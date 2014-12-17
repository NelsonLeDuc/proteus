//
//  PTCToken.m
//  protc
//
//  Created by Nelson LeDuc on 12/7/14.
//  Copyright (c) 2014 owensd.io. All rights reserved.
//

#import "PTCToken.h"

@implementation PTCToken

- (instancetype)initWithType:(PTCTokenType)type text:(NSString *)text positon:(PTCFilePosition *)position
{
    self = [super init];
    if (self)
    {
        _type = type;
        _text = text;
        _position = position;
    }
    
    return self;
}

@end
