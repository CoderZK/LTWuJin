//
//  LTSCMyOrderVC.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/21.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LTSCMyOrderVC.h"
#import "TYTabPagerBar.h"
#import "TYPagerController.h"
#import "LTSCSubOrderVC.h"
#import "LTSCOrderDetailVC.h"

@interface LTSCMyOrderVC ()<TYTabPagerBarDataSource,TYTabPagerBarDelegate,TYPagerControllerDataSource,TYPagerControllerDelegate>
@property (nonatomic, weak) TYTabPagerBar *tabBar;//顶部菜单栏

@property (nonatomic, weak) TYPagerController *pagerController;

@property (nonatomic, strong) NSArray *datas;

@end

@implementation LTSCMyOrderVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的订单";
    
    [self addTabPageView];
    [self addPagerController];
    [self.tabBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    [self.pagerController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.equalTo(self.view);
        make.top.equalTo(self.tabBar.mas_bottom);
    }];
    
    [self.tabBar scrollToItemFromIndex:0 toIndex:self.index progress:0.01];
    [self.pagerController scrollToControllerAtIndex:self.index animate:YES];
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
    [self loadData];
        
}

//- (void)baseLeftBtnClick {
//    if (self.isPP) {
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    }else {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//}
- (void)addTabPageView {
    TYTabPagerBar *tabBar = [[TYTabPagerBar alloc] init];
    tabBar.backgroundColor = [UIColor whiteColor];
    tabBar.layout.barStyle = TYPagerBarStyleProgressElasticView;
    tabBar.layout.normalTextFont = [UIFont systemFontOfSize:16];
    tabBar.layout.normalTextColor = CharacterDarkColor;
    tabBar.layout.selectedTextFont = [UIFont systemFontOfSize:16];
    tabBar.layout.selectedTextColor = MineColor;
    tabBar.layout.progressColor = MineColor;
    tabBar.layout.cellWidth = ScreenW*0.2;
    tabBar.dataSource = self;
    tabBar.delegate = self;
    [tabBar registerClass:[TYTabPagerBarCell class] forCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier]];
    [self.view addSubview:tabBar];
    _tabBar = tabBar;
}

- (void)addPagerController {
    TYPagerController *pagerController = [[TYPagerController alloc] init];
    pagerController.layout.prefetchItemCount = 1;
    //pagerController.layout.autoMemoryCache = NO;
    // 只有当scroll滚动动画停止时才加载pagerview，用于优化滚动时性能
    pagerController.layout.addVisibleItemOnlyWhenScrollAnimatedEnd = YES;
    pagerController.dataSource = self;
    pagerController.delegate = self;
    [self addChildViewController:pagerController];
    [self.view addSubview:pagerController.view];
    _pagerController = pagerController;
}

- (void)loadData {
    _datas = [NSMutableArray arrayWithArray:@[@"全部",@"待付款",@"待发货",@"待收货",@"待评价",@"待退款"]];
    [self reloadData];
}

- (void)reloadData {
    [_tabBar reloadData];
    [_pagerController reloadData];
}

#pragma mark - TYTabPagerBarDataSource

- (NSInteger)numberOfItemsInPagerTabBar {
    return _datas.count;
}

- (UICollectionViewCell<TYTabPagerBarCellProtocol> *)pagerTabBar:(TYTabPagerBar *)pagerTabBar cellForItemAtIndex:(NSInteger)index {
    UICollectionViewCell<TYTabPagerBarCellProtocol> *cell = [pagerTabBar dequeueReusableCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier] forIndex:index];
    cell.titleLabel.text = _datas[index];
    return cell;
}
#pragma mark - TYTabPagerBarDelegate

- (CGFloat)pagerTabBar:(TYTabPagerBar *)pagerTabBar widthForItemAtIndex:(NSInteger)index {
    NSString *title = _datas[index];
    return [pagerTabBar cellWidthForTitle:title];
}
- (void)pagerTabBar:(TYTabPagerBar *)pagerTabBar didSelectItemAtIndex:(NSInteger)index {
    [_pagerController scrollToControllerAtIndex:index animate:YES];
}

#pragma mark - TYPagerControllerDataSource

- (NSInteger)numberOfControllersInPagerController {
    return _datas.count;
}

- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
    LTSCSubOrderVC *vc = [[LTSCSubOrderVC alloc] initWithTableViewStyle:UITableViewStyleGrouped];
    vc.index = index;
    return vc;
}

#pragma mark - TYPagerControllerDelegate

- (void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated {
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex animate:animated];
}

-(void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex progress:progress];
}

@end
