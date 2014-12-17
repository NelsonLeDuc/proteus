//
//  PTCAnalyzer.m
//  protc
//
//  Created by Nelson LeDuc on 12/6/14.
//  Copyright (c) 2014 owensd.io. All rights reserved.
//

#import "PTCAnalyzer.h"

//typedef id<PTCConstruct> (^PTCConverter)(PTCToken *token, PTCLexer *lexer);

@interface PTCAnalyzer()

@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) NSDictionary *keywords;
@property (nonatomic, strong) NSMutableArray *errorMessages;

@end

@implementation PTCAnalyzer

- (instancetype)initWithPath:(NSString *)path
{
    self = [super init];
    if (self)
    {
        _path = path;
        _errorMessages = @[];
        _keywords = @{};//@{ @"enum" : };
    }
    
    return self;
}

- (NSArray *)analyze
{
    NSString *code = [NSString stringWithContentsOfFile:self.path encoding:NSUTF8StringEncoding error:nil];
//    if (code)
//    {
//        PTCLexer *lexer = [[PTCLexer alloc] initWithContent:code];
//        return [self parse:lexer];
//    }
//    
//    PTCFilePosition *position = [[PTCFilePosition alloc] initWithLineNumber:0 numberOfTabs:0 numberOfSpaces:0];
//    [self storeErrorWithMessage:@"file not found." path:self.path positon:position];
    return @[];
}


//- (void)storeErrorWithMessage:(NSString *)message path:(NSString *)path positon:(PTCFilePosition *)position
//{
//    NSString *output = [NSString stringWithFormat:@"%@:%@: error: %@", path, @(position.lineNumber), message];
//    [self.errorMessages addObject:output];
//}

@end
