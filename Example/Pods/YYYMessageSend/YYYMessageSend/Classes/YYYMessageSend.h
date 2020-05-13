//
//  MsgSend.h
//  YYYNetWorkDemo
//
//  Created by yyy on 2016/12/16.
//  Copyright © 2016年 yyy. All rights reserved.
//

#ifndef YYYMessageSend_h
#define YYYMessageSend_h

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const YYYMessageSendErrorDomain;
NS_ERROR_ENUM(YYYMessageSendErrorDomain) {
    YYYMessageSendErrorTargetNull = 1000,
    YYYMessageSendErrorSELNull = 1001,
    YYYMessageSendErrorSELNoFound = 1002,
    YYYMessageSendErrorResultTypeNoFound = 1003,
};

extern __attribute((overloadable)) id SEL_Exec(id target, SEL sel, ...);
extern __attribute((overloadable)) id SEL_Exec(id target, SEL sel, va_list list);
extern __attribute((overloadable)) id SEL_Exec(id target, SEL sel, va_list list, NSError **error);

#endif /* YYYMessageSend_h */
