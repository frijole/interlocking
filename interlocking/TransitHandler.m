//
//  TransitHandler.m
//  interlocking
//
//  Created by Ian Meyer on 11/2/15.
//  Copyright © 2015 Ian Meyer. All rights reserved.
//

#import "TransitHandler.h"

static TransitHandler *_defaultHandler = nil;

NSString *const kXMLReaderTextNodeKey = @"textInProgress";

@interface TransitHandler () <NSXMLParserDelegate>

@property (nonatomic, strong, readwrite) NSDictionary *transitData;

//Parser internals
@property (nonatomic, strong) NSMutableDictionary *rootDictionary;
@property (nonatomic, strong) NSMutableArray *elementStack;
@property (nonatomic, strong) NSMutableDictionary *elementInProgress;
@property (nonatomic, strong) NSMutableString *textInProgress;

@end

@implementation TransitHandler

+ (TransitHandler *)defaultHandler {
    if ( !_defaultHandler ) {
        _defaultHandler = [TransitHandler new];
    }
    return _defaultHandler;
}

- (void)updateDataWithCompletion:(void (^)(NSDictionary *, NSError *))completionBlock {
    NSURL *dataURL = [NSURL URLWithString:@"http://web.mta.info/status/serviceStatus.txt"];
    NSURLSessionTask *dataTask = [[NSURLSession sharedSession]
                                  dataTaskWithURL:dataURL
                                  completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                      if ( error ) {
                                          NSLog(@"error getting train status: %@", error);
                                          return;
                                      }
                                      NSString *tmpDataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                      NSLog(@"fetched train status: %@ bytes", @(tmpDataString.length));
                                      
                                      NSXMLParser *tmpParser = [[NSXMLParser alloc] initWithData:[tmpDataString dataUsingEncoding:NSUTF8StringEncoding]];
                                      [tmpParser setDelegate:self];
                                      BOOL tmpParsed = [tmpParser parse];
                                      
                                      if ( tmpParsed ) {
                                          if ( completionBlock ) {
                                              dispatch_async(dispatch_get_main_queue(), ^{ completionBlock(self.transitData, nil); });
                                          }
                                      } else {
                                          if ( completionBlock ) {
                                              NSError *tmpError = nil; // wat
                                              dispatch_async(dispatch_get_main_queue(), ^{ completionBlock(nil, tmpError); });
                                          }
                                      }
                                  }];
    [dataTask resume];
}

#pragma - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSLog(@"parseErrorOccurred: %@", parseError);
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    NSLog(@"parserDidStartDocument: %@", parser);

    self.rootDictionary = [NSMutableDictionary dictionary];
    self.elementStack = [NSMutableArray arrayWithObject:self.rootDictionary];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    // starting a new element, create a dictionary for its values
    self.elementInProgress = [NSMutableDictionary dictionary];
    // and add it to the stack
    [self.elementStack addObject:self.elementInProgress];
    
    // and (re)set the text builder
    self.textInProgress = [NSMutableString string];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    [self.textInProgress appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    // update the value of the current element
    if ( self.textInProgress ) {
        [self.elementInProgress setObject:self.textInProgress forKey:elementName];
    }
    
    NSMutableDictionary *tmpFinishedElement = self.elementInProgress;
    
    // pop it from the in-progress stack
    [self.elementStack removeObject:self.elementInProgress];

    // and pick up the last one
    self.elementInProgress = self.elementStack.lastObject;

    // and finally, put the finished element in its parent
    NSObject *existingElement = [self.elementInProgress objectForKey:elementName];
    if ( [existingElement isKindOfClass:[NSArray class]] ) {
        // add to existing collection
        NSArray *tmpArray = [(NSArray *)existingElement arrayByAddingObject:tmpFinishedElement];
        [self.elementInProgress setObject:tmpArray forKey:elementName];
    } else if ( [existingElement isKindOfClass:[NSDictionary class]] ) {
        // multiple entries, array it with the newly finished one
        NSArray *tmpArray = @[existingElement, tmpFinishedElement];
        [self.elementInProgress setObject:tmpArray forKey:elementName];
    } else if ( tmpFinishedElement.count == 1 && self.textInProgress ) {
        // only one value, and text. don't put the whole dictionary in the parent
        [self.elementInProgress addEntriesFromDictionary:tmpFinishedElement];
    } else {
        // multiple keys in this element, stick the whole thing in there
        [self.elementInProgress setObject:tmpFinishedElement forKey:elementName];
    }
    
    // don't forget to reset the string!
    self.textInProgress = nil;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    NSLog(@"parserDidEndDocument: %@", parser);
    
    self.transitData = self.rootDictionary;
    self.rootDictionary = nil;
}

@end
