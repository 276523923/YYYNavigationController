//
//  UIWindow+Addition.h
//  CategoryUtil
//
//  Created by lee on 14-7-3.
//  Copyright (c) 2014年 zzy.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWindow (YYYAddition)

/**
 *  获取当前可见VC
 *
 *  @return visibleViewController
 */
- (UIViewController *)visibleViewController;

/**
 *  @author 叶越悦, 15-08-13 17:53:19
 *
 *  获取当前可见ViewControllerClassString
 *
 *  @return ViewControllerClassString
 */
- (NSString *)visibleViewControllerClassString;

+ (UIWindow *)currentWindow;

@end
