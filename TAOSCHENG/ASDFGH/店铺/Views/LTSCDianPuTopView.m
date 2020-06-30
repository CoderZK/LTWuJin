//
//  LTSCDianPuTopView.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2020/4/8.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "LTSCDianPuTopView.h"

@interface LTSCDianPuTopView ()

@property (nonatomic, strong) UILabel *dianpuNameLabel;//店铺名称

@property (nonatomic, strong) UIImageView *iconImgView;

@property (nonatomic, strong) UILabel *fensiNumLabel;//粉丝数

@end


@implementation LTSCDianPuTopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = MineColor;
        [self initSubViews];
        [self setConstrains];
    }
    return self;
}

- (void)initSubViews {
    [self addSubview:self.backButton];
    [self addSubview:self.dianpuButton];
    [self.dianpuButton addSubview:self.dianpuNameLabel];
    [self.dianpuButton addSubview:self.iconImgView];
    [self addSubview:self.fensiNumLabel];
    [self addSubview:self.attentendButton];
    [self addSubview:self.searchView];
}

- (void)setConstrains {
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.top.equalTo(self).offset(NavigationSpace - 30);
        make.size.equalTo(@30);
    }];
    [self.dianpuButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.backButton.mas_trailing);
        make.trailing.equalTo(self.attentendButton.mas_leading);
        make.bottom.equalTo(self.backButton).offset(-7.5);
        make.height.equalTo(@40);
    }];
    [self.dianpuNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.equalTo(self.dianpuButton);
    }];
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.dianpuNameLabel.mas_trailing).offset(7.5);
        make.centerY.equalTo(self.dianpuNameLabel);
        make.size.equalTo(@12);
    }];
    [self.fensiNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dianpuButton.mas_bottom).offset(5);
        make.leading.equalTo(self.backButton.mas_trailing);
    }];
    [self.attentendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-15);
        make.centerY.equalTo(self.fensiNumLabel.mas_top);
        make.width.equalTo(@61);
        make.height.equalTo(@22);
    }];
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fensiNumLabel.mas_bottom).offset(10);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.height.equalTo(@30);
    }];
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton new];
        [_backButton setImage:[UIImage imageNamed:@"dianpu_back"] forState:UIControlStateNormal];
        _backButton.imageEdgeInsets = UIEdgeInsetsMake(19, 0, 0, 24.5);
    }
    return _backButton;
}

- (UIButton *)dianpuButton {
    if (!_dianpuButton) {
        _dianpuButton = [UIButton new];
    }
    return _dianpuButton;
}

- (UILabel *)dianpuNameLabel {
    if (!_dianpuNameLabel) {
        _dianpuNameLabel = [UILabel new];
        _dianpuNameLabel.textColor = UIColor.whiteColor;
        _dianpuNameLabel.font = [UIFont boldSystemFontOfSize:16];
        _dianpuNameLabel.text = @"";
    }
    return _dianpuNameLabel;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [UIImageView new];
        _iconImgView.image = [UIImage imageNamed:@"dianpu_comein"];
    }
    return _iconImgView;
}

- (UILabel *)fensiNumLabel {
    if (!_fensiNumLabel) {
        _fensiNumLabel = [UILabel new];
        _fensiNumLabel.textColor = UIColor.whiteColor;
        _fensiNumLabel.font = [UIFont systemFontOfSize:12];
        _fensiNumLabel.text = @"粉丝数0";
    }
    return _fensiNumLabel;
}

- (UIButton *)attentendButton {
    if (!_attentendButton) {
        _attentendButton = [UIButton new];
        _attentendButton.layer.borderWidth = 0.5;
        _attentendButton.layer.cornerRadius = 11;
        _attentendButton.layer.masksToBounds = YES;
        _attentendButton.layer.borderColor = UIColor.whiteColor.CGColor;
        [_attentendButton setTitle:@"+ 关注" forState:UIControlStateNormal];
        _attentendButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_attentendButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    }
    return _attentendButton;
}

- (LTSCHomeSearchView *)searchView {
    if (!_searchView) {
        _searchView = [[LTSCHomeSearchView alloc] init];
        [_searchView.bgButton addTarget:self action:@selector(searchButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _searchView.searchTF.placeholder = @"搜索店铺内商品";
        _searchView.searchTF.userInteractionEnabled = NO;
    }
    return _searchView;
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(ScreenW, NavigationSpace + 80);
}

- (void)setShopModel:(LTSCShopModel *)shopModel {
    _shopModel = shopModel;
    _dianpuNameLabel.text = _shopModel.shop_name;
    _fensiNumLabel.text = [NSString stringWithFormat:@"粉丝数%d", _shopModel.followNum.intValue];
    [_attentendButton setTitle:_shopModel.isFollow.boolValue ? @"已关注" : @"+ 关注" forState:UIControlStateNormal];
}

- (void)searchButtonClick {
    if (self.searchBlock) {
        self.searchBlock();
    }
}

@end


@interface LTSCDianPuAttentionRankView ()

@property (nonatomic, strong) UILabel *titleLabel;

@end
@implementation LTSCDianPuAttentionRankView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = UIColor.whiteColor;
        self.clipsToBounds = YES;
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.bottom.equalTo(self).offset(-10);
        }];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = CharacterDarkColor;
        _titleLabel.text = @"销量排行";
    }
    return _titleLabel;
}

@end

@interface LTSCDianPuAttentionLikeView ()

@property (nonatomic, strong) UIView *leftLine;

@property (nonatomic, strong) UIView *rightLine;

@end
@implementation LTSCDianPuAttentionLikeView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = YES;
        self.contentView.backgroundColor = BGGrayColor;
        [self addSubview:self.leftLine];
        [self addSubview:self.titleLabel];
        [self addSubview:self.rightLine];
        [self.leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.trailing.equalTo(self.titleLabel.mas_leading).offset(-12);
            make.leading.equalTo(self).offset(67);
            make.height.equalTo(@0.5);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
        
        [self.rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.leading.equalTo(self.titleLabel.mas_trailing).offset(12);
            make.trailing.equalTo(self).offset(-67);
            make.height.equalTo(@0.5);
        }];
    }
    return self;
}

- (UIView *)leftLine {
    if (!_leftLine) {
        _leftLine = [UILabel new];
        _leftLine.backgroundColor = [UIColor colorWithRed:192/255.0 green:192/255.0 blue:192/255.0 alpha:1.0];
    }
    return _leftLine;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor colorWithRed:151/255.0 green:151/255.0 blue:151/255.0 alpha:1.0];
    }
    return _titleLabel;
}

- (UIView *)rightLine {
    if (!_rightLine) {
        _rightLine = [UILabel new];
        _rightLine.backgroundColor = [UIColor colorWithRed:192/255.0 green:192/255.0 blue:192/255.0 alpha:1.0];
    }
    return _rightLine;
}

@end

@implementation LTSCDianPuAttentionRankCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        self.layer.cornerRadius = 7;
        self.layer.masksToBounds = YES;
        [self addSubview:self.imgView];
        [self addSubview:self.rankImgView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.numLabel];
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(self);
            make.height.equalTo(@(floor((ScreenW - 44)/3.0)));
        }];
        [self.rankImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imgView.mas_bottom).offset(-14);
            make.centerX.equalTo(self);
            make.width.equalTo(@22);
            make.height.equalTo(@28);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.rankImgView.mas_bottom);
            make.leading.equalTo(self).offset(4.5);
            make.trailing.equalTo(self).offset(-4.5);
        }];
        [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(7);
            make.leading.equalTo(self).offset(4.5);
            make.trailing.equalTo(self).offset(-4.5);
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

- (UIImageView *)rankImgView {
    if (!_rankImgView) {
        _rankImgView = [UIImageView new];
    }
    return _rankImgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textColor = CharacterDarkColor;
        _titleLabel.text = @"宿舍卧室客厅实木家具";
    }
    return _titleLabel;
}

- (UILabel *)numLabel {
    if (!_numLabel) {
        _numLabel = [UILabel new];
        _numLabel.font = [UIFont systemFontOfSize:11];
        _numLabel.textColor = LightGrayColor;
        _numLabel.text = @"11人付款";
    }
    return _numLabel;
}

@end



@interface LTSCDianPuAttentionBaoKuanCell ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *kuaiView;

@property (nonatomic, strong) UIImageView *baokuanImgView;

@end
@implementation LTSCDianPuAttentionBaoKuanCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = UIColor.clearColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.clipsToBounds = YES;
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.imgView1];
//        [self.bgView addSubview:self.kuaiView];
//        [self.bgView addSubview:self.buyButton];
//        [self.bgView addSubview:self.baokuanImgView];
//        [self.bgView addSubview:self.imgView2];
        
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.trailing.equalTo(self).offset(-15);
            make.top.bottom.equalTo(self);
        }];
        [self.imgView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.equalTo(self.bgView).offset(0);
            make.bottom.equalTo(self.bgView).offset(0);
            make.trailing.equalTo(self.bgView).offset(0);
        }];
//        [self.kuaiView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self.bgView).offset(-19);
//            make.trailing.equalTo(self.bgView).offset(-10);
//            make.top.equalTo(self.bgView).offset(85);
//            make.leading.equalTo(self.imgView1.mas_trailing).offset(60);
//        }];
//        [self.imgView2 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.kuaiView).offset(-15);
//            make.leading.equalTo(self.imgView1.mas_trailing).offset(-16);
//            make.bottom.equalTo(self.kuaiView).offset(-10);
//            make.trailing.equalTo(self.kuaiView).offset(-12);
//        }];
//        [self.baokuanImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.buyButton.mas_bottom).offset(10);
//            make.trailing.equalTo(self.bgView).offset(-20);
//            make.width.equalTo(@109.5);
//            make.height.equalTo(@19.5);
//        }];
//        [self.buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.bgView).offset(10);
//            make.trailing.equalTo(self.bgView);
//            make.width.equalTo(@67);
//            make.height.equalTo(@21);
//        }];
    }
    return self;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.layer.cornerRadius = 8;
        _bgView.layer.masksToBounds = YES;
        _bgView.backgroundColor = UIColor.whiteColor;
    }
    return _bgView;
}

- (UIImageView *)imgView1 {
    if (!_imgView1) {
        _imgView1 = [UIImageView new];
        _imgView1.image = [UIImage imageNamed:@"tupian"];
        _imgView1.contentMode =  UIViewContentModeScaleAspectFit;
    }
    return _imgView1;
}

- (UIImageView *)imgView2 {
    if (!_imgView2) {
        _imgView2 = [UIImageView new];
        _imgView2.layer.borderWidth = 0.5;
        _imgView2.layer.borderColor = UIColor.whiteColor.CGColor;
        _imgView2.image = [UIImage imageNamed:@"tupian"];
    }
    return _imgView2;
}

- (UIView *)kuaiView {
    if (!_kuaiView) {
        _kuaiView = [UIView new];
        _kuaiView.backgroundColor = MineColor;
    }
    return _kuaiView;
}

- (UIImageView *)baokuanImgView {
    if (!_baokuanImgView) {
        _baokuanImgView = [UIImageView new];
        _baokuanImgView.image = [UIImage imageNamed:@"baokuantuijian"];
    }
    return _baokuanImgView;
}

- (UILabel *)buyButton {
    if (!_buyButton) {
        _buyButton = [UILabel new];
        _buyButton.textAlignment = NSTextAlignmentCenter;
        _buyButton.backgroundColor = CharacterDarkColor;
        _buyButton.text = @"立即购买";
        _buyButton.textColor = UIColor.whiteColor;
        _buyButton.font = [UIFont systemFontOfSize:12];
    }
    return _buyButton;
}

@end


@interface LTSCDianPuAttentionRankCell ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UICollectionView *collectionView;

@end
@implementation LTSCDianPuAttentionRankCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.clipsToBounds = YES;
        [self addSubview:self.bgView];
        [self addSubview:self.collectionView];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.trailing.equalTo(self).offset(-15);
            make.top.bottom.equalTo(self);
        }];
    }
    return self;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
    }
    return _bgView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 7;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(floor((ScreenW - 44)/3.0),floor((ScreenW - 44)/3.0) + 60);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = UIColor.clearColor;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.scrollEnabled = YES;
        [_collectionView registerClass:LTSCDianPuAttentionRankCollectionCell.class forCellWithReuseIdentifier:@"LTSCDianPuAttentionRankCollectionCell"];
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.salesArr.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LTSCDianPuAttentionRankCollectionCell *itemCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LTSCDianPuAttentionRankCollectionCell" forIndexPath:indexPath];
    itemCell.rankImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"rank%ld",indexPath.item + 1]];
    [itemCell.imgView sd_setImageWithURL:[NSURL URLWithString:self.salesArr[indexPath.item].list_pic] placeholderImage:[UIImage imageNamed:@"789789"]];
    itemCell.titleLabel.text = self.salesArr[indexPath.item].good_name;
   
    itemCell.numLabel.text = [NSString stringWithFormat:@"%ld人付款",self.salesArr[indexPath.item].orderNum];
    return itemCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.didSelectCellClickBlock) {
        self.didSelectCellClickBlock(self.salesArr[indexPath.item]);
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    CAGradientLayer * gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bgView.bounds;
    gradientLayer.colors = @[(__bridge id)UIColor.whiteColor.CGColor,(__bridge id)BGGrayColor.CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    gradientLayer.locations = @[@0,@1];
    [self.bgView.layer addSublayer:gradientLayer];
}

- (void)setSalesArr:(NSArray<LTSCShopSalesModel *> *)salesArr {
    _salesArr = salesArr;
    [self.collectionView reloadData];
}

@end
