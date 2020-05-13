//
//  BZWConstants.h
//  BaoZhangWangiPad
//
//  Created by yyy on 15/12/14.
//  Copyright © 2015年 yyy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

FOUNDATION_EXPORT CGFloat const kBZWImageCornerRadius;/**< 图片圆角 */
FOUNDATION_EXPORT CGFloat const kBZWViewCornerRadius;/**< 圆角 */
FOUNDATION_EXPORT CGFloat const kBZWAspectRatio3_4;/**< 纵横比 3:4*/
FOUNDATION_EXPORT NSString *const kServiceTel;/**< 客服电话 */
FOUNDATION_EXPORT NSString *const kServiceQQ;/**< 客服QQ */
FOUNDATION_EXPORT NSString *const kAppChannel;/**< APP渠道 */
FOUNDATION_EXPORT NSString *const kBZWAppID;/**< AppID */

//推广链接
FOUNDATION_EXPORT NSString *const kUrlShareDownload;/**< 分享APP下载 */
FOUNDATION_EXPORT NSString *const kUrlFreeBidding;/**< 免费发布招标 */
FOUNDATION_EXTERN NSString *const kUrlEnterpriseGrade;/**< 装修公司评级 */
FOUNDATION_EXTERN NSString *const kUrlZhiNengBaoJia;/**< 智能报价 */
FOUNDATION_EXTERN NSString *const kUrlMFSJ;/**< 免费设计 */
FOUNDATION_EXPORT NSString *const kUrlFree;/**< 首页免费设计 */
FOUNDATION_EXPORT NSString *const kUrl8Reason;/**< 8大理由 */
FOUNDATION_EXPORT NSString *const kUrlZXSecurity;/**< 装修保 */
FOUNDATION_EXPORT NSString *const kUrlDeposit;/**< 装修保障金 */

//字体宏
#define kFontSizeWithPx(px) (px/2)

#define kF001 kFontSizeWithPx(36)
#define kF002 kFontSizeWithPx(32)
#define kF003 kFontSizeWithPx(30)
#define kF004 kFontSizeWithPx(28)
#define kF005 kFontSizeWithPx(26)
#define kF006 kFontSizeWithPx(24)
#define kF007 kFontSizeWithPx(22)
#define kF008 kFontSizeWithPx(20)
#define kF009 kFontSizeWithPx(18)
#define kF010 kFontSizeWithPx(40)
#define kF011 kFontSizeWithPx(46)
#define kF012 kFontSizeWithPx(54)
#define kF013 kFontSizeWithPx(44)

//颜色宏

#ifndef RGB
#define RGB(r, g, b) ([UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0])
#endif

#ifndef RGBA
#define RGBA(r, g, b, a) ([UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a])
#endif

#define kWhiteColor [UIColor whiteColor]
#define kWhiteColorA(a) RGBA(255,255,255,a)
#define kBlackColor [UIColor blackColor]
#define kBlackColorA(a) RGBA(0,0,0,a)
#define kDarkMaskColor kBlackColorA(.7)

#define kLogoBoardColor RGB(242,242,242)
#define kYellowColor RGB(247,193,32)
#define kLightGrayColor [UIColor lightGrayColor]
#define kGreenColor RGB(79, 212, 104)

#define kReturnWhiteColor [UIColor whiteColor]
#define kReturnBlackColor kC006
#define kReturnLoginColor RGB(211, 211, 211)

#define kShadowColor RGB(228, 228, 228)
#define kSeparatorWidth 1.f / [UIScreen mainScreen].scale
#define kSeparator_Offset ((1.f/[UIScreen mainScreen].scale) / 2.f)

#define kBackgroundColor kC013
#define kSeparatorColor kC010

#define kC001 RGB(0,0,0)  //FFF
#define kC002 RGB(51,51,51)//333
#define kC003 RGB(85,85,85)//555
#define kC004 RGB(102,102,102)//666
#define kC005 RGB(153,153,153)//999
#define kC006 RGB(74,74,74)//4A4A
#define kC007 RGB(178,178,178)//B2B2
#define kC008 RGB(204,204,204)//CCC
#define kC009 RGB(250,250,250)//FAFA
#define kC010 RGB(228,228,228)//E4E4
#define kC011 RGB(255,255,255)//FFF
#define kC012 RGB(250,247,247)//FAF7
#define kC013 RGB(246,243,243)//F6F3
#define kC101 RGB(255,52,49)
#define kC102 RGB(255,85,82)
#define kC103 RGB(255,153,151)
#define kC104 RGB(136,223,116)
#define kC105 RGB(242,188,118)
#define kC106 RGB(250,204,91)
#define kC107 RGB(154,184,207)
#define kC108 RGB(252,55,57)
#define kC108 RGB(252,55,57)
#define kC109 RGB(126,109,131)
#define kC110 RGB(255,243,246)
#define kC111 RGB(181,83,237)

//占位图
#define kPlaceholderImage750x750 [UIImage imageNamed:@"BZWConstants.bundle/750-750"] /**< 1 */
#define kPlaceholderImage750x560 [UIImage imageNamed:@"BZWConstants.bundle/750-560"] /**< 1.33 */
#define kPlaceholderImage750x375 [UIImage imageNamed:@"BZWConstants.bundle/750-375"] /**< 2 */
#define kPlaceholderImage750x320 [UIImage imageNamed:@"BZWConstants.bundle/750-320"] /**< 2.34 */
#define kPlaceholderImage750x180 [UIImage imageNamed:@"BZWConstants.bundle/750-180"] /**< 4.1 */
#define kPlaceholderImage240x240 [UIImage imageNamed:@"BZWConstants.bundle/240-240"] /**< 1 */

#define kPlaceholderShareImage [UIImage imageNamed:@"BZWConstants.bundle/bzw_share_image"] /**< 分享默认图片 */
#define kNavigationBarBackButtonImage [UIImage imageNamed:@"BZWConstants.bundle/btn_top_back"]
#define kNavigationBarShareButtonImage [UIImage imageNamed:@"BZWConstants.bundle/icon_med01_05"]


typedef NS_ENUM(NSInteger, BZWClassType) {
    BZWClassTypeCase = 0,      /**< 案例 */
    BZWClassTypeNews = 1,      /**< 新闻 */
    BZWClassTypeProducts = 2,  /**< 产品 */
    BZWClassTypeActivityOrder = 3,/**< 订单 */
    BZWClassTypePersonal = 4,  /**< 用户 */
    BZWClassTypeDesigner = 5,  /**< 设计师 */
    BZWClassTypeCompany = 6,   /**< 企业 */
    BZWClassTypeBuilding = 7,
    BZWClassTypeBuilded = 8,
    BZWClassTypeDiary = 9,     /**< 日记 */
    BZWClassTypeVideo = 10,     /**< 视频 */
    BZWClassTypeLive = 11,      /**< 直播 */
    BZWClassTypeComment = 12,   /**< 评论 */
    BZWClassTypeENTCoupons = 13,/**< 企业优惠活动 */
    //    ClassTypeBaike = 10,     /**< 百科 */
    BZWClassTypeCase_Enterprise = 14,/**< 企业案例 */
    BZWClassTypeCase_MeiTu = 15,/**< 美图 */
    BZWClassTypeCase_QuanWu = 16,/**< 全屋 */
    BZWClassTypeAll = 1000,/**< 全部 */
};

typedef NS_ENUM(NSUInteger, BZWSystemModel) {
    kBZWSystemModelAll = 0,   /**< 全部 */
    kBZWSystemModelNews = 1,  /**< 新闻 */
    kBZWSystemModelCase,      /**< 案例 */
    kBZWSystemModelBaike,     /**< 百科 */
    kBZWSystemModelDesigner,  /**< 设计师 */
    kBZWSystemModelPersonal,  /**< 用户 */
    kBZWSystemModelEnterprise,   /**< 企业 */
    kBZWSystemModelProducts,  /**< 产品 */
    kBZWSystemModelOrder,/**< 订单 */
    kBZWSystemModelDiary,     /**< 日记 */
    kBZWSystemModelVideo,     /**< 视频 */
    kBZWSystemModelLive,      /**< 直播 */
    kBZWSystemModelComment,   /**< 评论 */
};

typedef NS_ENUM(NSUInteger, UserClient) {
    UserClientBZW315_WEB = 1001,
    UserClientBZW315_MOBILE = 1002,
    UserClientBZW315_APP_IOS = 1003,
    UserClientBZW315_APP_ANDROID = 1004,
    UserClientBaike_WEB = 1005,
    UserClientBZW315_APP_Diary_IOS = 1006,
    UserClientBZW315_APP_Diary_ANDROID = 1007,
    UserClientBZW315_APP_CALCULATOR_IOS = 1008,
    UserClientBZW315_APP_CALCULATOR_ANDROID = 1009,
    
    UserClientSHEJIQUAN_WEB = 2001,
    UserClientSHEJIQUAN_MOBILE,
    UserClientSHEJIQUAN_APP_IOS,
    UserClientSHEJIQUAN_APP_ANDROID,
};

typedef NS_ENUM(NSUInteger, NewsListClassID) {
    NewsListClassIDBenefits = 398, /**< 优惠 */
    NewsListClassIDInfo = 399, /**< 资讯 */
    NewsListClassIDProcess = 535,/**< 装修流程535 */
    NewsListClassIDMaterial = 1010,/**< 选材1010 */
    NewsListClassIDGeomancy = 1012,/**< 风水1012 */
    NewsListClassIDActivity = 3078,/**< 热门活动 */
};

typedef NS_ENUM(NSUInteger, PersonalUpdateEnum) {
    kPersonalUpdateEnumLogo = 1,
    kPersonalUpdateEnumNikeName,
    kPersonalUpdateEnumSex,
    kPersonalUpdateEnumCity
};


/**
 请求数据为空的状态

 - BZWNoDataStatusDefault: 默认
 - BZWNoDataStatusSearch: 搜索
 - BZWNoDataStatusOrder: 订单
 - BZWNoDataStatusFavorite: 收藏
 - BZWNoDataStatusMessage: 消息
 - BZWNoDataStatusCoupons: 优惠活动
 - BZWNoDataStatusDelete: 数据已被删除
 - BZWNoDataStatusNoEnterprise: 未派装修公司
 - BZWNoDataStatusNoAlbumRights: 无相册权限
 */
typedef NS_ENUM(NSUInteger, BZWNoDataStatus) {
    BZWNoDataStatusDefault,
    BZWNoDataStatusSearch,
    BZWNoDataStatusOrder,
    BZWNoDataStatusFavorite,
    BZWNoDataStatusMessage,
    BZWNoDataStatusCoupons,
    BZWNoDataStatusDelete,
    BZWNoDataStatusNoEnterprise,
    BZWNoDataStatusNoAlbumRights,
};
