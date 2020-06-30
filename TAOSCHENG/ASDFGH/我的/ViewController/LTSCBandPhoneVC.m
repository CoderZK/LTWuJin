//
//  LTSCBandPhoneVC.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/21.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LTSCBandPhoneVC.h"
#import "LTSCLoginVC.h"

@interface LTSCBandPhoneVC ()

@property (nonatomic, strong) UIButton *bottomButton;//底部创建按钮

@property (nonatomic, strong) LTSCBandPhoneHeaderView *headerView;

@property (nonatomic, strong) NSTimer *timer;//倒计时

@property (nonatomic, assign) int time;//倒计时时间

@property (nonatomic, strong) NSTimer *timer1;//倒计时

@property (nonatomic, assign) int time1;//倒计时时间

@property (nonatomic, strong) LTSCBandPhoneFooterView *footerView;//底部视图

@end

@implementation LTSCBandPhoneVC

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

- (LTSCBandPhoneFooterView *)footerView {
    if (!_footerView) {
        _footerView = [[LTSCBandPhoneFooterView alloc] init];
    }
    return _footerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"绑定新手机";
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
    self.headerView = [[LTSCBandPhoneHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 120)];
    self.tableView.tableHeaderView = self.headerView;
    [self.headerView.sendCodeBtn addTarget:self action:@selector(sendCode) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *content = @"温馨提示:\n1.为保障您的账户安全,请在180s之内完成绑定新手机，否则超时无效。＼ｎ２.成功绑定新手机需要重新登陆";
    NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:content];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:2];
    [string2 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, content.length)];
    [paragraphStyle setLineBreakMode:(NSLineBreakByCharWrapping)];
    CGFloat contetH = [NSString getString:content lineSpacing:0 font:[UIFont systemFontOfSize:11] width:(ScreenW - 30)];
    self.footerView.frame = CGRectMake(0, 0, ScreenW, contetH + 30);
    self.tableView.tableFooterView = self.footerView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self daijishi];
}

- (void)daijishi{
    [self.timer1 invalidate];
    self.timer1 = nil;
    self.time1 = 180;
    self.timer1 = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer1) userInfo:nil repeats:YES];
    [self.timer1 fire];
}

/**
 定时器 验证码
 */
- (void)onTimer1 {
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"温馨提示:\n1.为保障您的账户安全,请在"];
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ds",self.time1 --] attributes:@{NSForegroundColorAttributeName:MineColor}];
    NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:@"之内完成绑定新手机，否则超时无效。\n２.成功绑定新手机需要重新登陆。" attributes:nil];
    [att appendAttributedString:str];
    [att appendAttributedString:str1];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:2];
    [paragraphStyle setLineBreakMode:(NSLineBreakByCharWrapping)];
    [att addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, att.length)];
    self.footerView.textLabel.attributedText = att;
    if (self.time1 < 0) {
        [self.timer1 invalidate];
        self.timer1 = nil;
       //提示时间到期
        [LTSCToastView showInFullWithStatus:@"已超时,请重新绑定!"];
    }
}


/**
 发送验证码
 */
- (void)sendCode {
    if (self.oneCode) {
        if (self.headerView.phoneTF.text.length == 0 || [self.headerView.phoneTF.text isKong]) {
            [LTSCToastView showInFullWithStatus:@"请输入手机号!"];
            return;
        }
        if ([self.headerView.phoneTF.text isContrainsKong]) {
            [LTSCToastView showInFullWithStatus:@"请输入不带空格的手机号!"];
            return;
        }
        if ([self.headerView.phoneTF.text isEqualToString:[LTSCTool ShareTool].userModel.tel]) {
            [LTSCToastView showInFullWithStatus:@"请输入要绑定的新手机号!"];
            return;
        }
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        [dict setObject:self.headerView.phoneTF.text forKey:@"telephone"];
        [dict setObject:@40 forKey:@"type"];
        [LTSCLoadingView show];
        [LTSCNetworking networkingPOST:app_identify parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [LTSCLoadingView dismiss];
            if ([responseObject[@"key"] integerValue] == 1000) {
                [LTSCToastView showSuccessWithStatus:@"验证码已发送"];
                [self.timer invalidate];
                self.timer = nil;
                self.time = 60;
                self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
            } else {
                [UIAlertController showAlertWithKey:responseObject[@"key"] message:responseObject[@"message"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [LTSCLoadingView dismiss];
        }];
    }else {
        [SVProgressHUD showErrorWithStatus:@"请先进行第一步验证身份操作!"];
    }
}

/**
 定时器 验证码
 */
- (void)onTimer {
    self.headerView.sendCodeBtn.enabled = NO;
    [self.headerView.sendCodeBtn setTitle:[NSString stringWithFormat:@"获取(%ds)",self.time--] forState:UIControlStateNormal];
    if (self.time < 0) {
        [self.timer invalidate];
        self.timer = nil;
        self.headerView.sendCodeBtn.enabled = YES;
        [self.headerView.sendCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}


/**
 确定
 */
- (void)sureClick {
    if (self.oneCode) {
        if (self.headerView.phoneTF.text.length == 0 || [self.headerView.phoneTF.text isKong]) {
            [LTSCToastView showInFullWithStatus:@"请输入手机号!"];
            return;
        }
        if ([self.headerView.phoneTF.text isContrainsKong]) {
            [LTSCToastView showInFullWithStatus:@"请输入不带空格的手机号!"];
            return;
        }
        if ([self.headerView.phoneTF.text isEqualToString:[LTSCTool ShareTool].userModel.tel]) {
            [LTSCToastView showInFullWithStatus:@"请输入要绑定的新手机号!"];
            return;
        }
        if (self.headerView.codeTF.text.length == 0 || [self.headerView.codeTF.text isKong]) {
            [LTSCToastView showInFullWithStatus:@"请输入验证码!"];
            return;
        }
        if ([self.headerView.codeTF.text isContrainsKong]) {
            [LTSCToastView showInFullWithStatus:@"不能输入带有空格的验证码!"];
            return;
        }
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"token"] = SESSION_TOKEN;
        dict[@"telephone"] = self.headerView.phoneTF.text;
        dict[@"modifyId"] = self.headerView.codeTF.text;
        dict[@"code"] = self.oneCode;
        [LTSCLoadingView show];
        [LTSCNetworking networkingPOST:change_tel_two parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [LTSCLoadingView dismiss];
            if ([responseObject[@"key"] integerValue] == 1000) {
                [LTSCToastView showSuccessWithStatus:@"已绑定新手机!"];
                [self exitClick];
            }else {
                [UIAlertController showAlertWithmessage:responseObject[@"message"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [LTSCLoadingView dismiss];
        }];
    }else {
        [SVProgressHUD showErrorWithStatus:@"请先进行第一步验证身份操作!"];
    }
}

/**
 退出登录
 */
- (void)exitClick {
    [LTSCNetworking networkingPOST:app_logout parameters:@{@"token":[LTSCTool ShareTool].session_token} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"key"] integerValue] == 1000) {
            [LTSCTool ShareTool].session_token = nil;
            [LTSCTool ShareTool].userModel = nil;
            [LTSCTool ShareTool].isLogin = NO;
            [[EMClient sharedClient] logout:YES];
            BaseNavigationController * nav  = [[BaseNavigationController alloc] initWithRootViewController:[[LTSCLoginVC alloc] init]];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
        }else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}


@end

@interface LTSCBandPhoneHeaderView()

@property (nonatomic, strong) UIView *phoneView;

@property (nonatomic, strong) UIView *codeView;

@property (nonatomic, strong) UIView *lineView;

@end

@implementation LTSCBandPhoneHeaderView

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
    [self addSubview:self.codeView];
    [self.phoneView addSubview:self.phoneTF];
    [self.phoneView addSubview:self.lineView];
    [self.codeView addSubview:self.codeTF];
    [self.codeView addSubview:self.sendCodeBtn];
    
}

/**
 设置约束
 */
- (void)setConstrains {
    
    [self.phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.leading.trailing.equalTo(self);
        make.height.equalTo(@60);
    }];
    [self.phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.phoneView).offset(15);
        make.trailing.equalTo(self.phoneView).offset(-15);
        make.top.bottom.equalTo(self.phoneView);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.phoneView).offset(15);
        make.bottom.trailing.equalTo(self.phoneView);
        make.height.equalTo(@.5);
    }];
    [self.codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneView.mas_bottom);
        make.leading.trailing.equalTo(self);
        make.height.equalTo(@60);
    }];
    [self.codeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.codeView).offset(15);
        make.top.bottom.equalTo(self.codeView);
        make.trailing.equalTo(self.sendCodeBtn.mas_leading);
    }];
    [self.sendCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.trailing.equalTo(self.codeView);
        make.width.equalTo(@100);
    }];
    
}

- (UIView *)phoneView {
    if (!_phoneView) {
        _phoneView = [[UIView alloc] init];
        _phoneView.backgroundColor = [UIColor whiteColor];
    }
    return _phoneView;
}

- (UITextField *)phoneTF {
    if (!_phoneTF) {
        _phoneTF = [[UITextField alloc] init];
        _phoneTF.placeholder = @"请输入手机号";
        _phoneTF.keyboardType = UIKeyboardTypeDefault;
        _phoneTF.textColor = CharacterDarkColor;
        _phoneTF.font = [UIFont systemFontOfSize:16];
    }
    return _phoneTF;
}


- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (UIView *)codeView {
    if (!_codeView) {
        _codeView = [[UIView alloc] init];
        _codeView.backgroundColor = [UIColor whiteColor];
    }
    return _codeView;
}

- (UITextField *)codeTF {
    if (!_codeTF) {
        _codeTF = [[UITextField alloc] init];
        _codeTF.placeholder = @"验证码";
        _codeTF.textColor = CharacterDarkColor;
        _codeTF.font = [UIFont systemFontOfSize:16];
    }
    return _codeTF;
}

- (UIButton *)sendCodeBtn {
    if (!_sendCodeBtn) {
        _sendCodeBtn = [[UIButton alloc] init];
        [_sendCodeBtn setBackgroundImage:[UIImage imageNamed:@"white"] forState:UIControlStateNormal];
        [_sendCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        [_sendCodeBtn setTitleColor:MineColor forState:UIControlStateNormal];
        _sendCodeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _sendCodeBtn;
}

@end


@implementation LTSCBandPhoneFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSString *content = @"温馨提示:\n1.为保障您的账户安全,请在180s之内完成绑定新手机，否则超时无效。＼ｎ２.成功绑定新手机需要重新登陆";
        NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:content];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:2];
        [paragraphStyle setLineBreakMode:(NSLineBreakByCharWrapping)];
        [string2 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, content.length)];
        CGFloat contetH = [NSString getString:content lineSpacing:0 font:[UIFont systemFontOfSize:11] width:(ScreenW - 30)];
        
        [self addSubview:self.textLabel];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.equalTo(self).offset(15);
            make.trailing.equalTo(self).offset(-15);
            make.height.equalTo(@(contetH + 30));
        }];
    }
    return self;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = CharacterGrayColor;
        _textLabel.font = [UIFont systemFontOfSize:13];
        _textLabel.numberOfLines = 0;
    }
    return _textLabel;
}

@end
