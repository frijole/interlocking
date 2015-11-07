//
//  SubwayLabel.m
//  interlocking
//
//  Created by Ian Meyer on 11/7/15.
//  Copyright © 2015 Ian Meyer. All rights reserved.
//

#import "SubwayLabel.h"
#import "UIColor+MTA.h"

@implementation SubwayLabel

- (void)setTrain:(NSString *)train {
    _train = train;
    
    self.text = train;
    
    UIColor *tmpBackgroundColor = [UIColor subwayACEBlueColor];
    if ( [@[@"A", @"C", @"E"] indexOfObject:train] != NSNotFound ) {
        tmpBackgroundColor = [UIColor subwayACEBlueColor];
    } else if ( [@[@"B", @"D", @"F", @"M"] indexOfObject:train] != NSNotFound ) {
        tmpBackgroundColor = [UIColor subwayBDFMOrangeColor];
    } else if ( [@[@"1", @"2", @"3"] indexOfObject:train] != NSNotFound ) {
        tmpBackgroundColor = [UIColor subway123RedColor];
    } else if ( [@[@"4", @"5", @"6"] indexOfObject:train] != NSNotFound ) {
        tmpBackgroundColor = [UIColor subway456GreenColor];
    } else if ( [@[@"N", @"Q", @"R"] indexOfObject:train] != NSNotFound ) {
        tmpBackgroundColor = [UIColor subwayNQRYellowColor];
    } else if ( [@[@"J", @"Z"] indexOfObject:train] != NSNotFound ) {
        tmpBackgroundColor = [UIColor subwayJZBrownColor];
    } else if ( [@"G" isEqualToString:train] ) {
        tmpBackgroundColor = [UIColor subwayGGreenColor];
    } else if ( [@"L" isEqualToString:train] ) {
        tmpBackgroundColor = [UIColor subwayLGreyColor];
    } else if ( [@"S" isEqualToString:train] ) {
        tmpBackgroundColor = [UIColor subwaySGreyColor];
    } else if ( [@"7" isEqualToString:train] ) {
        tmpBackgroundColor = [UIColor subway7PurpleColor];
    }
    self.backgroundColor = tmpBackgroundColor;
}

@end
