//
//  LTSCAddressCell.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/20.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LTSCAddressCell.h"

@interface LTSCAddressCell()

@property (nonatomic, strong) UILabel *nameLabel;//姓名

@property (nonatomic, strong) UILabel *phoneLabel;//电话

@property (nonatomic, strong) UILabel *morenLabel;//默认

@property (nonatomic, strong) UILabel *addressLabel;//地址



@property (nonatomic, strong) UIImageView *editImgView;//编辑

@property (nonatomic, strong) UIView *lineView;

@end

@implementation LTSCAddressCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubviews];
        [self setConstrains];
    }
    return self;
}

- (void)initSubviews {
    [self addSubview:self.nameLabel];
    [self addSubview:self.phoneLabel];
    [self addSubview:self.morenLabel];
    [self addSubview:self.addressLabel];
    [self addSubview:self.editImgView];
    [self addSubview:self.editBtn];
    [self addSubview:self.lineView];
}

- (void)setConstrains {
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self).offset(15);
        make.width.equalTo(@100);
    }];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nameLabel.mas_trailing).offset(15);
        make.centerY.equalTo(self.nameLabel);
    }];
    
    [self.morenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.centerY.equalTo(self);
        make.height.equalTo(@14);
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(15);
        make.leading.equalTo(self.nameLabel.mas_trailing).offset(15);
        make.trailing.equalTo(self).offset(-50);
    }];
    [self.editImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-15);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@22);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.trailing.bottom.equalTo(self);
        make.height.equalTo(@1);
    }];
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.bottom.equalTo(self);
        make.width.equalTo(@50);
    }];
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = CharacterDarkColor;
        _nameLabel.text = @"啦啦啦啦啦啦";
        _nameLabel.font = [UIFont systemFontOfSize:16];
    }
    return _nameLabel;
}

- (UILabel *)phoneLabel {
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc] init];
        _phoneLabel.textColor = CharacterDarkColor;
        _phoneLabel.text = @"176****8387";
        _phoneLabel.font = [UIFont systemFontOfSize:16];
    }
    return _phoneLabel;
}

- (UILabel *)morenLabel {
    if (!_morenLabel) {
        _morenLabel = [[UILabel alloc] init];
        _morenLabel.backgroundColor = MineColor;
        _morenLabel.textColor = UIColor.whiteColor;
        _morenLabel.text = @"  默认  ";
        _morenLabel.font = [UIFont systemFontOfSize:12];
        _morenLabel.layer.cornerRadius = 7;
        _morenLabel.layer.masksToBounds = YES;
    }
    return _morenLabel;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.textColor = CharacterGrayColor;
        _addressLabel.text = @"江苏省常州市新北区啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦";
        _addressLabel.numberOfLines = 0;
        _addressLabel.font = [UIFont systemFontOfSize:14];
    }
    return _addressLabel;
}

- (UIImageView *)editImgView {
    if (!_editImgView) {
        _editImgView = [[UIImageView alloc] init];
        _editImgView.image = [UIImage imageNamed:@"edit"];
    }
    return _editImgView;
}

-(UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (UIButton *)editBtn {
    if (!_editBtn) {
        _editBtn = [[UIButton alloc] init];
        [_editBtn addTarget:self action:@selector(editClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editBtn;
}

- (void)setIsSureOrder:(BOOL)isSureOrder {
    _isSureOrder = isSureOrder;
    if (_isSureOrder) {
        _editImgView.image = [UIImage imageNamed:@"next"];
    }
}

- (void)setModel:(LTSCAddressListModel *)model {
    _model = model;
    self.nameLabel.text = _model.username;
    self.phoneLabel.text = _model.telephone;
    self.morenLabel.hidden = _model.defaultStatus.intValue == 1;
    self.addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@", _model.province,_model.city,_model.district,_model.addressDetail];
    if ([model.defaultStatus isEqualToString:@"2"]) {
        self.morenLabel.hidden = NO;
    }else {
        self.morenLabel.hidden = YES;
    }
}

- (void)editClick {
    if (self.editBlock) {
        self.editBlock(self.model);
    }
}

@end


@implementation LTSCOrderStateCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = MineColor;
        [self addSubview:self.imgView];
        [self addSubview:self.stateLabel];
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.centerY.equalTo(self);
            make.size.equalTo(@25);
        }];
        [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.imgView.mas_trailing).offset(6);
            make.centerY.equalTo(self);
        }];
    }
    return self;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [UIImageView new];
    }
    return _imgView;
}

- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [UILabel new];
        _stateLabel.textColor = UIColor.whiteColor;
        _stateLabel.font = [UIFont systemFontOfSize:16];
    }
    return _stateLabel;
}

- (void)setModel:(LTSCOrderListDetailModel *)model {
    _model = model;
    //1：待支付，2：已付款，3：已发货，4：已确认收货，5.待退款，6.已取消，7.已评价
    switch (_model.status.intValue) {
        case 1:
        {
            _imgView.image = [UIImage imageNamed:@"order_dfk"];
            _stateLabel.text = @"待付款";
        }
            break;
        case 2:
        {
            _imgView.image = [UIImage imageNamed:@"order_dfh"];
            _stateLabel.text = @"待发货";
        }
            break;
        case 3:
        {
            _imgView.image = [UIImage imageNamed:@"order_dsh"];
            _stateLabel.text = @"待收货";
        }
            break;
        case 4:
        {
            _imgView.image = [UIImage imageNamed:@"order_qrsh"];
            _stateLabel.text = @"已确认收货";
        }
            break;
        case 5:
        {
            _imgView.image = [UIImage imageNamed:@"order_dtk"];
            _stateLabel.text = @"待退款";
        }
            break;
        case 6:
        {
            _imgView.image = [UIImage imageNamed:@"order_yqx"];
            _stateLabel.text = @"已取消";
        }
            break;
        case 7:
        {
            _imgView.image = [UIImage imageNamed:@"order_ypj"];
            _stateLabel.text = @"已评价";
        }
            break;
        default:
            break;
    }
}

@end
