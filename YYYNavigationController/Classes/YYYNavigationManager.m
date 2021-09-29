//
//  YYYNavigationManager.m
//  YYYNavigationBarTransition
//
//  Created by yyy on 2018/11/29.
//  Copyright © 2018 yyy. All rights reserved.
//

#import "YYYNavigationManager.h"

@interface YYYNavigationManager ()

@property (nonatomic) BOOL hasSetDarkBackgroundImage;
@property (nonatomic) BOOL hasSetDarkShadowImage;

@end

@implementation YYYNavigationManager
static YYYNavigationManager *globalManager__ = nil;

- (instancetype)init {
    self = [super init];
    if (self) {
        UINavigationBar *appearance = [UINavigationBar appearance];
        self.barStyle = appearance.barStyle;
        self.translucent = appearance.isTranslucent;
        self.translucent = YES;
        self.tintColor = appearance.tintColor;
        self.barTintColor = appearance.barTintColor;
        self.backgroundImage = [appearance backgroundImageForBarMetrics:UIBarMetricsDefault];
        self.shadowImage = appearance.shadowImage;
        self.titleTextAttributes = appearance.titleTextAttributes;
        self.hiddenNavigationBar = NO;
    }
    return self;
}

+ (instancetype)globalManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        globalManager__ = [YYYNavigationManager new];
    });
    return globalManager__;
}

- (NSUInteger)hash {
    if (@available(iOS 13, *)) {
        return [self.tintColor hash] ^ [self.barTintColor hash] ^ [self.backgroundImage hash] ^ [self.shadowImage hash] ^ [@(self.hiddenNavigationBar) hash] ^[self.darkShadowImage hash] ^ [self.darkBackgroundImage hash];
    } else {
        return [self.tintColor hash] ^ [self.barTintColor hash] ^ [self.backgroundImage hash] ^ [self.shadowImage hash] ^ [@(self.hiddenNavigationBar) hash];
    }
}

- (BOOL)isEqual:(YYYNavigationManager *)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isMemberOfClass:YYYNavigationManager.class]) {
        return NO;
    }
    
    if (object.hash != self.hash) {
        return NO;
    }
    return [self.tintColor isEqual:object.tintColor] && [self.barTintColor isEqual:object.barTintColor] && [self.backgroundImage isEqual:object.backgroundImage] && [self.shadowImage isEqual:object.shadowImage] && self.hiddenNavigationBar == object.hiddenNavigationBar;
    
}

- (void)reloadNavigationBarStyle {
    if (self.isShow && self.viewController && self.viewController.navigationController.navigationBar &&
        self.viewController.navigationController != self.viewController) {
        [self updateStyleToNavigationBar:self.viewController.navigationController.navigationBar];
    }
}

- (void)updateStyleToNavigationBar:(UINavigationBar *)navigationBar {
    if (!navigationBar) {
        return;
    }
    navigationBar.barStyle = self.barStyle;
    navigationBar.translucent = self.isTranslucent;
    navigationBar.barTintColor = self.barTintColor;
    navigationBar.tintColor = self.tintColor;
    if (@available(iOS 13, *)) {
        BOOL isDarkStyle = self.viewController.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark;
        if (self.hasSetDarkBackgroundImage && isDarkStyle) {
            [navigationBar setBackgroundImage:self.darkBackgroundImage forBarMetrics:UIBarMetricsDefault];
        } else {
            [navigationBar setBackgroundImage:self.backgroundImage forBarMetrics:UIBarMetricsDefault];
        }
        
        if (self.hasSetDarkShadowImage && isDarkStyle) {
            navigationBar.shadowImage = self.darkShadowImage;
        } else {
            navigationBar.shadowImage = self.shadowImage;
        }
    } else {
        navigationBar.shadowImage = self.shadowImage;
        [navigationBar setBackgroundImage:self.backgroundImage forBarMetrics:UIBarMetricsDefault];
    }
    
    navigationBar.titleTextAttributes = self.titleTextAttributes;

    if (@available(iOS 15, *)) {
        BOOL isDarkStyle = self.viewController.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark;
        navigationBar.standardAppearance.backgroundImage = self.backgroundImage;
        navigationBar.standardAppearance.shadowImage = self.shadowImage;
        navigationBar.standardAppearance.backgroundColor = self.barTintColor;
        navigationBar.standardAppearance.titleTextAttributes = self.titleTextAttributes;
        
        navigationBar.scrollEdgeAppearance.backgroundImage = self.backgroundImage;
        navigationBar.scrollEdgeAppearance.shadowImage = self.shadowImage;
        navigationBar.scrollEdgeAppearance.backgroundColor = self.barTintColor;
        navigationBar.scrollEdgeAppearance.titleTextAttributes = self.titleTextAttributes;
        
        if (isDarkStyle && self.hasSetDarkBackgroundImage) {
            navigationBar.standardAppearance.backgroundImage = self.darkBackgroundImage;
            navigationBar.scrollEdgeAppearance.backgroundImage = self.darkBackgroundImage;
        }
        
        if (isDarkStyle && self.hasSetDarkShadowImage) {
            navigationBar.standardAppearance.shadowImage = self.darkShadowImage;
            navigationBar.scrollEdgeAppearance.shadowImage = self.darkShadowImage;
        }
    }
}

- (BOOL)needUpdateNavigationBar {
    return self.isShow && self.viewController && self.viewController.navigationController.navigationBar && self.viewController != self.viewController.navigationController;
}

#pragma mark - Set
- (void)setBarStyle:(UIBarStyle)barStyle {
    _barStyle = barStyle;
    if ([self needUpdateNavigationBar]) {
        self.viewController.navigationController.navigationBar.barStyle = barStyle;
    }
}

- (void)setTranslucent:(BOOL)translucent {
    _translucent = translucent;
    if ([self needUpdateNavigationBar]) {
        self.viewController.navigationController.navigationBar.translucent = translucent;
    }
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    _backgroundImage = backgroundImage;
    if ([self needUpdateNavigationBar]) {
        [self.viewController.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
        if (@available(iOS 15, *)) {
            self.viewController.navigationController.navigationBar.standardAppearance.backgroundImage = backgroundImage;
            self.viewController.navigationController.navigationBar.scrollEdgeAppearance.backgroundImage = backgroundImage;
        }
    }
}

- (void)setShadowImage:(UIImage *)shadowImage {
    _shadowImage = shadowImage;
    if ([self needUpdateNavigationBar]) {
        self.viewController.navigationController.navigationBar.shadowImage = shadowImage;
        if (@available(iOS 15, *)) {
            self.viewController.navigationController.navigationBar.standardAppearance.shadowImage = shadowImage;
            self.viewController.navigationController.navigationBar.scrollEdgeAppearance.shadowImage = shadowImage;
        }
    }
}

- (void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
    if (_tintColor == nil) {
        _tintColor = [UINavigationBar appearance].tintColor;
    }
    if ([self needUpdateNavigationBar]) {
        self.viewController.navigationController.navigationBar.tintColor = tintColor;
    }
}

- (void)setBarTintColor:(UIColor *)barTintColor {
    _barTintColor = barTintColor;
    if ([self needUpdateNavigationBar]) {
        self.viewController.navigationController.navigationBar.barTintColor = barTintColor;
        if (@available(iOS 15, *)) {
            self.viewController.navigationController.navigationBar.standardAppearance.backgroundColor = barTintColor;
            self.viewController.navigationController.navigationBar.scrollEdgeAppearance.backgroundColor = barTintColor;
        }
    }
}

- (void)setHiddenNavigationBar:(BOOL)hiddenNavigationBar {
    [self setNavigationBarHidden:hiddenNavigationBar animated:NO];
}

- (void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated {
    _hiddenNavigationBar = hidden;
    if ([self needUpdateNavigationBar] && self.viewController.navigationController.isNavigationBarHidden != hidden) {
        [self.viewController.navigationController setNavigationBarHidden:hidden animated:animated];
    }
}

- (void)setTitleTextAttributes:(NSDictionary<NSAttributedStringKey,id> *)titleTextAttributes {
    _titleTextAttributes = [titleTextAttributes copy];
    if ([self needUpdateNavigationBar]) {
        self.viewController.navigationController.navigationBar.titleTextAttributes = titleTextAttributes;
        if (@available(iOS 15, *)) {
            self.viewController.navigationController.navigationBar.standardAppearance.titleTextAttributes = titleTextAttributes;
            self.viewController.navigationController.navigationBar.scrollEdgeAppearance.titleTextAttributes = titleTextAttributes;
        }
    }
}

- (void)setDarkShadowImage:(UIImage *)darkShadowImage {
    self.hasSetDarkShadowImage = YES;
    _darkShadowImage = darkShadowImage;
    if ([self needUpdateNavigationBar]) {
        self.viewController.navigationController.navigationBar.shadowImage = darkShadowImage;
    }
}

- (void)setDarkBackgroundImage:(UIImage *)darkBackgroundImage {
    self.hasSetDarkBackgroundImage = YES;
    _darkBackgroundImage = darkBackgroundImage;
    if ([self needUpdateNavigationBar]) {
        [self.viewController.navigationController.navigationBar setBackgroundImage:darkBackgroundImage forBarMetrics:UIBarMetricsDefault];
    }
}
#pragma mark - NSCopying, NSMutableCopying
- (id)copyWithZone:(NSZone *)zone {
    YYYNavigationManager *manager = [[self.class allocWithZone:zone] init];
    manager.barStyle = self.barStyle;
    manager.translucent = self.isTranslucent;
    manager.backgroundImage = self.backgroundImage;
    manager.shadowImage = self.shadowImage;
    manager.tintColor = self.tintColor;
    manager.barTintColor = self.barTintColor;
    manager.hiddenNavigationBar = self.hiddenNavigationBar;
    manager.titleTextAttributes = self.titleTextAttributes;
    if (@available(iOS 13, *)) {
        if (self.hasSetDarkShadowImage) {
            manager.darkShadowImage = self.darkShadowImage;
        }
        if (self.hasSetDarkBackgroundImage) {
            manager.darkBackgroundImage = self.darkBackgroundImage;
        }
    }
    return manager;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [self copyWithZone:zone];
}

#if DEBUG
- (NSString *)description {
    NSMutableString *string = [NSMutableString string];
    [string appendFormat:@"%@:{\n",self.class];
    [string appendFormat:@"    barStyle:%@\n",@(self.barStyle)];
    [string appendFormat:@"    translucent:%@\n",@(self.isTranslucent)];
    [string appendFormat:@"    backgroundImage:%@\n",self.backgroundImage];
    [string appendFormat:@"    shadowImage:%@\n",self.shadowImage];
    [string appendFormat:@"    tintColor:%@\n",self.tintColor];
    [string appendFormat:@"    barTintColor:%@\n",self.barTintColor];
    [string appendFormat:@"    hiddenNavigationBar:%@\n",@(self.hiddenNavigationBar)];
    [string appendFormat:@"    titleTextAttributes:%@\n",self.titleTextAttributes];
    [string appendString:@"}"];
    return string;
}

- (NSString *)debugDescription {
    return [self description];
}
#endif
@end
