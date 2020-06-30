//
//  LTSCEmptyView.m
//  yumeiren
//
//  Created by 李晓满 on 2019/8/8.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LTSCEmptyView.h"

@implementation LTSCEmptyView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
        [self addSubview:self.imgView];
        [self addSubview:self.textLabel];
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.width.equalTo(@73.5);
            make.height.equalTo(@67.5);
            make.bottom.equalTo(self.mas_centerY).offset(-5);
        }];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imgView.mas_bottom).offset(23);
            make.centerX.equalTo(self);
        }];
    }
    return self;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
    }
    return _imgView;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1.0];
        _textLabel.font = [UIFont systemFontOfSize:15];
    }
    return _textLabel;
}

@end
