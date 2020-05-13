//
//  YYYNavigationController.h
//  YYYNavigationBarTransition
//
//  Created by yyy on 2018/11/29.
//  Copyright © 2018 yyy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYYNavigationManager.h"

NS_ASSUME_NONNULL_BEGIN

/**
 独立配置返回按钮的样式
 */
@protocol YYYNavigationLeftBarButtonItemProtocol <NSObject>

- (UIBarButtonItem *)yyy_customBackItemWithTarget:(id)target action:(SEL)action;

@end

@interface UIViewController (YYYNavigationManager)
/**
 navigationController.yyy_navigationManager = [[YYYNavigationManager globalManager] copy];
 
 默认 viewController.yyy_navigationManager = [self.navigationController.yyy_navigationManager copy];
 */
@property (nonatomic, strong, readonly) YYYNavigationManager *yyy_navigationManager;

@end

/**
 YYYNavigationController 也是带有 yyy_navigationManager，默认是 globalManager的样式
 每个不同的NavigationController可以配置各自的 yyy_navigationManager 样式，这样子viewController都会继承这个样式
 */
@interface YYYNavigationController : UINavigationController

/**
 转场动画的代理得用这个yyy_delegate
 */
@property (nonatomic, weak) id<UINavigationControllerDelegate> yyy_delegate;

/**
 可以统一配置返回按钮的样式
 */
@property (nonatomic, copy) UIBarButtonItem *(^customBackItemBlock)(UIViewController *viewController,id target,SEL action);

/**
 设置为YES的话就禁用掉自定义的转场效果，使用系统的转场效果
 */
@property (nonatomic) BOOL disabledCustomTransition;

@end

NS_ASSUME_NONNULL_END
