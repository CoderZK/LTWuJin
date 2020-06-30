//
//  LTSCGoodsDeatilTopView.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/17.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LTSCGoodsDeatilTopView.h"

@implementation LTSCGoodsDeatilTopView

@end

@interface LTSCGoodsDeatilNavView()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIButton *leftButton;

@property (nonatomic, strong) UIButton *zhidingButton;



@end
@implementation LTSCGoodsDeatilNavView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.leftButton];
        [self.bgView addSubview:self.zhidingButton];
        [self.bgView addSubview:self.shareButton];
        [self.bgView addSubview:self.lineView];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(StateBarH);
            make.leading.trailing.equalTo(self);
            make.bottom.equalTo(self);
        }];
        [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.bgView).offset(15);
            make.width.height.equalTo(@25);
            make.centerY.equalTo(self.bgView);
        }];
        [self.zhidingButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.shareButton.mas_leading).offset(-20);
            make.width.height.equalTo(@25);
            make.centerY.equalTo(self.bgView);
        }];
        [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.bgView).offset(-15);
            make.width.height.equalTo(@25);
            make.centerY.equalTo(self.bgView);
        }];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.leading.trailing.equalTo(self.bgView);
            make.height.equalTo(@0.5);
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

- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [[UIButton alloc] init];
        [_leftButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _leftButton.tag = 100;
    }
    return _leftButton;
}

- (UIButton *)zhidingButton {
    if (!_zhidingButton) {
        _zhidingButton = [[UIButton alloc] init];
        [_zhidingButton setBackgroundImage:[UIImage imageNamed:@"zhiding"] forState:UIControlStateNormal];
        [_zhidingButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _zhidingButton.tag = 101;
    }
    return _zhidingButton;
}

- (UIButton *)shareButton {
    if (!_shareButton) {
        _shareButton = [[UIButton alloc] init];
        [_shareButton setBackgroundImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _shareButton.tag = 102;
    }
    return _shareButton;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (void)btnClick:(UIButton *)btn {
    if (self.navButtonSelectIndex) {
        self.navButtonSelectIndex(btn.tag);
    }
}

@end
