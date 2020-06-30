//
//  LTSCShopCarCell.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/16.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LTSCShopCarCell.h"

@interface LTSCShopCarCell()<UITextFieldDelegate>

@property (nonatomic, strong) UIButton *selectButton;//选择按钮

@property (nonatomic, strong) UIImageView *selectImgView;//选择图片

@property (nonatomic, strong) UIImageView *imgView;//图片

@property (nonatomic, strong) UILabel *titleLabel;//标题

@property (nonatomic, strong) LTSCShopGuiGeButton *detailButton;//描述button

@property (nonatomic, strong) UILabel *moneyLabel;//价格

@property (nonatomic, strong) UILabel *kcjzLabel;//库存紧张

@property (nonatomic, strong) LTSCShopNumView *numView;//数量

@end

@implementation LTSCShopCarCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubviews];
        [self setConstrains];
    }
    return self;
}

/**
 添加视图
 */
- (void)initSubviews {
    [self addSubview:self.selectButton];
    [self.selectButton addSubview:self.selectImgView];
    [self addSubview:self.imgView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.detailButton];
    [self addSubview:self.moneyLabel];
    [self addSubview:self.kcjzLabel];
    [self addSubview:self.numView];
}

/**
 添加约束
 */
- (void)setConstrains {
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.bottom.equalTo(self);
        make.width.equalTo(@47);
    }];
    [self.selectImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.selectButton).offset(49);
        make.leading.equalTo(self.selectButton).offset(15);
        make.width.height.equalTo(@22);
    }];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(15);
        make.leading.equalTo(self.selectButton.mas_trailing);
        make.width.height.equalTo(@90);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.leading.equalTo(self.imgView.mas_trailing).offset(10);
    }];
    [self.detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.trailing.equalTo(self).offset(-15);
        make.leading.equalTo(self.imgView.mas_trailing).offset(10);
    }];
    [self.kcjzLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailButton.mas_bottom).offset(5);
        make.leading.equalTo(self.imgView.mas_trailing).offset(10);
    }];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.imgView.mas_trailing).offset(10);
        make.centerY.equalTo(self.numView);
    }];
    [self.numView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailButton.mas_bottom).offset(25);
        make.trailing.equalTo(self).offset(-15);
        make.width.equalTo(@110);
        make.height.equalTo(@30);
    }];
}

- (UIButton *)selectButton {
    if (!_selectButton) {
        _selectButton = [[UIButton alloc] init];
        [_selectButton addTarget:self action:@selector(secletBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectButton;
}

- (UIImageView *)selectImgView {
    if (!_selectImgView) {
        _selectImgView = [[UIImageView alloc] init];
        _selectImgView.image = [UIImage imageNamed:@"selcet_n"];
    }
    return _selectImgView;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.image = [UIImage imageNamed:@"tupian"];
    }
    return _imgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = CharacterDarkColor;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.numberOfLines = 0;
        _titleLabel.text = @"环保高粘性透明热熔胶棒家用大小号热熔硅胶条胶水枪胶抢7mm 11mm";
    }
    return _titleLabel;
}

- (LTSCShopGuiGeButton *)detailButton {
    if (!_detailButton) {
        _detailButton = [[LTSCShopGuiGeButton alloc] init];
        _detailButton.backgroundColor = BGGrayColor;
        _detailButton.layer.cornerRadius = 3;
        _detailButton.layer.masksToBounds = YES;
        [_detailButton addTarget:self action:@selector(guigeClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _detailButton;
}

- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.textColor = MineColor;
        _moneyLabel.font = [UIFont systemFontOfSize:18];
        _moneyLabel.text = @"¥0";
    }
    return _moneyLabel;
}

- (UILabel *)kcjzLabel {
    if (!_kcjzLabel) {
        _kcjzLabel = [[UILabel alloc] init];
        _kcjzLabel.textColor = [UIColor colorWithRed:227/255.0 green:84/255.0 blue:84/255.0 alpha:1];
        _kcjzLabel.font = [UIFont systemFontOfSize:15];
        _kcjzLabel.text = @"库存紧张";
        _kcjzLabel.hidden = YES;
    }
    return _kcjzLabel;
}

- (LTSCShopNumView *)numView {
    if (!_numView) {
        _numView = [[LTSCShopNumView alloc] init];
        [_numView.decButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_numView.incButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _numView.numTF.delegate = self;
    }
    return _numView;
}

- (void)guigeClick:(LTSCShopGuiGeButton *)btn {
    btn.selected = !btn.selected;
    if (self.guigeClickBlock) {
        self.guigeClickBlock(self.model);
    }
}

- (void)setModel:(LTSCGoodsDetailSUKModel *)model {
    _model = model;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:_model.list_pic] placeholderImage:[UIImage imageNamed:@"blank"]];
    self.titleLabel.attributedText = _model.titleAtt;
    
    self.numView.numTF.text = _model.num;
    self.selectImgView.image = [UIImage imageNamed:_model.isSelect ? @"selcet_y" : @"selcet_n"];
    self.moneyLabel.text = [NSString stringWithFormat:@"¥%@", _model.good_price.getPriceStr];
    if (model.sku_id) {
        self.detailButton.hidden = NO;
        self.detailButton.textLabel.attributedText = _model.contentAtt;
        [self.detailButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(model.contentHeight));
        }];
    }else {
        self.detailButton.hidden = YES;
        [self.detailButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
    }
    
    if (_model.good_num.intValue - _model.num.intValue < 10) {
        self.kcjzLabel.hidden = NO;
    }else {
        self.kcjzLabel.hidden = YES;
    }
    [self layoutIfNeeded];
}

- (void)btnClick:(UIButton *)btn {
    NSInteger num =  _numView.numTF.text.intValue;
    if (btn == _numView.decButton) {
        if (_numView.numTF.text.intValue > 1) {
            num --;
        }else {
            [LTSCToastView showInFullWithStatus:@"受不了了,不能再少了!"];
        }
    }else {
        num ++;
    }
    _numView.numTF.text = [NSString stringWithFormat:@"%ld", (long)num];
    if (self.model.good_num.intValue >= _numView.numTF.text.intValue) {
        [self modifyCar:_numView.numTF.text];
    }else {
        self.numView.numTF.text = self.model.good_num;
        [UIAlertController showAlertWithmessage:@"库存不足!"];
    }
    if (self.model.good_num.intValue - _numView.numTF.text.intValue < 10) {
        self.kcjzLabel.hidden = NO;
    }else {
        self.kcjzLabel.hidden = YES;
    }
    
}

- (void)modifyCar:(NSString *)numStr {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (self.model.sku_id) {
        dict[@"skuId"] = self.model.sku_id;
    }
    dict[@"token"] = SESSION_TOKEN;
    dict[@"num"] = numStr;
    dict[@"id"] = self.model.id;
    dict[@"goodId"] = self.model.goodId;
    [LTSCNetworking networkingPOST:up_cart parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"key"] integerValue] == 1000) {
            self.model.num  = self.numView.numTF.text;
            if (self.modifyCarSuccess) {
                self.modifyCarSuccess(self.model);
            }
        }else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField endEditing:YES];
    if (textField.text.intValue < 1) {
        [LTSCToastView showInFullWithStatus:@"至少购买一件商品!"];
        _numView.numTF.text = @"1";
        textField.text = @"1";
    }
    if (self.model.good_num.intValue >= textField.text.intValue) {
        [self modifyCar:textField.text];
    }else {
        [self modifyCar:self.model.good_num];
        self.numView.numTF.text = self.model.good_num;
        [UIAlertController showAlertWithmessage:@"库存不足!"];
    }
    if (self.model.good_num.intValue - _numView.numTF.text.intValue < 10) {
        self.kcjzLabel.hidden = NO;
    } else {
        self.kcjzLabel.hidden = YES;
    }
}

- (void)secletBtnClick {
    if (self.selectModelBlock) {
        self.selectModelBlock(self.model,self.numView.numTF.text);
    }
}

@end


@implementation LTSCShopGuiGeButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.textLabel];
        [self addSubview:self.iconImgView];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(5);
            make.leading.equalTo(self).offset(10);
            make.trailing.equalTo(self).offset(-40);
        }];
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.trailing.equalTo(self).offset(-14.5);
            make.width.equalTo(@11);
            make.height.equalTo(@6);
        }];
    }
    return self;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = CharacterGrayColor;
        _textLabel.font = [UIFont systemFontOfSize:13];
        _textLabel.numberOfLines = 2;
//        _textLabel.backgroundColor = [UIColor redColor];
        _textLabel.lineBreakMode =  NSLineBreakByWordWrapping;
      
    }
    return _textLabel;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.image = [UIImage imageNamed:@"arrow_down"];
    }
    return _iconImgView;
}


@end


@implementation LTSCShopNumView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = LineColor.CGColor;
        
        [self addSubview:self.decButton];
        [self addSubview:self.numTF];
        [self addSubview:self.incButton];
        [self.decButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.bottom.equalTo(self);
            make.width.equalTo(@30);
        }];
        [self.numTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.leading.equalTo(self.decButton.mas_trailing);
            make.trailing.equalTo(self.incButton.mas_leading);
        }];
        [self.incButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.trailing.bottom.equalTo(self);
            make.width.equalTo(@30);
        }];
    }
    return self;
}

- (UIButton *)decButton {
    if (!_decButton) {
        _decButton = [[UIButton alloc] init];
        [_decButton setTitle:@"-" forState:UIControlStateNormal];
        [_decButton setTitleColor:LineColor forState:UIControlStateNormal];
        _decButton.titleLabel.font = [UIFont systemFontOfSize:18];
        
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(30 - 0.5, 0, 0.5, 30);
        layer.backgroundColor = LineColor.CGColor;
        [_decButton.layer addSublayer:layer];
    }
    return _decButton;
}

- (UITextField *)numTF {
    if (!_numTF) {
        _numTF = [[UITextField alloc] init];
        _numTF.textColor = CharacterDarkColor;
        _numTF.font = [UIFont systemFontOfSize:15];
        _numTF.textAlignment = NSTextAlignmentCenter;
        _numTF.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _numTF;
}

- (UIButton *)incButton {
    if (!_incButton) {
        _incButton = [[UIButton alloc] init];
        [_incButton setTitle:@"+" forState:UIControlStateNormal];
        [_incButton setTitleColor:LineColor forState:UIControlStateNormal];
        _incButton.titleLabel.font = [UIFont systemFontOfSize:18];
        
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, 0.5, 30);
        layer.backgroundColor = LineColor.CGColor;
        [_incButton.layer addSublayer:layer];
    }
    return _incButton;
}

@end

@interface LTSCShopCarHeaderView ()

@property (nonatomic, strong) UIButton *selectButton;//选择按钮

@property (nonatomic, strong) UIImageView *selectImgView;//选择图片

@property (nonatomic, strong) UIButton *dianpuButton;//跳转店铺

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIImageView *arrowImgView;

@end
@implementation LTSCShopCarHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = YES;
        self.contentView.backgroundColor = UIColor.whiteColor;
        [self initSubviews];
        [self setConstrains];
    }
    return self;
}

/**
 添加视图
 */
- (void)initSubviews {
    [self addSubview:self.selectButton];
    [self.selectButton addSubview:self.selectImgView];
    [self addSubview:self.dianpuButton];
    [self.dianpuButton addSubview:self.imgView];
    [self.dianpuButton addSubview:self.nameLabel];
    [self.dianpuButton addSubview:self.arrowImgView];
}

/**
 添加约束
 */
- (void)setConstrains {
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.bottom.equalTo(self);
        make.width.equalTo(@47);
    }];
    [self.selectImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.selectButton);
        make.leading.equalTo(self.selectButton).offset(15);
        make.width.height.equalTo(@22);
    }];
    [self.dianpuButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.selectButton.mas_trailing);
        make.top.trailing.bottom.equalTo(self);
    }];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.dianpuButton);
        make.centerY.equalTo(self.dianpuButton);
        make.size.equalTo(@15);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.imgView.mas_trailing).offset(5);
        make.centerY.equalTo(self.dianpuButton);
    }];
    [self.arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nameLabel.mas_trailing).offset(5);
        make.centerY.equalTo(self.dianpuButton);
        make.width.equalTo(@3.5);
        make.height.equalTo(@7.5);
    }];
}

- (UIButton *)selectButton {
    if (!_selectButton) {
        _selectButton = [[UIButton alloc] init];
        [_selectButton addTarget:self action:@selector(secletBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectButton;
}

- (UIImageView *)selectImgView {
    if (!_selectImgView) {
        _selectImgView = [[UIImageView alloc] init];
        _selectImgView.image = [UIImage imageNamed:@"selcet_n"];
    }
    return _selectImgView;
}

- (UIButton *)dianpuButton {
    if (!_dianpuButton) {
        _dianpuButton = [UIButton new];
        [_dianpuButton addTarget:self action:@selector(dianpuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dianpuButton;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [UIImageView new];
        _imgView.image = [UIImage imageNamed:@"dianpu_logo"];
    }
    return _imgView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.font = [UIFont boldSystemFontOfSize:15];
    }
    return _nameLabel;
}

- (UIImageView *)arrowImgView {
    if (!_arrowImgView) {
        _arrowImgView = [UIImageView new];
        _arrowImgView.image = [UIImage imageNamed:@"arrow_right"];
    }
    return _arrowImgView;
}

- (void)setModel:(LTSCShopCarDianPuModel *)model {
    _model = model;
    self.nameLabel.text = _model.shop_name;
    self.selectImgView.image = [UIImage imageNamed:_model.isSelect ? @"selcet_y" : @"selcet_n"];
}

- (void)dianpuButtonClick:(UIButton *)btn {
    if (self.didSelectDianpuBlock) {
        self.didSelectDianpuBlock(self.model);
    }
}

- (void)secletBtnClick:(UIButton *)btn {
    if (self.didSelectDianpuAllGoodsBlock) {
        self.didSelectDianpuAllGoodsBlock(self.model);
    }
}

- (void)setIsXiaDan:(BOOL)isXiaDan {
    _isXiaDan = isXiaDan;
    [self.selectButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.bottom.equalTo(self);
        make.width.equalTo(@0);
    }];
    [self.selectImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.selectButton);
        make.leading.equalTo(self.selectButton).offset(15);
        make.width.height.equalTo(@0);
    }];
    [self.dianpuButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.top.trailing.bottom.equalTo(self);
    }];
}

@end


@interface LTSCXiaDanFooterView ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *noteLabel;

@property (nonatomic, strong) UITextField *noteTF;

@property (nonatomic, strong) UILabel *totalLabel;

@property (nonatomic, strong) UIView *topView;

@end
@implementation LTSCXiaDanFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.topView];
        [self.topView addSubview:self.noteLabel];
        [self.topView addSubview:self.noteTF];
        [self.topView addSubview:self.totalLabel];
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(self);
            make.height.equalTo(@100);
        }];
        [self.noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.topView).offset(15);
            make.top.equalTo(self.topView);
            make.height.equalTo(@50);
            make.width.equalTo(@40);
        }];
        [self.noteTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.noteLabel.mas_trailing);
            make.top.equalTo(self.topView);
            make.height.equalTo(@50);
            make.trailing.equalTo(self.topView).offset(-15);
        }];
        [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.noteTF.mas_bottom);
            make.trailing.equalTo(self.topView).offset(-15);
            make.height.equalTo(@50);
        }];
    }
    return self;
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [UIView new];
        _topView.backgroundColor = UIColor.whiteColor;
    }
    return _topView;
}

- (UILabel *)noteLabel {
    if (!_noteLabel) {
        _noteLabel = [UILabel new];
        _noteLabel.textColor = CharacterDarkColor;
        _noteLabel.font = [UIFont systemFontOfSize:15];
        _noteLabel.text = @"备注:";
    }
    return _noteLabel;
}

- (UITextField *)noteTF {
    if (!_noteTF) {
        _noteTF = [UITextField new];
        _noteTF.placeholder = @"选填";
        _noteTF.font = [UIFont systemFontOfSize:15];
        _noteTF.textColor = CharacterDarkColor;
        _noteTF.delegate = self;
    }
    return _noteTF;
}

- (UILabel *)totalLabel {
    if (!_totalLabel) {
        _totalLabel = [UILabel new];
        _totalLabel.font = [UIFont systemFontOfSize:14];
    }
    return _totalLabel;
}

- (void)setModel:(LTSCShopCarDianPuModel *)model {
    _model = model;
    double price = 0;
    NSInteger count = 0;
    for (LTSCGoodsDetailSUKModel *m in _model.goodList) {
        price += m.good_price.floatValue * m.num.intValue;
        count += m.num.intValue;
    }
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"共计%ld件", count] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:173/255.0 green:173/255.0 blue:173/255.0 alpha:1.0]}]];
    NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:@"  小计: " attributes:@{NSForegroundColorAttributeName:CharacterDarkColor}];
    NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%.2f", price] attributes:@{NSForegroundColorAttributeName:MineColor}];
    [att appendAttributedString:str1];
    [att appendAttributedString:str2];
    _totalLabel.attributedText = att;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField endEditing:YES];
    if (!textField.text.isKong) {
        self.model.remark = textField.text;
    }
}

@end
