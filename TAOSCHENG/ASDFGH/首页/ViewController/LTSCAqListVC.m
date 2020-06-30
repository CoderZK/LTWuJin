//
//  LTSCAqListVC.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/6/6.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LTSCAqListVC.h"
#import "LTSCHomeTableSectionHeaderView.h"

@interface LTSCAqListVC ()

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray <LTSCHomeQuestionModel *>*questionArr;//问答模块数据model;

@end

@implementation LTSCAqListVC

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
    self.navigationItem.title = @"常见问题自助区";
    self.questionArr = [NSMutableArray array];
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
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
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
    [LTSCNetworking networkingPOST:qa_list parameters:dict returnClass:[LTSCHomeAQListRootModel class] success:^(NSURLSessionDataTask *task, LTSCHomeAQListRootModel *responseObject) {
        [self endRefrish];
        if (responseObject.key.intValue == 1000) {
            if (self.page == 1) {
                [self.questionArr removeAllObjects];
            }
            if (responseObject.result.count.integerValue > self.questionArr.count) {
                [self.questionArr addObjectsFromArray:responseObject.result.list];
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
    return self.questionArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LTSCHomeQuestionCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LTSCHomeQuestionCell"];
    if (!cell) {
        cell = [[LTSCHomeQuestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LTSCHomeQuestionCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.index = indexPath.row + 1;
    LTSCHomeQuestionModel *model = self.questionArr[indexPath.row];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LTSCHomeQuestionModel *model = self.questionArr[indexPath.row];
    return model.cellheight;
}

@end
