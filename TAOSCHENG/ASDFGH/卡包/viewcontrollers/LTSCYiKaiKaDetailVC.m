//
//  LTSCYiKaiKaDetailVC.m
//  huishou
//
//  Created by 李晓满 on 2020/3/19.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "LTSCYiKaiKaDetailVC.h"
#import "LTSCKaBaoView.h"
#import "LTSCCardDetailVC.h"

@interface LTSCYiKaiKaDetailVC ()

@property (nonatomic, strong) UIImageView *bgImgView;

@property (nonatomic, strong) LTSCKaDetailView *topView;

@property (nonatomic, strong) UIButton *leftButton;//返回按钮

@property (nonatomic, strong) UILabel *titleLabel;//

@end

@implementation LTSCYiKaiKaDetailVC

- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [UIImageView new];
        _bgImgView.image = [UIImage imageNamed:@"kadetail_bg"];
    }
    return _bgImgView;
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
        [_leftButton setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
        _leftButton.imageEdgeInsets = UIEdgeInsetsMake(12.5, 0, 12.5, 30);
        [_leftButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
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
    
    [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.height.equalTo(@(ScreenW * 221/375));
    }];
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(NavigationSpace - 39);
        make.leading.equalTo(self.view).offset(15);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
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
        make.leading.bottom.trailing.equalTo(self.view);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        LTSCYiKaiKaGongNengCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LTSCYiKaiKaGongNengCell"];
        if (!cell) {
            cell = [[LTSCYiKaiKaGongNengCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LTSCYiKaiKaGongNengCell"];
        }
        [cell.chongzhiButton addTarget:self action:@selector(chongzhiClick) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    LTSCYuECell * cell = [tableView dequeueReusableCellWithIdentifier:@"LTSCYuECell"];
    if (!cell) {
        cell = [[LTSCYuECell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LTSCYuECell"];
    }
    cell.stateLable.hidden = YES;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 100;
    }
    return 80;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    LTSCKaDetailheaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"LTSCKaDetailheaderView"];
    if (!headerView) {
        headerView = [[LTSCKaDetailheaderView alloc] initWithReuseIdentifier:@"LTSCKaDetailheaderView"];
    }
    headerView.textLabel0.text = @"交易记录";
    headerView.lineView.hidden = YES;
    headerView.iconImgView.hidden = YES;
    headerView.textLabel1.hidden = YES;
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
    if (!headerView) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"UITableViewHeaderFooterView"];
    }
    headerView.contentView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 0.01 : 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 15;
}


/// 返回
- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}

/// 充值
- (void)chongzhiClick {
    LTSCCardDetailVC *vc = [[LTSCCardDetailVC alloc] initWithTableViewStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
