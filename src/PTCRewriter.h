//
//  PTCRewriter.h
//  protc
//
//  Created by Nelson LeDuc on 12/16/14.
//  Copyright (c) 2014 owensd.io. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PTCConstruct;

@protocol PTCRewriter <NSObject>

+ (NSDictionary *)writeObjCFromConstruct:(id<PTCConstruct>)construct;

@end
