//
//  PTCFilePosition.m
//  protc
//
//  Created by Nelson LeDuc on 12/7/14.
//  Copyright (c) 2014 owensd.io. All rights reserved.
//

#import "PTCFilePosition.h"

@implementation PTCFilePosition

- (instancetype)initWithLineNumber:(UInt64)lineNum numberOfTaps:(UInt64)numTaps numberOfSpaces:(UInt64)numSpaces
{
    self = [super init];
    if (self)
    {
        _lineNumber = lineNum;
        _numberOfTabs = numTaps;
        _numberOfSpaces = numSpaces;
    }
    
    return self;
}

- (UInt64)column
{
    return [self columnWithNumberOfSpacesPerTab:4];
}

- (UInt64)columnWithNumberOfSpacesPerTab:(UInt64)number
{
    return number * self.numberOfTabs + self.numberOfSpaces;
}

@end
