//
//  LTSCMyOrderDetailWuLiuCell.m
//  TAOSCHENG
//
//  Created by kunzhang on 2020/5/30.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "LTSCMyOrderDetailWuLiuCell.h"

@implementation LTSCMyOrderDetailWuLiuCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.layer.masksToBounds = YES;
        self.clipsToBounds = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = MineColor;//[UIColor colorWithRed:241/255.0 green:182/255.0 blue:191/255.0 alpha:1];
        [self initSubViews];
        [self setConstrains];
    }
    return self;
}

/**
 添加视图
 */
- (void)initSubViews {
    [self addSubview:self.iconImgView];
    [self addSubview:self.stateLabel];
    [self addSubview:self.detailLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.accImgView];
}

/**
 添加约束
 */
- (void)setConstrains {
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self).offset(15);
        make.width.height.equalTo(@20);
    }];
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.iconImgView.mas_trailing).offset(10);
        make.centerY.equalTo(self.iconImgView);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stateLabel.mas_bottom).offset(10);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-35);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailLabel.mas_bottom).offset(10);
        make.leading.equalTo(self).offset(15);
        make.bottom.equalTo(self).offset(-15);
    }];
    [self.accImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-15);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@15);
    }];
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [UIImageView new];
    }
    return _iconImgView;
}

- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [UILabel new];
        _stateLabel.font = [UIFont systemFontOfSize:14];
        _stateLabel.textColor = [UIColor whiteColor];
    }
    return _stateLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
        _detailLabel.textColor = [UIColor whiteColor];
        _detailLabel.numberOfLines = 0;
        _detailLabel.font = [UIFont systemFontOfSize:14];
    }
    return _detailLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.hidden = NO;
    }
    return _timeLabel;
}

- (UIImageView *)accImgView {
    if (!_accImgView) {
        _accImgView = [UIImageView new];
    }
    return _accImgView;
}


- (void)setModel:(LTSCWuLiuInfoStateModel *)model {
    _model = model;
    self.stateLabel.text = _model.title;
    
    if (_model.list.count >= 1) {
        self.detailLabel.text = _model.list.firstObject.context;
        self.timeLabel.text = _model.list.firstObject.create_time;
    } else {
        self.detailLabel.text = @"物流信息:暂无物流信息";
    }
    if ([_model.title isEqualToString:@"已签收"]) {
        _iconImgView.image = [UIImage imageNamed:@"order_qrsh"];
    } else {
        _iconImgView.image = [UIImage imageNamed:@"order_dsh"];
    }
}


@end
