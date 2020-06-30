//
//  LTSCShopCarVC.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/15.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LTSCShopCarVC.h"
#import "LTSCShopCarCell.h"
#import "LTSCGuiGeView.h"
#import "LTSCSureOrderVC.h"
#import "LTSCGoodsDetailVC.h"
#import "LTSCOrderDetailVC.h"
#import "LTSCDianPuTabBarController.h"

@interface LTSCShopCarVC ()

@property (nonatomic, strong) LTSCShopCarBottomView *bottomView;//底部View

@property (nonatomic, strong) NSMutableArray <LTSCShopCarDianPuModel *> *dataArr;//数据

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, assign) CGFloat allPrice;

@property (nonatomic, strong) NSMutableDictionary *isSelectedDictionary;

@end

@implementation LTSCShopCarVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    if (!ISLOGIN || !SESSION_TOKEN) {
        self.bottomView.hidden = YES;
        self.rightButton.hidden = YES;
        self.noneView.loginButton.hidden = NO;
        WeakObj(self);
        self.noneView.loginButtonBlock = ^{
            [selfWeak gotoLogin];
        };
        [self.noneView showNoneDataViewAt:self.view img:[UIImage imageNamed:@"emptygwc"] tips:@"暂未登录, 登录即可查看购物车商品"];
    }else {
        self.page = 1;
        [self loadCarList];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
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

- (LTSCShopCarBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[LTSCShopCarBottomView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.hidden = YES;
    }
    return _bottomView;
}

- (void)saveSelectedDict {
    [NSUserDefaults.standardUserDefaults setObject:self.isSelectedDictionary forKey:@"isExiseDict"];
    [NSUserDefaults.standardUserDefaults synchronize];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"购物车";
    self.view.backgroundColor =  [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    self.isSelectedDictionary = [NSMutableDictionary dictionary];
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"isExiseDict"];
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        [self.isSelectedDictionary addEntriesFromDictionary:dict];
    }
    
    self.tableView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    self.tableView.separatorColor  = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    self.dataArr = [NSMutableArray array];
    [self initNav];
    [self initBottomView];
    WeakObj(self);
    [LTSCEventBus registerEvent:@"addCarSuccess" block:^(id data) {
        selfWeak.page = 1;
        [selfWeak loadCarList];
    }];
    [LTSCEventBus registerEvent:@"settleOrderSuccess" block:^(id data) {
        selfWeak.page = 1;
        [selfWeak loadCarList];
 
    }];
    
    
    self.tableView.mj_header = [LTSCRefreshHeader headerWithRefreshingBlock:^{
        selfWeak.page = 1;
        [selfWeak loadCarList];
    }];
    
    [LTSCEventBus registerEvent:@"backHomeVC" block:^(id data) {
        
        NSInteger aa = selfWeak.tabBarController.selectedIndex;
        selfWeak.tabBarController.selectedIndex = 0;
        [selfWeak.tabBarController.tabBar layoutSubviews];
    }];
    
    [self.bottomView.jiesuanButton addTarget:self action:@selector(bottomViewAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView.allSelectButton addTarget:self action:@selector(allSelectClick:) forControlEvents:UIControlEventTouchUpInside];
    [LTSCEventBus registerEvent:@"seeOrder" block:^(id data) {
        if ([[NSString stringWithFormat:@"%@", data[@"orderType"]] intValue] == 1) {
            LTSCMyOrderVC *vc = [[LTSCMyOrderVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [selfWeak.navigationController pushViewController:vc animated:YES];
        }if ([[NSString stringWithFormat:@"%@", data[@"orderType"]] intValue] == 2){
            LTSCOrderDetailVC *vc = [[LTSCOrderDetailVC alloc] initWithTableViewStyle:UITableViewStyleGrouped];
            vc.orderID = [NSString stringWithFormat:@"%@", data[@"orderID"]];
            vc.hidesBottomBarWhenPushed = YES;
            [selfWeak.navigationController pushViewController:vc animated:YES];
        }
    }];
    
    self.noneView.clickBlock = ^{
        selfWeak.page = 1;
        [selfWeak loadCarList];
    };
    
    [LTSCEventBus registerEvent:@"loginSuccess" block:^(id data) {
        self.page = 1;
        [self loadCarList];
    }];
    
    self.page = 1;
    [self loadCarList];
    
}

- (void)initNav {
    self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [self.rightButton setTitle:@"编辑" forState:UIControlStateNormal];
    [self.rightButton setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
    self.rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.rightButton addTarget:self action:@selector(editClick:) forControlEvents:UIControlEventTouchUpInside];
    self.rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    self.navigationItem.rightBarButtonItem = item;
}
/**
 初始化底部view
 */
- (void)initBottomView {
    [self.view addSubview:self.bottomView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (kDevice_Is_iPhoneX) {
            if (self.isTabarVC) {
                make.bottom.equalTo(self.view);
            } else {
                make.bottom.equalTo(self.view).offset(-TableViewBottomSpace);
            }
        } else {
            make.bottom.equalTo(self.view);
        }
        make.leading.trailing.equalTo(self.view);
        make.height.equalTo(@50);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr[section].goodList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LTSCShopCarCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[LTSCShopCarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LTSCShopCarCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    LTSCGoodsDetailSUKModel *model = self.dataArr[indexPath.section].goodList[indexPath.row];
    cell.model = model;
    WeakObj(self);
    cell.guigeClickBlock = ^(LTSCGoodsDetailSUKModel *model) {
        if (!model.rootModel) {
            [LTSCLoadingView show];
        }
        [selfWeak loadDetailDataWithSKUModel:model completed:^(LTSCGoodsDetailRootModel *rootModel) {
            [LTSCLoadingView dismiss];
            if (rootModel && rootModel.result.map.guideList.count > 0) {
                LTSCGuiGeView *guigeView = [[LTSCGuiGeView alloc] initWithFrame:UIScreen.mainScreen.bounds];
                guigeView.goodsModel = rootModel.result.map.detail;
                guigeView.guigeArr = rootModel.result.map.guideList;
                guigeView.skuArr = rootModel.result.map.skuList;
                [guigeView show];
                [guigeView reloadData];
                [guigeView updateCurrentSelectedModel:model];
                __weak LTSCGuiGeView *weak_guigeView = guigeView;
                guigeView.sureBlock = ^(LTSCGoodsDetailSUKModel *currentModel, NSInteger num) {
                    [self modifyCar:@(num).stringValue model:currentModel carModel:model];
                    [weak_guigeView dismiss];
                };
            } else {
                [LTSCToastView showErrorWithStatus:@"商品信息加载失败"];
            }
        }];
    };
    
    cell.selectModelBlock = ^(LTSCGoodsDetailSUKModel *model, NSString *numStr) {
        model.isSelect = !model.isSelect;
        selfWeak.allPrice = 0;
        NSInteger count = 0;
        NSInteger countNum = 0;
        for (LTSCShopCarDianPuModel *m in selfWeak.dataArr) {
            CGFloat count0 = 0;
            for (LTSCGoodsDetailSUKModel *tempM in m.goodList) {
                if (tempM.isSelect) {
                    count0 ++;
                    countNum ++;
                    selfWeak.allPrice += tempM.good_price.floatValue * tempM.num.intValue;
                }
            }
            m.isSelect = count0 == m.goodList.count;
            if (m.isSelect) {
                count ++;
            }
        }
        selfWeak.bottomView.allSelectButton.selected = count == selfWeak.dataArr.count;
        selfWeak.bottomView.allPrice.text = [NSString stringWithFormat:@"¥%.2f", self.allPrice];
        if ([selfWeak.rightButton.titleLabel.text isEqualToString:@"编辑"]) {//结算
            [selfWeak.bottomView.jiesuanButton setTitle:[NSString stringWithFormat:@"结算(%ld)", (long)countNum] forState:UIControlStateNormal];
        }else {//删除
            
        }
        
        [selfWeak.tableView reloadData];
    };
    cell.modifyCarSuccess = ^(LTSCGoodsDetailSUKModel *model) {//购物车更新数量
        selfWeak.allPrice = 0;
        NSInteger count = 0;
        NSInteger count0 = 0;
        for (LTSCShopCarDianPuModel *model in self.dataArr) {
            for (LTSCGoodsDetailSUKModel *m in model.goodList) {
                if (m.isSelect) {
                    selfWeak.allPrice += m.good_price.floatValue * m.num.intValue;
                    count0 ++;
                }
            }
            if (model.isSelect) {
                count ++;
            }
        }
        selfWeak.bottomView.allPrice.text = [NSString stringWithFormat:@"¥%.2f", self.allPrice];
        selfWeak.bottomView.allSelectButton.selected = count == selfWeak.dataArr.count;
        if ([selfWeak.rightButton.titleLabel.text isEqualToString:@"编辑"]) {//结算
            [selfWeak.bottomView.jiesuanButton setTitle:[NSString stringWithFormat:@"结算(%ld)", count0] forState:UIControlStateNormal];
        } else {//删除
            
        }
    };
    return cell;
}

- (void)peiMoney {
    
    self.allPrice = 0;
    NSInteger count = 0;
    NSInteger countNum = 0;
    for (LTSCShopCarDianPuModel *m in self.dataArr) {
        CGFloat count0 = 0;
        for (LTSCGoodsDetailSUKModel *tempM in m.goodList) {
            if (tempM.isSelect) {
                count0 ++;
                countNum ++;
                self.allPrice += tempM.good_price.floatValue * tempM.num.intValue;
            }
        }
        m.isSelect = count0 == m.goodList.count;
        if (m.isSelect) {
            count ++;
        }
    }
    self.bottomView.allSelectButton.selected = count == self.dataArr.count;
    self.bottomView.allPrice.text = [NSString stringWithFormat:@"¥%.2f", self.allPrice];
    if ([self.rightButton.titleLabel.text isEqualToString:@"编辑"]) {//结算
        [self.bottomView.jiesuanButton setTitle:[NSString stringWithFormat:@"结算(%ld)", (long)countNum] forState:UIControlStateNormal];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    LTSCShopCarHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"LTSCShopCarHeaderView"];
    if (!headerView) {
        headerView = [[LTSCShopCarHeaderView alloc] initWithReuseIdentifier:@"LTSCShopCarHeaderView"];
    }
    headerView.model = self.dataArr[section];
    WeakObj(self);
    headerView.didSelectDianpuBlock = ^(LTSCShopCarDianPuModel *model) {
        LTSCDianPuTabBarController *tabVC = [LTSCDianPuTabBarController new];
        tabVC.shopId = model.shopId;
        //        tabVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [selfWeak presentViewController:tabVC animated:NO completion:nil];
    };
    headerView.didSelectDianpuAllGoodsBlock = ^(LTSCShopCarDianPuModel *model) {
        model.isSelect = !model.isSelect;
        for (LTSCGoodsDetailSUKModel *m in model.goodList) {
            m.isSelect = model.isSelect;
        }
        NSInteger count = 0;
        NSInteger count0 = 0;
        selfWeak.allPrice = 0;
        for (LTSCShopCarDianPuModel *tempM in selfWeak.dataArr) {
            if (tempM.isSelect) {
                count ++;
                for (LTSCGoodsDetailSUKModel *m0 in tempM.goodList) {
                    if (m0.isSelect) {
                        count0 ++;
                        selfWeak.allPrice += m0.good_price.floatValue * m0.num.intValue;
                    }
                }
            }
        }
        selfWeak.bottomView.allPrice.text = [NSString stringWithFormat:@"¥%.2f", self.allPrice];
        selfWeak.bottomView.allSelectButton.selected = count == selfWeak.dataArr.count;
        if ([selfWeak.rightButton.titleLabel.text isEqualToString:@"编辑"]) {//结算
            [selfWeak.bottomView.jiesuanButton setTitle:[NSString stringWithFormat:@"结算(%ld)", count0] forState:UIControlStateNormal];
        }else {//删除
            
        }
        
        [selfWeak.tableView reloadData];
        
    };
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.dataArr[section].goodList.count == 0) {
        return 0.01;
    }
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LTSCGoodsDetailSUKModel *model = self.dataArr[indexPath.section].goodList[indexPath.row];
    return model.cellheight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LTSCGoodsDetailSUKModel *model = self.dataArr[indexPath.section].goodList[indexPath.row];
    LTSCGoodsDetailVC *vc = [[LTSCGoodsDetailVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.goodsID = model.goodId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {//删除购物车
    LTSCGoodsDetailSUKModel *model = self.dataArr[indexPath.section].goodList[indexPath.row];
    [self deleteCart:model isHide:NO];
}

- (void)editClick:(UIButton *)btn {
    //编辑
    btn.selected = !btn.selected;
    if (btn.selected) {
        [self.rightButton setTitle:@"完成" forState:UIControlStateNormal];
        [self.bottomView.jiesuanButton setTitle:@"删除" forState:UIControlStateNormal];
        self.bottomView.allPrice.hidden = YES;
    }else {
        [self.rightButton setTitle:@"编辑" forState:UIControlStateNormal];
        [self.bottomView.jiesuanButton setTitle:@"结算" forState:UIControlStateNormal];
        self.bottomView.allPrice.hidden = NO;
        [self peiMoney];
        
    }
}

/**
 修改购物车
 */
- (void)modifyCar:(NSString *)numStr model:(LTSCGoodsDetailSUKModel *)model carModel:(LTSCGoodsDetailSUKModel *)carModel {
    [LTSCLoadingView show];
    [LTSCNetworking networkingPOST:up_cart parameters:@{@"token":SESSION_TOKEN, @"num":numStr, @"id":carModel.id, @"skuId":model.id, @"goodId":model.goodId} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [LTSCLoadingView dismiss];
        if ([responseObject[@"key"] integerValue] == 1000) {
            bool ishave = NO;
            LTSCGoodsDetailSUKModel *tempM = nil;
            LTSCGoodsDetailSUKModel *tempM1 = nil;
            LTSCShopCarDianPuModel *delM = nil;
            for (LTSCShopCarDianPuModel *m in self.dataArr) {
                for (LTSCGoodsDetailSUKModel *m0 in m.goodList) {
                    if (m0.id.intValue == carModel.id.intValue) {
                        //找到当前修改对象
                        tempM = m0;
                    }
                    if (m0.good_id.intValue == model.goodId.intValue && m0.sku_id.intValue == model.id.intValue) {
                        delM = m;
                        tempM1 = m0;
                        ishave = YES;
                    }
                }
            }
            if (ishave) {
                tempM1.num = [NSString stringWithFormat:@"%d", carModel.num.intValue + tempM1.num.intValue];
                NSMutableArray *goods = [NSMutableArray arrayWithArray:delM.goodList];
                if ([goods containsObject:tempM]) {
                    [goods removeObject:tempM];
                }
                delM.goodList = goods;
            } else {
                tempM.contentAtt = [[NSMutableAttributedString alloc] initWithString:[model.yixuanStr stringByReplacingOccurrencesOfString:tempM.good_name withString:@""]];;
                tempM.properties = model.properties;
            }
            //            [self.tableView reloadData];
            
            self.page = 1;
            [self loadCarList];
            
        }else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [LTSCLoadingView dismiss];
    }];
}

/**
 修改购物车
 */
- (void)modifyCarModel:(LTSCGoodsDetailSUKModel *)carModel {
    [LTSCNetworking networkingPOST:up_cart parameters:@{@"token":SESSION_TOKEN, @"num":carModel.num, @"id":carModel.id, @"skuId":carModel.sku_id, @"goodId":carModel.goodId} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}


/**
 获取详情
 */
- (void)loadDetailDataWithSKUModel:(LTSCGoodsDetailSUKModel *)model completed:(void(^)(LTSCGoodsDetailRootModel *rootModel))completedBlock {
    if (!model) {
        if (completedBlock) {
            completedBlock(nil);
        }
        return;
    }
    if (model.rootModel) {
        if (completedBlock) {
            completedBlock(model.rootModel);
        }
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (SESSION_TOKEN) {
        dict[@"token"] = SESSION_TOKEN;
    }
    dict[@"id"] = model.goodId;
    [LTSCNetworking networkingPOST:good_detail parameters:dict returnClass:[LTSCGoodsDetailRootModel class] success:^(NSURLSessionDataTask *task, LTSCGoodsDetailRootModel *responseObject) {
        if (responseObject.key.integerValue == 1000) {
            model.rootModel = responseObject;
            if (completedBlock) {
                completedBlock(model.rootModel);
            }
        } else {
            if (completedBlock) {
                completedBlock(nil);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (completedBlock) {
            completedBlock(nil);
        }
    }];
}

/*
 * 获取购物车列表
 */
- (void)loadCarList {
    if (ISLOGIN && SESSION_TOKEN) {
        [LTSCLoadingView show];
        WeakObj(self);
        [LTSCNetworking networkingPOST:cartList parameters:@{@"token" : SESSION_TOKEN, @"pageNum":@(self.page), @"pageSize" : @1000} returnClass:[LTSCShopCarRootModel class] success:^(NSURLSessionDataTask *task, LTSCShopCarRootModel *responseObject) {
            [selfWeak endRefrish];
            if (responseObject.key.intValue == 1000) {
                if (selfWeak.page == 1) {
                    [selfWeak.dataArr removeAllObjects];
                }
                if (selfWeak.page <= responseObject.result.allPageNumber.intValue) {
                    [selfWeak.dataArr addObjectsFromArray:responseObject.result.list];
                }
                selfWeak.bottomView.hidden = selfWeak.dataArr.count == 0;
                selfWeak.page ++;
                [selfWeak.tableView reloadData];
                [self peiMoney];
                
            }else {
                [UIAlertController showAlertWithmessage:responseObject.message];
            }
            if (selfWeak.dataArr.count <= 0) {
                [selfWeak.noneView showNoneDataViewAt:selfWeak.view img:[UIImage imageNamed:@"emptygwc"] tips:@"你的购物车空空如也"];
            } else {
                [selfWeak.noneView dismiss];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [self endRefrish];
            if (self.dataArr.count <= 0) {
                [self.noneView showNoneNetViewAt:self.view];
            } else {
                [self.noneView dismiss];
            }
        }];
    } else {
        self.bottomView.hidden = YES;
        self.rightButton.hidden = YES;
        self.noneView.loginButton.hidden = NO;
        WeakObj(self);
        self.noneView.loginButtonBlock = ^{
            [selfWeak gotoLogin];
        };
        [self.noneView showNoneDataViewAt:self.view img:[UIImage imageNamed:@"emptygwc"] tips:@"暂未登录, 登录即可查看购物车商品"];
    }
    
}


/**
 删除购物车
 */
- (void)deleteCart:(LTSCGoodsDetailSUKModel *)model isHide:(BOOL)hide {
    
    UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:@"是否确认删除?" preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if (!hide) {
            [LTSCLoadingView show];
        }
        WeakObj(self);
        [LTSCNetworking networkingPOST:del_cart parameters:@{@"token":SESSION_TOKEN,@"idStr":model.id} returnClass:[LTSCShopCarRootModel class] success:^(NSURLSessionDataTask *task, LTSCShopCarRootModel *responseObject) {
            if (!hide) {
                [LTSCLoadingView dismiss];
                if (responseObject.key.intValue == 1000) {
                    for (LTSCShopCarDianPuModel *m in self.dataArr) {
                        for (LTSCGoodsDetailSUKModel *m0 in m.goodList) {
                            if (m0.good_id.intValue == model.good_id.intValue && m0.sku_id.intValue == model.sku_id.intValue) {
                                NSMutableArray *goods = [NSMutableArray arrayWithArray:m.goodList];
                                if ([goods containsObject:model]) {
                                    [goods removeObject:model];
                                }
                                m.goodList = goods;
                                break;
                            }
                        }
                    }
                    NSInteger count = 0;
                    for (LTSCShopCarDianPuModel *mm in selfWeak.dataArr) {
                        if (mm.goodList.count > 0) {
                            count ++;
                        }
                    }
                    selfWeak.bottomView.hidden = count == 0;
                    if (count == 0) {
                        [selfWeak.noneView showNoneDataViewAt:self.view img:[UIImage imageNamed:@"emptygwc"] tips:@"你的购物车空空如也"];
                    } else {
                        [selfWeak.noneView dismiss];
                    }
                    [selfWeak.tableView reloadData];
                }else {
                    [UIAlertController showAlertWithmessage:responseObject.message];
                }
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [LTSCLoadingView dismiss];
        }];
    }]];
    [self presentViewController:alertView animated:YES completion:nil];
}

/**
 底部按钮 结算或删除操作
 */
- (void)bottomViewAction {
    NSMutableArray *tempArr = [NSMutableArray array];
    NSMutableArray *ids = [NSMutableArray array];
    NSMutableArray *resultArr = [NSMutableArray array];
    
    NSArray *dictArray = [LTSCShopCarDianPuModel mj_keyValuesArrayWithObjectArray:self.dataArr];
    NSArray<LTSCShopCarDianPuModel *> *tempDataArr = [LTSCShopCarDianPuModel mj_objectArrayWithKeyValuesArray:dictArray];
    
    for (LTSCShopCarDianPuModel *model in tempDataArr) {
        NSMutableArray *tempArr0 = [NSMutableArray array];
        for (LTSCGoodsDetailSUKModel *m in model.goodList) {
            if (m.isSelect) {
                [tempArr addObject:m];
                [tempArr0 addObject:m];
                [ids addObject:m.id];
            }
        }
        if (tempArr0.count != 0) {
            model.goodList = tempArr0;
            [resultArr addObject:model];
        }
    }
    if (tempArr.count == 0) {
        [LTSCToastView showInFullWithStatus :@"您还没有选择宝贝哦!"];
        return;
    }
    if ([self.rightButton.titleLabel.text isEqualToString:@"编辑"]) {//结算
        [self settleCarOrder:[ids componentsJoinedByString:@","] selectArr:tempArr dataArr:resultArr];
    }else {//删除
        UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:@"是否确认删除?" preferredStyle:UIAlertControllerStyleAlert];
        [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self deleteCartswithIds:[ids componentsJoinedByString:@","] dataArr1:tempArr];
        }]];
        [self presentViewController:alertView animated:YES completion:nil];
    }
}
//删除多个商品
- (void)deleteCartswithIds:(NSString *)ids dataArr1:(NSMutableArray *)dataArr1 {
    
    WeakObj(self);
    [LTSCLoadingView show];
    [LTSCNetworking networkingPOST:del_cart parameters:@{@"token":SESSION_TOKEN,@"idStr":ids} returnClass:[LTSCShopCarRootModel class] success:^(NSURLSessionDataTask *task, LTSCShopCarRootModel *responseObject) {
        [LTSCLoadingView dismiss];
        if (responseObject.key.intValue == 1000) {
            for (LTSCGoodsDetailSUKModel *m in dataArr1) {
                for (LTSCShopCarDianPuModel *m0 in self.dataArr) {
                    for (LTSCGoodsDetailSUKModel *m1 in m0.goodList) {
                        if (m1.good_id.intValue == m.good_id.intValue && m1.sku_id.intValue == m.sku_id.intValue) {
                            NSMutableArray *goods = [NSMutableArray arrayWithArray:m0.goodList];
                            if ([goods containsObject:m1]) {
                                [goods removeObject:m1];
                            }
                            m0.goodList = goods;
                        }
                    }
                }
            }
            NSInteger count = 0;
            for (LTSCShopCarDianPuModel *mm in selfWeak.dataArr) {
                if (mm.goodList.count > 0) {
                    count ++;
                }
            }
            selfWeak.bottomView.hidden = count == 0;
            if (count == 0) {
                [selfWeak.noneView showNoneDataViewAt:self.view img:[UIImage imageNamed:@"emptygwc"] tips:@"你的购物车空空如也"];
            } else {
                [selfWeak.noneView dismiss];
            }
            [selfWeak.tableView reloadData];
        }else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [LTSCLoadingView dismiss];
    }];
}

/**
 购物车全选操作
 */
- (void)allSelectClick:(UIButton *)btn {
    btn.selected = !btn.selected;
    WeakObj(self);
    self.allPrice = 0;
    NSInteger count = 0;
    for (LTSCShopCarDianPuModel *m in self.dataArr) {
        if (btn.selected) {
            m.isSelect = YES;
            
        } else {
            m.isSelect = NO;
        }
        for (LTSCGoodsDetailSUKModel *tempM in m.goodList) {
            tempM.isSelect = m.isSelect;
            if (tempM.isSelect) {
                count ++;
                selfWeak.allPrice += tempM.good_price.floatValue * tempM.num.intValue;
            }
        }
    }
    [self.tableView reloadData];
    self.bottomView.allPrice.text = [NSString stringWithFormat:@"¥%.2f", self.allPrice];
    if ([selfWeak.rightButton.titleLabel.text isEqualToString:@"编辑"]) {//结算
        if (count == 0) {
            [selfWeak.bottomView.jiesuanButton setTitle:@"结算" forState:UIControlStateNormal];
        }else {
            [selfWeak.bottomView.jiesuanButton setTitle:[NSString stringWithFormat:@"结算(%ld)", (long)count] forState:UIControlStateNormal];
        }
        
    }else {//删除
        
    }
}

/**
 购物车结算下单
 */
- (void)settleCarOrder:(NSString *)ids selectArr:(NSMutableArray *)selectArray dataArr:(NSMutableArray *)dataArr{
    LTSCSureOrderVC *vc = [[LTSCSureOrderVC alloc] initWithTableViewStyle:UITableViewStyleGrouped];
    vc.ids = ids;
    vc.dataArr = selectArray;
    vc.allPrice = self.allPrice;
    vc.dianpuArr = dataArr;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 登录
 */
- (void)loginButtonClick {
    [self gotoLogin];
}

@end

@interface LTSCShopCarBottomView()

@property (nonatomic, strong) UIView *lineView;//线

@property (nonatomic, strong) UIView *lineView1;//线

@end
@implementation LTSCShopCarBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
        [self setConstrains];
    }
    return self;
}

/**
 添加视图
 */
- (void)initSubviews {
    [self addSubview:self.lineView];
    [self addSubview:self.allSelectButton];
    [self addSubview:self.allPrice];
    [self addSubview:self.jiesuanButton];
    [self addSubview:self.lineView1];
}

/**
 设置约束
 */
- (void)setConstrains {
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self);
        make.height.equalTo(@0.5);
    }];
    [self.allSelectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom);
        make.leading.equalTo(self);
        make.width.equalTo(@100);
        make.bottom.equalTo(self.lineView1.mas_top);
    }];
    [self.allPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom);
        make.leading.equalTo(self.allSelectButton.mas_trailing);
        make.bottom.equalTo(self.lineView1.mas_top);
        make.trailing.equalTo(self.jiesuanButton.mas_leading).offset(-10);
    }];
    [self.jiesuanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom);
        make.trailing.equalTo(self);
        make.bottom.equalTo(self.lineView1.mas_top);
        make.width.equalTo(@100);
    }];
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.equalTo(self);
        make.height.equalTo(@0.5);
    }];
}

- (UIButton *)allSelectButton {
    if (!_allSelectButton) {
        _allSelectButton = [[UIButton alloc] init];
        [_allSelectButton setImage:[UIImage imageNamed:@"selcet_n"] forState:UIControlStateNormal];
        [_allSelectButton setImage:[UIImage imageNamed:@"selcet_y"] forState:UIControlStateSelected];
        _allSelectButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
        [_allSelectButton setTitle:@"全选" forState:UIControlStateNormal];
        [_allSelectButton setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
        _allSelectButton.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _allSelectButton;
}

- (UILabel *)allPrice {
    if (!_allPrice) {
        _allPrice = [[UILabel alloc] init];
        _allPrice.textColor = MineColor;
        _allPrice.textAlignment = NSTextAlignmentRight;
        _allPrice.font = [UIFont systemFontOfSize:15];
        _allPrice.text = @"合计: ¥0.00";
    }
    return _allPrice;
}

- (UIButton *)jiesuanButton {
    if (!_jiesuanButton) {
        _jiesuanButton = [[UIButton alloc] init];
        [_jiesuanButton setBackgroundImage:[UIImage imageNamed:@"yellow"] forState:UIControlStateNormal];
        [_jiesuanButton setTitle:@"结算" forState:UIControlStateNormal];
        [_jiesuanButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _jiesuanButton.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _jiesuanButton;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [LineColor colorWithAlphaComponent:0.5];
    }
    return _lineView;
}

- (UIView *)lineView1 {
    if (!_lineView1) {
        _lineView1 = [[UIView alloc] init];
        _lineView1.backgroundColor = [LineColor colorWithAlphaComponent:0.5];
    }
    return _lineView1;
}

@end
