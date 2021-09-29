//
//  TestTableViewController.h
//  QMUINavigationBarTransition
//
//  Created by yyy on 2018/11/26.
//  Copyright © 2018 yyy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, NavigationBarStyle) {
    NavigationBarStyleOrigin,
    NavigationBarStyleLight,
    NavigationBarStyleDark,
    NavigationBarStyleRed,
    NavigationBarStyleHidden,
    NavigationBarStyleHiddenWhenScroll
};


@interface TestTableViewController : UITableViewController

@property(nonatomic, assign) BOOL customNavBarTransition;
- (instancetype)initWithBarStyle:(NavigationBarStyle)barStyle;

@end

