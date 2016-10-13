//
//  ServiceAlertViewController.h
//  interlocking
//
//  Created by Ian Meyer on 11/9/15.
//  Copyright © 2015 Ian Meyer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServiceAlertViewController : UITableViewController

@end

@interface ServiceAlertTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *serviceAlertLabel;

@end
