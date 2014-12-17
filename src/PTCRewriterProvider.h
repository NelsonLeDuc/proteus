//
//  PTCRewriterProvider.h
//  protc
//
//  Created by Nelson LeDuc on 12/16/14.
//  Copyright (c) 2014 owensd.io. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PTCRewriter;

@interface PTCRewriterProvider : NSObject

+ (Class<PTCRewriter>)rewriterForConstructTypeName:(NSString *)typeName;

@end