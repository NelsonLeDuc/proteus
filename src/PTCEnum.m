//
//  PTCEnum.m
//  protc
//
//  Created by Nelson LeDuc on 12/7/14.
//  Copyright (c) 2014 owensd.io. All rights reserved.
//

#import "PTCEnum.h"

@implementation PTCEnum

- (instancetype)initWithName:(NSString *)name options:(NSArray *)options
{
    self = [super init];
    if (self)
    {
        _identifier = name;
        _options = options;
    }
    
    return self;
}

- (NSString *)typeName
{
    return @"enum";
}

@end