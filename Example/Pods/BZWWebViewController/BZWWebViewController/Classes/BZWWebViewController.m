//
//  BZWWebViewController.m
//  BaoZhangWang
//
//  Created by 叶越悦 on 15/7/24.
//  Copyright (c) 2015年 BaoliNetworkTechnology. All rights reserved.
//

#import "BZWWebViewController.h"
#import <WebKit/WebKit.h>
#import "NSString+YYYAddition.h"
#import "BZWConstants.h"
#import "BZWMediator.h"

@interface BZWWebViewController () <WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIBarButtonItem *gobackButton;
@property (nonatomic, strong) UIBarButtonItem *closeButton; /**< 关闭 */
@property (nonatomic, strong) UIProgressView *progressView; /**< 进度条 */

@end

@implementation BZWWebViewController

+ (instancetype)viewController {
    return [self viewControllerWithParams:nil];
}

+ (instancetype)viewControllerWithParams:(NSDictionary *)params {
    BZWWebViewController *vc = [self new];
    NSString *urlString = params[@"url"];
    if (urlString) {
        vc.urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    } else {
        vc.HTMLString = params[@"HTML"];
    }
    
    if (vc.urlString == nil && vc.HTMLString == nil) {
        vc.urlString = @"www.bzw315.com";
    }
    NSString *title = params[@"title"];
    if (title) {
        vc.title = title;
        vc.showTitleFromWeb = NO;
    } else {
        vc.showTitleFromWeb = YES;
    }
    
    if (params[@"showTitleFromWeb"]) {
        vc.showTitleFromWeb = [params[@"showTitleFromWeb"] boolValue];
    }
    
    return vc;
}

- (instancetype)init {
    if (self = [super init]) {
        _showTitleFromWeb = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"hahaha";
    self.view.backgroundColor = [UIColor whiteColor];
//    self.navigationItem.leftBarButtonItem = self.gobackButton;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[kNavigationBarBackButtonImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarPressedHandle)];
    
    [self.navigationController.navigationBar addSubview:self.progressView];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    [self webViewLoadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [_webView removeObserver:self forKeyPath:@"title"];
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    return YES;
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    if ([error code] == NSURLErrorCancelled) {
        return;
    }
    NSString *message = error.localizedDescription? :error.domain;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:NULL];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self updateTitle];
    if (self.urlString.length > 0 && NSClassFromString(@"BZWShare")) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:kNavigationBarShareButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(shareHandle)];
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    WKFrameInfo *frameInfo = navigationAction.targetFrame;
    if (![frameInfo isMainFrame]) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        completionHandler();
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        completionHandler(YES);
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
        completionHandler(NO);
    }];
    [alertController addAction:confirmAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString *_Nullable))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"用户输入" message:@"输入框" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *_Nonnull textField) {
        textField.textColor = [UIColor redColor];
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        completionHandler([[alert.textFields lastObject] text]);
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
}

#pragma mark - private
- (void)webViewLoadData {
    self.progressView.progress = 0;
    if ([_urlString isKindOfClass:[NSString class]] && _urlString.length > 0) {
        _urlString = [_urlString trim];
        if (![[_urlString lowercaseString] hasPrefix:@"http://"] &&
            ![[_urlString lowercaseString] hasPrefix:@"https://"]) {
            _urlString = [NSString stringWithFormat:@"http://%@", _urlString];
        }
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
        [self.webView loadRequest:request];
    } else if ([_HTMLString isKindOfClass:[NSString class]] && _HTMLString.length > 0) {
        [self.webView loadHTMLString:_HTMLString baseURL:nil];
    }
}

- (void)updateTitle {
    if (self.showTitleFromWeb) {
        NSString *webTitle = self.webView.title;
        [self.webView evaluateJavaScript:@"document.getElementsByName('AppTitle')[0].content" completionHandler:^(id _Nullable title, NSError *_Nullable error) {
            [super setTitle:title? title:webTitle];
        }];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object != _webView) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }

    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        [self.progressView setAlpha:1.0f];
        BOOL animated = self.webView.estimatedProgress > self.progressView.progress;
        [self.progressView setProgress:self.webView.estimatedProgress animated:animated];
        if (self.webView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    } else if ([keyPath isEqualToString:@"title"]) {
        [self updateTitle];
    }
}

#pragma mark - event response

- (void)shareHandle {
    [self.view endEditing:YES];
    NSString *title = self.title;
    __block NSString *content = @"装修要保障，就上保障网！";
    __block NSString *logoUrl = @"";
    NSString *url = self.urlString;
    [self.webView evaluateJavaScript:@"document.getElementsByName('Description')[0].content" completionHandler:^(id _Nullable text, NSError *_Nullable error) {
        if (!error) {
            content = text;
        }

        [self.webView evaluateJavaScript:@"$(\"link[rel=sharing]\").attr(\"href\")" completionHandler:^(id _Nullable logo, NSError *_Nullable error) {
            if (!error) {
                logoUrl = logo;
            }

            id shareImage = logoUrl;
            if (![logoUrl isWebUrl]) {
                shareImage = kPlaceholderShareImage;
            }
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"title"] = title;
            params[@"content"] = content;
            params[@"image"] = shareImage;
            params[@"url"] = url;
            NSMutableDictionary *shareParams = [[BZWMediator shared] performTargetClassName:@"BZWShare" actionStringAndParam:@"shareParamWithParams:",params];
            [[BZWMediator shared] performTargetClassName:@"BZWShare" actionStringAndParam:@"showShareActionSheetWithShareParam:",shareParams];
        }];
    }];
}

- (void)leftBarPressedHandle {
    if ([_webView canGoBack]) {
        [_webView goBack];
        if ([self.navigationItem.leftBarButtonItems count] < 2) {
            self.navigationItem.leftBarButtonItems = @[self.gobackButton, self.closeButton];
        }
    } else {
        if (self.presentingViewController) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)closeButtonHandle {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - get, set

- (UIBarButtonItem *)gobackButton {
    if (!_gobackButton) {
        _gobackButton = [[UIBarButtonItem alloc] initWithImage:kNavigationBarBackButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(leftBarPressedHandle)];
    }
    return _gobackButton;
}

- (UIBarButtonItem *)closeButton {
    if (!_closeButton) {
        _closeButton = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeButtonHandle)];
    }
    return _closeButton;
}

- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    self.showTitleFromWeb = NO;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        CGFloat progressBarHeight = 1.f;
        CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
        CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
        _progressView.frame = barFrame;
        _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        _progressView.progressTintColor = kC101;
        _progressView.trackTintColor = [UIColor clearColor];
    }
    return _progressView;
}

- (WKWebView *)webView {
    if (!_webView) {
        //设置网页的配置文件
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        if (@available(iOS 9, *)) {
            //允许视频播放
            configuration.allowsAirPlayForMediaPlayback = YES;
        }
        // 允许可以与网页交互，选择视图
        configuration.selectionGranularity = WKSelectionGranularityCharacter;
        configuration.allowsInlineMediaPlayback = YES;
        // web内容处理池
        configuration.processPool = [[WKProcessPool alloc] init];
        //自定义配置,一般用于 js调用oc方法(OC拦截URL中的数据做自定义操作)
        WKUserContentController *UserContentController = [[WKUserContentController alloc] init];
        configuration.userContentController = UserContentController;
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        _webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
        _webView.allowsBackForwardNavigationGestures = YES;
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:_webView];
    }
    return _webView;
}

@end
