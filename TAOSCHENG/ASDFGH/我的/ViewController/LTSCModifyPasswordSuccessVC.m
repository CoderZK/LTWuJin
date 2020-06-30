//
//  LTSCModifyPasswordSuccessVC.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/21.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LTSCModifyPasswordSuccessVC.h"
#import "LTSCLoginVC.h"

@interface LTSCModifyPasswordSuccessVC ()

@property (nonatomic, strong) UIView *centerView;

@property (nonatomic, strong) UIImageView *iconImgView;//图标

@property (nonatomic, strong) UILabel *modifiySuccessLabel;//支付成功

@end

@implementation LTSCModifyPasswordSuccessVC

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    BaseNavigationController * nav  = [[BaseNavigationController alloc] initWithRootViewController:[[LTSCLoginVC alloc] init]];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
}

- (UIView *)centerView {
    if (!_centerView) {
        _centerView = [[UIView alloc] init];
    }
    return _centerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    self.navigationItem.title = @"修改密码";
}
/**
 添加视图
 */
- (void)initView {
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.centerView];
    [self.centerView addSubview:self.iconImgView];
    [self.centerView addSubview:self.modifiySuccessLabel];
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
    [self.modifiySuccessLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImgView.mas_bottom).offset(20);
        make.centerX.equalTo(self.centerView);
    }];
}
- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.image = [UIImage imageNamed:@"sucess"];
    }
    return _iconImgView;
}

- (UILabel *)modifiySuccessLabel {
    if (!_modifiySuccessLabel) {
        _modifiySuccessLabel = [[UILabel alloc] init];
        _modifiySuccessLabel.textColor = CharacterDarkColor;
        _modifiySuccessLabel.font = [UIFont systemFontOfSize:18];
        _modifiySuccessLabel.text = @"修改成功";
    }
    return _modifiySuccessLabel;
}

@end
