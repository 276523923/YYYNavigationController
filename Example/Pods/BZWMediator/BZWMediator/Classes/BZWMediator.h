//
//  BZWMediator.h
//  BaoZhangWang
//
//  Created by 叶越悦 on 2018/8/27.
//  Copyright © 2018年 yyy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class stdarg;
@interface BZWMediator : NSObject


/**
 单例

 @return BZWMediator
 */
+ (instancetype)shared;

/**
 远程App调用入口，可以直接用网页链接打开 web 页面
 web url
 http://www.bzw315.com
 open BZWWebViewController
 
 scheme://[target]/[action]?[params]
 本地类方法调用:
 BZWTarget://targetClassName/actionString?id=1234
 
 @param url 链接
 @param completion 完成回调
 @return 方法返回值
 */
- (id)performActionWithUrl:(NSURL *)url completion:(void(^)(NSDictionary *info))completion;

/**
 本地调用，类方法调用

 @param className 类方法调用
 @param actionStringAndParam 类方法跟参数
 @return 方法返回值
 */
- (id)performTargetClassName:(NSString *)className actionStringAndParam:(NSString *)actionStringAndParam,...;

/**
 本地调用，任意target调用，类对象，实例对象都可以

 @param target 调用对象
 @param actionAndParam 调用方法跟参数
 @return 方法返回值
 */
- (id)performTarget:(id)target actionAndParam:(SEL)actionAndParam,...;

/**
 本地调用，任意target调用，类对象，实例对象都可以

 @param target 调用对象
 @param action 调用方法
 @param paramList 参数列表
 @return 方法返回值
 */
- (id)performTarget:(id)target action:(SEL)action paramList:(va_list)paramList;


@end
