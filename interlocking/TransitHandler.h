//
//  TransitHandler.h
//  interlocking
//
//  Created by Ian Meyer on 11/2/15.
//  Copyright © 2015 Ian Meyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransitObjects.h"

@interface TransitHandler : NSObject

@property (readonly, getter=isUpdating) BOOL updating;
@property (readonly, copy) NSDate *lastUpdated;

@property (readonly) NSArray<SubwayLine*> *subwayStatus;

+ (TransitHandler *)defaultHandler;

- (void)updateDataWithCompletion:(void (^)(NSArray<SubwayLine*> *subwayStatus, NSError *error))completionBlock;

@end

@interface NSDateFormatter (TransitHandler)

+ (NSDateFormatter *)transitTimestampFormatter;

@end
