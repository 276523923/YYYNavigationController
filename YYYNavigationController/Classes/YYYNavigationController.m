//
//  YYYNavigationController.m
//  YYYNavigationBarTransition
//
//  Created by yyy on 2018/11/29.
//  Copyright © 2018 yyy. All rights reserved.
//

#import "YYYNavigationController.h"
#import "YYYNavigationManager.h"
#import <objc/runtime.h>

@interface YYY_Transition_NavigationBar : UINavigationBar
@end

@implementation YYY_Transition_NavigationBar

/**
 自己创建的navigationBar的 backgroundView 不会自动置顶到电池栏的底下
 */
- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.window) {
        CGRect frame = [self convertRect:self.bounds toView:self.window];
        UIView *view = [self valueForKey:@"_backgroundView"];
        view.frame = CGRectMake(0, - CGRectGetMinY(frame), CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + CGRectGetMinY(frame));
    }
}

@end

@interface UIViewController ()

@property (nonatomic, strong) YYY_Transition_NavigationBar *yyy_fakeNavigationBar;

@end

@implementation UIViewController (YYYNavigationManager)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method oriMethod = class_getInstanceMethod(self, @selector(viewWillLayoutSubviews));
        Method newMethod = class_getInstanceMethod(self, @selector(yyy_navigation_viewWillLayoutSubviews));
        if (!newMethod || !oriMethod) {
            return;
        }
        BOOL isAddedMethod = class_addMethod(self, @selector(viewWillLayoutSubviews), method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
        if (isAddedMethod) {
            // 如果 class_addMethod 成功了，说明之前 fromClass 里并不存在 originSelector，所以要用一个空的方法代替它，以避免 class_replaceMethod 后，后续 toClass 的这个方法被调用时可能会 crash
            IMP oriMethodIMP = method_getImplementation(oriMethod) ?: imp_implementationWithBlock(^(id selfObject) {});
            const char *oriMethodTypeEncoding = method_getTypeEncoding(oriMethod) ?: "v@:";
            class_replaceMethod(self, @selector(yyy_navigation_viewWillLayoutSubviews), oriMethodIMP, oriMethodTypeEncoding);
        } else {
            method_exchangeImplementations(oriMethod, newMethod);
        }
    });
}

- (YYYNavigationManager *)yyy_navigationManager {
    YYYNavigationManager *manager = objc_getAssociatedObject(self, @selector(yyy_navigationManager));
    if (!manager) {
        if ([self isKindOfClass:[UINavigationController class]]) {
            manager = [[YYYNavigationManager globalManager] copy];
        } else {
            manager = [self.navigationController.yyy_navigationManager copy];
        }
        manager.viewController = self;
        objc_setAssociatedObject(self, @selector(yyy_navigationManager), manager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return manager;
}

- (void)yyy_navigation_viewWillLayoutSubviews {
    [self resizeFakeNavigationBarFrame];
    [self yyy_navigation_viewWillLayoutSubviews];
}

- (void)resizeFakeNavigationBarFrame {
    if (!self.view.window || !self.navigationController.navigationBar) {
        return;
    }
    
    if (self.yyy_fakeNavigationBar) {
        CGRect barFrame = [self.navigationController.navigationBar convertRect:self.navigationController.navigationBar.bounds toView:self.view];
        barFrame.origin.x = 0;
        [UIView performWithoutAnimation:^{
            self.yyy_fakeNavigationBar.frame = barFrame;
            [self.yyy_fakeNavigationBar layoutIfNeeded];
        }];
    }
}

- (void)yyy_traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    
}

- (YYY_Transition_NavigationBar *)yyy_fakeNavigationBar {
    return objc_getAssociatedObject(self, @selector(yyy_fakeNavigationBar));
}

- (void)setYyy_fakeNavigationBar:(YYY_Transition_NavigationBar *)yyy_fakeNavigationBar {
    UIView *view = self.yyy_fakeNavigationBar;
    if (view) {
        [view removeFromSuperview];
    }
    objc_setAssociatedObject(self, @selector(yyy_fakeNavigationBar), yyy_fakeNavigationBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@interface YYYNavigationController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate,NSKeyedArchiverDelegate>

@end

@implementation YYYNavigationController

#pragma mark - UIGestureRecognizerDelegate 处理隐藏navigationBar后侧滑手势失效问题
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return self.viewControllers.count > 1;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return (gestureRecognizer == self.interactivePopGestureRecognizer);
}

#pragma mark - UINavigationControllerDelegate

/**
 在将要进行转场动画的时候，将系统自带的导航栏隐藏掉，同时在将要消失的界面跟将要出现的界面都添加上假的navigationBar,然后配置各自的样式
 转场动画结束后在将假的navigationBar移除，将真的显示出来
 extendedLayoutIncludesOpaqueBars = YES 和 UIRectEdgeTop 是为了保证viewController.view 的大小撑到navigationBar底下，不然        viewController.view.clipsToBounds = YES,假的Bar可能会超出view范围导致不显示。
 */
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (!self.disabledCustomTransition) {
        viewController.edgesForExtendedLayout = viewController.edgesForExtendedLayout|UIRectEdgeTop;
        viewController.extendedLayoutIncludesOpaqueBars = YES;
        [self addLeftBarButtonItemAtViewController:viewController];
        [self updateNavigationBarStyleWithManager:viewController.yyy_navigationManager];
        if (self.isNavigationBarHidden != viewController.yyy_navigationManager.hiddenNavigationBar) {
            [self setNavigationBarHidden:viewController.yyy_navigationManager.hiddenNavigationBar animated:animated];
        }
        [[UIApplication sharedApplication] setStatusBarStyle:viewController.preferredStatusBarStyle animated:animated];
        
        UIViewController *disappearViewController = [self.transitionCoordinator viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController *toViewController = [self.transitionCoordinator viewControllerForKey:UITransitionContextToViewControllerKey];
        BOOL needTransition = animated && disappearViewController != nil && toViewController == viewController;
        if (needTransition) {
            [self addFakeBarAtViewController:disappearViewController];
            [self addFakeBarAtViewController:viewController];
            disappearViewController.yyy_navigationManager.isShow = NO;
            self.navigationBar.layer.mask = [CALayer layer];
            if (self.navigationBar.isTranslucent) {
                self.transitionCoordinator.containerView.backgroundColor = [UIColor whiteColor];
            }
            
            [self.transitionCoordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                void(^completionBlock)(void) = ^(void) {
                    [self removeFakeBarAtViewController:disappearViewController];
                    [self removeFakeBarAtViewController:viewController];
                    if (self.navigationBar.topItem.titleView && !self.isNavigationBarHidden) {
                        UIView *view = self.navigationBar.topItem.titleView;
                        self.navigationBar.topItem.titleView = nil;
                        self.navigationBar.topItem.titleView = view;
                    }
                    self.navigationBar.layer.mask = nil;
                };
                
                if ([context isCancelled]) {
                    [[UIApplication sharedApplication] setStatusBarStyle:disappearViewController.preferredStatusBarStyle animated:animated];
                    viewController.yyy_navigationManager.isShow = NO;
                    [self updateNavigationBarStyleWithManager:disappearViewController.yyy_navigationManager];
                    if (@available(iOS 8.3, *)) {
                        completionBlock();
                    } else {
                        //8.3以下，更改navigationBar的barTintColor不会立即改变，会有一个动画效果，所以得延迟移除假的bar。
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            completionBlock();
                        });
                    }
                } else {
                    completionBlock();
                }
            }];
        }
    }
    if (self.yyy_delegate && [self.yyy_delegate respondsToSelector:@selector(navigationController:willShowViewController:animated:)]) {
        [self.yyy_delegate navigationController:navigationController willShowViewController:viewController animated:animated];
    }
}

#pragma mark - UINavigationControllerDelegate 以下为代理转发
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.yyy_delegate && [self.yyy_delegate respondsToSelector:@selector(navigationController:didShowViewController:animated:)]) {
        [self.yyy_delegate navigationController:navigationController didShowViewController:viewController animated:animated];
    }
}

- (UIInterfaceOrientationMask)navigationControllerSupportedInterfaceOrientations:(UINavigationController *)navigationController {
    if ([self.yyy_delegate respondsToSelector:@selector(navigationControllerSupportedInterfaceOrientations:)]) {
        return [self.yyy_delegate navigationControllerSupportedInterfaceOrientations:navigationController];
    }
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)navigationControllerPreferredInterfaceOrientationForPresentation:(UINavigationController *)navigationController {
    if (self.yyy_delegate && [self.yyy_delegate respondsToSelector:@selector(navigationControllerPreferredInterfaceOrientationForPresentation:)]) {
        return [self.yyy_delegate navigationControllerPreferredInterfaceOrientationForPresentation:navigationController];
    }
    return UIInterfaceOrientationPortrait;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    if (self.yyy_delegate && [self.yyy_delegate respondsToSelector:@selector(navigationController:interactionControllerForAnimationController:)]) {
        return [self.yyy_delegate navigationController:navigationController interactionControllerForAnimationController:animationController];
    }
    return nil;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if ([self.yyy_delegate respondsToSelector:@selector(navigationController:animationControllerForOperation:fromViewController:toViewController:)]) {
        return [self.yyy_delegate navigationController:navigationController animationControllerForOperation:operation fromViewController:fromVC toViewController:toVC];
    }
    return nil;
}

#pragma mark -

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    if (@available(iOS 13, *)) {
        if (self.traitCollection.userInterfaceStyle != previousTraitCollection.userInterfaceStyle) {
            [self.topViewController.yyy_navigationManager reloadNavigationBarStyle];
        }
    }
}

#pragma mark - leftBarButtonItem 处理返回按钮
- (void)addLeftBarButtonItemAtViewController:(UIViewController *)viewController {
    if (!viewController.navigationItem.leftBarButtonItem && self.viewControllers.count > 1) {
        UIBarButtonItem *item = nil;
        if ([viewController respondsToSelector:@selector(yyy_customBackItemWithTarget:action:)]) {
            id <YYYNavigationLeftBarButtonItemProtocol> vc = (id <YYYNavigationLeftBarButtonItemProtocol>)viewController;
            item = [vc yyy_customBackItemWithTarget:self action:@selector(popViewControllerHandle)];
        } else if (self.customBackItemBlock) {
            item = self.customBackItemBlock(viewController,self,@selector(popViewControllerHandle));
        }
        if (item) {
            viewController.navigationItem.leftBarButtonItem = item;
        }
    }
}

- (void)popViewControllerHandle {
    [self popViewControllerAnimated:YES];
}

#pragma mark - private method

- (void)updateNavigationBarStyleWithManager:(YYYNavigationManager *)manager {
    manager.isShow = YES;
    [manager updateStyleToNavigationBar:self.navigationBar];
}

- (void)removeFakeBarAtViewController:(UIViewController *)viewController {
    if (viewController.yyy_fakeNavigationBar.topItem.titleView) {
        viewController.navigationItem.titleView = viewController.yyy_fakeNavigationBar.topItem.titleView;
        viewController.yyy_fakeNavigationBar.topItem.titleView = nil;
    }
    [viewController.yyy_fakeNavigationBar removeFromSuperview];
    viewController.yyy_fakeNavigationBar = nil;
}

- (void)addFakeBarAtViewController:(UIViewController *)viewController {
    if (viewController.yyy_navigationManager.hiddenNavigationBar) {
        return;
    }
    YYY_Transition_NavigationBar *fakeBar = [[YYY_Transition_NavigationBar alloc] init];
    [viewController.yyy_navigationManager updateStyleToNavigationBar:fakeBar];
    CGRect barFrame = [self.navigationBar convertRect:self.navigationBar.bounds toView:viewController.view];
    barFrame.origin.x = 0;
    fakeBar.frame = barFrame;
    UINavigationItem *item = viewController.navigationItem;
    if (item.leftBarButtonItem == nil) {
        //navigationBar如果没有设置leftBarButtonItem的话，它的返回按钮就是根据上一个navigationItem决定的，
        NSInteger index = [self.navigationBar.items indexOfObject:item];
        if (index == NSNotFound) {
            UINavigationItem *fakeItem = [self copyNavigationItem:self.navigationBar.topItem];
            [fakeBar pushNavigationItem:fakeItem animated:NO];
        } else if (index > 0) {
            UINavigationItem *fakeItem = [self copyNavigationItem:self.navigationBar.items[index - 1]];
            [fakeBar pushNavigationItem:fakeItem animated:NO];
        }
    }
    [fakeBar pushNavigationItem:[self copyNavigationItem:item] animated:NO];
    [viewController.view addSubview:fakeBar];
    viewController.yyy_fakeNavigationBar = fakeBar;
    [UIView performWithoutAnimation:^{
        [fakeBar layoutIfNeeded];
    }];
}

- (UINavigationItem *)copyNavigationItem:(UINavigationItem *)item {
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    archiver.delegate = self;
    [archiver encodeObject:item forKey:NSKeyedArchiveRootObjectKey];
    [archiver finishEncoding];
    UINavigationItem *copyObject = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (item.titleView) {
        copyObject.titleView = item.titleView;
        item.titleView = nil;
    }
    return copyObject;
}

- (id)archiver:(NSKeyedArchiver *)archiver willEncodeObject:(id)object {
    if ([object isKindOfClass:[UIImage class]]) {
        UIImage *image = object;
        if (image.renderingMode == UIImageRenderingModeAutomatic) {
            return [UIImage imageWithCGImage:image.CGImage scale:image.scale orientation:image.imageOrientation];
        }
    }
    return object;
}

@end

@interface YYYNavigationController (YYY_System)
@end

@implementation YYYNavigationController (YYY_System)

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    // 处理隐藏navigationBar后侧滑手势失效问题
    self.interactivePopGestureRecognizer.delegate = self;
    self.interactivePopGestureRecognizer.delaysTouchesBegan = YES;
}

- (void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated {
    [super setNavigationBarHidden:hidden animated:animated];
    self.topViewController.yyy_navigationManager.hiddenNavigationBar = hidden;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.topViewController.preferredStatusBarStyle;
}

- (BOOL)prefersStatusBarHidden {
    return [self.topViewController prefersStatusBarHidden];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.topViewController supportedInterfaceOrientations];
}

#if __IPHONE_11_0 && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_11_0
- (nullable UIViewController *)childViewControllerForScreenEdgesDeferringSystemGestures {
    return self.topViewController;
}

- (UIRectEdge)preferredScreenEdgesDeferringSystemGestures {
    return [self.topViewController preferredScreenEdgesDeferringSystemGestures];
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    return self.topViewController.prefersHomeIndicatorAutoHidden;
}

- (UIViewController *)childViewControllerForHomeIndicatorAutoHidden {
    return self.topViewController;
}
#endif

- (void)setDelegate:(id<UINavigationControllerDelegate>)delegate {
    if (delegate == self) {
        [super setDelegate:self];
    } else {
        self.yyy_delegate = delegate;
    }
}

@end
