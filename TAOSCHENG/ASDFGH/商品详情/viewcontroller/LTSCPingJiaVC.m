//
//  LTSCPingJiaVC.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2020/4/8.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "LTSCPingJiaVC.h"
#import "LTSCGoodsDetailCell.h"

@interface LTSCPingJiaVC ()

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray <LTSCGoodsDetailEvalModel *> *dataArr;

@property (nonatomic, assign) NSInteger allPageNum;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, assign) NSInteger paiXuIndex;

@property (nonatomic, strong) LTSCPingJiaMapModel *mapModel;

@end

@implementation LTSCPingJiaVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
   [super viewWillDisappear:animated];
   [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"评价";
    self.tableView.separatorColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0.5);
        make.leading.trailing.bottom.equalTo(self.view);
    }];
    self.index = 111;
    self.paiXuIndex = 10;
    
    self.dataArr = [NSMutableArray array];
    self.allPageNum = 1;
    self.page = 1;
    [self loadData];
    WeakObj(self);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
      selfWeak.page = 1;
      selfWeak.allPageNum = 1;
      [self loadData];
    }];

    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
      [selfWeak loadData];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        LTSCPingJiaSellectCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LTSCPingJiaSellectCell"];
        if (!cell) {
            cell = [[LTSCPingJiaSellectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LTSCPingJiaSellectCell"];
        }
        cell.model = self.mapModel;
        WeakObj(self);
        cell.didSelectBlock = ^(NSInteger index) {
            selfWeak.index = index;
            selfWeak.page = 1;
            selfWeak.allPageNum = 1;
            [selfWeak loadData];
        };
        return cell;
    }
    LTSCPingJiaCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LTSCPingJiaCell"];
    if (!cell) {
        cell = [[LTSCPingJiaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LTSCPingJiaCell"];
    }
    cell.evalModel1 = self.dataArr[indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    LTSCPingJiaHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"LTSCPingJiaHeaderView"];
    if (!headerView) {
        headerView = [[LTSCPingJiaHeaderView alloc] initWithReuseIdentifier:@"LTSCPingJiaHeaderView"];
    }
    WeakObj(self);
    headerView.moreLabel.text = selfWeak.paiXuIndex == 11 ? @"按时间排序" : @"默认排序";
    headerView.didSelectBlock = ^(NSInteger index) {
        selfWeak.paiXuIndex = index;
        selfWeak.page = 1;
        selfWeak.allPageNum = 1;
        [selfWeak loadData];
    };
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 50;
    }
    return self.dataArr[indexPath.row].cellHeight1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 40;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 15;
}

/**
 请求数据
 */
- (void)loadData {
    if (self.page <= self.allPageNum) {
        if (self.dataArr.count <= 0) {
            [LTSCLoadingView show];
        }
        WeakObj(self);
        [LTSCNetworking networkingPOST:evalList parameters:@{@"pageNum" : @(self.page),@"pageSize" : @10, @"goodId" : self.goodId, @"isPicType" : (self.index == 111 ? @1 : @2), @"isDateType":(self.paiXuIndex == 10 ? @1 : @2)} returnClass:LTSCPingJiaRootModel.class success:^(NSURLSessionDataTask *task, LTSCPingJiaRootModel *responseObject) {
            [self endRefrish];
            if (responseObject.key.intValue == 1000) {
                selfWeak.mapModel = responseObject.result.map;
                selfWeak.allPageNum = responseObject.result.allPageNumber.intValue;
                if (selfWeak.page == 1) {
                    [selfWeak.dataArr removeAllObjects];
                }
                if (selfWeak.page <= responseObject.result.allPageNumber.intValue) {
                    [selfWeak.dataArr addObjectsFromArray:responseObject.result.list];
                }
                selfWeak.page ++;
                [selfWeak.tableView reloadData];
            } else {
                [UIAlertController showAlertWithmessage:responseObject.message];
            }
            if (selfWeak.dataArr.count <= 0) {
                [selfWeak.noneView showNoneDataViewAt:self.view img:[UIImage imageNamed:@"emptyorder"] tips:[NSString stringWithFormat:@"暂无%@", self.index == 111 ? @"评价" : @"有图评价"]];
            } else {
                [selfWeak.noneView dismiss];
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [self endRefrish];
        }];
    }
}


@end
