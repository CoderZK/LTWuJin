//
//  LTSCCateLeftTableCell.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/16.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LTSCCateLeftTableCell.h"

@interface LTSCCateLeftTableCell()

@end

@implementation LTSCCateLeftTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.yellowLineView];
        [self addSubview:self.titleLabel];
        [self.yellowLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self);
            make.centerY.equalTo(self);
            make.width.equalTo(@3);
            make.height.equalTo(@20);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.yellowLineView.mas_trailing).offset(15);
            make.centerY.equalTo(self);
            make.width.equalTo(self);
        }];
    }
    return self;
}

- (UIView *)yellowLineView {
    if (!_yellowLineView) {
        _yellowLineView = [[UIView alloc] init];
        _yellowLineView.backgroundColor = UIColor.whiteColor;
    }
    return _yellowLineView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = CharacterDarkColor;
    }
    return _titleLabel;
}

@end

@interface LTSCCateRightCollectionCell()

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UILabel *titleLabel;

@end
@implementation LTSCCateRightCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imgView];
        [self addSubview:self.titleLabel];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.centerX.equalTo(self);
            make.width.height.equalTo(@50);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imgView.mas_bottom).offset(15);
            make.leading.equalTo(self).offset(3);
            make.right.equalTo(self).offset(-3);
            make.height.equalTo(@20);
        }];
    }
    return self;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.image = [UIImage imageNamed:@"tupian"];
        _imgView.layer.cornerRadius = 25;
        _imgView.layer.masksToBounds = YES;
    }
    return _imgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = CharacterDarkColor;
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.numberOfLines = 2;
        _titleLabel.text = @"麻花钻头";
    }
    return _titleLabel;
}

- (void)setModel:(LTSCCateModel *)model {
    _model = model;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:_model.listPic] placeholderImage:[UIImage imageNamed:@"goods_blank"]];
    _titleLabel.text = _model.typeName;
}

- (void)setDianpuModel:(LTSCDianPuCataModel *)dianpuModel {
    _dianpuModel = dianpuModel;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:_dianpuModel.list_pic] placeholderImage:[UIImage imageNamed:@"goods_blank"]];
    _titleLabel.text = _dianpuModel.type_name;
}

@end
