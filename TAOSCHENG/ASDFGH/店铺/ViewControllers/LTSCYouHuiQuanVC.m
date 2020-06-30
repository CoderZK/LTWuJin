//
//  LTSCYouHuiQuanVC.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2020/4/9.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "LTSCYouHuiQuanVC.h"
#import "LTSCSubYouHuiQuanVC.h"
#import "TYTabPagerBar.h"
#import "TYPagerController.h"

@interface LTSCYouHuiQuanVC ()<TYTabPagerBarDelegate,TYTabPagerBarDataSource,TYPagerControllerDataSource,TYPagerControllerDelegate>

@property (nonatomic, strong) TYTabPagerBar *tabBar;

@property (nonatomic, strong) TYPagerController *pagerController;

@property (nonatomic, strong) NSArray <NSString *>*titleArr;

@end

@implementation LTSCYouHuiQuanVC

- (TYTabPagerBar *)tabBar {
    if (!_tabBar) {
        _tabBar = [[TYTabPagerBar alloc] init];
        TYTabPagerBarLayout *layout = [[TYTabPagerBarLayout alloc] initWithPagerTabBar:_tabBar];
        layout.normalTextFont = [UIFont systemFontOfSize:14];
        layout.selectedTextFont = [UIFont boldSystemFontOfSize:14];
        layout.normalTextColor = UIColor.blackColor;
        layout.selectedTextColor = MineColor;
        layout.progressHeight = 4;
        layout.progressRadius = 2;
        layout.progressColor = MineColor;
        layout.cellEdging = 0;
        layout.cellSpacing = 0;
        layout.adjustContentCellsCenter = YES;
        layout.barStyle = TYPagerBarStyleProgressView;
        layout.animateDuration = 0.25;
        layout.progressVerEdging = 8;
        layout.cellWidth = floor(ScreenW/3.0);
        layout.progressWidth = 35;
        _tabBar.backgroundColor = [UIColor whiteColor];
        _tabBar.layout = layout;
        _tabBar.autoScrollItemToCenter = YES;
        _tabBar.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tabBar.delegate = self;
        _tabBar.dataSource = self;
        [_tabBar registerClass:[TYTabPagerBarCell class] forCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier]];
    }
    return _tabBar;
}

- (TYPagerController *)pagerController {
    if (!_pagerController) {
        TYPagerController *pagerController = [[TYPagerController alloc]init];
        pagerController.layout.prefetchItemCount = 1;
        //pagerController.layout.autoMemoryCache = NO;
        // 只有当scroll滚动动画停止时才加载pagerview，用于优化滚动时性能
        pagerController.layout.addVisibleItemOnlyWhenScrollAnimatedEnd = YES;
        pagerController.dataSource = self;
        pagerController.delegate = self;
        _pagerController = pagerController;
    }
    return _pagerController;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated {

 [super viewWillDisappear:animated];
 [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"优惠券";
    self.titleArr = @[@"未使用(0)",@"已使用(0)",@"已过期(0)"];
    [self.view addSubview:self.tabBar];
    [self addChildViewController:self.pagerController];
    [self.view addSubview:self.pagerController.view];
    
    [self.tabBar mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.leading.trailing.equalTo(self.view);
           make.height.equalTo(@50);
       }];
    [self.pagerController.view mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(self.tabBar.mas_bottom);
       make.leading.trailing.bottom.equalTo(self.view);
    }];
    
    [self.tabBar reloadData];
    [self.pagerController reloadData];
    
    WeakObj(self);
    [LTSCEventBus registerEvent:@"youhuiquanNum" block:^(id data) {
        LTSCYouHuiQuanMapModel *model = (LTSCYouHuiQuanMapModel *)data;
        selfWeak.titleArr = @[[NSString stringWithFormat:@"未使用(%d)", model.noUseNum.intValue],[NSString stringWithFormat:@"已使用(%d)", model.useNum.intValue],[NSString stringWithFormat:@"已过期(%d)", model.lastNum.intValue]];
        [selfWeak.tabBar reloadData];
    }];
}

- (NSInteger)numberOfItemsInPagerTabBar {
    return self.titleArr.count;
}

- (NSInteger)numberOfControllersInPagerController {
    return self.titleArr.count;
}

- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
    LTSCSubYouHuiQuanVC *vc = [[LTSCSubYouHuiQuanVC alloc] init];
    vc.index = [NSString stringWithFormat:@"%ld", index];
    return vc;
}

#pragma mark - TYTabPagerBarDelegate

- (CGFloat)pagerTabBar:(TYTabPagerBar *)pagerTabBar widthForItemAtIndex:(NSInteger)index {
    return [pagerTabBar cellWidthForTitle:self.titleArr[index]];
}

- (void)pagerTabBar:(TYTabPagerBar *)pagerTabBar didSelectItemAtIndex:(NSInteger)index {
    [_pagerController scrollToControllerAtIndex:index animate:YES];
}


#pragma mark - TYPagerControllerDelegate

- (UICollectionViewCell<TYTabPagerBarCellProtocol> *)pagerTabBar:(TYTabPagerBar *)pagerTabBar cellForItemAtIndex:(NSInteger)index {
    UICollectionViewCell<TYTabPagerBarCellProtocol> *cell = [pagerTabBar dequeueReusableCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier] forIndex:index];
    cell.titleLabel.text = self.titleArr[index];
    return cell;
}

- (void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated {
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex animate:animated];
}

-(void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex progress:progress];
}

@end
