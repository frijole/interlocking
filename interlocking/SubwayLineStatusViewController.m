//
//  ViewController.m
//  interlocking
//
//  Created by Ian Meyer on 11/2/15.
//  Copyright © 2015 Ian Meyer. All rights reserved.
//

#import "SubwayLineStatusViewController.h"
#import <InterlockingKit/TransitHandler.h>

@interface SubwayLineStatusViewController ()

@property (nonatomic, strong) NSArray *rows;
@property (nonatomic, strong) NSMutableArray *expandedRows;

- (void)refreshControlActivated;

@end

@implementation SubwayLineStatusViewController

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

- (NSMutableArray *)expandedRows {
    if ( !_expandedRows ) {
        _expandedRows = [NSMutableArray array];
    }
    return _expandedRows;
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

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *rtnActionArray = @[];
    
    UITableViewRowAction *watchAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                                           title:@"Add to Favorites"
                                                                         handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                             NSLog(@"add to favorites: %@", indexPath);
                                                                         }];
    rtnActionArray = [rtnActionArray arrayByAddingObject:watchAction];
    
    return rtnActionArray;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *rtnCell = [tableView dequeueReusableCellWithIdentifier:@"subwayCell" forIndexPath:indexPath];
    SubwayLine *tmpLine = self.rows[indexPath.row];
    if ( [rtnCell respondsToSelector:@selector(setSubwayLine:)] ) {
        [(SubwayTableViewCell *)rtnCell setSubwayLine:tmpLine];
    
        if ( [self.expandedRows indexOfObject:indexPath] == NSNotFound ) {
            [[(SubwayTableViewCell *)rtnCell serviceLabel] setText:nil];
        }
    }
    
    return rtnCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ( [self.expandedRows indexOfObject:indexPath] == NSNotFound ) {
        // not expanded, add to array
        [self.expandedRows addObject:indexPath];
    } else {
        // expanded already, collapse
        [self.expandedRows removeObject:indexPath];
    }
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
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

    // details
    self.serviceLabel.text = subwayLine.serviceStatus;
    
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
