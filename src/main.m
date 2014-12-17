//
//  main.m
//  asd
//
//  Created by Nelson LeDuc on 12/16/14.
//  Copyright (c) 2014 Nelson LeDuc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PTCAnalyzer.h"
#import "PTCConstruct.h"
#import "PTCRewriterProvider.h"
#import "PTCRewriter.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        NSFileHandle *standardError = [NSFileHandle fileHandleWithStandardError];
        NSString *filePath = [[NSUserDefaults standardUserDefaults] stringForKey:@"file"];
        
        NSString *outputPath = [[NSUserDefaults standardUserDefaults] stringForKey:@"output"];
        outputPath = outputPath ?: @"./output";
        
        [[NSFileManager defaultManager] createDirectoryAtPath:outputPath withIntermediateDirectories:YES attributes:nil error:nil];
        
        if (filePath)
        {
            PTCAnalyzer *analyzer = [[PTCAnalyzer alloc] initWithPath:filePath];
            NSArray *constructs = [analyzer analyze];
            
            if ([analyzer.errors firstObject])
            {
                NSData *data = [[NSString stringWithFormat:@"%@\n", [analyzer.errors firstObject]] dataUsingEncoding:NSUTF8StringEncoding];
                if (data)
                    [standardError writeData:data];
            }
            else
            {
                for (id<PTCConstruct> construct in constructs)
                {
                    Class<PTCRewriter> rewriter = [PTCRewriterProvider rewriterForConstructTypeName:[construct typeName]];
                    NSDictionary *result = [rewriter writeObjCFromConstruct:construct];
                    if (result)
                    {
                        NSString *resultHeader = result[@"header"];
                        NSString *resultImpl = result[@"implementation"];
                        
                        NSString *headerString = [NSString stringWithFormat:@"#import <Foundation/Foundation.h>\n\n%@", resultHeader];
                        [headerString writeToFile:[NSString stringWithFormat:@"%@/%@.h", outputPath, [construct identifier]] atomically:YES encoding:NSUTF8StringEncoding error:nil];
                        [resultImpl writeToFile:[NSString stringWithFormat:@"%@/%@.m", outputPath, [construct identifier]] atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    }
                    
                }
            }
        }
     
        [standardError closeFile];
    }
    
    return 0;
}
