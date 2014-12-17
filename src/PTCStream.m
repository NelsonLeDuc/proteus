//
//  PTCStream.m
//  protc
//
//  Created by Nelson LeDuc on 12/7/14.
//  Copyright (c) 2014 owensd.io. All rights reserved.
//

#import "PTCStream.h"

@interface PTCStream ()

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSString *contentString;
@property (nonatomic, assign) BOOL eof;

@end

@implementation PTCStream

- (instancetype)initWithContent:(NSString *)content
{
    self = [super init];
    if (self)
    {
        _index = 0;
        _contentString = content;
        _eof = NO;
//        _generator = [content generate];
    }
    
    return self;
}

- (NSString *)prevWithOffset:(NSInteger)offset
{
    if (self.index < offset)
    {
        return nil;
    }
    
    return [self.contentString substringWithRange:NSMakeRange(self.index - offset, 1)];
}

- (NSString *)nextWithOffset:(NSInteger)offset
{
    NSString *c = [self peekWithOffset:offset];
    self.index = MIN(self.index + offset, self.contentString.length);
    
    return c;
}

- (NSString *)peekWithOffset:(NSInteger)offset
{
    if (self.eof)
        return nil;
    
    if (self.index + offset < self.contentString.length)
    {
        return [self.contentString substringWithRange:NSMakeRange(self.index + offset, 1)];
    }
    
    NSString *character = nil;
    NSInteger remaining = self.contentString.length - self.index - offset;
    for (int i = 0; i < remaining; i++)
    {
#warning Figure this out
    }
    
    return character;
}

- (NSString *)curr
{
    if (self.eof)
        return nil;
    
    return [self.contentString substringWithRange:NSMakeRange(self.index, 1)];
}

@end
