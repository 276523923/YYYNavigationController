//
//  BZWMediator+ViewController.m
//  BaoZhangWang
//
//  Created by yyy on 2018/11/8.
//  Copyright © 2018 yyy. All rights reserved.
//

#import "BZWMediator+ViewController.h"
#import "UIWindow+YYYAddition.h"
#import "NSString+YYYAddition.h"

@implementation BZWMediator (ViewController)

- (nullable UIViewController *)getViewController:(NSString *)className {
    return [self getViewController:className withParam:nil];
}

- (nullable UIViewController *)getViewController:(NSString *)className withParam:(nullable id)param {
    if ([className isWebUrl]) {
        if (![className containsString:@"bzw315.com"]) {
            //不是保障网链接不给跳转
            return nil;
        }
        return [self performTargetClassName:@"BZWWebViewController" actionStringAndParam:@"viewControllerWithParams:",@{@"url":className.copy}];
    }
    return [self performTargetClassName:className actionStringAndParam:@"viewControllerWithParams:",param];
}

- (nullable UIViewController *)pushViewController:(NSString *)className {
    return [self pushViewController:className withParam:nil];
}

- (nullable UIViewController *)pushViewController:(NSString *)className withParam:(nullable id)param {
    UIViewController *viewController = [self getViewController:className withParam:param];
    if (viewController) {
        UIViewController *currentVisitViewController = [self currentVisitController];
        [currentVisitViewController.navigationController pushViewController:viewController animated:YES];
    }
    return viewController;
}

- (UIViewController *)presentViewController:(NSString *)className {
    return [self presentViewController:className withParam:nil];
}

- (UIViewController *)presentViewController:(NSString *)className withParam:(id)param {
    UIViewController *viewController = [self getViewController:className withParam:param];
    if (viewController) {
        UIViewController *currentVisitViewController = [self currentVisitController];
        [currentVisitViewController presentViewController:viewController animated:YES completion:nil];
    }
    return viewController;
}

- (UIViewController *)currentVisitController {
    UIViewController *visibleVC = [UIApplication sharedApplication].delegate.window.visibleViewController;
    if ([visibleVC isKindOfClass:NSClassFromString(@"RTContainerController")]) {
        UIViewController *vc = [visibleVC valueForKey:@"contentViewController"];
        return vc? vc:visibleVC;
    } else {
        return visibleVC;
    }
}

@end

@implementation UIViewController (BZWControllerMediator)

+ (instancetype)viewControllerWithParams:(NSDictionary *)param {
    return [self new];
}

@end
