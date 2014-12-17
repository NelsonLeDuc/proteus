//
//  PTCEnum.h
//  protc
//
//  Created by Nelson LeDuc on 12/7/14.
//  Copyright (c) 2014 owensd.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTCConstruct.h"

@interface PTCEnum : NSObject <PTCConstruct>

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSArray *options;

@end
