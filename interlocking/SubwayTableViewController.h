//
//  ViewController.h
//  interlocking
//
//  Created by Ian Meyer on 11/2/15.
//  Copyright © 2015 Ian Meyer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubwayTableViewController : UITableViewController

@property (nonatomic, weak) IBOutlet UIBarButtonItem *statusItem;

- (IBAction)refreshData;

@end

