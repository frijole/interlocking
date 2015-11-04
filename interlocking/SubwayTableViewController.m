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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshControlActivated) forControlEvents:UIControlEventValueChanged];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self refreshData];
}

- (void)refreshControlActivated {
    self.statusItem.title = @"Updating...";
    [self refreshData];
}

- (IBAction)refreshData {
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
    rtnCell.textLabel.text = tmpLine.name;
    rtnCell.detailTextLabel.text = tmpLine.status;
    return rtnCell;
}

@end
