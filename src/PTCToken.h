//
//  PTCToken.h
//  protc
//
//  Created by Nelson LeDuc on 12/7/14.
//  Copyright (c) 2014 owensd.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTCTokenType.h"

@class PTCFilePosition;

@interface PTCToken : NSObject

@property (nonatomic, assign) PTCTokenType type;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) PTCFilePosition *position;

- (instancetype)initWithType:(PTCTokenType)type text:(NSString *)text positon:(PTCFilePosition *)position;

@end
