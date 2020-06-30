//
//  LTSCCateListVC.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/20.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LTSCCateListVC.h"
#import "TYPagerView.h"
#import "TYTabPagerBar.h"
#import "TYPagerController.h"
#import "LTSCSubCateListVC.h"
#import "LTSCSearchShaiXuanView.h"
#import "LTSCTitleView.h"
#import "LTSCSearchVC.h"

@interface LTSCCateListVC ()<TYTabPagerBarDataSource,TYTabPagerBarDelegate,TYPagerControllerDataSource,TYPagerControllerDelegate,UITextFieldDelegate>

@property (nonatomic, strong) LTSCCateTopView *topView;//选择view

@property (nonatomic, weak) TYTabPagerBar *tabBar;//顶部菜单栏

@property (nonatomic, weak) TYPagerController *pagerController;

@property (nonatomic, strong) NSArray <LTSCCateModel *>*datas;

@property (nonatomic, strong) LTSCSearchShaiXuanView *sxView;

@property (nonatomic, strong) LTSCTitleView *titleView;

@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, strong) LTSCSubCateListVC *subCateListVC;

@property (nonatomic, assign) NSInteger selectIndex;

//1.综合（按照时间倒序），2.销量，3.价格从低到高，4.价格从高到低 5.店铺，6.筛选，7.新品
@property (nonatomic, strong) NSNumber *type;


@end

@implementation LTSCCateListVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated {

 [super viewWillDisappear:animated];
 [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (LTSCTitleView *)titleView {
    if (!_titleView) {
        _titleView = [[LTSCTitleView alloc] initWithFrame:CGRectMake(0, 0, ScreenW - 30, 30)];
        _titleView.searchView.bgButton.backgroundColor = [UIColor whiteColor];
        _titleView.searchView.bgButton.backgroundColor = BGGrayColor;
        [_titleView.searchView sendSubviewToBack:_titleView.searchView.bgButton];
        _titleView.searchView.searchTF.userInteractionEnabled = YES;
        _titleView.searchView.searchTF.text = self.keyWords;
        _titleView.searchView.searchTF.delegate = self;
    }
    return _titleView;
}

- (LTSCCateTopView *)topView {
    if (!_topView) {
        _topView = [[LTSCCateTopView alloc] init];
        _topView.backgroundColor = [UIColor whiteColor];
    }
    return _topView;
}

- (void)initNav {
    self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [self.rightButton setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
    [self.rightButton setImage:[UIImage imageNamed:@"search_icon"] forState:UIControlStateNormal];
    self.rightButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.rightButton addTarget:self action:@selector(searchClick:) forControlEvents:UIControlEventTouchUpInside];
    self.rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    self.navigationItem.rightBarButtonItem = item;
}

/**
 搜索
 */
- (void)searchClick:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (btn.selected) {
        self.navigationItem.titleView = self.titleView;
        [self.rightButton setImage:[UIImage imageNamed:@" "] forState:UIControlStateNormal];
        [self.rightButton setTitle:@"取消" forState:UIControlStateNormal];
        LTSCSearchVC *vc = [[LTSCSearchVC alloc] init];
        vc.isHome = YES;
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:NO completion:nil];
    }else {
        self.navigationItem.titleView = nil;
        [self.rightButton setImage:[UIImage imageNamed:@"search_icon"] forState:UIControlStateNormal];
        [self.rightButton setTitle:@" " forState:UIControlStateNormal];
        if (self.selectIndex == 0) {
            LTSCCateModel *model = [LTSCCateModel new];
            model.pid = self.cateModel.pid;
            model.id = self.cateModel.id;
            LTSCSubCateListVC *vc = (LTSCSubCateListVC *)[self.pagerController controllerForIndex:0];
            vc.cateModel = model;
            vc.shopId = self.shopId;
            [vc reloadData1];
        }else {
            LTSCCateModel *model = _datas[self.selectIndex - 1];
            LTSCSubCateListVC *vc = (LTSCSubCateListVC *)[self.pagerController controllerForIndex:self.pagerController.curIndex];
            vc.cateModel = model;
            vc.keywords = @"";
            vc.shopId = self.shopId;
            [vc reloadData1];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.topView];
    [self addTabPageView];
    [self addPagerController];
    self.type = @1;
    if (self.isSearch) {
        self.navigationItem.titleView = self.titleView;
        self.titleView.searchView.searchTF.text = self.keyWords;
        
        [self.tabBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.trailing.equalTo(self.view);
            make.height.equalTo(@0);
        }];
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tabBar.mas_bottom);
            make.leading.trailing.equalTo(self.view);
            make.height.equalTo(@40);
        }];
        self.secondCateArr = @[[LTSCCateModel new]];
    }else {
        if (self.isHome) {
            self.navigationItem.title = self.titleStr;
            [self initNav];
            [self.tabBar mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.top.trailing.equalTo(self.view);
                make.height.equalTo(@0);
            }];
            [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.tabBar.mas_bottom);
                make.leading.trailing.equalTo(self.view);
                make.height.equalTo(@40);
            }];
        }else {
            self.navigationItem.title = self.titleStr;
            [self initNav];
            [self.tabBar mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.top.trailing.equalTo(self.view);
                make.height.equalTo(@40);
            }];
            [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.tabBar.mas_bottom);
                make.leading.trailing.equalTo(self.view);
                make.height.equalTo(@40);
            }];
        }
    }
    [self.pagerController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.leading.bottom.trailing.equalTo (self.view);
    }];
    [self loadData];
    
    WeakObj(self);
    self.topView.buttonClickBlock = ^(NSInteger index, NSInteger count) {
        NSLog(@"%ld ------ %ld", index, count);
        
        if (index == 201) {
            selfWeak.type = @1;
        } else if (index == 202) {
            selfWeak.type = @2;
        } else if (index == 203) {
            if (count == 1) {
                selfWeak.type = @3;
            } else if (count == 0) {
                selfWeak.type = @4;
            }
        } else if (index == 204) {
//            [selfWeak showSxView];
            selfWeak.type = @7;
        } else if (index == 205) {
            selfWeak.type = @5;
        }
        [selfWeak.titleView.searchView.searchTF endEditing:YES];
       if (selfWeak.isSearch) {
           selfWeak.subCateListVC.type = selfWeak.type;
           selfWeak.subCateListVC.shopId = selfWeak.shopId;
           [selfWeak.subCateListVC reloadData:selfWeak.titleView.searchView.searchTF.text];
       }else {
           if (selfWeak.selectIndex == 0) {
               LTSCCateModel *model = [LTSCCateModel new];
               model.pid = selfWeak.cateModel.pid;
               LTSCSubCateListVC *vc = (LTSCSubCateListVC *)[selfWeak.pagerController controllerForIndex:0];
               vc.cateModel = model;
               vc.type = selfWeak.type;
               vc.shopId = selfWeak.shopId;
               [vc reloadData:selfWeak.titleView.searchView.searchTF.text];
           }else {
               LTSCCateModel *model = selfWeak.datas[selfWeak.selectIndex - 1];
               LTSCSubCateListVC *vc = (LTSCSubCateListVC *)[selfWeak.pagerController controllerForIndex:selfWeak.pagerController.curIndex];
               vc.cateModel = model;
               vc.type = selfWeak.type;
               vc.shopId = selfWeak.shopId;
               [vc reloadData:selfWeak.titleView.searchView.searchTF.text];
           }
       }
    };
    //小满写的
    self.sxView = [[LTSCSearchShaiXuanView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    self.selectIndex = self.currentIndex + 1;
//    [self.pagerController scrollToControllerAtIndex:self.currentIndex + 1 animate:YES];
//    [self.tabBar scrollToItemFromIndex:0 toIndex:self.currentIndex + 1 animate:YES];
    //修改后的
    self.selectIndex = self.currentIndex;
    [self.pagerController scrollToControllerAtIndex:self.currentIndex animate:YES];
//    [self.tabBar scrollToItemFromIndex:0 toIndex:self.currentIndex animate:YES];
}

- (void)showSxView {
    [self.sxView show];
}

- (void)addTabPageView {
    TYTabPagerBar *tabBar = [[TYTabPagerBar alloc] init];
    tabBar.backgroundColor = [UIColor whiteColor];
    tabBar.contentInset = UIEdgeInsetsMake(0, 15, 0, 15);
    tabBar.layout.barStyle = TYPagerBarStyleProgressElasticView;
    tabBar.layout.normalTextFont = [UIFont systemFontOfSize:16];
    tabBar.layout.normalTextColor = CharacterDarkColor;
    tabBar.layout.selectedTextFont = [UIFont systemFontOfSize:16];
    tabBar.layout.selectedTextColor = MineColor;
    tabBar.layout.progressColor = MineColor;
    tabBar.layout.cellSpacing = 15;
    tabBar.dataSource = self;
    tabBar.delegate = self;
    [tabBar registerClass:[TYTabPagerBarCell class] forCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier]];
    [self.view addSubview:tabBar];
    _tabBar = tabBar;
}

- (void)addPagerController {
    TYPagerController *pagerController = [[TYPagerController alloc] init];
    pagerController.view.backgroundColor = BGGrayColor;
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
    _datas = [NSMutableArray arrayWithArray:self.secondCateArr];
    [self reloadData];
}

- (void)reloadData {
    [_tabBar reloadData];
    [_pagerController reloadData];
}

#pragma mark - TYTabPagerBarDataSource

- (NSInteger)numberOfItemsInPagerTabBar {
    if (self.isSearch) {
        return 1;
    }else {
       return _datas.count + 1;
    }
   
}

- (UICollectionViewCell<TYTabPagerBarCellProtocol> *)pagerTabBar:(TYTabPagerBar *)pagerTabBar cellForItemAtIndex:(NSInteger)index {
    if (self.isSearch) {
        UICollectionViewCell<TYTabPagerBarCellProtocol> *cell = [pagerTabBar dequeueReusableCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier] forIndex:index];
        cell.titleLabel.text = @"全部";
        return cell;
    }else {
        UICollectionViewCell<TYTabPagerBarCellProtocol> *cell = [pagerTabBar dequeueReusableCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier] forIndex:index];
        if (index == 0) {
            cell.titleLabel.text = @"全部";
        }else {
            LTSCCateModel *model = _datas[index - 1];
            cell.titleLabel.text = model.typeName;
        }
        return cell;
    }
    
}
#pragma mark - TYTabPagerBarDelegate

- (CGFloat)pagerTabBar:(TYTabPagerBar *)pagerTabBar widthForItemAtIndex:(NSInteger)index {
    if (self.isSearch) {
        return [pagerTabBar cellWidthForTitle:@"全部"];
    }else {
        if (index == 0) {
            return [pagerTabBar cellWidthForTitle:@"全部"];
        }else {
            LTSCCateModel *model = _datas[index - 1];
            return [pagerTabBar cellWidthForTitle:model.typeName];
        }
    }
}
- (void)pagerTabBar:(TYTabPagerBar *)pagerTabBar didSelectItemAtIndex:(NSInteger)index {
    if (self.isSearch) {
        self.selectIndex = 0;
        [_pagerController scrollToControllerAtIndex:0 animate:YES];
    }else {
        self.selectIndex = index;
        [_pagerController scrollToControllerAtIndex:index animate:YES];
    }
    
}

#pragma mark - TYPagerControllerDataSource

- (NSInteger)numberOfControllersInPagerController {
    if (self.isSearch) {
        return 1;
    }else {
       return self.secondCateArr.count + 1;
    }
    
}

- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
    if (self.isSearch) {
        LTSCSubCateListVC *vc = [[LTSCSubCateListVC alloc] init];
        vc.keywords = self.keyWords;
        vc.type = self.type;
        vc.shopId = self.shopId;
        [vc reloadData:self.keyWords];
        self.subCateListVC = vc;
        return vc;
    }else {
        LTSCSubCateListVC *vc = [[LTSCSubCateListVC alloc] init];
        LTSCCateModel *model = [LTSCCateModel new];
        if (index == 0) {
            model.pid = self.cateModel.pid;
        }else {
            model = self.secondCateArr[index - 1];
        }
        vc.type = self.type;
        vc.shopId = self.shopId;
        vc.cateModel = model;
        return vc;
    }
}

#pragma mark - TYPagerControllerDelegate

- (void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated {
    if (self.isSearch) {
        self.selectIndex = 0;
        [_tabBar scrollToItemFromIndex:0 toIndex:0 animate:animated];
    }else {
        self.selectIndex = toIndex;
        [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex animate:animated];
    }
}

-(void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {
    if (self.isSearch) {
        self.selectIndex = 0;
        [_tabBar scrollToItemFromIndex:0 toIndex:0 progress:progress];
    }else {
//        self.selectIndex = toIndex;
        [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex progress:progress];
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    if (textField.text.length == 0 || [textField.text isKong]) {
        [LTSCToastView showInFullWithStatus:@"请输入要搜索的关键字"];
        return NO;
    }
    if (self.isSearch) {
        self.subCateListVC.type = self.type;
        self.subCateListVC.shopId = self.shopId;
        [self.subCateListVC reloadData:textField.text];
    }else {
        if (self.selectIndex == 0) {
            LTSCCateModel *model = [LTSCCateModel new];
            model.pid = self.cateModel.pid;
            LTSCSubCateListVC *vc = (LTSCSubCateListVC *)[self.pagerController controllerForIndex:0];
            vc.cateModel = model;
            vc.type = self.type;
            vc.shopId = self.shopId;
            [vc reloadData:textField.text];
        }else {
            LTSCCateModel *model = _datas[self.selectIndex - 1];
            LTSCSubCateListVC *vc = (LTSCSubCateListVC *)[self.pagerController controllerForIndex:self.pagerController.curIndex];
            vc.cateModel = model;
            vc.type = self.type;
            vc.shopId = self.shopId;
            [vc reloadData:textField.text];
        }
    }
    return YES;
    
}

@end


/**
 综合  销售  价格 筛选
 */
@interface LTSCCateTopView()

@property (nonatomic, strong) UIButton *zongheBtn;//综合

@property (nonatomic, strong) UIButton *xiaoliangBtn;//销量

@property (nonatomic, strong) UIButton *xinpinButton;//新品

@property (nonatomic, strong) LTSCCateButton *priceBtn;//价格

@property (nonatomic, strong) UIButton *dianpuBtn;//店铺

@property (nonatomic, strong) LTSCCateButton *shaixuanBtn;//筛选

@property (nonatomic, strong) NSMutableArray *btnArr;//

@property (nonatomic, assign) NSInteger count;//价格点击数量

@end
@implementation LTSCCateTopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.count = 0;
        self.btnArr = [NSMutableArray array];
        [self addSubview:self.zongheBtn];
        [self addSubview:self.xiaoliangBtn];
         [self addSubview:self.xinpinButton];
        [self addSubview:self.priceBtn];
        [self addSubview:self.dianpuBtn];
       
        
        [self.btnArr addObject:self.zongheBtn];
        [self.btnArr addObject:self.xiaoliangBtn];
        [self.btnArr addObject:self.priceBtn];
        [self.btnArr addObject:self.dianpuBtn];
        [self.btnArr addObject:self.xinpinButton];
        
        [self.zongheBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.bottom.equalTo(self);
            make.width.equalTo(@(ScreenW *0.2));
        }];
        [self.xiaoliangBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.zongheBtn.mas_trailing);
            make.top.bottom.equalTo(self);
            make.width.equalTo(@(ScreenW *0.2));
        }];
        
        [self.xinpinButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.xiaoliangBtn.mas_trailing);
            make.top.bottom.equalTo(self);
            make.width.equalTo(@(ScreenW *0.2));
        }];
        
        [self.priceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.xinpinButton.mas_trailing);
            make.top.bottom.equalTo(self);
            make.width.equalTo(@(ScreenW *0.2));
        }];
        [self.dianpuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.priceBtn.mas_trailing);
            make.top.bottom.equalTo(self);
            make.width.equalTo(@(ScreenW *0.2));
        }];
//        [self.shaixuanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.leading.equalTo(self.dianpuBtn.mas_trailing);
//            make.top.bottom.trailing.equalTo(self);
//        }];
        
        UIView * line = [[UIView alloc] init];
        line.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(self);
            make.height.equalTo(@0.5);
        }];
    }
    return self;
}

- (UIButton *)zongheBtn {
    if (!_zongheBtn) {
        _zongheBtn = [[UIButton alloc] init];
        [_zongheBtn setTitle:@"综合" forState:UIControlStateNormal];
        [_zongheBtn setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
        [_zongheBtn setTitleColor:MineColor forState:UIControlStateSelected];
        _zongheBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _zongheBtn.tag = 201;
        [_zongheBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _zongheBtn.selected = YES;
    }
    return _zongheBtn;
}

- (UIButton *)xiaoliangBtn {
    if (!_xiaoliangBtn) {
        _xiaoliangBtn = [[UIButton alloc] init];
        [_xiaoliangBtn setTitle:@"销量" forState:UIControlStateNormal];
        [_xiaoliangBtn setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
        [_xiaoliangBtn setTitleColor:MineColor forState:UIControlStateSelected];
        _xiaoliangBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _xiaoliangBtn.tag = 202;
        [_xiaoliangBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _xiaoliangBtn;
}

- (UIButton *)xinpinButton {
    if (!_xinpinButton) {
        _xinpinButton = [[UIButton alloc] init];
        [_xinpinButton setTitle:@"新品" forState:UIControlStateNormal];
        [_xinpinButton setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
        [_xinpinButton setTitleColor:MineColor forState:UIControlStateSelected];
        _xinpinButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _xinpinButton.tag = 204;
        [_xinpinButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _xinpinButton;
}

- (LTSCCateButton *)priceBtn {
    if (!_priceBtn) {
        _priceBtn = [[LTSCCateButton alloc] init];
        _priceBtn.iconImgView.image = [UIImage imageNamed:@"price_n"];
        _priceBtn.textLabel.text = @"价格";
        _priceBtn.tag = 203;
        [_priceBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _priceBtn;
}

- (UIButton *)dianpuBtn {
    if (!_dianpuBtn) {
        _dianpuBtn = [[UIButton alloc] init];
        [_dianpuBtn setTitle:@"店铺" forState:UIControlStateNormal];
        [_dianpuBtn setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
        [_dianpuBtn setTitleColor:MineColor forState:UIControlStateSelected];
        _dianpuBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _dianpuBtn.tag = 205;
        [_dianpuBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dianpuBtn;
}


- (LTSCCateButton *)shaixuanBtn {
    if (!_shaixuanBtn) {
        _shaixuanBtn = [[LTSCCateButton alloc] init];
        _shaixuanBtn.iconImgView.image = [UIImage imageNamed:@"sx_n"];
        _shaixuanBtn.textLabel.text = @"筛选";
        _shaixuanBtn.tag = 204;
        [_shaixuanBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shaixuanBtn;
}

- (void)btnClick:(UIButton *)btn {
    for (UIButton *btnn in self.btnArr) {
        if (btnn == btn) {
            btnn.selected = YES;
           
            
            if (btnn.tag == 203) {
                LTSCCateButton *bt = (LTSCCateButton *)btnn;
                bt.textLabel.textColor = MineColor;
                self.count ++;
                if (self.count%2 == 0) {
                    bt.iconImgView.image = [UIImage imageNamed:@"high"];
                }else {
                    bt.iconImgView.image = [UIImage imageNamed:@"low"];
                }
            }
            if (self.buttonClickBlock) {
                self.buttonClickBlock(btnn.tag, self.count%2);
            }
        }else {
            btnn.selected = NO;
            
            if (btnn.tag == 203) {
                self.count = 0;
                LTSCCateButton *bt = (LTSCCateButton *)btnn;
                bt.textLabel.textColor = CharacterDarkColor;
                bt.iconImgView.image = [UIImage imageNamed:@"price_n"];
            }
        }
        
    }
}


@end


@interface LTSCCateButton()

@end
@implementation LTSCCateButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.textLabel];
        [self addSubview:self.iconImgView];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.mas_centerX).offset(7);
            make.centerY.equalTo(self);
        }];
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.mas_centerX).offset(10);
            make.centerY.equalTo(self);
            make.width.equalTo(@10);
            make.height.equalTo(@15);
        }];
    }
    return self;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:15];
        _textLabel.textColor = CharacterDarkColor;
    }
    return _textLabel;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
    }
    return _iconImgView;
}

@end
