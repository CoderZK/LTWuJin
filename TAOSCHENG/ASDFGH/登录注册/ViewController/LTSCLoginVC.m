//
//  LTSCLoginVC.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/15.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LTSCLoginVC.h"
#import "LTSCPutinView.h"
#import "LTSCRegistVC.h"
#import "LTSCTabBarVC.h"
#import "LTSCForgetPasswordVC.h"

@interface LTSCLoginVC ()

@property (nonatomic, strong) UIView *headerView;//头视图

@property (nonatomic, strong) UIView *centerView;//头视图

@property (nonatomic, strong) LTSCPutinView *phoneView;//手机号

@property (nonatomic, strong) LTSCPutinView *passwordView;//密码

@property (nonatomic, strong) UIButton *forgetButton;//忘记密码

@property (nonatomic, strong) UIButton *registeButton;//注册

@property (nonatomic, strong) UIButton *loginButton;//登录

@property (nonatomic, strong) UIImageView *footerImgView;//底部背景

@end

@implementation LTSCLoginVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];}

- (UIImageView *)footerImgView {
    if (!_footerImgView) {
        _footerImgView = [[UIImageView alloc] init];
        _footerImgView.image = [UIImage imageNamed:@"bgImage"];
        _footerImgView.backgroundColor = [UIColor whiteColor];
    }
    return _footerImgView;
}

- (UIView *)centerView {
    if (!_centerView) {
        _centerView = [[UIView alloc] init];
        _centerView.backgroundColor = [UIColor clearColor];
    }
    return _centerView;
}

- (LTSCPutinView *)phoneView {
    if (!_phoneView) {
        _phoneView = [[LTSCPutinView alloc] init];
        _phoneView.putinTF.placeholder = @"手机号";
        _phoneView.putinTF.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _phoneView;
}

- (LTSCPutinView *)passwordView {
    if (!_passwordView) {
        _passwordView = [[LTSCPutinView alloc] init];
        _passwordView.putinTF.placeholder = @"密码";
        _passwordView.putinTF.secureTextEntry = YES;
    }
    return _passwordView;
}

- (UIButton *)forgetButton {
    if (!_forgetButton) {
        _forgetButton = [[UIButton alloc] init];
        [_forgetButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
        [_forgetButton setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
        _forgetButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _forgetButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _forgetButton.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        [_forgetButton addTarget:self action:@selector(forgetButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgetButton;
}

- (UIButton *)registeButton {
    if (!_registeButton) {
        _registeButton = [[UIButton alloc] init];
        [_registeButton setTitle:@"注册新账户" forState:UIControlStateNormal];
        [_registeButton setTitleColor:MineColor forState:UIControlStateNormal];
        _registeButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_registeButton addTarget:self action:@selector(registButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registeButton;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [[UIButton alloc] init];
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_loginButton setBackgroundImage:[UIImage imageNamed:@"yellow"] forState:UIControlStateNormal];
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _loginButton.layer.cornerRadius = 3;
        _loginButton.layer.masksToBounds = YES;
        [_loginButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubView];
    [self initTableSubView];
    [self initNav];
}

- (void)initNav {
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 0, 50, 40)];
    [leftButton setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"home_back"] forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:leftButton];
    leftButton.mj_y = [UIApplication sharedApplication].statusBarFrame.size.height + 2;

}

/**
 返回按钮
 */
- (void)leftButtonClick {
//    [self.tableView endEditing:YES];
//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 设置view子视图
 */
- (void)initSubView {
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.footerImgView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.footerImgView.mas_top);
    }];
    [self.footerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.height.equalTo(@(ScreenW *145 / 750));
    }];
}

/**
 设置tableview子视图
 */
- (void)initTableSubView {
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 410)];
    self.tableView.tableHeaderView = self.headerView;
    
    [self.headerView addSubview:self.centerView];
    [self.centerView addSubview:self.phoneView];
    [self.centerView addSubview:self.passwordView];
    [self.centerView addSubview:self.registeButton];
    [self.centerView addSubview:self.forgetButton];
    [self.centerView addSubview:self.loginButton];
    
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView).offset(150);
        make.width.equalTo(self.headerView);
        make.height.equalTo(@255);
    }];
    [self.phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.centerView);
        make.height.equalTo(@50);
    }];
    [self.passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneView.mas_bottom);
        make.leading.trailing.equalTo(self.centerView);
        make.height.equalTo(@50);
    }];
    [self.forgetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordView.mas_bottom).offset(5);
        make.leading.equalTo(self.centerView).offset(15);
        make.trailing.equalTo(self.centerView).offset(-15);
        make.height.equalTo(@50);
    }];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.forgetButton.mas_bottom).offset(5);
        make.leading.equalTo(self.centerView).offset(15);
        make.trailing.equalTo(self.centerView).offset(-15);
        make.height.equalTo(@50);
    }];
    [self.registeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginButton.mas_bottom).offset(5);
        make.leading.equalTo(self.centerView).offset(15);
        make.trailing.equalTo(self.centerView).offset(-15);
        make.height.equalTo(@50);
    }];
}

/**
 登录
 */
- (void)loginButtonClick {
    
    [self.centerView endEditing:YES];
    if (self.phoneView.putinTF.text.length != 11 || [self.phoneView.putinTF.text isKong]) {
        [LTSCToastView showInFullWithStatus:@"请输入正确的手机号"];
        return;
    }
    if ([self.phoneView.putinTF.text isContrainsKong]) {
        [LTSCToastView showInFullWithStatus:@"不能输入带有空格的手机号"];
        return;
    }
    if ([self.passwordView.putinTF.text isKong]) {
        [LTSCToastView showInFullWithStatus:@"请输入密码!"];
        return;
    }
    if ([self.passwordView.putinTF.text isContrainsKong]) {
        [LTSCToastView showInFullWithStatus:@"密码不能输入带有空格的字符串"];
        return;
    }
    if (self.passwordView.putinTF.text.length < 6 || self.passwordView.putinTF.text.length > 15) {
        [LTSCToastView showInFullWithStatus:@"密码长度在6~15位"];
        return;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"telephone"] = self.phoneView.putinTF.text;
    dic[@"password"] = self.passwordView.putinTF.text;
    self.loginButton.userInteractionEnabled = NO;
    WeakObj(self);
    [LTSCLoadingView show];
    [LTSCNetworking networkingPOST:login parameters:dic returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [LTSCLoadingView dismiss];
        if ([responseObject[@"key"] integerValue] == 1000) {
            [LTSCToastView showSuccessWithStatus:@"登录成功"];
            [LTSCEventBus sendEvent:@"loginSuccess" data:nil];
            [LTSCTool ShareTool].session_token = [NSString stringWithFormat:@"%@", responseObject[@"result"][@"token"]];
            NSLog(@"token:%@--%@", LTSCTool.ShareTool.session_token, SESSION_TOKEN);
            
            [LTSCTool ShareTool].userModel = [LTSCUserInfoModel mj_objectWithKeyValues:responseObject[@"result"][@"map"]];
            [LTSCTool ShareTool].isLogin = YES;
            [[LTSCTool ShareTool] uploadDeviceToken];
            
             [[LTSCTool ShareTool] getHuanXinCode];
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                selfWeak.loginButton.userInteractionEnabled = YES;
                if (selfWeak.isDianpu) {
                    [selfWeak dismissViewControllerAnimated:YES completion:nil];
                } else {
                    UIApplication.sharedApplication.keyWindow.rootViewController = [LTSCTabBarVC new];
                }
            });
        }else {
            selfWeak.loginButton.userInteractionEnabled = YES;
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [LTSCLoadingView dismiss];
    }];
}

/**
 忘记密码
 */
- (void)forgetButtonClick {
    [self.headerView endEditing:YES];
    LTSCForgetPasswordVC *vc = [[LTSCForgetPasswordVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


/**
 注册
 */
- (void)registButtonClick {
    LTSCRegistVC *vc = [[LTSCRegistVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
