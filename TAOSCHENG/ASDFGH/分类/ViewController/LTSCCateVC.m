//
//  LTSCCateVC.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/15.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LTSCCateVC.h"
#import "LTSCHomeVC.h"
#import "LTSCCateLeftTableCell.h"
#import "LTSCTitleView.h"
#import "LTSCSearchVC.h"
#import "LTSCCateListVC.h"
#import "LTSCCateModel.h"

@interface LTSCCateVC ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UITableView *tableView1;

@property (nonatomic, strong) LTSCTitleView *titleView;

@property (nonatomic, strong) NSArray <LTSCCateModel *>*tableViewTitleArr;

@property (nonatomic, strong) NSMutableArray <LTSCCateModel *>*secondDataArr;

@property (nonatomic, assign) NSInteger currectIndex;

@property (nonatomic , strong)UICollectionViewFlowLayout * layout;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSString *firstStr;//一级分类名称

@end

@implementation LTSCCateVC

- (LTSCTitleView *)titleView {
    if (!_titleView) {
        _titleView = [[LTSCTitleView alloc] initWithFrame:CGRectMake(0, 0, ScreenW - 30, 30)];
        _titleView.searchView.bgButton.backgroundColor = BGGrayColor;
    
    }
    return _titleView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    self.secondDataArr = [NSMutableArray array];
    self.navigationItem.titleView = self.titleView;
    [self.tableView removeFromSuperview];
    [self initTableView];
    [self initCollectionView];
    WeakObj(self);
    self.titleView.searchBlock = ^{
        LTSCSearchVC *vc = [[LTSCSearchVC alloc] init];
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
        [selfWeak presentViewController:nav animated:NO completion:nil];
    };
    [self loadTypeList];
    
    [LTSCEventBus registerEvent:@"searchClick" block:^(id data) {
        NSLog(@"%@",data);
        LTSCCateListVC *vc = [[LTSCCateListVC alloc] init];
        vc.isSearch = YES;
        vc.keyWords = [NSString stringWithFormat:@"%@",data[@"searchWord"]];
        vc.hidesBottomBarWhenPushed = YES;
        [selfWeak.navigationController pushViewController:vc animated:YES];
    }];
    [LTSCEventBus registerEvent:@"backHomeVC" block:^(id data) {
        selfWeak.tabBarController.selectedIndex = 0;
    }];
    self.noneView.clickBlock = ^{
        [selfWeak loadTypeList];
    };
    
}

- (void)initTableView {
    self.tableView1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 1, 100, self.view.bounds.size.height - 1) style:UITableViewStylePlain];
    self.tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView1.delegate = self;
    self.tableView1.dataSource = self;
    self.tableView1.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView1];
//    [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    [self.tableView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(1);
        make.leading.bottom.equalTo(self.view);
        make.width.equalTo(@100);
    }];
}

- (void)initCollectionView {
    self.layout = [[UICollectionViewFlowLayout alloc] init];
    self.layout.minimumInteritemSpacing = 0;
    self.layout.minimumLineSpacing = 0;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(101, 1, ScreenW - 101, self.view.bounds.size.height) collectionViewLayout:self.layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.contentInset = UIEdgeInsetsMake(15, 0, 15, 0);
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(1);
        make.trailing.bottom.equalTo(self.view);
        make.width.equalTo(@(ScreenW - 101));
    }];
    
    [self.collectionView registerClass:[LTSCCateRightCollectionCell class] forCellWithReuseIdentifier:@"LTSCCateRightCollectionCell"];
}


#pragma --mark tableView的方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableViewTitleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LTSCCateLeftTableCell *cell=[tableView dequeueReusableCellWithIdentifier:@"LTSCCateLeftTableCell"];
    if (!cell) {
        cell = [[LTSCCateLeftTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LTSCCateLeftTableCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.yellowLineView.backgroundColor = indexPath.row == self.currectIndex ? MineColor : UIColor.whiteColor;
    cell.titleLabel.textColor = indexPath.row == self.currectIndex ? MineColor : CharacterDarkColor;
    LTSCCateModel *model = self.tableViewTitleArr[indexPath.row];
    cell.titleLabel.text = model.typeName;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.currectIndex = indexPath.row;
    NSLog(@"%ld",indexPath.row);
    LTSCCateModel *model = self.tableViewTitleArr[indexPath.row];
    [self loadSecondList:model];
    [tableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

#pragma --mark collectionView的方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.secondDataArr.count;
}
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat h = floor((ScreenW - 101)/3);
    return CGSizeMake(h, h + 30);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LTSCCateRightCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LTSCCateRightCollectionCell" forIndexPath:indexPath];
    LTSCCateModel *model = self.secondDataArr[indexPath.item];
    cell.model = model;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    LTSCCateModel *model = self.secondDataArr[indexPath.item];
    LTSCCateListVC *vc = [[LTSCCateListVC alloc] init];
    vc.titleStr = self.firstStr;
    vc.cateModel = model;
    vc.secondCateArr = self.secondDataArr;
    vc.currentIndex = indexPath.item+1;
    vc.hidesBottomBarWhenPushed = YES;
    vc.isNOAll = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma --mark 事件处理和网络请求
/**
 获取商品类别
 */
- (void)loadTypeList {
    [LTSCNetworking networkingPOST:good_first_type_list parameters:nil returnClass:[LTSCCateRootModel class] success:^(NSURLSessionDataTask *task, LTSCCateRootModel *responseObject) {
        if (responseObject.key.integerValue == 1000) {
            self.tableViewTitleArr = responseObject.result.list;
            [self.tableView1 reloadData];
            if (self.tableViewTitleArr.count >= 1) {
                [self loadSecondList:self.tableViewTitleArr[0]];
            }
        }else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
        if (self.tableViewTitleArr.count <= 0) {
            [self.noneView showNoneDataViewAt:self.view img:[UIImage imageNamed:@"emptysearch"] tips:@"暂无数据"];
        } else {
            [self.noneView dismiss];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (self.tableViewTitleArr.count <= 0) {
            [self.noneView showNoneNetViewAt:self.view];
        } else {
            [self.noneView dismiss];
        }
    }];
}

/**
 获取商品二级列表
 */
- (void)loadSecondList:(LTSCCateModel *)model {
    [LTSCLoadingView show];
    [LTSCNetworking networkingPOST:good_second_type_list parameters:@{@"id":model.id} returnClass:[LTSCCateRootModel class] success:^(NSURLSessionDataTask *task, LTSCCateRootModel *responseObject) {
        [LTSCLoadingView dismiss];
        if (responseObject.key.integerValue == 1000) {
            [self.secondDataArr removeAllObjects];
            self.firstStr = responseObject.result.data;
            [self.secondDataArr addObjectsFromArray:responseObject.result.list];
            [self.collectionView reloadData];
        }else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [LTSCLoadingView dismiss];
    }];
}


@end
