//
//  PTCAnalyzer.h
//  protc
//
//  Created by Nelson LeDuc on 12/6/14.
//  Copyright (c) 2014 owensd.io. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTCAnalyzer : NSObject

@property (nonatomic, strong) NSArray *errors;

- (instancetype)initWithPath:(NSString *)path;
- (NSArray *)analyze;

@end
