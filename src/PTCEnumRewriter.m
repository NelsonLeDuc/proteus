//
//  PTCEnumRewriter.m
//  protc
//
//  Created by Nelson LeDuc on 12/16/14.
//  Copyright (c) 2014 owensd.io. All rights reserved.
//

#import "PTCEnumRewriter.h"
#import "PTCConstruct.h"
#import "PTCEnum.h"
#import "PTCEnumOption.h"

static NSString * const TAB = @"    ";

@implementation PTCEnumRewriter

+ (NSDictionary *)writeObjCFromConstruct:(id<PTCConstruct>)construct
{
    if (![construct isKindOfClass:[PTCEnum class]])
    {
        return nil;
    }
    
    PTCEnum *enumConstruct = construct;
    return [self writeObjCFromEnum:enumConstruct];
}

+ (NSDictionary *)writeObjCFromEnum:(PTCEnum *)enumConstruct
{
    NSMutableArray *headerStrings = [@[
                               @"@interface ",
                               enumConstruct.identifier,
                               @" : NSObject\n\n"
                               ] mutableCopy];
    
    NSString *identifier = enumConstruct.identifier;
    NSMutableArray *implStrings = [@[
                             @"#include ",
                             identifier,
                             @".h\"\n\n",
                             @"#define RETURN_ENUM_INSTANCE() \\\n",
                             TAB, @"static ", identifier,
                             @" *instance = nil;\\\n",
                             TAB, @"static dispatch_once_t onceToken;\\\n",
                             TAB, @"dispatch_once(&onceToken, ^{\\\n",
                             TAB, TAB, @"instance = [[", identifier, @" alloc] init];\\\n",
                             TAB, @"});\\\n",
                             TAB, @"return instance;\n\n",
                             @"@implementation ", identifier, @"\n\n"
                             ] mutableCopy];
    
    for (PTCEnumOption *option in enumConstruct.options)
    {
        NSString *methodString = [NSString stringWithFormat:@"+ (%@ *)%@", identifier, option.name];
        
        NSString *headerMethodString = [NSString stringWithFormat:@"%@;\n", methodString];
        [headerStrings addObject:headerMethodString];
        
        NSArray *implMethodStrings = @[ methodString, @"{ RETURN_ENUM_INSTANCE(); }\n" ];
        [implStrings addObjectsFromArray:implMethodStrings];
    }
    
    [headerStrings addObject:@"\n+ (NSArray *)values;\n"];
    [implStrings addObjectsFromArray:@[
                                       @"\n+ (NSArray *)values\n",
                                       @"{\n",
                                       TAB, @"static NSArray *values = nil;\n",
                                       TAB, @"static dispatch_once_t onceToken;\n",
                                       TAB, @"dispatch_once(&onceToken, ^{\n",
                                       TAB, TAB, @"values = @[ "
                                       ]];
    
    [enumConstruct.options enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        PTCEnumOption *option = obj;
        NSString *str = [NSString stringWithFormat:@"%@.%@", identifier, option.name];
        [implStrings addObject:str];
        if (idx != enumConstruct.options.count - 1)
        {
            [implStrings addObject:@", "];
        }
    }];
    
    [implStrings addObjectsFromArray:@[
                                       @" ];\n",
                                       TAB, @"});\n\n",
                                       TAB, @"return values;\n",
                                       @"}\n",
                                       @"\n@end\n"
                                       ]];
    [headerStrings addObject:@"\n@end\n"];
    
    NSString *headerString = [headerStrings componentsJoinedByString:@""];
    NSString *implString = [implStrings componentsJoinedByString:@""];
    
    return @{
             @"header" : headerString,
             @"implementation" : implString
             };
}

@end
