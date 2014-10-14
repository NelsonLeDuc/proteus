//
//  PTScanner.h
//  Proteus
//
//  Created by David Owens II on 10/8/14.
//  Copyright (c) 2014 owensd.io. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PTTokenType)
{
    PTTokenTypeError = -1,
    PTTokenTypeIdentifier,
    PTTokenTypeKeyword,
    PTTokenTypeIndent,
    PTTokenTypeNewLine,
    PTTokenTypeColon,
    PTTokenTypePipe,
    PTTokenTypeOperator
};

@interface PTToken : NSObject

@property (assign) NSInteger line;
@property (assign) NSInteger column;
@property (assign) NSInteger offset;

@property (copy) NSString *text;
@property (copy) NSDictionary *attributes;

@property (assign) PTTokenType type;

@end

@interface PTScanner : NSObject

- (instancetype)initWithString:(NSString *)content;

- (PTToken *)nextToken;

@end
