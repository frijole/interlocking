//
//  TransitObjects.m
//  interlocking
//
//  Created by Ian Meyer on 11/3/15.
//  Copyright © 2015 Ian Meyer. All rights reserved.
//

#import "TransitObjects.h"

@interface TransitObject ()

@end

@implementation TransitObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if ( self = [super init] ) {
        [self updateWithDictionary:dictionary];
    }
    return self;
}

- (void)updateWithDictionary:(NSDictionary *)dictionary {
    // Override in subclasses
}

@end


@implementation SubwayLine

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p> \"%@\" Status: %@", NSStringFromClass(self.class), self, self.name, self.status];
}

- (void)updateWithDictionary:(NSDictionary *)dictionary {
    self.name = dictionary[@"name"];
    self.status = dictionary[@"status"];
    
    NSString *tmpServiceInformationHTML = dictionary[@"text"];
    
    if ( tmpServiceInformationHTML ) {
        //TODO: Parse into attributed string
        NSError *error = nil;
        NSMutableAttributedString *tmpAttributedStatus = [[NSMutableAttributedString alloc] initWithData:[tmpServiceInformationHTML dataUsingEncoding:NSUTF8StringEncoding]
                                                                                                 options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,
                                                                                                           NSCharacterEncodingDocumentAttribute:@(NSUTF8StringEncoding)}
                                                                                      documentAttributes:nil
                                                                                                   error:&error];
        self.serviceInformation = tmpAttributedStatus;
        
        NSString *tmpTimestamp = dictionary[@"Date"];
        tmpTimestamp = [tmpTimestamp stringByAppendingFormat:@"%@", dictionary[@"Time"]];
        // TODO: parse into NSDate
        self.serviceInformationUpdatedAt = tmpTimestamp;
    }
}

@end
