//
//  LTSCTuiKuanVC.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/21.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LTSCTuiKuanVC.h"

@interface LTSCTuiKuanVC ()

@property (nonatomic, strong) UIButton *bottomButton;//底部创建按钮

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) LTSCTuiKuanReasonRootModel *reasonModel;

@end

@implementation LTSCTuiKuanVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (UIButton *)bottomButton {
    if (!_bottomButton) {
        _bottomButton = [[UIButton alloc] init];
        [_bottomButton setTitle:@"提交" forState:UIControlStateNormal];
        [_bottomButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_bottomButton setBackgroundImage:[UIImage imageNamed:@"yellow"] forState:UIControlStateNormal];
        _bottomButton.layer.cornerRadius = 3;
        _bottomButton.layer.masksToBounds = YES;
        [_bottomButton addTarget:self action:@selector(tijiaoClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomButton;
}

- (void)tijiaoClick {
    [LTSCLoadingView show];
    LTSCTuiKuanReasonModel *model = self.reasonModel.result.list[self.currentIndex - 1];
    [LTSCNetworking networkingPOST:apply_back parameters:@{@"token":SESSION_TOKEN,@"orderId":self.goodsModel.id,@"reason_id": model.id} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [LTSCLoadingView dismiss];
        if ([responseObject[@"key"] integerValue] == 1000) {
            [LTSCToastView showSuccessWithStatus:@"退货申请已提交!"];
            [LTSCEventBus sendEvent:@"tuikuanSuccess" data:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [LTSCLoadingView dismiss];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"申请退款";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.currentIndex = 1;
    [self initView];
    [self loadReasonList];
}

/**
 退款理由
 */
- (void)loadReasonList {
    [LTSCLoadingView show];
    NSMutableDictionary * dict = @{}.mutableCopy;
    dict[@"token"] = SESSION_TOKEN;
    [LTSCNetworking networkingPOST:reason_list parameters:dict returnClass:LTSCTuiKuanReasonRootModel.class success:^(NSURLSessionDataTask *task, LTSCTuiKuanReasonRootModel *responseObject) {
        [self endRefrish];
        self.reasonModel = responseObject;
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self endRefrish];
    }];
}

- (void)initView {
    [self.view addSubview:self.bottomButton];
    if (kDevice_Is_iPhoneX) {
        [self.bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tableView.mas_bottom);
            make.leading.equalTo(self.view).offset(15);
            make.trailing.equalTo(self.view).offset(-15);
            make.bottom.equalTo(self.view).offset(-(15 + TableViewBottomSpace));
            make.height.equalTo(@50);
        }];
    }else {
        [self.bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tableView.mas_bottom);
            make.leading.equalTo(self.view).offset(15);
            make.trailing.equalTo(self.view).offset(-15);
            make.bottom.equalTo(self.view).offset(-15);
            make.height.equalTo(@50);
        }];
    }
    self.tableView.separatorColor = BGGrayColor;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(1);
        make.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.bottomButton.mas_top);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if (section == 2) {
        return self.reasonModel.result.list.count + 1;
    }else {
       return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        LTSCTuiKuanCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LTSCTuiKuanCell"];
        if (!cell) {
            cell = [[LTSCTuiKuanCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LTSCTuiKuanCell"];
        }
        cell.goodsModel = self.goodsModel;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 1) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"退款金额: " attributes:@{NSForegroundColorAttributeName:CharacterDarkColor}];
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%.2f",self.goodsModel.total_money.floatValue] attributes:@{NSForegroundColorAttributeName:MineColor}];
        [att appendAttributedString:str];
        cell.textLabel.attributedText = att;
        return cell;
    }else {
        if (indexPath.row == 0) {
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell1"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell1"];
                UIView * line = [[UIView alloc] init];
                line.backgroundColor = BGGrayColor;
                [cell addSubview:line];
                [line mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.leading.equalTo(cell).offset(15);
                    make.bottom.leading.trailing.equalTo(cell);
                    make.height.equalTo(@0.5);
                }];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = [UIFont systemFontOfSize:16];
            cell.textLabel.textColor = CharacterGrayColor;
            cell.textLabel.text = @"请选择退款原因";
            return cell;
        }else {
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
                UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
                imgView.tag = 111;
                imgView.image = [UIImage imageNamed:indexPath.row == 1 ? @"selcet_y" : @"selcet_n"];
                cell.accessoryView = imgView;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = [UIFont systemFontOfSize:16];
            cell.textLabel.textColor = CharacterGrayColor;
            UIImageView *imgView = [cell viewWithTag:111];
            imgView.image = [UIImage imageNamed:self.currentIndex == indexPath.row ? @"selcet_y" : @"selcet_n"];
            cell.textLabel.text = self.reasonModel.result.list[indexPath.row - 1].reason;
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        if (indexPath.row != 0) {
            self.currentIndex = indexPath.row;
            [self.tableView reloadData];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 120;
    }else if (indexPath.section == 1) {
        return 60;
    }else {
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}


@end


@interface LTSCTuiKuanCell()

@property (nonatomic, strong) UIImageView *imgView;//图片

@property (nonatomic, strong) UILabel *titleLabel;//标题

@property (nonatomic, strong) UILabel *guigeLabel;//规格

@end
@implementation LTSCTuiKuanCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubviews];
        [self setConstrains];
    }
    return self;
}

- (void)initSubviews {
    [self addSubview:self.imgView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.guigeLabel];
}

- (void)setConstrains {
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self).offset(15);
        make.width.height.equalTo(@90);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView);
        make.trailing.equalTo(self).offset(-15);
        make.leading.equalTo(self.imgView.mas_trailing).offset(10);
    }];
    [self.guigeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.leading.equalTo(self.imgView.mas_trailing).offset(10);
        make.trailing.equalTo(self).offset(-15);
    }];
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.image = [UIImage imageNamed:@"tupian"];
        _imgView.layer.cornerRadius = 3;
        _imgView.layer.masksToBounds = YES;
    }
    return _imgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = CharacterDarkColor;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.text = @"环保高粘性透明热熔胶棒家用大小号热熔硅胶条胶水枪胶抢7mm 11mm";
    }
    return _titleLabel;
}

- (UILabel *)guigeLabel {
    if (!_guigeLabel) {
        _guigeLabel = [[UILabel alloc] init];
        _guigeLabel.textColor = CharacterGrayColor;
        _guigeLabel.font = [UIFont systemFontOfSize:13];
        _guigeLabel.numberOfLines = 2;
        _guigeLabel.text = @"大中小T型4件套伸缩两用螺丝刀(赠送加磁器)";
    }
    return _guigeLabel;
}

- (void)setGoodsModel:(LTSCOrderDetailModel *)goodsModel {
    _goodsModel = goodsModel;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:_goodsModel.list_pic] placeholderImage:[UIImage imageNamed:@"blank"]];
    self.titleLabel.text = _goodsModel.good_name;
    self.guigeLabel.attributedText = _goodsModel.yixuanAttStr;
}

@end
