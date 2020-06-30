//
//  LTSCGoodDeatilVC.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/17.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LTSCGoodsDetailVC.h"
#import "LTSCGoodsDeatilTopView.h"
#import "LTSCGoodsDetailCell.h"
#import "LTSCGuiGeView.h"
#import <WebKit/WebKit.h>
#import "LTSCCateModel.h"
#import "ORSKUDataFilter.h"
#import "LTSCSelectAddressVC.h"
#import "LTSCShopCarVC.h"
#import "LTSCSelectPayTypeVC.h"
#import "MLYPhotoBrowserView.h"
#import "LTSCSureOrderVC.h"
#import "LTSCOrderDetailVC.h"
#import "LTSCShareAlertView.h"

#import "LTSCDianPuVC.h"

#import "LTSCDianPuTabBarController.h"
#import "UIViewController+shareAction.h"

@interface LTSCGoodsDetailVC ()<SDCycleScrollViewDelegate,UIScrollViewDelegate,MLYPhotoBrowserViewDataSource>

@property (nonatomic, strong) LTSCGoodsDetailTopView *titleView;

@property (nonatomic, strong) LTSCGoodsDeatilNavView *topView;

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;

@property (nonatomic, strong) LTSCGuiGeView *guigeView;

@property (nonatomic, strong) LTSCGoodsGuiGeBottomView *bottomView;//底部view

@property (nonatomic , strong) WKWebView * webView;

@property (nonatomic, strong) LTSCGoodsDetailModel *detailModel;//商品详情

@property (nonatomic, strong) LTSCGoodsDetailAdressModel *addressModel;//地址

@property (nonatomic, strong) LTSCGoodsDetailSUKModel *currentSUKModel;//当前选中的规格

@property (nonatomic, assign) NSInteger num;

@property (nonatomic, strong) NSString *carNum;

@property (nonatomic, strong) NSMutableArray <LTSCGoodsDetailTuPianModel *>*tupianArr;//图片数组

@property (nonatomic, strong) NSMutableArray <LTSCGoodsDetailTuPianModel *>*bannerArr;//banner数组

@property (nonatomic, strong) NSString *currentskuid;

@property (nonatomic, strong) UIButton *backToTopButton;//回顶部

@property (nonatomic, strong) LTSCGoodsDetailRootModel *rootModel;

@end

@implementation LTSCGoodsDetailVC

- (LTSCGoodsDetailTopView *)titleView {
    if (!_titleView) {
        _titleView = [[LTSCGoodsDetailTopView alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        _titleView.noDefaultSelected = YES;
        WeakObj(self);
        _titleView.selectTopButtonBlock = ^(NSInteger index) {
            if (index == 201) {
                [selfWeak.tableView setContentOffset:CGPointZero animated:YES];
            } else {
                CGRect rect = [selfWeak.tableView rectForSection:index - 200];
                [selfWeak.tableView setContentOffset:CGPointMake(0, rect.origin.y - (kDevice_Is_iPhoneX ? 88 : 60)) animated:YES];
            }
        };
    }
    return _titleView;
}

- (UIButton *)backToTopButton {
    if (!_backToTopButton) {
        _backToTopButton = [[UIButton alloc] init];
        [_backToTopButton setBackgroundImage:[UIImage imageNamed:@"backtotop"] forState:UIControlStateNormal];
        _backToTopButton.hidden = YES;
        [_backToTopButton addTarget:self action:@selector(backToTopClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backToTopButton;
}

- (LTSCGoodsDeatilNavView *)topView {
    if (!_topView) {
        _topView = [[LTSCGoodsDeatilNavView alloc] init];
        _topView.lineView.backgroundColor = UIColor.clearColor;
    }
    return _topView;
}

- (LTSCGoodsGuiGeBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[LTSCGoodsGuiGeBottomView alloc] init];
        _bottomView.backgroundColor = [LineColor colorWithAlphaComponent:0.5];
    }
    return _bottomView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    WeakObj(self);
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
    
    
    [self.view addSubview:self.bottomView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    if (kDevice_Is_iPhoneX) {
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(-TableViewBottomSpace);
            make.height.equalTo(@50);
        }];
    }else {
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.bottom.trailing.equalTo(self.view);
            make.height.equalTo(@50);
        }];
    }
    [self.view layoutIfNeeded];
    
    [self initTableHeaderView];
    self.tableView.separatorColor = BGGrayColor;
    self.guigeView = [[LTSCGuiGeView alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.guigeView.isGoods = YES;
    self.guigeView.topViewController = self;
    self.guigeView.closeBlock = ^(BOOL isclose) {
       
    };
    self.guigeView.pushShopCarVC = ^{
        LTSCShopCarVC *vc = [[LTSCShopCarVC alloc] init];
//        vc.tanGuigeViewBlock = ^{
//            selfWeak.currentskuid = nil;
//            if (selfWeak.currentSUKModel && !selfWeak.currentskuid) {
//                [selfWeak.guigeView show];
//            }
//        };
        [selfWeak.navigationController pushViewController:vc animated:YES];
    };
    
    self.guigeView.dianPuVCBlock = ^{
        LTSCDianPuTabBarController *tabVC = [LTSCDianPuTabBarController new];
        tabVC.shopId = selfWeak.detailModel.shopStoreId;
        //        tabVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [selfWeak presentViewController:tabVC animated:NO completion:nil];
    };
    
    self.guigeView.currentSKUDidChanged = ^(LTSCGoodsDetailSUKModel *currentModel, NSString *currentStatus, NSInteger num) {
        if (currentModel) {
            selfWeak.num = num;
            currentModel.num = @(num).stringValue;
            selfWeak.currentSUKModel = currentModel;
            selfWeak.currentskuid = selfWeak.currentSUKModel.id;
            selfWeak.detailModel.yixuanStr = currentModel.yixuanStr;
        } else if (currentStatus) {
            selfWeak.num = num;
            currentModel.num = @(num).stringValue;
            selfWeak.currentSUKModel = nil;
            selfWeak.currentskuid = nil;
            selfWeak.detailModel.yixuanStr = currentStatus;
        }
        
        [selfWeak.tableView reloadData];
    };
    self.guigeView.lijiGouMaiBlock = ^(LTSCGoodsDetailSUKModel *currentModel, NSInteger num) {
        selfWeak.num = num;
        currentModel.num = @(num).stringValue;
        selfWeak.currentSUKModel = currentModel;
        selfWeak.currentskuid = selfWeak.currentSUKModel.id;
        selfWeak.detailModel.yixuanStr = currentModel.yixuanStr;
        [selfWeak.tableView reloadData];
        if (selfWeak.guigeView.guigeArr.count == 0) {
            [selfWeak buyNowAction];
        }else {
            if (!selfWeak.currentskuid) {
                [selfWeak.guigeView show];
//                [SVProgressHUD showErrorWithStatus:@"请先选择规格数量!"];
                return ;
            }else {
                [selfWeak buyNowAction];
            }
        }
    };
    
//    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
//    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(15, 100, ScreenW - 30, 5)];
//    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
//    self.webView.scrollView.delegate = self;
//    [self.webView sizeToFit];
//    [self.webView loadRequest:req];
//    self.tableView.tableFooterView = self.webView;
    
    self.topView.navButtonSelectIndex = ^(NSInteger index) {
        [selfWeak navTo:index];
    };
    
    self.tupianArr = [NSMutableArray array];
    self.bannerArr = [NSMutableArray array];
    [self loadDetailData];
    
    self.noneView.clickBlock = ^{
       [selfWeak loadDetailData];
    };
    
    [self setBottomAction];
    [LTSCEventBus registerEvent:@"CarNumInc" block:^(id data) {
        NSString *str = [NSString stringWithFormat:@"%ld", self.carNum.integerValue + 1];
        self.bottomView.numLabel.hidden = NO;
        self.bottomView.numLabel.text = str;
        if (str.length == 1) {
            [self.bottomView.numLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@14);
            }];
        }else {
            CGFloat w = [self.bottomView.numLabel.text getSizeWithMaxSize:CGSizeMake(80, 15) withFontSize:10].width;
            [self.bottomView.numLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(w + 6));
            }];
        }
        [self.bottomView.numLabel layoutIfNeeded];
    }];
    [self initBackToTop];
}

/**
 初始化回到顶部按钮
 */
- (void)initBackToTop {
    [self.view addSubview:self.backToTopButton];
    if (kDevice_Is_iPhoneX) {
        [self.backToTopButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.view).offset(-15);
            make.bottom.equalTo(self.view).offset(-(TableViewBottomSpace +100));
            make.width.height.equalTo(@40);
        }];
    }else {
        [self.backToTopButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.view).offset(-15);
            make.bottom.equalTo(self.view).offset(-100);
            make.width.height.equalTo(@40);
        }];
    }
   
}


- (void)initTableHeaderView {
    // 网络加载图片的轮播器
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenW, 300) delegate:self placeholderImage:[UIImage imageNamed:@"789789"]];
    // 本地加载图片的轮播器
//    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenW, 300) imageURLStringsGroup:@[@"tupian",@"tupian",@"tupian"]];
    
    self.cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    self.cycleScrollView.delegate = self;
    self.cycleScrollView.pageDotColor = UIColor.whiteColor;
    self.cycleScrollView.currentPageDotColor = MineColor;
    self.cycleScrollView.autoScrollTimeInterval = 3;// 自定义轮播时间间隔
    self.tableView.tableHeaderView = self.cycleScrollView;
    
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.leading.trailing.equalTo(self.view);
        make.height.equalTo(@(self.navigationController.navigationBar.bounds.size.height + StateBarH));
    }];
    [self.topView addSubview:self.titleView];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView).offset(StateBarH);
        make.centerX.equalTo(self.topView);
        make.width.equalTo(@120);
        make.height.equalTo(@44);
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.bounds.origin.y >= 0 && scrollView == self.tableView) {
        self.topView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:scrollView.bounds.origin.y/self.topView.frame.size.height];
        self.topView.lineView.backgroundColor = [BGGrayColor colorWithAlphaComponent:scrollView.bounds.origin.y/self.topView.frame.size.height];
    }
    if (scrollView.bounds.origin.y >= 547) {
        self.backToTopButton.hidden = NO;
    }else {
        self.backToTopButton.hidden = YES;
    }

    NSArray<NSIndexPath *> *sections = [self.tableView indexPathsForRowsInRect:CGRectMake(0, self.tableView.contentOffset.y + 150, self.view.bounds.size.width, 500)];
    if (sections > 0) {
        if (sections.firstObject.section  == 2) {
            [self.titleView setSelectIndex:202];
        } else if (sections.firstObject.section  == 3) {
            [self.titleView setSelectIndex:203];
        } else {
            [self.titleView setSelectIndex:201];
        }
    }
}

- (BOOL)haveComment {
    if (self.rootModel.result.map.eval) {
        return YES;
    }
    return NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.detailModel == nil) {
        return 0;
    }
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1){
        return 3;
    } else if (section == 2){
        if ([self haveComment]) {
            return 1;
        } else {
            return 0;
        }
    } else {
        return self.tupianArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        LTSCGoodsDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LTSCGoodsDetailCell"];
        if (!cell) {
            cell = [[LTSCGoodsDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LTSCGoodsDetailCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailModel = self.detailModel;
        return cell;
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            if (self.guigeView.guigeArr.count > 0) {
                LTSCGoodsDetailGuiGeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LTSCGoodsDetailGuiGeCell"];
                if (!cell) {
                    cell = [[LTSCGoodsDetailGuiGeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LTSCGoodsDetailGuiGeCell"];
                }
                cell.detailModel = self.detailModel;
                return cell;
            } else {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell0"];
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell0"];
                }
                return cell;
            }
            
        } else if (indexPath.row == 1) {
            if (self.addressModel) {
                LTSCGoodsAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LTSCGoodsAddressCell"];
                if (!cell) {
                    cell = [[LTSCGoodsAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LTSCGoodsAddressCell"];
                }
                cell.addressModel = self.addressModel;
                return cell;
            }else {
                LTSCNoneAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LTSCNoneAddressCell"];
                if (!cell) {
                    cell = [[LTSCNoneAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LTSCNoneAddressCell"];
                }
                return cell;
            }
        } else {
            LTSCGoodsNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LTSCGoodsNoteCell"];
            if (!cell) {
                cell = [[LTSCGoodsNoteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LTSCGoodsNoteCell"];
            }
            return cell;
        }
    } else if (indexPath.section == 2) {
        LTSCPingJiaCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LTSCPingJiaCell"];
        if (!cell) {
            cell = [[LTSCPingJiaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LTSCPingJiaCell"];
        }
        cell.evalModel = self.rootModel.result.map.eval;
        return cell;
    } else {
        LTSCGoodsImgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LTSCGoodsImgCell"];
        if (!cell) {
            cell = [[LTSCGoodsImgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LTSCGoodsImgCell"];
        }
        LTSCGoodsDetailTuPianModel *model = self.tupianArr[indexPath.row];
        cell.tupianModel = model;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return self.detailModel.cellHeight;
    } else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            if (self.guigeView.guigeArr.count > 0) {
                return 60;
            }else {
                return 0;
            }
        }else if(indexPath.row == 1){
            if (self.addressModel) {
                return self.addressModel.cellHeight;
            }else {
                return 50;
            }
        }else {
            return 50;
        }
    } else if (indexPath.section == 2) {
        LTSCGoodsDetailEvalModel *model = self.rootModel.result.map.eval;
        if (model) {
            return model.cellHeight;
        }
        return 0;
    } else {
        LTSCGoodsDetailTuPianModel *model = self.tupianArr[indexPath.row];
        if (model.width.integerValue > ScreenW) {
            return ScreenW*model.height.integerValue/model.width.integerValue;
        }else {
            return model.height.integerValue;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    LTSCGoodsDetailHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"LTSCGoodsDetailHeaderView"];
    if (!headerView) {
        headerView = [[LTSCGoodsDetailHeaderView alloc] initWithReuseIdentifier:@"LTSCGoodsDetailHeaderView"];
    }
    headerView.goodsId = self.goodsID;
    headerView.evalNum = self.rootModel.result.map.evalNum;
    return headerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        if ([self haveComment]) {
            return 40;
        }
        return 0;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self.guigeView show];
        }else if (indexPath.row == 1) {//选择地址
            LTSCSelectAddressVC *vc = [[LTSCSelectAddressVC alloc] init];
            vc.isSelect = YES;
            WeakObj(self);
            vc.selectAddressModelClick = ^(LTSCGoodsDetailAdressModel *addressModel) {
                selfWeak.addressModel = addressModel;
                [selfWeak.tableView reloadData];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if (indexPath.section == 3) {
        MLYPhotoBrowserView *mlyView = [MLYPhotoBrowserView photoBrowserView];
        mlyView.dataSource = self;
        mlyView.currentIndex = indexPath.row;
        [mlyView showWithItemsSpuerView:nil];
    }
}

/**
 导航栏按钮点击
 */
- (void)navTo:(NSInteger)index {
    if (index == 100) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if (index == 101) {//返回首页
        [self.navigationController popToRootViewControllerAnimated:YES];
//        [LTSCEventBus sendEvent:@"backHomeVC" data:nil];
    }else {
        LTSCShareAlertView *alertView = [[LTSCShareAlertView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        //友盟 方法判断微信和新浪微博是否安装 没有安装的情况下 隐藏分享面板上面对应的按钮 否则会被拒
        WeakObj(self);
        alertView.shareClickBlock = ^(NSInteger index) {
            UMSocialPlatformType  type = UMSocialPlatformType_WechatSession;
            if (index == 212) {
              type = UMSocialPlatformType_WechatTimeLine;
            }else if (index == 213) {
                type = UMSocialPlatformType_QQ;
            }
            
            [selfWeak shareWebPageToPlatformType:type withTitle:self.detailModel.goodName andContent:@"我在质农优选发现了一个不错的商品，赶快来看看吧。" thumImage:self.detailModel.listPic];


        };
        [alertView show];
        

        
        
    }
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType withTitle:(NSString *)title andContent:(NSString *)contentStr thumImage:(id)thumImage
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象

    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:contentStr thumImage:thumImage];
    //设置网页地址
    shareObject.webpageUrl = self.detailModel.downUrl;
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}


#pragma --mark 网络请求是事件处理

- (void)loadDetailData {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (SESSION_TOKEN) {
        dict[@"token"] = SESSION_TOKEN;
    }
    dict[@"id"] = self.goodsID;
    WeakObj(self);
     [LTSCLoadingView show];
    [LTSCNetworking networkingPOST:good_detail parameters:dict returnClass:[LTSCGoodsDetailRootModel class] success:^(NSURLSessionDataTask *task, LTSCGoodsDetailRootModel *responseObject) {
        if (responseObject.key.integerValue == 1000) {
            [self endRefrish];
            selfWeak.rootModel = responseObject;
            selfWeak.detailModel = responseObject.result.map.detail;
            
            
            [selfWeak.titleView hiddenComment:![selfWeak haveComment]];
            
            NSMutableArray *temp = [NSMutableArray array];
            NSArray *tempArr0 = [selfWeak.detailModel.mainPic mj_JSONObject];
            for (NSDictionary *dict in tempArr0) {
                LTSCGoodsDetailTuPianModel *model = [LTSCGoodsDetailTuPianModel mj_objectWithKeyValues:dict];
                [temp addObject:model.url];
                [self.bannerArr addObject:model];
            }
            selfWeak.cycleScrollView.imageURLStringsGroup = (NSArray *)temp;
            
            selfWeak.carNum = responseObject.result.map.num.stringValue;
            
            NSArray *tempArr = [selfWeak.detailModel.content mj_JSONObject];
            for (NSDictionary *dict in tempArr) {
                LTSCGoodsDetailTuPianModel *model = [LTSCGoodsDetailTuPianModel mj_objectWithKeyValues:dict];
                [selfWeak.tupianArr addObject:model];
            }
            selfWeak.addressModel = responseObject.result.map.address;
            [selfWeak.tableView reloadData];
            selfWeak.guigeView.carNum = responseObject.result.map.num.stringValue;
            selfWeak.guigeView.goodsModel = selfWeak.detailModel;
            if (responseObject.result.map.guideList.count > 0) {
                selfWeak.guigeView.guigeArr = responseObject.result.map.guideList;
                selfWeak.guigeView.skuArr = responseObject.result.map.skuList;
                [selfWeak.guigeView reloadData];
            }
            if (selfWeak.guigeView.carNum.intValue == 0) {
                selfWeak.bottomView.numLabel.hidden = YES;
            }else {
                selfWeak.bottomView.numLabel.text = [NSString stringWithFormat:@"%@",selfWeak.guigeView.carNum];
                if (selfWeak.guigeView.carNum.length == 1) {
                    [selfWeak.bottomView.numLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.width.equalTo(@14);
                    }];
                }else {
                    CGFloat w = [selfWeak.bottomView.numLabel.text getSizeWithMaxSize:CGSizeMake(80, 15) withFontSize:10].width;
                    [selfWeak.bottomView.numLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.width.equalTo(@(w + 6));
                    }];
                }
                
                if (selfWeak.detailModel.status.intValue == 1) {
                    [selfWeak.bottomView.lijiButton setTitleColor:[UIColor colorWithRed:1 green:166/255.0 blue:105/255.0 alpha:1.0] forState:UIControlStateNormal];
                    [selfWeak.bottomView.addCarButton setTitleColor:[UIColor colorWithRed:1 green:186/255.0 blue:87/255.0 alpha:1.0] forState:UIControlStateNormal];
                    selfWeak.bottomView.userInteractionEnabled = NO;
                    selfWeak.topView.shareButton.userInteractionEnabled = NO;
                    
                    
                    UILabel * lb =[[UILabel alloc] init];
                    lb.backgroundColor = [UIColor colorWithRed:146/255.0 green:146/255.0 blue:146/255.0 alpha:1.0];
                    lb.font = [UIFont systemFontOfSize:14];
                    lb.textColor = [UIColor whiteColor];
                    [self.view addSubview:lb];
                    lb.text = @"已下架";
                    lb.textAlignment = NSTextAlignmentCenter;
                    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
                       make.leading.trailing.equalTo(self.view);
                        make.bottom.equalTo(self.bottomView.mas_top);
                        make.height.equalTo(@40);
                        
                    }];
                    
                    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.top.leading.trailing.equalTo(self.view);
                        make.bottom.equalTo(lb.mas_top);
                    }];

                }else {
                    [selfWeak.bottomView.lijiButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [selfWeak.bottomView.addCarButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    selfWeak.bottomView.userInteractionEnabled = YES;
                    selfWeak.topView.shareButton.userInteractionEnabled = YES;
                }
                
                [selfWeak.bottomView.numLabel layoutIfNeeded];
            }
        }else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.noneView showNoneNetViewAt:self.view];
        [self endRefrish];
    }];
}

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
    
}

- (void)setBottomAction {
    WeakObj(self);
    
    self.bottomView.dianpuClickBlock = ^{//点击跳转店铺界面
        LTSCDianPuTabBarController *tabVC = [LTSCDianPuTabBarController new];
        tabVC.shopId = selfWeak.detailModel.shopStoreId;
//        tabVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [selfWeak presentViewController:tabVC animated:NO completion:nil];
    };
    
    self.bottomView.shopCarBlock = ^{//点击跳转购物车界面
        LTSCShopCarVC *vc = [[LTSCShopCarVC alloc] init];
        [selfWeak.navigationController pushViewController:vc animated:YES];
    };
    self.bottomView.lijigoumaiBlock = ^{//立即购买
        if (self.guigeView.guigeArr.count == 0) {
            [selfWeak buyNowAction];
        }else {
//            if (!selfWeak.currentskuid) {
                [selfWeak.guigeView show];
////                [SVProgressHUD showErrorWithStatus:@"请先选择规格数量!"];
//                return ;
//            }else {
//                [selfWeak buyNowAction];
//            }
        }
    };
    
    self.bottomView.addShopCarBlock = ^{//加入购物车操作
        if (self.guigeView.guigeArr.count == 0) {
            [selfWeak addCarAction];
        }else {
//            if (!selfWeak.currentskuid) {
////                [SVProgressHUD showErrorWithStatus:@"请先选择规格数量!"];
                [selfWeak.guigeView show];
//                return ;
//            }else {
//                [selfWeak addCarAction];
//            }
        }
    };
}

/**
 加入购物车操作
 */
- (void)addCarAction {
    if (self.num > self.currentSUKModel.goodNum.intValue) {
        [LTSCToastView showInFullWithStatus:@"库存不足!"];
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (self.guigeView.guigeArr.count > 0) {
        dict[@"skuId"] = self.currentSUKModel.id;
        dict[@"num"] = @(self.num);
    }else {
        dict[@"num"] = @1;
    }
    dict[@"goodId"] = self.detailModel.id;
    dict[@"token"] = SESSION_TOKEN;
    [LTSCLoadingView show];
    [LTSCNetworking networkingPOST:add_cart parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [LTSCLoadingView dismiss];
        if ([responseObject[@"key"] integerValue] == 1000) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [LTSCToastView showSuccessWithStatus:@"添加成功!"];
            });
            [LTSCEventBus sendEvent:@"addCarSuccess" data:nil];
            NSString *data = responseObject[@"result"][@"data"];
            if (data.intValue == 1) {
                NSString *str = [NSString stringWithFormat:@"%ld", self.carNum.integerValue + 1];
                self.bottomView.numLabel.hidden = NO;
                self.bottomView.numLabel.text = str;
                if (str.length == 1) {
                    [self.bottomView.numLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.width.equalTo(@14);
                    }];
                }else {
                    CGFloat w = [self.bottomView.numLabel.text getSizeWithMaxSize:CGSizeMake(80, 15) withFontSize:10].width;
                     w =  w > 14 ? (w + 6) : 14;
                    [self.bottomView.numLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.width.equalTo(@(w));
                    }];
                }
                [self.bottomView.numLabel layoutIfNeeded];
            }
        }else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [LTSCLoadingView dismiss];
    }];
}

/**
 立即购买
 */
- (void)buyNowAction {
    if (!self.addressModel) {
        [LTSCToastView showInFullWithStatus:@"请选择下单地址!"];
        return;
    }
    if (self.num > self.currentSUKModel.goodNum.intValue) {
        [LTSCToastView showInFullWithStatus:@"库存不足!"];
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (self.guigeView.guigeArr.count > 0) {
        dict[@"skuId"] = self.currentSUKModel.id;
        dict[@"num"] = @(self.num);
    } else {
        dict[@"num"] = @1;
    }
    dict[@"addressId"] = self.addressModel.id;
    dict[@"goodId"] = self.detailModel.id;
    dict[@"token"] = SESSION_TOKEN;

    LTSCShopCarDianPuModel *dianpuModel = [LTSCShopCarDianPuModel new];
    LTSCGoodsDetailSUKModel *model = [LTSCGoodsDetailSUKModel new];
    model.list_pic = self.detailModel.listPic;
    model.good_name = self.detailModel.goodName;
    model.properties = self.currentSUKModel.properties;
    model.yixuanStr = self.detailModel.yixuanStr;
    if (self.guigeView.guigeArr.count > 0) {
        model.num = @(self.num).stringValue;
        model.good_price = self.currentSUKModel.goodPrice;
    }else {
        model.num = @"1";
        model.good_price = self.detailModel.normalPrice.getPriceStr;
    }
    model.goodId = self.detailModel.id;
    
    //地址传递新加
    LTSCAddressListModel *addmodel = [[LTSCAddressListModel alloc] init];
    addmodel.username = self.addressModel.username ;
    addmodel.id = self.addressModel.id;
    addmodel.defaultStatus = self.addressModel.defaultStatus;
    addmodel.telephone = self.addressModel.telephone;
    addmodel.province = self.addressModel.province;
    addmodel.city = self.addressModel.city;
    addmodel.district = self.addressModel.district;
    addmodel.addressDetail = self.addressModel.addressDetail;
    //
    
    
    dianpuModel.goodList = [NSMutableArray arrayWithArray:@[model]];
    dianpuModel.shopId = self.detailModel.shopStoreId;
    dianpuModel.shop_name = self.rootModel.result.map.shopName;
    LTSCSureOrderVC *vc = [[LTSCSureOrderVC alloc] initWithTableViewStyle:UITableViewStyleGrouped];
    vc.dict = dict;
    vc.ids = self.detailModel.id;
    vc.dianpuArr = [NSMutableArray arrayWithArray:@[dianpuModel]];
    if (self.guigeView.guigeArr.count > 0) {
        vc.allPrice = self.num * self.currentSUKModel.goodPrice.floatValue;
    }else {
        vc.allPrice = 1 * self.detailModel.normalPrice.floatValue;
    }
    vc.addressModel = addmodel;
//    WeakObj(self);
    vc.tanGuigeViewBlock = ^{
//        selfWeak.currentskuid = nil;
//        if (selfWeak.currentSUKModel && !selfWeak.currentskuid) {
//            [selfWeak.guigeView show];
//        }
    };
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//图片放大
- (NSInteger)numberOfItemsInPhotoBrowserView:(MLYPhotoBrowserView *)photoBrowserView{
    return self.tupianArr.count;
}
- (MLYPhoto *)photoBrowserView:(MLYPhotoBrowserView *)photoBrowserView photoForItemAtIndex:(NSInteger)index{
    LTSCGoodsDetailTuPianModel *model = self.tupianArr[index];
    MLYPhoto *photo = [[MLYPhoto alloc] init];
    photo.imageUrl = [NSURL URLWithString:model.url];
    return photo;
}

/**
 回到顶部
 */
- (void)backToTopClick {
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    [_titleView setSelectIndex:201];
}

@end
