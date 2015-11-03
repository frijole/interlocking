//
//  TransitHandler.h
//  interlocking
//
//  Created by Ian Meyer on 11/2/15.
//  Copyright © 2015 Ian Meyer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransitHandler : NSObject

@property (nonatomic, readonly) NSDictionary *transitData;

+ (TransitHandler *)defaultHandler;

- (void)updateDataWithCompletion:(void (^)(NSDictionary *transitData, NSError *error))completionBlock;

@end
