//
//  LTSCMyOrderHeaderFooterView.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/21.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LTSCMyOrderHeaderFooterView.h"

@implementation LTSCMyOrderHeaderFooterView

@end

@interface LTSCMyOrderHeaderView()

@property (nonatomic, strong) UIButton *bgButton;

@property (nonatomic, strong) LTSCAlertView *youxiaoqiDataView;//倒计时

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIImageView *arrowImgView;



@property (nonatomic, strong) UIView *lineView;//线

//倒计时
@property (nonatomic , strong)NSTimer * timer;

@property (nonatomic , assign)int time;

@end
@implementation LTSCMyOrderHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = UIColor.whiteColor;
        [self addSubview:self.bgButton];
        [self addSubview:self.youxiaoqiDataView];
        [self.bgButton addSubview:self.imgView];
        [self.bgButton addSubview:self.nameLabel];
        [self.bgButton addSubview:self.arrowImgView];
        [self.bgButton addSubview:self.stateLabel];
        [self.bgButton addSubview:self.lineView];
        [self.bgButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(self);
            make.height.equalTo(@40);
        }];
        [self.youxiaoqiDataView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bgButton.mas_bottom);
            make.leading.trailing.bottom.equalTo(self);
        }];
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.bgButton).offset(15);
            make.centerY.equalTo(self.bgButton);
            make.size.equalTo(@15);
        }];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.imgView.mas_trailing).offset(5);
            make.centerY.equalTo(self.bgButton);
        }];
        [self.arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.nameLabel.mas_trailing).offset(5);
            make.centerY.equalTo(self.bgButton);
            make.width.equalTo(@3.5);
            make.height.equalTo(@7.5);
        }];
        [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.bgButton).offset(-15);
            make.centerY.equalTo(self.bgButton);
        }];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.bgButton).offset(15);
            make.bottom.trailing.equalTo(self.bgButton);
            make.height.equalTo(@0.5);
        }];
    }
    return self;
}

- (UIButton *)bgButton {
    if (!_bgButton) {
        _bgButton = [[UIButton alloc] init];
        [_bgButton addTarget:self action:@selector(bgButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bgButton;
}

- (LTSCAlertView *)youxiaoqiDataView {
    if (!_youxiaoqiDataView) {
        _youxiaoqiDataView = [[LTSCAlertView alloc] init];
    }
    return _youxiaoqiDataView;
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

- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.textColor = [UIColor colorWithRed:203/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        _stateLabel.font = [UIFont systemFontOfSize:15];
        _stateLabel.text = @"已取消";
    }
    return _stateLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (void)bgButtonClick {
    if (self.bgButtonClickBlock) {
        self.bgButtonClickBlock();
    }
}

- (void)setObjModel:(LTSCOrderObjectModel *)objModel {
    _objModel = objModel;
    if (_objModel.status.intValue == 1) {
        double chaTime = [NSString chaWithCreateTime:_objModel.create_time];
        if (chaTime < 0) {
            _objModel.status = @"7";
        }
    }
    self.nameLabel.text = _objModel.shop_name;
    self.youxiaoqiDataView.hidden = _objModel.status.intValue != 1;
    switch (_objModel.status.intValue) {
        case 1:
            self.stateLabel.text = @"待付款";
            break;
        case 2:
            self.stateLabel.text = @"待发货";
            break;
        case 3:
            self.stateLabel.text = @"待收货";
            break;
        case 4:
            self.stateLabel.text = @"已完成";
            break;
        case 5:
            self.stateLabel.text = @"待退款";
            break;
        case 6:
            self.stateLabel.text = @"已取消";
            break;
        case 7:
            self.stateLabel.text = @"已评价";
            break;
        default:
            break;
    }
    
    if (_objModel.status.intValue == 1) {
        double chaTime = [NSString chaWithCreateTime:_objModel.create_time];
        [self.timer invalidate];
        self.timer = nil;
        self.time = chaTime;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer1) userInfo:nil repeats:YES];
        [NSRunLoop.currentRunLoop addTimer:self.timer forMode:NSRunLoopCommonModes];
        [self.timer fire];
    } else {
        [self.timer invalidate];
        self.timer = nil;
    }
}

//订单详情
- (void)setDetailModel:(LTSCOrderListDetailModel *)detailModel {
    _detailModel = detailModel;
    if (_detailModel.status.intValue == 1) {
        double chaTime = [NSString chaWithCreateTime:_detailModel.createTime];
        if (chaTime < 0) {
            _detailModel.status = @"6";
        }
    }
    self.nameLabel.text = _detailModel.shop_name;
    self.youxiaoqiDataView.hidden = _detailModel.status.intValue != 1;
    switch (_detailModel.status.intValue) {
        case 1:
            self.stateLabel.text = @"待付款";
            break;
        case 2:
            self.stateLabel.text = @"待发货";
            break;
        case 3:
            self.stateLabel.text = @"待收货";
            break;
        case 4:
            self.stateLabel.text = @"已完成";
            break;
        case 5:
            self.stateLabel.text = @"待退款";
            break;
        case 6:
            self.stateLabel.text = @"已取消";
            break;
        case 7:
            self.stateLabel.text = @"已评价";
            break;
        default:
            break;
    }
    
    if (_detailModel.status.intValue == 1) {
        double chaTime = [NSString chaWithCreateTime:_detailModel.createTime];
        [self.timer invalidate];
        self.timer = nil;
        self.time = chaTime;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer1) userInfo:nil repeats:YES];
        [NSRunLoop.currentRunLoop addTimer:_timer forMode:NSRunLoopCommonModes];
        [self.timer fire];
    } else {
        [self.timer invalidate];
        self.timer = nil;
    }
}

-(void)onTimer1 {
    NSString *timeStr = [NSString durationTimeStringWithDuration:_time--];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"请在" attributes:@{NSForegroundColorAttributeName:CharacterGrayColor}];
    NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:timeStr attributes:@{NSForegroundColorAttributeName:MineColor}];
    NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:@"内完成付款,否则订单会被系统取消" attributes:@{NSForegroundColorAttributeName:CharacterGrayColor}];
    [att appendAttributedString:str1];
    [att appendAttributedString:str2];
    self.youxiaoqiDataView.timeLabel.attributedText = att;
    if (_time < 0) {
        [self.timer invalidate];
        self.timer = nil;
        //订单变为已取消
        self.detailModel.status = @"6";
        [LTSCEventBus sendEvent:@"cancelSuccess" data:nil];
    }
}


@end

@interface LTSCMyOrderFooterView()

@property (nonatomic, strong) UIButton *bgButton;

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UILabel *totallabel;

@property (nonatomic, strong) UIView *lineView;//线

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UIButton *leftButton;

@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIButton *leftOneButton;


@property (nonatomic, strong) UIView *lineView1;//线

@end
@implementation LTSCMyOrderFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.topView];
        [self.topView addSubview:self.totallabel];
        [self.topView addSubview:self.lineView];
        [self addSubview:self.bottomView];
        [self addSubview:self.bgButton];
        [self.bgButton addSubview:self.leftButton];
        [self.bgButton addSubview:self.rightButton];
        [self.bgButton addSubview:self.leftOneButton];
        [self addSubview:self.lineView1];

        [self.bgButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.bottom.equalTo(self);
        }];
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(self.bgButton);
            make.height.equalTo(@30);
        }];
        [self.totallabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.topView).offset(-15);
            make.centerY.equalTo(self.topView);
        }];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.topView).offset(15);
            make.bottom.trailing.equalTo(self.topView);
            make.height.equalTo(@0.5);
        }];
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topView.mas_bottom);
            make.leading.trailing.equalTo(self.bgButton);
            make.height.equalTo(@60);
        }];
        [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.bottomView).offset(-15);
//            make.top.equalTo(self).offset(15);
            make.width.equalTo(@80);
            make.height.equalTo(@30);
            make.centerY.equalTo(self.bgButton.mas_centerY);
        }];
        [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.bgButton).offset(-115);
//            make.top.equalTo(self).offset(15);
            make.width.equalTo(@80);
            make.height.equalTo(@30);
            make.centerY.equalTo(self.bgButton.mas_centerY);
            
        }];
        [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bottomView.mas_bottom);
            make.left.trailing.equalTo(self.bgButton);
            make.height.equalTo(@10);
        }];
        
        [self.leftOneButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.leftButton.mas_leading).offset(-20);
//            make.top.equalTo(self).offset(15);
            make.height.equalTo(@30);
            make.width.equalTo(@80);
            make.centerY.equalTo(self.bgButton.mas_centerY);
        }];

        
    }
    return self;
}

- (UIButton *)bgButton {
    if (!_bgButton) {
        _bgButton = [[UIButton alloc] init];
        [_bgButton addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bgButton;
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [UIColor whiteColor];
    }
    return _topView;
}

- (UILabel *)totallabel {
    if (!_totallabel) {
        _totallabel = [[UILabel alloc] init];
        _totallabel.textColor = CharacterDarkColor;
        _totallabel.font = [UIFont systemFontOfSize:13];
        _totallabel.text = @"共2件商品 合计:¥118.00";
    }
    return _totallabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (UIView *)lineView1 {
    if (!_lineView1) {
        _lineView1 = [[UIView alloc] init];
        _lineView1.backgroundColor = BGGrayColor;
    }
    return _lineView1;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}

- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [[UIButton alloc] init];
        [_leftButton setTitle:@"  删除订单  " forState:UIControlStateNormal];
        [_leftButton setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
        [_leftButton setBackgroundImage:[UIImage imageNamed:@"white"] forState:UIControlStateNormal];
        _leftButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _leftButton.layer.borderWidth = 0.5;
        _leftButton.layer.cornerRadius = 3;
        _leftButton.layer.borderColor = CharacterDarkColor.CGColor;
        _leftButton.layer.masksToBounds = YES;
        [_leftButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _leftButton.tag = 110;
    }
    return _leftButton;
}

- (UIButton *)leftOneButton {
    if (!_leftOneButton) {
        _leftOneButton = [[UIButton alloc] init];
        [_leftOneButton setTitle:@"  删除订单  " forState:UIControlStateNormal];
        [_leftOneButton setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
        [_leftOneButton setBackgroundImage:[UIImage imageNamed:@"white"] forState:UIControlStateNormal];
        _leftOneButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _leftOneButton.layer.borderWidth = 0.5;
        _leftOneButton.layer.cornerRadius = 3;
        _leftOneButton.layer.borderColor = CharacterDarkColor.CGColor;
        _leftOneButton.layer.masksToBounds = YES;
        [_leftOneButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _leftOneButton.tag = 109;
    }
    return _leftOneButton;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [[UIButton alloc] init];
        [_rightButton setTitle:@"去付款" forState:UIControlStateNormal];
        [_rightButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_rightButton setBackgroundImage:[UIImage imageNamed:@"yellow"] forState:UIControlStateNormal];
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _rightButton.layer.cornerRadius = 3;
        _rightButton.layer.masksToBounds = YES;
        [_rightButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _rightButton.tag = 111;
    }
    return _rightButton;
}

- (void)btnClick {
    if (self.bgButtonClickBlock) {
        self.bgButtonClickBlock();
    }
}

- (void)btnClick: (UIButton *)btn {
    if (self.footerButtonClickBlock) {
        self.footerButtonClickBlock(self.objModel, btn.tag);
    }
}

- (void)setObjModel:(LTSCOrderObjectModel *)objModel {
    _objModel = objModel;
    _totallabel.text = [NSString stringWithFormat:@"共%ld件商品 合计:¥%.2f", _objModel.goods.count, _objModel.total_money.floatValue];
    
    if ( _objModel.status.intValue == 5 || _objModel.status.intValue == 2) {
        self.lineView.hidden = YES;
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@10);
        }];
    } else {
        self.lineView.hidden = NO;
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@60);
        }];
    }
//    [self layoutIfNeeded];
    _leftOneButton.hidden = YES;
   [self.leftButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomView).offset(-115);
    }];
    switch (_objModel.status.intValue) {
        case 1: {//待付款
            _leftButton.hidden = _rightButton.hidden = NO;
            [_leftButton setTitle:@"取消订单" forState:UIControlStateNormal];
            [_rightButton setTitle:@"去付款" forState:UIControlStateNormal];
        }
            break;
        case 2: {//待发货
           
            _leftButton.hidden = YES;
            _rightButton.hidden = YES;
//            [_rightButton setTitle:@"  确认收货  " forState:UIControlStateNormal];
        }
            break;
        case 3: {//待收货
           
            _leftButton.hidden = YES;
            _rightButton.hidden = NO;
            [_rightButton setTitle:@"确认收货" forState:UIControlStateNormal];
        }
            break;
        case 4: {//已完成
            
            _leftButton.hidden = NO;
            _rightButton.hidden = NO;
            _leftOneButton.hidden = NO;
            [_leftButton setTitle:@"再次购买" forState:UIControlStateNormal];
            [_leftOneButton setTitle:@"删除订单" forState:UIControlStateNormal];
            [_rightButton setTitle:@"去评价" forState:UIControlStateNormal];
           
        }
            break;
        case 5: {//待退款
            _leftButton.hidden = YES;
            _rightButton.hidden = YES;

        }
            break;
        case 6: {//已取消
            
            _leftButton.hidden = NO;
            _rightButton.hidden = YES;
            [self.leftButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.bottomView).offset(-15);
            }];
            [_leftButton setTitle:@"删除订单" forState:UIControlStateNormal];
           
            
        }
            break;
            
        case 7: {//已取消
            _leftOneButton.hidden = NO;
            _leftButton.hidden = NO;
            _rightButton.hidden = YES;
            [self.leftButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.bottomView).offset(-15);
            }];
            [_leftButton setTitle:@"再次购买" forState:UIControlStateNormal];
            [_leftOneButton setTitle:@"删除订单" forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}
@end


@interface LTSCAlertView()

@property (nonatomic, strong) UIImageView *alertImgView;//闹钟图片

@end
@implementation LTSCAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
        [self addSubview:self.alertImgView];
        [self addSubview:self.timeLabel];
        [self.alertImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.centerY.equalTo(self);
            make.width.height.equalTo(@15);
        }];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.alertImgView.mas_trailing).offset(5);
            make.centerY.equalTo(self);
            make.trailing.equalTo(self).offset(-15);
        }];
    }
    return self;
}

- (UIImageView *)alertImgView {
    if (!_alertImgView) {
        _alertImgView = [[UIImageView alloc] init];
        _alertImgView.image = [UIImage imageNamed:@"alert"];
    }
    return _alertImgView;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.text = @"请在30分钟内完成付款,否则订单会被系统取消";
    }
    return _timeLabel;
}

@end
