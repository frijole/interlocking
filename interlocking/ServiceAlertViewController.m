//
//  ServiceAlertViewController.m
//  interlocking
//
//  Created by Ian Meyer on 11/9/15.
//  Copyright © 2015 Ian Meyer. All rights reserved.
//

#import "ServiceAlertViewController.h"
#import <InterlockingKit/TransitHandler.h>

@interface ServiceAlertViewController ()

@property (nonatomic, strong) NSArray *tableSections;

@end

@implementation ServiceAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureTableView];
}

- (void)configureTableView {
    NSArray *tmpServiceAlerts = @[];
    NSArray *tmpSubwayLines = [[TransitHandler defaultHandler] subwayLineStatus];
    for ( SubwayLine *tmpLine in tmpSubwayLines ) {
        // wat
        if ( tmpLine.serviceStatus && tmpLine.serviceStatus.length > 0 ) {
            tmpServiceAlerts = [tmpServiceAlerts arrayByAddingObject:tmpLine.serviceStatus];
        }
    }
    [self setTableSections:tmpServiceAlerts];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.tableSections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *rtnCell = [tableView dequeueReusableCellWithIdentifier:@"serviceAlertCell" forIndexPath:indexPath];
    if ( [rtnCell respondsToSelector:@selector(serviceAlertLabel)] ) {
        [[(ServiceAlertTableViewCell *)rtnCell serviceAlertLabel] setText:self.tableSections[indexPath.section]];
    }
    return rtnCell;
}

@end


@implementation ServiceAlertTableViewCell

@end
