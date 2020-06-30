//
//  LTSCRegistView.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/15.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LTSCRegistVC.h"
#import "LTSCTabBarVC.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import "MXPhotoPickerController.h"
#import "UIViewController+MXPhotoPicker.h"
#import "LTSCWebViewController.h"
@interface LTSCRegistVC ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIView *headerView;//头视图

@property (nonatomic, strong) LTSCGerenView *gerenView;//个人注册view

@property (nonatomic, strong) UIImageView *footerImgView;//底部背景

@property (nonatomic, strong) NSTimer *timer;//倒计时

@property (nonatomic, assign) int time;//倒计时时间

@end

@implementation LTSCRegistVC

- (UIImageView *)footerImgView {
    if (!_footerImgView) {
        _footerImgView = [[UIImageView alloc] init];
        _footerImgView.image = [UIImage imageNamed:@"bgImage"];
        _footerImgView.backgroundColor = [UIColor whiteColor];
    }
    return _footerImgView;
}


- (LTSCGerenView *)gerenView {
    if (!_gerenView) {
        _gerenView = [[LTSCGerenView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 570 + 50)];
        [_gerenView.xieYibutton addTarget:self action:@selector(seeProtocol) forControlEvents:UIControlEventTouchUpInside];
        
        [_gerenView.xieYibutton.selectBt addTarget:self action:@selector(selectAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _gerenView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubView];
    [self initTableSubView];
    [self gerenEvent];
}


/// 查看协议
- (void)seeProtocol {
    
    LTSCWebViewController * vc =[[LTSCWebViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.loadUrl = [NSURL URLWithString:@"https://www.zmzt99.com/submit/submitRule.html"];
    vc.navigationItem.title = @"注册协议";
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)selectAction {
    
    
    if ([self.gerenView.xieYibutton.iconImgView.image isEqual:[UIImage imageNamed:@"selcet_n"]]) {
        self.gerenView.xieYibutton.iconImgView.image = [UIImage imageNamed:@"selcet_y"];
    }else {
        self.gerenView.xieYibutton.iconImgView.image = [UIImage imageNamed:@"selcet_n"];
    }

    
}


/**
 设置view子视图
 */
- (void)initSubView {
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.footerImgView];
    [self.footerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.height.equalTo(@(ScreenW *145 / 750));
    }];
    [self.view bringSubviewToFront:self.tableView];
}

/**
 设置tableview子视图
 */
- (void)initTableSubView {
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, self.view.bounds.size.height)];
    self.tableView.tableHeaderView = self.headerView;
    self.navigationItem.title = @"注册";
    [self.headerView addSubview:self.gerenView];
}

- (void)registButtonClick:(UIButton *)btn {
    if ([self.gerenView.xieYibutton.iconImgView.image isEqual:[UIImage imageNamed:@"selcet_n"]]) {
        [SVProgressHUD showErrorWithStatus:@"请勾选注协协议"];
        return;
    }
    [self gerenRegist];
}

/**
 获取验证码 "1注册
 */
- (void)getCodeClick:(UIButton *)btn {
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    if (self.gerenView.phoneView.putinTF.text.length == 0 || [self.gerenView.phoneView.putinTF.text isKong]) {
        [LTSCToastView showInFullWithStatus:@"请输入手机号"];
        return;
    }
    if (self.gerenView.phoneView.putinTF.text.length!= 11) {
        [LTSCToastView showInFullWithStatus:@"请输入11位的手机号"];
        return;
    }
    [dict setObject:self.gerenView.phoneView.putinTF.text forKey:@"telephone"];
    [dict setObject:@10 forKey:@"type"];
    [LTSCLoadingView show];
    [LTSCNetworking networkingPOST:app_identify parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [LTSCLoadingView dismiss];
        if ([responseObject[@"key"] integerValue] == 1000) {
            [SVProgressHUD showSuccessWithStatus:@"发送验证码成功"];
            [self.timer invalidate];
            self.timer = nil;
            self.time = 60;
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer1) userInfo:nil repeats:YES];
           
        } else {
            [UIAlertController showAlertWithKey:responseObject[@"key"] message:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [LTSCLoadingView dismiss];
    }];
}

/**
 定时器 验证码
 */
- (void)onTimer1 {
    self.gerenView.codeButton.enabled = NO;
    [self.gerenView.codeButton setTitle:[NSString stringWithFormat:@"获取(%ds)",self.time--] forState:UIControlStateNormal];
    if (self.time < 0) {
        [self.timer invalidate];
        self.timer = nil;
        self.gerenView.codeButton.enabled = YES;
        [self.gerenView.codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}

/**
 个人注册 事件处理
 */
- (void)gerenEvent {
    [self.gerenView.codeButton addTarget:self action:@selector(getCodeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.gerenView.registeButton addTarget:self action:@selector(registButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.gerenView.xieYibutton addTarget:self action:@selector(xieyiClick:) forControlEvents:UIControlEventTouchUpInside];
}

/**
 个人注册 事件处理
 */
- (void)gerenRegist {
    if (self.gerenView.phoneView.putinTF.text.length == 0 || [self.gerenView.phoneView.putinTF.text isKong]) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
        return;
    }
    if (self.gerenView.codeView.putinTF.text.length == 0 || [self.gerenView.codeView.putinTF.text isKong]) {
        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
        return;
    }
    if (self.gerenView.passwordView.putinTF.text.length == 0 || [self.gerenView.passwordView.putinTF.text isKong]) {
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return;
    }
    if (self.gerenView.surePasswordView.putinTF.text.length == 0 || [self.gerenView.surePasswordView.putinTF.text isKong]) {
        [SVProgressHUD showErrorWithStatus:@"请再次输入密码"];
        return;
    }
    if (![self.gerenView.passwordView.putinTF.text isEqualToString:self.gerenView.surePasswordView.putinTF.text]) {
        [SVProgressHUD showErrorWithStatus:@"两次输入的密码不一致"];
        return;
    }
    [self geRenRegist];
}

/**
 个人注册
 */
- (void)geRenRegist {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"telephone"] = self.gerenView.phoneView.putinTF.text;
    dict[@"modifyId"] = self.gerenView.codeView.putinTF.text;
    dict[@"password"] = self.gerenView.passwordView.putinTF.text;
    self.gerenView.registeButton.userInteractionEnabled = NO;
    WeakObj(self);
    [LTSCLoadingView show];
    [LTSCNetworking networkingPOST:n_user_submit parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [LTSCLoadingView dismiss];
        if ([responseObject[@"key"] integerValue] == 1000) {
            [LTSCToastView showSuccessWithStatus:@"注册成功"];
            [LTSCTool ShareTool].session_token = responseObject[@"result"][@"token"];
            [LTSCTool ShareTool].userModel = [LTSCUserInfoModel mj_objectWithKeyValues:responseObject[@"result"][@"map"]];
            [LTSCTool ShareTool].isLogin = YES;
            [[LTSCTool ShareTool] uploadDeviceToken];
            [self getHuanXinMessage];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                selfWeak.gerenView.registeButton.userInteractionEnabled = YES;
                [UIApplication sharedApplication].keyWindow.rootViewController = [[LTSCTabBarVC alloc] init];
            });
        }else {
            selfWeak.gerenView.registeButton.userInteractionEnabled = YES;
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [LTSCLoadingView dismiss];
        selfWeak.gerenView.registeButton.userInteractionEnabled = YES;
    }];
}


- (void)getHuanXinMessage {
    
  
    WeakObj(self);
    NSMutableDictionary * dict = @{}.mutableCopy;
    dict[@"token"] = [LTSCTool ShareTool].session_token;
          [LTSCNetworking networkingPOST:get_huanxin parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject){
            [SVProgressHUD dismiss];
            if ([responseObject[@"key"] intValue] == 1000) {
               
           
                [LTSCTool ShareTool].userModel.imCode = responseObject[@"result"][@"map"][@"imCode"];
                 [LTSCTool ShareTool].userModel.imPass = responseObject[@"result"][@"map"][@"imPass"];
                           //登录环信
                [LTSCTool.ShareTool loginHuanXin];
                
    //            [selfWeak.navigationController pushViewController:self animated:YES];
    //            [selfWeak.navigationController popViewControllerAnimated:YES];
            } else {
//                [UIAlertController showAlertWithmessage:responseObject[@"message"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
           
            [SVProgressHUD dismiss];
        }];
    
}


- (void)xieyiClick:(LTSCRegistXieYiButton *)btn {
//    btn.selected = !btn.selected;
//    btn.iconImgView.image = [UIImage imageNamed:btn.selected ? @"selcet_y" : @"selcet_n"];
}
@end

@interface LTSCRegistTopView ()

@property (nonatomic, strong) UIButton *qiyeButton;//企业注册

@property (nonatomic, strong) UIButton *gerenButton;//个人注册

@property (nonatomic, strong) UIView *lineView;//黄线

@property (nonatomic, strong) UIView *bgView;//黄线

@end

@implementation LTSCRegistTopView

- (CGSize)intrinsicContentSize {
    return UILayoutFittingExpandedSize;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.bgView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.qiyeButton];
        [self.bgView addSubview:self.gerenButton];
        [self.bgView addSubview:self.lineView];
        [self.qiyeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.bgView.mas_centerX).offset(-10);
            make.width.equalTo(@100);
            make.height.equalTo(@40);
        }];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.qiyeButton);
            make.bottom.equalTo(self.qiyeButton);
            make.width.equalTo(@30);
            make.height.equalTo(@3);
        }];
        [self.gerenButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.bgView.mas_centerX).offset(10);
            make.width.equalTo(@100);
            make.height.equalTo(@40);
        }];
    }
    return self;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
    }
    return _bgView;
}

- (UIButton *)qiyeButton {
    if (!_qiyeButton) {
        _qiyeButton = [[UIButton alloc] init];
        [_qiyeButton setTitle:@"企业注册" forState:UIControlStateNormal];
        [_qiyeButton setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
        _qiyeButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_qiyeButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _qiyeButton;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = MineColor;
        _lineView.layer.cornerRadius = 1.5;
        _lineView.layer.masksToBounds = YES;
    }
    return _lineView;
}

- (UIButton *)gerenButton {
    if (!_gerenButton) {
        _gerenButton = [[UIButton alloc] init];
        [_gerenButton setTitle:@"个人注册" forState:UIControlStateNormal];
        [_gerenButton setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
        _gerenButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_gerenButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _gerenButton;
}

- (void)btnClick:(UIButton *)btn {
    NSInteger index = 0;
    if (btn == _qiyeButton) {
        index = 0;
        [UIView animateWithDuration:0.3 animations:^{
            [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.qiyeButton);
                make.bottom.equalTo(self.qiyeButton);
                make.width.equalTo(@30);
                make.height.equalTo(@3);
            }];
        }];
    }else {
        index = 1;
        [UIView animateWithDuration:0.3 animations:^{
            [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.gerenButton);
                make.bottom.equalTo(self.gerenButton);
                make.width.equalTo(@30);
                make.height.equalTo(@3);
            }];
        }];
    }
    if (self.buttonClickBlock) {
        self.buttonClickBlock(index);
    }
}

- (void)selectIndex:(NSInteger)index {
    if (index == 0) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.qiyeButton);
                make.bottom.equalTo(self.qiyeButton);
                make.width.equalTo(@30);
                make.height.equalTo(@3);
            }];
        }];
    }else {
        [UIView animateWithDuration:0.3 animations:^{
            [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.gerenButton);
                make.bottom.equalTo(self.gerenButton);
                make.width.equalTo(@30);
                make.height.equalTo(@3);
            }];
        }];
    }
}






@end

/**
 个人注册
 */
@implementation LTSCGerenView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
        [self setConstrains];
    }
    return self;
}

/**
 添加子视图
 */
- (void)initSubviews {
    [self addSubview:self.phoneView];
    [self.phoneView addSubview:self.codeButton];
    [self addSubview:self.codeView];
    [self addSubview:self.passwordView];
    [self addSubview:self.surePasswordView];
    [self addSubview:self.xieYibutton];
    
    [self addSubview:self.registeButton];
}

/**
 设置约束
 */
- (void)setConstrains {
    [self.phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self);
        make.height.equalTo(@50);
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
        make.leading.trailing.equalTo(self);
        make.height.equalTo(@50);
    }];
    [self.passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeView.mas_bottom);
        make.leading.trailing.equalTo(self);
        make.height.equalTo(@50);
    }];
    [self.surePasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordView.mas_bottom);
        make.leading.trailing.equalTo(self);
        make.height.equalTo(@50);
    }];
    [self.xieYibutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.surePasswordView.mas_bottom).offset(20);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.height.equalTo(@50);
    }];
    [self.registeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xieYibutton.mas_bottom);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
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

- (LTSCRegistXieYiButton *)xieYibutton {
    if (!_xieYibutton) {
        _xieYibutton = [[LTSCRegistXieYiButton alloc] init];
       
    }
    return _xieYibutton;
}


- (UIButton *)registeButton {
    if (!_registeButton) {
        _registeButton = [[UIButton alloc] init];
        [_registeButton setTitle:@"注册" forState:UIControlStateNormal];
        [_registeButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_registeButton setBackgroundImage:[UIImage imageNamed:@"yellow"] forState:UIControlStateNormal];
        _registeButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _registeButton.layer.cornerRadius = 3;
        _registeButton.layer.masksToBounds = YES;
    }
    return _registeButton;
}

@end
