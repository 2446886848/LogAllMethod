//
//  Cat.h
//  LogAllMethod
//
//  Created by walen on 2017/5/17.
//  Copyright © 2017年 dafyit. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CatBlock)();

@interface Cat : NSObject

@property (nonatomic, copy) CatBlock catBlock;

- (void)fee;

- (NSString *)name;

- (void)eat:(NSString *)foodName;

+ (NSString *)classFunc:(NSInteger)arg;

@end
