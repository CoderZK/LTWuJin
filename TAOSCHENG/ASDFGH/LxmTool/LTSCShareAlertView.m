//
//  LTSCAlertView.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/6/7.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LTSCShareAlertView.h"

@interface LTSCShareAlertView()

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UIButton *bgButton;//背景按钮

@property (nonatomic, strong) UIButton *cancelButton;//取消

@property (nonatomic, strong) LTSCShareButton *wechatButton;//微信好友

@property (nonatomic, strong) LTSCShareButton *pyqButton;//微信朋友圈

@property (nonatomic, strong) LTSCShareButton *sinaButton;//新浪微博


@end

@implementation LTSCShareAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.bgButton = [[UIButton alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [self.bgButton addTarget:self action:@selector(bgButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.bgButton];
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.cancelButton];
        [self.contentView addSubview:self.bottomView];
        [self setCornerRadius];
        [self initButtons];
        [self setConstrains];
    }
    return self;
}
/**
 初始化子视图
 */
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH, ScreenW, 250 + TableViewBottomSpace)];
        _contentView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    }
    return _contentView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, TableViewBottomSpace)];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] init];
        [_cancelButton setBackgroundImage:[UIImage imageNamed:@"tabbarwhite"] forState:UIControlStateNormal];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_cancelButton addTarget:self action:@selector(bgButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (LTSCShareButton *)wechatButton {
    if (!_wechatButton) {
        _wechatButton = [[LTSCShareButton alloc] init];
        _wechatButton.iconImgView.image = [UIImage imageNamed:@"weixin"];
        _wechatButton.textLabel.text = @"微信好友";
        _wechatButton.tag = 211;
        [_wechatButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _wechatButton;
}

- (LTSCShareButton *)pyqButton {
    if (!_pyqButton) {
        _pyqButton = [[LTSCShareButton alloc] init];
        _pyqButton.iconImgView.image = [UIImage imageNamed:@"wxpyq"];
        _pyqButton.textLabel.text = @"微信朋友圈";
        _pyqButton.tag = 212;
        [_pyqButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pyqButton;
}

- (LTSCShareButton *)sinaButton {
    if (!_sinaButton) {
        _sinaButton = [[LTSCShareButton alloc] init];
        _sinaButton.iconImgView.image = [UIImage imageNamed:@"QQ"];
        _sinaButton.textLabel.text = @"QQ";
        _sinaButton.tag = 213;
        [_sinaButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sinaButton;
}


- (void)initButtons {
    [self.contentView addSubview:self.wechatButton];
    [self.contentView addSubview:self.pyqButton];
    [self.contentView addSubview:self.sinaButton];
}

/**
 设置圆角
 */
- (void)setCornerRadius {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.contentView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(8, 8)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer.frame = self.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    self.contentView.layer.mask = maskLayer;
}

/**
 添加约束
 */
- (void)setConstrains {
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.equalTo(self.contentView);
        make.height.equalTo(@(TableViewBottomSpace));
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-TableViewBottomSpace);
        make.height.equalTo(@50);
    }];
    
    self.wechatButton.frame = CGRectMake(15, 50, 90, 90);
    self.pyqButton.frame = CGRectMake((ScreenW - 90) * 0.5, 50, 90, 90);
    self.sinaButton.frame = CGRectMake(ScreenW - 90 - 15, 50, 90, 90);
}

- (void)show {
    self.backgroundColor = UIColor.clearColor;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    _contentView.frame = CGRectMake(0, ScreenH, ScreenW, 250 + TableViewBottomSpace);
    [_contentView layoutIfNeeded];
    NSArray *arr = @[self.wechatButton, self.pyqButton, self.sinaButton];
    for (UIButton *btn in arr) {
        CGRect rect = btn.frame;
        rect.origin.y = 250;
        btn.frame = rect;
    }
    WeakObj(self);
    [UIView animateWithDuration:0.4 animations:^{
        selfWeak.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        self.contentView.frame = CGRectMake(0, ScreenH - (250 + TableViewBottomSpace), ScreenW, 250 + TableViewBottomSpace);
    } completion:^(BOOL finished) {
        
    }];
    
    for (int i = 0; i < arr.count; i++) {
        UIButton *btn = arr[i];
        [UIView animateWithDuration:0.5 delay:i * 0.2 usingSpringWithDamping:10 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGRect rect = btn.frame;
            rect.origin.y = 50;
            btn.frame = rect;
        } completion:^(BOOL finished) {
            
        }];
    }
    
}

- (void)dismiss {
    WeakObj(self);
    self.bgButton.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = UIColor.clearColor;
        self.contentView.frame = CGRectMake(0, ScreenH, ScreenW, 250 + TableViewBottomSpace);
    } completion:^(BOOL finished) {
        [selfWeak removeFromSuperview];
        self.bgButton.userInteractionEnabled = YES;
    }];
}

- (void)bgButtonClick {
    [self dismiss];
}

- (void)btnClick:(UIButton *)btn {
    if (self.shareClickBlock) {
        self.shareClickBlock(btn.tag);
    }
}

@end


@implementation LTSCShareButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.iconImgView];
        [self addSubview:self.textLabel];
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.centerX.equalTo(self);
            make.width.height.equalTo(@50);
        }];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconImgView.mas_bottom).offset(15);
            make.centerX.equalTo(self);
        }];
    }
    return self;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
    }
    return _iconImgView;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:15];
        _textLabel.textColor = CharacterDarkColor;
    }
    return _textLabel;
}

@end
