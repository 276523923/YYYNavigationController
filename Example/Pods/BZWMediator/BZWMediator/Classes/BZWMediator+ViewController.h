//
//  BZWMediator+ViewController.h
//  BaoZhangWang
//
//  Created by yyy on 2018/11/8.
//  Copyright © 2018 yyy. All rights reserved.
//

#import "BZWMediator.h"

NS_ASSUME_NONNULL_BEGIN

@interface BZWMediator (ViewController)

@property (nonatomic, readonly) UIViewController *currentVisitController;

- (nullable __kindof UIViewController *)getViewController:(NSString *)className withParam:(nullable id)param;
- (nullable __kindof UIViewController *)getViewController:(NSString *)className;

- (nullable __kindof UIViewController *)pushViewController:(NSString *)className withParam:(nullable id)param;
- (nullable __kindof UIViewController *)pushViewController:(NSString *)className;

- (nullable __kindof UIViewController *)presentViewController:(NSString *)className withParam:(nullable id)param;
- (nullable __kindof UIViewController *)presentViewController:(NSString *)className;

@end

@interface UIViewController (BZWControllerMediator)

+ (instancetype)viewControllerWithParams:(nullable NSDictionary *)param;

@end

NS_ASSUME_NONNULL_END
