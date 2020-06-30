//
//  LTSCSureOrderVC.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/20.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LTSCSureOrderVC.h"
#import "LTSCAddressCell.h"
#import "LTSCSelectPayTypeVC.h"
#import "LTSCAddressModel.h"
#import "LTSCSelectAddressVC.h"
#import "LTSCGoodsDetailVC.h"
#import "LTSCDianPuTabBarController.h"

#import "LTSCYouHuiQuanAlertView.h"

@interface LTSCSureOrderVC ()<UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *imgView;//顶部背景

@property (nonatomic, strong) LTSCSureOrderBottomView *bottomView;//顶部背景



@property (nonatomic, strong) NSMutableArray <LTSCYouHuiQuanModel *>*youhuiquanArr;//优惠券数据

@property (nonatomic, strong) LTSCYouHuiQuanModel *currentModel;//选中的可使用的优惠券

/**  */
@property(nonatomic , strong)NSMutableArray<LTSCGoodsDetailSUKModel *> *xiaJiaArr;//下架的商品


@end

@implementation LTSCSureOrderVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    NSArray *viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count > 1 && [viewControllers objectAtIndex:viewControllers.count - 2] == self) {
        //为push操作
        NSLog(@"111");
    } else if ([viewControllers indexOfObject:self] == NSNotFound) {
        //为pop操作
        if (self.tanGuigeViewBlock) {
            self.tanGuigeViewBlock();
        }
    }
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.image = [UIImage imageNamed:@"addressimage"];
    }
    return _imgView;
}

- (LTSCSureOrderBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[LTSCSureOrderBottomView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.moneyLabel.text = [NSString stringWithFormat:@"¥%.2f",self.allPrice];
    }
    return _bottomView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"确认订单";
    [self initView];
    WeakObj(self);
    self.xiaJiaArr = @[].mutableCopy;
    self.bottomView.submitOrderBlock = ^{
        if (selfWeak.dict) {
            [selfWeak lijiXiadan];
        }else {
            [selfWeak submitOrder];
        }
    };
    //获取默认地址
//    [self loadMorenAddress];
    
    self.youhuiquanArr = [NSMutableArray array];
    [self loadYouHuiQuanList];
    
    if (self.addressModel == nil) {
//        self.addressModel = [[LTSCAddressListModel alloc] init];
        
        [self loadMorenAddress];
    }
    
}


/// 获取优惠券列表
- (void)loadYouHuiQuanList {
    WeakObj(self);
    [LTSCLoadingView show];
    [LTSCNetworking networkingPOST:couponList parameters:@{@"token":SESSION_TOKEN,@"status":@2,@"pageNum":@1,@"pageSize":@100} returnClass:[LTSCYouHuiQuanRootModel class] success:^(NSURLSessionDataTask *task, LTSCYouHuiQuanRootModel *responseObject) {
        [LTSCLoadingView dismiss];
        if (responseObject.key.intValue == 1000) {
            [selfWeak.youhuiquanArr removeAllObjects];
            [selfWeak.youhuiquanArr addObjectsFromArray:responseObject.result.list];
             [selfWeak.tableView reloadSections:[NSIndexSet indexSetWithIndex:1 + self.dianpuArr.count] withRowAnimation:UITableViewRowAnimationFade];
        } else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [LTSCLoadingView dismiss];
    }];
}




- (void)initView {
    [self.view addSubview:self.imgView];
    [self.view addSubview:self.bottomView];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.height.equalTo(@9);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom);
        make.leading.trailing.bottom.equalTo(self.view);
        make.height.equalTo(@(TableViewBottomSpace + 50));
    }];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(9);
        make.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3 + self.dianpuArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1 + self.dianpuArr.count) {
        return 1;
    } else if (section == 2 + self.dianpuArr.count) {
        return 2;
    } else {
       return self.dianpuArr[section - 1].goodList.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.addressModel.id) {
            LTSCAddressCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LTSCAddressCell"];
            if (!cell) {
                cell = [[LTSCAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LTSCAddressCell"];
            }
            cell.isSureOrder = YES;
            cell.model = self.addressModel;
            cell.editBtn.userInteractionEnabled = NO;
            return cell;
        }else {
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.textColor = CharacterGrayColor;
            cell.textLabel.text = @"请选择收货地址";
            return cell;
        }
    } else if (indexPath.section == 1 + self.dianpuArr.count) {
        LTSCSureOrderYouhuiQuanCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LTSCSureOrderYouhuiQuanCell"];
        if (!cell) {
            cell = [[LTSCSureOrderYouhuiQuanCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"LTSCSureOrderYouhuiQuanCell"];
        }
        cell.leftLabel.text = @"优惠券";
        if (!self.currentModel) {
            cell.rightLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.youhuiquanArr.count];
            NSInteger number = 0;
            for (LTSCYouHuiQuanModel * mmm in  self.youhuiquanArr) {
                if (mmm.type.intValue == 1) {
                    if (self.allPrice > mmm.full_money.floatValue) {
                        number++;
                    }
                }else {
                    if (self.allPrice > mmm.reduce_money.floatValue) {
                        number++;
                    }
                }
               
            }
            cell.rightTwoLabel.text =  [NSString stringWithFormat:@"%ld个可用",number];
            cell.rightLabel.hidden = YES;
            cell.imagV.hidden = NO;
        } else {
            cell.rightLabel.text = [NSString stringWithFormat:@"-¥%@",self.currentModel.type.intValue == 2 ? self.currentModel.reduce_money.getPriceStr : self.currentModel.reduce_money.getPriceStr];
            cell.rightLabel.hidden = NO;
            
            cell.imagV.hidden = YES;
        }
        return cell;
    } else if (indexPath.section == 2 + self.dianpuArr.count) {
        LTSCSureOrderGoodsOtherCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LTSCSureOrderGoodsOtherCell"];
        if (!cell) {
            cell = [[LTSCSureOrderGoodsOtherCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LTSCSureOrderGoodsOtherCell"];
        }
        if (indexPath.row == 0) {
            cell.leftLabel.text = @"商品金额";
            cell.rightLabel.text = [NSString stringWithFormat:@"¥%.2f",self.allPrice];
        } else {
            cell.leftLabel.text = @"运费";
            cell.rightLabel.text = @"¥0.00";
        }
        return cell;
    } else {
        LTSCSureOrderGoodsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LTSCSureOrderGoodsCell"];
        if (!cell) {
            cell = [[LTSCSureOrderGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LTSCSureOrderGoodsCell"];
        }
        LTSCGoodsDetailSUKModel *model = self.dianpuArr[indexPath.section - 1].goodList[indexPath.row];
        model.isCart = self.dict ? YES : NO;
        cell.goodsModel = model;
        
        for (LTSCGoodsDetailSUKModel *neiModel in self.xiaJiaArr) {
            if (self.dict) {
                if (neiModel.skuId.length == 0) {
                    if ([model.goodId isEqualToString:neiModel.goodId]) {
                        cell.xiaJiaImgV.hidden = NO;
                        break;
                    }else {
                        cell.xiaJiaImgV.hidden = YES;
                    }
                }else {
                    if ([model.skuId isEqualToString:neiModel.skuId] && [model.goodId isEqualToString:neiModel.goodId]) {
                        cell.xiaJiaImgV.hidden = NO;
                        break;
                    }else {
                        cell.xiaJiaImgV.hidden = YES;
                    }
                }
            }else {
                if (neiModel.skuId.length == 0) {
                    if ([model.good_id isEqualToString:neiModel.goodId]) {
                        cell.xiaJiaImgV.hidden = NO;
                        break;
                    }else {
                        cell.xiaJiaImgV.hidden = YES;
                    }
                }else {
                    if ([model.sku_id isEqualToString:neiModel.skuId] && [model.good_id isEqualToString:neiModel.goodId]) {
                        cell.xiaJiaImgV.hidden = NO;
                        break;
                    }else {
                        cell.xiaJiaImgV.hidden = YES;
                    }
                }
            }
            
            
            
        }
        
        WeakObj(self);
        cell.refreshTableView = ^(LTSCGoodsDetailSUKModel *goodsModel) {
            selfWeak.dict[@"num"] = goodsModel.num;
            selfWeak.allPrice = goodsModel.good_price.floatValue * goodsModel.num.intValue;
            if (selfWeak.currentModel) {
                if (selfWeak.currentModel.isSelect) {
                    CGFloat youhuiP = (selfWeak.currentModel.type.intValue == 2 ? selfWeak.currentModel.reduce_money.doubleValue : selfWeak.currentModel.reduce_money.doubleValue);
                    if (selfWeak.allPrice > youhuiP) {
                        selfWeak.bottomView.moneyLabel.text = [NSString stringWithFormat:@"¥%.2f",self.allPrice - (selfWeak.currentModel.type.intValue == 2 ? selfWeak.currentModel.reduce_money.floatValue : selfWeak.currentModel.reduce_money.floatValue)];
                    } else {
                        selfWeak.currentModel = nil;
                        selfWeak.bottomView.moneyLabel.text = [NSString stringWithFormat:@"¥%.2f",self.allPrice];
                    }
                } else {
                    selfWeak.currentModel = nil;
                    selfWeak.bottomView.moneyLabel.text = [NSString stringWithFormat:@"¥%.2f",self.allPrice];
                }
                 
            } else {
                 selfWeak.bottomView.moneyLabel.text = [NSString stringWithFormat:@"¥%.2f",self.allPrice];
            }
            
            [selfWeak.tableView reloadData];
        };
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0 || (section == 1 + self.dianpuArr.count) || (section == 2 + self.dianpuArr.count)) {
        return nil;
    }
    LTSCShopCarHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"LTSCShopCarHeaderView"];
    if (!headerView) {
        headerView = [[LTSCShopCarHeaderView alloc] initWithReuseIdentifier:@"LTSCShopCarHeaderView"];
    }
    headerView.isXiaDan = YES;
    headerView.model = self.dianpuArr[section - 1];
    WeakObj(self);
    headerView.didSelectDianpuBlock = ^(LTSCShopCarDianPuModel *model) {
        LTSCDianPuTabBarController *tabVC = [LTSCDianPuTabBarController new];
        tabVC.shopId = model.shopId;
//        tabVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [selfWeak presentViewController:tabVC animated:NO completion:nil];
    };
    return headerView;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0 || (section == 1 + self.dianpuArr.count) || (section == 2 + self.dianpuArr.count)) {
        return nil;
    }
    LTSCXiaDanFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"LTSCXiaDanFooterView"];
    if (!footerView) {
        footerView = [[LTSCXiaDanFooterView alloc] initWithReuseIdentifier:@"LTSCXiaDanFooterView"];
    }
    footerView.model = self.dianpuArr[section - 1];
    return footerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.addressModel) {
            NSString *str = [NSString stringWithFormat:@"%@%@%@%@",self.addressModel.province,self.addressModel.city,self.addressModel.district,self.addressModel.addressDetail];
            CGFloat h = [str getSizeWithMaxSize:CGSizeMake(ScreenW - 180, 9999) withFontSize:14].height;
            return 15 + 20 + 15 + h + 15;
        }else {
            return 60;
        }
    } else if(indexPath.section == 1 + self.dianpuArr.count) {
        if (self.youhuiquanArr.count == 0) {
            return 0.01;
        }
        return 60;
    } else if(indexPath.section == 2 + self.dianpuArr.count) {
        return 60;
    } else {
        return 120;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0 || (section == 2 + self.dianpuArr.count)) {
        return 10;
    } else if(section == 1 + self.dianpuArr.count) {
        if (self.youhuiquanArr.count == 0) {
            return 0.01;
        }
        return 10;
    }
    return 110;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 || (section == 1 + self.dianpuArr.count) || (section == 2 + self.dianpuArr.count)) {
        return 0.01;
    }
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        LTSCSelectAddressVC *vc = [[LTSCSelectAddressVC alloc] init];
        vc.isSelect = YES;
        WeakObj(self);
        vc.selectAddressModelClick = ^(LTSCGoodsDetailAdressModel *addressModel) {
            if (selfWeak.addressModel == nil) {
                selfWeak.addressModel = [[LTSCAddressListModel alloc] init];
            }
            selfWeak.addressModel.id = addressModel.id;
            selfWeak.addressModel.username = addressModel.username;
            selfWeak.addressModel.telephone = addressModel.telephone;
            selfWeak.addressModel.province = addressModel.province;
            selfWeak.addressModel.city = addressModel.city;
            selfWeak.addressModel.district = addressModel.district;
            selfWeak.addressModel.addressDetail = addressModel.addressDetail;
            selfWeak.addressModel.defaultStatus = addressModel.defaultStatus;
            [selfWeak.tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.section == 1 + self.dianpuArr.count) {//优惠券
        LTSCYouHuiQuanAlertView *alertView = [[LTSCYouHuiQuanAlertView alloc] initWithFrame:UIScreen.mainScreen.bounds];
        alertView.allPrice = self.allPrice;
        alertView.youhuiquanArr = self.youhuiquanArr;
        WeakObj(self);
        alertView.didSelectYouHuiQuanModelBlock = ^(LTSCYouHuiQuanModel *model) {
            selfWeak.currentModel = model;
            if (selfWeak.currentModel) {
                if (selfWeak.currentModel.isSelect) {
                    CGFloat youhuiP = (selfWeak.currentModel.type.intValue == 2 ? selfWeak.currentModel.reduce_money.doubleValue : selfWeak.currentModel.reduce_money.doubleValue);
                    if (selfWeak.allPrice > youhuiP) {
                        selfWeak.bottomView.moneyLabel.text = [NSString stringWithFormat:@"¥%.2f",self.allPrice - (selfWeak.currentModel.type.intValue == 2 ? selfWeak.currentModel.reduce_money.floatValue : selfWeak.currentModel.reduce_money.floatValue)];
                    } else {
                        selfWeak.currentModel = nil;
                        selfWeak.bottomView.moneyLabel.text = [NSString stringWithFormat:@"¥%.2f",self.allPrice];
                    }
                } else {
                    selfWeak.currentModel = nil;
                    selfWeak.bottomView.moneyLabel.text = [NSString stringWithFormat:@"¥%.2f",self.allPrice];
                }
            } else {
                selfWeak.currentModel = nil;
                selfWeak.bottomView.moneyLabel.text = [NSString stringWithFormat:@"¥%.2f",self.allPrice];
            }
            
            [selfWeak.tableView reloadSections:[NSIndexSet indexSetWithIndex:1 + self.dianpuArr.count] withRowAnimation:UITableViewRowAnimationFade];
        };
        [alertView show];
    } else if (indexPath.section == 2 + self.dianpuArr.count) {
        
    } else {
        if (self.dict) {
            //直接下单
            LTSCGoodsDetailVC *vc = [[LTSCGoodsDetailVC alloc] init];
            vc.goodsID = self.dianpuArr[indexPath.section - 1].goodList[indexPath.row].goodId;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            LTSCGoodsDetailVC *vc = [[LTSCGoodsDetailVC alloc] init];
            vc.goodsID = self.dianpuArr[indexPath.section - 1].goodList[indexPath.row].good_id;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

/**
 获取收货地址详情
 */
- (void)loadMorenAddress {
    [LTSCLoadingView show];
    
    NSMutableDictionary * dict = @{}.mutableCopy;
    dict[@"token"] = SESSION_TOKEN;
    
    [LTSCNetworking networkingPOST:address_detail parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [LTSCLoadingView dismiss];
        if ([responseObject[@"key"] integerValue] == 1000) {
            self.addressModel = [LTSCAddressListModel mj_objectWithKeyValues:responseObject[@"result"][@"data"]];
            [self.tableView reloadData];
        }else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [LTSCLoadingView dismiss];
    }];
}

/**
 购物车提交订单
 */
- (void)submitOrder {
    [self.view endEditing:YES];
    if (!self.addressModel.id) {
        [LTSCToastView showInFullWithStatus:@"请选择收货地址!"];
        return;
    }
    
    NSMutableArray *arr = [NSMutableArray array];
    for (LTSCShopCarDianPuModel *m in self.dianpuArr) {
        if (m.remark.isValid) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic[@"shopId"] = m.shopId;
            dic[@"remark"] = m.remark;
            [arr addObject:dic];
        }
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = SESSION_TOKEN;
    dict[@"cartIds"] = self.ids;
    dict[@"addressId"] = self.addressModel.id;
    dict[@"freight"] = @0;
    //couponId
    if (arr.count > 0) {
        NSString *remarks = [NSString convertToJsonData:arr];
        dict[@"remarks"] = remarks;
    }
    if (self.currentModel) {
        dict[@"couponId"] = self.currentModel.id;
    }
    [LTSCLoadingView show];
    [LTSCNetworking networkingPOST:settle_cart_order parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [LTSCLoadingView dismiss];
        if ([responseObject[@"key"] integerValue] == 1000) {
            LTSCSelectPayTypeVC *vc = [[LTSCSelectPayTypeVC alloc] init];
            vc.orderID = [NSString stringWithFormat:@"%@",responseObject[@"result"][@"map"][@"orderId"]];
            vc.orderCode = [NSString stringWithFormat:@"%@",responseObject[@"result"][@"map"][@"orderCode"]];
            vc.allPrice = [NSString stringWithFormat:@"%@",responseObject[@"result"][@"map"][@"price"]].floatValue;
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([responseObject[@"key"] integerValue] == 6522){
            
            self.xiaJiaArr = [LTSCGoodsDetailSUKModel mj_objectArrayWithKeyValuesArray:responseObject[@"result"][@"list"]];
            [self.tableView reloadData];
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
            
        }else {
           [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [LTSCLoadingView dismiss];
    }];
}

/**
 立即下单
 */
- (void)lijiXiadan {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.dict];
    if (self.dianpuArr[0].remark.isValid) {
        dic[@"remark"] = self.dianpuArr[0].remark;
    }
    if (self.currentModel) {
        dic[@"couponId"] = self.currentModel.id;
    }
    dic[@"freight"] = @0;
    dic[@"shopId"] = self.dianpuArr[0].shopId;
    [LTSCLoadingView show];
    [LTSCNetworking networkingPOST:settle_order parameters:dic returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [LTSCLoadingView dismiss];
        if ([responseObject[@"key"] integerValue] == 1000) {//直接购买 下单成功 立即到支付界面
            LTSCSelectPayTypeVC *vc = [[LTSCSelectPayTypeVC alloc] init];
            vc.orderID = [NSString stringWithFormat:@"%@",responseObject[@"result"][@"map"][@"orderId"]];
            vc.orderCode = [NSString stringWithFormat:@"%@",responseObject[@"result"][@"map"][@"orderCode"]];
            vc.allPrice = [NSString stringWithFormat:@"%@",responseObject[@"result"][@"map"][@"price"]].floatValue;
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([responseObject[@"key"] integerValue] == 6522){
            
            self.xiaJiaArr = [LTSCGoodsDetailSUKModel mj_objectArrayWithKeyValuesArray:responseObject[@"result"][@"list"]];
            [self.tableView reloadData];
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
            
        }else {
           [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [LTSCLoadingView dismiss];
    }];
}

@end

@interface LTSCSureOrderGoodsCell()<UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *imgView;//图片


@property (nonatomic, strong) UILabel *titleLabel;//标题

@property (nonatomic, strong) UILabel *guigeLabel;//规格

@property (nonatomic, strong) UILabel *moneyLabel;//价格

@property (nonatomic, strong) UILabel *numLabel;//数量

@property (nonatomic, strong) LTSCShopNumView *numView;//数量

@end
@implementation LTSCSureOrderGoodsCell

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
    [self addSubview:self.guigeLabel];
    [self addSubview:self.moneyLabel];
    [self addSubview:self.numLabel];
    [self addSubview:self.numView];
}

- (void)setConstrains {
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self).offset(15);
        make.width.height.equalTo(@90);
    }];
    
    [self.imgView addSubview:self.xiaJiaImgV];
    self.xiaJiaImgV.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.8];
    self.xiaJiaImgV.hidden = YES;
    [self.xiaJiaImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.right.bottom.equalTo(self.imgView);
    }];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView);
        make.trailing.equalTo(self).offset(-15);
        make.leading.equalTo(self.imgView.mas_trailing).offset(10);
    }];
    [self.guigeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(2);
        make.leading.equalTo(self.imgView.mas_trailing).offset(10);
        make.trailing.equalTo(self).offset(-20);
    }];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.imgView.mas_trailing).offset(10);
        make.bottom.equalTo(self.imgView);
    }];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.moneyLabel);
        make.trailing.equalTo(self).offset(-15);
    }];
    [self.numView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.moneyLabel);
        make.trailing.equalTo(self).offset(-15);
        make.width.equalTo(@110);
        make.height.equalTo(@30);
    }];
}

-(UIImageView *)xiaJiaImgV {
    if (_xiaJiaImgV == nil) {
        _xiaJiaImgV = [[UIImageView alloc] init];
        _xiaJiaImgV.image = [UIImage imageNamed:@"yixiajia"];
    }
    return _xiaJiaImgV;
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
        _titleLabel.font = [UIFont systemFontOfSize:14];
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
        _guigeLabel.font = [UIFont systemFontOfSize:13];
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

- (LTSCShopNumView *)numView {
    if (!_numView) {
        _numView = [[LTSCShopNumView alloc] init];
        [_numView.decButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_numView.incButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _numView.numTF.delegate = self;
    }
    return _numView;
}

- (void)btnClick:(UIButton *)btn {
    NSInteger num =  _numView.numTF.text.intValue;
    if (btn == _numView.decButton) {
        if (_numView.numTF.text.intValue > 1) {
            num --;
        }else {
            [LTSCToastView showInFullWithStatus:@"受不了了,不能再少了!"];
        }
    }else {
        num ++;
    }
    _numView.numTF.text = [NSString stringWithFormat:@"%ld", (long)num];
    self.goodsModel.num = _numView.numTF.text;
    if (self.refreshTableView) {
        self.refreshTableView(self.goodsModel);
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text.intValue <= 1) {
        _numView.numTF.text = @"1";
        [LTSCToastView showInFullWithStatus:@"至少购买一件商品!"];
    }
    self.goodsModel.num = _numView.numTF.text;
    if (self.refreshTableView) {
        self.refreshTableView(self.goodsModel);
    }
}

- (void)setGoodsModel:(LTSCGoodsDetailSUKModel *)goodsModel {
    _goodsModel = goodsModel;
    if (_goodsModel.isCart) {
        self.numView.hidden = NO;
        self.numLabel.hidden = YES;
    } else {
        self.numView.hidden = YES;
        self.numLabel.hidden = NO;
    }
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:_goodsModel.list_pic] placeholderImage:[UIImage imageNamed:@"blank"]];
    self.titleLabel.attributedText = _goodsModel.titleAtt;
    self.numLabel.text = [NSString stringWithFormat:@"X%@",_goodsModel.num];
    self.numView.numTF.text = [NSString stringWithFormat:@"%@",_goodsModel.num];
    self.moneyLabel.text = [NSString stringWithFormat:@"¥%.2f", _goodsModel.good_price.floatValue];
    if (_goodsModel.sku_id) {
        self.guigeLabel.hidden = NO;
        self.guigeLabel.attributedText = _goodsModel.contentAtt;
    }else {
        if (_goodsModel.properties && ![_goodsModel.properties isKong]) {
            self.guigeLabel.hidden = NO;
            self.guigeLabel.text = _goodsModel.yixuanStr;
        } else {
            self.guigeLabel.hidden = YES;
        }
    }
    
    [self layoutIfNeeded];
}

- (void)setDetailModel:(LTSCOrderDetailModel *)detailModel {
    _detailModel = detailModel;
    self.numView.hidden = YES;
    self.numLabel.hidden = NO;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:_detailModel.list_pic] placeholderImage:[UIImage imageNamed:@"blank"]];
    self.titleLabel.text = _detailModel.good_name;
    self.numLabel.text = [NSString stringWithFormat:@"X%@",_detailModel.num];
    self.moneyLabel.text = [NSString stringWithFormat:@"¥%.2f", _detailModel.good_price.floatValue];
    if (_detailModel.properties && ![_detailModel.properties isEqualToString:@""]) {
        self.guigeLabel.hidden = NO;
        self.guigeLabel.attributedText = _detailModel.yixuanAttStr;
    }else {
        self.guigeLabel.hidden = YES;
    }
    
}

@end


@interface LTSCSureOrderGoodsOtherCell()

@property (nonatomic, strong) UIView *lineView;

@end

@implementation LTSCSureOrderGoodsOtherCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.leftLabel];
        [self addSubview:self.rightLabel];
        [self addSubview:self.lineView];
        [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.centerY.equalTo(self);
        }];
        [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self).offset(-15);
            make.centerY.equalTo(self);
        }];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.trailing.equalTo(self);
            make.leading.equalTo(self).offset(15);
            make.height.equalTo(@1);
        }];
    }
    return self;
}

- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.textColor = CharacterDarkColor;
        _leftLabel.font = [UIFont systemFontOfSize:15];
    }
    return _leftLabel;
}

- (UILabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.textColor = CharacterDarkColor;
        _rightLabel.font = [UIFont systemFontOfSize:15];
    }
    return _rightLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

@end


@interface LTSCSureOrderBottomView()

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UIButton *submitBtn;//提交

@end
@implementation LTSCSureOrderBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.topView];
        [self.topView addSubview:self.moneyLabel];
        [self.topView addSubview:self.submitBtn];
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.trailing.leading.equalTo(self);
            make.height.equalTo(@50);
        }];
        [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.topView).offset(15);
            make.centerY.equalTo(self.topView);
        }];
        [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.trailing.bottom.equalTo(self.topView);
            make.width.equalTo(@120);
        }];
    }
    return self;
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [UIView new];
        _topView.backgroundColor = UIColor.whiteColor;
    }
    return _topView;
}

- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.textColor = MineColor;
        _moneyLabel.font = [UIFont systemFontOfSize:18];
    }
    return _moneyLabel;
}

- (UIButton *)submitBtn {
    if (!_submitBtn) {
        _submitBtn = [[UIButton alloc] init];
        [_submitBtn setBackgroundImage:[UIImage imageNamed:@"yellow"] forState:UIControlStateNormal];
        [_submitBtn setTitle:@"提交订单" forState:UIControlStateNormal];
        [_submitBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _submitBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_submitBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}

/**
 提交订单
 */
- (void)btnClick {
    if (self.submitOrderBlock) {
        self.submitOrderBlock();
    }
}

@end


@interface LTSCSureOrderYouhuiQuanCell ()

@property (nonatomic, strong) UIImageView *arrowImgView;
@property(nonatomic , strong)UIImageView *neiImageV;
@end

@implementation LTSCSureOrderYouhuiQuanCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.leftLabel];
        [self addSubview:self.rightLabel];
        [self addSubview:self.arrowImgView];
        [self addSubview:self.imagV];
        [self.imagV addSubview:self.neiImageV];
        [self.imagV addSubview:self.rightTwoLabel];
        [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.centerY.equalTo(self);
        }];
        [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.arrowImgView.mas_leading).offset(-10);
            make.centerY.equalTo(self);
        }];
        [self.arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self).offset(-15);
            make.centerY.equalTo(self);
            make.width.equalTo(@3.5);
            make.height.equalTo(@7.5);
        }];
        
        [self.imagV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-15);
            make.top.equalTo(self).offset(19.5);
            make.width.equalTo(@90);
            make.height.equalTo(@21);
        }];
        
        [self.neiImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imagV.mas_left).offset(10);
            make.top.equalTo(self.imagV.mas_top).offset(5.5);
            make.width.equalTo(@16);
            make.height.equalTo(@10);
        }];

//        [self.rightTwoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.leading.equalTo(self.imagV.mas_left).offset(31);
//            make.right.equalTo(self.imagV.mas_right).offset(-5);
//            make.top.bottom.equalTo(self.imagV);
//        }];
        
        
    }
    return self;
}

- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.textColor = CharacterDarkColor;
        _leftLabel.font = [UIFont systemFontOfSize:15];
    }
    return _leftLabel;
}

- (UILabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.textColor = [UIColor colorWithRed:251/255.0 green:53/255.0 blue:48/255.0 alpha:1.0];
        _rightLabel.font = [UIFont systemFontOfSize:15];
    }
    return _rightLabel;
}

-(UIImageView *)imagV {
    if (_imagV == nil) {
        _imagV = [[UIImageView alloc] init];
        _imagV.image =[UIImage imageNamed:@"yhj"];
        _imagV.layer.cornerRadius = 3;
        _imagV.clipsToBounds = YES;
    }
    return _imagV;
}

-(UIImageView *)neiImageV {
    if (_neiImageV == nil) {
        _neiImageV = [[UIImageView alloc] init];
        _neiImageV.image =[UIImage imageNamed:@"yhj1"];
    }
    return _neiImageV;
}

-(UILabel *)rightTwoLabel {
    if (_rightTwoLabel == nil) {
        _rightTwoLabel = [[UILabel alloc] initWithFrame:CGRectMake(31, 0, 55, 21)];
        _rightTwoLabel.font = [UIFont systemFontOfSize:12];
        _rightTwoLabel.textColor = [UIColor whiteColor];
    }
    return _rightTwoLabel;
}


- (UIImageView *)arrowImgView {
    if (!_arrowImgView) {
        _arrowImgView = [UIImageView new];
        _arrowImgView.image = [UIImage imageNamed:@"arrow_right"];
    }
    return _arrowImgView;
}

@end



