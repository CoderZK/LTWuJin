//
//  LTSCWuLiuInfoVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/26.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LTSCWuLiuInfoVC.h"


@interface LTSCWuLiuInfoOrderCell : UITableViewCell

@property (nonatomic, strong) UILabel *orderLabel;//订单号

@property (nonatomic, strong) UILabel *companyLabel;//快递公司

@property (nonatomic, strong) UILabel *yjsdrqLabel;//预计送达
@property (nonatomic, strong) LTSCWuLiuInfoMapModel *mapData;


@end
@implementation LTSCWuLiuInfoOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubViews];
        [self setConstrains];
        [self setData];
    }
    return self;
}

/**
 添加视图
 */
- (void)initSubViews {
    [self addSubview:self.orderLabel];
    [self addSubview:self.companyLabel];
    [self addSubview:self.yjsdrqLabel];
}

/**
 添加约束
 */
- (void)setConstrains {
    [self.orderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self).offset(15);
    }];
    [self.companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderLabel.mas_bottom).offset(10);
        make.leading.equalTo(self).offset(15);
    }];
    [self.yjsdrqLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.companyLabel.mas_bottom).offset(10);
        make.leading.equalTo(self).offset(15);
    }];
}

- (UILabel *)orderLabel {
    if (!_orderLabel) {
        _orderLabel = [UILabel new];
        _orderLabel.font = [UIFont systemFontOfSize:13];
        _orderLabel.textColor = CharacterDarkColor;
    }
    return _orderLabel;
}

- (UILabel *)companyLabel {
    if (!_companyLabel) {
        _companyLabel = [UILabel new];
        _companyLabel.font = [UIFont systemFontOfSize:13];
        _companyLabel.textColor = CharacterDarkColor;
    }
    return _companyLabel;
}

- (UILabel *)yjsdrqLabel {
    if (!_yjsdrqLabel) {
        _yjsdrqLabel = [UILabel new];
        _yjsdrqLabel.font = [UIFont systemFontOfSize:13];
        _yjsdrqLabel.textColor = CharacterDarkColor;
        _yjsdrqLabel.hidden = YES;
    }
    return _yjsdrqLabel;
}

- (void)setData {
    self.orderLabel.text = @"订单号: 80124838390546323";
    self.companyLabel.text = @"快递公司: 申通快递";
    self.yjsdrqLabel.text = @"预计送达: 12月15日";
}

- (void)setMapData:(LTSCWuLiuInfoMapModel *)mapData {
    _mapData = mapData;
    self.orderLabel.text = [NSString stringWithFormat:@"订单号: %@",_mapData.orderCode];
    if (_mapData.company.isValid) {
        self.companyLabel.hidden = NO;
        self.companyLabel.text = [NSString stringWithFormat:@"快递公司: %@",_mapData.company];
    } else {
        self.companyLabel.hidden = YES;
    }
}

@end


@interface LTSCWuLiuInfoOrderHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) UIView *dianView;//点

@property (nonatomic, strong) UIView *topLineView;//顶线

@property (nonatomic, strong) UIView *lineView;//左侧线

@property (nonatomic, strong) UILabel *stateLabel;//状态

@end
@implementation LTSCWuLiuInfoOrderHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self initSubViews];
        [self setConstrains];
    }
    return self;
}

/**
 添加视图
 */
- (void)initSubViews {
    [self addSubview:self.topLineView];
    [self addSubview:self.dianView];
    [self addSubview:self.lineView];
    [self addSubview:self.stateLabel];
}

/**
 设置约束
 */
- (void)setConstrains {
   
    [self.dianView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(18);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@5);
    }];
    
     [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
//            make.leading.equalTo(self).offset(20);
            make.width.equalTo(@1);
         make.centerX.equalTo(self.dianView.mas_centerX);
            make.bottom.equalTo(self.dianView.mas_top);
        }];
    
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.dianView);
        make.leading.equalTo(self.topLineView.mas_trailing).offset(15);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dianView.mas_bottom);
        make.centerX.equalTo(self.dianView.mas_centerX);
        
        make.width.equalTo(@1);
        make.bottom.equalTo(self);
    }];
}

- (UIView *)topLineView {
    if (!_topLineView) {
        _topLineView = [UIView new];
        _topLineView.backgroundColor = BGGrayColor;
    }
    return _topLineView;
}

- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [UILabel new];
        _stateLabel.font = [UIFont boldSystemFontOfSize:14];
        _stateLabel.textColor = CharacterDarkColor;
    }
    return _stateLabel;
}

- (UIView *)dianView {
    if (!_dianView) {
        _dianView = [UIView new];
        _dianView.layer.cornerRadius = 2.5;
        _dianView.layer.masksToBounds = YES;
    }
    return _dianView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

@end


/**
 物流信息
 */
@interface LTSCWuLiuInfoCell : UITableViewCell

@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) LTSCWuLiuInfoListModel *infoModel;

@property (nonatomic, strong) UIView *lineView;//左侧线

@end

@implementation LTSCWuLiuInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubViews];
        [self setConstrains];
        [self setData];
    }
    return self;
}

/**
 添加视图
 */
- (void)initSubViews {
    [self addSubview:self.detailLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.lineView];
}

/**
 设置约束
 */
- (void)setConstrains {
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.leading.equalTo(self).offset(36);
        make.trailing.equalTo(self).offset(-15);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailLabel.mas_bottom).offset(5);
        make.leading.equalTo(self).offset(36);
        make.trailing.equalTo(self).offset(-15);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.leading.equalTo(self).offset(20);
        make.width.equalTo(@1);
    }];
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
        _detailLabel.font = [UIFont systemFontOfSize:12];
        _detailLabel.textColor = CharacterDarkColor;
        _detailLabel.numberOfLines = 0;
    }
    return _detailLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.font = [UIFont systemFontOfSize:9];
        _timeLabel.textColor = CharacterLightGrayColor;
    }
    return _timeLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (void)setData {
    self.detailLabel.text = @"您的订单已有本人签收";
    self.timeLabel.text = @"2018-09-22 17:23:56";
}

- (void)setInfoModel:(LTSCWuLiuInfoListModel *)infoModel {
    _infoModel = infoModel;
    self.detailLabel.text = _infoModel.context;
    if (infoModel.diff.isValid) {
        self.timeLabel.text = [NSString stringWithFormat:@"%@-%@  %@", _infoModel.year,_infoModel.day,_infoModel.diff];
    } else {
        self.timeLabel.text = [NSString stringWithFormat:@"%@", _infoModel.create_time];
    }
}

@end



@interface LTSCWuLiuInfoVC ()

@property (nonatomic, strong) UIView *lineView;//

@end

@implementation LTSCWuLiuInfoVC

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"物流信息";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initSubviews];
}
/**
 初始化子视图
 */
- (void)initSubviews {
    [self.view addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.height.equalTo(@1);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom);
        make.leading.bottom.trailing.equalTo(self.view);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1 + self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : self.dataArr[section - 1].list.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        LTSCWuLiuInfoOrderCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LTSCWuLiuInfoOrderCell"];
        if (!cell) {
            cell = [[LTSCWuLiuInfoOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LTSCWuLiuInfoOrderCell"];
        }
        cell.mapData = self.mapData;
        return cell;
    } else {
        LTSCWuLiuInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LTSCWuLiuInfoCell"];
        if (!cell) {
            cell = [[LTSCWuLiuInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LTSCWuLiuInfoCell"];
        }
        cell.lineView.hidden = indexPath.section == self.dataArr.count ? YES : NO;
        cell.infoModel = self.dataArr[indexPath.section - 1].list[indexPath.row];
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }
    LTSCWuLiuInfoOrderHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"LTSCWuLiuInfoOrderHeaderView"];
    if (!headerView) {
        headerView = [[LTSCWuLiuInfoOrderHeaderView alloc] initWithReuseIdentifier:@"LTSCWuLiuInfoOrderHeaderView"];
    }
    headerView.topLineView.hidden = section == 1 ? YES : NO;
    headerView.dianView.backgroundColor = section == 1 ? MineColor : LineColor;
    headerView.stateLabel.text = self.dataArr[section - 1].title;
    headerView.lineView.hidden = section == self.dataArr.count ? YES : NO;
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
    if (!footerView) {
        footerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"UITableViewHeaderFooterView"];
    }
    footerView.contentView.backgroundColor = section == 0 ? [UIColor clearColor] : [UIColor whiteColor];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    }
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == 0 ? 10 : section == self.dataArr.count ? 10 : 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.mapData.company.isValid) {
            return 70;
        }
        return 50;
    }
 
    return self.dataArr[indexPath.section - 1].list[indexPath.row].cellH;
}





@end
