//
//  PTCFilePosition.h
//  protc
//
//  Created by Nelson LeDuc on 12/7/14.
//  Copyright (c) 2014 owensd.io. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTCFilePosition : NSObject

@property (nonatomic, assign) UInt64 lineNumber;
@property (nonatomic, assign) UInt64 numberOfTabs;
@property (nonatomic, assign) UInt64 numberOfSpaces;

- (instancetype)initWithLineNumber:(UInt64)lineNum numberOfTaps:(UInt64)numTaps numberOfSpaces:(UInt64)numSpaces;

- (UInt64)column;
- (UInt64)columnWithNumberOfSpacesPerTab:(UInt64)number;

@end
