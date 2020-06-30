//
//  LTSCHomeTableSectionHeaderView.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/16.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LTSCHomeTableSectionHeaderView.h"

@interface LTSCHomeTableSectionHeaderView()

@property (nonatomic, strong) UIView *bgView;//背景

@property (nonatomic, strong) UIView *yellowLineView;//黄线条

@property (nonatomic, strong) UILabel *titleLabel;//标题

@property (nonatomic, strong) UIButton *bgBtn;

@property (nonatomic, strong) UILabel *moreLabel;//更多

@property (nonatomic, strong) UIImageView *moreImgView;//箭头

@end


@implementation LTSCHomeTableSectionHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = YES;
        [self initSubbviews];
        [self setConstrains];
    }
    return self;
}

/**
 添加子视图
 */
- (void)initSubbviews {
    [self addSubview:self.bgView];
    [self addSubview:self.bgBtn];
    [self.bgView addSubview:self.yellowLineView];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.moreLabel];
    [self.bgView addSubview:self.moreImgView];
    
}

/**
 添加约束
 */
- (void)setConstrains {
    [self.bgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.yellowLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.bgView).offset(15);
        make.centerY.equalTo(self.bgView);
        make.width.equalTo(@5);
        make.height.equalTo(@20);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.yellowLineView.mas_trailing).offset(5);
        make.centerY.equalTo(self.bgView);
    }];
    [self.moreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.moreImgView.mas_leading);
        make.centerY.equalTo(self.bgView);
    }];
    [self.moreImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.bgView).offset(-8.5);
        make.centerY.equalTo(self.bgView);
        make.width.height.equalTo(@22);
    }];
}

- (UIButton *)bgBtn {
    if (!_bgBtn) {
        _bgBtn = [[UIButton alloc] init];
        [_bgBtn addTarget:self action:@selector(sectionClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bgBtn;
}

- (UILabel *)moreLabel {
    if (!_moreLabel) {
        _moreLabel = [[UILabel alloc] init];
        _moreLabel.textColor = CharacterGrayColor;
        _moreLabel.font = [UIFont systemFontOfSize:15];
        _moreLabel.text = @"更多";
    }
    return _moreLabel;
}

- (UIImageView *)moreImgView {
    if (!_moreImgView) {
        _moreImgView = [[UIImageView alloc] init];
        _moreImgView.image = [UIImage imageNamed:@"next"];
    }
    return _moreImgView;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = UIColor.whiteColor;
    }
    return _bgView;
}

- (UIView *)yellowLineView {
    if (!_yellowLineView) {
        _yellowLineView = [[UIView alloc] init];
        _yellowLineView.backgroundColor = MineColor;
    }
    return _yellowLineView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = CharacterDarkColor;
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
    }
    return _titleLabel;
}

- (void)setSection:(NSInteger)section {
    _section = section;
    _moreLabel.hidden = _section == 0;
    _moreImgView.hidden = _section == 0;
    self.titleLabel.text = _section == 0 ? @"优惠券" : _section == 1 ? @"人气严选" : @"爆款推荐";
}

- (void)sectionClick {
    if (self.sectionHeaderClick) {
        self.sectionHeaderClick(self.section);
    }
}

@end


@interface LTSCHomeTableSectionHeaderView1()

@property (nonatomic, strong) UIView *bgView;//背景

@property (nonatomic, strong) UILabel *titleLabel;//标题

@end


@implementation LTSCHomeTableSectionHeaderView1

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubbviews];
        [self setConstrains];
    }
    return self;
}

/**
 添加子视图
 */
- (void)initSubbviews {
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.titleLabel];
}

/**
 添加约束
 */
- (void)setConstrains {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.bottom.equalTo(self);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(20);
        make.centerX.equalTo(self.bgView);
    }];
}


- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = UIColor.whiteColor;
    }
    return _bgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = UIColor.blackColor;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.text = @"-常见问题自助区-";
    }
    return _titleLabel;
}

@end

//首页优惠券
@interface LTSCYouHuiQuanCell ()

@property (nonatomic, strong) UIImageView *bgImgView;

@property (nonatomic, strong) UILabel *moneyLabel;

@property (nonatomic, strong) UILabel *textLabel1;

@property (nonatomic, strong) UILabel *dateLabel;//日期

@property (nonatomic, strong) UIImageView *lingquButton;//立即领取

@end
@implementation LTSCYouHuiQuanCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        [self initSubViews];
        [self setConstrains];
    }
    return self;
}

- (void)initSubViews {
    [self addSubview:self.bgImgView];
    [self addSubview:self.moneyLabel];
    [self addSubview:self.textLabel1];
    [self addSubview:self.dateLabel];
    [self addSubview:self.lingquButton];
}

- (void)setConstrains {
    [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(10);
        make.centerY.equalTo(self);
    }];
    [self.textLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.moneyLabel.mas_trailing).offset(5);
        make.bottom.equalTo(self.mas_centerY).offset(-2);
    }];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.moneyLabel.mas_trailing).offset(5);
        make.top.equalTo(self.mas_centerY).offset(2);
    }];
    [self.lingquButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.trailing.equalTo(self).offset(-17);
        make.size.equalTo(@48);
    }];
}

- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [UIImageView new];
        _bgImgView.image = [UIImage imageNamed:@"youhuiquan_bg"];
    }
    return _bgImgView;
}

- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [UILabel new];
        _moneyLabel.textColor = MineColor;
    }
    return _moneyLabel;
}

- (UILabel *)textLabel1 {
    if (!_textLabel1) {
        _textLabel1 = [UILabel new];
        _textLabel1.font = [UIFont systemFontOfSize:13];
        _textLabel1.textColor = MineColor;
        _textLabel1.text = @"无金额门槛";
    }
    return _textLabel1;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [UILabel new];
        _dateLabel.font = [UIFont systemFontOfSize:13];
        _dateLabel.textColor = MineColor;
        _dateLabel.text = @"01.10-01.20";
    }
    return _dateLabel;
}

- (UIImageView *)lingquButton {
    if (!_lingquButton) {
        _lingquButton = [UIImageView new];
    }
    return _lingquButton;
}

- (void)setModel:(LTSCYouHuiQuanModel *)model {
    _model = model;
    _lingquButton.image = [UIImage imageNamed:_model.isReceive.boolValue ? @"yilingqu" : @"lijilingqu"];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithAttributedString:[[NSAttributedString alloc] initWithString:@"¥" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}]];
    NSAttributedString *str  = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",_model.type.intValue == 1 ? _model.reduce_money.getPriceStr : _model.reduce_money.getPriceStr] attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:25]}];
    [att appendAttributedString:str];
    _moneyLabel.attributedText = att;
    
    if (_model.type.intValue == 1) {//type 1.满减，2.抵扣
        _textLabel1.text = [NSString stringWithFormat:@"满%ld可用",_model.full_money.integerValue];
    } else {
        _textLabel1.text = @"无金额门槛";
    }
    _dateLabel.text = [NSString stringWithFormat:@"%@-%@",[NSString formatterYouHuiQuanTime:_model.create_time], [NSString formatterYouHuiQuanTime:_model.last_time]];
}

@end

@interface LTSCHomeYouHuiQuanCell ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@end
@implementation LTSCHomeYouHuiQuanCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.layer.masksToBounds = YES;
        self.clipsToBounds = YES;
        [self addSubview:self.collectionView];
    }
    return self;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 15;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(270,73);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(15, 5, ScreenW - 30, 73) collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.scrollEnabled = YES;
        [_collectionView registerClass:LTSCYouHuiQuanCell.class forCellWithReuseIdentifier:@"LTSCYouHuiQuanCell"];
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.list.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LTSCYouHuiQuanCell *itemCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LTSCYouHuiQuanCell" forIndexPath:indexPath];
    itemCell.model = self.list[indexPath.item];
    return itemCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.list[indexPath.item].isReceive.boolValue) {
        if (self.lingquyouHuiQuanClickBlock) {
            self.lingquyouHuiQuanClickBlock(self.list[indexPath.item]);
        }
    }
}


- (void)setList:(NSArray<LTSCYouHuiQuanModel *> *)list {
    _list = list;
    [self.collectionView reloadData];
}


@end



@interface LTSCHomeReQiCell()

@property (nonatomic, strong) UIImageView *imgView;//图片

@property (nonatomic, strong) UILabel *titleLabel;//标题

@property (nonatomic, strong) UILabel *moneyLabel;//钱数

@property (nonatomic, strong) UILabel *qiangLabel;//马上抢

@property (nonatomic, strong) UIView *lineView;//线

@property (nonatomic, strong) UIImageView *stateImgView;//人气严选 爆款推荐

@end

@implementation LTSCHomeReQiCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = YES;
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
    [self addSubview:self.imgView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.moneyLabel];
    [self addSubview:self.qiangLabel];
    [self addSubview:self.lineView];
    [self addSubview:self.stateImgView];
}

/**
 添加约束
 */
- (void)setConstrains {
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(self).offset(15);
        make.width.height.equalTo(@115);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView).offset(5);
        make.leading.equalTo(self.imgView.mas_trailing).offset(10);
        make.trailing.equalTo(self).offset(-15);
    }];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.imgView.mas_trailing).offset(10);
        make.centerY.equalTo(self);
    }];
    [self.qiangLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.bottom.equalTo(self).offset(-15);
        make.width.equalTo(@80);
        make.height.equalTo(@30);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.bottom.equalTo(self);
        make.height.equalTo(@1);
    }];
    [self.stateImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.imgView);
        make.leading.equalTo(self.imgView.mas_trailing).offset(10);
        make.width.equalTo(@60.5);
        make.height.equalTo(@18);
    }];
}

- (UIImageView *)stateImgView {
    if (!_stateImgView) {
        _stateImgView = [[UIImageView alloc] init];
    }
    return _stateImgView;
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
        _titleLabel.numberOfLines = 2;
        _titleLabel.text = @"环保高粘性透明热熔胶棒家用大小号热熔硅胶条胶水枪胶抢7mm 11mm";
    }
    return _titleLabel;
}

- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.textColor = MineColor;
        _moneyLabel.font = [UIFont systemFontOfSize:18];
    }
    return _moneyLabel;
}

- (UILabel *)qiangLabel {
    if (!_qiangLabel) {
        _qiangLabel = [[UILabel alloc] init];
        _qiangLabel.backgroundColor = MineColor;
        _qiangLabel.text = @"马上抢";
        _qiangLabel.textColor = UIColor.whiteColor;
        _qiangLabel.font = [UIFont systemFontOfSize:15];
        _qiangLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _qiangLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (void)setChooseModel:(LTSCChooseListModel *)chooseModel {
    _chooseModel = chooseModel;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:_chooseModel.list_pic] placeholderImage:[UIImage imageNamed:@"tupian"]];
    _titleLabel.text = _chooseModel.good_name;
    _moneyLabel.text = [NSString stringWithFormat:@"¥%@",_chooseModel.normal_price.getPriceStr];
    if (_chooseModel.info_type.intValue == 0) {
        self.stateImgView.hidden = YES;
    }else {
        self.stateImgView.hidden = NO;
        self.stateImgView.image = [UIImage imageNamed:_chooseModel.info_type.intValue == 1 ? @"rqyx" : @"bktj"];
    }
}

@end


@interface LTSCHomeBaoKuanCell()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic , strong)UICollectionViewFlowLayout * layout;

@end
@implementation LTSCHomeBaoKuanCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.layout = [[UICollectionViewFlowLayout alloc] init];
        
        self.layout.minimumInteritemSpacing = 0;
        self.layout.minimumLineSpacing = 15;
        NSInteger num = ceil(8/2.0);
        CGFloat h = ((ScreenW - 45)/2)+ 75 + 15;
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(15, 0, ScreenW - 30, h * num) collectionViewLayout:self.layout];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.scrollEnabled = NO;
        [self addSubview:self.collectionView];
        
        [self.collectionView registerClass:[LTSCHomeBaoKuanCollectionCell class] forCellWithReuseIdentifier:@"LTSCHomeBaoKuanCollectionCell"];
    }
    return self;
}

- (void)setDataArr:(NSArray<LTSCChooseListModel *> *)dataArr {
    _dataArr = dataArr;
    NSInteger num = ceil(dataArr.count/2.0);
    CGFloat h = ((ScreenW - 45)/2)+ 75 + 15;
    self.collectionView.frame = CGRectMake(15, 0, ScreenW - 30, h * num);
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat h = ((ScreenW - 45)/2)+ 75;
    return CGSizeMake(floor((ScreenW - 45)/2), h);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LTSCHomeBaoKuanCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LTSCHomeBaoKuanCollectionCell" forIndexPath:indexPath];
    cell.chooseModel = self.dataArr[indexPath.item];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectItemBlock) {
        self.selectItemBlock(self.dataArr[indexPath.item]);
    }
}

@end

@interface LTSCHomeBaoKuanCollectionCell()

@property (nonatomic, strong) UIImageView *imgView;//图片

@property (nonatomic, strong) UILabel *titleLabel;//标题

@property (nonatomic, strong) UILabel *moneyLabel;//钱数

@property (nonatomic, strong) UIImageView *stateImgView;//人气严选 爆款推荐

@end
@implementation LTSCHomeBaoKuanCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        self.layer.cornerRadius = 3;
        self.layer.masksToBounds = YES;
        [self initSubviews];
        [self setConstrains];
    }
    return self;
}
/**
 添加视图
 */
- (void)initSubviews {
    [self addSubview:self.imgView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.moneyLabel];
    [self addSubview:self.stateImgView];
}

/**
 添加约束
 */
- (void)setConstrains {
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.equalTo(self);
        make.width.height.equalTo(@((ScreenW - 45)/2));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView.mas_bottom).offset(10);
        make.leading.equalTo(self).offset(5);
        make.trailing.equalTo(self).offset(-5);
    }];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.leading.equalTo(self).offset(5);
    }];
    [self.stateImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.moneyLabel);
        make.leading.equalTo(self.moneyLabel.mas_trailing).offset(5);
        make.width.equalTo(@60.5);
        make.height.equalTo(@18);
    }];
}

- (UIImageView *)stateImgView {
    if (!_stateImgView) {
        _stateImgView = [[UIImageView alloc] init];
    }
    return _stateImgView;
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
        _titleLabel.text = @"环保高粘性透明热熔胶棒家用大小号热熔硅胶条胶水枪胶抢7mm 11mm";
    }
    return _titleLabel;
}

- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.textColor = MineColor;
        _moneyLabel.textAlignment = NSTextAlignmentLeft;
        _moneyLabel.font = [UIFont systemFontOfSize:18];
    }
    return _moneyLabel;
}



- (void)setModel:(LTSCCateModel *)model {
    _model = model;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:_model.listPic] placeholderImage:[UIImage imageNamed:@"goods_blank"]];
    _titleLabel.text = _model.goodName;
    _moneyLabel.text = [NSString stringWithFormat:@"¥%@",_model.normalPrice.getPriceStr];
    if (_model.info_type.intValue == 0) {
        self.stateImgView.hidden = YES;
    }else {
        self.stateImgView.hidden = NO;
        self.stateImgView.image = [UIImage imageNamed:_model.info_type.intValue == 1 ? @"rqyx" : @"bktj"];
    }
}

- (void)setDianPuGoodsModel:(LTSCCateModel *)dianPuGoodsModel {
    _dianPuGoodsModel = dianPuGoodsModel;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:_dianPuGoodsModel.list_pic] placeholderImage:[UIImage imageNamed:@"goods_blank"]];
    _titleLabel.text = _dianPuGoodsModel.good_name;
    _moneyLabel.text = [NSString stringWithFormat:@"¥%@",_dianPuGoodsModel.normal_price.getPriceStr];
    if (_dianPuGoodsModel.info_type.intValue == 0) {
        self.stateImgView.hidden = YES;
    }else {
        self.stateImgView.hidden = NO;
        self.stateImgView.image = [UIImage imageNamed:_dianPuGoodsModel.info_type.intValue == 1 ? @"rqyx" : @"bktj"];
    }
}

- (void)setChooseModel:(LTSCChooseListModel *)chooseModel {
    _chooseModel = chooseModel;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:_chooseModel.list_pic] placeholderImage:[UIImage imageNamed:@"goods_blank"]];
    _titleLabel.text = _chooseModel.good_name;
    _moneyLabel.text = [NSString stringWithFormat:@"¥%@",_chooseModel.normal_price.getPriceStr];
    if (_chooseModel.info_type.intValue == 0) {
        self.stateImgView.hidden = YES;
    }else {
        self.stateImgView.hidden = NO;
        self.stateImgView.image = [UIImage imageNamed:_chooseModel.info_type.intValue == 1 ? @"rqyx" : @"bktj"];
    }
}

@end

@interface LTSCHomeQuestionCell()

@property (nonatomic, strong) UIButton *imgButton;//图片

@property (nonatomic, strong) UILabel *titleLabel;//标题

@property (nonatomic, strong) UILabel *detailLabel;//问题描述

@property (nonatomic, strong) UIView *lineView;//线

@end
@implementation LTSCHomeQuestionCell

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
    [self addSubview:self.imgButton];
    [self addSubview:self.titleLabel];
    [self addSubview:self.detailLabel];
    [self addSubview:self.lineView];
}

/**
 添加约束
 */
- (void)setConstrains {
    [self.imgButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(self).offset(15);
        make.width.equalTo(@24);
        make.height.equalTo(@22);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(15);
        make.leading.equalTo(self.imgButton.mas_trailing).offset(15);
        make.trailing.equalTo(self).offset(-15);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(3);
        make.leading.equalTo(self.imgButton.mas_trailing).offset(15);
        make.trailing.equalTo(self).offset(-15);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.bottom.equalTo(self);
        make.height.equalTo(@0.5);
    }];
}

- (UIButton *)imgButton {
    if (!_imgButton) {
        _imgButton = [[UIButton alloc] init];
        [_imgButton setBackgroundImage:[UIImage imageNamed:@"question"] forState:UIControlStateNormal];
        [_imgButton setTitle:@"Q1" forState:UIControlStateNormal];
        [_imgButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _imgButton.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _imgButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = CharacterDarkColor;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.textColor = CharacterGrayColor;
        _detailLabel.font = [UIFont systemFontOfSize:13];
        _detailLabel.numberOfLines = 2;
    }
    return _detailLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (void)setModel:(LTSCHomeQuestionModel *)model {
    _model = model;
    self.titleLabel.attributedText =_model.titleAtt;
    self.detailLabel.attributedText = _model.contentAtt;
}

- (void)setIndex:(NSInteger)index {
    _index = index;
    [_imgButton setTitle:[NSString stringWithFormat:@"Q%ld", index] forState:UIControlStateNormal];
}

@end
