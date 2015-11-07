//
//  ViewController.h
//  interlocking
//
//  Created by Ian Meyer on 11/2/15.
//  Copyright © 2015 Ian Meyer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransitObjects.h"
#import "SubwayLabel.h"

@interface SubwayTableViewController : UITableViewController

@property (nonatomic, weak) IBOutlet UIBarButtonItem *statusItem;

- (IBAction)refreshData;

@end


@interface SubwayTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet SubwayLabel *firstTrainLabel;
@property (nonatomic, weak) IBOutlet SubwayLabel *secondTrainLabel;
@property (nonatomic, weak) IBOutlet SubwayLabel *thirdTrainLabel;
@property (nonatomic, weak) IBOutlet SubwayLabel *fourthTrainLabel;
@property (nonatomic, weak) IBOutlet UILabel *statusLabel;

@property (nonatomic, strong) SubwayLine *subwayLine;

@end
