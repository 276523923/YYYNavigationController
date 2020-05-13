//
//  TestTableViewController.m
//  QMUINavigationBarTransition
//
//  Created by yyy on 2018/11/26.
//  Copyright © 2018 yyy. All rights reserved.
//

#import "TestTableViewController.h"
#import "YYYNavigationController.h"

@interface TestTableViewController ()

@property(nonatomic, assign) NavigationBarStyle barStyle;
@property(nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) UIView *cstView;
@property (nonatomic, weak) id delegate;

@end

@implementation TestTableViewController

- (instancetype)initWithBarStyle:(NavigationBarStyle)barStyle {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.barStyle = barStyle;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    YYYNavigationController *nav = (YYYNavigationController *)self.navigationController;
    if (!nav.customBackItemBlock) {
        nav.customBackItemBlock = ^UIBarButtonItem * _Nonnull(UIViewController * _Nonnull viewController, id  _Nonnull target, SEL  _Nonnull action) {
            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:target action:action];
            return item;
        };
    }
    self.dataSource = @[@"默认navBar样式",
                        @"浅色navBar样式",
                        @"暗色navBar样式",
                        @"隐藏navBar样式",
                        @"滑动隐藏navBar样式"
                        ];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    self.title = self.dataSource[self.barStyle];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"root" style:UIBarButtonItemStylePlain target:self action:@selector(popToRootViewController)];
    [self configNavigationManager];
}

- (void)configNavigationManager {
    switch (self.barStyle) {
        case NavigationBarStyleLight: {
            self.yyy_navigationManager.barTintColor = [UIColor whiteColor];
            self.yyy_navigationManager.tintColor = [UIColor blueColor];
            self.yyy_navigationManager.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor redColor]};
            break;
        }
        case NavigationBarStyleDark: {
            self.yyy_navigationManager.barTintColor = [UIColor blackColor];
            self.yyy_navigationManager.tintColor = [UIColor whiteColor];
            self.yyy_navigationManager.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
            self.yyy_navigationManager.translucent = NO;
            break;
        }
        case NavigationBarStyleHidden: {
            self.yyy_navigationManager.hiddenNavigationBar = YES;
            break;
        }
        default:
            break;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.barStyle != NavigationBarStyleDark ? UIStatusBarStyleDefault:UIStatusBarStyleLightContent;
}

- (NSString *)description {
    return self.title;
}

- (NSString *)debugDescription {
    return self.title;
}

- (void)popToRootViewController {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 20;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TestTableViewController *vc = [[TestTableViewController alloc] initWithBarStyle:indexPath.row];
    vc.title = self.dataSource[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.barStyle == NavigationBarStyleHiddenWhenScroll) {
        CGFloat offsetY = scrollView.contentOffset.y;
        if (offsetY > 100) {
            [self.yyy_navigationManager setNavigationBarHidden:YES animated:YES];
        } else {
            [self.yyy_navigationManager setNavigationBarHidden:NO animated:YES];
        }
    }
}

@end
