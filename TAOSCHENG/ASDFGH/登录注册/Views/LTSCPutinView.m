//
//  LTSCPutinView.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/15.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LTSCPutinView.h"

@implementation LTSCPutinView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.putinTF];
        [self addSubview:self.lineView];
        [self.putinTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.leading.equalTo(self).offset(15);
            make.trailing.equalTo(self).offset(-15);
            make.bottom.equalTo(self).offset(-1);
        }];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.trailing.equalTo(self).offset(-15);
            make.bottom.equalTo(self);
            make.height.equalTo(@1);
        }];
    }
    return self;
}

- (UITextField *)putinTF {
    if (!_putinTF) {
        _putinTF = [[UITextField alloc] init];
        _putinTF.font = [UIFont systemFontOfSize:16];
    }
    return _putinTF;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    }
    return _lineView;
}

@end

@interface LTSCRegistXieYiButton()

@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) UILabel *textLabel1;

@end
@implementation LTSCRegistXieYiButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.iconImgView];
        [self addSubview:self.textLabel];
        [self addSubview:self.textLabel1];
        [self addSubview:self.selectBt];
        
        [self.selectBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.bottom.equalTo(self);
            make.width.equalTo(@60);
        }];
        
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.equalTo(self);
            make.width.height.equalTo(@20);
        }];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.iconImgView.mas_trailing).offset(5);
            make.centerY.equalTo(self.iconImgView);
        }];
        [self.textLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.textLabel.mas_trailing).offset(5);
            make.centerY.equalTo(self.iconImgView);
        }];
    }
    return self;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.image = [UIImage imageNamed:@"selcet_n"];
    }
    return _iconImgView;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:13];
        _textLabel.textColor = CharacterGrayColor;
        _textLabel.text = @"我已阅读并同意";
    }
    return _textLabel;
}

- (UILabel *)textLabel1 {
    if (!_textLabel1) {
        _textLabel1 = [[UILabel alloc] init];
        _textLabel1.font = [UIFont systemFontOfSize:13];
        _textLabel1.textColor = MineColor;
        _textLabel1.text = @"《用户协议》";
    }
    return _textLabel1;
}

-(UIButton *)selectBt {
    if (_selectBt == nil) {
        _selectBt = [[UIButton  alloc] init];
    }
    return _selectBt;
}

@end
