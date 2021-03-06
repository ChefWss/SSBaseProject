//
//  BaseViewController.m
//  SSBaseProject
//
//  Created by 王少帅 on 2018/1/30.
//  Copyright © 2018年 王少帅. All rights reserved.
//

#import "BaseViewController.h"


@interface BaseViewController ()

@property(nonatomic, strong) UIImageView *topImgView;
@property(nonatomic, strong) UIView *topLine;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kBackground_GrayColor;
    
    [self setUpNav];
}

- (void)setUpNav
{
    self.topImgView = [[UIImageView alloc]init];
    self.topImgView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.topImgView];
    
    [self.topImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(kStatusBarH + kNavigationBarH);
    }];
    
    
    self.topLine = [[UIView alloc]init];
    _topLine.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.2];
    [self.view addSubview:_topLine];
    
    [_topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.bottom.equalTo(self.topImgView);
        make.height.mas_equalTo(0.5);
    }];
    
}

#pragma mark - 获取当前控制器
+ (UIViewController *)currentViewController {
    // Find best view controller
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [BaseViewController findBestViewController:viewController];
}

//循环查找
+ (UIViewController *) findBestViewController:(UIViewController *)vc {
    if (vc.presentedViewController) {
        // Return presented view controller
        return [BaseViewController findBestViewController:vc.presentedViewController];
        
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        // Return top view
        UINavigationController *svc = (UINavigationController *)vc;
        if (svc.viewControllers.count > 0)
            return [BaseViewController findBestViewController:svc.topViewController];
        else
            return vc;
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        // Return visible view
        UITabBarController *svc = (UITabBarController *)vc;
        if (svc.viewControllers.count > 0)
            return [BaseViewController findBestViewController:svc.selectedViewController];
        else
            return vc;
    } else {
        // Unknown view controller type, return last child view controller
        return vc;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.topImgView.hidden = _hidNavBar;
    self.topLine.hidden = _hidNavBar;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
