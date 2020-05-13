//
//  NSString+Addition.m
//  BossmailQ
//
//  Created by 李 磊磊 on 12-10-30.
//  Copyright (c) 2012年 zzy. All rights reserved.
//

#import "NSString+YYYAddition.h"
#import <CommonCrypto/CommonDigest.h>
#import <CoreFoundation/CoreFoundation.h>

@implementation NSString (YYYAddition)

#pragma mark - others

//判断是否时整形
- (BOOL)isPureInt {
    NSScanner *scan = [NSScanner scannerWithString:self];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点形
- (BOOL)isPureFloat {
    NSScanner *scan = [NSScanner scannerWithString:self];
    double val;
    return [scan scanDouble:&val] && [scan isAtEnd];
}

//分割字符串
- (NSArray *)splitWithString:(NSString *)y {
    return [self componentsSeparatedByString:y];
}

//去掉首尾空白符
- (NSString *)trim {
    NSCharacterSet *seperator = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *y = [self stringByTrimmingCharactersInSet:seperator];
    return y;
}

//校验用户邮箱格式，调用之前需要去掉首尾空白
- (BOOL)isEmail {
    return [self isMatchedByPattern:@"^[\\w-]+(\\.[\\w-]+)*@([\\w-]+\\.)+[a-zA-Z]+$"];
}

/**
 *	判断是否手机号码
 *
 *	@return BOOL
 */
- (BOOL)isMobile {
    NSString *reg = @"^(13|14|15|16|17|18|19)\\d{9}$";
    NSRegularExpression *regEx = [NSRegularExpression regularExpressionWithPattern:reg options:NSRegularExpressionAnchorsMatchLines error:nil];
    NSUInteger numberofMatch = [regEx numberOfMatchesInString:self
        options:NSMatchingReportProgress
        range:NSMakeRange(0, self.length)];

    if (numberofMatch > 0) {
        return YES;
    }

    return NO;
}

//判断是否包含sub字符串
- (BOOL)isContainString:(NSString *)sub {
    if (@available(iOS 8, *)) {
        return [self containsString:sub];
    } else {
        NSRange nsr = [self rangeOfString:sub];
        if (nsr.location == NSNotFound) {
            return NO;
        }
        return YES;
    }
}

//去掉sub字符串
- (NSString *)stringByDeletingString:(NSString *)sub {
    return [self stringByReplacingOccurrencesOfString:sub withString:@""];
}

#pragma mark - MD5 -

//md5
- (NSString *)md5 {
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG) strlen(cStr), result);
    NSString *md5String = [NSString stringWithFormat:
        @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
        result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
        result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
    ];
    return [md5String uppercaseString];
}

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
- (BOOL)isMatchedByPattern:(NSString *)pattern {
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
    return [expression numberOfMatchesInString:self options:0 range:NSMakeRange(0, self.length)] > 0;
}

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
- (CGSize)yyy_sizeWithFont:(UIFont *)font {
    return [self yyy_sizeWithFont:font constrainedToSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
}

- (CGSize)yyy_sizeWithFont:(UIFont *)font forWidth:(CGFloat)width {
    return [self yyy_sizeWithFont:font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
}

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
- (CGSize)yyy_sizeWithFont:(UIFont *)font forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode {
    return [self yyy_sizeWithFont:font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:lineBreakMode];
}

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
- (CGSize)yyy_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size {
    return [self yyy_sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
}

/**
 *  @author 陈圣治, 2015-03-19 11:29:08
 *
 *  计算文字占用的CGSize
 *
 *  @param font          字体
 *  @param size         最大宽度高度
 *  @param lineBreakMode 换行方式
 *
 *  @return CGSize
 */
- (CGSize)yyy_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode {
    return [self yyy_sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode maxLine:0];
}

- (CGSize)yyy_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode maxLine:(NSUInteger)line {
    if (!font) {
        return CGSizeZero;
    }
    NSMutableParagraphStyle *para = [[NSMutableParagraphStyle alloc] init];
    para.lineBreakMode = lineBreakMode;
    CGSize rsize = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: font,NSParagraphStyleAttributeName: para} context:nil].size;
    if (line > 0) {
        rsize.height = MIN(rsize.height, font.lineHeight * line);
    }
    rsize.width = ceil(rsize.width);
    rsize.height = ceil(rsize.height);
    return rsize;
}

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
- (void)yyy_drawAtPoint:(CGPoint)point withFont:(UIFont *)font textColor:(UIColor *)textColor {
    [self drawAtPoint:point withAttributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName: textColor}];
}

#pragma mark - 拼音 -

- (NSString *)URLEncodedString {
    NSString *encodedString = (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef) self, (CFStringRef) @"!$&'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
    return encodedString;
}

- (BOOL)isWebUrl {
    return [self isMatchedByPattern:@"([\\w\\d]+\\.)+\\w{2,}(\\/[\\d\\w\\.\\?=&]+)*"];
}

- (NSArray *)arrayOfCaptureComponentsMatchedByRegexString:(NSString *)regexString {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexString options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *arr = [regex matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    NSMutableArray *marray = [NSMutableArray array];
    for (NSTextCheckingResult *match in arr) {
        NSString *substringForMatch = [self substringWithRange:match.range];
        [marray addObject:substringForMatch];
    }
    return marray;
}

/**
 *  @brief  清除html标签
 *
 *  @return 清除后的结果
 */
- (NSString *)stringByStrippingHTML {
    return [self stringByReplacingOccurrencesOfString:@"<[^>]+>" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, self.length)];
}

/**
 *  @brief  清除js脚本
 *
 *  @return 清楚js后的结果
 */
- (NSString *)stringByRemovingScripts {
    NSMutableString *mString = [self mutableCopy];
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<script[^>]*?>[\\s\\S]*?</script>" options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *matches = [regex matchesInString:mString options:NSMatchingReportProgress range:NSMakeRange(0, [mString length])];
    for (NSTextCheckingResult *match in [matches reverseObjectEnumerator]) {
        [mString replaceCharactersInRange:match.range withString:@""];
    }
    return mString;
}

+ (NSString *)urlParametersStringFromParameters:(NSDictionary *)parameters {
    if (parameters && [parameters isKindOfClass:[NSDictionary class]]) {
        NSMutableArray *paramArray = [NSMutableArray array];
        [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
            if ([obj isKindOfClass:[NSString class]]) {
                //转码，避免中文乱码
                [paramArray addObject:[NSString stringWithFormat:@"%@=%@", key, [(NSString *) obj stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
            } else {
                [paramArray addObject:[NSString stringWithFormat:@"%@=%@", key, obj]];
            }
        }];
        return [paramArray componentsJoinedByString:@"&"];
    }
    return @"";
}


/**
 *  @author 叶越悦, 15-04-16 15:12:54
 *
 *  字符串转模糊搜索Sql条件
 *
 *  @return sql条件
 */
- (NSString *)fixSearchPinYinString {
    NSArray *pinyin = @[@"a",@"ai",@"an",@"ang",@"ao",@"ba",@"bai",@"ban",@"bang",@"bao",@"bei",@"ben",@"beng",@"bi",@"bian",@"biao",@"bie",@"bin",@"bing",@"bo",@"bu",@"ca",@"cai",@"can",@"cang",@"cao",@"ce",@"ceng",@"cha",@"chai",@"chan",@"chang",@"chao",@"che",@"chen",@"cheng",@"chi",@"chong",@"chou",@"chu",@"chuai",@"chuan",@"chuang",@"chui",@"chun",@"chuo",@"ci",@"cong",@"cou",@"cu",@"cuan",@"cui",@"cun",@"cuo",@"da",@"dai",@"dan",@"dang",@"dao",@"de",@"deng",@"di",@"dian",@"diao",@"die",@"ding",@"diu",@"dong",@"dou",@"du",@"duan",@"dui",@"dun",@"duo",@"e",@"en",@"er",@"fa",@"fan",@"fang",@"fei",@"fen",@"feng",@"fo",@"fou",@"fu",@"ga",@"gai",@"gan",@"gang",@"gao",@"ge",@"gei",@"gen",@"geng",@"gong",@"gou",@"gu",@"gua",@"guai",@"guan",@"guang",@"gui",@"gun",@"guo",@"ha",@"hai",@"han",@"hang",@"hao",@"he",@"hei",@"hen",@"heng",@"hong",@"hou",@"hu",@"hua",@"huai",@"huan",@"huang",@"hui",@"hun",@"huo",@"ji",@"jia",@"jian",@"jiang",@"jiao",@"jie",@"jin",@"jing",@"jiong",@"jiu",@"ju",@"juan",@"jue",@"jun",@"ka",@"kai",@"kan",@"kang",@"kao",@"ke",@"ken",@"keng",@"kong",@"kou",@"ku",@"kua",@"kuai",@"kuan",@"kuang",@"kui",@"kun",@"kuo",@"la",@"lai",@"lan",@"lang",@"lao",@"le",@"lei",@"leng",@"li",@"lia",@"lian",@"liang",@"liao",@"lie",@"lin",@"ling",@"liu",@"long",@"lou",@"lu",@"lv",@"luan",@"lue",@"lun",@"luo",@"ma",@"mai",@"man",@"mang",@"mao",@"me",@"mei",@"men",@"meng",@"mi",@"mian",@"miao",@"mie",@"min",@"ming",@"miu",@"mo",@"mou",@"mu",@"na",@"nai",@"nan",@"nang",@"nao",@"ne",@"nei",@"nen",@"neng",@"ni",@"nian",@"niang",@"niao",@"nie",@"nin",@"ning",@"niu",@"nong",@"nu",@"nv",@"nuan",@"nue",@"nuo",@"o",@"ou",@"pa",@"pai",@"pan",@"pang",@"pao",@"pei",@"pen",@"peng",@"pi",@"pian",@"piao",@"pie",@"pin",@"ping",@"po",@"pu",@"qi",@"qia",@"qian",@"qiang",@"qiao",@"qie",@"qin",@"qing",@"qiong",@"qiu",@"qu",@"quan",@"que",@"qun",@"ran",@"rang",@"rao",@"re",@"ren",@"reng",@"ri",@"rong",@"rou",@"ru",@"ruan",@"rui",@"run",@"ruo",@"sa",@"sai",@"san",@"sang",@"sao",@"se",@"sen",@"seng",@"sha",@"shai",@"shan",@"shang",@"shao",@"she",@"shen",@"sheng",@"shi",@"shou",@"shu",@"shua",@"shuai",@"shuan",@"shuang",@"shui",@"shun",@"shuo",@"si",@"song",@"sou",@"su",@"suan",@"sui",@"sun",@"suo",@"ta",@"tai",@"tan",@"tang",@"tao",@"te",@"teng",@"ti",@"tian",@"tiao",@"tie",@"ting",@"tong",@"tou",@"tu",@"tuan",@"tui",@"tun",@"tuo",@"wa",@"wai",@"wan",@"wang",@"wei",@"wen",@"weng",@"wo",@"wu",@"xi",@"xia",@"xian",@"xiang",@"xiao",@"xie",@"xin",@"xing",@"xiong",@"xiu",@"xu",@"xuan",@"xue",@"xun",@"ya",@"yan",@"yang",@"yao",@"ye",@"yi",@"yin",@"ying",@"yo",@"yong",@"you",@"yu",@"yuan",@"yue",@"yun",@"za",@"zai",@"zan",@"zang",@"zao",@"ze",@"zei",@"zen",@"zeng",@"zha",@"zhai",@"zhan",@"zhang",@"zhao",@"zhe",@"zhen",@"zheng",@"zhi",@"zhong",@"zhou",@"zhu",@"zhua",@"zhuai",@"zhuan",@"zhuang",@"zhui",@"zhun",@"zhuo",@"zi",@"zong",@"zou",@"zu",@"zuan",@"zui",@"zun",@"zuo"];
    
    NSString *string = [self lowercaseString];
    NSUInteger searchIndex = 0;
    NSUInteger length = string.length;
    NSString *newString = @"";
    while (searchIndex < length && string.length > 0) {
        NSUInteger len = string.length > 6 ? 6 : string.length;
        NSUInteger index = 0;
        NSString *searchString = [string substringToIndex:len];
        
        while (1) {
            index = [pinyin indexOfObject:searchString];
            if (index != NSNotFound || searchString.length == 1) {
                break;
            } else {
                len--;
                searchString = [searchString substringToIndex:len];
            }
        }
        newString = [newString stringByAppendingString:[searchString stringByAppendingString:@"*"]];
        string = [string substringFromIndex:len];
        searchIndex = len;
    }
    if (string.length > 0) {
        return [newString stringByAppendingFormat:@"%@*", string];
    } else {
        return newString;
    }
}

@end
