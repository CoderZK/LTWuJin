//
//  LTSCDianPuSearchVC.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2020/4/14.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "LTSCDianPuSearchVC.h"
#import "LTSCHomeTableSectionHeaderView.h"
#import "LTSCDianPuCateTopView.h"
#import "LTSCLoginVC.h"
#import "LTSCSearchVC.h"
#import "LTSCTitleView.h"

@interface LTSCDianPuSearchVC ()<UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) LTSCTitleView *titleView;

@property (nonatomic, strong) LTSCDianPuCateTopView *cateTopView;//选择view

@property (nonatomic , strong)UICollectionViewFlowLayout * layout;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray <LTSCCateModel *>*goods;

@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) NSInteger allPageNum;

@property (nonatomic, strong) UILabel *noneLabel;

//1.综合（按照时间倒序），2.销量，3.价格从低到高，4.价格从高到低 5.店铺，6.筛选，7.新品
@property (nonatomic, strong) NSNumber *type;

@end

@implementation LTSCDianPuSearchVC


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [_titleView.searchView.searchTF endEditing:YES];
}

- (LTSCTitleView *)titleView {
    if (!_titleView) {
        _titleView = [[LTSCTitleView alloc] initWithFrame:CGRectMake(0, 0, ScreenW - 30, 30)];
        _titleView.searchView.bgButton.backgroundColor = [UIColor whiteColor];
        _titleView.searchView.bgButton.backgroundColor = BGGrayColor;
        [_titleView.searchView sendSubviewToBack:_titleView.searchView.bgButton];
        _titleView.searchView.searchTF.userInteractionEnabled = YES;
        _titleView.searchView.searchTF.text = self.keyWords;
        _titleView.searchView.searchTF.delegate = self;
    }
    return _titleView;
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
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    [self initCollectionView];
    
    self.type = @1;
    self.goods = [NSMutableArray array];
    self.page = 1;
    self.allPageNum = 1;
    [self loadGoodsList];
    WeakObj(self);
    self.collectionView.mj_header = [LTSCRefreshHeader headerWithRefreshingBlock:^{
        selfWeak.page = 1;
        selfWeak.allPageNum = 1;
        [selfWeak loadGoodsList];
    }];
    self.collectionView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [selfWeak loadGoodsList];
    }];
    
    self.navigationItem.titleView = self.titleView;
    self.titleView.searchView.searchTF.text = self.keyWords;
    
}

- (void)initNav {
    self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [self.rightButton setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
    [self.rightButton setImage:[UIImage imageNamed:@"search_icon"] forState:UIControlStateNormal];
    self.rightButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.rightButton addTarget:self action:@selector(searchClick:) forControlEvents:UIControlEventTouchUpInside];
    self.rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    self.navigationItem.rightBarButtonItem = item;
}

/**
 搜索
 */
- (void)searchClick:(UIButton *)btn {
    btn.selected = !btn.selected;
    self.navigationItem.titleView = self.titleView;
    [self.rightButton setImage:[UIImage imageNamed:@" "] forState:UIControlStateNormal];
    [self.rightButton setTitle:@"取消" forState:UIControlStateNormal];
    
    LTSCSearchVC *vc = [[LTSCSearchVC alloc] init];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:NO completion:nil];
}

- (void)initViews {
    [self.view addSubview:self.cateTopView];
    [self.cateTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
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
//    LTSCGoodsDetailVC *vc = [[LTSCGoodsDetailVC alloc] init];
//    vc.goodsID = self.goods[indexPath.item].id;
//    [self.navigationController pushViewController:vc animated:YES];
}



#pragma --mark 网络请求和事件处理

- (void)loadGoodsList {
    if (self.page <= self.allPageNum) {
        if (self.goods.count <= 0) {
            [LTSCLoadingView show];
        }
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"pageNum"] = @(self.page);
        dict[@"type"] = self.type;
        if (!self.shopId.isKong && ![self.shopId isEqualToString:@"(null)"]) {
           dict[@"shopId"] = self.shopId;
        }
        dict[@"keyword"] = self.keyWords;
        dict[@"pageSize"] = @10;
        
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
}

- (void)collectionEndRefresh {
    [LTSCLoadingView dismiss];
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    if (textField.text.length == 0 || [textField.text isKong]) {
        [LTSCToastView showInFullWithStatus:@"请输入要搜索的关键字"];
        return NO;
    }
    self.keyWords = textField.text;
    self.page = 1;
    [self loadGoodsList];
    return YES;
    
}


@end
