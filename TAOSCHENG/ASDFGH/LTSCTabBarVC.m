//
//  LTSCTabBarVC.m
//  salaryStatus
//
//  Created by 李晓满 on 2019/1/25.
//  Copyright © 2019年 李晓满. All rights reserved.
//

#import "LTSCTabBarVC.h"
#import "LTSCHomeVC.h"
#import "LTSCCateVC.h"
#import "LTSCShopCarVC.h"
#import "LTSCMineVC.h"

#import "LTSCKaBaoVC.h"

@interface LTSCTabBarVC ()

@end

@implementation LTSCTabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.backgroundImage = [UIImage imageNamed:@"tabbarwhite"];
    self.tabBar.shadowImage = [UIImage new];
    self.tabBar.barTintColor = UIColor.whiteColor;
    self.tabBar.tintColor = UIColor.whiteColor;
    self.tabBar.layer.shadowColor = [CharacterDarkColor colorWithAlphaComponent:0.2].CGColor;
    self.tabBar.layer.shadowRadius = 5;
    self.tabBar.layer.shadowOpacity = 0.5;
    self.tabBar.layer.shadowOffset = CGSizeMake(0, 0);
    
    if (@available(iOS 13.0, *)) {
           UITabBarAppearance *tabBarAppearance = [[UITabBarAppearance alloc] init];
           tabBarAppearance.backgroundImage = [UIImage imageNamed:@"tabbarwhite"];
           tabBarAppearance.shadowColor = UIColor.whiteColor;
           tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = @{NSForegroundColorAttributeName : MineColor};
           tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = @{NSForegroundColorAttributeName : CharacterLightGrayColor};
           self.tabBar.standardAppearance = tabBarAppearance;
       }
    
    LTSCHomeVC *homeVC = [[LTSCHomeVC alloc] initWithTableViewStyle:UITableViewStyleGrouped];
    homeVC.tabBarItem.image = [[UIImage imageNamed:@"shouye_n"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"shouye_y"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [homeVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:MineColor} forState:UIControlStateSelected];
    [homeVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:CharacterLightGrayColor} forState:UIControlStateNormal];
    homeVC.tabBarItem.title = @"首页";
    BaseNavigationController *nav1 = [[BaseNavigationController alloc] initWithRootViewController:homeVC];
    
    LTSCCateVC *cateVC = [[LTSCCateVC alloc] initWithTableViewStyle:UITableViewStyleGrouped];
    cateVC.tabBarItem.image = [[UIImage imageNamed:@"fenlei_n"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    cateVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"fenlei_y"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [cateVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:MineColor} forState:UIControlStateSelected];
    [cateVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:CharacterLightGrayColor} forState:UIControlStateNormal];
    cateVC.tabBarItem.title = @"分类";
    BaseNavigationController *nav2 = [[BaseNavigationController alloc] initWithRootViewController:cateVC];
    
    
//    LTSCKaBaoVC *kaBaoVC = [[LTSCKaBaoVC alloc] initWithTableViewStyle:UITableViewStyleGrouped];
//    kaBaoVC.tabBarItem.image = [[UIImage imageNamed:@"kabao_n"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    kaBaoVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"kabao_y"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    [kaBaoVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:MineColor} forState:UIControlStateSelected];
//    [kaBaoVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:CharacterLightGrayColor} forState:UIControlStateNormal];
//    kaBaoVC.tabBarItem.title = @"卡包";
//    BaseNavigationController *nav3 = [[BaseNavigationController alloc] initWithRootViewController:kaBaoVC];
    
    
    
    LTSCShopCarVC *carVC = [[LTSCShopCarVC alloc] initWithTableViewStyle:UITableViewStyleGrouped];
    carVC.isTabarVC = YES;
    carVC.tabBarItem.image = [[UIImage imageNamed:@"gouwuche_n"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    carVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"gouwuche_y"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [carVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:MineColor} forState:UIControlStateSelected];
    [carVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:CharacterLightGrayColor} forState:UIControlStateNormal];
    carVC.tabBarItem.title = @"购物车";
    BaseNavigationController *nav4 = [[BaseNavigationController alloc] initWithRootViewController:carVC];
    
    
    LTSCMineVC *mineVC = [[LTSCMineVC alloc] initWithTableViewStyle:UITableViewStyleGrouped];
    mineVC.tabBarItem.image = [[UIImage imageNamed:@"wode_n"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mineVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"wode_y"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [mineVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:MineColor} forState:UIControlStateSelected];
    [mineVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:CharacterLightGrayColor} forState:UIControlStateNormal];
    mineVC.tabBarItem.title = @"我的";
    BaseNavigationController *nav5 = [[BaseNavigationController alloc] initWithRootViewController:mineVC];
    
    self.viewControllers = @[nav1,nav2,nav4,nav5];
}


@end
