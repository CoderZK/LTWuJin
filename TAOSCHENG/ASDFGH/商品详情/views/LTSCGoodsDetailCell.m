//
//  LTSCGoodsDetailCell.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/17.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LTSCGoodsDetailCell.h"

@interface LTSCGoodsDetailCell()

@property (nonatomic , strong) UILabel *priceLabel;//价格

@property (nonatomic, strong) UILabel *titleLabel;//标题

@property (nonatomic, strong) UIImageView *stateImgView;//人气严选 爆款推荐

@end

@implementation LTSCGoodsDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.priceLabel];
        [self addSubview:self.titleLabel];
        [self addSubview:self.stateImgView];
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(25);
            make.leading.equalTo(self).offset(15);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.priceLabel.mas_bottom).offset(15);
            make.leading.equalTo(self).offset(15);
            make.trailing.equalTo(self).offset(-15);
        }];
        [self.stateImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.priceLabel);
            make.leading.equalTo(self.priceLabel.mas_trailing).offset(10);
            make.width.equalTo(@60.5);
            make.height.equalTo(@18);
        }];
    }
    return self;
}

- (UIImageView *)stateImgView {
    if (!_stateImgView) {
        _stateImgView = [[UIImageView alloc] init];
    }
    return _stateImgView;
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

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = MineColor;
        _priceLabel.font = [UIFont systemFontOfSize:18];
    }
    return _priceLabel;
}

- (void)setDetailModel:(LTSCGoodsDetailModel *)detailModel {
    _detailModel = detailModel;
    _titleLabel.text = _detailModel.goodName;
    _priceLabel.text = [NSString stringWithFormat:@"¥%@",_detailModel.normalPrice.getPriceStr];
    if (_detailModel.info_type.intValue == 0) {
        self.stateImgView.hidden = YES;
    }else {
        self.stateImgView.hidden = NO;
        self.stateImgView.image = [UIImage imageNamed:_detailModel.info_type.intValue == 1 ? @"rqyx" : @"bktj"];
    }
}


@end

@interface LTSCGoodsDetailGuiGeCell()

@property (nonatomic, strong) UILabel *guigeLabel;//规格 数量

@property (nonatomic, strong) UIImageView *iconImgView;//箭头

@end
@implementation LTSCGoodsDetailGuiGeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.guigeLabel];
        [self addSubview:self.iconImgView];
        [self.guigeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.trailing.equalTo(self.iconImgView.mas_leading).offset(-3);
            make.centerY.equalTo(self);
        }];
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self).offset(-11);
            make.centerY.equalTo(self);
            make.width.height.equalTo(@22);
        }];
    }
    return self;
}

- (UILabel *)guigeLabel {
    if (!_guigeLabel) {
        _guigeLabel = [[UILabel alloc] init];
        _guigeLabel.textColor = CharacterLightGrayColor;
        _guigeLabel.font = [UIFont systemFontOfSize:15];
        _guigeLabel.numberOfLines = 2;
        _guigeLabel.text = @"请选择规格数量";
    }
    return _guigeLabel;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.image = [UIImage imageNamed:@"next"];
    }
    return _iconImgView;
}

- (void)setDetailModel:(LTSCGoodsDetailModel *)detailModel {
    _detailModel = detailModel;
    if (_detailModel.yixuanStr) {
        _guigeLabel.textColor = CharacterDarkColor;
        _guigeLabel.text = _detailModel.yixuanStr;
    }else {
        _guigeLabel.text = @"请选择规格数量";
        _guigeLabel.textColor = CharacterLightGrayColor;
    }
}

@end

@interface LTSCGoodsAddressCell()

@property (nonatomic, strong) UILabel *peisongLabel;//配送

@property (nonatomic, strong) UILabel *addresslabel;//配送地址

@property (nonatomic, strong) UILabel *timelabel;//几点送达

@property (nonatomic, strong) UIImageView *iconImgView;//箭头

@end
@implementation LTSCGoodsAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.peisongLabel];
        [self addSubview:self.addresslabel];
        [self addSubview:self.timelabel];
        [self addSubview:self.iconImgView];
        [self.peisongLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.equalTo(self).offset(15);
            make.width.equalTo(@60);
        }];
        [self.addresslabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(15);
            make.leading.equalTo(self.peisongLabel.mas_trailing).offset(15);
            make.trailing.equalTo(self).offset(-50);
        }];
        [self.timelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.addresslabel.mas_bottom).offset(10);
            make.leading.equalTo(self.peisongLabel.mas_trailing).offset(15);
            make.trailing.equalTo(self).offset(-50);
        }];
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self).offset(-15);
            make.centerY.equalTo(self);
            make.width.height.equalTo(@22);
        }];
    }
    return self;
}

- (UILabel *)peisongLabel {
    if (!_peisongLabel) {
        _peisongLabel = [[UILabel alloc] init];
        _peisongLabel.text = @"配送至";
        _peisongLabel.textColor = CharacterGrayColor;
        _peisongLabel.font = [UIFont systemFontOfSize:15];
    }
    return _peisongLabel;
}

- (UILabel *)addresslabel {
    if (!_addresslabel) {
        _addresslabel = [[UILabel alloc] init];
        _addresslabel.textColor = CharacterDarkColor;
        _addresslabel.text = @"常州市天宁区青龙街道建材宿舍12栋";
        _addresslabel.font = [UIFont systemFontOfSize:15];
        _addresslabel.numberOfLines = 0;
    }
    return _addresslabel;
}

- (UILabel *)timelabel {
    if (!_timelabel) {
        _timelabel = [[UILabel alloc] init];
        _timelabel.textColor = CharacterGrayColor;
        _timelabel.text = @"18:00前完成支付,预计(后天)04月24日送达";
        _timelabel.font = [UIFont systemFontOfSize:13];
        _timelabel.numberOfLines = 0;
    }
    return _timelabel;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.image = [UIImage imageNamed:@"next"];
    }
    return _iconImgView;
}

- (void)setAddressModel:(LTSCGoodsDetailAdressModel *)addressModel {
    _addressModel = addressModel;
    _addresslabel.text = [NSString stringWithFormat:@"%@%@%@%@",_addressModel.province, _addressModel.city, _addressModel.district, _addressModel.addressDetail];
}

@end

@interface LTSCGoodsNoteCell()

@property (nonatomic, strong) UIImageView *iconImgView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *iconImgView1;

@property (nonatomic, strong) UILabel *titleLabel1;
@property (nonatomic, strong) UIImageView *iconImgView2;

@property (nonatomic, strong) UILabel *titleLabel2;

@end
@implementation LTSCGoodsNoteCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.iconImgView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.iconImgView1];
        [self addSubview:self.titleLabel1];
        [self addSubview:self.iconImgView2];
        [self addSubview:self.titleLabel2];
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.centerY.equalTo(self);
            make.width.height.equalTo(@5.5);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.iconImgView.mas_trailing).offset(10);
            make.centerY.equalTo(self);
        }];
        [self.iconImgView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.titleLabel.mas_trailing).offset(30);
            make.centerY.equalTo(self);
        }];
        [self.titleLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.iconImgView1.mas_trailing).offset(10);
            make.centerY.equalTo(self);
        }];
        
        [self.iconImgView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.titleLabel1.mas_trailing).offset(30);
            make.centerY.equalTo(self);
        }];
        [self.titleLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.iconImgView2.mas_trailing).offset(10);
            make.centerY.equalTo(self);
        }];
        
    }
    return self;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.image = [UIImage imageNamed:@"note"];
    }
    return _iconImgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = CharacterGrayColor;
        _titleLabel.text = @"店铺发货&售后";
        _titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _titleLabel;
}

- (UIImageView *)iconImgView1 {
    if (!_iconImgView1) {
        _iconImgView1 = [[UIImageView alloc] init];
        _iconImgView1.image = [UIImage imageNamed:@"note"];
    }
    return _iconImgView1;
}

- (UILabel *)titleLabel1 {
    if (!_titleLabel1) {
        _titleLabel1 = [[UILabel alloc] init];
        _titleLabel1.textColor = CharacterGrayColor;
        _titleLabel1.text = @"专业包装";
        _titleLabel1.font = [UIFont systemFontOfSize:13];
    }
    return _titleLabel1;
}


- (UIImageView *)iconImgView2 {
    if (!_iconImgView2) {
        _iconImgView2 = [[UIImageView alloc] init];
        _iconImgView2.image = [UIImage imageNamed:@"note"];
    }
    return _iconImgView2;
}

- (UILabel *)titleLabel2 {
    if (!_titleLabel2) {
        _titleLabel2 = [[UILabel alloc] init];
        _titleLabel2.textColor = CharacterGrayColor;
        _titleLabel2.text = @"极速发货";
        _titleLabel2.font = [UIFont systemFontOfSize:13];
    }
    return _titleLabel2;
}


@end


@interface LTSCGoodsImgCell()

@property (nonatomic, strong) UIImageView *imgView;//图片

@end
@implementation LTSCGoodsImgCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.imgView];
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.equalTo(@200);
            make.height.equalTo(@200);
        }];
    }
    return self;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
    }
    return _imgView;
}

- (void)setTupianModel:(LTSCGoodsDetailTuPianModel *)tupianModel {
    _tupianModel = tupianModel;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:_tupianModel.url] placeholderImage:[UIImage imageNamed:@"blank"]];
    if (_tupianModel.width.integerValue > ScreenW) {
        [self.imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self); make.height.equalTo(@(ScreenW*tupianModel.height.integerValue/tupianModel.width.integerValue));
            make.width.equalTo(@(ScreenW));
        }];
    }else {
        [self.imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.equalTo(@(tupianModel.width.integerValue));
            make.height.equalTo(@(tupianModel.height.integerValue));
        }];
    }
    
}

@end



/**
 请选择地址
 */
@interface LTSCNoneAddressCell ()

@property (nonatomic, strong) UILabel *titleLabel;//地址

@property (nonatomic, strong) UIImageView *iconImgView;//箭头

@end
@implementation LTSCNoneAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.titleLabel];
        [self addSubview:self.iconImgView];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.trailing.equalTo(self.iconImgView.mas_leading).offset(-3);
            make.centerY.equalTo(self);
        }];
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self).offset(-11);
            make.centerY.equalTo(self);
            make.width.height.equalTo(@22);
        }];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = CharacterLightGrayColor;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.text = @"请选择地址";
    }
    return _titleLabel;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.image = [UIImage imageNamed:@"next"];
    }
    return _iconImgView;
}

@end

#import "LTSCPingJiaVC.h"
@interface LTSCGoodsDetailHeaderView ()

@property (nonatomic, strong) UIButton *bgBtn;

@property (nonatomic, strong) UILabel *moreLabel;//更多

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *moreImgView;//箭头

@end
@implementation LTSCGoodsDetailHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = YES;
        self.contentView.backgroundColor = UIColor.whiteColor;
        [self initSubbviews];
        [self setConstrains];
    }
    return self;
}

/**
 添加子视图
 */
- (void)initSubbviews {
    [self addSubview:self.bgBtn];
    [self.bgBtn addSubview:self.titleLabel];
    [self.bgBtn addSubview:self.moreLabel];
    [self.bgBtn addSubview:self.moreImgView];
    
}

/**
 添加约束
 */
- (void)setConstrains {
    [self.bgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.bgBtn).offset(15);
        make.centerY.equalTo(self.bgBtn);
    }];
    [self.moreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.moreImgView.mas_leading);
        make.centerY.equalTo(self.bgBtn);
    }];
    [self.moreImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.bgBtn).offset(-8.5);
        make.centerY.equalTo(self.bgBtn);
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
        _moreLabel.textColor = MineColor;
        _moreLabel.font = [UIFont systemFontOfSize:14];
        _moreLabel.text = @"查看全部";
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


- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = CharacterDarkColor;
        _titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _titleLabel;
}

- (void)sectionClick {//查看全部评价
    LTSCPingJiaVC *vc = [[LTSCPingJiaVC alloc] initWithTableViewStyle:UITableViewStyleGrouped];
    vc.goodId = self.goodsId;
    [UIViewController.topViewController.navigationController pushViewController:vc animated:YES];
}

- (void)setEvalNum:(NSString *)evalNum {
    _evalNum = evalNum;
    if (_evalNum.intValue == 0) {
        _titleLabel.text = @"商品评价";
    } else {
        _titleLabel.text = [NSString stringWithFormat:@"商品评价(%d)", _evalNum.intValue];
    }
}


@end

//商品评价
@implementation LTSCPingJiaImgCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imgView];
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [UIImageView new];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.layer.masksToBounds = YES;
        _imgView.image = [UIImage imageNamed:@"tupian"];
    }
    return _imgView;
}

@end


#import "MLYPhotoBrowserView.h"
@interface LTSCPingJiaCell ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MLYPhotoBrowserViewDataSource>

@property (nonatomic, strong) UIImageView *headerImgView;//评价人头像

@property (nonatomic, strong) UILabel *nicknameLabel;//昵称

@property (nonatomic, strong) UILabel *timeLabel;//时间

@property (nonatomic, strong) UILabel *contentLabel;//评价内容

@property (nonatomic, strong) UICollectionView *collectionView;//评价图

@property (nonatomic, strong) NSArray <NSString *>*imgs;

@end
@implementation LTSCPingJiaCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.clipsToBounds = YES;
        [self initSubviews];
        [self setConstrians];
    }
    return self;
}

- (void)initSubviews {
    [self addSubview:self.headerImgView];
    [self addSubview:self.nicknameLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.contentLabel];
    [self addSubview:self.collectionView];
}

- (void)setConstrians {
    [self.headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.leading.equalTo(self).offset(15);
        make.size.equalTo(@20);
    }];
    [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.headerImgView.mas_trailing).offset(7.5);
        make.centerY.equalTo(self.headerImgView);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nicknameLabel.mas_bottom).offset(5);
        make.leading.equalTo(self.headerImgView.mas_trailing).offset(7.5);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerImgView.mas_bottom).offset(10);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.mas_bottom).offset(18);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.height.equalTo(@(floor((ScreenW - 50)/3.0)));
    }];
    
}

- (UIImageView *)headerImgView {
    if (!_headerImgView) {
        _headerImgView = [UIImageView new];
        _headerImgView.layer.masksToBounds = YES;
    }
    return _headerImgView;
}

- (UILabel *)nicknameLabel {
    if (!_nicknameLabel) {
        _nicknameLabel = [UILabel new];
        _nicknameLabel.font = [UIFont systemFontOfSize:13];
        _nicknameLabel.textColor = LightGrayColor;
    }
    return _nicknameLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = [UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:1.0];
    }
    return _timeLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
        _contentLabel.font = [UIFont systemFontOfSize:13];
        _contentLabel.textColor = CharacterDarkColor;
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        layout.itemSize = CGSizeMake(floor((ScreenW - 50)/3.0), floor((ScreenW - 50)/3.0));
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenW - 30, floor((ScreenW - 50)/3.0)) collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:LTSCPingJiaImgCell.class forCellWithReuseIdentifier:@"LTSCPingJiaImgCell"];
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imgs.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LTSCPingJiaImgCell *itemCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LTSCPingJiaImgCell" forIndexPath:indexPath];
    [itemCell.imgView sd_setImageWithURL:[NSURL URLWithString:self.imgs[indexPath.item]] placeholderImage:[UIImage imageNamed:@"789789"]];
    return itemCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
   MLYPhotoBrowserView *mlyView = [MLYPhotoBrowserView photoBrowserView];
   mlyView.dataSource = self;
   mlyView.currentIndex = indexPath.row;
   [mlyView showWithItemsSpuerView:nil];
}

- (void)setEvalModel:(LTSCGoodsDetailEvalModel *)evalModel {
    _evalModel = evalModel;
    if (_evalModel.list_pic.isValid) {
        self.imgs = [_evalModel.list_pic componentsSeparatedByString:@","];
    }
    [_headerImgView sd_setImageWithURL:[NSURL URLWithString:_evalModel.head_pic] placeholderImage:[UIImage imageNamed:@"789789"]];
    _contentLabel.text = _evalModel.remark;
    _nicknameLabel.text = _evalModel.username;
    _headerImgView.layer.cornerRadius = 10;
    [_headerImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.leading.equalTo(self).offset(15);
        make.size.equalTo(@20);
    }];
    self.timeLabel.hidden = YES;
    if (self.imgs.count > 0) {
        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentLabel.mas_bottom).offset(18);
            make.leading.equalTo(self).offset(15);
            make.trailing.equalTo(self).offset(-15);
            make.height.equalTo(@(floor((ScreenW - 50)/3.0)));
        }];
        [self.collectionView reloadData];
    } else {
        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentLabel.mas_bottom).offset(18);
            make.leading.equalTo(self).offset(15);
            make.trailing.equalTo(self).offset(-15);
            make.height.equalTo(@0);
        }];
    }
}


- (void)setEvalModel1:(LTSCGoodsDetailEvalModel *)evalModel1 {
    _evalModel1 = evalModel1;
    if (_evalModel1.list_pic.isValid) {
        self.imgs = [_evalModel1.list_pic componentsSeparatedByString:@","];
    }
    _headerImgView.layer.cornerRadius = 17.5;
    [_headerImgView sd_setImageWithURL:[NSURL URLWithString:_evalModel1.head_pic] placeholderImage:[UIImage imageNamed:@"789789"]];
    _contentLabel.text = _evalModel1.remark;
    _nicknameLabel.text = _evalModel1.username;
    _timeLabel.text = _evalModel1.create_time;
    [_headerImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.leading.equalTo(self).offset(15);
        make.size.equalTo(@35);
    }];
    [self.nicknameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.headerImgView.mas_trailing).offset(7.5);
        make.bottom.equalTo(self.headerImgView.mas_centerY).offset(-3);
    }];
    self.timeLabel.hidden = NO;
    if (self.imgs.count > 0) {
        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentLabel.mas_bottom).offset(18);
            make.leading.equalTo(self).offset(15);
            make.trailing.equalTo(self).offset(-15);
            make.height.equalTo(@((floor((ScreenW - 50)/3.0) + 10) * ceil(self.imgs.count/3.0) + 18));
        }];
        [self.collectionView reloadData];
    } else {
        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentLabel.mas_bottom).offset(18);
            make.leading.equalTo(self).offset(15);
            make.trailing.equalTo(self).offset(-15);
            make.height.equalTo(@0);
        }];
    }
}

////图片放大
- (NSInteger)numberOfItemsInPhotoBrowserView:(MLYPhotoBrowserView *)photoBrowserView{
    return self.imgs.count;
}
- (MLYPhoto *)photoBrowserView:(MLYPhotoBrowserView *)photoBrowserView photoForItemAtIndex:(NSInteger)index{
    MLYPhoto *photo = [[MLYPhoto alloc] init];
    photo.imageUrl = [NSURL URLWithString:self.imgs[index]];
    return photo;
}

@end


@interface LTSCPingJiaHeaderView ()

@property (nonatomic, strong) UIButton *bgBtn;

@end
@implementation LTSCPingJiaHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = YES;
        self.contentView.backgroundColor = UIColor.whiteColor;
        [self initSubbviews];
        [self setConstrains];
    }
    return self;
}

/**
 添加子视图
 */
- (void)initSubbviews {
    [self addSubview:self.bgBtn];
    [self.bgBtn addSubview:self.moreLabel];
}

/**
 添加约束
 */
- (void)setConstrains {
    [self.bgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.moreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.bgBtn).offset(-15);
        make.centerY.equalTo(self.bgBtn);
    }];
}

- (UIButton *)bgBtn {
    if (!_bgBtn) {
        _bgBtn = [[UIButton alloc] init];
        [_bgBtn addTarget:self action:@selector(sectionClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bgBtn;
}

- (UILabel *)moreLabel {
    if (!_moreLabel) {
        _moreLabel = [[UILabel alloc] init];
        _moreLabel.textColor = LightGrayColor;
        _moreLabel.font = [UIFont systemFontOfSize:14];
        _moreLabel.text = @"默认排序";
    }
    return _moreLabel;
}

- (void)sectionClick:(UIButton *)btn {
    btn.selected = !btn.selected;
    NSInteger index = 10;
    index = btn.selected ? 11 : 10;
    if (self.didSelectBlock) {
        self.didSelectBlock(index);
    }
    
}

@end

@interface LTSCPingJiaSellectCell ()

@property (nonatomic, strong) UIButton *allButton;

@property (nonatomic, strong) UIButton *imgButton;

@end

@implementation LTSCPingJiaSellectCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.allButton];
        [self addSubview:self.imgButton];
        [self.allButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.centerY.equalTo(self);
            make.width.equalTo(@50);
            make.height.equalTo(@30);
        }];
        [self.imgButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.allButton.mas_trailing).offset(15);
            make.centerY.equalTo(self);
            make.height.equalTo(@30);
        }];
    }
    return self;
}

- (UIButton *)allButton {
    if (!_allButton) {
        _allButton = [UIButton new];
        _allButton.titleLabel.font = [UIFont systemFontOfSize:14];
        
        _allButton.layer.borderWidth = 0.5;
        _allButton.layer.cornerRadius = 2;
        _allButton.layer.masksToBounds = YES;
        [_allButton setTitle:@"全部" forState:UIControlStateNormal];
        [_allButton setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
        [_allButton setTitleColor:MineColor forState:UIControlStateSelected];
        _allButton.layer.borderColor = MineColor.CGColor;
        _allButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:246/255.0 blue:232/255.0 alpha:1.0];
        _allButton.selected = YES;
        [_allButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _allButton;
}

- (UIButton *)imgButton {
    if (!_imgButton) {
        _imgButton = [UIButton new];
        _imgButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _imgButton.layer.borderWidth = 0.5;
        _imgButton.layer.cornerRadius = 2;
        _imgButton.layer.masksToBounds = YES;
        [_imgButton setTitle:@"  有图  " forState:UIControlStateNormal];
        [_imgButton setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
        [_imgButton setTitleColor:MineColor forState:UIControlStateSelected];
        _imgButton.layer.borderColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0].CGColor;
        _imgButton.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
        [_imgButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _imgButton;
}

- (void)setModel:(LTSCPingJiaMapModel *)model {
    _model = model;
    if (_model.picNum.intValue == 0) {
        [_imgButton setTitle:@"  有图  " forState:UIControlStateNormal];
    } else {
        [_imgButton setTitle:[NSString stringWithFormat:@"  有图(%d)  ", _model.picNum.intValue] forState:UIControlStateNormal];
    }
}

- (void)btnClick:(UIButton *)btn {
    btn.selected = !btn.selected;
    NSInteger index = 111;
    if (btn == _allButton) {
        _imgButton.selected = !btn.selected;
    } else {
        _allButton.selected = !btn.selected;
    }
    if (_allButton.selected) {
        index = 111;
        _allButton.layer.borderColor = MineColor.CGColor;
        _allButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:246/255.0 blue:232/255.0 alpha:1.0];
        _imgButton.layer.borderColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0].CGColor;
        _imgButton.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
    } else {
        index = 112;
        _imgButton.layer.borderColor = MineColor.CGColor;
        _imgButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:246/255.0 blue:232/255.0 alpha:1.0];
        _allButton.layer.borderColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0].CGColor;
        _allButton.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
    }
    if (self.didSelectBlock) {
        self.didSelectBlock(index);
    }
}

@end


//商品详情 顶部  商品 评价  详情

@implementation LTSCGoodsDetailTopButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.textLabel];
        [self addSubview:self.lineView];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.textLabel.mas_bottom).offset(5);
            make.width.equalTo(self.textLabel);
            make.height.equalTo(@3);
            make.centerX.equalTo(self.textLabel);
        }];
    }
    return self;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [UILabel new];
        _textLabel.font = [UIFont systemFontOfSize:13];
    }
    return _textLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = MineColor;
        _lineView.layer.cornerRadius = 1.5;
        _lineView.layer.masksToBounds = YES;
    }
    return _lineView;
}

@end


@interface LTSCGoodsDetailTopView ()

@property (nonatomic, strong) LTSCGoodsDetailTopButton *shangpinButton;

@property (nonatomic, strong) LTSCGoodsDetailTopButton *pingjiaButton;

@property (nonatomic, strong) LTSCGoodsDetailTopButton *detailButton;

@property (nonatomic, strong) NSMutableArray <LTSCGoodsDetailTopButton *>*btnArr;

@end

@implementation LTSCGoodsDetailTopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.shangpinButton];
        [self addSubview:self.pingjiaButton];
        [self addSubview:self.detailButton];
        [self.shangpinButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.bottom.equalTo(self);
        }];
        [self.pingjiaButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.leading.equalTo(self.shangpinButton.mas_trailing).offset(15);
        }];
        [self.detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.trailing.equalTo(self);
            make.leading.equalTo(self.pingjiaButton.mas_trailing).offset(15);
        }];
        self.btnArr = [NSMutableArray array];
        [self.btnArr addObject:self.shangpinButton];
        [self.btnArr addObject:self.pingjiaButton];
        [self.btnArr addObject:self.detailButton];
    }
    return self;
}

- (LTSCGoodsDetailTopButton *)shangpinButton {
    if (!_shangpinButton) {
        _shangpinButton = [LTSCGoodsDetailTopButton new];
        _shangpinButton.textLabel.text = @"商品";
        _shangpinButton.textLabel.textColor = MineColor;
        _shangpinButton.lineView.hidden = NO;
        [_shangpinButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _shangpinButton.tag = 201;
    }
    return _shangpinButton;
}

- (LTSCGoodsDetailTopButton *)pingjiaButton {
    if (!_pingjiaButton) {
        _pingjiaButton = [LTSCGoodsDetailTopButton new];
        _pingjiaButton.textLabel.text = @"评价";
        _pingjiaButton.textLabel.textColor = CharacterDarkColor;
        _pingjiaButton.lineView.hidden = YES;
        [_pingjiaButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _pingjiaButton.tag = 202;
    }
    return _pingjiaButton;
}

- (LTSCGoodsDetailTopButton *)detailButton {
    if (!_detailButton) {
        _detailButton = [LTSCGoodsDetailTopButton new];
        _detailButton.textLabel.text = @"详情";
        _detailButton.textLabel.textColor = CharacterDarkColor;
        _detailButton.lineView.hidden = YES;
        [_detailButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _detailButton.tag = 203;
    }
    return _detailButton;
}


- (void)btnClick:(LTSCGoodsDetailTopButton *)btn {
    if (self.noDefaultSelected) {
        if (self.selectTopButtonBlock) {
            self.selectTopButtonBlock(btn.tag);
        }
        return;
    }
    btn.selected = !btn.selected;
    for (LTSCGoodsDetailTopButton *btnn in self.btnArr) {
        btnn.selected = btnn == btn;
        if (btnn.selected) {
            btnn.textLabel.textColor = MineColor;
            btnn.lineView.hidden = NO;
            if (self.selectTopButtonBlock) {
                self.selectTopButtonBlock(btnn.tag);
            }
        } else {
            btnn.textLabel.textColor = CharacterDarkColor;
            btnn.lineView.hidden = YES;
        }
    }
}

- (void)setSelectIndex: (NSInteger)index {
    for (LTSCGoodsDetailTopButton *btnn in self.btnArr) {
        btnn.selected = btnn.tag == index;
        if (btnn.selected) {
            btnn.textLabel.textColor = MineColor;
            btnn.lineView.hidden = NO;
        } else {
           btnn.textLabel.textColor = CharacterDarkColor;
           btnn.lineView.hidden = YES;
        }
    }
}

- (void)hiddenComment:(BOOL)hide {
    self.pingjiaButton.hidden = hide;
    if (hide) {
        [self.shangpinButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.bottom.equalTo(self);
        }];
        [self.detailButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.trailing.equalTo(self);
            make.leading.equalTo(self.shangpinButton.mas_trailing);
            make.width.equalTo(self.shangpinButton.mas_width);
        }];
    } else {
        [self.shangpinButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.bottom.equalTo(self);
        }];
        [self.pingjiaButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.leading.equalTo(self.shangpinButton.mas_trailing).offset(15);
            make.width.equalTo(self.shangpinButton.mas_width);
        }];
        [self.detailButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.trailing.equalTo(self);
            make.leading.equalTo(self.pingjiaButton.mas_trailing).offset(15);
            make.width.equalTo(self.shangpinButton.mas_width);
        }];
    }
}

@end
