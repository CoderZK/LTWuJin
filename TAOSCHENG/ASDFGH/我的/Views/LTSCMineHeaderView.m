//
//  LTSCMineHeaderView.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/17.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LTSCMineHeaderView.h"

@interface LTSCMineHeaderView()

@property (nonatomic, strong) UIView *hearderView;//圆角背景

@property (nonatomic, strong) UIButton *seeOrderButton;//顶部btn

@property (nonatomic, strong) UILabel *myOrderLabel;//我的订单

@property (nonatomic, strong) UILabel *seeAllLabel;//查看全部

@property (nonatomic, strong) UIImageView *iconImgView;//>

@property (nonatomic, strong) LTSCMineButtonView *buttonView;


@end

@implementation LTSCMineHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setCornerRadius];
        [self initSubviews];
        [self setConstrains];
    }
    return self;
}

/**
 设置圆角
 */
- (void)setCornerRadius {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(6, 6)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    //设置大小
    maskLayer.frame = self.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    self.hearderView.layer.mask = maskLayer;
}

/**
 添加视图
 */
- (void)initSubviews {
    [self addSubview:self.hearderView1];
    [self addSubview:self.hearderView];
    [self.hearderView addSubview:self.seeOrderButton];
    [self.seeOrderButton addSubview:self.myOrderLabel];
    [self.seeOrderButton addSubview:self.seeAllLabel];
    [self.seeOrderButton addSubview:self.iconImgView];
    [self.hearderView addSubview:self.buttonView];
}

/**
 设置约束
 */
- (void)setConstrains {
    [self.hearderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.bottom.equalTo(self);
    }];
    [self.hearderView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.leading.trailing.bottom.equalTo(self);
    }];
    [self.seeOrderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.hearderView);
        make.height.equalTo(@50);
    }];
    [self.myOrderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.seeOrderButton).offset(15);
        make.centerY.equalTo(self.seeOrderButton);
    }];
    [self.seeAllLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.iconImgView.mas_leading).offset(-5);
        make.centerY.equalTo(self.seeOrderButton);
    }];
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.seeOrderButton).offset(-15);
        make.centerY.equalTo(self.seeOrderButton);
        make.width.height.equalTo(@22);
    }];
    [self.buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.seeOrderButton.mas_bottom);
        make.leading.equalTo(self.hearderView).offset(15);
        make.trailing.equalTo(self.hearderView).offset(-15);
        make.bottom.equalTo(self.hearderView);
    }];
}

- (UIView *)hearderView {
    if (!_hearderView) {
        _hearderView = [[UIView alloc] init];
        _hearderView.layer.masksToBounds = YES;
        _hearderView.backgroundColor = [UIColor whiteColor];
    }
    return _hearderView;
}

- (UIView *)hearderView1 {
    if (!_hearderView1) {
        _hearderView1 = [[UIView alloc] init];
        _hearderView1.backgroundColor = MineColor;
    }
    return _hearderView1;
}

- (UIButton *)seeOrderButton {
    if (!_seeOrderButton) {
        _seeOrderButton = [[UIButton alloc] init];
        _seeOrderButton.backgroundColor = [UIColor clearColor];
        [_seeOrderButton addTarget:self action:@selector(seeOrderClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _seeOrderButton;
}

- (UILabel *)myOrderLabel {
    if (!_myOrderLabel) {
        _myOrderLabel = [[UILabel alloc] init];
        _myOrderLabel.text = @"我的订单";
        _myOrderLabel.textColor = CharacterDarkColor;
        _myOrderLabel.font = [UIFont boldSystemFontOfSize:18];
    }
    return _myOrderLabel;
}

- (UILabel *)seeAllLabel {
    if (!_seeAllLabel) {
        _seeAllLabel = [[UILabel alloc] init];
        _seeAllLabel.text = @"查看全部";
        _seeAllLabel.textColor = CharacterGrayColor;
        _seeAllLabel.font = [UIFont systemFontOfSize:14];
    }
    return _seeAllLabel;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.image = [UIImage imageNamed:@"next"];
    }
    return _iconImgView;
}

- (LTSCMineButtonView *)buttonView {
    if (!_buttonView) {
        _buttonView = [[LTSCMineButtonView alloc] init];
        WeakObj(self);
        _buttonView.buttonClickBlock = ^(NSInteger index) {
            if (selfWeak.buttonClickBlock) {
                selfWeak.buttonClickBlock(index);
            }
        };
    }
    return _buttonView;
}

- (void)setModel:(LTSCUserInfoModel *)model {
    _model = model;
    self.buttonView.model = _model;
}

/**
 查看订单
 */
- (void)seeOrderClick {
    if (self.seeAllOrderBlock) {
        self.seeAllOrderBlock();
    }
}


@end

@implementation LTSCMineItemButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.numLabel];
        [self addSubview:self.itemLabel];
        [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_centerY).offset(-2);
            make.centerX.equalTo(self);
        }];
        [self.itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_centerY).offset(8);
            make.centerX.equalTo(self);
        }];
    }
    return self;
}

- (UILabel *)numLabel {
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] init];
        _numLabel.textColor = UIColor.whiteColor;
        _numLabel.font = [UIFont boldSystemFontOfSize:25];
    }
    return _numLabel;
}

- (UILabel *)itemLabel {
    if (!_itemLabel) {
        _itemLabel = [[UILabel alloc] init];
        _itemLabel.textColor = UIColor.whiteColor;
        _itemLabel.font = [UIFont systemFontOfSize:13];
    }
    return _itemLabel;
}

@end


@interface LTSCMineUserView()



@property (nonatomic, strong) UIImageView *userImgView;//用户头像

@property (nonatomic, strong) UILabel *nickLabel;//昵称

@property (nonatomic, strong) UIImageView *accrowImgView;//箭头

@end
@implementation LTSCMineUserView

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
    [self addSubview:self.topButton];
    [self.topButton addSubview:self.userImgView];
    [self.topButton addSubview:self.nickLabel];
    [self addSubview:self.messageBt];
    [self addSubview:self.dianpuButton];
    [self addSubview:self.youhuiquanButton];
}

- (UIButton *)messageBt {
    if (_messageBt == nil) {
        _messageBt = [[UIButton alloc] init];
        [_messageBt setImage:[UIImage imageNamed:@"mmd"] forState:UIControlStateNormal];
    }
    return _messageBt;
}

/**
 添加约束
 */
- (void)setConstrains {
    [self.topButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(NavigationSpace - 20);
        make.leading.equalTo(self);
        make.right.equalTo(self).offset(-60);
        make.height.equalTo(@40);
    }];
    [self.userImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.topButton).offset(15);
        make.centerY.equalTo(self.topButton);
        make.width.height.equalTo(@40);
    }];
    [self.nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.userImgView.mas_trailing).offset(15);
        make.centerY.equalTo(self.userImgView);
    }];
//    [self.accrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.trailing.equalTo(self).offset(-15);
//        make.centerY.equalTo(self.userImgView);
//        make.width.equalTo(@7);
//        make.height.equalTo(@12.5);
//    }];
      [self.messageBt mas_makeConstraints:^(MASConstraintMaker *make) {
          make.height.width.equalTo(@35);
          make.centerY.equalTo(self.topButton);
          make.right.equalTo(self.mas_right).offset(-10);
      }];
      
    [self.dianpuButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topButton.mas_bottom);
        make.leading.bottom.equalTo(self);
        make.trailing.equalTo(self.mas_centerX);
    }];
    [self.youhuiquanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topButton.mas_bottom);
        make.trailing.bottom.equalTo(self);
        make.leading.equalTo(self.mas_centerX);
    }];
}

- (UIButton *)topButton {
    if (!_topButton) {
        _topButton = [[UIButton alloc] init];
//        [_topButton addTarget:self action:@selector(topBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topButton;
}

- (UIImageView *)userImgView {
    if (!_userImgView) {
        _userImgView = [[UIImageView alloc] init];
        _userImgView.image = [UIImage imageNamed:@"scpeople"];
        _userImgView.layer.cornerRadius = 20;
        _userImgView.layer.masksToBounds = YES;
    }
    return _userImgView;
}

- (UILabel *)nickLabel {
    if (!_nickLabel) {
        _nickLabel = [[UILabel alloc] init];
        _nickLabel.text = @"啦啦啦";
        _nickLabel.textColor = UIColor.whiteColor;
        _nickLabel.font = [UIFont boldSystemFontOfSize:18];
    }
    return _nickLabel;
}

- (UIImageView *)accrowImgView {
    if (!_accrowImgView) {
        _accrowImgView = [[UIImageView alloc] init];
        _accrowImgView.image = [UIImage imageNamed:@"next1"];
    }
    return _accrowImgView;
}

- (LTSCMineItemButton *)dianpuButton {
    if (!_dianpuButton) {
        _dianpuButton = [LTSCMineItemButton new];
        _dianpuButton.itemLabel.text = @"店铺关注";
    }
    return _dianpuButton;
}

- (LTSCMineItemButton *)youhuiquanButton {
    if (!_youhuiquanButton) {
        _youhuiquanButton = [LTSCMineItemButton new];
        _youhuiquanButton.itemLabel.text = @"优惠券";
    }
    return _youhuiquanButton;
}

- (void)topBtnClick {
    if (self.topBtnClickBlock) {
        self.topBtnClickBlock();
    }
}

- (void)setInfoMode:(LTSCUserInfoModel *)infoMode {
    _infoMode = infoMode;
    if (_infoMode.userHead && ![_infoMode.userHead isKong]) {
        [_userImgView sd_setImageWithURL:[NSURL URLWithString:_infoMode.userHead] placeholderImage:[UIImage imageNamed:@"scpeople"]];
    } else {
        _userImgView.image = [UIImage imageNamed:@"scpeople"];
    }
    if (_infoMode.username && ![_infoMode.username isKong]) {
        _nickLabel.text = _infoMode.username;
    } else {
        _nickLabel.text = @"立即登录";
    }
    _youhuiquanButton.numLabel.text = [NSString stringWithFormat:@"%d", _infoMode.couponNum.intValue];
    _dianpuButton.numLabel.text = [NSString stringWithFormat:@"%d", _infoMode.followShopNum.intValue];
}

@end




@interface LTSCMineButtonView()

@property (nonatomic, strong) NSMutableArray <LTSCMineButton *>*btnArr;

@end
@implementation LTSCMineButtonView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.btnArr = [NSMutableArray array];
        CGFloat w = floor((ScreenW - 30 - 400)/4.0);
        for (int i = 0; i < 5; i ++) {
            LTSCMineButton *btn = [[LTSCMineButton alloc] initWithFrame:CGRectMake((w + 80)*i, 0, 80, 140)];
            btn.tag = i;
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            if (i == 0) {
                btn.iconImgView.image = [UIImage imageNamed:@"dfk"];
                btn.textLabel.text = @"待付款";
            } else if (i == 1) {
                btn.iconImgView.image = [UIImage imageNamed:@"dfh"];
                btn.textLabel.text = @"待发货";
            } else if (i == 2) {
                btn.iconImgView.image = [UIImage imageNamed:@"dsh"];
                btn.textLabel.text = @"待收货";
            } else if (i == 3) {
               btn.iconImgView.image = [UIImage imageNamed:@"dpj"];
               btn.textLabel.text = @"待评价";
            } else {
                btn.iconImgView.image = [UIImage imageNamed:@"thtk"];
                btn.textLabel.text = @"待退款";
            }
            [self.btnArr addObject:btn];
            [self addSubview:btn];
        }
    }
    return self;
}

- (void)setModel:(LTSCUserInfoModel *)model {
    _model = model;
    if (_model) {
        for (LTSCMineButton *btn in self.btnArr) {
            btn.redNumLabel.hidden = NO;
            if (btn.tag == 0) {
                if (_model.pay_order.intValue == 0) {
                    btn.redNumLabel.hidden = YES;
                }else {
                    btn.redNumLabel.hidden = NO;
                }
                if (_model.pay_order.length == 1) {
                    btn.redNumStr = _model.pay_order;
                }else {
                    btn.redNumStr = [NSString stringWithFormat:@" %@ ", _model.pay_order];
                }
            } else if (btn.tag == 1) {
                if (_model.send_order.intValue == 0) {
                    btn.redNumLabel.hidden = YES;
                }else {
                    btn.redNumLabel.hidden = NO;
                }
                if (_model.send_order.length == 1) {
                    btn.redNumStr = _model.send_order;
                }else {
                    btn.redNumStr = [NSString stringWithFormat:@" %@ ", _model.send_order];
                }
            } else if (btn.tag == 2) {
                if (_model.get_order.intValue == 0) {
                    btn.redNumLabel.hidden = YES;
                }else {
                    btn.redNumLabel.hidden = NO;
                }
                if (_model.get_order.length == 1) {
                    btn.redNumStr = _model.get_order;
                }else {
                    btn.redNumStr = [NSString stringWithFormat:@" %@ ", _model.get_order];
                }
            } else if (btn.tag == 3) {
                if (_model.comment_order.intValue == 0) {
                    btn.redNumLabel.hidden = YES;
                }else {
                    btn.redNumLabel.hidden = NO;
                }
                if (_model.comment_order.length == 1) {
                    btn.redNumStr = _model.comment_order;
                }else {
                    btn.redNumStr = [NSString stringWithFormat:@" %@ ", _model.comment_order];
                }
            } else {
               if (_model.apply_order.intValue == 0) {
                    btn.redNumLabel.hidden = YES;
                }else {
                    btn.redNumLabel.hidden = NO;
                }
                if (_model.apply_order.length == 1) {
                    btn.redNumStr = _model.apply_order;
                }else {
                    btn.redNumStr = [NSString stringWithFormat:@" %@ ", _model.apply_order];
                }
            }
        }
    } else {
        for (LTSCMineButton *btn in self.btnArr) {
            btn.redNumLabel.hidden = YES;
        }
    }
   
}

- (void)btnClick:(UIButton *)btn {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(btn.tag);
    }
}

@end


@implementation LTSCMineButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.iconImgView];
        [self addSubview:self.textLabel];
        [self addSubview:self.redNumLabel];
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_centerY).offset(-10);
            make.centerX.equalTo(self);
            make.width.height.equalTo(@25);
        }];
        [self.redNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconImgView).offset(-4);
            make.trailing.equalTo(self.iconImgView).offset(4);
            make.height.equalTo(@16);
        }];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_centerY).offset(10);
            make.centerX.equalTo(self);
        }];
    }
    return self;
}

- (UILabel *)redNumLabel {
    if (!_redNumLabel) {
        _redNumLabel = [[UILabel alloc] init];
        _redNumLabel.backgroundColor = [UIColor colorWithRed:206/255.0 green:25/255.0 blue:26/255.0 alpha:1];
        _redNumLabel.textColor = UIColor.whiteColor;
        _redNumLabel.font = [UIFont systemFontOfSize:10];
        _redNumLabel.layer.cornerRadius = 8;
        _redNumLabel.layer.masksToBounds = YES;
        _redNumLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _redNumLabel;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
    }
    return _iconImgView;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = CharacterDarkColor;
        _textLabel.font = [UIFont systemFontOfSize:16];
    }
    return _textLabel;
}

- (void)setRedNumStr:(NSString *)redNumStr {
    _redNumStr = redNumStr;
    self.redNumLabel.text = _redNumStr;
    CGFloat w = [_redNumStr getSizeWithMaxSize:CGSizeMake(50, 9999) withFontSize:10].width;
    w = (w > 16 ? w : 16);
    [self.redNumLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(w));
    }];
    [self layoutIfNeeded];
}

@end

@interface LTSCMineCell()

@property (nonatomic, strong) UIImageView *iconImgView;//图标

@property (nonatomic, strong) UILabel *titleLabel;//标题

@property (nonatomic, strong) UIImageView *arrowImgView;//箭头

@property (nonatomic, strong) UIView *lineView;

@end
@implementation LTSCMineCell

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
    [self addSubview:self.iconImgView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.arrowImgView];
    [self addSubview:self.lineView];
}

/**
 设置约束
 */
- (void)setConstrains {
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@17);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.iconImgView.mas_trailing).offset(10);
        make.centerY.equalTo(self);
    }];
    [self.arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-15);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@22);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.bottom.equalTo(self);
        make.height.equalTo(@.5);
    }];
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
    }
    return _iconImgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = CharacterDarkColor;
        _titleLabel.font = [UIFont systemFontOfSize:18];
    }
    return _titleLabel;
}

- (UIImageView *)arrowImgView {
    if (!_arrowImgView) {
        _arrowImgView = [[UIImageView alloc] init];
        _arrowImgView.image = [UIImage imageNamed:@"next"];
    }
    return _arrowImgView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (void)setIndex:(NSInteger)index {
    _index = index;
    self.iconImgView.image = [UIImage imageNamed:_index == 0 ? @"address" : @"setting"];
    self.titleLabel.text = _index == 0 ? @"地址管理" : @"设置";
}

@end
