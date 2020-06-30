//
//  LTSCDianPuTabBarController.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2020/4/8.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "LTSCDianPuTabBarController.h"
#import "LTSCDianPuVC.h"
#import "LTSCShangPinVC.h"
#import "LTSCDianPuCateVC.h"

@interface LTSCDianPuTabBarController ()

@end

@implementation LTSCDianPuTabBarController

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

    LTSCDianPuVC *dianpuVC = [[LTSCDianPuVC alloc] initWithTableViewStyle:UITableViewStyleGrouped];
    dianpuVC.tabBarItem.image = [[UIImage imageNamed:@"dianpu_shouye_n"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    dianpuVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"dianpu_shouye_y"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [dianpuVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:MineColor} forState:UIControlStateSelected];
    [dianpuVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:CharacterLightGrayColor} forState:UIControlStateNormal];
    dianpuVC.tabBarItem.title = @"首页";
    BaseNavigationController *nav1 = [[BaseNavigationController alloc] initWithRootViewController:dianpuVC];

    LTSCShangPinVC *goodsVC = [[LTSCShangPinVC alloc] init];
    goodsVC.tabBarItem.image = [[UIImage imageNamed:@"dianpu_goods_n"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    goodsVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"dianpu_goods_y"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [goodsVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:MineColor} forState:UIControlStateSelected];
    [goodsVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:CharacterLightGrayColor} forState:UIControlStateNormal];
    goodsVC.tabBarItem.title = @"商品";
    BaseNavigationController *nav2 = [[BaseNavigationController alloc] initWithRootViewController:goodsVC];

    LTSCDianPuCateVC *cateVC = [[LTSCDianPuCateVC alloc] init];
    cateVC.tabBarItem.image = [[UIImage imageNamed:@"dianpu_fenlei_n"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    cateVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"dianpu_fenlei_y"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [cateVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:MineColor} forState:UIControlStateSelected];
    [cateVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:CharacterLightGrayColor} forState:UIControlStateNormal];
    cateVC.tabBarItem.title = @"分类";
    BaseNavigationController *nav3 = [[BaseNavigationController alloc] initWithRootViewController:cateVC];

    LTSCKeFuTVC *mineVC = [[LTSCKeFuTVC alloc] initWithTableViewStyle:UITableViewStyleGrouped];
    mineVC.tabBarItem.image = [[UIImage imageNamed:@"dianpu_kefu_n"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mineVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"dianpu_kefu_y"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [mineVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:MineColor} forState:UIControlStateSelected];
    [mineVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:CharacterLightGrayColor} forState:UIControlStateNormal];
    mineVC.tabBarItem.title = @"客服";
    BaseNavigationController *nav4 = [[BaseNavigationController alloc] initWithRootViewController:mineVC];
   
   self.viewControllers = @[nav1,nav2,nav3,nav4];
    
    WeakObj(self);
    [LTSCEventBus registerEvent:@"guanzhuAction" block:^(id data) {
        [selfWeak loadDetailData:selfWeak.shopId];
    }];
}


- (void)setShopId:(NSString *)shopId {
    _shopId = shopId;
    for (BaseNavigationController *nav in self.viewControllers) {
        for (BaseViewController *vc in nav.viewControllers) {
            if ([vc isKindOfClass:LTSCDianPuVC.class]) {
                LTSCDianPuVC *vc0 = (LTSCDianPuVC *)vc;
                vc0.shopID = _shopId;
            } else if ([vc isKindOfClass:LTSCShangPinVC.class]) {
                LTSCShangPinVC *vc0 = (LTSCShangPinVC *)vc;
                vc0.shopID = _shopId;
            } else if ([vc isKindOfClass:LTSCDianPuCateVC.class]) {
                LTSCDianPuCateVC *vc0 = (LTSCDianPuCateVC *)vc;
                vc0.shopID = _shopId;
            }
        }
    }
    [self loadDetailData:_shopId];
}


- (void)loadDetailData:(NSString *)shopID {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (SESSION_TOKEN && ISLOGIN) {
        dict[@"token"] = SESSION_TOKEN;
    }
    dict[@"shopId"] = shopID;
    [LTSCLoadingView show];
    [LTSCNetworking networkingPOST:shopGoodMsg parameters:dict returnClass:LTSCShopRootModel.class success:^(NSURLSessionDataTask *task, LTSCShopRootModel *responseObject) {
        [LTSCLoadingView dismiss];
        if (responseObject.key.intValue == 1000) {
            LTSCShopModel *shopModel = responseObject.result.map;
            for (BaseNavigationController *nav in self.viewControllers) {
                for (BaseViewController *vc in nav.viewControllers) {
                    if ([vc isKindOfClass:LTSCDianPuVC.class]) {
                        LTSCDianPuVC *vc0 = (LTSCDianPuVC *)vc;
                        vc0.shopModel = shopModel;
                    } else if ([vc isKindOfClass:LTSCShangPinVC.class]) {
                        LTSCShangPinVC *vc0 = (LTSCShangPinVC *)vc;
                        vc0.shopModel = shopModel;
                    } else if ([vc isKindOfClass:LTSCDianPuCateVC.class]) {
                        LTSCDianPuCateVC *vc0 = (LTSCDianPuCateVC *)vc;
                        vc0.shopModel = shopModel;
                    }
                }
            }
        } else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [LTSCLoadingView dismiss];
    }];
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
