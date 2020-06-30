//
//  LTSCForgetPasswordVC.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/22.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LTSCForgetPasswordVC.h"
#import "LTSCPutinView.h"

@interface LTSCForgetPasswordVC ()

@property (nonatomic, strong) UIImageView *footerImgView;//底部背景

@property (nonatomic, strong) LTSCPutinView *phoneView;//负责人手机号

@property (nonatomic, strong) UIButton *codeButton;//获取验证码

@property (nonatomic, strong) LTSCPutinView *codeView;//验证码

@property (nonatomic, strong) LTSCPutinView *passwordView;//密码

@property (nonatomic, strong) LTSCPutinView *surePasswordView;//确认密码

@property (nonatomic, strong) UIButton *submitButton;//提交

@property (nonatomic, strong) NSTimer *timer;//倒计时

@property (nonatomic, assign) int time;//倒计时时间

@end

@implementation LTSCForgetPasswordVC

- (UIImageView *)footerImgView {
    if (!_footerImgView) {
        _footerImgView = [[UIImageView alloc] init];
        _footerImgView.image = [UIImage imageNamed:@"bgImage"];
        _footerImgView.backgroundColor = [UIColor whiteColor];
    }
    return _footerImgView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubView];
    [self initSubViews];
    [self setConstrains];
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
 初始化
 */
- (void)initSubViews {
    [self.tableView addSubview:self.phoneView];
    [self.phoneView addSubview:self.codeButton];
    [self.tableView addSubview:self.codeView];
    [self.tableView addSubview:self.passwordView];
    [self.tableView addSubview:self.surePasswordView];
    [self.tableView addSubview:self.submitButton];
}

- (void)setConstrains {
    [self.phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView);
        make.leading.trailing.equalTo(self.tableView);
        make.height.equalTo(@50);
        make.width.equalTo(@(ScreenW));
    }];
    [self.phoneView.putinTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.phoneView);
        make.leading.equalTo(self.phoneView).offset(15);
        make.trailing.equalTo(self.phoneView).offset(-115);
    }];
    [self.codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.phoneView);
        make.trailing.equalTo(self.phoneView).offset(-15);
        make.width.equalTo(@100);
    }];
    [self.codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneView.mas_bottom);
        make.leading.trailing.equalTo(self.tableView);
        make.height.equalTo(@50);
    }];
    [self.passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeView.mas_bottom);
        make.leading.trailing.equalTo(self.tableView);
        make.height.equalTo(@50);
    }];
    [self.surePasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordView.mas_bottom);
        make.leading.trailing.equalTo(self.tableView);
        make.height.equalTo(@50);
    }];
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.surePasswordView.mas_bottom).offset(20);
        make.leading.equalTo(self.tableView).offset(15);
        make.trailing.equalTo(self.tableView).offset(-15);
        make.height.equalTo(@50);
    }];
}

- (LTSCPutinView *)phoneView {
    if (!_phoneView) {
        _phoneView = [[LTSCPutinView alloc] init];
        _phoneView.putinTF.placeholder = @"手机号";
        _phoneView.putinTF.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _phoneView;
}

- (UIButton *)codeButton {
    if (!_codeButton) {
        _codeButton = [[UIButton alloc] init];
        [_codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_codeButton setTitleColor:MineColor forState:UIControlStateNormal];
        _codeButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_codeButton addTarget:self action:@selector(getCodeClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _codeButton;
}

- (LTSCPutinView *)codeView {
    if (!_codeView) {
        _codeView = [[LTSCPutinView alloc] init];
        _codeView.putinTF.placeholder = @"验证码";
    }
    return _codeView;
}

- (LTSCPutinView *)passwordView {
    if (!_passwordView) {
        _passwordView = [[LTSCPutinView alloc] init];
        _passwordView.putinTF.placeholder = @"密码";
        _passwordView.putinTF.secureTextEntry = YES;
    }
    return _passwordView;
}
- (LTSCPutinView *)surePasswordView {
    if (!_surePasswordView) {
        _surePasswordView = [[LTSCPutinView alloc] init];
        _surePasswordView.putinTF.placeholder = @"确认密码";
        _surePasswordView.putinTF.secureTextEntry = YES;
    }
    return _surePasswordView;
}

- (UIButton *)submitButton {
    if (!_submitButton) {
        _submitButton = [[UIButton alloc] init];
        [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
        [_submitButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_submitButton setBackgroundImage:[UIImage imageNamed:@"yellow"] forState:UIControlStateNormal];
        _submitButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _submitButton.layer.cornerRadius = 3;
        _submitButton.layer.masksToBounds = YES;
        [_submitButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}

/**
 事件处理
 */
- (void)getCodeClick {
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    if (self.phoneView.putinTF.text.length == 0 || [self.phoneView.putinTF.text isKong]) {
        [LTSCToastView showInFullWithStatus:@"请输入手机号"];
        return;
    }
    if (self.phoneView.putinTF.text.length!= 11) {
        [LTSCToastView showInFullWithStatus:@"请输入11位的手机号"];
        return;
    }
    [dict setObject:self.phoneView.putinTF.text forKey:@"telephone"];
    [dict setObject:@20 forKey:@"type"];
    [LTSCLoadingView show];
    self.codeButton.userInteractionEnabled = NO;
    [LTSCNetworking networkingPOST:app_identify parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [LTSCLoadingView dismiss];
        self.codeButton.userInteractionEnabled = YES;
        if ([responseObject[@"key"] integerValue] == 1000) {
            [self.timer invalidate];
            self.timer = nil;
            self.time = 60;
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
            
        } else {
            [UIAlertController showAlertWithKey:responseObject[@"key"] message:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        self.codeButton.userInteractionEnabled = YES;
        [LTSCLoadingView dismiss];
    }];
}

/**
 定时器 验证码
 */
- (void)onTimer {
    self.codeButton.enabled = NO;
    [self.codeButton setTitle:[NSString stringWithFormat:@"获取(%ds)",self.time--] forState:UIControlStateNormal];
    if (self.time < 0) {
        [self.timer invalidate];
        self.timer = nil;
        self.codeButton.enabled = YES;
        [self.codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}

/**
 找回密码
 */
- (void)submit {
    if (self.phoneView.putinTF.text.length == 0 || [self.phoneView.putinTF.text isKong]) {
        [LTSCToastView showInFullWithStatus:@"请输入手机号"];
        return;
    }
    if (self.phoneView.putinTF.text.length!= 11) {
        [LTSCToastView showInFullWithStatus:@"请输入11位的手机号"];
        return;
    }
    if (self.codeView.putinTF.text.length == 0 || [self.codeView.putinTF.text isKong]) {
        [LTSCToastView showInFullWithStatus:@"请输入验证码"];
        return;
    }
    if (self.passwordView.putinTF.text.length == 0 || [self.passwordView.putinTF.text isKong]) {
        [LTSCToastView showInFullWithStatus:@"请输入密码"];
        return;
    }
    if (self.passwordView.putinTF.text.length < 6 || self.passwordView.putinTF.text.length > 15) {
        [LTSCToastView showInFullWithStatus:@"密码长度在6~15位"];
        return;
    }
    if (self.surePasswordView.putinTF.text.length == 0 || [self.surePasswordView.putinTF.text isKong]) {
        [LTSCToastView showInFullWithStatus:@"请再次输入密码"];
        return;
    }
    if (self.surePasswordView.putinTF.text.length < 6 || self.surePasswordView.putinTF.text.length > 15) {
        [LTSCToastView showInFullWithStatus:@"确认密码长度在6~15位"];
        return;
    }
    if (![self.passwordView.putinTF.text isEqualToString:self.surePasswordView.putinTF.text]) {
        [LTSCToastView showInFullWithStatus:@"两次输入的密码不一致"];
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"telephone"] = self.phoneView.putinTF.text;
    dict[@"modifyId"] = self.codeView.putinTF.text;
    dict[@"newPass"] = self.passwordView.putinTF.text;
    self.submitButton.userInteractionEnabled = NO;
    [LTSCLoadingView show];
    [LTSCNetworking networkingPOST:back_pass parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        self.submitButton.userInteractionEnabled = YES;
        [LTSCLoadingView dismiss];
        if ([responseObject[@"key"] integerValue] == 1000) {
            [LTSCToastView showSuccessWithStatus:@"密码已重置"];
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [LTSCLoadingView dismiss];
        self.submitButton.userInteractionEnabled = YES;
    }];
}

@end
