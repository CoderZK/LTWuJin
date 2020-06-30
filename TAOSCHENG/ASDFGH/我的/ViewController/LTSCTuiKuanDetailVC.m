//
//  LTSCTuiKuanDetailVC.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/6/11.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LTSCTuiKuanDetailVC.h"
#import "LTSCOrderDetailVC.h"

@interface LTSCTuiKuanDetailVC ()

@property (nonatomic, assign) LTSCTuiKuanDetailVC_type type;

@end

@implementation LTSCTuiKuanDetailVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (instancetype)initWithTableViewStyle:(UITableViewStyle)style type:(LTSCTuiKuanDetailVC_type)type {
    self = [super initWithTableViewStyle:style];
    if (self) {
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"退款详情";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if(section == 1) {
        return self.detailModel.subOrders.count;
    } else {
        return 3;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.textColor = UIColor.whiteColor;
            titleLabel.font = [UIFont systemFontOfSize:15];
            titleLabel.tag = 101;
            [cell addSubview:titleLabel];
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(cell);
            }];
        }
        UILabel *titleLabel = (UILabel *)[cell viewWithTag:101];
        titleLabel.text = self.type == LTSCTuiKuanDetailVC_type_doing ? @"您已成功发起退款申请,请耐心等待商家处理" : @"退款成功";
        cell.backgroundColor = MineColor;
        return cell;
    }else if(indexPath.section == 1) {
        LTSCOrderDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LTSCOrderDetailCell"];
        if (!cell) {
            cell = [[LTSCOrderDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LTSCOrderDetailCell"];
        }
        cell.tuikuanModel = self.detailModel.subOrders[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.detailModel.subOrders[indexPath.row];
        return cell;
    } else {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        }
       
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = CharacterGrayColor;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        if (indexPath.row == 0) {
            cell.textLabel.text = [NSString stringWithFormat:@"退款原因: %@",self.detailModel.reason ? self.detailModel.reason : @""];
        } else if (indexPath.row == 1) {
            cell.textLabel.text = [NSString stringWithFormat:@"退款金额: ¥%.2f",self.detailModel.totalMoney.floatValue];
        } else if (indexPath.row == 2) {
            cell.textLabel.text = [NSString stringWithFormat:@"申请时间: %@",self.detailModel.apply_time ? self.detailModel.apply_time : @""];
        }
        return cell;
    }
  
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
        if (!headerView) {
            headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"UITableViewHeaderFooterView"];
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.textColor = CharacterDarkColor;
            titleLabel.font = [UIFont systemFontOfSize:15];
            titleLabel.text = @"退款信息";
            [headerView addSubview:titleLabel];
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(headerView);
                make.leading.equalTo(headerView).offset(15);
            }];
            
            UIView * line = [[UIView alloc] init];
            line.backgroundColor = BGGrayColor;
            line.tag = 111;
            [headerView addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(headerView);
                make.leading.equalTo(headerView).offset(15);
                make.trailing.equalTo(headerView).offset(-15);
                make.height.equalTo(@0.5);
            }];
        }
        headerView.contentView.backgroundColor = [UIColor whiteColor];
        return headerView;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"footerView"];
    if (!footerView) {
        footerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"footerView"];
        UIView * line = [[UIView alloc] init];
        line.backgroundColor = BGGrayColor;
        line.tag = 111;
        [footerView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(footerView);
            make.leading.equalTo(footerView).offset(15);
            make.trailing.equalTo(footerView).offset(-15);
            make.height.equalTo(@0.5);
        }];
    }
    UIView *line = (UIView *)[footerView viewWithTag:111];
    if (section == 0) {
        line.hidden = YES;
        footerView.contentView.backgroundColor = [UIColor clearColor];
    } else if (section == 1) {
        line.hidden = NO;
        footerView.contentView.backgroundColor = [UIColor whiteColor];
    } else {
        line.hidden = YES;
        footerView.contentView.backgroundColor = [UIColor whiteColor];
    }
    return footerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 100;
    } else if (indexPath.section == 1) {
        return 120;
    } else {
        return 40;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 40;
    }
    return 0.01;
}

@end
