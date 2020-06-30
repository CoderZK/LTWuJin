//
//  LTSCToastView.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/6/11.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LTSCToastView.h"

@interface LTSCToastView ()

@property (nonatomic, strong) UIImageView *iconImgView;

@property (nonatomic, strong) UILabel *messageLabel;

@property (nonatomic, strong) UIImageView *messageImgView;

@end

@implementation LTSCToastView

- (UIImageView *)messageImgView {
    if (!_messageImgView) {
        _messageImgView = [[UIImageView alloc] init];
        _messageImgView.image = [UIImage imageNamed:@"message"];
    }
    return _messageImgView;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
    }
    return _iconImgView;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.textColor = CharacterDarkColor;
        _messageLabel.font = [UIFont systemFontOfSize:15];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.numberOfLines = 0;
    }
    return _messageLabel;
}

- (instancetype)initWithFrame:(CGRect)frame withString:(NSString *)string withImage:(NSString *)image
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat w = [string getSizeWithMaxSize:CGSizeMake(9999, 30) withFontSize:15].width;
        CGFloat HH = [string getSizeWithMaxSize:CGSizeMake(ScreenW - 90, 9999) withFontSize:15].height;
        if (w < 200) {
            w = 200;
        } else if (w > ScreenW - 90) {
            w = ScreenW - 90;
        }

    
        [self addSubview:self.messageImgView];
        [self.messageImgView addSubview:self.iconImgView];
        [self.messageImgView addSubview:self.messageLabel];
        [self.messageImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.equalTo(@(w+20));
            make.height.equalTo(@(HH + 70));
        }];
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self.messageImgView.mas_centerY).offset(-5);
            make.top.equalTo(self.messageImgView).offset(15);
            make.centerX.equalTo(self.messageImgView);
            make.width.height.equalTo(@25);
        }];
        [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconImgView.mas_bottom).offset(15);
            make.centerX.equalTo(self.messageImgView.mas_centerX);
            make.left.equalTo(self.messageImgView).offset(30);
            make.right.equalTo(self.messageImgView).offset(-30);
        }];
        self.iconImgView.image = [UIImage imageNamed:image];
        self.messageLabel.text = string;
        
    }
    return self;
}

+ (void)showSuccessWithStatus:(NSString *)string {
    [self dismiss];
    LTSCToastView *toastView = [[LTSCToastView alloc] initWithFrame:UIScreen.mainScreen.bounds withString:string withImage:@"chenggong"];
    toastView.tag = 654321;
    toastView.alpha = 0.8;
    [[UIApplication sharedApplication].keyWindow addSubview:toastView];
    [UIView animateWithDuration:0.15 animations:^{
        toastView.alpha = 1;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismiss];
        });
    }];
}

+ (void)showErrorWithStatus:(NSString *)string {
    [self dismiss];
    LTSCToastView *toastView = [[LTSCToastView alloc] initWithFrame:UIScreen.mainScreen.bounds withString:string withImage:@"shibai"];
    toastView.tag = 654321;
    toastView.alpha = 0.8;
    [[UIApplication sharedApplication].keyWindow addSubview:toastView];
    [UIView animateWithDuration:0.15 animations:^{
        toastView.alpha = 1;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismiss];
            
            if ([string isEqualToString:@"未登录"]) {
                
                BaseNavigationController * nav  = [[BaseNavigationController alloc] initWithRootViewController:[[LTSCLoginVC alloc] init]];
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
            }
        });
    }];
}

+ (void)showInFullWithStatus:(NSString *)string {
    [self dismiss];
    LTSCToastView *toastView = [[LTSCToastView alloc] initWithFrame:UIScreen.mainScreen.bounds withString:string withImage:@"tishi"];
    toastView.tag = 654321;
    toastView.alpha = 0.8;
    [[UIApplication sharedApplication].keyWindow addSubview:toastView];
    [UIView animateWithDuration:0.15 animations:^{
        toastView.alpha = 1;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismiss];
        });
    }];
}

+ (void)dismiss {
    UIView *preView = [[UIApplication sharedApplication].delegate.window viewWithTag:654321];
    [preView removeFromSuperview];
}


@end
