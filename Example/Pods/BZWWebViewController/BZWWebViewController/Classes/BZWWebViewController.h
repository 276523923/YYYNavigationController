//
//  BZWWebViewController.h
//  BaoZhangWang
//
//  Created by 叶越悦 on 15/7/24.
//  Copyright (c) 2015年 BaoliNetworkTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BZWWebViewController : UIViewController

@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSString *HTMLString;/**< 加载HTML */
@property (nonatomic) BOOL showTitleFromWeb; // 是否从页面中获取标题

+ (instancetype)viewController;


/**
 param keys
 title , self.title = param[@"title"]; 设置这个会将 self.showTitleFromWeb = NO;
 url , self.urlString = param[@"url"];
 HTML , self.HTMLString = param[@"HML"];
 showTitleFromWeb , self.showTitleFromWeb = [param[@"showTitleFromWeb"] boolValue];

 @param params 参数
 @return BZWWebViewController
 */
+ (instancetype)viewControllerWithParams:(NSDictionary *)params;

@end
