
//
//  LTSCNoneView.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/6/7.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LTSCNoneView.h"

@interface LTSCNoneView ()

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UILabel *label;

@end

@implementation LTSCNoneView

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [[UIButton alloc] init];
        [_loginButton setTitle:@"立即登录" forState:UIControlStateNormal];
        [_loginButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_loginButton setBackgroundImage:[UIImage imageNamed:@"yellow"] forState:UIControlStateNormal];
        _loginButton.layer.cornerRadius = 5;
        _loginButton.layer.masksToBounds = YES;
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [_loginButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _loginButton.hidden = YES;
    }
    return _loginButton;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.groupTableViewBackgroundColor;
        [self addTarget:self action:@selector(selfClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.imgView];
        [self addSubview:self.label];
        [self addSubview:self.loginButton];
        
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_centerY).offset(-3);
            make.centerX.equalTo(self);
            make.width.height.equalTo(@150);
        }];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_centerY).offset(3);
            make.centerX.equalTo(self);
        }];
        [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.label.mas_bottom).offset(15);
            make.centerX.equalTo(self);
            make.width.equalTo(@(ScreenW - 60));
            make.height.equalTo(@44);
        }];
    }
    return self;
}

- (void)selfClick {
    if (self.clickBlock) {
        self.clickBlock();
    }
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [UIImageView new];
    }
    return _imgView;
}

- (UILabel *)label {
    if (!_label) {
        _label = [UILabel new];
        _label.font = [UIFont systemFontOfSize:14];
        _label.textColor = CharacterGrayColor;
    }
    return _label;
}

- (void)showNoneNetViewAt:(UIView *)view {
    if (view) {
        self.imgView.image = [UIImage imageNamed:@"noneNet"];
        self.label.text = @"网络错误,请刷新重试";
        [self dismiss];
        [view addSubview:self];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view);
        }];
    }
}

- (void)showNoneDataViewAt:(UIView *)view img:(UIImage *)img tips:(NSString *)tips {
    if (view) {
        self.imgView.image = img;
        self.label.text = tips;
        [self dismiss];
        [view addSubview:self];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view);
        }];
    }
}

- (void)dismiss {
    [self removeFromSuperview];
}

- (void)loginButtonClick {
    if (self.loginButtonBlock) {
        self.loginButtonBlock();
    }
}

@end
