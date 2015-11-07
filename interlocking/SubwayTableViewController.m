//
//  ViewController.m
//  interlocking
//
//  Created by Ian Meyer on 11/2/15.
//  Copyright © 2015 Ian Meyer. All rights reserved.
//

#import "SubwayTableViewController.h"
#import "TransitHandler.h"

@interface SubwayTableViewController ()

@property (nonatomic, strong) NSArray *rows;

- (void)refreshControlActivated;

@end

@implementation SubwayTableViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.statusItem.title = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 67.0f;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshControlActivated) forControlEvents:UIControlEventValueChanged];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self refreshData];
}

- (void)refreshControlActivated {
    [self refreshData];
}

- (IBAction)refreshData {
    self.statusItem.title = @"Updating...";

    [[TransitHandler defaultHandler] updateDataWithCompletion:^(NSArray<SubwayLine *> *subwayLines, NSError *error) {
        
        [self.refreshControl endRefreshing];
        
        if ( error ) {
            self.statusItem.title = [NSString stringWithFormat:@"Error: %@", error.localizedDescription];
        } else {
            self.statusItem.title = [NSString stringWithFormat:@"Updated: %@", [[NSDateFormatter transitTimestampFormatter] stringFromDate:[[TransitHandler defaultHandler] lastUpdated]]];
            self.rows = subwayLines;
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.rows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *rtnCell = [tableView dequeueReusableCellWithIdentifier:@"subwayCell" forIndexPath:indexPath];
    SubwayLine *tmpLine = self.rows[indexPath.row];
    if ( [rtnCell respondsToSelector:@selector(setSubwayLine:)] ) {
        [(SubwayTableViewCell *)rtnCell setSubwayLine:tmpLine];
    }
    return rtnCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end


@implementation SubwayTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    for ( UILabel *tmpTrainLabel in @[self.firstTrainLabel, self.secondTrainLabel, self.thirdTrainLabel, self.fourthTrainLabel] ) {
        tmpTrainLabel.layer.cornerRadius = CGRectGetWidth(tmpTrainLabel.frame)/2.0f;
        tmpTrainLabel.clipsToBounds = YES;
    }
}

- (void)setSubwayLine:(SubwayLine *)subwayLine {
    _subwayLine = subwayLine;

    // clear the labels to get ready
    self.firstTrainLabel.text = nil;
    self.secondTrainLabel.text = nil;
    self.thirdTrainLabel.text = nil;
    self.fourthTrainLabel.text = nil;
    self.statusLabel.text = @"--";

    // status
    self.statusLabel.text = subwayLine.status;

    // and trains
    NSArray *tmpTrainLabels = @[self.firstTrainLabel, self.secondTrainLabel, self.thirdTrainLabel, self.fourthTrainLabel];

    if ( [subwayLine.name isEqualToString:@"SIR"] ) {
        self.firstTrainLabel.train = @"SIR";
    }
    else {
        // split up name into characters
        NSArray *tmpTrains = @[];
        for ( int i=0; i<subwayLine.name.length; i++ ) {
            tmpTrains = [tmpTrains arrayByAddingObject:[subwayLine.name substringWithRange:NSMakeRange(i, 1)]];
        }
        
        // update labels
        for ( NSString *tmpTrain in tmpTrains ) {
            SubwayLabel *tmpTrainLabel = [tmpTrainLabels objectAtIndex:[tmpTrains indexOfObject:tmpTrain]];
            tmpTrainLabel.train = tmpTrain;
        }
    }

    // make sure empty labels are hidden
    for ( UILabel *tmpTrainLabel in tmpTrainLabels ) {
        [tmpTrainLabel setHidden:tmpTrainLabel.text==nil];
    }
}

@end
