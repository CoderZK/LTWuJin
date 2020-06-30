//
//  LTSCCardDetailVC.m
//  huishou
//
//  Created by 李晓满 on 2020/3/13.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "LTSCCardDetailVC.h"
#import "LTSCSelectPayTypeVC.h"

@interface LTSCCardDetailVC ()

@property (nonatomic, strong) UIImageView *bgImgView;

@property (nonatomic, strong) LTSCKaDetailView *topView;

@property (nonatomic, strong) UIButton *leftButton;//返回按钮

@property (nonatomic, strong) UILabel *titleLabel;//

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) LTSCKaDetailBottomView *bottomMainView;

@property (nonatomic, strong) LTSCKaDetailMingXiView *selectedView;

@end

@implementation LTSCCardDetailVC

- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [UIImageView new];
        _bgImgView.image = [UIImage imageNamed:@"kadetail_bg"];
    }
    return _bgImgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.textColor = UIColor.whiteColor;
        _titleLabel.text = @"交通卡详情";
    }
    return _titleLabel;
}

- (LTSCKaDetailView *)topView {
    if (!_topView) {
        _topView = [LTSCKaDetailView new];
    }
    return _topView;
}

- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [UIButton new];
        [_leftButton setImage:[UIImage imageNamed:@"nav_white_back"] forState:UIControlStateNormal];
        _leftButton.imageEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 40);
        [_leftButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.layer.shadowColor = [CharacterDarkColor colorWithAlphaComponent:0.2].CGColor;
        _bottomView.layer.shadowRadius = 5;
        _bottomView.layer.shadowOpacity = 0.5;
        _bottomView.layer.shadowOffset = CGSizeMake(0, 0);
    }
    return _bottomView;
}

- (LTSCKaDetailBottomView *)bottomMainView {
    if (!_bottomMainView) {
        _bottomMainView = [LTSCKaDetailBottomView new];
        [_bottomMainView.mingxiButton addTarget:self action:@selector(mingxiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomMainView.sureKaiTongButton addTarget:self action:@selector(querenkaiTongClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomMainView;
}

- (LTSCKaDetailMingXiView *)selectedView {
    if (!_selectedView) {
        _selectedView = [LTSCKaDetailMingXiView new];
    }
    return _selectedView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initSubViews];
}

- (void)initSubViews {
    [self.view addSubview:self.bgImgView];
    [self.view addSubview:self.leftButton];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.bottomMainView];
    
    [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.height.equalTo(@(ScreenW * 221/375));
    }];
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(NavigationSpace - 39);
        make.leading.equalTo(self.view).offset(15);
        make.width.equalTo(@49);
        make.height.equalTo(@37);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       make.centerX.equalTo(self.view);
       make.centerY.equalTo(self.leftButton);
    }];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImgView.mas_bottom).offset(-130);
        make.leading.trailing.equalTo(self.view);
        make.height.equalTo(@220);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.equalTo(self.view);
        make.height.equalTo(@(70 + TableViewBottomSpace));
    }];
    [self.bottomMainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.bottomView);
        make.height.equalTo(@70);
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        LTSCKaDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LTSCKaDetailCell"];
        if (!cell) {
            cell = [[LTSCKaDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LTSCKaDetailCell"];
        }
        return cell;
    }
    LTSCKaDetailMoneyCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LTSCKaDetailMoneyCell"];
    if (!cell) {
        cell = [[LTSCKaDetailMoneyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LTSCKaDetailMoneyCell"];
    }
    WeakObj(self);
    cell.selectMoneyBlock = ^{
        [selfWeak.tableView reloadData];
    };
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    LTSCKaDetailheaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"LTSCKaDetailheaderView"];
    if (!headerView) {
        headerView = [[LTSCKaDetailheaderView alloc] initWithReuseIdentifier:@"LTSCKaDetailheaderView"];
    }
    headerView.textLabel0.text = section == 0 ? @"邳州电子公交卡" : @"卡片费用";
    headerView.lineView.hidden = section == 0;
    headerView.iconImgView.hidden = section == 0;
    headerView.textLabel1.hidden = section == 0;
    headerView.textLabel1.text = @"¥20.00";
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 40;
    }
    return ceil(6/3.0)*60 + 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}

/// 返回
- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)mingxiButtonClick:(UIButton *)btn {
    if (self.selectedView.superview) {
        [self.selectedView dismiss];
    } else {
        [self.selectedView showAtView:self.view];
    }
}

/// 确认开通
- (void)querenkaiTongClick:(UIButton *)btn {
    LTSCSelectPayTypeVC *vc = [LTSCSelectPayTypeVC new];
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
}

@end
