//
//  PTCLexer.h
//  protc
//
//  Created by Nelson LeDuc on 12/7/14.
//  Copyright (c) 2014 owensd.io. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PTCToken;

@interface PTCLexer : NSObject

- (instancetype)initWithContent:(NSString *)content;

- (PTCToken *)generateNext;

@end
