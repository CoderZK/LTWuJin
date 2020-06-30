//
//  LTSCDianPuCateTopView.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2020/4/9.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "LTSCDianPuCateTopView.h"
#import "LTSCCateListVC.h"

@interface LTSCDianPuCateTopView ()

@property (nonatomic, strong) UIButton *zongheBtn;//综合

@property (nonatomic, strong) UIButton *xiaoliangBtn;//销量

@property (nonatomic, strong) UIButton *xinpinButton;//新品

@property (nonatomic, strong) LTSCCateButton *priceBtn;//价格

@property (nonatomic, strong) NSMutableArray *btnArr;//

@property (nonatomic, assign) NSInteger count;//价格点击数量

@end


@implementation LTSCDianPuCateTopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.count = 0;
        self.btnArr = [NSMutableArray array];
        [self addSubview:self.zongheBtn];
        [self addSubview:self.xiaoliangBtn];
        [self addSubview:self.xinpinButton];
        [self addSubview:self.priceBtn];
        
        
        [self.btnArr addObject:self.zongheBtn];
        [self.btnArr addObject:self.xiaoliangBtn];
        [self.btnArr addObject:self.xinpinButton];
        [self.btnArr addObject:self.priceBtn];
        
        
        [self.zongheBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.bottom.equalTo(self);
            make.width.equalTo(@(ScreenW *0.25));
        }];
        [self.xiaoliangBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.zongheBtn.mas_trailing);
            make.top.bottom.equalTo(self);
            make.width.equalTo(@(ScreenW *0.25));
        }];
        [self.xinpinButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.xiaoliangBtn.mas_trailing);
            make.top.bottom.equalTo(self);
            make.width.equalTo(@(ScreenW *0.25));
        }];
        [self.priceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.xinpinButton.mas_trailing);
            make.top.bottom.trailing.equalTo(self);
        }];
        
        UIView * line = [[UIView alloc] init];
        line.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(self);
            make.height.equalTo(@0.5);
        }];
    }
    return self;
}

- (UIButton *)zongheBtn {
    if (!_zongheBtn) {
        _zongheBtn = [[UIButton alloc] init];
        [_zongheBtn setTitle:@"综合" forState:UIControlStateNormal];
        [_zongheBtn setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
        [_zongheBtn setTitleColor:MineColor forState:UIControlStateSelected];
        _zongheBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _zongheBtn.tag = 201;
        [_zongheBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _zongheBtn.selected = YES;
    }
    return _zongheBtn;
}

- (UIButton *)xiaoliangBtn {
    if (!_xiaoliangBtn) {
        _xiaoliangBtn = [[UIButton alloc] init];
        [_xiaoliangBtn setTitle:@"销量" forState:UIControlStateNormal];
        [_xiaoliangBtn setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
        [_xiaoliangBtn setTitleColor:MineColor forState:UIControlStateSelected];
        _xiaoliangBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _xiaoliangBtn.tag = 202;
        [_xiaoliangBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _xiaoliangBtn;
}

- (UIButton *)xinpinButton {
    if (!_xinpinButton) {
        _xinpinButton = [[UIButton alloc] init];
        [_xinpinButton setTitle:@"新品" forState:UIControlStateNormal];
        [_xinpinButton setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
        [_xinpinButton setTitleColor:MineColor forState:UIControlStateSelected];
        _xinpinButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _xinpinButton.tag = 203;
        [_xinpinButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _xinpinButton;
}

- (LTSCCateButton *)priceBtn {
    if (!_priceBtn) {
        _priceBtn = [[LTSCCateButton alloc] init];
        _priceBtn.iconImgView.image = [UIImage imageNamed:@"price_n"];
        _priceBtn.textLabel.text = @"价格";
        _priceBtn.tag = 204;
        [_priceBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _priceBtn;
}

- (void)btnClick:(UIButton *)btn {
    for (UIButton *btnn in self.btnArr) {
        if (btnn == btn) {
            btnn.selected = YES;
            if (btnn.tag == 204) {
                LTSCCateButton *bt = (LTSCCateButton *)btnn;
                bt.textLabel.textColor = MineColor;
                self.count ++;
                if (self.count%2 == 0) {
                    bt.iconImgView.image = [UIImage imageNamed:@"high"];
                }else {
                    bt.iconImgView.image = [UIImage imageNamed:@"low"];
                }
            }
            if (self.buttonClickBlock) {
                self.buttonClickBlock(btnn.tag, self.count%2);
            }
        }else {
            btnn.selected = NO;
            if (btnn.tag == 204) {
                self.count = 0;
                LTSCCateButton *bt = (LTSCCateButton *)btnn;
                bt.textLabel.textColor = CharacterDarkColor;
                bt.iconImgView.image = [UIImage imageNamed:@"price_n"];
            }
        }
        
    }
}

@end
