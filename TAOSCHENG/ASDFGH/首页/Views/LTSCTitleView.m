//
//  LTSCTitleView.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/17.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LTSCTitleView.h"


@implementation LTSCTitleView

//- (CGSize)intrinsicContentSize {
//    return UILayoutFittingExpandedSize;
//}

- (LTSCHomeSearchView *)searchView {
    if (!_searchView) {
        _searchView = [[LTSCHomeSearchView alloc] init];
        [_searchView.bgButton addTarget:self action:@selector(searchButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _searchView.searchTF.userInteractionEnabled = NO;
    }
    return _searchView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.searchView];
        [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.trailing.leading.bottom.equalTo(self);
        }];
    }
    return self;
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(ScreenW - 30, 30);
}

- (void)searchButtonClick {
    if (self.searchBlock) {
        self.searchBlock();
    }
}

@end


@interface LTSCTitleView1()


@end
@implementation LTSCTitleView1

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.searchView];
        [self addSubview:self.cancelButton];
       
        [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.trailing.equalTo(self).offset(-70);
            make.centerY.equalTo(self);
            make.height.equalTo(@30);
        }];
        [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self).offset(-15);
            make.centerY.equalTo(self);
            make.width.height.equalTo(@40);
        }];
    }
    return self;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] init];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_cancelButton addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (LTSCHomeSearchView *)searchView {
    if (!_searchView) {
        _searchView = [[LTSCHomeSearchView alloc] init];
        _searchView.bgButton.backgroundColor = BGGrayColor;
    }
    return _searchView;
}

- (CGSize)intrinsicContentSize {
    return UILayoutFittingExpandedSize;
}

- (void)cancelClick {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

@end

/**
 首页 表尾查看更多>
 */
@interface LTSCHomeMoreButtonView()

@property (nonatomic, strong) UILabel *titleLabel;//查看更多

@property (nonatomic, strong) UIImageView *iconImgView;//箭头

@end
@implementation LTSCHomeMoreButtonView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.titleLabel];
        [self addSubview:self.iconImgView];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self).offset(-5);
            make.centerY.equalTo(self);
        }];
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.titleLabel.mas_trailing).offset(15);
            make.centerY.equalTo(self);
            make.width.height.equalTo(@22);
        }];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = CharacterLightGrayColor;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.text = @"查看更多";
    }
    return _titleLabel;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.image = [UIImage imageNamed:@"next"];
    }
    return _iconImgView;
}

@end

@implementation LTSCChargeCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 3;
        self.layer.borderWidth = 0.5;
        self.layer.masksToBounds = YES;
        [self addSubview:self.moneyLabel];
        [self addSubview:self.detailLabel];
        [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self.mas_centerY).offset(-2);
        }];
        [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.mas_centerY).offset(2);
        }];
    }
    return self;
}

- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [UILabel new];
        _moneyLabel.font = [UIFont boldSystemFontOfSize:18];
    }
    return _moneyLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
        _detailLabel.font = [UIFont systemFontOfSize:12];
    }
    return _detailLabel;
}

@end


@interface LTSCChargeCenterTopView ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *yinyingView;

@property (nonatomic, strong) UILabel *textLabel;//花费充值(元)

@property (nonatomic, strong) UIView *redLine;//红线

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) NSArray <NSString *> *dataArr;

@end

@implementation LTSCChargeCenterTopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.yinyingView];
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.textLabel];
        [self.bgView addSubview:self.redLine];
        [self.bgView addSubview:self.collectionView];
        [self.yinyingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.equalTo(self).offset(20);
            make.bottom.trailing.equalTo(self).offset(-20);
        }];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.equalTo(self).offset(15);
            make.bottom.trailing.equalTo(self).offset(-15);
        }];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.bgView);
            make.top.equalTo(self.bgView).offset(15);
        }];
        [self.redLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.bgView);
            make.top.equalTo(self.textLabel.mas_bottom).offset(5);
            make.width.equalTo(@20);
            make.height.equalTo(@4);
        }];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.redLine.mas_bottom).offset(25);
            make.leading.equalTo(self.bgView).offset(15);
            make.trailing.equalTo(self.bgView).offset(-15);
            make.height.equalTo(@130);
        }];
        self.dataArr = @[@"10",@"30",@"50",@"100",@"200",@"300"];
    }
    return self;
}

- (UIView *)yinyingView {
    if (!_yinyingView) {
        _yinyingView = [UIView new];
        _yinyingView.backgroundColor = [UIColor whiteColor];
        _yinyingView.layer.shadowColor = [CharacterDarkColor colorWithAlphaComponent:0.3].CGColor;
        _yinyingView.layer.shadowRadius = 10;
        _yinyingView.layer.shadowOpacity = 0.5;
        _yinyingView.layer.shadowOffset = CGSizeMake(0, 0);
    }
    return _yinyingView;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 10;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [UILabel new];
        _textLabel.textColor = MineColor;
        _textLabel.font = [UIFont systemFontOfSize:15];
        _textLabel.text = @"话费充值";
    }
    return _textLabel;
}

- (UIView *)redLine {
    if (!_redLine) {
        _redLine = [UIView new];
        _redLine.backgroundColor = MineColor;
        _redLine.layer.cornerRadius = 2;
        _redLine.layer.masksToBounds = YES;
    }
    return _redLine;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        layout.itemSize = CGSizeMake((ScreenW - 80)/3.0, 60);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(15, 0, ScreenW - 60, ceil(self.dataArr.count/3.0)*70) collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.scrollEnabled = YES;
        [_collectionView registerClass:LTSCChargeCell.class forCellWithReuseIdentifier:@"LTSCChargeCell"];
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LTSCChargeCell *itemCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LTSCChargeCell" forIndexPath:indexPath];
    itemCell.moneyLabel.text = [NSString stringWithFormat:@"%@元", self.dataArr[indexPath.item]];
    itemCell.detailLabel.text = [NSString stringWithFormat:@"售%.2f元", self.dataArr[indexPath.item].doubleValue];
    itemCell.layer.borderColor = indexPath.item == self.currentIndex ? MineColor.CGColor : [UIColor colorWithRed:189/255.0 green:189/255.0 blue:189/255.0 alpha:1.0].CGColor;
    itemCell.moneyLabel.textColor = indexPath.item == self.currentIndex ? MineColor : [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1.0];
    itemCell.detailLabel.textColor = indexPath.item == self.currentIndex ? MineColor : [UIColor colorWithRed:189/255.0 green:189/255.0 blue:189/255.0 alpha:1.0];
    itemCell.backgroundColor = indexPath.item == self.currentIndex ? [UIColor colorWithRed:255/255.0 green:250/255.0 blue:242/255.0 alpha:1.0] : [UIColor whiteColor];
    return itemCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
   self.currentIndex = indexPath.item;
   [self.collectionView reloadData];
    if (self.didMoneyClickBlock) {
        self.didMoneyClickBlock(self.dataArr[indexPath.item]);
    }
}

@end
