//
//  LTSCSubOrderVC.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/21.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LTSCSubOrderVC.h"
#import "LTSCSureOrderVC.h"
#import "LTSCMyOrderHeaderFooterView.h"
#import "LTSCOrderDetailVC.h"
#import "LTSCSelectPayTypeVC.h"
#import "LTSCGoodsDetailVC.h"
#import "LTSCCommentOrderVC.h"
#import "LTSCDianPuTabBarController.h"
@interface LTSCSubOrderVC ()

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray <LTSCOrderObjectModel *> *dataArr;

@property (nonatomic, strong) NSString *current_time;

@end

@implementation LTSCSubOrderVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.page = 1;
    [self loadOrderList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 10)];
    
    self.dataArr = [NSMutableArray array];
    self.page = 1;
    [self loadOrderList];
    WeakObj(self);
    self.tableView.mj_header = [LTSCRefreshHeader headerWithRefreshingBlock:^{
        selfWeak.page = 1;
        [selfWeak loadOrderList];
    }];
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [selfWeak loadOrderList];
    }];
    
    [LTSCEventBus registerEvent:@"settleOrderSuccess" block:^(id data) {
        selfWeak.page = 1;
        [selfWeak loadOrderList];
        selfWeak.tabBarController.selectedIndex = 0;
    }];
    [LTSCEventBus registerEvent:@"cancelSuccess" block:^(id data) {
        [selfWeak.tableView reloadData];
    }];
    [LTSCEventBus registerEvent:@"reloadOrderList" block:^(id data) {
        selfWeak.page = 1;
        [selfWeak loadOrderList];
    }];
    
    self.noneView.clickBlock = ^{
        selfWeak.page = 1;
        [selfWeak loadOrderList];
    };
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    LTSCOrderObjectModel *objModel = self.dataArr[section];
    return objModel.goods.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LTSCSureOrderGoodsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LTSCSureOrderGoodsCell"];
    if (!cell) {
        cell = [[LTSCSureOrderGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LTSCSureOrderGoodsCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    LTSCOrderObjectModel *objModel = self.dataArr[indexPath.section];
    cell.detailModel = objModel.goods[indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    LTSCMyOrderHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"LTSCMyOrderHeaderView"];
    if (!headerView) {
        headerView = [[LTSCMyOrderHeaderView alloc] initWithReuseIdentifier:@"LTSCMyOrderHeaderView"];
    }
    headerView.bgButtonClickBlock = ^{
//        LTSCOrderDetailVC *vc = [[LTSCOrderDetailVC alloc] initWithTableViewStyle:UITableViewStyleGrouped];
//        vc.orderID = self.dataArr[section].id;
//        [self.navigationController pushViewController:vc animated:YES];
        
         LTSCDianPuTabBarController *tabVC = [LTSCDianPuTabBarController new];
            tabVC.shopId = self.dataArr[section].shop_id;
        //    tabVC.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:tabVC animated:NO completion:nil];
        
    };
    LTSCOrderObjectModel *model = self.dataArr[section];
    model.current_time = self.current_time;
    headerView.objModel = model;
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    LTSCMyOrderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"LTSCMyOrderFooterView"];
    if (!footerView) {
        footerView = [[LTSCMyOrderFooterView alloc] initWithReuseIdentifier:@"LTSCMyOrderFooterView"];
    }
    LTSCOrderObjectModel *model = self.dataArr[section];
    model.current_time = self.current_time;
    footerView.objModel = model;
    footerView.bgButtonClickBlock = ^{
        LTSCOrderDetailVC *vc = [[LTSCOrderDetailVC alloc] initWithTableViewStyle:UITableViewStyleGrouped];
        vc.orderID = self.dataArr[section].id;
        [self.navigationController pushViewController:vc animated:YES];
    };
    footerView.footerButtonClickBlock = ^(LTSCOrderObjectModel *objModel, NSInteger index) {
        [self footerAction:objModel index:index];
    };
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.dataArr[section].status.intValue == 1) {
        return 70;
    }
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.dataArr[section].status.intValue == 5 || self.dataArr[section].status.intValue == 2) {
        return 50;
    }
    
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LTSCOrderObjectModel *objModel = self.dataArr[indexPath.section];
    LTSCOrderDetailVC *vc = [[LTSCOrderDetailVC alloc] initWithTableViewStyle:UITableViewStyleGrouped];
    vc.orderID = objModel.id;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 获取订单列表
 */
- (void)loadOrderList {
    if (self.dataArr <= 0) {
        [LTSCLoadingView show];
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"token"] = SESSION_TOKEN;
    dic[@"pageNum"] = @(self.page);
    dic[@"status"] = @(self.index);
    dic[@"pageSize"] = @10;
    [LTSCNetworking networkingPOST:orderList parameters:dic returnClass:[LTSCOrderRootModel class] success:^(NSURLSessionDataTask *task, LTSCOrderRootModel *responseObject) {
        [self endRefrish];
        if (responseObject.key.intValue == 1000) {
            if (self.page == 1) {
                [self.dataArr removeAllObjects];
            }
            if (self.page <= responseObject.result.allPageNumber.intValue) {
                [self.dataArr addObjectsFromArray:responseObject.result.list];
            }
            if (self.dataArr.count > 0) {
                [NSDate updateServerTimestamp:[self.dataArr[0].system_time longLongValue]];
            }
            self.page ++;
            [self.tableView reloadData];
        }else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
        if (self.dataArr.count <= 0) {
            [self.noneView showNoneDataViewAt:self.view img:[UIImage imageNamed:@"emptyorder"] tips:@"暂无订单"];
        } else {
            [self.noneView dismiss];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self endRefrish];
        if (self.dataArr.count <= 0) {
            [self.noneView showNoneNetViewAt:self.view];
        } else {
            [self.noneView dismiss];
        }
    }];
}


/**
 区尾按钮事件处理
 */
- (void)footerAction:(LTSCOrderObjectModel *)objModel index:(NSInteger)index {
    switch (objModel.status.intValue) {
        case 1: {//待付款
            if (index == 110) {//取消订单
                [self cancelOrder:objModel];
            }else {//去付款
                [self payWithModel:objModel];
            }
        }
            break;
        case 2: {//待发货
            [self sureOrder:objModel];
        }
            break;
        case 3: {//待收货
            //确认收货
            [self sureOrder:objModel];
        }
            break;
        case 4: {//已完成
            if (index == 109) {
                //删除订单
                [self deleteOrder:objModel];
            } else if (index == 111) {
                //去评价
                LTSCCommentOrderVC *vc = [[LTSCCommentOrderVC alloc] initWithTableViewStyle:UITableViewStyleGrouped];
                vc.orderModel = objModel;
                [self.navigationController pushViewController:vc animated:YES];
            }else {
                if (objModel.goods.count == 0){
                    return;
                }
                LTSCGoodsDetailVC *vc = [[LTSCGoodsDetailVC alloc] init];
                vc.goodsID = objModel.goods[0].good_id;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        case 5: {//待退款
            //确认收货
            [self sureOrder:objModel];
        }
            break;
        case 6: {//已取消
            if (index == 110) {//删除订单
                [self deleteOrder:objModel];
            }else {//再次购买 跳转确认订单
                [self goToSureOrder];
            }
        }
            break;
        case 7: {//已评价
            if (index == 109) {
                //删除订单
                [self deleteOrder:objModel];
            }else if (index == 110){
                if (objModel.goods.count == 0){
                    return;
                }
                LTSCGoodsDetailVC *vc = [[LTSCGoodsDetailVC alloc] init];
                vc.goodsID = objModel.goods[0].good_id;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
            
        default:
            break;
    }
}


/**
 去付款
 */
- (void)payWithModel:(LTSCOrderObjectModel *)objModel {
    LTSCSelectPayTypeVC *vc = [[LTSCSelectPayTypeVC alloc] init];
    vc.orderID = objModel.id;
    vc.orderCode = objModel.order_code;
    vc.allPrice = objModel.total_money.floatValue;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 取消订单
 */
- (void)cancelOrder:(LTSCOrderObjectModel *)model {
    UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:@"要取消此订单?" preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:nil]];
    [alertView addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [LTSCLoadingView show];
        [LTSCNetworking networkingPOST:cancel_order parameters:@{@"token":SESSION_TOKEN,@"orderId":model.id} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [LTSCLoadingView dismiss];
            if ([responseObject[@"key"] integerValue] == 1000) {
                model.status = @"6";
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
- (void)deleteOrder:(LTSCOrderObjectModel *)model {
    UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:@"是否确认删除?" preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [LTSCLoadingView show];
        [LTSCNetworking networkingPOST:del_order parameters:@{@"token":SESSION_TOKEN,@"orderId":model.id} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [LTSCLoadingView dismiss];
            if ([responseObject[@"key"] integerValue] == 1000) {
                [LTSCToastView showSuccessWithStatus:@"此订单已删除!"];
                [self.dataArr removeObject:model];
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
 确认收货
 */
- (void)sureOrder:(LTSCOrderObjectModel *)model {
    UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:@"是否确认收货?" preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [LTSCLoadingView show];
        [LTSCNetworking networkingPOST:get_good parameters:@{@"token":SESSION_TOKEN,@"orderId":model.id} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [LTSCLoadingView dismiss];
            if ([responseObject[@"key"] integerValue] == 1000) {
                model.status = @"4";
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
 再次购买
 */
- (void)goToSureOrder {
    //    LTSCSureOrderVC *vc = [[LTSCSureOrderVC alloc] init];
    //    vc.ids = ids;
    //    vc.dataArr = selectArray;
    //    vc.allPrice = self.allPrice;
    //    vc.hidesBottomBarWhenPushed = YES;
    //    [self.navigationController pushViewController:vc animated:YES];
}

@end
