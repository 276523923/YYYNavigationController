//
//  BZWMediator.m
//  BaoZhangWang
//
//  Created by 叶越悦 on 2018/8/27.
//  Copyright © 2018年 yyy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <stdarg.h>
#import "BZWMediator.h"
#import "BZWMediator+ViewController.h"
#import "YYYMessageSend.h"

@implementation BZWMediator

#pragma mark - public methods
+ (instancetype)shared {
    static BZWMediator *mediator__;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mediator__ = [BZWMediator new];
    });
    return mediator__;
}

/*
 web url
 http://www.bzw315.com
 open BZWWebViewController
 
 bzw315://
 
 
 scheme://[target]/[action]?[params]
 
 url sample:
 BZWTarget://targetA/actionB?id=1234
 */

- (id)performActionWithUrl:(NSURL *)url completion:(void (^)(NSDictionary *))completion {
    if (!url) {
        return nil;
    }
    if ([url.scheme isEqualToString:@"bzw315"]) {
        //TODO:跟推送消息一起处理
    } else if ([url.scheme hasPrefix:@"http"]) {
        if (![url.host hasSuffix:@"bzw315.com"]) {
            return nil;
        }
        UIViewController *viewController = [self pushViewController:url.absoluteString];
        if (completion) {
            if (viewController) {
                completion(@{@"result":viewController});
            } else {
                completion(nil);
            }
        }
        return viewController;
    } else if ([url.scheme isEqualToString:@"BZWTarget"]) {
        NSMutableDictionary *params = [self getParamsFromUrl:url];
        NSString *actionName = [url.path stringByReplacingOccurrencesOfString:@"/" withString:@""];
        // 这个demo针对URL的路由处理非常简单，就只是取对应的target名字和method名字，但这已经足以应对绝大部份需求。如果需要拓展，可以在这个方法调用之前加入完整的路由逻辑
        id result = [self performTargetClassName:url.host actionStringAndParam:actionName,params];
        if (completion) {
            if (result) {
                completion(@{@"result":result});
            } else {
                completion(nil);
            }
        }
        return result;
    }
    return nil;
}

- (id)performTargetClassName:(NSString *)className actionStringAndParam:(NSString *)actionStringAndParam, ... {
    id target = NSClassFromString(className);
    SEL action = NSSelectorFromString(actionStringAndParam);
    va_list list;
    va_start(list, actionStringAndParam);
    id result = [self performTarget:target action:action paramList:list];
    va_end(list);
    return result;
}

- (id)performTarget:(id)target actionAndParam:(SEL)actionAndParam, ... {
    va_list list;
    va_start(list, actionAndParam);
    id result = [self performTarget:target action:actionAndParam paramList:list];
    va_end(list);
    return result;
}

- (id)performTarget:(id)target action:(SEL)action paramList:(va_list)paramList {
    if (target == nil || action == nil) {
        [self NoTargetActionResponseWithTarget:target selector:action];
        return nil;
    }
    NSError *error;
    id result = nil;
    @try {
        result = SEL_Exec(target, action, paramList,&error);
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    } @finally {
        if (error.domain == YYYMessageSendErrorDomain) {
            [self NoTargetActionResponseWithTarget:target selector:action];
        }
        return result;
    }
}

#pragma mark - private methods
- (void)NoTargetActionResponseWithTarget:(id)target selector:(SEL)selector {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"originTarget"] = target;
    params[@"originAction"] = NSStringFromSelector(selector);
    Class newTarget = NSClassFromString(@"Target_NoTargetAction");
    SEL noTargetAction = NSSelectorFromString(@"noTargetAction:");
    @try {
        SEL_Exec(newTarget, noTargetAction,params);
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
}

- (NSMutableDictionary *)getParamsFromUrl:(NSURL *)url {
    NSString *query = url.query;
    NSArray *querys = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    for (NSString *param in querys) {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        if([elts count] < 2) continue;
        [params setObject:[elts lastObject] forKey:[elts firstObject]];
    }
    return params;
}

@end
