//
//  MethodLogManager.m
//  LogAllMethod
//
//  Created by walen on 2017/5/17.
//  Copyright © 2017年 dafyit. All rights reserved.
//

#import "MethodLogManager.h"
#import <objc/runtime.h>
#import <objc/message.h>

static NSString *kMethodLogPrefix = @"MethodLog_";

@implementation LogMethod

- (instancetype)initWithInvocation:(NSInvocation *)invocation {
    if (self = [super init]) {
        _invocation = invocation;
        [self initData];
    }
    return self;
}

- (void)initData {
    _object = self.invocation.target;
    
    NSString *selName = NSStringFromSelector(self.invocation.selector);
    if ([selName hasPrefix:kMethodLogPrefix]) {
        selName = [selName substringFromIndex:kMethodLogPrefix.length];
    }
    _selector = NSSelectorFromString(selName);
    NSUInteger numberOfArguments = self.invocation.methodSignature.numberOfArguments;
    NSMutableArray *argumentsArray = [NSMutableArray arrayWithCapacity:numberOfArguments - 2];
    for (NSUInteger index = 2; index < numberOfArguments; index++) {
        [argumentsArray addObject:[self argumentAtIndex:index]];
    }
    _arguments = argumentsArray;
    _returnValue = [self getReturnValue];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"object:%@\n\
                                        selector:%@\n\
                                        arguments:%@\n\
            returnValue:%@\n", self.object, NSStringFromSelector(self.selector), self.arguments, self.returnValue];
}

- (id)argumentAtIndex:(NSUInteger)index {
    
#define WRAP_AND_RETURN(type) \
do { \
type val = 0; \
[self.invocation getArgument:&val atIndex:(NSInteger)index]; \
return @(val); \
} while (0)
    
    const char *argType = [self.invocation.methodSignature getArgumentTypeAtIndex:index];
    // Skip const type qualifier.
    if (argType[0] == 'r') {
        argType++;
    }
    
    if (strcmp(argType, @encode(id)) == 0 || strcmp(argType, @encode(Class)) == 0) {
        __autoreleasing id returnObj;
        [self.invocation getArgument:&returnObj atIndex:(NSInteger)index];
        return returnObj;
    } else if (strcmp(argType, @encode(char)) == 0) {
        WRAP_AND_RETURN(char);
    } else if (strcmp(argType, @encode(int)) == 0) {
        WRAP_AND_RETURN(int);
    } else if (strcmp(argType, @encode(short)) == 0) {
        WRAP_AND_RETURN(short);
    } else if (strcmp(argType, @encode(long)) == 0) {
        WRAP_AND_RETURN(long);
    } else if (strcmp(argType, @encode(long long)) == 0) {
        WRAP_AND_RETURN(long long);
    } else if (strcmp(argType, @encode(unsigned char)) == 0) {
        WRAP_AND_RETURN(unsigned char);
    } else if (strcmp(argType, @encode(unsigned int)) == 0) {
        WRAP_AND_RETURN(unsigned int);
    } else if (strcmp(argType, @encode(unsigned short)) == 0) {
        WRAP_AND_RETURN(unsigned short);
    } else if (strcmp(argType, @encode(unsigned long)) == 0) {
        WRAP_AND_RETURN(unsigned long);
    } else if (strcmp(argType, @encode(unsigned long long)) == 0) {
        WRAP_AND_RETURN(unsigned long long);
    } else if (strcmp(argType, @encode(float)) == 0) {
        WRAP_AND_RETURN(float);
    } else if (strcmp(argType, @encode(double)) == 0) {
        WRAP_AND_RETURN(double);
    } else if (strcmp(argType, @encode(BOOL)) == 0) {
        WRAP_AND_RETURN(BOOL);
    } else if (strcmp(argType, @encode(char *)) == 0) {
        WRAP_AND_RETURN(const char *);
    } else if (strcmp(argType, @encode(void (^)(void))) == 0) {
        __unsafe_unretained id block = nil;
        [self.invocation getArgument:&block atIndex:(NSInteger)index];
        return [block copy];
    } else {
        NSUInteger valueSize = 0;
        NSGetSizeAndAlignment(argType, &valueSize, NULL);
        
        unsigned char valueBytes[valueSize];
        [self.invocation getArgument:valueBytes atIndex:(NSInteger)index];
        
        return [NSValue valueWithBytes:valueBytes objCType:argType];
    }
    
    return nil;
    
#undef WRAP_AND_RETURN
}

- (id)getReturnValue {
#define WRAP_AND_RETURN(type) \
do { \
type val = 0; \
[self.invocation getReturnValue:&val]; \
return @(val); \
} while (0)
    
    const char *returnType = self.invocation.methodSignature.methodReturnType;
    // Skip const type qualifier.
    if (returnType[0] == 'r') {
        returnType++;
    }
    
    if (strcmp(returnType, @encode(id)) == 0 || strcmp(returnType, @encode(Class)) == 0 || strcmp(returnType, @encode(void (^)(void))) == 0) {
        __autoreleasing id returnObj;
        [self.invocation getReturnValue:&returnObj];
        return returnObj;
    } else if (strcmp(returnType, @encode(char)) == 0) {
        WRAP_AND_RETURN(char);
    } else if (strcmp(returnType, @encode(int)) == 0) {
        WRAP_AND_RETURN(int);
    } else if (strcmp(returnType, @encode(short)) == 0) {
        WRAP_AND_RETURN(short);
    } else if (strcmp(returnType, @encode(long)) == 0) {
        WRAP_AND_RETURN(long);
    } else if (strcmp(returnType, @encode(long long)) == 0) {
        WRAP_AND_RETURN(long long);
    } else if (strcmp(returnType, @encode(unsigned char)) == 0) {
        WRAP_AND_RETURN(unsigned char);
    } else if (strcmp(returnType, @encode(unsigned int)) == 0) {
        WRAP_AND_RETURN(unsigned int);
    } else if (strcmp(returnType, @encode(unsigned short)) == 0) {
        WRAP_AND_RETURN(unsigned short);
    } else if (strcmp(returnType, @encode(unsigned long)) == 0) {
        WRAP_AND_RETURN(unsigned long);
    } else if (strcmp(returnType, @encode(unsigned long long)) == 0) {
        WRAP_AND_RETURN(unsigned long long);
    } else if (strcmp(returnType, @encode(float)) == 0) {
        WRAP_AND_RETURN(float);
    } else if (strcmp(returnType, @encode(double)) == 0) {
        WRAP_AND_RETURN(double);
    } else if (strcmp(returnType, @encode(BOOL)) == 0) {
        WRAP_AND_RETURN(BOOL);
    } else if (strcmp(returnType, @encode(char *)) == 0) {
        WRAP_AND_RETURN(const char *);
    } else if (strcmp(returnType, @encode(void)) == 0) {
        return nil;
    } else {
        NSUInteger valueSize = 0;
        NSGetSizeAndAlignment(returnType, &valueSize, NULL);
        
        unsigned char valueBytes[valueSize];
        [self.invocation getReturnValue:valueBytes];
        
        return [NSValue valueWithBytes:valueBytes objCType:returnType];
    }
    
    return nil;
    
#undef WRAP_AND_RETURN
}

@end

@interface NSObject (MethodLog)

@property (nonatomic, assign, class) BOOL methodLogDealled;

@property (nonatomic, copy, class) MethodCallback methodCallback;

@end

@implementation NSObject (MethodLog)

+ (BOOL)methodLogDealled {
    return [objc_getAssociatedObject(self, @selector(methodLogDealled)) boolValue];
}

+ (void)setMethodLogDealled:(BOOL)methodLogDealled {
    objc_setAssociatedObject(self, @selector(methodLogDealled), @(methodLogDealled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (MethodCallback)methodCallback {
    return objc_getAssociatedObject(self, @selector(methodCallback));
}

+ (void)setMethodCallback:(MethodCallback)methodCallback {
    objc_setAssociatedObject(self, @selector(methodCallback), methodCallback, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end

@implementation MethodLogManager

+ (void)logAllMethodForClass:(Class)logedClass callback:(MethodCallback)callback {
    if (!callback) {
        callback = ^(LogMethod *method) {
            NSLog(@"method:%@", method);
        };
    }
    //已经处理过了 不再次处理
    if (logedClass.methodLogDealled) {
        return;
    }
    unsigned int outCount = 0;
    Method *methods = class_copyMethodList(logedClass, &outCount);
    for (int i = 0; i < outCount; i++) {
        Method method = methods[i];
        SEL methodSel = method_getName(method);
        const char *typeEncoding = method_getTypeEncoding(method);
        IMP imp = method_getImplementation(method);
        
        if ([self isMsgForwardIMP:imp]) {
            continue;
        }
        //过滤系统的隐藏函数
        if ([NSStringFromSelector(methodSel) hasPrefix:@"."]) {
            continue;
        }
        
        NSString *hookedName = [self methodLogMethodName:NSStringFromSelector(methodSel)];
        
        class_addMethod(logedClass, NSSelectorFromString(hookedName), imp, typeEncoding);
        
        //将旧地址指向forward invocaton
        class_replaceMethod(logedClass, methodSel, [self getMsgForwardIMP:logedClass sel:methodSel], typeEncoding);
    }
    
    IMP forwardInvocationImpl = imp_implementationWithBlock(^(id object, NSInvocation *invocation) {
        NSString *newSelectorName = [self methodLogMethodName:NSStringFromSelector(invocation.selector)];
        invocation.selector = NSSelectorFromString(newSelectorName);
        [invocation invoke];
        
        MethodCallback methodCallback = object_getClass(object).methodCallback;
        if (methodCallback) {
            LogMethod *logMethod = [[LogMethod alloc] initWithInvocation:invocation];
            methodCallback(logMethod);
        }
    });
    
    class_addMethod(logedClass, @selector(forwardInvocation:), forwardInvocationImpl, "v@:@");
    
    free(methods);
    
    logedClass.methodLogDealled = YES;
    logedClass.methodCallback = callback;
    
    //hook +方法
    if (!class_isMetaClass(logedClass)) {
        [self logAllMethodForClass:object_getClass(logedClass) callback:callback];
    }
}

+ (NSString *)methodLogMethodName:(NSString *)selName {
    return [kMethodLogPrefix stringByAppendingString:selName];
}

+ (IMP)getMsgForwardIMP:(Class)logedClass sel:(SEL)selector {
    IMP msgForwardIMP = _objc_msgForward;
#if !defined(__arm64__)
    Method method = class_getInstanceMethod(logedClass, selector);
    const char *encoding = method_getTypeEncoding(method);
    BOOL methodReturnsStructValue = encoding[0] == _C_STRUCT_B;
    if (methodReturnsStructValue) {
        @try {
            NSUInteger valueSize = 0;
            NSGetSizeAndAlignment(encoding, &valueSize, NULL);
            
            if (valueSize == 1 || valueSize == 2 || valueSize == 4 || valueSize == 8) {
                methodReturnsStructValue = NO;
            }
        } @catch (NSException *e) {}
    }
    if (methodReturnsStructValue) {
        msgForwardIMP = (IMP)_objc_msgForward_stret;
    }
#endif
    return msgForwardIMP;
}

+ (BOOL)isMsgForwardIMP:(IMP)impl {
    return impl == _objc_msgForward
#if !defined(__arm64__)
    || impl == (IMP)_objc_msgForward_stret
#endif
    ;
}

@end
