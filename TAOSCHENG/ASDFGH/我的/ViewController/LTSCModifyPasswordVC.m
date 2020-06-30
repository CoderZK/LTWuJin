//
//  LTSCModifyPasswordVC.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/21.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LTSCModifyPasswordVC.h"
#import "LTSCPutinView.h"
#import "LTSCModifyPasswordSuccessVC.h"

@interface LTSCModifyPasswordVC ()

@property (nonatomic, strong) UIButton *bottomButton;//底部创建按钮

@property (nonatomic, strong) LTSCPutinView *oldPasswordView;//旧密码

@property (nonatomic, strong) LTSCPutinView *passwordView;//新密码

@property (nonatomic, strong) LTSCPutinView *surePasswordView;//确认密码

@end

@implementation LTSCModifyPasswordVC

- (LTSCPutinView *)oldPasswordView {
    if (!_oldPasswordView) {
        _oldPasswordView = [[LTSCPutinView alloc] init];
        _oldPasswordView.putinTF.placeholder = @"旧密码";
        _oldPasswordView.putinTF.secureTextEntry = YES;
    }
    return _oldPasswordView;
}

- (LTSCPutinView *)passwordView {
    if (!_passwordView) {
        _passwordView = [[LTSCPutinView alloc] init];
        _passwordView.putinTF.placeholder = @"新密码";
        _passwordView.putinTF.secureTextEntry = YES;
    }
    return _passwordView;
}

- (LTSCPutinView *)surePasswordView {
    if (!_surePasswordView) {
        _surePasswordView = [[LTSCPutinView alloc] init];
        _surePasswordView.putinTF.placeholder = @"确认新密码";
        _surePasswordView.putinTF.secureTextEntry = YES;
    }
    return _surePasswordView;
}

- (UIButton *)bottomButton {
    if (!_bottomButton) {
        _bottomButton = [[UIButton alloc] init];
        [_bottomButton setTitle:@"确定" forState:UIControlStateNormal];
        [_bottomButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_bottomButton setBackgroundImage:[UIImage imageNamed:@"yellow"] forState:UIControlStateNormal];
        _bottomButton.layer.cornerRadius = 3;
        _bottomButton.layer.masksToBounds = YES;
        [_bottomButton addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改密码";
    [self.view addSubview:self.bottomButton];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(1);
        make.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.bottomButton.mas_top);
    }];
    if (kDevice_Is_iPhoneX) {
        [self.bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tableView.mas_bottom);
            make.leading.equalTo(self.view).offset(15);
            make.trailing.equalTo(self.view).offset(-15);
            make.bottom.equalTo(self.view).offset(-(15 + TableViewBottomSpace));
            make.height.equalTo(@50);
        }];
    }else {
        [self.bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tableView.mas_bottom);
            make.leading.equalTo(self.view).offset(15);
            make.trailing.equalTo(self.view).offset(-15);
            make.bottom.equalTo(self.view).offset(-15);
            make.height.equalTo(@50);
        }];
    }
    [self initHeaderView];
}

- (void)initHeaderView {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 150)];
    headView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = headView;
    [headView addSubview:self.oldPasswordView];
    [headView addSubview:self.passwordView];
    [headView addSubview:self.surePasswordView];
    [self.oldPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(headView);
        make.height.equalTo(@50);
    }];
    [self.passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.oldPasswordView.mas_bottom);
        make.leading.trailing.equalTo(headView);
        make.height.equalTo(@50);
    }];
    [self.surePasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordView.mas_bottom);
        make.leading.trailing.equalTo(headView);
        make.height.equalTo(@50);
    }];
}

/**
 确定
 */
- (void)sureClick {
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    if (self.oldPasswordView.putinTF.text.length == 0 || [self.oldPasswordView.putinTF.text isKong]) {
        [LTSCToastView showInFullWithStatus:@"请输入旧密码"];
        return;
    }
    if (self.passwordView.putinTF.text.length == 0 || [self.passwordView.putinTF.text isKong]) {
        [LTSCToastView showInFullWithStatus:@"请输入新密码"];
        return;
    }
    if (self.passwordView.putinTF.text.length < 6 || self.passwordView.putinTF.text.length > 15) {
        [LTSCToastView showInFullWithStatus:@"密码长度在6~15位"];
        return;
    }
    
    if (self.surePasswordView.putinTF.text.length == 0 || [self.surePasswordView.putinTF.text isKong]) {
        [LTSCToastView showInFullWithStatus:@"请再次输入新密码"];
        return;
    }
    if (self.surePasswordView.putinTF.text.length < 6 || self.surePasswordView.putinTF.text.length > 15) {
        [LTSCToastView showInFullWithStatus:@"确认密码长度在6~15位"];
        return;
    }
    if (![self.passwordView.putinTF.text isEqualToString:self.surePasswordView.putinTF.text]) {
        [LTSCToastView showInFullWithStatus:@"两次输入的新密码不一致"];
        return;
    }
    if ([self.oldPasswordView.putinTF.text isEqualToString:self.passwordView.putinTF.text]) {
        [LTSCToastView showInFullWithStatus:@"请输入不一样的新密码"];
        return;
    }
    [dict setObject:[LTSCTool ShareTool].session_token forKey:@"token"];
    [dict setObject:self.oldPasswordView.putinTF.text forKey:@"oldPass"];
    [dict setObject:self.passwordView.putinTF.text forKey:@"newPass"];
    [LTSCLoadingView show];
    [LTSCNetworking networkingPOST:change_pass parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [LTSCLoadingView dismiss];
        if ([responseObject[@"key"] integerValue] == 1000) {
            [LTSCTool ShareTool].session_token = nil;
            [LTSCTool ShareTool].userModel = nil;
            [LTSCTool ShareTool].isLogin = NO;
            [[EMClient sharedClient] logout:YES];
            LTSCModifyPasswordSuccessVC *vc = [[LTSCModifyPasswordSuccessVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [UIAlertController showAlertWithKey:responseObject[@"key"] message:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [LTSCLoadingView dismiss];
    }];
    
}

@end
