//
//  LTSCBaoKuanTuiJianVC.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/6/6.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LTSCBaoKuanTuiJianVC.h"
#import "LTSCHomeTableSectionHeaderView.h"
#import "LTSCGoodsDetailVC.h"

@interface LTSCBaoKuanTuiJianVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic , strong)UICollectionViewFlowLayout * layout;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray <LTSCChooseListModel *>*hotList;//爆款

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) UILabel *noneLabel;

@end

@implementation LTSCBaoKuanTuiJianVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (UILabel *)noneLabel {
    if (!_noneLabel) {
        _noneLabel = [[UILabel alloc] init];
        _noneLabel.text = @"没有更多内容啦~";
        _noneLabel.font = [UIFont systemFontOfSize:12];
        _noneLabel.textColor = CharacterGrayColor;
        _noneLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _noneLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"爆款推荐";
    [self initCollectionView];
    self.hotList = [NSMutableArray array];
    self.collectionView.mj_header = [LTSCRefreshHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [self loadList];
    }];
    self.collectionView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [self loadList];
    }];
    self.page = 1;
    [self loadList];
}

- (void)initCollectionView {
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    self.layout = [[UICollectionViewFlowLayout alloc] init];
    self.layout.minimumInteritemSpacing = 0;
    self.layout.minimumLineSpacing = 15;
    self.layout.sectionInset = UIEdgeInsetsMake(15, 15, 0, 15);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
    self.layout.footerReferenceSize = CGSizeMake(ScreenW, 40);
    self.collectionView.backgroundColor = BGGrayColor;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[LTSCHomeBaoKuanCollectionCell class] forCellWithReuseIdentifier:@"LTSCHomeBaoKuanCollectionCell"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableView"];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(1);
        make.leading.bottom.trailing.equalTo(self.view);
    }];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];
    [footerView addSubview:self.noneLabel];
    [self.noneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(footerView);
    }];
    return footerView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.hotList.count;
}
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat h = ((ScreenW - 45)/2)+ 75;
    return CGSizeMake(floor((ScreenW - 45)/2), h);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LTSCHomeBaoKuanCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LTSCHomeBaoKuanCollectionCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.chooseModel = self.hotList[indexPath.row];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LTSCGoodsDetailVC *vc = [[LTSCGoodsDetailVC alloc] init];
    vc.goodsID = self.hotList[indexPath.item].id;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loadList {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"type"] = @2;
    if (SESSION_TOKEN) {
        dict[@"token"] = SESSION_TOKEN;
    }
    dict[@"pageNum"] = @(self.page);
    [LTSCLoadingView show];
    [LTSCNetworking networkingPOST:reco_good_list parameters:dict returnClass:[LTSCHomeReQiYanXuanRootModel class] success:^(NSURLSessionDataTask *task, LTSCHomeReQiYanXuanRootModel *responseObject) {
        [self collectionEndRefresh];
        if (responseObject.key.intValue == 1000) {
            if (self.page == 1) {
                [self.hotList removeAllObjects];
            }
            if (responseObject.result.count.integerValue > self.hotList.count) {
                [self.hotList addObjectsFromArray:responseObject.result.list];
            }
            self.page ++;
            [self.collectionView reloadData];
        }else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self collectionEndRefresh];
    }];
}

- (void)collectionEndRefresh {
    [LTSCLoadingView dismiss];
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
}

@end
