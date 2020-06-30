//
//  LTSCAccountVerifyVC.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/21.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LTSCAccountVerifyVC.h"
#import "LTSCVerifyIdentifyVC.h"
#import "LTSCBandPhoneVC.h"
#import "TYPagerView.h"
#import "TYTabPagerBar.h"
#import "TYPagerController.h"

@interface LTSCAccountVerifyVC ()<TYTabPagerBarDataSource,TYTabPagerBarDelegate,TYPagerControllerDataSource,TYPagerControllerDelegate>

@property (nonatomic, strong) UIImageView *bgImgView;

@property (nonatomic, strong) UILabel *nextlabel;

@property (nonatomic, strong) UILabel *steplabel;

@property (nonatomic, weak) TYTabPagerBar *tabBar;//顶部菜单栏

@property (nonatomic, weak) TYPagerController *pagerController;

@end

@implementation LTSCAccountVerifyVC

- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] init];
        _bgImgView.image = [UIImage imageNamed:@"maodifyphone0"];
    }
    return _bgImgView;
}

- (UILabel *)steplabel {
    if (!_steplabel) {
        _steplabel = [[UILabel alloc] init];
        _steplabel.text = @"1.验证身份";
        _steplabel.font = [UIFont systemFontOfSize:15];
        _steplabel.textColor = UIColor.whiteColor;
    }
    return _steplabel;
}

- (UILabel *)nextlabel {
    if (!_nextlabel) {
        _nextlabel = [[UILabel alloc] init];
        _nextlabel.text = @"2.绑定新手机";
        _nextlabel.font = [UIFont systemFontOfSize:15];
        _nextlabel.textColor = CharacterDarkColor;
    }
    return _nextlabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.tabBar.curIndex == 0 ? @"验证身份" : @"绑定新手机";
    [self.view addSubview:self.bgImgView];
    [self.bgImgView addSubview:self.steplabel];
    [self.bgImgView addSubview:self.nextlabel];
    [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.height.equalTo(@37);
    }];
    [self.steplabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgImgView.mas_centerX).offset(-(ScreenW *0.5 * 0.5));
        make.centerY.equalTo(self.bgImgView);
    }];
    [self.nextlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgImgView.mas_centerX).offset((ScreenW *0.5 * 0.5));
        make.centerY.equalTo(self.bgImgView);
    }];
    
    
    [self addTabPageView];
    [self addPagerController];
    [self reloadData];
    [self.tabBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(self.view);
        make.height.equalTo(@37);
    }];
    [self.pagerController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.equalTo(self.view);
        make.top.equalTo(self.tabBar.mas_bottom);
    }];
    WeakObj(self);
    [LTSCEventBus registerEvent:@"oneStepSuccess" block:^(id data) {
        NSLog(@"输出%@",data);
        [selfWeak.tabBar scrollToItemFromIndex:0 toIndex:1 progress:1];
        [selfWeak.pagerController scrollToControllerAtIndex:1 animate:YES];
        selfWeak.navigationItem.title = @"绑定新手机";
        self.steplabel.textColor = CharacterDarkColor;
        self.nextlabel.textColor = UIColor.whiteColor;
        self.bgImgView.image = [UIImage imageNamed:@"maodifyphone1"];
        LTSCBandPhoneVC *vc = (LTSCBandPhoneVC *)[selfWeak.pagerController controllerForIndex:self.pagerController.curIndex];
        vc.oneCode = data;
    }];
}

- (void)addTabPageView {
    TYTabPagerBar *tabBar = [[TYTabPagerBar alloc] init];
    tabBar.backgroundColor = [UIColor clearColor];
    tabBar.layout.barStyle = TYPagerBarStyleProgressElasticView;
    tabBar.layout.progressColor = UIColor.clearColor;
    tabBar.layout.cellWidth = ScreenW *0.5;
    tabBar.dataSource = self;
    tabBar.delegate = self;
    [tabBar registerClass:[TYTabPagerBarCell class] forCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier]];
    [self.view addSubview:tabBar];
    _tabBar = tabBar;
}

- (void)addPagerController {
    TYPagerController *pagerController = [[TYPagerController alloc]init];
    pagerController.view.backgroundColor = [UIColor clearColor];
    pagerController.layout.prefetchItemCount = 1;
    //pagerController.layout.autoMemoryCache = NO;
    // 只有当scroll滚动动画停止时才加载pagerview，用于优化滚动时性能
    pagerController.layout.addVisibleItemOnlyWhenScrollAnimatedEnd = YES;
    pagerController.dataSource = self;
    pagerController.delegate = self;
    pagerController.scrollView.scrollEnabled = NO;
    [self addChildViewController:pagerController];
    [self.view addSubview:pagerController.view];
    _pagerController = pagerController;
}

- (void)reloadData {
    [_tabBar reloadData];
    [_pagerController reloadData];
}

#pragma mark - TYTabPagerBarDataSource

- (NSInteger)numberOfItemsInPagerTabBar {
    return 2;
}

- (UICollectionViewCell<TYTabPagerBarCellProtocol> *)pagerTabBar:(TYTabPagerBar *)pagerTabBar cellForItemAtIndex:(NSInteger)index {
    UICollectionViewCell<TYTabPagerBarCellProtocol> *cell = [pagerTabBar dequeueReusableCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier] forIndex:index];
    return cell;
}
#pragma mark - TYTabPagerBarDelegate

- (CGFloat)pagerTabBar:(TYTabPagerBar *)pagerTabBar widthForItemAtIndex:(NSInteger)index {
    
    return [pagerTabBar cellWidthForTitle:@""];
}
//- (void)pagerTabBar:(TYTabPagerBar *)pagerTabBar didSelectItemAtIndex:(NSInteger)index {
//    if (index == 0) {
//        self.steplabel.textColor = UIColor.whiteColor;
//        self.nextlabel.textColor = CharacterDarkColor;
//    }else {
//        self.steplabel.textColor = CharacterDarkColor;
//        self.nextlabel.textColor = UIColor.whiteColor;
//    }
//    self.bgImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"maodifyphone%ld",index]];
//    [_pagerController scrollToControllerAtIndex:index animate:YES];
//}

#pragma mark - TYPagerControllerDataSource

- (NSInteger)numberOfControllersInPagerController {
    return 2;
}

- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
    if (index == 0) {
        LTSCVerifyIdentifyVC *vc = [[LTSCVerifyIdentifyVC alloc] init];
        return vc;
    }else {
        LTSCBandPhoneVC *vc = [[LTSCBandPhoneVC alloc] init];
        return vc;
    }
}

#pragma mark - TYPagerControllerDelegate

//- (void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated {
//    self.navigationItem.title = toIndex == 0 ? @"验证身份" : @"绑定新手机";
//    if (toIndex == 0) {
//        self.steplabel.textColor = UIColor.whiteColor;
//        self.nextlabel.textColor = CharacterDarkColor;
//    }else {
//        self.steplabel.textColor = CharacterDarkColor;
//        self.nextlabel.textColor = UIColor.whiteColor;
//    }
//    self.bgImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"maodifyphone%ld",toIndex]];
//    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex animate:animated];
//}
//
//-(void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {
//    self.navigationItem.title = toIndex == 0 ? @"验证身份" : @"绑定新手机";
//    if (toIndex == 0) {
//        self.steplabel.textColor = UIColor.whiteColor;
//        self.nextlabel.textColor = CharacterDarkColor;
//    }else {
//        self.steplabel.textColor = CharacterDarkColor;
//        self.nextlabel.textColor = UIColor.whiteColor;
//    }
//    self.bgImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"maodifyphone%ld",toIndex]];
//    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex progress:progress];
//}

@end
