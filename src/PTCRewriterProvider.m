//
//  PTCRewriterProvider.m
//  protc
//
//  Created by Nelson LeDuc on 12/16/14.
//  Copyright (c) 2014 owensd.io. All rights reserved.
//

#import "PTCRewriterProvider.h"
#import "PTCEnumRewriter.h"

@implementation PTCRewriterProvider

+ (Class<PTCRewriter>)rewriterForConstructTypeName:(NSString *)typeName
{
    return [[self rewriterDictionary] objectForKey:typeName];
}

+ (NSDictionary *)rewriterDictionary
{
    NSDictionary *rewriterDict = @{
                                   @"enum" : [PTCEnumRewriter class]
                                   };
    
    return rewriterDict;
}

@end
