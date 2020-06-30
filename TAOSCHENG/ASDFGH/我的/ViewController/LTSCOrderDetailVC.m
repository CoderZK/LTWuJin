//
//  LTSCOrderDetailVC.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/21.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LTSCOrderDetailVC.h"
#import "LTSCAddressCell.h"
#import "LTSCMyOrderHeaderFooterView.h"
#import "LTSCTuiKuanVC.h"
#import "LTSCCateModel.h"
#import "LTSCGoodsDetailVC.h"
#import "LTSCSelectPayTypeVC.h"
#import "LTSCTuiKuanDetailVC.h"
#import "LTSCCommentOrderVC.h"
#import "LTSCMyOrderDetailWuLiuCell.h"
#import "LTSCWuLiuInfoVC.h"
@interface LTSCOrderDetailVC ()

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UIButton *leftButton;//返回按钮

@property (nonatomic, strong) UILabel *titleLabel;//标题

@property (nonatomic, strong) LTSCOrderDetailBottomView *bottomView;//底部View

@property (nonatomic, strong) LTSCOrderListDetailModel *detailModel;

@property (nonatomic, strong) NSArray <LTSCWuLiuInfoStateModel *>*dataArr;

@property (nonatomic, strong) NSString *status;

@property (nonatomic, strong) LTSCWuLiuInfoMapModel *mapData;

@end

@implementation LTSCOrderDetailVC

- (UIView *)topView {
    if (!_topView) {
        _topView = [UIView new];
        _topView.backgroundColor = MineColor;
    }
    return _topView;
}

- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [UIButton new];
        [_leftButton setImage:[UIImage imageNamed:@"nav_white_back"] forState:UIControlStateNormal];
        _leftButton.imageEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 40);
        [_leftButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.textColor = UIColor.whiteColor;
        _titleLabel.text = @"订单详情";
    }
    return _titleLabel;
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.navigationController.navigationBar setBarTintColor:MineColor];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setBarTintColor:UIColor.whiteColor];
    
  
    
}



- (LTSCOrderDetailBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[LTSCOrderDetailBottomView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"订单详情";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.noneView.clickBlock = ^{
        [self loadOrderDetail];
    };
    [self loadOrderDetail];
    [LTSCEventBus registerEvent:@"tuikuanSuccess" block:^(id data) {
        self.detailModel = nil;
        [self loadOrderDetail];
    }];
    
    [self loadWuLiuInfo];
    self.tableView.estimatedRowHeight = 44;
    
}


/**
 初始化底部view
 */
- (void)initBottomView {
    [self.view addSubview:self.topView];
    [self.topView addSubview:self.leftButton];
    [self.topView addSubview:self.titleLabel];
    [self.view addSubview:self.bottomView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.height.equalTo(@(NavigationSpace));
    }];
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView).offset(NavigationSpace - 39);
        make.leading.equalTo(self.topView).offset(15);
        make.width.equalTo(@49);
        make.height.equalTo(@37);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.topView);
        make.centerY.equalTo(self.leftButton);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.equalTo(self.view);
        if (kDevice_Is_iPhoneX) {
            make.height.equalTo(@(50 + TableViewBottomSpace));
        } else {
            make.height.equalTo(@50);
        }
    }];
    WeakObj(self);
    self.bottomView.bottomActionBlock = ^(NSInteger index) {//左209 中 210 右211
        [selfWeak bottomAction:index];
    };
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.detailModel == nil) {
        return 0;
    }
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }else if (section == 1) {
        return self.detailModel.subOrders.count;
    }else {
        return 8;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if ((self.detailModel.status.intValue == 3 || self.detailModel.status.intValue == 4 || self.detailModel.status.intValue == 7) && self.dataArr.count > 0) {
                LTSCMyOrderDetailWuLiuCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LTSCMyOrderDetailWuLiuCell"];
                if (!cell) {
                    cell = [[LTSCMyOrderDetailWuLiuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LTSCMyOrderDetailWuLiuCell"];
                }
                if (self.dataArr.count >= 1) {
                    cell.model = self.dataArr.lastObject;
                }
                if (self.detailModel.status.intValue == 3) {
                    cell.stateLabel.text = @"已发货";
                }else if (self.detailModel.status.intValue == 4) {
                    cell.stateLabel.text = @"已收货";
                }
                return cell;
            }else {
                LTSCOrderStateCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LTSCOrderStateCell"];
                if (!cell) {
                    cell = [[LTSCOrderStateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LTSCOrderStateCell"];
                }
                cell.model = self.detailModel;
                return cell;
            }
            
        }
        LTSCOrderDetailAddressCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LTSCOrderDetailAddressCell"];
        if (!cell) {
            cell = [[LTSCOrderDetailAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LTSCOrderDetailAddressCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailModel = self.detailModel;
        return cell;
    }else if (indexPath.section == 1) {
        LTSCOrderDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LTSCOrderDetailCell"];
        if (!cell) {
            cell = [[LTSCOrderDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LTSCOrderDetailCell"];
        }
        cell.tuikuanBlock = ^(LTSCOrderListDetailModel *detailModel, LTSCOrderDetailModel *goodsModel) {
            if (detailModel.status.intValue == 2 || detailModel.status.intValue == 3) {//待发货
                if (goodsModel.status.intValue == 4) {//申请退款中
                    LTSCTuiKuanDetailVC *vc = [[LTSCTuiKuanDetailVC alloc] initWithTableViewStyle:UITableViewStyleGrouped type:LTSCTuiKuanDetailVC_type_doing];
                    vc.detailModel = detailModel;
                    [self.navigationController pushViewController:vc animated:YES];
                } else if (goodsModel.status.intValue == 5) {//退款成功
                    LTSCTuiKuanDetailVC *vc = [[LTSCTuiKuanDetailVC alloc] initWithTableViewStyle:UITableViewStyleGrouped type:LTSCTuiKuanDetailVC_type_success];
                    vc.detailModel = detailModel;
                    [self.navigationController pushViewController:vc animated:YES];
                } else {//申请退款
                    LTSCTuiKuanVC *vc = [[LTSCTuiKuanVC alloc] initWithTableViewStyle:UITableViewStyleGrouped];
                    vc.goodsModel = goodsModel;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            } else if (detailModel.status.intValue == 5 || detailModel.status.intValue == 4) {
                if (goodsModel.status.intValue == 4) {//申请退款中
                    LTSCTuiKuanDetailVC *vc = [[LTSCTuiKuanDetailVC alloc] initWithTableViewStyle:UITableViewStyleGrouped type:LTSCTuiKuanDetailVC_type_doing];
                    vc.detailModel = detailModel;
                    [self.navigationController pushViewController:vc animated:YES];
                } else if (goodsModel.status.intValue == 5) {//退款成功
                    LTSCTuiKuanDetailVC *vc = [[LTSCTuiKuanDetailVC alloc] initWithTableViewStyle:UITableViewStyleGrouped type:LTSCTuiKuanDetailVC_type_success];
                    vc.detailModel = detailModel;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }else if (detailModel.status.intValue == 6 || detailModel.status.intValue == 7) {
                if (goodsModel.status.intValue == 5) {//退款成功
                    LTSCTuiKuanDetailVC *vc = [[LTSCTuiKuanDetailVC alloc] initWithTableViewStyle:UITableViewStyleGrouped type:LTSCTuiKuanDetailVC_type_success];
                    vc.detailModel = detailModel;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
        };
        
        cell.detailModel = self.detailModel;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.detailModel.subOrders[indexPath.row];
        return cell;
    }else {
        if (indexPath.row == 7) {
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
                UIView * line = [[UIView alloc] init];
                line.backgroundColor = BGGrayColor;
                [cell addSubview:line];
                [line mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.leading.trailing.equalTo(cell);
                    make.height.equalTo(@0.5);
                }];
                cell.clipsToBounds = YES;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.textColor = MineColor;
            cell.textLabel.font = [UIFont systemFontOfSize:16];
            cell.textLabel.text = [NSString stringWithFormat:@"实际支付: ¥%.2f",self.detailModel.total_money.floatValue];
            return cell;
        }
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell1"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell1"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = CharacterDarkColor;
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.numberOfLines = 0;
        if (indexPath.row == 0) {
            cell.textLabel.text = [NSString stringWithFormat:@"订单编号: %@",self.detailModel.order_code];
        }else  if (indexPath.row == 1) {//2019.04.23 17:00
            cell.textLabel.text = [NSString stringWithFormat:@"下单时间: %@",self.detailModel.createTime];
        } else if (indexPath.row == 2) {
            if (![self.detailModel.status isEqualToString:@"1"]) {
                cell.textLabel.text = [NSString stringWithFormat:@"支付方式: %@",self.detailModel.pay_type.intValue == 1 ? @"支付宝" : @"微信"];
            }else {
                cell.textLabel.text = @"支付方式: 待支付";
            }
            
        } else if (indexPath.row == 3) {
            cell.textLabel.text = [NSString stringWithFormat:@"商品金额: ¥%.2f",self.detailModel.base_money.floatValue];
        } else if (indexPath.row == 4) {
            cell.textLabel.text = [NSString stringWithFormat:@"运费: ¥%.2f", self.detailModel.freight.doubleValue];
        }else if (indexPath.row == 5) {
            cell.textLabel.text = [NSString stringWithFormat:@"备注: %@", self.detailModel.remark];
            if (self.detailModel.remark.length == 0) {
                cell.textLabel.text = @"";
            }
        } else if (indexPath.row == 6) {
            CGFloat youhui = self.detailModel.base_money.doubleValue - self.detailModel.total_money.doubleValue;
            if (youhui != 0) {
                cell.textLabel.text = [NSString stringWithFormat:@"优惠金额: ¥%.2f", youhui];
            }
        }
        cell.clipsToBounds = YES;
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        LTSCMyOrderHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"LTSCMyOrderHeaderView"];
        if (!headerView) {
            headerView = [[LTSCMyOrderHeaderView alloc] initWithReuseIdentifier:@"LTSCMyOrderHeaderView"];
        }
        headerView.detailModel = self.detailModel;
        headerView.stateLabel.hidden = YES;
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if ((self.detailModel.status.intValue == 3 || self.detailModel.status.intValue == 4 || self.detailModel.status.intValue == 7) && self.dataArr.count > 0){
               if (self.dataArr.lastObject.list.count == 0) {
                   CGFloat h = [self.dataArr.lastObject.description getSizeWithMaxSize:CGSizeMake(ScreenW - 75, 9999) withFontSize:14].height;
                   return  15 + 20 + 10 + h + 15;
               }else {
                  return UITableViewAutomaticDimension;
               }
            }else {
               return 60;
            }
            
        }
        return self.detailModel.cellHeight1;
    }else if(indexPath.section == 1) {
        return 120;
    }else {
        if (indexPath.row == 7) {
            return 60;
        }
        if (indexPath.row == 6) {
            CGFloat youhui = self.detailModel.base_money.doubleValue - self.detailModel.total_money.doubleValue;
            if (youhui == 0) {
                return 0.01;
            }
            return 40;
        }else if (indexPath.row == 5){
            if (self.detailModel.remark.length == 0) {
                return 0;
            }
            return  [[NSString stringWithFormat:@"备注%@",self.detailModel.remark] getSizeWithMaxSize:CGSizeMake(ScreenW - 30, 300) withFontSize:16].height+20;;
        }
        return 40;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        if (self.detailModel.status.intValue == 1) {
            return 70;
        }
        return 40;
    }
    return 0.01;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 0 && self.dataArr.count > 0 && (self.detailModel.status.intValue == 3 || self.detailModel.status.intValue == 4 || self.detailModel.status.intValue == 7)) {
        
        LTSCWuLiuInfoVC *vc = [[LTSCWuLiuInfoVC alloc] initWithTableViewStyle:UITableViewStyleGrouped];
        vc.mapData = self.mapData;
        vc.dataArr = self.dataArr;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    if (indexPath.section == 1) {
        LTSCOrderDetailModel *m = self.detailModel.subOrders[indexPath.row];
        LTSCGoodsDetailVC *vc = [[LTSCGoodsDetailVC alloc] init];
        vc.goodsID = m.good_id;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)backClick:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 获取订单详情数据
 */
- (void)loadOrderDetail {
    [LTSCLoadingView show];
    WeakObj(self);
    [LTSCNetworking networkingPOST:order_detail parameters:@{@"token":SESSION_TOKEN,@"orderId":self.orderID} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [LTSCLoadingView dismiss];
        [self.noneView dismiss];
        [self endRefrish];
        if ([responseObject[@"key"] integerValue] == 1000) {
            
             [self initBottomView];
            
            NSString *system_time = [NSString stringWithFormat:@"%@",responseObject[@"result"][@"map"][@"system_time"]];
            [NSDate updateServerTimestamp:[system_time longLongValue]];
            selfWeak.detailModel = [LTSCOrderListDetailModel mj_objectWithKeyValues:responseObject[@"result"][@"map"]];
            if (selfWeak.detailModel.status.intValue == 2 || selfWeak.detailModel.status.intValue == 5) {
                [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.leading.trailing.equalTo(self.view);
                    make.height.equalTo(@0);
                }];
            } else {
                [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.leading.trailing.equalTo(self.view);
                    make.height.equalTo(@(50 + TableViewBottomSpace));
                }];
            }
            selfWeak.bottomView.detailModel = self.detailModel;
            selfWeak.status = self.detailModel.status;
            [selfWeak.tableView reloadData];
        }else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.noneView showNoneNetViewAt:self.view];
        [LTSCLoadingView dismiss];
    }];
}

- (void)loadWuLiuInfo {
    [SVProgressHUD show];
    WeakObj(self);
    [LTSCNetworking networkingPOST:way_detail parameters:@{@"token":SESSION_TOKEN,@"id":self.orderID} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"key"] integerValue] == 1000) {
            selfWeak.dataArr = [LTSCWuLiuInfoStateModel mj_objectArrayWithKeyValuesArray:responseObject[@"result"][@"list"]];
            self.mapData = [LTSCWuLiuInfoMapModel mj_objectWithKeyValues:responseObject[@"result"][@"map"]];
            [selfWeak.tableView reloadData];
        } else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

//底部按钮事件 210左 211右
- (void)bottomAction:(NSInteger)index {
    switch (self.status.intValue) {
        case 1: {//待付款
            if (index == 210) {//取消订单
                [self cancelOrder];
            }else if (index == 211){//去付款
                [self gotopay];
            }
        }
            break;
        case 2: {//待收货
            //确认收货
            [self sureOrder];
        }
            break;
        case 3: {//待收货
            //确认收货
            [self sureOrder];
        }
            break;
        case 4: {//已确认收货
            if (index == 209) {
                //删除订单
                [self deleteOrder];
            } else if (index == 211){
                //去评价
                LTSCCommentOrderVC *vc = [[LTSCCommentOrderVC alloc] initWithTableViewStyle:UITableViewStyleGrouped];
                LTSCOrderObjectModel *model = [LTSCOrderObjectModel new];
                model.goods = self.detailModel.subOrders;
                model.id = self.detailModel.id;
                model.shop_id = self.detailModel.shop_id;
                vc.orderModel = model;
                [self.navigationController pushViewController:vc animated:YES];
            }else if (index == 210) {
                if (self.detailModel.subOrders.count == 0) {
                    return;
                }
                                LTSCGoodsDetailVC *vc = [[LTSCGoodsDetailVC alloc] init];
                vc.goodsID = self.detailModel.subOrders[0].good_id;
                                vc.hidesBottomBarWhenPushed = YES;
                                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        case 5: {//待退款
            
        }
            break;
        case 6: {//待收货
            if (index == 210) {//删除订单
                [self deleteOrder];
            }else {//再次购买 跳转确认订单
                
            }
        }
            break;
            
        case 7: {//已取消
            [self deleteOrder];
        }
            break;
            
        default:
            break;
    }
}

/**
 取消订单
 */
- (void)cancelOrder {
    UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:@"要取消此订单?" preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:nil]];
    [alertView addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [LTSCLoadingView show];
        [LTSCNetworking networkingPOST:cancel_order parameters:@{@"token":SESSION_TOKEN,@"orderId":self.detailModel.id} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [LTSCLoadingView dismiss];
            if ([responseObject[@"key"] integerValue] == 1000) {
                [LTSCEventBus sendEvent:@"reloadOrderList" data:nil];
                self.detailModel.status = @"6";
                self.status = @"6";
                self.bottomView.detailModel = self.detailModel;
                [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
                     make.height.equalTo(@(50 + TableViewBottomSpace));
                }];
                [self.tableView reloadData];
            }else {
                [UIAlertController showAlertWithmessage:@"message"];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [LTSCLoadingView dismiss];
        }];
    }]];
    [self presentViewController:alertView animated:YES completion:nil];
}

/**
 删除订单
 */
- (void)deleteOrder {
    UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:@"是否确认删除?" preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [LTSCLoadingView show];
        [LTSCNetworking networkingPOST:del_order parameters:@{@"token":SESSION_TOKEN,@"orderId":self.detailModel.id} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [LTSCLoadingView dismiss];
            if ([responseObject[@"key"] integerValue] == 1000) {
                [LTSCToastView showSuccessWithStatus:@"此订单已删除!"];
                [LTSCEventBus sendEvent:@"reloadOrderList" data:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                [UIAlertController showAlertWithmessage:responseObject[@"message"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [LTSCLoadingView dismiss];
        }];
    }]];
    [self presentViewController:alertView animated:YES completion:nil];
}


/**
 确认收货
 */
- (void)sureOrder {
    
    UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:@"是否确认收货?" preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [LTSCLoadingView show];
        [LTSCNetworking networkingPOST:get_good parameters:@{@"token":SESSION_TOKEN,@"orderId":self.detailModel.id} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [LTSCLoadingView dismiss];
            if ([responseObject[@"key"] integerValue] == 1000) {
                [LTSCEventBus sendEvent:@"reloadOrderList" data:nil];
                self.detailModel.status = @"4";
                self.status = @"4";
                self.bottomView.detailModel = self.detailModel;
                if (self.detailModel.status.intValue == 2 || self.detailModel.status.intValue == 5) {
                    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.bottom.leading.trailing.equalTo(self.view);
                        make.height.equalTo(@0);
                    }];
                } else {
                    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.bottom.leading.trailing.equalTo(self.view);
                        make.height.equalTo(@(50 + TableViewBottomSpace));
                    }];
                }
                [self.tableView reloadData];
            }else {
                [UIAlertController showAlertWithmessage:responseObject[@"message"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [LTSCLoadingView dismiss];
        }];
    }]];
    [self presentViewController:alertView animated:YES completion:nil];
}

/**
 去付款
 */
- (void)gotopay {
    LTSCSelectPayTypeVC *vc = [[LTSCSelectPayTypeVC alloc] init];
    vc.orderID = self.detailModel.id;
    vc.orderCode = self.detailModel.order_code;
    vc.allPrice = self.detailModel.total_money.floatValue;
    [self.navigationController pushViewController:vc animated:YES];
}

@end

@interface LTSCOrderDetailAddressCell()

//@property (nonatomic, strong) UIImageView *imgView;//顶部背景

@property (nonatomic, strong) UILabel *nameLabel;//姓名

@property (nonatomic, strong) UILabel *phoneLabel;//电话

@property (nonatomic, strong) UILabel *addressLabel;//地址

@property (nonatomic, strong) UIImageView *addressImgView;//编辑

@end
@implementation LTSCOrderDetailAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubviews];
        [self setConstrains];
    }
    return self;
}
- (void)initSubviews {
    //    [self addSubview:self.imgView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.phoneLabel];
    [self addSubview:self.addressImgView];
    [self addSubview:self.addressLabel];
}

- (void)setConstrains {
    //    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.leading.trailing.equalTo(self);
    //        make.height.equalTo(@9);
    //    }];
    [self.addressImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.centerY.equalTo(self).offset(5);
        make.width.equalTo(@20);
        make.height.equalTo(@25);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20);
        make.leading.equalTo(self.addressImgView.mas_trailing).offset(15);
    }];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nameLabel.mas_trailing).offset(15);
        make.centerY.equalTo(self.nameLabel);
    }];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
        make.leading.equalTo(self.addressImgView.mas_trailing).offset(15);
        make.trailing.equalTo(self).offset(-20);
    }];
}
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = CharacterDarkColor;
        _nameLabel.text = @"啦啦啦啦啦啦";
        _nameLabel.font = [UIFont systemFontOfSize:16];
    }
    return _nameLabel;
}

- (UILabel *)phoneLabel {
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc] init];
        _phoneLabel.textColor = CharacterDarkColor;
        _phoneLabel.text = @"176****8387";
        _phoneLabel.font = [UIFont systemFontOfSize:16];
    }
    return _phoneLabel;
}
- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.textColor = CharacterGrayColor;
        _addressLabel.text = @"江苏省常州市新北区";
        _addressLabel.numberOfLines = 0;
        _addressLabel.font = [UIFont systemFontOfSize:14];
    }
    return _addressLabel;
}
- (UIImageView *)addressImgView {
    if (!_addressImgView) {
        _addressImgView = [[UIImageView alloc] init];
        _addressImgView.image = [UIImage imageNamed:@"orderaddress"];
    }
    return _addressImgView;
}

//- (UIImageView *)imgView {
//    if (!_imgView) {
//        _imgView = [[UIImageView alloc] init];
//        _imgView.image = [UIImage imageNamed:@"addressimage"];
//    }
//    return _imgView;
//}

- (void)setModel:(LTSCGoodsDetailAdressModel *)model {
    _model = model;
    _nameLabel.text = _model.username;
    _phoneLabel.text = _model.telephone;
    _addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@",_model.province,_model.city,_model.district,_model.addressDetail];
}

- (void)setDetailModel:(LTSCOrderListDetailModel *)detailModel {
    _detailModel = detailModel;
    _nameLabel.text = _detailModel.username;
    _phoneLabel.text = _detailModel.telephone;
    _addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@",_detailModel.province,_detailModel.city,_detailModel.district,_detailModel.address_detail1];
}

@end

@interface LTSCOrderDetailCell()

@property (nonatomic, strong) UIImageView *imgView;//图片

@property (nonatomic, strong) UILabel *titleLabel;//标题

@property (nonatomic, strong) UILabel *guigeLabel;//规格

@property (nonatomic, strong) UILabel *moneyLabel;//价格

@property (nonatomic, strong) UILabel *numLabel;//数量

@property (nonatomic, strong) UIButton *tuikuanButton;//退款

@end
@implementation LTSCOrderDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubviews];
        [self setConstrains];
    }
    return self;
}

- (void)initSubviews {
    [self addSubview:self.imgView];
    [self addSubview:self.titleLabel];
    self.titleLabel.numberOfLines = 2;
    [self addSubview:self.guigeLabel];
    [self addSubview:self.moneyLabel];
    [self addSubview:self.numLabel];
    [self addSubview:self.tuikuanButton];
}

- (void)setConstrains {
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self).offset(15);
        make.width.height.equalTo(@90);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView);
        make.trailing.equalTo(self).offset(-90);
        make.leading.equalTo(self.imgView.mas_trailing).offset(10);
    }];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView);
        make.trailing.equalTo(self).offset(-15);
        make.width.equalTo(@100);
    }];
    [self.guigeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(2);
        make.leading.equalTo(self.imgView.mas_trailing).offset(10);
        make.trailing.equalTo(self).offset(-115);
    }];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.imgView.mas_trailing).offset(10);
        make.bottom.equalTo(self.imgView);
    }];
    [self.tuikuanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-15);
        make.bottom.equalTo(self.imgView);
        make.width.equalTo(@60);
        make.height.equalTo(@30);
    }];
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.image = [UIImage imageNamed:@"tupian"];
        _imgView.layer.cornerRadius = 3;
        _imgView.layer.masksToBounds = YES;
    }
    return _imgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = CharacterDarkColor;
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.numberOfLines = 2;
        _titleLabel.text = @"环保高粘性透明热熔胶棒家用大小号热熔硅胶条胶水枪胶抢7mm 11mm";
    }
    return _titleLabel;
}

- (UILabel *)numLabel {
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] init];
        _numLabel.textColor = CharacterDarkColor;
        _numLabel.font = [UIFont systemFontOfSize:15];
        _numLabel.textAlignment = NSTextAlignmentRight;
        _numLabel.text = @"X1000";
    }
    return _numLabel;
}

- (UILabel *)guigeLabel {
    if (!_guigeLabel) {
        _guigeLabel = [[UILabel alloc] init];
        _guigeLabel.textColor = CharacterGrayColor;
        _guigeLabel.font = [UIFont systemFontOfSize:11];
        _guigeLabel.numberOfLines = 2;
        _guigeLabel.text = @"大中小T型4件套伸缩两用螺丝刀(赠送加磁器)";
    }
    return _guigeLabel;
}

- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.textColor = CharacterDarkColor;
        _moneyLabel.font = [UIFont systemFontOfSize:13];
    }
    return _moneyLabel;
}

- (UIButton *)tuikuanButton {
    if (!_tuikuanButton) {
        _tuikuanButton = [[UIButton alloc] init];
        [_tuikuanButton setTitle:@"退款" forState:UIControlStateNormal];
        [_tuikuanButton setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
        [_tuikuanButton setBackgroundImage:[UIImage imageNamed:@"white"] forState:UIControlStateNormal];
        _tuikuanButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _tuikuanButton.layer.borderWidth = 0.5;
        _tuikuanButton.layer.cornerRadius = 3;
        _tuikuanButton.layer.borderColor = CharacterDarkColor.CGColor;
        _tuikuanButton.layer.masksToBounds = YES;
        [_tuikuanButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tuikuanButton;
}

- (void)btnClick:(UIButton *)button  {
    if (![button.titleLabel.text isEqualToString:@"退款"]) {
        return;
    }
    if (self.tuikuanBlock) {
        self.tuikuanBlock(self.detailModel,self.model);
    }
}

- (void)setModel:(LTSCOrderDetailModel *)model {
    _model = model;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:_model.list_pic] placeholderImage:[UIImage imageNamed:@"blank"]];
    self.titleLabel.text = _model.good_name;
    if (_detailModel.status.intValue == 2 || _detailModel.status.intValue == 3) {//3：驳回退款，4：退款中,5.退款成功
        if (_model.status.intValue == 4) {
            _tuikuanButton.hidden = NO;
            [_tuikuanButton setTitle:@"退款中" forState:UIControlStateNormal];
            [_tuikuanButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@70);
            }];
        } else if (_model.status.intValue == 5) {
            _tuikuanButton.hidden = NO;
            [_tuikuanButton setTitle:@"退款成功" forState:UIControlStateNormal];
            [_tuikuanButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@70);
            }];
        } else {
            _tuikuanButton.hidden = NO;
            [_tuikuanButton setTitle:@"退款" forState:UIControlStateNormal];
            [_tuikuanButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@70);
            }];
        }
    } else if (_detailModel.status.intValue == 5 || _detailModel.status.intValue == 4) {
        if (_model.status.intValue == 4) {
            _tuikuanButton.hidden = NO;
            [_tuikuanButton setTitle:@"退款中" forState:UIControlStateNormal];
            [_tuikuanButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@70);
            }];
        } else if (_model.status.intValue == 5) {
            _tuikuanButton.hidden = NO;
            [_tuikuanButton setTitle:@"退款成功" forState:UIControlStateNormal];
            [_tuikuanButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@70);
            }];
        }else {
            _tuikuanButton.hidden = YES;
            [_tuikuanButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@0);
            }];
        }
        
    } else if (_detailModel.status.intValue == 6 ||  _detailModel.status.intValue == 7) {
         if (_model.status.intValue == 5) {
            _tuikuanButton.hidden = NO;
            [_tuikuanButton setTitle:@"退款成功" forState:UIControlStateNormal];
            [_tuikuanButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@70);
            }];
        } else {
            _tuikuanButton.hidden = YES;
            [_tuikuanButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@0);
            }];
        }
        
    }  else {
        _tuikuanButton.hidden = YES;
        [_tuikuanButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@0);
        }];
    }
    if (_model.properties && ![_model.properties isKong]) {
        self.guigeLabel.hidden = NO;
        self.guigeLabel.attributedText = _model.yixuanAttStr;
    }else {
        self.guigeLabel.hidden = YES;
    }
    self.numLabel.text = [NSString stringWithFormat:@"X%@",_model.num];
    self.moneyLabel.text = [NSString stringWithFormat:@"¥%.2f", _model.good_price.floatValue];
    [self layoutIfNeeded];
}
//退款详情
- (void)setTuikuanModel:(LTSCOrderDetailModel *)tuikuanModel {
    _tuikuanModel = tuikuanModel;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:_tuikuanModel.list_pic] placeholderImage:[UIImage imageNamed:@"blank"]];
    self.titleLabel.text = _tuikuanModel.good_name;
    _tuikuanButton.hidden = YES;
    [_tuikuanButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@0);
    }];
    if (_tuikuanModel.properties && ![_tuikuanModel.properties isKong]) {
        self.guigeLabel.hidden = NO;
        self.guigeLabel.attributedText = _tuikuanModel.yixuanAttStr;
    }else {
        self.guigeLabel.hidden = YES;
    }
    self.numLabel.text = [NSString stringWithFormat:@"X%@",_tuikuanModel.num];
    self.moneyLabel.text = [NSString stringWithFormat:@"¥%.2f", _tuikuanModel.good_price.floatValue];
    [self layoutIfNeeded];
}

@end

@interface LTSCOrderDetailBottomView()

@property (nonatomic, strong) UIView *lineView;//线

@property (nonatomic, strong) UIButton *leftButton;

@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, strong) UIButton *leftOneButton;


@end

@implementation LTSCOrderDetailBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.redColor;
        [self addSubview:self.lineView];
        [self addSubview:self.leftOneButton];
        [self addSubview:self.leftButton];
        [self addSubview:self.rightButton];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(self);
            make.height.equalTo(@0.5);
        }];
        [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(10);
            make.trailing.equalTo(self).offset(-15);
            make.height.equalTo(@30);
            make.width.equalTo(@80);
            
        }];
        [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self).offset(-115);
            make.top.equalTo(self).offset(10);
            make.height.equalTo(@30);
            make.width.equalTo(@80);
        }];
        
        [self.leftOneButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.leftButton.mas_leading).offset(-20);
            make.top.equalTo(self).offset(10);
            make.height.equalTo(@30);
            make.width.equalTo(@80);
        }];
    }
    return self;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [LineColor colorWithAlphaComponent:0.3];
    }
    return _lineView;
}

- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [[UIButton alloc] init];
        [_leftButton setTitle:@"删除订单" forState:UIControlStateNormal];
        [_leftButton setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
        [_leftButton setBackgroundImage:[UIImage imageNamed:@"white"] forState:UIControlStateNormal];
        _leftButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _leftButton.layer.borderWidth = 0.5;
        _leftButton.layer.cornerRadius = 3;
        _leftButton.layer.borderColor = CharacterDarkColor.CGColor;
        _leftButton.layer.masksToBounds = YES;
        [_leftButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _leftButton.tag = 210;
    }
    return _leftButton;
}

- (UIButton *)leftOneButton {
    if (!_leftOneButton) {
        _leftOneButton = [[UIButton alloc] init];
        [_leftOneButton setTitle:@"删除订单" forState:UIControlStateNormal];
        [_leftOneButton setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
        [_leftOneButton setBackgroundImage:[UIImage imageNamed:@"white"] forState:UIControlStateNormal];
        _leftOneButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _leftOneButton.layer.borderWidth = 0.5;
        _leftOneButton.layer.cornerRadius = 3;
        _leftOneButton.layer.borderColor = CharacterDarkColor.CGColor;
        _leftOneButton.layer.masksToBounds = YES;
        [_leftOneButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _leftOneButton.tag = 209;
    }
    return _leftOneButton;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [[UIButton alloc] init];
        [_rightButton setTitle:@"  再次购买  " forState:UIControlStateNormal];
        [_rightButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_rightButton setBackgroundImage:[UIImage imageNamed:@"yellow"] forState:UIControlStateNormal];
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _rightButton.layer.cornerRadius = 3;
        _rightButton.layer.masksToBounds = YES;
        [_rightButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _rightButton.tag = 211;
    }
    return _rightButton;
}

- (void)btnClick:(UIButton *)btn {
    if (self.bottomActionBlock) {
        self.bottomActionBlock(btn.tag);
    }
}

- (void)setDetailModel:(LTSCOrderListDetailModel *)detailModel {
    _detailModel = detailModel;
    _leftOneButton.hidden = YES;
    [self.leftButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-115);
    }];
    switch (_detailModel.status.intValue) {
        case 1: {//待付款
            _leftButton.hidden = _rightButton.hidden = NO;
            [_leftButton setTitle:@"取消订单" forState:UIControlStateNormal];
            [_rightButton setTitle:@"去付款" forState:UIControlStateNormal];
        }
            break;
        case 2: {//待发货
            
            _leftButton.hidden = YES;
            _rightButton.hidden = YES;
            //            [_rightButton setTitle:@"  确认收货  " forState:UIControlStateNormal];
        }
            break;
        case 3: {//待收货
            
            _leftButton.hidden = YES;
            _rightButton.hidden = NO;
            [_rightButton setTitle:@"确认收货" forState:UIControlStateNormal];
        }
            break;
        case 4: {//已完成
            
            _leftButton.hidden = NO;
            _rightButton.hidden = NO;
            _leftOneButton.hidden = NO;
            [_leftButton setTitle:@"再次购买" forState:UIControlStateNormal];
            [_leftOneButton setTitle:@"删除订单" forState:UIControlStateNormal];
            [_rightButton setTitle:@"去评价" forState:UIControlStateNormal];
            
        }
            break;
        case 5: {//待退款
            _leftButton.hidden = YES;
            _rightButton.hidden = YES;
            
        }
            break;
        case 6: {//已取消
            
            _leftButton.hidden = NO;
            _rightButton.hidden = YES;
            [self.leftButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self).offset(-15);
            }];
            [_leftButton setTitle:@"删除订单" forState:UIControlStateNormal];
            
            
        }
            break;
            
        case 7: {//已取消
            _leftOneButton.hidden = NO;
            _leftButton.hidden = NO;
            _rightButton.hidden = YES;
            [self.leftButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self).offset(-15);
            }];
            [_leftButton setTitle:@"再次购买" forState:UIControlStateNormal];
            [_leftOneButton setTitle:@"删除订单" forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}



@end
