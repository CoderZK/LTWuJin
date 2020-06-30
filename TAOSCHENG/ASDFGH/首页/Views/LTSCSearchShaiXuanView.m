//
//  LTSCSearchShaiXuanView.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/22.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LTSCSearchShaiXuanView.h"

@interface LTSCSearchShaiXuanView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UITableView *tableView;//表

@property (nonatomic, strong) LTSCShaiXuanBottomView *bottomView;//底部

@property (nonatomic, strong) UIButton *bgButton;//背景按钮

@end


@implementation LTSCSearchShaiXuanView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.bgButton = [[UIButton alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [self.bgButton addTarget:self action:@selector(bgButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.bgButton];
        [self addSubview:self.contentView];
        [self initContentView];
        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 331, 30)];
    }
    return self;
}
/**
 初始化子视图
 */
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = UIColor.whiteColor;
    }
    return _contentView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (LTSCShaiXuanBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[LTSCShaiXuanBottomView alloc] init];
        [_bottomView.resetButton addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView.sureButton addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomView;
}

/**
 初始化content
 */
- (void)initContentView {
    [self.contentView addSubview:self.tableView];
    [self.contentView addSubview:self.bottomView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.contentView);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    if (kDevice_Is_iPhoneX) {
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView).offset(-TableViewBottomSpace);
            make.height.equalTo(@50);
        }];
    }else {
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.bottom.trailing.equalTo(self.contentView);
            make.height.equalTo(@50);
        }];
    }
    
}

- (void)show {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    _contentView.frame = CGRectMake(ScreenW, 0, 331, ScreenH);
    WeakObj(self);
    [UIView animateWithDuration:0.4 animations:^{
        selfWeak.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        self.contentView.frame = CGRectMake(ScreenW - 331, 0, 331, ScreenH);
    }];
}

- (void)dismiss {
    [self.contentView endEditing:YES];
    WeakObj(self);
    self.bgButton.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.frame = CGRectMake(ScreenW, 0, 331, ScreenH);
    } completion:^(BOOL finished) {
        [selfWeak removeFromSuperview];
        self.bgButton.userInteractionEnabled = YES;
    }];
}

#pragma --mark tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        LTSCSearchShaiXuanPriceCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LTSCSearchShaiXuanPriceCell"];
        if (!cell) {
            cell = [[LTSCSearchShaiXuanPriceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LTSCSearchShaiXuanPriceCell"];
        }
        return cell;
    }
    LTSCSearchShaiXuanCollectionCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LTSCSearchShaiXuanCollectionCell"];
    if (!cell) {
        cell = [[LTSCSearchShaiXuanCollectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LTSCSearchShaiXuanCollectionCell"];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 50;
    }else if (indexPath.section == 1) {
        return 40.5 *ceil(8/3.0);
    }else {
        return 40.5 *ceil(8/3.0);
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    LTSCSearchShaiXuanHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"LTSCSearchShaiXuanHeaderView"];
    if (!headerView) {
        headerView = [[LTSCSearchShaiXuanHeaderView alloc] initWithReuseIdentifier:@"LTSCSearchShaiXuanHeaderView"];
    }
    headerView.section = section;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (void)bgButtonClick {
    [self dismiss];
}

#pragma --mark 底部按钮

- (void)reset {
    //重置
}

- (void)sure {
    //确定
    [self dismiss];
}


@end


@interface LTSCSearchShaiXuanHeaderView()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation LTSCSearchShaiXuanHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(16);
            make.centerY.equalTo(self);
        }];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = CharacterDarkColor;
        _titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _titleLabel;
}

- (void)setSection:(NSInteger)section {
    _section = section;
    if (_section == 0) {
        _titleLabel.text = @"价格区间";
    }else if (_section == 1) {
        _titleLabel.text = @"品牌";
    }else {
        _titleLabel.text = @"材质";
    }
}

@end


@interface LTSCSearchShaiXuanPriceCell()

@property (nonatomic, strong) UITextField *leftTF;//左边输入框

@property (nonatomic, strong) UIView *lineView;//中划线

@property (nonatomic, strong) UITextField *rightTF;//右侧输入框

@end
@implementation LTSCSearchShaiXuanPriceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.leftTF];
        [self addSubview:self.lineView];
        [self addSubview:self.rightTF];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.equalTo(@30);
            make.height.equalTo(@1);
        }];
        [self.leftTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.lineView.mas_leading).offset(-20);
            make.centerY.equalTo(self);
            make.width.equalTo(@120);
            make.height.equalTo(@30.5);
        }];
        [self.rightTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.lineView.mas_trailing).offset(20);
            make.centerY.equalTo(self);
            make.width.equalTo(@120);
            make.height.equalTo(@30.5);
        }];
    }
    return self;
}

- (UITextField *)leftTF {
    if (!_leftTF) {
        _leftTF = [[UITextField alloc] init];
        _leftTF.layer.borderColor = [UIColor colorWithRed:202/255.0 green:202/255.0 blue:202/255.0 alpha:1].CGColor;
        _leftTF.layer.borderWidth = 0.5;
        _leftTF.textAlignment = NSTextAlignmentCenter;
        _leftTF.placeholder = @"最低价";
        _leftTF.keyboardType = UIKeyboardTypeDecimalPad;
        _leftTF.textColor = CharacterDarkColor;
        _leftTF.font = [UIFont systemFontOfSize:14];
    }
    return _leftTF;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithRed:202/255.0 green:202/255.0 blue:202/255.0 alpha:1];
    }
    return _lineView;
}

- (UITextField *)rightTF {
    if (!_rightTF) {
        _rightTF = [[UITextField alloc] init];
        _rightTF.layer.borderColor = [UIColor colorWithRed:202/255.0 green:202/255.0 blue:202/255.0 alpha:1].CGColor;
        _rightTF.layer.borderWidth = 0.5;
        _rightTF.textAlignment = NSTextAlignmentCenter;
        _rightTF.placeholder = @"最高价";
        _rightTF.keyboardType = UIKeyboardTypeDecimalPad;
        _rightTF.textColor = CharacterDarkColor;
        _rightTF.font = [UIFont systemFontOfSize:14];
    }
    return _rightTF;
}

@end


@interface LTSCSearchShaiXuanCollectionCell()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic , strong)UICollectionViewFlowLayout * layout;

@property (nonatomic, strong) UICollectionView *collectionView;

@end
@implementation LTSCSearchShaiXuanCollectionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.layout = [[UICollectionViewFlowLayout alloc] init];
        
        self.layout.minimumInteritemSpacing = 10;
        self.layout.minimumLineSpacing = 10;
        NSInteger num = ceil(8/3.0);
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(15, 0, 301, 40.5 * num) collectionViewLayout:self.layout];
        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.scrollEnabled = NO;
        [self addSubview:self.collectionView];
        
        [self.collectionView registerClass:[LTSCSearchCollectionCell class] forCellWithReuseIdentifier:@"LTSCSearchCollectionCell"];
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 8;
}
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(93.5, 30.5);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LTSCSearchCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LTSCSearchCollectionCell" forIndexPath:indexPath];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

@end


@implementation LTSCSearchCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bgButton];
        [self.bgButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.bottom.trailing.equalTo(self);
        }];
    }
    return self;
}

- (UIButton *)bgButton {
    if (!_bgButton) {
        _bgButton = [[UIButton alloc] init];
        [_bgButton setTitle:@"格兰仕" forState:UIControlStateNormal];
        [_bgButton setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
        [_bgButton setTitleColor:MineColor forState:UIControlStateSelected];
        _bgButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_bgButton setBackgroundImage:[UIImage imageNamed:@"shaixuan_n"] forState:UIControlStateNormal];
        [_bgButton setBackgroundImage:[UIImage imageNamed:@"shaixuan_y"] forState:UIControlStateSelected];
    }
    return _bgButton;
}
@end

@interface LTSCShaiXuanBottomView()

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIView *lineView1;

@end
@implementation LTSCShaiXuanBottomView

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
    [self addSubview:self.resetButton];
    [self addSubview:self.sureButton];
    [self addSubview:self.lineView1];
}

/**
 添加约束
 */
- (void)setConstrains {
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self);
        make.height.equalTo(@0.5);
    }];
    [self.resetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom);
        make.bottom.equalTo(self.lineView1.mas_top);
        make.leading.equalTo(self);
        make.width.equalTo(@165.5);
    }];
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom);
        make.bottom.equalTo(self.lineView1.mas_top);
        make.trailing.equalTo(self);
        make.width.equalTo(@165.5);
    }];
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.equalTo(self);
        make.height.equalTo(@0.5);
    }];
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (UIButton *)resetButton {
    if (!_resetButton) {
        _resetButton = [[UIButton alloc] init];
        [_resetButton setTitle:@"重置" forState:UIControlStateNormal];
        [_resetButton setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
        [_resetButton setBackgroundImage:[UIImage imageNamed:@"white"] forState:UIControlStateNormal];
        _resetButton.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _resetButton;
}

- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [[UIButton alloc] init];
        [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [_sureButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_sureButton setBackgroundImage:[UIImage imageNamed:@"yellow"] forState:UIControlStateNormal];
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _sureButton;
}

- (UIView *)lineView1 {
    if (!_lineView1) {
        _lineView1 = [[UIView alloc] init];
        _lineView1.backgroundColor = BGGrayColor;
    }
    return _lineView1;
}

@end
