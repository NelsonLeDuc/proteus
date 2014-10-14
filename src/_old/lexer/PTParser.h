//
//  PTParser.h
//  Proteus
//
//  Created by David Owens II on 10/8/14.
//  Copyright (c) 2014 owensd.io. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const PTParserErrorDomain;

@interface PTParserResults : NSObject
@property (copy) NSString *implementation;
@property (copy) NSString *header;
@end

@interface PTParser : NSObject

+ (PTParserResults *)parse:(NSStream *)content error:(NSError *__autoreleasing *)error;

@end
