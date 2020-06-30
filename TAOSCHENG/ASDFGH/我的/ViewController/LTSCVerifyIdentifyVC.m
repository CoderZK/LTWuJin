//
//  LTSCVerifyIdentifyVC.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/21.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LTSCVerifyIdentifyVC.h"

@interface LTSCVerifyIdentifyVC ()<UITextFieldDelegate>

@property (nonatomic, strong) LTSCVerifyIdentifyHeaderView *headerView;

@property (nonatomic, strong) NSTimer *timer;//倒计时

@property (nonatomic, assign) int time;//倒计时时间

@end

@implementation LTSCVerifyIdentifyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"验证身份";
    self.tableView.separatorColor = BGGrayColor;
    self.headerView = [[LTSCVerifyIdentifyHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 120)];
    self.headerView.phoneTF.userInteractionEnabled = NO;
    self.tableView.tableHeaderView = self.headerView;
    
    [self.headerView.sendCodeBtn addTarget:self action:@selector(sendCode) forControlEvents:UIControlEventTouchUpInside];
    self.headerView.codeTF.delegate = self;;
}

/**
 发送验证码
 */
- (void)sendCode {
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setObject:[LTSCTool ShareTool].userModel.tel forKey:@"telephone"];
    [dict setObject:@30 forKey:@"type"];
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

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [self.tableView.tableHeaderView endEditing:YES];
    if (textField == self.headerView.codeTF) {
        [self oneStep];
    }
    return YES;
}

/**
 第一步完成
 */
- (void)oneStep {
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
    dict[@"telephone"] = [LTSCTool ShareTool].userModel.tel;
    dict[@"modifyId"] = self.headerView.codeTF.text;
    [LTSCLoadingView show];
    [LTSCNetworking networkingPOST:change_tel_one parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [LTSCLoadingView dismiss];
        if ([responseObject[@"key"] integerValue] == 1000) {
            [LTSCEventBus sendEvent:@"oneStepSuccess" data:responseObject[@"result"][@"data"]];
        }else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [LTSCLoadingView dismiss];
    }];
}


@end


@interface LTSCVerifyIdentifyHeaderView()

@property (nonatomic, strong) UIView *phoneView;

@property (nonatomic, strong) UIView *codeView;

@property (nonatomic, strong) UILabel *nextlabel;

@property (nonatomic, strong) UIView *lineView;

@end
@implementation LTSCVerifyIdentifyHeaderView

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
        _phoneTF.textColor = CharacterDarkColor;
        _phoneTF.font = [UIFont systemFontOfSize:16];
        if ([LTSCTool ShareTool].userModel.tel) {
            NSString *str = [NSString stringWithFormat:@"%@",[LTSCTool ShareTool].userModel.tel];
            _phoneTF.text = [str stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        }
        _phoneTF.placeholder = @"请输入手机号";
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
