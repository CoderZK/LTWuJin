

//
//  LTSCAccountSafeVC.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/21.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LTSCAccountSafeVC.h"
#import "LTSCAccountVerifyVC.h"
#import "LTSCModifyPasswordVC.h"


@interface LTSCAccountSafeVC ()

@end

@implementation LTSCAccountSafeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"账号安全";
    self.tableView.separatorColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    self.tableView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    self.tableView.separatorColor = BGGrayColor;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(1);
        make.leading.trailing.bottom.equalTo(self.view);
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
        imgView.image = [UIImage imageNamed:@"next"];
        cell.accessoryView = imgView;
    }
    cell.textLabel.textColor = CharacterDarkColor;
    cell.textLabel.font = cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
    cell.detailTextLabel.textColor = CharacterGrayColor;
    if (indexPath.row == 0) {
        cell.textLabel.text = @"更改手机号";
    }else {
        cell.textLabel.text = @"修改密码";
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        LTSCAccountVerifyVC *accVC = [[LTSCAccountVerifyVC alloc] init];
        [self.navigationController pushViewController:accVC animated:YES];
    }else {
        LTSCModifyPasswordVC *accVC = [[LTSCModifyPasswordVC alloc] init];
        [self.navigationController pushViewController:accVC animated:YES];
    }
}

@end
