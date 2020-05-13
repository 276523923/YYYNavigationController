//
//  MsgSend.m
//  YYYNetWorkDemo
//
//  Created by yyy on 2016/12/16.
//  Copyright © 2016年 yyy. All rights reserved.
//

#import "YYYMessageSend.h"
#import <UIKit/UIKit.h>
#import <objc/message.h>

NSString *const YYYMessageSendErrorDomain = @"YYYMessageSendErrorDomain";

__attribute((overloadable)) id SEL_Exec(id target, SEL sel, va_list argList, NSError **error) {
    BOOL needError = error != NULL;
    if (target == nil || [target isEqual:[NSNull null]]) {
        if (needError) {
            *error = [NSError errorWithDomain:YYYMessageSendErrorDomain code:YYYMessageSendErrorTargetNull userInfo:@{NSLocalizedDescriptionKey:@"target can't null"}];
        }
        return nil;
    }
    
    if (sel == nil) {
        if (needError) {
            *error = [NSError errorWithDomain:YYYMessageSendErrorDomain code:YYYMessageSendErrorSELNull userInfo:@{NSLocalizedDescriptionKey:@"sel can't null"}];
        }
        return nil;
    }
    
    BOOL isClass = NO;
    NSMethodSignature *methodSignature = nil;
    if (object_isClass(target)) {
        isClass = YES;
        methodSignature = [target methodSignatureForSelector:sel];
    } else {
        isClass = NO;
        methodSignature = [[target class] instanceMethodSignatureForSelector:sel];
    }
    if (methodSignature == nil) {
        if (needError) {
            NSString *description = [NSString stringWithFormat:@"target no fonud this sel\n target:%@\n sel:%@",target,NSStringFromSelector(sel)];
            *error = [NSError errorWithDomain:YYYMessageSendErrorDomain code:YYYMessageSendErrorSELNoFound userInfo:@{NSLocalizedDescriptionKey:description}];
        }
        return nil;
    }
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    [invocation setTarget:target];
    [invocation setSelector:sel];
    for (unsigned int i = 2; i < methodSignature.numberOfArguments; i++) {
        const char *type = [methodSignature getArgumentTypeAtIndex:i];
        if (strcmp(type, @encode(id)) == 0) {
            id actual = va_arg(argList, id);
            [invocation setArgument:&actual atIndex:i];
        } else if (strcmp(type, @encode(CGRect)) == 0) {
            CGRect actual = (CGRect) va_arg(argList, CGRect);
            [invocation setArgument:&actual atIndex:i];
        } else if (strcmp(type, @encode(CGPoint)) == 0) {
            CGPoint actual = (CGPoint) va_arg(argList, CGPoint);
            [invocation setArgument:&actual atIndex:i];
        } else if (strcmp(type, @encode(CGSize)) == 0) {
            CGSize actual = (CGSize) va_arg(argList, CGSize);
            [invocation setArgument:&actual atIndex:i];
        } else if (strcmp(type, @encode(NSRange)) == 0) {
            NSRange actual = (NSRange) va_arg(argList, NSRange);
            [invocation setArgument:&actual atIndex:i];
        } else if (strcmp(type, @encode(CGAffineTransform)) == 0) {
            CGAffineTransform actual = (CGAffineTransform) va_arg(argList, CGAffineTransform);
            [invocation setArgument:&actual atIndex:i];
        } else if (strcmp(type, @encode(UIEdgeInsets)) == 0) {
            UIEdgeInsets actual = (UIEdgeInsets) va_arg(argList, UIEdgeInsets);
            [invocation setArgument:&actual atIndex:i];
        } else if (strcmp(type, @encode(UIOffset)) == 0) {
            UIOffset actual = (UIOffset) va_arg(argList, UIOffset);
            [invocation setArgument:&actual atIndex:i];
        } else if (strcmp(type, @encode(CGVector)) == 0) {
            CGVector actual = (CGVector) va_arg(argList, CGVector);
            [invocation setArgument:&actual atIndex:i];
        } else if (strcmp(type, @encode(double)) == 0) {
            double actual = (double) va_arg(argList, double);
            [invocation setArgument:&actual atIndex:i];
        } else if (strcmp(type, @encode(float)) == 0) {
            float actual = (float) va_arg(argList, double);
            [invocation setArgument:&actual atIndex:i];
        } else if (strcmp(type, @encode(int)) == 0) {
            int actual = (int) va_arg(argList, int);
            [invocation setArgument:&actual atIndex:i];
        } else if (strcmp(type, @encode(long)) == 0) {
            long actual = (long) va_arg(argList, long);
            [invocation setArgument:&actual atIndex:i];
        } else if (strcmp(type, @encode(long long)) == 0) {
            long long actual = (long long) va_arg(argList, long long);
            [invocation setArgument:&actual atIndex:i];
        } else if (strcmp(type, @encode(short)) == 0) {
            short actual = (short) va_arg(argList, int);
            [invocation setArgument:&actual atIndex:i];
        } else if (strcmp(type, @encode(char)) == 0) {
            char actual = (char) va_arg(argList, int);
            [invocation setArgument:&actual atIndex:i];
        } else if (strcmp(type, @encode(bool)) == 0) {
            bool actual = (bool) va_arg(argList, int);
            [invocation setArgument:&actual atIndex:i];
        } else if (strcmp(type, @encode(unsigned char)) == 0) {
            unsigned char actual = (unsigned char) va_arg(argList, unsigned int);
            [invocation setArgument:&actual atIndex:i];
        } else if (strcmp(type, @encode(unsigned int)) == 0) {
            unsigned int actual = (unsigned int) va_arg(argList, unsigned int);
            [invocation setArgument:&actual atIndex:i];
        } else if (strcmp(type, @encode(unsigned long)) == 0) {
            unsigned long actual = (unsigned long) va_arg(argList, unsigned long);
            [invocation setArgument:&actual atIndex:i];
        } else if (strcmp(type, @encode(unsigned long long)) == 0) {
            unsigned long long actual = (unsigned long long) va_arg(argList, unsigned long long);
            [invocation setArgument:&actual atIndex:i];
        } else if (strcmp(type, @encode(unsigned short)) == 0) {
            unsigned short actual = (unsigned short) va_arg(argList, unsigned int);
            [invocation setArgument:&actual atIndex:i];
        } else if (strcmp(type, @encode(SEL)) == 0) {
            SEL actual = (SEL) va_arg(argList, SEL);
            [invocation setArgument:&actual atIndex:i];
        } else if (strcmp(type, @encode(void **)) == 0) {
            void **actual = (void **) va_arg(argList, void**);
            [invocation setArgument:&actual atIndex:i];
        } else if (strcmp(type, @encode(Class)) == 0) {
            Class actual = (Class) va_arg(argList, Class);
            [invocation setArgument:&actual atIndex:i];
        } else {
            //无法处理的对象直接传递nil了
            id nilObj = nil;
            [invocation setArgument:&nilObj atIndex:i];
        }
    }
    [invocation invoke];
    
    const char *returnType = [methodSignature methodReturnType];
    if (strcmp(returnType, @encode(void)) == 0) {
        return nil;
    } else if (strcmp(returnType, @encode(id)) == 0) {
        void *result;
        [invocation getReturnValue:&result];
        if (result == NULL) {
            return nil;
        }
        id returnValue;
        NSString *selName = NSStringFromSelector(sel);
        if ([selName isEqualToString:@"alloc"] || [selName isEqualToString:@"new"] || [selName isEqualToString:@"copy"] || [selName isEqualToString:@"mutableCopy"]) {
            returnValue = (__bridge_transfer id) result;
        } else {
            returnValue = (__bridge id) result;
        }
        return returnValue;
    } else if (strcmp(returnType, @encode(CGRect)) == 0) {
        CGRect result;
        [invocation getReturnValue:&result];
        NSValue *returnValue = [NSValue valueWithBytes:&(result) objCType:@encode(CGRect)];
        return returnValue;
    } else if (strcmp(returnType, @encode(CGPoint)) == 0) {
        CGPoint result;
        [invocation getReturnValue:&result];
        NSValue *returnValue = [NSValue valueWithBytes:&(result) objCType:@encode(CGPoint)];
        return returnValue;
    } else if (strcmp(returnType, @encode(CGSize)) == 0) {
        CGSize result;
        [invocation getReturnValue:&result];
        NSValue *returnValue = [NSValue valueWithBytes:&(result) objCType:@encode(CGSize)];
        return returnValue;
    } else if (strcmp(returnType, @encode(NSRange)) == 0) {
        NSRange result;
        [invocation getReturnValue:&result];
        NSValue *returnValue = [NSValue valueWithBytes:&(result) objCType:@encode(NSRange)];
        return returnValue;
    } else if (strcmp(returnType, @encode(CGAffineTransform)) == 0) {
        CGAffineTransform result;
        [invocation getReturnValue:&result];
        NSValue *returnValue = [NSValue valueWithBytes:&(result) objCType:@encode(CGAffineTransform)];
        return returnValue;
    } else if (strcmp(returnType, @encode(UIEdgeInsets)) == 0) {
        UIEdgeInsets result;
        [invocation getReturnValue:&result];
        NSValue *returnValue = [NSValue valueWithBytes:&(result) objCType:@encode(UIEdgeInsets)];
        return returnValue;
    } else if (strcmp(returnType, @encode(UIOffset)) == 0) {
        UIOffset result;
        [invocation getReturnValue:&result];
        NSValue *returnValue = [NSValue valueWithBytes:&(result) objCType:@encode(UIOffset)];
        return returnValue;
    } else if (strcmp(returnType, @encode(CGVector)) == 0) {
        CGVector result;
        [invocation getReturnValue:&result];
        NSValue *returnValue = [NSValue valueWithBytes:&(result) objCType:@encode(CGVector)];
        return returnValue;
    } else if (strcmp(returnType, @encode(double)) == 0) {
        double returnValue;
        [invocation getReturnValue:&returnValue];
        return @(returnValue);
    } else if (strcmp(returnType, @encode(float)) == 0) {
        float returnValue;
        [invocation getReturnValue:&returnValue];
        return @(returnValue);
    } else if (strcmp(returnType, @encode(int)) == 0) {
        int returnValue;
        [invocation getReturnValue:&returnValue];
        return @(returnValue);
    } else if (strcmp(returnType, @encode(long)) == 0) {
        long returnValue;
        [invocation getReturnValue:&returnValue];
        return @(returnValue);
    } else if (strcmp(returnType, @encode(long long)) == 0) {
        long long returnValue;
        [invocation getReturnValue:&returnValue];
        return @(returnValue);
    } else if (strcmp(returnType, @encode(short)) == 0) {
        short returnValue;
        [invocation getReturnValue:&returnValue];
        return @(returnValue);
    } else if (strcmp(returnType, @encode(char)) == 0) {
        char returnValue;
        [invocation getReturnValue:&returnValue];
        return @(returnValue);
    } else if (strcmp(returnType, @encode(bool)) == 0) {
        bool returnValue;
        [invocation getReturnValue:&returnValue];
        return @(returnValue);
    } else if (strcmp(returnType, @encode(unsigned char)) == 0) {
        unsigned char returnValue;
        [invocation getReturnValue:&returnValue];
        return @(returnValue);
    } else if (strcmp(returnType, @encode(unsigned int)) == 0) {
        unsigned int returnValue;
        [invocation getReturnValue:&returnValue];
        return @(returnValue);
    } else if (strcmp(returnType, @encode(unsigned long)) == 0) {
        unsigned long returnValue;
        [invocation getReturnValue:&returnValue];
        return @(returnValue);
    } else if (strcmp(returnType, @encode(unsigned long long)) == 0) {
        unsigned long long returnValue;
        [invocation getReturnValue:&returnValue];
        return @(returnValue);
    } else if (strcmp(returnType, @encode(unsigned short)) == 0) {
        unsigned short returnValue;
        [invocation getReturnValue:&returnValue];
        return @(returnValue);
    } else if (strcmp(returnType, @encode(SEL)) == 0) {
        SEL returnValue;
        [invocation getReturnValue:&returnValue];
        return NSStringFromSelector(returnValue);
    } else if (strcmp(returnType, @encode(Class)) == 0) {
        Class returnValue;
        [invocation getReturnValue:&returnValue];
        return returnValue;
    }
    //无法识别的类型，直接返回nil
    if (needError) {
        *error = [NSError errorWithDomain:YYYMessageSendErrorDomain code:YYYMessageSendErrorResultTypeNoFound userInfo:@{NSLocalizedDescriptionKey:@"result type no found"}];        
    }
    return nil;
}

__attribute((overloadable)) id SEL_Exec(id target, SEL sel, va_list argList) {
    return SEL_Exec(target, sel, argList, nil);
}

__attribute((overloadable)) id SEL_Exec(id target, SEL sel, ...) {
    if (target == nil || !sel) {
        return nil;
    }
    va_list argList;
    va_start(argList, sel);
    id value = SEL_Exec(target, sel, argList);
    va_end(argList);
    return value;
}


