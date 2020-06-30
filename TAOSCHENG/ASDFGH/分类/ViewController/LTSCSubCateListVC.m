//
//  LTSCSubCateListVC.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/20.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LTSCSubCateListVC.h"
#import "LTSCHomeTableSectionHeaderView.h"
#import "LTSCGoodsDetailVC.h"
#import "LTSCDianPuTabBarController.h"

@interface LTSCSubCateListVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic , strong)UICollectionViewFlowLayout * layout;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray <LTSCCateModel *>*goods;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) UILabel *noneLabel;



@end

@implementation LTSCSubCateListVC


- (UILabel *)noneLabel {
    if (!_noneLabel) {
        _noneLabel = [[UILabel alloc] init];
        _noneLabel.text = @"没有更多内容啦~";
        _noneLabel.font = [UIFont systemFontOfSize:12];
        _noneLabel.textColor = CharacterGrayColor;
        _noneLabel.textAlignment = NSTextAlignmentCenter;
//        _noneLabel.hidden = YES;
    }
    return _noneLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BGGrayColor;
    [self initCollectionView];
    
    self.goods = [NSMutableArray array];
    if (self.cateModel) {
        self.page = 1;
        [self loadGoodsList];
    }
    self.collectionView.mj_header = [LTSCRefreshHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [self loadGoodsList];
    }];
    self.collectionView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [self loadGoodsList];
    }];
    WeakObj(self);
    self.noneView.clickBlock = ^{
        selfWeak.page = 1;
        [selfWeak loadGoodsList];
    };
}

- (void)initCollectionView {
    self.layout = [[UICollectionViewFlowLayout alloc] init];
    
    self.layout.minimumInteritemSpacing = 0;
    self.layout.minimumLineSpacing = 15;
    self.layout.footerReferenceSize = CGSizeMake(ScreenW, 40);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
    self.collectionView.contentInset = UIEdgeInsetsMake(10, 15, 10, 15);
    self.collectionView.backgroundColor = BGGrayColor;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;

    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.bottom.equalTo(self.view);
    }];
    
    [self.collectionView registerClass:[LTSCSubCateListDianPuCell class] forCellWithReuseIdentifier:@"LTSCSubCateListDianPuCell"];
    [self.collectionView registerClass:[LTSCHomeBaoKuanCollectionCell class] forCellWithReuseIdentifier:@"LTSCHomeBaoKuanCollectionCell"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableView"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.goods.count;
}
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type.intValue != 5) {
        CGFloat h = ((ScreenW - 45)/2)+ 75;
        return CGSizeMake(floor((ScreenW - 45)/2), h);
    } else {
        return CGSizeMake(ScreenW - 30, 60 + floor((ScreenW - 90)/3.0) + 40);
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type.intValue != 5) {
        LTSCHomeBaoKuanCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LTSCHomeBaoKuanCollectionCell" forIndexPath:indexPath];
        cell.layer.cornerRadius = 6;
        cell.layer.masksToBounds = YES;
        cell.backgroundColor = [UIColor whiteColor];
        cell.dianPuGoodsModel = self.goods[indexPath.item];
        return cell;
    }
    LTSCSubCateListDianPuCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LTSCSubCateListDianPuCell" forIndexPath:indexPath];
    cell.layer.cornerRadius = 6;
    cell.layer.masksToBounds = YES;
    cell.backgroundColor = [UIColor whiteColor];
    cell.model = self.goods[indexPath.item];
    cell.didSelectGoods = ^(LTSCCateModel *model) {
        LTSCGoodsDetailVC *vc = [[LTSCGoodsDetailVC alloc] init];
        vc.goodsID = model.id;
        [self.navigationController pushViewController:vc animated:YES];
    };
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];
    [footerView addSubview:self.noneLabel];
    [self.noneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(footerView);
    }];
    return footerView;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type.intValue != 5) {
        [collectionView deselectItemAtIndexPath:indexPath animated:YES];
        LTSCGoodsDetailVC *vc = [[LTSCGoodsDetailVC alloc] init];
        vc.goodsID = self.goods[indexPath.item].id;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        LTSCDianPuTabBarController *tabVC = [LTSCDianPuTabBarController new];
        tabVC.shopId = self.goods[indexPath.item].shopId;
//        tabVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:tabVC animated:NO completion:nil];
    }
}



#pragma --mark 网络请求和事件处理

- (void)loadGoodsList {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (self.keywords || ![self.keywords isKong]) {
        dict[@"keyword"] = self.keywords;
    }
    if (self.cateModel) {
        if (self.cateModel.id) {
            dict[@"secondTypeId"] = self.cateModel.id;
        }
        dict[@"firstTypeId"] = self.cateModel.pid;
    }
    dict[@"pageNum"] = @(self.page);
    dict[@"pageSize"] = @(10);
    dict[@"type"] = self.type;
    if (self.shopId.length > 0 && ![self.shopId isEqualToString:@"(null)"]) {
        dict[@"shopId"] = self.shopId;
    }
    [LTSCLoadingView show];
    [LTSCNetworking networkingPOST:app_search parameters:dict returnClass:[LTSCCateRootModel class] success:^(NSURLSessionDataTask *task, LTSCCateRootModel *responseObject) {
        [self collectionEndRefresh];
        if (responseObject.key.intValue == 1000) {
            if (self.page == 1) {
                [self.goods removeAllObjects];
            }
            if (self.page <= responseObject.result.allPageNumber.intValue) {
                [self.goods addObjectsFromArray:responseObject.result.list];
            }
            self.noneLabel.hidden = self.goods.count == 0;
            self.page ++;
            [self.collectionView reloadData];
        } else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
        if (self.goods.count == 0) {
            [self.noneView showNoneDataViewAt:self.view img:[UIImage imageNamed:@"emptysearch"] tips:@"暂无数据"];
        } else {
            [self.noneView dismiss];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self collectionEndRefresh];
        if (self.goods.count == 0) {
            [self.noneView showNoneNetViewAt:self.view];
        } else {
            [self.noneView dismiss];
        }
    }];
}

- (void)reloadData:(NSString *)keywords {
    self.keywords = keywords;
    self.page = 1;
    [self loadGoodsList];
}

- (void)reloadData1 {
    self.page = 1;
    [self loadGoodsList];
}

- (void)collectionEndRefresh {
    [LTSCLoadingView dismiss];
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
}

@end


@interface LTSCSubCateListInfoCell ()

@end
@implementation LTSCSubCateListInfoCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        [self addSubview:self.imgView];
        [self addSubview:self.moneyLabel];
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(self);
            make.height.equalTo(self.mas_width);
        }];
        [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imgView.mas_bottom).offset(10);
            make.centerX.equalTo(self);
            make.height.equalTo(@20);
        }];
    }
    return self;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [UIImageView new];
    }
    return _imgView;
}

- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [UILabel new];
        _moneyLabel.font = [UIFont systemFontOfSize:15];
        _moneyLabel.textColor = MineColor;
        _moneyLabel.text = @"¥59";
    }
    return _moneyLabel;
}

@end




@interface LTSCSubCateListDianPuCell ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, strong) UICollectionView *collectionView;

@end
@implementation LTSCSubCateListDianPuCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.topView];
        [self.topView addSubview:self.imgView];
        [self.topView addSubview:self.nameLabel];
        [self.topView addSubview:self.detailLabel];
        [self addSubview:self.collectionView];
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(self);
            make.height.equalTo(@60);
        }];
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.topView).offset(15);
            make.centerY.equalTo(self.topView);
            make.width.height.equalTo(@40);
        }];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.imgView.mas_trailing).offset(10);
            make.bottom.equalTo(self.imgView.mas_centerY).offset(-2);
        }];
        [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.imgView.mas_trailing).offset(10);
            make.top.equalTo(self.imgView.mas_centerY).offset(2);
        }];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topView.mas_bottom);
            make.leading.equalTo(self).offset(15);
            make.trailing.equalTo(self).offset(-15);
            make.bottom.equalTo(self);
        }];
    }
    return self;
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [UIView new];
    }
    return _topView;
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
        _nameLabel.text = @"居家百货生活馆";
    }
    return _nameLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
        _detailLabel.font = [UIFont systemFontOfSize:12];
        _detailLabel.textColor = [UIColor colorWithRed:159/255.0 green:159/255.0 blue:159/255.0 alpha:1.0];
        _detailLabel.text = @"3728人关注 112件在售商品";
    }
    return _detailLabel;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 15;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(floor((ScreenW - 90)/3.0), floor((ScreenW - 90)/3.0) + 40);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[LTSCSubCateListInfoCell class] forCellWithReuseIdentifier:@"LTSCSubCateListInfoCell"];
    }
    return _collectionView;
}

#pragma --mark collectionView的方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.model.goodList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LTSCSubCateListInfoCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LTSCSubCateListInfoCell" forIndexPath:indexPath];
    cell.backgroundColor = UIColor.whiteColor;
    LTSCCateModel *m = self.model.goodList[indexPath.item];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:m.list_pic] placeholderImage:[UIImage imageNamed:@"789789"]];
    cell.moneyLabel.text = [NSString stringWithFormat:@"¥%@", m.normal_price.getPriceStr];
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.didSelectGoods) {
        self.didSelectGoods(self.model.goodList[indexPath.item]);
    }
}

- (void)setModel:(LTSCCateModel *)model {
    _model = model;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.shop_pic] placeholderImage:[UIImage imageNamed:@"789789"]];
    self.nameLabel.text = _model.shop_name;
    self.detailLabel.text = [NSString stringWithFormat:@"%ld人关注 %ld件在售商品", _model.followNum.integerValue, _model.goodNum.integerValue];
    [self.collectionView reloadData];
}

@end
