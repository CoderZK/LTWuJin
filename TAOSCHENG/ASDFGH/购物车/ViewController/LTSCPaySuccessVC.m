//
//  LTSCPaySuccessVC.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/21.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LTSCPaySuccessVC.h"
#import "LTSCGoodsDetailVC.h"
#import "LTSCShopCarVC.h"
#import "LTSCMyOrderVC.h"
#import "LTSCOrderDetailVC.h"
@interface LTSCPaySuccessVC ()

@property (nonatomic, strong) UIView *centerView;

@property (nonatomic, strong) UIImageView *iconImgView;//图标

@property (nonatomic, strong) UILabel *paySuccessLabel;//支付成功

@property (nonatomic, strong) UIButton *seeOrderButton;//查看订单

@property (nonatomic, strong) UIButton *backHomeButton;//返回首页

@end

@implementation LTSCPaySuccessVC

- (UIView *)centerView {
    if (!_centerView) {
        _centerView = [[UIView alloc] init];
    }
    return _centerView;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSArray *vcs = self.navigationController.viewControllers;
    for (UIViewController *vc in vcs) {
        if ([vc isKindOfClass:[LTSCShopCarVC class]]) {
            [self.navigationController popToViewController:vc animated:NO];
            break;
        }
        if ([vc isKindOfClass:[LTSCMyOrderVC class]]) {
            [self.navigationController popToViewController:vc animated:NO];
            break;
        }
        if ([vc isKindOfClass:[LTSCGoodsDetailVC class]]) {
            [self.navigationController popToViewController:vc animated:NO];
            break;
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

/**
 添加视图
 */
- (void)initView {
    self.navigationItem.leftBarButtonItem.tintColor = UIColor.whiteColor;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.centerView];
    [self.centerView addSubview:self.iconImgView];
    [self.centerView addSubview:self.paySuccessLabel];
    [self.centerView addSubview:self.seeOrderButton];
    [self.centerView addSubview:self.backHomeButton];
    [self setConstrains];
}

/**
 设置约束
 */
- (void)setConstrains {
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(@(ScreenW - 60));
        make.height.equalTo(@300);
    }];
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.equalTo(self.centerView);
        make.width.height.equalTo(@60);
    }];
    [self.paySuccessLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImgView.mas_bottom).offset(20);
        make.centerX.equalTo(self.centerView);
    }];
    [self.seeOrderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.paySuccessLabel.mas_bottom).offset(50);
        make.leading.trailing.centerX.equalTo(self.centerView);
        make.height.equalTo(@50);
    }];
    [self.backHomeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.seeOrderButton.mas_bottom).offset(20);
        make.leading.trailing.centerX.equalTo(self.centerView);
        make.height.equalTo(@50);
    }];
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.image = [UIImage imageNamed:@"paysucess"];
    }
    return _iconImgView;
}

- (UILabel *)paySuccessLabel {
    if (!_paySuccessLabel) {
        _paySuccessLabel = [[UILabel alloc] init];
        _paySuccessLabel.textColor = CharacterDarkColor;
        _paySuccessLabel.font = [UIFont systemFontOfSize:18];
        _paySuccessLabel.text = @"支付成功";
    }
    return _paySuccessLabel;
}

- (UIButton *)seeOrderButton {
    if (!_seeOrderButton) {
        _seeOrderButton = [[UIButton alloc] init];
        [_seeOrderButton setBackgroundImage:[UIImage imageNamed:@"yellow"] forState:UIControlStateNormal];
        [_seeOrderButton setTitle:@"查看订单" forState:UIControlStateNormal];
        [_seeOrderButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _seeOrderButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _seeOrderButton.layer.cornerRadius = 3;
        _seeOrderButton.layer.masksToBounds = YES;
        [_seeOrderButton addTarget:self action:@selector(seeOrderClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _seeOrderButton;
}

- (UIButton *)backHomeButton {
    if (!_backHomeButton) {
        _backHomeButton = [[UIButton alloc] init];
        [_backHomeButton setBackgroundImage:[UIImage imageNamed:@"white"] forState:UIControlStateNormal];
        [_backHomeButton setTitle:@"返回首页" forState:UIControlStateNormal];
        [_backHomeButton setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
        _backHomeButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _backHomeButton.layer.borderWidth = 0.5;
        _backHomeButton.layer.borderColor = LineColor.CGColor;
        _backHomeButton.layer.cornerRadius = 3;
        _backHomeButton.layer.masksToBounds = YES;
        [_backHomeButton addTarget:self action:@selector(backToHome) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backHomeButton;
}

- (void)backToHome {
    [UIApplication sharedApplication].keyWindow.rootViewController = [[LTSCTabBarVC alloc] init];;
    
//    NSArray *vcs = self.navigationController.viewControllers;
//    for (UIViewController *vc in vcs) {
//        if ([vc isKindOfClass:[LTSCShopCarVC class]]) {
//            [LTSCEventBus sendEvent:@"settleOrderSuccess" data:nil];
//        }
//        if ([vc isKindOfClass:[LTSCMyOrderVC class]]) {
//            [LTSCEventBus sendEvent:@"settleOrderSuccess" data:nil];
//        }
//        if ([vc isKindOfClass:[LTSCGoodsDetailVC class]]) {
//            [LTSCEventBus sendEvent:@"settleOrderSuccess" data:nil];
//        }
//    }
//    [LTSCEventBus sendEvent:@"backHomeVC" data:nil];
//    [self.navigationController popToRootViewControllerAnimated:YES];
}

/**
 查看订单
 */
- (void)seeOrderClick {
    NSArray *vcs = self.navigationController.viewControllers;
    for (UIViewController *vc in vcs) {
        if ([vc isKindOfClass:[LTSCShopCarVC class]]) {
            [self.navigationController popToViewController:vc animated:NO];
            [LTSCEventBus sendEvent:@"seeOrder" data:@{@"orderID":self.orderID,@"orderType":self.orderType}];
            break;
        }
        if ([vc isKindOfClass:[LTSCMyOrderVC class]]) {
            [self.navigationController popToViewController:vc animated:NO];
            [LTSCEventBus sendEvent:@"seeOrder" data:@{@"orderID":self.orderID,@"orderType":self.orderType}];
            break;
        }
        if ([vc isKindOfClass:[LTSCGoodsDetailVC class]]) {
            [self.navigationController popToViewController:vc animated:NO];
            [LTSCEventBus sendEvent:@"seeOrder" data:@{@"orderID":self.orderID,@"orderType":self.orderType}];
            break;
        }
    }
    
//    if ([self.orderType isEqualToString:@"1"]) {
//        LTSCMyOrderVC *vc = [[LTSCMyOrderVC alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
//        vc.isPP = YES;
//  
//    }else {
//        LTSCOrderDetailVC *vc = [[LTSCOrderDetailVC alloc] init];
//        vc.isPP = YES;
//        vc.orderID = self.orderID;
//        [self.navigationController pushViewController:vc animated:YES];
//
//    }
    
}

@end
