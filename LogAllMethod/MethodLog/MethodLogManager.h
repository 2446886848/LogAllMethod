//
//  MethodLogManager.h
//  LogAllMethod
//
//  Created by walen on 2017/5/17.
//  Copyright © 2017年 dafyit. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LogMethod;

typedef void(^MethodCallback)(LogMethod *method);

@interface LogMethod : NSObject

@property (nonatomic, strong, readonly) id object;
@property (nonatomic, assign, readonly) SEL selector;
@property (nonatomic, strong, readonly) NSArray *arguments;
@property (nonatomic, strong, readonly) id returnValue;

@property (nonatomic, strong) NSInvocation *invocation;

- (instancetype)initWithInvocation:(NSInvocation *)invocation;

@end

@interface MethodLogManager : NSObject

/**
 记录一个类的所有函数

 @param logedClass 需要记录的类
 @param callback 自定义记录回调 默认打印method:%@
 */
+ (void)logAllMethodForClass:(Class)logedClass callback:(MethodCallback)callback;

@end
