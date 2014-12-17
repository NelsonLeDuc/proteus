//
//  PTCLexer.m
//  protc
//
//  Created by Nelson LeDuc on 12/7/14.
//  Copyright (c) 2014 owensd.io. All rights reserved.
//

#import "PTCLexer.h"
#import "PTCToken.h"
#import "PTCFilePosition.h"

@interface PTCLexer ()

@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) PTCToken *previousToken;
@property (nonatomic, strong) NSString *previousChar;

@property (nonatomic, assign) UInt64 lineNumber;
@property (nonatomic, assign) UInt64 numberOfSpaces;
@property (nonatomic, assign) UInt64 numberOfTabs;

@end

@implementation PTCLexer

+ (NSArray *)keywords
{
    return @[@"as", @"catch", @"class", @"def", @"elseif", @"else", @"enum", @"for", @"finally", @"func", @"id", @"if", @"in", @"let", @"import", @"interface", @"is", @"namespace", @"return", @"try", @"typedef", @"unsafe", @"var"];
}

- (instancetype)initWithContent:(NSString *)content
{
    self = [super init];
    if (self)
    {
        _content = content;
    }
    
    return self;
}

- (PTCToken *)generateNext
{
    if (self.previousToken.type == PTCTokenTypeEndOfFile)
    {
        return nil;
    }
    
    return [self nextToken];
}

- (PTCToken *)nextToken
{
    PTCToken *(^tokenGenerator)() = ^PTCToken *() {
        if (!self.previousChar)
        {
            return [[PTCToken alloc] initWithType:PTCTokenTypeEndOfFile text:@"" positon:[self filePosition]];
        }
        
        NSMutableString *value = [NSMutableString string];
        
        if ([self.previousChar isEqualToString:@"\n"])
        {
            [self next];
            while ( [self.previousChar isEqualToString:@" "] || [self.previousChar isEqualToString:@"\t"])
            {
                [value appendString:self.previousChar];
                [self next];
            }
            
            if (value.length != 0)
                return [[PTCToken alloc] initWithType:PTCTokenTypeIndent text:value positon:[self filePosition]];
        }
        
        if ([self.previousChar isEqualToString:@" "] || [self.previousChar isEqualToString:@"\t"])
        {
            while ( [self.previousChar isEqualToString:@" "] || [self.previousChar isEqualToString:@"\t"])
            {
                [self next];
            }
        }
        
        if ([self isLetter:self.previousChar])
        {
            while ([self isLetter:self.previousChar])
            {
                [value appendString:self.previousChar];
                [self next];
            }
            
            PTCTokenType type = [[[self class] keywords] containsObject:value] ? PTCTokenTypeKeyword : PTCTokenTypeIdentifier;
            return [[PTCToken alloc] initWithType:type text:value positon:[self filePosition]];
        }
        
        //TODO: support look-ahead when actually needed
        
        if ([self.previousChar isEqualToString:@":"])
        {
            [self next];
            return [[PTCToken alloc] initWithType:PTCTokenTypeError text:@":" positon:[self filePosition]];
        }
        
        if ([self.previousChar isEqualToString:@"|"])
        {
            [self next];
            return [[PTCToken alloc] initWithType:PTCTokenTypePipe text:@"|" positon:[self filePosition]];
        }
        
        return [[PTCToken alloc] initWithType:PTCTokenTypeError text:@"<invalid state>" positon:[self filePosition]];
    };
    
    self.previousToken = tokenGenerator();
    
    return self.previousToken ?: [[PTCToken alloc] initWithType:PTCTokenTypeError text:@"<invalid state>" positon:[self filePosition]];
}

- (void)next
{
    self.index++;
    self.previousChar = [self.content substringWithRange:NSMakeRange(self.index, 0)];
    
    if ([self.previousChar isEqualToString:@"\n"])
    {
        self.lineNumber++;
        self.numberOfSpaces = 0;
        self.numberOfTabs = 0;
    }
    else if ([self.previousChar isEqualToString:@"\t"])
    {
        self.numberOfTabs++;
    }
    else if ([self.previousChar isEqualToString:@" "])
    {
        self.numberOfSpaces++;
    }
}

- (PTCFilePosition *)filePosition
{
    return [[PTCFilePosition alloc] initWithLineNumber:self.lineNumber numberOfTaps:self.numberOfTabs numberOfSpaces:self.numberOfSpaces];
}

- (BOOL)isLetter:(NSString *)c
{
    return [[NSCharacterSet letterCharacterSet] characterIsMember:[c characterAtIndex:0]];
}

@end
