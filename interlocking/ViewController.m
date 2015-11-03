//
//  ViewController.m
//  interlocking
//
//  Created by Ian Meyer on 11/2/15.
//  Copyright © 2015 Ian Meyer. All rights reserved.
//

#import "ViewController.h"
#import "TransitHandler.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)updateButtonPressed:(id)sender {
    [[TransitHandler defaultHandler] updateDataWithCompletion:^(NSDictionary *transitData, NSError *error) {
        if ( error ) {
            self.statusLabel.text = [NSString stringWithFormat:@"Error: %@", error.localizedDescription];
        } else {
            self.statusLabel.text = [NSString stringWithFormat:@"Transit Data Updated\n%@", [transitData valueForKeyPath:@"service.timestamp"]];
        }
    }];
}

@end
