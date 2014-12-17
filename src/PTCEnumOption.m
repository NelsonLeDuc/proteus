//
//  PTCEnumOption.m
//  protc
//
//  Created by Nelson LeDuc on 12/7/14.
//  Copyright (c) 2014 owensd.io. All rights reserved.
//

#import "PTCEnumOption.h"

@implementation PTCEnumOption

- (instancetype)initWithName:(NSString *)name
{
    self = [super init];
    if (self)
    {
        _name = name;
    }
    
    return self;
}

@end