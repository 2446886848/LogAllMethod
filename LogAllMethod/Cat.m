//
//  Cat.m
//  LogAllMethod
//
//  Created by walen on 2017/5/17.
//  Copyright © 2017年 dafyit. All rights reserved.
//

#import "Cat.h"

@implementation Cat

- (void)fee {
    NSLog(@"cat fee");
}

- (NSString *)name {
    NSLog(@"cat name");
    return @"kitty";
}

- (void)eat:(NSString *)foodName {
    NSLog(@"cat eat %@", foodName);
}

+ (NSString *)classFunc:(NSInteger)arg {
    NSLog(@"classFunc:");
    return [NSString stringWithFormat:@"%@", @(arg)];
}
@end
