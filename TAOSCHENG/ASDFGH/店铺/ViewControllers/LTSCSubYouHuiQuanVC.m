//
//  LTSCSubYouHuiQuanVC.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2020/4/9.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "LTSCSubYouHuiQuanVC.h"

@interface LTSCSubYouHuiQuanVC ()

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray <LTSCYouHuiQuanModel *> *dataArr;

@property (nonatomic, assign) NSInteger allPageNum;

@end

@implementation LTSCSubYouHuiQuanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArr = [NSMutableArray array];
    self.allPageNum = 1;
    self.page = 1;
    [self loadData];
    WeakObj(self);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
      selfWeak.page = 1;
      selfWeak.allPageNum = 1;
      [self loadData];
    }];

    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
      [selfWeak loadData];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LTSCSubYouHuiQuanCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LTSCSubYouHuiQuanCell"];
    if (!cell) {
        cell = [[LTSCSubYouHuiQuanCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LTSCSubYouHuiQuanCell"];
    }
    cell.index = self.index;
    cell.model = self.dataArr[indexPath.section];
    cell.userClickBlock = ^(LTSCYouHuiQuanModel *model) {
        [LTSCEventBus sendEvent:@"goHomeClick" data:nil];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 87;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

/**
 请求数据
 */
- (void)loadData {
    if (self.page <= self.allPageNum) {
        if (self.dataArr.count <= 0) {
            [LTSCLoadingView show];
        }
        [LTSCNetworking networkingPOST:couponList parameters:@{@"token":SESSION_TOKEN,@"pageNum" : @(self.page),@"pageSize" : @10, @"status" : self.index.intValue == 0 ? @2 : self.index.intValue == 1 ? @3 : @1} returnClass:LTSCYouHuiQuanRootModel.class success:^(NSURLSessionDataTask *task, LTSCYouHuiQuanRootModel *responseObject) {
            [self endRefrish];
            if (responseObject.key.intValue == 1000) {
                self.allPageNum = responseObject.result.allPageNumber.intValue;
                [LTSCEventBus sendEvent:@"youhuiquanNum" data:responseObject.result.map];
                if (self.page == 1) {
                    [self.dataArr removeAllObjects];
                }
                if (self.page <= responseObject.result.allPageNumber.intValue) {
                    [self.dataArr addObjectsFromArray:responseObject.result.list];
                }
                self.page ++;
                [self.tableView reloadData];
            } else {
                [UIAlertController showAlertWithmessage:responseObject.message];
            }
            if (self.dataArr.count <= 0) {
                [self.noneView showNoneDataViewAt:self.view img:[UIImage imageNamed:@"emptyorder"] tips:[NSString stringWithFormat:@"暂无%@优惠券", self.index.intValue == 0 ? @"未使用" : self.index.intValue == 1 ? @"已使用" : @"已过期"]];
            } else {
                [self.noneView dismiss];
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [self endRefrish];
        }];
    }
}



@end


@interface LTSCSubYouHuiQuanCell ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *leftView;

@property (nonatomic, strong) UILabel *moneyLabel;

@property (nonatomic, strong) UIView *rightView;

@property (nonatomic, strong) UILabel *textLabel1;

@property (nonatomic, strong) UILabel *dateLabel;//日期

@property (nonatomic, strong) UIButton *userButton;//去使用

@property (nonatomic, strong) UIImageView *stateImgView;

@property (nonatomic, strong) UIImageView *selectImgView;//选择图片

@end
@implementation LTSCSubYouHuiQuanCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubViews];
        [self setConstrains];
    }
    return self;
}

- (void)initSubViews {
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.leftView];
    [self.leftView addSubview:self.moneyLabel];
    [self.bgView addSubview:self.rightView];
    [self.rightView addSubview:self.textLabel1];
    [self.rightView addSubview:self.dateLabel];
    [self.rightView addSubview:self.userButton];
    [self.rightView addSubview:self.stateImgView];
    [self.rightView addSubview:self.selectImgView];
}

- (void)setConstrains {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.top.bottom.equalTo(self);
    }];
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.bottom.equalTo(self.bgView);
        make.width.equalTo(@100);
    }];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           make.center.equalTo(self.leftView);
       }];
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.leftView.mas_trailing);
        make.trailing.top.bottom.equalTo(self.bgView);
    }];
    [self.textLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rightView).offset(24);
        make.leading.equalTo(self.rightView).offset(18);
    }];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textLabel1.mas_bottom).offset(15);
        make.leading.equalTo(self.rightView).offset(18);
    }];
    [self.userButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.dateLabel);
        make.trailing.equalTo(self.rightView).offset(-15);
        make.width.equalTo(@50);
        make.height.equalTo(@20);
    }];
    [self.stateImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rightView).offset(5);
        make.trailing.equalTo(self.rightView).offset(-5);
        make.width.equalTo(@53);
        make.height.equalTo(@47);
    }];
    [self.selectImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.rightView).offset(-15);
        make.centerY.equalTo(self.dateLabel);
        make.width.height.equalTo(@22);
    }];
    
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.layer.cornerRadius = 3;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (UIView *)leftView {
    if (!_leftView) {
        _leftView = [UIView new];
        _leftView.backgroundColor = MineColor;
    }
    return _leftView;
}

- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [UILabel new];
        _moneyLabel.textColor = UIColor.whiteColor;
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithAttributedString:[[NSAttributedString alloc] initWithString:@"¥" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}]];
        NSAttributedString *str  = [[NSAttributedString alloc] initWithString:@"5" attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:43]}];
        [att appendAttributedString:str];
        _moneyLabel.attributedText = att;
    }
    return _moneyLabel;
}

- (UIView *)rightView {
    if (!_rightView) {
        _rightView = [UIView new];
        _rightView.backgroundColor = UIColor.whiteColor;
    }
    return _rightView;
}

- (UILabel *)textLabel1 {
    if (!_textLabel1) {
        _textLabel1 = [UILabel new];
        _textLabel1.font = [UIFont boldSystemFontOfSize:13];
        _textLabel1.textColor = CharacterDarkColor;
        _textLabel1.text = @"满99可使用";
    }
    return _textLabel1;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [UILabel new];
        _dateLabel.font = [UIFont systemFontOfSize:11];
        _dateLabel.textColor = [UIColor colorWithRed:155/255.0 green:155/255.0 blue:155/255.0 alpha:1.0];
        _dateLabel.text = @"2020.03.04-2020.03.22";
    }
    return _dateLabel;
}

- (UIImageView *)selectImgView {
    if (!_selectImgView) {
        _selectImgView = [[UIImageView alloc] init];
        _selectImgView.image = [UIImage imageNamed:@"selcet_n"];
    }
    return _selectImgView;
}

- (UIButton *)userButton {
    if (!_userButton) {
        _userButton = [UIButton new];
        [_userButton setTitle:@"去使用" forState:UIControlStateNormal];
        [_userButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_userButton setBackgroundImage:[UIImage imageNamed:@"yellow"] forState:UIControlStateNormal];
        _userButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _userButton.layer.cornerRadius = 3;
        _userButton.layer.masksToBounds = YES;
        [_userButton addTarget:self action:@selector(useButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _userButton;
}

- (UIImageView *)stateImgView {
    if (!_stateImgView) {
        _stateImgView = [UIImageView new];
        _stateImgView.image = [UIImage imageNamed:@"yishiyong"];
    }
    return _stateImgView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.leftView.bounds byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.path = maskPath.CGPath;
    self.leftView.layer.mask = maskLayer;

    UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:self.rightView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc]init];
    maskLayer1.path = maskPath1.CGPath;
    self.rightView.layer.mask = maskLayer1;
}

- (void)setIndex:(NSString *)index {
    _index = index;
    if (_index.intValue == 0) {
        self.selectImgView.hidden = YES;
        self.userButton.hidden = NO;
        self.stateImgView.hidden = YES;
        self.leftView.backgroundColor = MineColor;
        self.textLabel1.textColor = CharacterDarkColor;
        self.dateLabel.textColor = [UIColor colorWithRed:155/255.0 green:155/255.0 blue:155/255.0 alpha:1.0];
    } else if (_index.intValue == 1) {
        self.selectImgView.hidden = YES;
        self.userButton.hidden = YES;
        self.stateImgView.hidden = NO;
        self.stateImgView.image = [UIImage imageNamed:@"yishiyong"];
        self.leftView.backgroundColor = MineColor;
        self.textLabel1.textColor = CharacterDarkColor;
        self.dateLabel.textColor = [UIColor colorWithRed:155/255.0 green:155/255.0 blue:155/255.0 alpha:1.0];
    } else if (_index.intValue == 333) {
        self.selectImgView.hidden = NO;
        self.userButton.hidden = YES;
        self.stateImgView.hidden = YES;
        self.leftView.backgroundColor = MineColor;
        self.textLabel1.textColor = CharacterDarkColor;
        self.dateLabel.textColor = [UIColor colorWithRed:155/255.0 green:155/255.0 blue:155/255.0 alpha:1.0];
    }  else if (_index.intValue == 334) {
         self.selectImgView.hidden = NO;
         self.userButton.hidden = YES;
         self.stateImgView.hidden = YES;
         self.leftView.backgroundColor = [UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:1.0];
         self.textLabel1.textColor = [UIColor colorWithRed:205/255.0 green:205/255.0 blue:205/255.0 alpha:1.0];
         self.dateLabel.textColor = [UIColor colorWithRed:205/255.0 green:205/255.0 blue:205/255.0 alpha:1.0];
    } else {
        self.selectImgView.hidden = YES;
        self.userButton.hidden = YES;
        self.stateImgView.hidden = NO;
        self.stateImgView.image = [UIImage imageNamed:@"yiguoqi"];
        self.leftView.backgroundColor = [UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:1.0];
        self.textLabel1.textColor = [UIColor colorWithRed:205/255.0 green:205/255.0 blue:205/255.0 alpha:1.0];
        self.dateLabel.textColor = [UIColor colorWithRed:205/255.0 green:205/255.0 blue:205/255.0 alpha:1.0];
    }
}

- (void)setModel:(LTSCYouHuiQuanModel *)model {
    _model = model;
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithAttributedString:[[NSAttributedString alloc] initWithString:@"¥" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}]];
    NSAttributedString *str  = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",_model.type.intValue == 1 ? _model.reduce_money.getPriceStr : _model.reduce_money.getPriceStr] attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:25]}];
    [att appendAttributedString:str];
    _moneyLabel.attributedText = att;
    
    if (_model.type.intValue == 1) {//type 1.满减，2.抵扣
        _textLabel1.text = [NSString stringWithFormat:@"满%ld可用",(long)_model.full_money.integerValue];
    } else {
        _textLabel1.text = @"无金额门槛";
    }
    _dateLabel.text = [NSString stringWithFormat:@"%@-%@",[NSString formatterYouHuiQuanTime:_model.create_time], [NSString formatterYouHuiQuanTime:_model.last_time]];
}


- (void)setCellModel:(LTSCYouHuiQuanModel *)cellModel {
    _cellModel = cellModel;
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithAttributedString:[[NSAttributedString alloc] initWithString:@"¥" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}]];
    NSAttributedString *str  = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",_cellModel.type.intValue == 1 ? _cellModel.full_money.getPriceStr : _cellModel.reduce_money.getPriceStr] attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:25]}];
    [att appendAttributedString:str];
    _moneyLabel.attributedText = att;
    
    if (_model.type.intValue == 1) {//type 1.满减，2.抵扣
        _textLabel1.text = [NSString stringWithFormat:@"满%ld可用",(long)_cellModel.full_money.integerValue];
    } else {
        _textLabel1.text = @"无金额门槛";
    }
    _dateLabel.text = [NSString stringWithFormat:@"%@-%@",[NSString formatterYouHuiQuanTime1:_cellModel.create_time], [NSString formatterYouHuiQuanTime1:_cellModel.last_time]];
}


- (void)setUserModel:(LTSCYouHuiQuanModel *)userModel {
    _userModel = userModel;
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithAttributedString:[[NSAttributedString alloc] initWithString:@"¥" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}]];
    NSAttributedString *str  = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",_userModel.type.intValue == 1 ? _userModel.reduce_money.getPriceStr : _userModel.reduce_money.getPriceStr] attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:25]}];
    [att appendAttributedString:str];
    _moneyLabel.attributedText = att;
    
    if (_userModel.type.intValue == 1) {//type 1.满减，2.抵扣
        _textLabel1.text = [NSString stringWithFormat:@"满%ld可用",(long)_userModel.full_money.integerValue];
    } else {
        _textLabel1.text = @"无金额门槛";
    }
    _dateLabel.text = [NSString stringWithFormat:@"%@-%@",_userModel.create_time, _userModel.last_time];
    _selectImgView.image = [UIImage imageNamed:_userModel.isSelect ? @"selcet_y" : @"selcet_n"];
}

- (void)useButtonClick:(UIButton *)btn {
    if (self.userClickBlock) {
        self.userClickBlock(self.model);
    }
}

@end
