//
//  PTParser.m
//  Proteus
//
//  Created by David Owens II on 10/8/14.
//  Copyright (c) 2014 owensd.io. All rights reserved.
//

#import "PTParser.h"
#import "PTScanner.h"

NSString * const PTParserErrorDomain = @"io.owensd.proteus.parser.error";

@implementation PTParserResults
@end

@implementation PTParser

+ (PTParserResults *)parse:(NSString *)content error:(NSError **)error
{
    if ([content length] == 0) {
        if (error != nil) {
            *error = [NSError errorWithDomain:PTParserErrorDomain code:0 userInfo:nil];
        }
        return nil;
    }

    return nil;

//    PTScanner *scanner = [[PTScanner alloc] initWithString:content];
//    PTParserResults *results = [[PTParserResults alloc] init];
//
//    return results;
}

@end
