//
//  LTSCDianPuYinXiangVC.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2020/4/9.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "LTSCDianPuYinXiangVC.h"
#import "LTSCLoginVC.h"

@interface LTSCDianPuYinXiangVC ()

@property (nonatomic, strong) LTSCShopModel *shopModel;

@property (nonatomic, strong) LTSCShopMapModel1 *starModel;

@end

@implementation LTSCDianPuYinXiangVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"店铺印象";
    self.tableView.backgroundColor = UIColor.whiteColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0.5);
        make.leading.trailing.bottom.equalTo(self.view);
    }];
    [self loadDetail];
    [self loadDetail1];
}

- (void)loadDetail {
    [LTSCLoadingView show];
    WeakObj(self);
    [LTSCNetworking networkingPOST:shopStar parameters:@{@"shopId":self.shopId} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [LTSCLoadingView dismiss];
        if ([responseObject[@"key"] intValue] == 1000) {
            selfWeak.starModel = [LTSCShopMapModel1 mj_objectWithKeyValues:responseObject[@"result"][@"map"]];
            [selfWeak.tableView reloadData];
        } else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [LTSCLoadingView dismiss];
    }];
}

- (void)loadDetail1 {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (SESSION_TOKEN && ISLOGIN) {
        dict[@"token"] = SESSION_TOKEN;
    }
    dict[@"shopId"] = self.shopId;
    [LTSCLoadingView show];
    WeakObj(self);
    [LTSCNetworking networkingPOST:shopGoodMsg parameters:dict returnClass:LTSCShopRootModel.class success:^(NSURLSessionDataTask *task, LTSCShopRootModel *responseObject) {
        [LTSCLoadingView dismiss];
        if (responseObject.key.intValue == 1000) {
            LTSCShopModel *shopModel = responseObject.result.map;
            selfWeak.shopModel = shopModel;
            [selfWeak.tableView reloadData];
        } else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [LTSCLoadingView dismiss];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 4;
    } else {
        return 5;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        LTSCDianPuYinXiangInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LTSCDianPuYinXiangInfoCell"];
        if (!cell) {
            cell = [[LTSCDianPuYinXiangInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LTSCDianPuYinXiangInfoCell"];
        }
        cell.shopModel = self.shopModel;
        WeakObj(self);
        cell.attendClickBlock = ^(LTSCShopModel *shopModel) {
            [selfWeak attentClick:shopModel];
        };
        return cell;
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            LTSCDianPuYinXiangTitleCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LTSCDianPuYinXiangTitleCell"];
            if (!cell) {
                cell = [[LTSCDianPuYinXiangTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LTSCDianPuYinXiangTitleCell"];
            }
            cell.leftLabel.textColor = CharacterDarkColor;
            cell.leftLabel.text = @"店铺好评率 99.87%";
            return cell;
        }
        LTSCDianPuYinXiangPingJiaCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LTSCDianPuYinXiangPingJiaCell"];
        if (!cell) {
            cell = [[LTSCDianPuYinXiangPingJiaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LTSCDianPuYinXiangPingJiaCell"];
        }
        if (indexPath.row == 1) {
            cell.leftLabel.text = @"描述相符";
            cell.progressView.progress = self.starModel.describeStar.doubleValue/10.0;
            cell.numLabel.text = [NSString stringWithFormat:@"%.1f",self.starModel.describeStar.doubleValue];
            if (self.starModel.describeOtherStar.doubleValue > 0) {
                cell.infoLabel.text = [NSString stringWithFormat:@"高于同行%.2f%@",self.starModel.describeOtherStar.doubleValue*100,@"%"];
            } else {
                cell.infoLabel.text = [NSString stringWithFormat:@"低于同行%.2f%@", fabs(self.starModel.describeOtherStar.doubleValue*100),@"%"];
            }
        } else if (indexPath.row == 2) {
            cell.leftLabel.text = @"服务态度";
            cell.progressView.progress = self.starModel.serverStar.doubleValue/10.0;
            cell.numLabel.text = [NSString stringWithFormat:@"%.1f",self.starModel.serverStar.doubleValue];
            if (self.starModel.serverOtherStar.doubleValue > 0) {
                cell.infoLabel.text = [NSString stringWithFormat:@"高于同行%.2f%@",self.starModel.serverOtherStar.doubleValue*100,@"%"];
            } else {
                cell.infoLabel.text = [NSString stringWithFormat:@"低于同行%.2f%@", fabs(self.starModel.serverOtherStar.doubleValue*100),@"%"];
            }
            
        } else {
            cell.leftLabel.text = @"物流服务";
            cell.progressView.progress = self.starModel.logisticsStar.doubleValue/10.0;
            cell.numLabel.text = [NSString stringWithFormat:@"%.1f",self.starModel.logisticsStar.doubleValue];
            if (self.starModel.logisticsOtherStar.doubleValue > 0) {
                cell.infoLabel.text = [NSString stringWithFormat:@"高于同行%.2f%@",self.starModel.logisticsOtherStar.doubleValue*100,@"%"];
            } else {
                cell.infoLabel.text = [NSString stringWithFormat:@"低于同行%.2f%@", fabs(self.starModel.logisticsOtherStar.doubleValue*100),@"%"];
            }
        }
        return cell;
    } else {
        if (indexPath.row == 0) {
            LTSCDianPuYinXiangTitleCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LTSCDianPuYinXiangTitleCell"];
            if (!cell) {
                cell = [[LTSCDianPuYinXiangTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LTSCDianPuYinXiangTitleCell"];
            }
            cell.leftLabel.textColor = [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1.0];
            cell.leftLabel.text = @"基础信息";
            return cell;
        }
        LTSCDianPuYinXiangBasicInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LTSCDianPuYinXiangBasicInfoCell"];
        if (!cell) {
            cell = [[LTSCDianPuYinXiangBasicInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LTSCDianPuYinXiangBasicInfoCell"];
        }
        if (indexPath.row == 1) {
            cell.leftLabel.text = @"掌柜名";
            cell.rightLabel.text = self.shopModel.user_name;
        } else if (indexPath.row == 2) {
            cell.leftLabel.text = @"服务电话";
            cell.rightLabel.text = self.shopModel.server_telephone;;
        } else if (indexPath.row == 3) {
            cell.leftLabel.text = @"所在地";
            cell.rightLabel.text = [NSString stringWithFormat:@"%@%@",self.shopModel.province, self.shopModel.city];
        } else {
            cell.leftLabel.text = @"开店时间";
            cell.rightLabel.text = self.shopModel.update_time;
        }
        return cell;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
    if (!footerView) {
        footerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"UITableViewHeaderFooterView"];
    }
    footerView.contentView.backgroundColor = BGGrayColor;
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 80;
    } else if (indexPath.section == 1) {
        return 40;
    }
    return 40;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == 2 ? 0.01 : 10;
}


- (void)attentClick:(LTSCShopModel *)model {
    if (!SESSION_TOKEN) {
        LTSCLoginVC *vc = [[LTSCLoginVC alloc] init];
        vc.isDianpu = YES;
        BaseNavigationController * nav  = [[BaseNavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
        return;
    }
    [LTSCLoadingView show];
    WeakObj(self);
    [LTSCNetworking networkingPOST:followShop parameters:@{@"token" : SESSION_TOKEN, @"shopId" : self.shopId } returnClass:LTSCShopGoodsRootModel.class success:^(NSURLSessionDataTask *task, LTSCShopGoodsRootModel *responseObject) {
        [LTSCLoadingView dismiss];
        if (responseObject.key.intValue == 1000) {
            BOOL isf = selfWeak.shopModel.isFollow.boolValue;
            isf = !isf;
            selfWeak.shopModel.isFollow = [NSString stringWithFormat:@"%@", @(isf)];
            NSInteger num = selfWeak.shopModel.followNum.intValue;
            if (num > 0) {
                num = num;
            } else {
                num = 0;
            }
            if (isf) {
                num += 1;
                [LTSCToastView showSuccessWithStatus:@"店铺关注成功"];
            } else {
                num -= 1;
                [LTSCToastView showSuccessWithStatus:@"已取消店铺关注"];
            }
            selfWeak.shopModel.followNum = [NSString stringWithFormat:@"%ld", num];
            [selfWeak.tableView reloadData];
            [LTSCEventBus sendEvent:@"guanzhuAction" data:nil];
        } else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [LTSCLoadingView dismiss];
    }];
}

@end

//店铺信息
@interface LTSCDianPuYinXiangInfoCell ()

@property (nonatomic, strong) UIImageView *imgView;//店铺logo

@property (nonatomic, strong) UILabel *nameLabel;//店铺名称

@property (nonatomic, strong) UILabel *fensiNumLabel;//粉丝数

@property (nonatomic, strong) UIButton *attentendButton;//关注

@end
@implementation LTSCDianPuYinXiangInfoCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubViews];
        [self setConstains];
    }
    return self;
}

- (void)initSubViews {
    [self addSubview:self.imgView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.fensiNumLabel];
    [self addSubview:self.attentendButton];
}

- (void)setConstains {
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.centerY.equalTo(self);
        make.size.equalTo(@40);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.imgView.mas_trailing).offset(10);
        make.bottom.equalTo(self.mas_centerY).offset(-2);
    }];
    [self.fensiNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.imgView.mas_trailing).offset(10);
        make.top.equalTo(self.mas_centerY).offset(2);
        make.height.equalTo(@18);
    }];
    [self.attentendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-15);
        make.centerY.equalTo(self.fensiNumLabel.mas_top);
        make.width.equalTo(@61);
        make.height.equalTo(@22);
    }];
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [UIImageView new];
        _imgView.layer.cornerRadius = 20;
        _imgView.layer.masksToBounds = YES;
    }
    return _imgView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.font = [UIFont boldSystemFontOfSize:15];
        _nameLabel.textColor = CharacterDarkColor;
        
    }
    return _nameLabel;
}

- (UILabel *)fensiNumLabel {
    if (!_fensiNumLabel) {
        _fensiNumLabel = [UILabel new];
        _fensiNumLabel.textColor = [UIColor colorWithRed:159/255.0 green:159/255.0 blue:159/255.0 alpha:1.0];
        _fensiNumLabel.font = [UIFont systemFontOfSize:12];
    }
    return _fensiNumLabel;
}

- (UIButton *)attentendButton {
    if (!_attentendButton) {
        _attentendButton = [UIButton new];
        _attentendButton.layer.cornerRadius = 11;
        _attentendButton.layer.masksToBounds = YES;
        _attentendButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_attentendButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_attentendButton setBackgroundImage:[UIImage imageNamed:@"yellow"] forState:UIControlStateNormal];
        [_attentendButton addTarget:self action:@selector(attectClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _attentendButton;
}

- (void)setShopModel:(LTSCShopModel *)shopModel {
    _shopModel = shopModel;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:_shopModel.shop_pic] placeholderImage:[UIImage imageNamed:@"789789"]];
    _nameLabel.text = _shopModel.shop_name;
    _fensiNumLabel.text = [NSString stringWithFormat:@"粉丝数%d", _shopModel.followNum.intValue];
    [_attentendButton setTitle:_shopModel.isFollow.boolValue ? @"已关注" : @"+ 关注" forState:UIControlStateNormal];
}

- (void)attectClick:(UIButton *)btn {
    if (self.attendClickBlock) {
        self.attendClickBlock(self.shopModel);
    }
}


@end

@implementation LTSCDianPuYinXiangTitleCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.leftLabel];
        [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.centerY.equalTo(self);
        }];
    }
    return self;
}

- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [UILabel new];
        _leftLabel.font = [UIFont systemFontOfSize:15];
    }
    return _leftLabel;
}


@end


@interface LTSCDianPuYinXiangPingJiaCell ()

@end
@implementation LTSCDianPuYinXiangPingJiaCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubViews];
        [self setConstains];
    }
    return self;
}

- (void)initSubViews {
    [self addSubview:self.leftLabel];
    [self addSubview:self.progressView];
    [self addSubview:self.numLabel];
    [self addSubview:self.infoLabel];
}

- (void)setConstains {
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.centerY.equalTo(self);
    }];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.leftLabel.mas_trailing).offset(10);
        make.centerY.equalTo(self);
        make.width.equalTo(@136);
        make.height.equalTo(@11);
    }];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.progressView.mas_trailing).offset(10);
        make.centerY.equalTo(self);
    }];
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-15);
        make.leading.greaterThanOrEqualTo(self.numLabel.mas_trailing).offset(10);
        make.centerY.equalTo(self);
    }];
}

- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [UILabel new];
        _leftLabel.font = [UIFont systemFontOfSize:15];
        _leftLabel.textColor = CharacterDarkColor;
    }
    return _leftLabel;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [UIProgressView new];
        _progressView.trackTintColor = BGGrayColor;
        _progressView.progressTintColor = MineColor;
        _progressView.layer.cornerRadius = 5.5;
        _progressView.layer.masksToBounds = YES;
    }
    return _progressView;
}

- (UILabel *)numLabel {
    if (!_numLabel) {
        _numLabel = [UILabel new];
        _numLabel.font = [UIFont systemFontOfSize:15];
        _numLabel.textColor = MineColor;
        _numLabel.text = @"4.9";
    }
    return _numLabel;
}

- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [UILabel new];
        _infoLabel.font = [UIFont systemFontOfSize:11];
        _infoLabel.textColor = MineColor;
        _infoLabel.text = @"高于同行48.34%";
    }
    return _infoLabel;
}


@end


@implementation LTSCDianPuYinXiangBasicInfoCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.leftLabel];
        [self addSubview:self.rightLabel];
        [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.centerY.equalTo(self);
        }];
        [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self).offset(-15);
            make.centerY.equalTo(self);
        }];
    }
    return self;
}

- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [UILabel new];
        _leftLabel.textColor = CharacterDarkColor;
        _leftLabel.font = [UIFont systemFontOfSize:15];
    }
    return _leftLabel;
}

- (UILabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = [UILabel new];
        _rightLabel.textColor = CharacterDarkColor;
        _rightLabel.font = [UIFont systemFontOfSize:15];
    }
    return _rightLabel;
}




@end
