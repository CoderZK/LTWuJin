//
//  LTSCHomeVC.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/15.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LTSCHomeVC.h"
#import "LTSCBianMinItemView.h"
#import "LTSCPublicModel.h"
#import "LTSCHomeTableSectionHeaderView.h"
#import "LTSCSearchVC.h"
#import "LTSCTitleView.h"
#import "LTSCGoodsDetailVC.h"
#import "LTSCCateListVC.h"
#import "LTSCReQiYanXuanVC.h"
#import "LTSCBaoKuanTuiJianVC.h"
#import "LTSCAqListVC.h"
#import "LTSCLoadingView.h"
#import "LTSCChargeCenterVC.h"
#import "LTSCWebViewController.h"
#import "LTSCLoginVC.h"

@interface LTSCHomeVC ()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) UIImageView *bgImgView;//顶部背景图

@property (nonatomic, strong) LTSCTitleView *titleView;

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) SDCycleScrollView *bannerView;

@property (nonatomic, strong) UIImageView *bannerImgView;//顶部背景图


@property (nonatomic , strong) LTSCBianMinItemView * itemView;//首页模块儿

@property (nonatomic, strong) NSMutableArray <LTSCYouHuiQuanModel *>*youhuiquanArr;//优惠券数据

@property (nonatomic, strong) NSMutableArray <LTSCPublicModel *>*itemArr;//item模块数据

@property (nonatomic, strong) NSMutableArray <LTSCChooseListModel *>*hotList;//爆款

@property (nonatomic, strong) NSMutableArray <LTSCChooseListModel *>*chooseList;//人气严选

@property (nonatomic, strong) NSMutableArray <LTSCHomeQuestionModel *>*questionArr;//问答模块数据model;

@property (nonatomic , strong) NSMutableArray <LTSCHomeBannerModel *>*bannerArr;//首页模块儿

@property (nonatomic, strong) NSMutableArray <LTSCCateModel *>*secondDataArr;

@property (nonatomic, strong) LTSCHomeMoreButtonView *moreButtonView;

@end

@implementation LTSCHomeVC

- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [UIImageView new];
        _bgImgView.image = [UIImage imageNamed:@"shouye_bg"];
        _bgImgView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImgView.layer.masksToBounds = YES;
    }
    return _bgImgView;
}

- (UIImageView *)bannerImgView {
    if (!_bannerImgView) {
        _bannerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 83)];
        _bannerImgView.image = [UIImage imageNamed:@"shouye_bg2"];
        _bannerImgView.contentMode = UIViewContentModeScaleAspectFill;
        _bannerImgView.layer.masksToBounds = YES;
    }
    return _bannerImgView;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = UIColor.whiteColor;
    }
    return _bgView;
}

- (LTSCHomeMoreButtonView *)moreButtonView {
    if (!_moreButtonView) {
        _moreButtonView = [[LTSCHomeMoreButtonView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 60)];
        [_moreButtonView addTarget:self action:@selector(bottomButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreButtonView;
}

- (LTSCTitleView *)titleView {
    if (!_titleView) {
        _titleView = [[LTSCTitleView alloc] initWithFrame:CGRectMake(0, 0, ScreenW - 30, 30)];
        _titleView.searchView.bgButton.backgroundColor = [UIColor whiteColor];
    }
    return _titleView;
}

- (SDCycleScrollView *)bannerView {
    if (!_bannerView) {
        _bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(15, 0, ScreenW - 30, 150) delegate:self placeholderImage:[UIImage imageNamed:@"banner"]];
        _bannerView.layer.cornerRadius = 10;
        _bannerView.layer.masksToBounds = YES;
        _bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _bannerView.delegate = self;
        _bannerView.pageDotImage = [UIImage imageNamed:@"banner_2"];
        _bannerView.currentPageDotImage = [UIImage imageNamed:@"banner_1"];
        _bannerView.autoScrollTimeInterval = 3;// 自定义轮播时间间隔
    }
    return _bannerView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.navigationController.navigationBar setBarTintColor:MineColor];
 
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     [self.navigationController setNavigationBarHidden:NO animated:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setBarTintColor:UIColor.whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = UIColor.clearColor;
    self.itemArr = [NSMutableArray array];
    self.bannerArr = [NSMutableArray array];
    self.hotList = [NSMutableArray array];
    self.chooseList = [NSMutableArray array];
    self.questionArr = [NSMutableArray array];
    self.secondDataArr = [NSMutableArray array];
    self.youhuiquanArr = [NSMutableArray array];
    [self initView];
    [self initHeaderView];
    WeakObj(self);
    [LTSCEventBus registerEvent:@"backHomeVC" block:^(id data) {
         
         NSInteger aa = selfWeak.tabBarController.selectedIndex;
        selfWeak.navigationController.tabBarController.selectedIndex = 0;
//        [selfWeaktabBarController.tabBar layoutIfNeeded];
     }];

    self.tableView.tableFooterView = self.moreButtonView;
    self.titleView.searchBlock = ^{
        LTSCSearchVC *vc = [[LTSCSearchVC alloc] init];
        vc.isHome = YES;
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
        [selfWeak presentViewController:nav animated:NO completion:nil];
    };

    [LTSCEventBus registerEvent:@"homeSearchClick" block:^(id data) {
        LTSCCateListVC *vc = [[LTSCCateListVC alloc] init];
        vc.isSearch = YES;
        vc.keyWords = [NSString stringWithFormat:@"%@",data[@"searchWord"]];
        NSString *shopID = [NSString stringWithFormat:@"%@",data[@"shopId"]];
        if (!shopID.isKong) {
            vc.shopId = shopID;
        }
        vc.hidesBottomBarWhenPushed = YES;
        [selfWeak.navigationController pushViewController:vc animated:YES];
    }];
    [self loadIndexList];
    [selfWeak loadYouHuiQuanList];
    
    self.tableView.mj_header = [LTSCRefreshHeader headerWithRefreshingBlock:^{
        [selfWeak loadIndexList];
        [selfWeak loadYouHuiQuanList];
    }];
 
    self.noneView.clickBlock = ^{
        [selfWeak loadIndexList];
        [selfWeak loadYouHuiQuanList];
    };
}


- (void)initHeaderView {
    
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 170 + 15+90+15 + 10 + 10)];
    self.tableView.tableHeaderView = self.headerView;
    [self.headerView addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView).offset(170);
        make.leading.trailing.bottom.equalTo(self.headerView);
    }];
    [self.headerView addSubview:self.bannerImgView];
    [self.headerView addSubview:self.bannerView];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView * line = [[UIView alloc] init];
    line.backgroundColor = BGGrayColor;
    [self.headerView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.equalTo(self.headerView);
        make.height.equalTo(@10);
    }];
    
    self.itemView = [[LTSCBianMinItemView alloc] initWithFrame:CGRectMake(0, 170, ScreenW, 15+90 )];
    self.itemView.backgroundColor = [UIColor whiteColor];
    [self.headerView addSubview:self.itemView];
    WeakObj(self);
    self.itemView.didselectItem = ^(LTSCPublicModel *model) {
        [selfWeak pageToList:model];
    };
}


//
- (void)initView {
    [self.view addSubview:self.bgImgView];
    [self.view addSubview:self.titleView];
    [self.view bringSubviewToFront:self.tableView];
   
    [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.height.equalTo(@(NavigationSpace));
    }];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(NavigationSpace - 44 + 7);
        make.leading.equalTo(self.view).offset(15);
        make.trailing.equalTo(self.view).offset(-15);
        make.height.equalTo(@30);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.mas_bottom).offset(7);
        make.leading.trailing.bottom.equalTo(self.view);
    }];
}

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    LTSCHomeBannerModel *model = self.bannerArr[index];
    [self pageToVC:model];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return self.chooseList.count;
    } else if (section == 2) {
        return 1;
    }
    return self.questionArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        LTSCHomeYouHuiQuanCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LTSCHomeYouHuiQuanCell"];
        if (!cell) {
            cell = [[LTSCHomeYouHuiQuanCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LTSCHomeYouHuiQuanCell"];
        }
        cell.list = self.youhuiquanArr;
        WeakObj(self);
        cell.lingquyouHuiQuanClickBlock = ^(LTSCYouHuiQuanModel *model) {
            if (!ISLOGIN) {
                [selfWeak gotoLogin];
               
            }else {
               [selfWeak lingQuYouHuiQuan:model];
            }
           
        };
        return cell;
    } else if (indexPath.section == 1) {
        LTSCHomeReQiCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LTSCHomeReQiCell"];
        if (!cell) {
            cell = [[LTSCHomeReQiCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LTSCHomeReQiCell"];
        }
        cell.chooseModel = self.chooseList[indexPath.row];
        return cell;
    } else if (indexPath.section == 2) {
        LTSCHomeBaoKuanCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LTSCHomeBaoKuanCell"];
        if (!cell) {
            cell = [[LTSCHomeBaoKuanCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LTSCHomeBaoKuanCell"];
        }
        cell.collectionView.backgroundColor = UIColor.whiteColor;
        cell.dataArr = self.hotList;
        WeakObj(self);
        cell.selectItemBlock = ^(LTSCChooseListModel *model) {
            [selfWeak pageToDetail:model.id];
        };
        return cell;
    } else {
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
   
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 1 || section == 2) {
        LTSCHomeTableSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"LTSCHomeTableSectionHeaderView"];
        if (!headerView) {
            headerView = [[LTSCHomeTableSectionHeaderView alloc] initWithReuseIdentifier:@"LTSCHomeTableSectionHeaderView"];
        }
        headerView.section = section;
        headerView.sectionHeaderClick = ^(NSInteger section) {
            [self pageTo:section];
        };
        return headerView;
    }
    LTSCHomeTableSectionHeaderView1 *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"LTSCHomeTableSectionHeaderView1"];
    if (!headerView) {
        headerView = [[LTSCHomeTableSectionHeaderView1 alloc] initWithReuseIdentifier:@"LTSCHomeTableSectionHeaderView1"];
    }
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
    if (!footerView) {
        footerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"UITableViewHeaderFooterView"];
    }
    footerView.contentView.backgroundColor = BGGrayColor;
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (self.youhuiquanArr.count > 0) {
            return 44;
        }
        return 0.01;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        if (self.youhuiquanArr.count > 0) {
            return 10;
        }
        return 0.01;
    } else if (section == 3) {
        return 0.5;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.youhuiquanArr.count > 0) {
            return 93;
        }
        return 0.01;
    } else if (indexPath.section == 1) {
        return 145;
    } else if (indexPath.section == 2) {
        return (((ScreenW - 45)/2)+ 75 + 15) * ceil(self.hotList.count/2.0);
    }
    LTSCHomeQuestionModel *model = self.questionArr[indexPath.row];
    return model.cellheight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        LTSCGoodsDetailVC *vc = [[LTSCGoodsDetailVC alloc] init];
        vc.goodsID = self.chooseList[indexPath.row].id;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)pageToDetail:(NSString *)goodId {
    LTSCGoodsDetailVC *vc = [[LTSCGoodsDetailVC alloc] init];
    vc.goodsID = goodId;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


/**
  获取首页数据
*/
- (void)loadIndexList {
    [LTSCLoadingView show];
    [LTSCNetworking networkingPOST:s_index parameters:nil returnClass:[LTSCHomeRootModel class] success:^(NSURLSessionDataTask *task, LTSCHomeRootModel *responseObject) {
        [self endRefrish];
        if (responseObject.key.intValue == 1000) {
            [self.chooseList removeAllObjects];
            [self.hotList removeAllObjects];
            [self.questionArr removeAllObjects];
            [self.bannerArr removeAllObjects];
            NSMutableArray *arr = [NSMutableArray array];
            for (LTSCHomeBannerModel *model in responseObject.result.map.banner) {
                [arr addObject:model.pic];
            }
            self.bannerView.imageURLStringsGroup = arr;
            if (responseObject.result.map.typeList.count <= 5) {
                self.headerView.frame = CGRectMake(0, 0, ScreenW, 170 + 15+90+15 + 10 + 10);
                self.itemView.frame = CGRectMake(0, 170, ScreenW, 15+90 );
            }else {
                self.headerView.frame = CGRectMake(0, 0, ScreenW, 170 + 15+2*90+15 + 10 + 10);
                self.itemView.frame = CGRectMake(0, 170, ScreenW, 15+2*90 );
            }
            self.itemView.dataArr = responseObject.result.map.typeList;
            self.tableView.tableHeaderView = self.headerView;
            [self.bannerArr addObjectsFromArray:responseObject.result.map.banner];
            [self.hotList addObjectsFromArray:responseObject.result.map.hotList];
            [self.chooseList addObjectsFromArray:responseObject.result.map.chooseList];
            [self.questionArr addObjectsFromArray:responseObject.result.map.qaList];
            [self.tableView reloadData];
            
        }else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
        
        if (self.chooseList.count <= 0 && self.hotList.count <= 0 && self.questionArr.count <=0 && self.bannerArr.count <= 0) {
            [self.noneView showNoneDataViewAt:self.view img:[UIImage imageNamed:@"emptysearch"] tips:@"暂无数据"];
        } else {
            [self.noneView dismiss];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self endRefrish];
        if (self.chooseList.count <= 0 && self.hotList.count <= 0 && self.questionArr.count <=0 && self.bannerArr.count <= 0) {
            [self.noneView showNoneNetViewAt:self.view];
        } else {
            [self.noneView dismiss];
        }
    }];
}

/// 获取优惠券列表
- (void)loadYouHuiQuanList {
    WeakObj(self);
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (SESSION_TOKEN) {
        dict[@"token"] = SESSION_TOKEN;
    }
    
    [LTSCNetworking networkingPOST:app_index_couponList parameters:dict returnClass:[LTSCYouHuiQuanRootModel class] success:^(NSURLSessionDataTask *task, LTSCYouHuiQuanRootModel *responseObject) {
        [self endRefrish];
        if (responseObject.key.intValue == 1000) {
            [selfWeak.youhuiquanArr removeAllObjects];
            [selfWeak.youhuiquanArr addObjectsFromArray:responseObject.result.list];
            [selfWeak.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        } else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self endRefrish];
    }];
}


#pragma --- 事件处理

- (void)pageToList:(LTSCPublicModel *)model {
    if (model.index_type.intValue == 1) {//一级分类
        [self loadSecondList:model isOther:NO];
    } else if (model.index_type.intValue == 2) {
        //2.充值中心
        if (!ISLOGIN) {
            [self gotoLogin];
            return;
        }
        
        LTSCChargeCenterVC *vc = [LTSCChargeCenterVC new];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (model.index_type.intValue == 3) {
        
        
        if (!ISLOGIN) {
            [self gotoLogin];
            return;
        }
        
        //3.火车票，机票，酒店
        if (model.link_type.intValue == 1) {
            //机票
            [self getThirdLogin:@1 name:@"机票"];
        } else if (model.link_type.intValue == 2) {
            //火车票
            [self getThirdLogin:@2 name:@"火车票"];
        } else if (model.link_type.intValue == 3) {
            //酒店
            [self getThirdLogin:@3 name:@"酒店"];
        }
    }
}

//酒店 火车票 机票
- (void)getThirdLogin:(NSNumber *)type name:(NSString *)name {
    if (SESSION_TOKEN) {
        [LTSCLoadingView show];
        [LTSCNetworking networkingPOST:get_link parameters:@{@"token" : SESSION_TOKEN, @"type" : type} returnClass:LTSCHomeThirdLoginRootModel.class success:^(NSURLSessionDataTask *task, LTSCHomeThirdLoginRootModel *responseObject) {
            [LTSCLoadingView dismiss];
            if (responseObject.key.intValue == 1000) {
                LTSCWebViewController *vc = [[LTSCWebViewController alloc] init];
                vc.navigationItem.title = name;
                vc.loadUrl = [NSURL URLWithString:responseObject.result.data];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                [UIAlertController showAlertWithmessage:responseObject.message];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [LTSCLoadingView dismiss];
        }];
    } else {
        [self gotoLogin];
    }
}

/**
 获取商品二级列表
 */
- (void)loadSecondList:(LTSCPublicModel *)model isOther:(BOOL)isOther {
    [LTSCLoadingView show];
    [LTSCNetworking networkingPOST:good_second_type_list parameters:@{@"id":model.type_id} returnClass:[LTSCCateRootModel class] success:^(NSURLSessionDataTask *task, LTSCCateRootModel *responseObject) {
        [LTSCLoadingView dismiss];
        if (responseObject.key.integerValue == 1000) {
            LTSCCateModel *cataModel = [LTSCCateModel new];
            cataModel.pid = model.type_id;
            cataModel.typeName = model.type_name;
            [self.secondDataArr removeAllObjects];
            [self.secondDataArr addObjectsFromArray:responseObject.result.list];
            LTSCCateListVC *vc = [[LTSCCateListVC alloc] init];
            vc.titleStr = responseObject.result.data;
            vc.cateModel = cataModel;
            vc.currentIndex = 0;
            vc.secondCateArr = self.secondDataArr;
            if (isOther) {
                vc.isHome = YES;
            }
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [LTSCLoadingView dismiss];
    }];
}

/// 领取优惠券
- (void)lingQuYouHuiQuan: (LTSCYouHuiQuanModel *)model {
    if (SESSION_TOKEN) {
        [LTSCLoadingView show];
        WeakObj(self);
        [LTSCNetworking networkingPOST:addCoupon parameters:@{@"token":SESSION_TOKEN, @"id":model.id} returnClass:LTSCBaseModel.class success:^(NSURLSessionDataTask *task, LTSCBaseModel *responseObject) {
            [LTSCLoadingView dismiss];
            if (responseObject.key.intValue == 1000) {
                [LTSCToastView showSuccessWithStatus:@"领取成功!"];
                model.isReceive = @"1";
                
                LTSCHomeYouHuiQuanCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                cell.list = self.youhuiquanArr;
                
//                [selfWeak.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [LTSCLoadingView dismiss];
        }];
    } else {
        LTSCLoginVC *vc = [[LTSCLoginVC alloc] init];
        BaseNavigationController * nav  = [[BaseNavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

/**
 更多

 @param section 1 人气严选 2 爆款推荐
 */
- (void)pageTo:(NSInteger)section {
    if (section == 1) {
        LTSCReQiYanXuanVC *vc = [[LTSCReQiYanXuanVC alloc] initWithTableViewStyle:UITableViewStyleGrouped];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (section == 2){
        LTSCBaoKuanTuiJianVC *vc = [[LTSCBaoKuanTuiJianVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
//        self.tabBarController.selectedIndex = 2;
    }
}

/**
 常见问题 自助区
 */
- (void)bottomButtonClick {//
    LTSCAqListVC *vc = [[LTSCAqListVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


/**
 banner跳转

 @param model info_type 跳转类型：'1：商品id，2：大类列表
 */
- (void)pageToVC:(LTSCHomeBannerModel *)model {
    if (model.info_type.intValue == 1) {
        LTSCGoodsDetailVC *vc = [[LTSCGoodsDetailVC alloc] init];
        vc.goodsID = model.info_id;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (model.info_type.intValue == 2) {
        LTSCPublicModel *m = [LTSCPublicModel new];
        m.type_id = model.info_id;
        [self loadSecondList:m isOther:NO];
    }
}

@end

/**
 导航栏部分的搜索栏
 */
@interface LTSCHomeSearchView()

@property (nonatomic, strong) UIImageView *iconImgView;//搜索图标

@end
@implementation LTSCHomeSearchView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bgButton];
        [self.bgButton addSubview:self.iconImgView];
        [self.bgButton addSubview:self.searchTF];
        [self.bgButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.bottom.equalTo(self);
        }];
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@15);
            make.centerY.equalTo(self.bgButton);
            make.width.height.equalTo(@14);
        }];
        [self.searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.iconImgView.mas_trailing).offset(10);
            make.trailing.equalTo(self.bgButton.mas_trailing).offset(-5);
            make.top.bottom.equalTo(self.bgButton);
        }];
    }
    return self;
}

- (UIButton *)bgButton {
    if (!_bgButton) {
        _bgButton = [[UIButton alloc] init];
        _bgButton.backgroundColor = [UIColor whiteColor];
        _bgButton.layer.cornerRadius = 15;
        _bgButton.layer.masksToBounds = YES;
    }
    return _bgButton;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.image = [UIImage imageNamed:@"search"];
    }
    return _iconImgView;
}

- (UITextField *)searchTF {
    if (!_searchTF) {
        _searchTF = [[UITextField alloc] init];
        _searchTF.placeholder = @"搜一搜";
        _searchTF.font = [UIFont systemFontOfSize:14];
        _searchTF.textColor = CharacterDarkColor;
        _searchTF.returnKeyType = UIReturnKeySearch;
    }
    return _searchTF;
}

@end
