//
//  PTScanner.m
//  Proteus
//
//  Created by David Owens II on 10/8/14.
//  Copyright (c) 2014 owensd.io. All rights reserved.
//


#import "PTParser.h"
#import "PTScanner.h"
#import "keywords.h"

// BASIC TOKEN STRUCTURE
//
// identifier ::=  (letter|"_") (letter | digit | "_")* ("'")*
// letter     ::=  lowercase | uppercase
// lowercase  ::=  "a"..."z" | unicode_character
// uppercase  ::=  "A"..."Z" | unicode_upper_character
// digit      ::=  "0"..."9"


@implementation PTToken
@end

@interface PTScanner ()
@property (retain) NSString *content;
@end


@implementation PTScanner
{
    NSUInteger _numberOfLines;
    NSUInteger _lineOffset;
    NSUInteger _offset;
}

+ (NSArray *)keywords
{
    static NSArray *keywords = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        keywords = PROTEUS_KEYWORDS;
    });

    return keywords;
}

- (instancetype)initWithString:(NSString *)content
{
    if (self = [super init]) {
        self.content = content;

        _numberOfLines = 0;
        _lineOffset = 0;
        _offset = 0;
    }

    return self;
}

- (PTToken *)nextToken
{
    PTToken *token = nil;

    unichar c = [self peek];

    BOOL startOfLine = [[NSCharacterSet newlineCharacterSet] characterIsMember:[self peekBy:-1]] || [self peekBy:-1] == '\0';

    if (startOfLine == NO && (c == ' ' || c == '\t')) {
        [self readIndentWithChar:c];
    }

    if (c == ' ' || c == '\t') {
        token = [[PTToken alloc] init];
        token.type = PTTokenTypeIndent;
        token.text = [self readIndentWithChar:c];
    }
    else if (c == '\n') {
        token = [[PTToken alloc] init];
        token.type = PTTokenTypeNewLine;
    }
    else if ([[NSCharacterSet letterCharacterSet] characterIsMember:c]) {
        token = [self tokenForIdentifier];
    }

    return token;
}

- (BOOL)eof
{
    return _offset >= _content.length;
}

- (unichar)next
{
    _offset++;
    if (_offset < _content.length) {
        return [_content characterAtIndex:_offset];
    }
    return '\0';
}

- (unichar)nextBy:(NSUInteger)count
{
    for (NSUInteger idx = 0; idx < count; idx++) { [self next]; }
    return [self peek];
}

- (unichar)prev
{
    if (_offset == 0) { return '\0'; }

    _offset--;
    return [_content characterAtIndex:_offset];
}

- (unichar)peek
{
    if ([self eof]) { return '\0'; }
    return [_content characterAtIndex:_offset];
}

- (unichar)peekBy:(NSInteger)offset
{
    if (_offset + offset < _content.length) {
        return [_content characterAtIndex:_offset + offset];
    }
    return '\0';
}

#pragma mark - Helper read methods

- (PTToken *)tokenForIdentifier
{
    PTToken *token = [[PTToken alloc] init];

    NSMutableString *value = [[NSMutableString alloc] init];
    unichar c = [self peek];
    while ([[NSCharacterSet letterCharacterSet] characterIsMember:c]) {
        [value appendFormat:@"%c", c];
        c = [self next];
    }

    if ([[PTScanner keywords] containsObject:value]) {
        token.type = PTTokenTypeKeyword;
    }
    else {
        token.type = PTTokenTypeIdentifier;
    }

    token.text = value;

    return token;
}

- (NSString *)readIndentWithChar:(unichar)c
{
    NSMutableString *value = [[NSMutableString alloc] init];
    while ([self peek] == c) {
        [value appendFormat:@"%c", c];
        [self next];
    }

    return value;
}

//- (void)skipWhitespace
//{
//    while (true) {
//        if ([self eof]) { break; }
//
//        unichar c = [self peek];
//        if (![[NSCharacterSet whitespaceCharacterSet] characterIsMember:c]) { break; }
//
//        [self updatePositionInfo:c];
//    }
//}
//
//- (void)skipWhitespaceAndNewlines
//{
//    while (true) {
//        if ([self eof]) { break; }
//
//        unichar c = [self peek];
//        if (![[NSCharacterSet whitespaceAndNewlineCharacterSet] characterIsMember:c]) { break; }
//
//        [self updatePositionInfo:c];
//    }
//}
//
//- (void)updatePositionInfo:(unichar)c
//{
//    switch (c) {
//        case '\n':
//            _spaceCount = 0;
//            _tabCount = 0;
//            _lineCount++;
//            break;
//
//        case '\t':
//            _tabCount++;
//            break;
//
//        case ' ':
//            _spaceCount++;
//            break;
//
//        default:
//            return;
//    }
//
//    _location++;
//}

//
//#pragma keyword parsing
//
//#define PARSE_ENUM_ERROR()\
//    if (error != NULL) {\
//        *error = [NSError errorWithDomain:PTParserErrorDomain code:0 userInfo:nil];\
//    }\
//    return nil;
//
//- (PTParseTreeNode *)parseEnum:(NSError *__autoreleasing *)error
//{
//    [self skipWhitespace];
//
//    _scanner.scanLocation = _location;
//
//    NSString *identifier = nil;
//    if ([_scanner scanCharactersFromSet:[NSCharacterSet letterCharacterSet] intoString:&identifier] == NO) {
//        PARSE_ENUM_ERROR();
//    }
//
//    _location += [identifier length];
//
//    [self skipWhitespace];
//
//    if ([self next] != ':') {
//        PARSE_ENUM_ERROR();
//    }
//
//    PTParseTreeNode *node = [[PTParseTreeNode alloc] init];
//
//    [self skipWhitespace];
//    if ([self peek] == '\n') {
//        [self next];
//        [node.children addObjectsFromArray:[self parseEnumOptionsMultiLine:error]];
//    }
//    else {
//        [node.children addObjectsFromArray:[self parseEnumOptions:error]];
//    }
//
//    return node;
//}
//
//- (NSArray *)parseEnumOptions:(NSError *__autoreleasing *)error
//{
//    NSMutableArray *options = [[NSMutableArray alloc] init];
//
//    while ([self peek] != '\n' && [self eof] == NO) {
//        [self skipWhitespace];
//
//        _scanner.scanLocation = _location;
//
//        NSString *identifier = nil;
//        if ([_scanner scanCharactersFromSet:[NSCharacterSet letterCharacterSet] intoString:&identifier] == NO) {
//            PARSE_ENUM_ERROR();
//        }
//
//        _location += [identifier length];
//
//        PTParseTreeNode *node = [[PTParseTreeNode alloc] init];
//        [options addObject:node];
//
//        [self skipWhitespace];
//        if ([self next] != '|') { break; }
//    }
//
//    return options;
//}
//
//- (NSArray *)parseEnumOptionsMultiLine:(NSError *__autoreleasing *)error
//{
//    NSMutableArray *options = [[NSMutableArray alloc] init];
//
//    NSUInteger leftOutdent = _location;
//    [self skipWhitespace];
//    leftOutdent = _location - leftOutdent;
//
//    while (![self eof]) {
//        if ([self next] != '|') { break; }
//
//        [self skipWhitespace];
//
//        _scanner.scanLocation = _location;
//
//        NSString *identifier = nil;
//        if ([_scanner scanCharactersFromSet:[NSCharacterSet letterCharacterSet] intoString:&identifier] == NO) {
//            PARSE_ENUM_ERROR();
//        }
//
//        _location += [identifier length];
//
//        PTParseTreeNode *node = [[PTParseTreeNode alloc] init];
//        [options addObject:node];
//
//        [self skipWhitespace];
//
//        if ([self next] != '\n') { break; }
//
//        NSUInteger outdent = _location;
//        [self skipWhitespace];
//        outdent = _location - outdent;
//        if (outdent != leftOutdent) { break; }
//    }
//    
//    return options;
//}

@end
