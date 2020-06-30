//
//  LTSCReQiYanXuanVC.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/6/6.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LTSCReQiYanXuanVC.h"
#import "LTSCHomeTableSectionHeaderView.h"
#import "LTSCGoodsDetailVC.h"

@interface LTSCReQiYanXuanVC ()

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray <LTSCChooseListModel *>*chooseList;//人气严选

@end

@implementation LTSCReQiYanXuanVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"人气严选";
    self.chooseList = [NSMutableArray array];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(1);
        make.leading.bottom.trailing.equalTo(self.view);
    }];
    self.page = 1;
    [self loadData];
    self.tableView.mj_header = [LTSCRefreshHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [self loadData];
    }];
    self.tableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        [self loadData];
    }];
}

- (void)loadData {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"type"] = @1;
    if (SESSION_TOKEN) {
        dict[@"token"] = SESSION_TOKEN;
    }
    dict[@"pageNum"] = @(self.page);
    [LTSCLoadingView show];
    [LTSCNetworking networkingPOST:reco_good_list parameters:dict returnClass:[LTSCHomeReQiYanXuanRootModel class] success:^(NSURLSessionDataTask *task, LTSCHomeReQiYanXuanRootModel *responseObject) {
        [self endRefrish];
        if (responseObject.key.intValue == 1000) {
            if (self.page == 1) {
                [self.chooseList removeAllObjects];
            }else {
                if (responseObject.result.list.count == 0) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            if (responseObject.result.count.integerValue > self.chooseList.count) {
                [self.chooseList addObjectsFromArray:responseObject.result.list];
            }
            self.page ++;
            [self.tableView reloadData];
        }else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self endRefrish];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chooseList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LTSCHomeReQiCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LTSCHomeReQiCell"];
    if (!cell) {
        cell = [[LTSCHomeReQiCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LTSCHomeReQiCell"];
    }
    cell.chooseModel = self.chooseList[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 145;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LTSCGoodsDetailVC *vc = [[LTSCGoodsDetailVC alloc] init];
    vc.goodsID = self.chooseList[indexPath.row].id;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
