//
//  TransitObjects.h
//  interlocking
//
//  Created by Ian Meyer on 11/3/15.
//  Copyright © 2015 Ian Meyer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransitObject : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (void)updateWithDictionary:(NSDictionary *)dictionary;

@end

// Handy interface for parsed subway lines
@interface SubwayLine : TransitObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSAttributedString *serviceInformation;
@property (nonatomic, copy) NSString *serviceInformationUpdatedAt; // TODO: NSDate

@end

// TODO: Train-specific statuses

// LIRR

// MetroNorth

// Bus

// B&T
