//
//  NSString+Addition.h
//  BossmailQ
//
//  Created by 李 磊磊 on 12-10-30.
//  Copyright (c) 2012年 zzy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (YYYAddition)

#pragma mark - 判断
//判断是否时整形
- (BOOL)isPureInt;

//判断是否为浮点形
- (BOOL)isPureFloat;
/**
 校验用户邮箱格式，调用之前需要去掉首尾空白
 */
- (BOOL)isEmail;
/**
 *  判断是否网页链接
 */
- (BOOL)isWebUrl;
/**
 *	判断是否手机号码
 */
- (BOOL)isMobile;

//分割字符串
- (NSArray *)splitWithString:(NSString *)y;
//去掉首尾空白符
- (NSString *)trim;
//判断是否包含sub字符串
- (BOOL)isContainString:(NSString *)sub;

//去掉sub字符串
- (NSString *)stringByDeletingString:(NSString *)sub;

#pragma mark - MAC MD5 -

//md5
- (NSString *)md5;

#pragma mark - 正则表达式 -
/**
 *  @author 陈圣治, 2015-03-16 11:41:47
 *
 *  是否匹配正则表达式
 *
 *  @param pattern 正则
 *
 *  @return BOOL
 */
- (BOOL)isMatchedByPattern:(NSString *)pattern;

#pragma mark - 计算字符串占用的CGSize -
/**
 *  @author 陈圣治, 2015-03-19 11:29:08
 *
 *  计算文字占用的CGSize, 当行不限制宽度
 *
 *  @param font          字体
 *
 *  @return CGSize
 */
- (CGSize)yyy_sizeWithFont:(UIFont *)font;

/**
 *  计算文字占用的CGSize
 *
 *  @param font  字体
 *  @param width 最大宽度
 *
 *  @return CGSize
 */
- (CGSize)yyy_sizeWithFont:(UIFont *)font forWidth:(CGFloat)width;

/**
 *  @author 陈圣治, 2015-03-19 11:29:08
 *
 *  计算文字占用的CGSize
 *
 *  @param font          字体
 *  @param width         最大宽度
 *  @param lineBreakMode 换行方式
 *
 *  @return CGSize
 */
- (CGSize)yyy_sizeWithFont:(UIFont *)font forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode;

/**
 *  @author 陈圣治, 2015-03-19 11:29:39
 *
 *  计算文字占用的CGSize, 换行方式为 NSLineBreakModeWordWrap
 *
 *  @param font 字体
 *  @param size 最大宽度高度
 *
 *  @return CGSize
 */
- (CGSize)yyy_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

/**
 *  @author 陈圣治, 2015-03-19 11:29:08
 *
 *  计算文字占用的CGSize
 *
 *  @param font         字体
 *  @param size         最大宽度高度
 *  @param lineBreakMode 换行方式
 *
 *  @return CGSize
 */
- (CGSize)yyy_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;

- (CGSize)yyy_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode maxLine:(NSUInteger)line;

#pragma mark - 绘制方法 -
/**
 *  @author 陈圣治, 2015-03-19 14:28:08
 *
 *  绘制字符串
 *
 *  @param point    坐标
 *  @param font     字体
 *  @param textColor 颜色
 */
- (void)yyy_drawAtPoint:(CGPoint)point withFont:(UIFont *)font textColor:(UIColor *)textColor;

/**
 *  中文字符转URLENCODE
 *
 *  @author 叶越悦, 15-01-27 18:01:38
 *
 *  @return urlString
 */
- (NSString *)URLEncodedString;

- (NSArray *)arrayOfCaptureComponentsMatchedByRegexString:(NSString *)regexString;

/**
 *  @brief  清除html标签
 *
 *  @return 清除后的结果
 */
- (NSString *)stringByStrippingHTML;
/**
 *  @brief  清除js脚本
 *
 *  @return 清楚js后的结果
 */
- (NSString *)stringByRemovingScripts;

/**
 *  @author 叶越悦, 15-04-16 15:12:54
 *
 *  字符串转模糊搜索Sql条件
 *
 *  @return sql条件
 */
- (NSString *)fixSearchPinYinString;

/**
 *  URL参数转换
 *  @param parameters 参数
 */
+ (NSString *)urlParametersStringFromParameters:(NSDictionary *)parameters;

@end
