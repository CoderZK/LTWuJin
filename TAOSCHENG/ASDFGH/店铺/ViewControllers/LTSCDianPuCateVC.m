//
//  LTSCDianPuCateVC.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2020/4/9.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "LTSCDianPuCateVC.h"
#import "LTSCDianPuTopView.h"
#import "LTSCHomeTableSectionHeaderView.h"
#import "LTSCCateLeftTableCell.h"
#import "LTSCLoginVC.h"
#import "LTSCCateListVC.h"
#import "LTSCDianPuSearchVC.h"
#import "LTSCSearchVC.h"
#import "LTSCDianPuYinXiangVC.h"

@interface LTSCDianPuCateVC ()<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UITableView *tableView1;

@property (nonatomic , strong)UICollectionViewFlowLayout * layout;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) LTSCDianPuTopView *topView;

@property (nonatomic, assign) NSInteger currectIndex;

@property (nonatomic, strong) LTSCDianPuFirstCataModel *firstModel;

@property (nonatomic, strong) LTSCDianPuCataRootModel *rootModel;

@end

@implementation LTSCDianPuCateVC

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
            //            nav.modalPresentationStyle = UIModalPresentationFullScreen;
            [selfWeak presentViewController:nav animated:NO completion:nil];
        };
    }
    return _topView;
}

- (UITableView *)tableView1 {
    if (!_tableView1) {
        _tableView1 = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView1.delegate = self;
        _tableView1.dataSource = self;
        _tableView1.showsVerticalScrollIndicator = NO;
    }
    return _tableView1;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(101, 1, ScreenW - 101, self.view.bounds.size.height) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.contentInset = UIEdgeInsetsMake(15, 0, 15, 0);
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        [_collectionView registerClass:[LTSCCateRightCollectionCell class] forCellWithReuseIdentifier:@"LTSCCateRightCollectionCell"];
    }
    return _collectionView;
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
    //获取店铺分类数据
    [self loadDianPuCateData];
    WeakObj(self);
    [LTSCEventBus registerEvent:@"dianpuSearchClick" block:^(id data) {
        LTSCDianPuSearchVC *vc = [[LTSCDianPuSearchVC alloc] init];
        vc.keyWords = [NSString stringWithFormat:@"%@",data[@"searchWord"]];
        vc.shopId = [NSString stringWithFormat:@"%@",data[@"shopId"]];;
        vc.hidesBottomBarWhenPushed = YES;
        [selfWeak.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)initViews {
    [self.view addSubview:self.topView];
    [self.view addSubview:self.tableView1];
    [self.view addSubview:self.collectionView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.size.equalTo(@(NavigationSpace + 80));
    }];
    [self.tableView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom).offset(1);
        make.leading.bottom.equalTo(self.view);
        make.width.equalTo(@100);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom).offset(1);
        make.trailing.bottom.equalTo(self.view);
        make.width.equalTo(@(ScreenW - 101));
    }];
}

#pragma --mark tableView的方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.rootModel.result.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LTSCCateLeftTableCell *cell=[tableView dequeueReusableCellWithIdentifier:@"LTSCCateLeftTableCell"];
    if (!cell) {
        cell = [[LTSCCateLeftTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LTSCCateLeftTableCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.yellowLineView.backgroundColor = indexPath.row == self.currectIndex ? MineColor : UIColor.whiteColor;
    cell.titleLabel.textColor = indexPath.row == self.currectIndex ? MineColor : CharacterDarkColor;
    cell.titleLabel.text = self.rootModel.result.list[indexPath.row].type_name;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.currectIndex = indexPath.row;
    self.firstModel = self.rootModel.result.list[indexPath.row];
    [tableView reloadData];
    [self.collectionView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

#pragma --mark collectionView的方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.firstModel.secondType.count;
}
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat h = floor((ScreenW - 101)/3);
    return CGSizeMake(h, h + 30);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LTSCCateRightCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LTSCCateRightCollectionCell" forIndexPath:indexPath];
    cell.dianpuModel = self.firstModel.secondType[indexPath.item];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    
    LTSCCateModel *m = [LTSCCateModel new];
    m.typeName = self.firstModel.type_name;
    m.pid = self.firstModel.id;
    m.id = self.firstModel.secondType[indexPath.item].id;
    
    NSMutableArray <LTSCCateModel *> *tempArr = [NSMutableArray array];
    for (LTSCDianPuCataModel *dianpuM in self.firstModel.secondType) {
        LTSCCateModel *cateM = [LTSCCateModel new];
        cateM.id = dianpuM.id;
        cateM.pid = self.firstModel.id;
        cateM.typeName = dianpuM.type_name;
        [tempArr addObject:cateM];
    }
    
    LTSCCateListVC *vc = [[LTSCCateListVC alloc] init];
    vc.titleStr = self.firstModel.type_name;
    vc.cateModel = m;
    vc.secondCateArr = tempArr;
    vc.currentIndex = indexPath.item + 1;
    vc.hidesBottomBarWhenPushed = YES;
    vc.isNOAll = YES;
    vc.shopId = self.shopID;
    [self.navigationController pushViewController:vc animated:YES];
}

/// 店铺分类
- (void)loadDianPuCateData {
    if (!self.rootModel) {
        [LTSCLoadingView show];
    }
    WeakObj(self);
    [LTSCNetworking networkingPOST:shopGoodTypeList parameters:@{@"shopId":self.shopID} returnClass:LTSCDianPuCataRootModel.class success:^(NSURLSessionDataTask *task, LTSCDianPuCataRootModel *responseObject) {
        [LTSCLoadingView dismiss];
        if (responseObject.key.intValue == 1000) {
            selfWeak.rootModel = responseObject;
            if (selfWeak.rootModel.result.list.count >= 1) {
                selfWeak.firstModel = selfWeak.rootModel.result.list[0];
            }
            [selfWeak.tableView1 reloadData];
            [selfWeak.collectionView reloadData];
        } else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [LTSCLoadingView dismiss];
    }];
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
    [self.tableView1 reloadData];
}


@end
