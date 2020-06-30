//
//  LTSCDianPuVC.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2020/4/8.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "LTSCDianPuVC.h"
#import "LTSCDianPuTopView.h"
#import "LTSCHomeTableSectionHeaderView.h"

#import "LTSCShopModel.h"
#import "LTSCGoodsDetailVC.h"
#import "LTSCLoginVC.h"
#import "LTSCSearchVC.h"
#import "LTSCDianPuSearchVC.h"
#import "LTSCDianPuYinXiangVC.h"
#import "LTSCKeFuTVC.h"

@interface LTSCDianPuVC ()<UITextFieldDelegate,UITabBarControllerDelegate>

@property (nonatomic, strong) LTSCDianPuTopView *topView;

@property (nonatomic, strong) NSMutableArray <LTSCChooseListModel *> *likeList;//人气商品

@property (nonatomic, strong) NSMutableArray <LTSCChooseListModel *> *moreList;//逛逛更多

@end

@implementation LTSCDianPuVC

- (LTSCDianPuTopView *)topView {
    if (!_topView) {
        _topView = [LTSCDianPuTopView new];
        [_topView.backButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
        [_topView.dianpuButton addTarget:self action:@selector(dianpuClick:) forControlEvents:UIControlEventTouchUpInside];
        [_topView.attentendButton addTarget:self action:@selector(attentionClick:) forControlEvents:UIControlEventTouchUpInside];
        _topView.searchView.searchTF.delegate = self;
        _topView.searchView.searchTF.userInteractionEnabled = NO;
        WeakObj(self);
        _topView.searchBlock = ^{
            LTSCSearchVC *vc = [[LTSCSearchVC alloc] init];
            vc.isDianPuSearch = YES;
            vc.shopId = selfWeak.shopID;
            BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
            //             nav.modalPresentationStyle = UIModalPresentationFullScreen;
            [selfWeak presentViewController:nav animated:NO completion:nil];
        };
        
    }
    return _topView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tabBarController.tabBar.hidden = NO;
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    //    self.tabBarController.tabBar.hidden = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initViews];
    
    self.likeList = [NSMutableArray array];
    self.moreList = [NSMutableArray array];
    [self loadLikeListData];
    [self loadMoreListData];
    
    WeakObj(self);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadLikeListData];
        [self loadMoreListData];
    }];
    
    [LTSCEventBus registerEvent:@"dianpuSearchClick" block:^(id data) {
        LTSCDianPuSearchVC *vc = [[LTSCDianPuSearchVC alloc] init];
        vc.keyWords = [NSString stringWithFormat:@"%@",data[@"searchWord"]];
        vc.shopId = [NSString stringWithFormat:@"%@",data[@"shopId"]];;
        vc.hidesBottomBarWhenPushed = YES;
        [selfWeak.navigationController pushViewController:vc animated:YES];
    }];
    
    self.tabBarController.delegate = self;
    
}

- (void)initViews {
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.size.equalTo(@(NavigationSpace + 80));
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.leading.trailing.bottom.equalTo(self.view);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3 + self.shopModel.hotGood.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        LTSCDianPuAttentionRankCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LTSCDianPuAttentionRankCell"];
        if (!cell) {
            cell = [[LTSCDianPuAttentionRankCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LTSCDianPuAttentionRankCell"];
        }
        cell.salesArr = self.shopModel.sales;
        cell.didSelectCellClickBlock = ^(LTSCShopSalesModel *model) {
            LTSCGoodsDetailVC *vc = [[LTSCGoodsDetailVC alloc] init];
            vc.goodsID = model.id;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        };
        return cell;
    } else if (indexPath.section == 1 + self.shopModel.hotGood.count) {
        LTSCHomeBaoKuanCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LTSCHomeBaoKuanCell"];
        if (!cell) {
            cell = [[LTSCHomeBaoKuanCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LTSCHomeBaoKuanCell"];
        }
        cell.backgroundColor = UIColor.clearColor;
        cell.collectionView.backgroundColor = UIColor.clearColor;
        cell.dataArr = self.likeList;
        cell.selectItemBlock = ^(LTSCChooseListModel *model) {
            LTSCGoodsDetailVC *vc = [[LTSCGoodsDetailVC alloc] init];
            vc.goodsID = model.id;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        };
        return cell;
    } else if (indexPath.section == 2 + self.shopModel.hotGood.count) {
        LTSCHomeBaoKuanCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LTSCHomeBaoKuanCell"];
        if (!cell) {
            cell = [[LTSCHomeBaoKuanCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LTSCHomeBaoKuanCell"];
        }
        cell.backgroundColor = UIColor.clearColor;
        cell.collectionView.backgroundColor = UIColor.clearColor;
        cell.dataArr = self.moreList;
        cell.selectItemBlock = ^(LTSCChooseListModel *model) {
            LTSCGoodsDetailVC *vc = [[LTSCGoodsDetailVC alloc] init];
            vc.goodsID = model.id;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        };
        return cell;
    }
    LTSCDianPuAttentionBaoKuanCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LTSCDianPuAttentionBaoKuanCell"];
    if (!cell) {
        cell = [[LTSCDianPuAttentionBaoKuanCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LTSCDianPuAttentionBaoKuanCell"];
    }
    [cell.imgView1 sd_setImageWithURL:[NSURL URLWithString:self.shopModel.hotGood[indexPath.section - 1].list_pic] placeholderImage:[UIImage imageNamed:@"789789"]];
    //    [cell.imgView2 sd_setImageWithURL:[NSURL URLWithString:self.shopModel.hotGood[indexPath.section - 1].list_pic] placeholderImage:[UIImage imageNamed:@"789789"]];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        LTSCDianPuAttentionRankView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"LTSCDianPuAttentionRankView"];
        if (!headerView) {
            headerView = [[LTSCDianPuAttentionRankView alloc] initWithReuseIdentifier:@"LTSCDianPuAttentionRankView"];
        }
        return headerView;
    } else if ((section == 2 + self.shopModel.hotGood.count) || (section == 1 + self.shopModel.hotGood.count)) {
        LTSCDianPuAttentionLikeView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"LTSCDianPuAttentionLikeView"];
        if (!headerView) {
            headerView = [[LTSCDianPuAttentionLikeView alloc] initWithReuseIdentifier:@"LTSCDianPuAttentionLikeView"];
        }
        headerView.titleLabel.text = section == 1 + self.shopModel.hotGood.count ? @"猜你喜欢" : @"逛逛更多商品";
        return headerView;
    } else {
        UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
        if (!headerView) {
            headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"UITableViewHeaderFooterView"];
        }
        return headerView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.shopModel.sales.count > 0) {
            return floor((ScreenW - 44)/3.0) + 60;
        }
        return 0;
    } else if (indexPath.section == 1 + self.shopModel.hotGood.count) {
        if (self.likeList.count > 0) {
            return (((ScreenW - 45)/2)+ 75 + 15) * ceil(self.likeList.count/2.0);
        }
        return 0.01;
    } else if (indexPath.section == 2 + self.shopModel.hotGood.count) {
        if (self.moreList.count > 0) {
            return (((ScreenW - 45)/2)+ 75 + 15) * ceil(self.moreList.count/2.0);
        }
        return 0.01;
    }
    return (ScreenW - 30) * 460/702;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (self.shopModel.sales.count > 0) {
            return 44;
        }
        return 0.01;
    } else if (section == 1 + self.shopModel.hotGood.count) {
        if (self.likeList.count > 0) {
            return 60;
        }
        return 0.01;
    } else if (section == 2 + self.shopModel.hotGood.count) {
        if (self.moreList.count > 0) {
            return 60;
        }
        
        return 0.01;
    }
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 0 && (indexPath.section != 1 + self.shopModel.hotGood.count) && (indexPath.section != 2 + self.shopModel.hotGood.count)) {
        LTSCGoodsDetailVC *vc = [[LTSCGoodsDetailVC alloc] init];
        vc.goodsID = self.shopModel.hotGood[indexPath.section - 1].id;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

/// 返回
- (void)backClick:(UIButton *)btn {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:NO completion:nil];
}
/// 跳转店铺主页
- (void)dianpuClick:(UIButton *)btn {
    LTSCDianPuYinXiangVC *vc = [LTSCDianPuYinXiangVC new];
    vc.shopId = self.shopID;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
/// 关注店铺
- (void)attentionClick:(UIButton *)btn {
    if (!SESSION_TOKEN) {
        LTSCLoginVC *vc = [[LTSCLoginVC alloc] init];
        vc.isDianpu = YES;
        BaseNavigationController * nav  = [[BaseNavigationController alloc] initWithRootViewController:vc];
        //         vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:nav animated:YES completion:nil];
        return;
    }
    [LTSCLoadingView show];
    WeakObj(self);
    [LTSCNetworking networkingPOST:followShop parameters:@{@"token" : SESSION_TOKEN, @"shopId" : self.shopID } returnClass:LTSCShopGoodsRootModel.class success:^(NSURLSessionDataTask *task, LTSCShopGoodsRootModel *responseObject) {
        [LTSCLoadingView dismiss];
        if (responseObject.key.intValue == 1000) {
            BOOL isf = selfWeak.shopModel.isFollow.boolValue;
            isf = !isf;
            selfWeak.shopModel.isFollow = [NSString stringWithFormat:@"%@", @(isf)];
            NSInteger num = selfWeak.shopModel.followNum.intValue;
            if (num > 0) {
                num = num;
            } else {
                num = 0;
            }
            if (isf) {
                num += 1;
                [LTSCToastView showSuccessWithStatus:@"店铺关注成功"];
            } else {
                num -= 1;
                [LTSCToastView showSuccessWithStatus:@"已取消店铺关注"];
            }
            selfWeak.shopModel.followNum = [NSString stringWithFormat:@"%ld", num];
            selfWeak.topView.shopModel = selfWeak.shopModel;
            [LTSCEventBus sendEvent:@"guanzhuAction" data:nil];
        } else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [LTSCLoadingView dismiss];
    }];
}
//搜索键
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    return YES;
}

- (void)setShopModel:(LTSCShopModel *)shopModel {
    _shopModel = shopModel;
    self.topView.shopModel = _shopModel;
    [self.tableView reloadData];
}

//猜你喜欢
- (void)loadLikeListData {
    if (self.likeList.count == 0) {
        [LTSCLoadingView show];
    }
    WeakObj(self);
    [LTSCNetworking networkingPOST:guessLike parameters:@{@"shopId" : self.shopID} returnClass:LTSCShopGoodsRootModel.class success:^(NSURLSessionDataTask *task, LTSCShopGoodsRootModel *responseObject) {
        [LTSCLoadingView dismiss];
        [self.tableView.mj_header endRefreshing];
        if (responseObject.key.intValue == 1000) {
            [selfWeak.likeList removeAllObjects];
            [selfWeak.likeList addObjectsFromArray:responseObject.result.list];
            [selfWeak.tableView reloadData];
        } else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [LTSCLoadingView dismiss];
        [self.tableView.mj_header endRefreshing];
    }];
    
}

//逛逛更多
- (void)loadMoreListData {
    if (self.moreList.count == 0) {
        [LTSCLoadingView show];
    }
    WeakObj(self);
    [LTSCNetworking networkingPOST:goMoreGoods parameters:@{@"shopId" : self.shopID} returnClass:LTSCShopGoodsRootModel.class success:^(NSURLSessionDataTask *task, LTSCShopGoodsRootModel *responseObject) {
        [LTSCLoadingView dismiss];
        [self.tableView.mj_header endRefreshing];
        if (responseObject.key.intValue == 1000) {
            [selfWeak.moreList removeAllObjects];
            [selfWeak.moreList addObjectsFromArray:responseObject.result.list];
            [selfWeak.tableView reloadData];
        } else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [LTSCLoadingView dismiss];
        [self.tableView.mj_header endRefreshing];
    }];
}


- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    BaseNavigationController * sectNavc = (BaseNavigationController *)self.tabBarController.selectedViewController;
    NSLog(@"====\n%@",[sectNavc.childViewControllers firstObject]);
    NSLog(@"-----\n%d",tabBarController.selectedIndex);
    BaseNavigationController * nav = (BaseNavigationController *)viewController;
    if ([[nav.childViewControllers firstObject] isKindOfClass:[LTSCKeFuTVC class]]) {
        
        BaseViewController * fvc = [sectNavc.childViewControllers firstObject];
        if  (!ISLOGIN) {
           [fvc presentViewController:[[BaseNavigationController alloc] initWithRootViewController:[LTSCLoginVC new]] animated:YES completion:nil];
            return NO;
        }else {
            EMChatViewController *chatController = [[EMChatViewController alloc] initWithConversationId:self.shopModel.shop_im_code type:EMConversationTypeChat createIfNotExist:YES];
            chatController.toUserHeadPic = self.shopModel.shop_pic;
            chatController.toUserName = self.shopModel.shop_name;
            
            fvc.hidesBottomBarWhenPushed = YES;
            [sectNavc pushViewController:chatController animated:YES];
            
            
            if ([LTSCTool ShareTool].userModel.imCode.length == 0) {
                [[LTSCTool ShareTool] getHuanXinCodeTwo];
            }
            
            
        }
        
        return NO;
        
    }
    return YES;
    
}

@end
