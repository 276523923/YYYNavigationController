//
//  YYYNavigationManager.h
//  YYYNavigationBarTransition
//
//  Created by yyy on 2018/11/29.
//  Copyright © 2018 yyy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YYYNavigationManager : NSObject<NSCopying,NSMutableCopying>

@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic) UIBarStyle barStyle;
@property (nonatomic, getter=isTranslucent) BOOL translucent;

@property (nonatomic, strong, nullable) UIImage *backgroundImage;
@property (nonatomic, strong, nullable) UIImage *shadowImage;

@property (nonatomic, strong, nullable) UIImage *darkBackgroundImage API_AVAILABLE(ios(13.0));
@property (nonatomic, strong, nullable) UIImage *darkShadowImage API_AVAILABLE(ios(13.0));

@property (nonatomic, strong, null_resettable) UIColor *tintColor;
@property (nonatomic, strong, nullable) UIColor *barTintColor;
@property (nonatomic) BOOL hiddenNavigationBar;
@property (nonatomic, copy, nullable) NSDictionary<NSAttributedStringKey, id> *titleTextAttributes;
@property (nonatomic) BOOL isShow;

- (void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated;


- (void)reloadNavigationBarStyle;

- (void)updateStyleToNavigationBar:(UINavigationBar *)navigationBar;

/**
 全局默认配置
 
 默认为 [UINavigationBar appearance] 的样式
 所以可以在 AppDelegate 直接配置 [UINavigationBar appearance] 的样式
 或者直接配置 globalManager 的样式
 
 @return globalManager
 */
+ (instancetype)globalManager;

@end

NS_ASSUME_NONNULL_END
