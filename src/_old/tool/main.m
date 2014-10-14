//
//  main.m
//  Proteus
//
//  Created by David Owens II on 10/1/14.
//  Copyright (c) 2014 owensd.io. All rights reserved.
//

#import <Foundation/Foundation.h>

// sum -> int -> int -> int

#define BLOCK(in, out) __typeof__(out (^)(in))

BLOCK(int, BLOCK(int, int)) sum_partial = ^(int x) { return ^int(int y) { return x + y; }; };
BLOCK(int, BLOCK(int, int)) mult_partial = ^(int x) { return ^(int y) { return x * y; }; };

int (^add)(int, int) = ^(int x, int y) {
    return x + y;
};

#define BLOCK2(out, in, ...) __typeof__(out (^)(in, ##__VA_ARGS__))

int sum(int x, int y) { return sum_partial(x)(y); }
int mult(int x, int y) { return mult_partial(x)(y); }

BLOCK2(NSNumber *, NSNumber *, NSNumber *) add2 = ^NSNumber *(NSNumber *x, NSNumber *y) { return @([x integerValue] + [y integerValue]); };

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSLog(@"result = %d", sum(10, 12));

        BLOCK(int, int) sum_partial1 = sum_partial(7);
        NSLog(@"partial result = %d", sum_partial1(12));

        NSLog(@"partial mult = %d", mult_partial(2)(3));

        NSLog(@"add = %d", add(2, 3));
    }
    return 0;
}
