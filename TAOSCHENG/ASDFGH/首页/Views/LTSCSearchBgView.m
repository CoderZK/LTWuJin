//
//  LTSCSearchBgView.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/17.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LTSCSearchBgView.h"


#define SearchKey @"SearchKey"

@interface LTSCSearchBgView()

@end

@implementation LTSCSearchBgView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
        [self setConstrains];
    }
    return self;
}

/**
 添加视图
 */
- (void)initSubviews {
    [self addSubview:self.topBtn];
    
    [self.topBtn addSubview:self.titleLabel];
    [self.topBtn addSubview:self.cleanImgView];
}

/**
 添加约束
 */
- (void)setConstrains {
    [self.topBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self);
        make.height.equalTo(@50);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.topBtn).offset(15);
        make.centerY.equalTo(self.topBtn);
    }];
    [self.cleanImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.topBtn).offset(-15);
        make.centerY.equalTo(self.topBtn);
        make.width.height.equalTo(@22);
    }];
}

- (UIButton *)topBtn {
    if (!_topBtn) {
        _topBtn = [[UIButton alloc] init];
    }
    return _topBtn;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"最近搜索";
        _titleLabel.textColor = CharacterDarkColor;
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _titleLabel;
}

- (UIImageView *)cleanImgView {
    if (!_cleanImgView) {
        _cleanImgView = [[UIImageView alloc] init];
        _cleanImgView.image = [UIImage imageNamed:@"clean"];
    }
    return _cleanImgView;
}


@end
