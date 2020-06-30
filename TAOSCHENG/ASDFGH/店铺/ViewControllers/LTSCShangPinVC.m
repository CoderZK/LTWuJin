//
//  LTSCShangPinVC.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2020/4/9.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "LTSCShangPinVC.h"
#import "LTSCDianPuTopView.h"
#import "LTSCHomeTableSectionHeaderView.h"
#import "LTSCDianPuCateTopView.h"
#import "LTSCLoginVC.h"
#import "LTSCDianPuSearchVC.h"
#import "LTSCGoodsDetailVC.h"
#import "LTSCSearchVC.h"
#import "LTSCDianPuYinXiangVC.h"


@interface LTSCShangPinVC ()<UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) LTSCDianPuTopView *topView;

@property (nonatomic, strong) LTSCDianPuCateTopView *cateTopView;//选择view

@property (nonatomic , strong)UICollectionViewFlowLayout * layout;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray <LTSCCateModel *>*goods;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) UILabel *noneLabel;

//1.综合（按照时间倒序），2.销量，3.价格从低到高，4.价格从高到低 5.店铺，6.筛选，7.新品
@property (nonatomic, strong) NSNumber *type;

@end

@implementation LTSCShangPinVC

- (LTSCDianPuTopView *)topView {
    if (!_topView) {
        _topView = [LTSCDianPuTopView new];
        [_topView.backButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
        [_topView.dianpuButton addTarget:self action:@selector(dianpuClick:) forControlEvents:UIControlEventTouchUpInside];
        [_topView.attentendButton addTarget:self action:@selector(attentionClick:) forControlEvents:UIControlEventTouchUpInside];
        _topView.searchView.searchTF.delegate = self;
        _topView.searchView.searchTF.userInteractionEnabled = NO;
        WeakObj(self);
        _topView.searchBlock = ^{
            LTSCSearchVC *vc = [[LTSCSearchVC alloc] init];
            vc.isDianPuSearch = YES;
            vc.shopId = selfWeak.shopID;
            BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
            [selfWeak presentViewController:nav animated:NO completion:nil];
        };
    }
    return _topView;
}

- (LTSCDianPuCateTopView *)cateTopView {
    if (!_cateTopView) {
        _cateTopView = [[LTSCDianPuCateTopView alloc] init];
        _cateTopView.backgroundColor = [UIColor whiteColor];
        WeakObj(self);
        _cateTopView.buttonClickBlock = ^(NSInteger index, NSInteger count) {
            if (index == 201) {
                selfWeak.type = @1;
            } else if (index == 202) {
                selfWeak.type = @2;
            } else if (index == 203) {
                selfWeak.type = @7;
            } else {
                if (count == 1) {
                    selfWeak.type = @3;
                } else if (count == 0) {
                    selfWeak.type = @4;
                }
            }
            selfWeak.page = 1;
            [selfWeak loadGoodsList];
           
        };
    }
    return _cateTopView;
}

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tabBarController.tabBar.hidden = NO;
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    [self initCollectionView];
//    self.tabBarController.delegate = self;
    self.type = @1;
    self.goods = [NSMutableArray array];
    self.page = 1;
    [self loadGoodsList];
    WeakObj(self);
    self.collectionView.mj_header = [LTSCRefreshHeader headerWithRefreshingBlock:^{
        selfWeak.page = 1;
        [selfWeak loadGoodsList];
    }];
    self.collectionView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [selfWeak loadGoodsList];
    }];
    
    self.noneView.clickBlock = ^{
        selfWeak.page = 1;
        [selfWeak loadGoodsList];
    };
  
    [LTSCEventBus registerEvent:@"guanzhuAction" block:^(id data) {
       selfWeak.topView.shopModel = selfWeak.shopModel;
    }];
    
    [LTSCEventBus registerEvent:@"dianpuSearchClick" block:^(id data) {
        NSLog(@"%@",data);
        LTSCDianPuSearchVC *vc = [[LTSCDianPuSearchVC alloc] init];
        vc.keyWords = [NSString stringWithFormat:@"%@",data[@"searchWord"]];
        vc.shopId = [NSString stringWithFormat:@"%@",data[@"shopId"]];;
        vc.hidesBottomBarWhenPushed = YES;
        [selfWeak.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)initViews {
    [self.view addSubview:self.topView];
    [self.view addSubview:self.cateTopView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.size.equalTo(@(NavigationSpace + 80));
    }];
    [self.cateTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.leading.trailing.equalTo(self.view);
        make.height.equalTo(@40);
    }];
}

- (void)initCollectionView {
    self.layout = [[UICollectionViewFlowLayout alloc] init];
    
    self.layout.minimumInteritemSpacing = 0;
    self.layout.minimumLineSpacing = 15;
    self.layout.footerReferenceSize = CGSizeMake(ScreenW, 40);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
    self.collectionView.contentInset = UIEdgeInsetsMake(10, 15, 10, 15);
    self.collectionView.backgroundColor = BGGrayColor;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;

    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cateTopView.mas_bottom);
        make.leading.trailing.bottom.equalTo(self.view);
    }];
    
    [self.collectionView registerClass:[LTSCHomeBaoKuanCollectionCell class] forCellWithReuseIdentifier:@"LTSCHomeBaoKuanCollectionCell"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableView"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.goods.count;
}
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat h = ((ScreenW - 45)/2)+ 75;
    return CGSizeMake(floor((ScreenW - 45)/2), h);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LTSCHomeBaoKuanCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LTSCHomeBaoKuanCollectionCell" forIndexPath:indexPath];
    cell.layer.cornerRadius = 6;
    cell.layer.masksToBounds = YES;
    cell.backgroundColor = [UIColor whiteColor];
    cell.dianPuGoodsModel = self.goods[indexPath.item];
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
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    LTSCGoodsDetailVC *vc = [[LTSCGoodsDetailVC alloc] init];
    vc.goodsID = self.goods[indexPath.item].id;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma --mark 网络请求和事件处理

- (void)loadGoodsList {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"pageNum"] = @(self.page);
    dict[@"type"] = self.type;
    if (!self.shopID.isKong && ![self.shopID isEqualToString:@"(null)"]) {
       dict[@"shopId"] = self.shopID;
    }
    dict[@"pageSize"] = @10;
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
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self collectionEndRefresh];
        if (self.goods.count == 0) {
            [self.noneView showNoneNetViewAt:self.view];
        } else {
            [self.noneView dismiss];
        }
    }];
}

//- (void)reloadData:(NSString *)keywords {
//    self.keywords = keywords;
//    self.page = 1;
//    [self loadGoodsList];
//}
//
//- (void)reloadData1 {
//    self.page = 1;
//    [self loadGoodsList];
//}
//
- (void)collectionEndRefresh {
    [LTSCLoadingView dismiss];
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
}


/// 返回
- (void)backClick:(UIButton *)btn {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:NO completion:nil];
}
/// 跳转店铺主页
- (void)dianpuClick:(UIButton *)btn {
    LTSCDianPuYinXiangVC *vc = [LTSCDianPuYinXiangVC new];
    vc.shopId = self.shopID;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
/// 关注店铺
- (void)attentionClick:(UIButton *)btn {
    if (!SESSION_TOKEN) {
        LTSCLoginVC *vc = [[LTSCLoginVC alloc] init];
        vc.isDianpu = YES;
        BaseNavigationController * nav  = [[BaseNavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
        return;
    }
    [LTSCLoadingView show];
    WeakObj(self);
    [LTSCNetworking networkingPOST:followShop parameters:@{@"token" : SESSION_TOKEN, @"shopId" : self.shopID } returnClass:LTSCShopGoodsRootModel.class success:^(NSURLSessionDataTask *task, LTSCShopGoodsRootModel *responseObject) {
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
            selfWeak.topView.shopModel = selfWeak.shopModel;
            [LTSCEventBus sendEvent:@"guanzhuAction" data:nil];
        } else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [LTSCLoadingView dismiss];
    }];
}
//搜索键
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    return YES;
}

- (void)setShopModel:(LTSCShopModel *)shopModel {
    _shopModel = shopModel;
    self.topView.shopModel = _shopModel;
}


@end
