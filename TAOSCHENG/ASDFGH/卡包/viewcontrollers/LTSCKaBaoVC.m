//
//  LTSCKaBaoVC.m
//  回收
//
//  Created by 李晓满 on 2020/3/11.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "LTSCKaBaoVC.h"
#import "LTSCKaBaoView.h"
#import "LTSCCardDetailVC.h"
#import "LTSCYiKaiKaDetailVC.h"

@interface LTSCKaBaoVC ()

@end

@implementation LTSCKaBaoVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"卡包";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(1);
        make.leading.trailing.bottom.equalTo(self.view);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        LTSCKaBaoEmptyCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LTSCKaBaoEmptyCell"];
        if (!cell) {
            cell = [[LTSCKaBaoEmptyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LTSCKaBaoEmptyCell"];
        }
        return cell;
    } else {
        LTSCKaBaoCardCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LTSCKaBaoCardCell"];
        if (!cell) {
            cell = [[LTSCKaBaoCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LTSCKaBaoCardCell"];
        }
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    LTSCKaBaoHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"LTSCKaBaoHeaderView"];
    if (!headerView) {
        headerView = [[LTSCKaBaoHeaderView alloc] initWithReuseIdentifier:@"LTSCKaBaoHeaderView"];
    }
    headerView.titleLabel.text = section == 0 ? @"我的交通卡" : @"更多公交卡";
    headerView.moreLabel.hidden = section == 0;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 200;
    }
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
    } else {
        LTSCYiKaiKaDetailVC *vc = [[LTSCYiKaiKaDetailVC alloc] initWithTableViewStyle:UITableViewStyleGrouped];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
