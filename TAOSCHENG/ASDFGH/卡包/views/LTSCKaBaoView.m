//
//  LTSCKaBaoView.m
//  huishou
//
//  Created by 李晓满 on 2020/3/13.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "LTSCKaBaoView.h"

@implementation LTSCKaBaoView


@end
@interface LTSCKaBaoHeaderView ()

@end
@implementation LTSCKaBaoHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.titleLabel];
        [self addSubview:self.moreLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.centerY.equalTo(self);
        }];
        [self.moreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self).offset(-15);
            make.centerY.equalTo(self);
        }];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = UIColor.blackColor;
        _titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _titleLabel;
}

- (UILabel *)moreLabel {
    if (!_moreLabel) {
        _moreLabel = [UILabel new];
        _moreLabel.textColor = [UIColor colorWithRed:251/255.0 green:168/255.0 blue:48/255.0 alpha:1.0];
        _moreLabel.font = [UIFont systemFontOfSize:13];
        _moreLabel.text = @"查看更多";
    }
    return _moreLabel;
}

@end

@interface LTSCKaBaoCardCell ()

@property (nonatomic, strong) UIImageView *imgView;//图片

@property (nonatomic, strong) UILabel *moreLabel;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *detaillabel;

@property (nonatomic, strong) UIImageView *accImgView;

@end
@implementation LTSCKaBaoCardCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.imgView];
        [self addSubview:self.moreLabel];
        [self addSubview:self.nameLabel];
        [self addSubview:self.detaillabel];
        [self addSubview:self.accImgView];
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.centerY.equalTo(self);
            make.width.equalTo(@82);
            make.height.equalTo(@52);
        }];
        [self.moreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imgView);
            make.leading.equalTo(self.imgView.mas_trailing).offset(10);
            make.width.equalTo(@30);
            make.height.equalTo(@14);
        }];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.moreLabel.mas_trailing).offset(3);
            make.centerY.equalTo(self.moreLabel);
            make.trailing.equalTo(self).offset(-20);
        }];
        [self.detaillabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(12);
            make.leading.equalTo(self.imgView.mas_trailing).offset(10);
            make.trailing.equalTo(self).offset(-20);
        }];
        [self.accImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self).offset(-15);
            make.centerY.equalTo(self);
            make.width.equalTo(@5);
            make.height.equalTo(@9);
        }];
    }
    return self;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [UIImageView new];
        _imgView.image = [UIImage imageNamed:@"card"];
        _imgView.layer.cornerRadius = 4;
        _imgView.layer.masksToBounds = YES;
    }
    return _imgView;
}

- (UILabel *)moreLabel {
    if (!_moreLabel) {
        _moreLabel = [UILabel new];
        _moreLabel.backgroundColor = MineColor;
        _moreLabel.layer.cornerRadius = 7;
        _moreLabel.layer.masksToBounds = YES;
        _moreLabel.textColor = UIColor.whiteColor;
        _moreLabel.font = [UIFont systemFontOfSize:10];
        _moreLabel.text = @"默认";
        _moreLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _moreLabel;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.textColor = [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1.0];
        _nameLabel.font = [UIFont boldSystemFontOfSize:15];
        _nameLabel.text = @"徐州e行无忧公交卡";
    }
    return _nameLabel;
}

- (UILabel *)detaillabel {
    if (!_detaillabel) {
        _detaillabel = [UILabel new];
        _detaillabel.font = [UIFont systemFontOfSize:13];
        _detaillabel.textColor = [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1.0];
        _detaillabel.text = @"徐州市内公交";
    }
    return _detaillabel;
}

- (UIImageView *)accImgView {
    if (!_accImgView) {
        _accImgView = [UIImageView new];
        _accImgView.image = [UIImage imageNamed:@"arrow_right"];
    }
    return _accImgView;
}

@end

#import "LTSCEmptyView.h"
@interface LTSCKaBaoEmptyCell ()

@property (nonatomic, strong) LTSCEmptyView *emptyView;//空界面

@end
@implementation LTSCKaBaoEmptyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.emptyView];
        [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (LTSCEmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[LTSCEmptyView alloc] init];
        _emptyView.textLabel.text = @"暂未开通";
        _emptyView.imgView.image = [UIImage imageNamed:@"empty"];
    }
    return _emptyView;
}

@end

@interface LTSCKaDetailView ()

@property (nonatomic, strong) UIImageView *cardImgView;

@property (nonatomic, strong) UIView *yinyingView;

@end
@implementation LTSCKaDetailView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.yinyingView];
        [self addSubview:self.cardImgView];
        [self.yinyingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.equalTo(self).offset(18);
            make.bottom.trailing.equalTo(self).offset(-18);
        }];
        [self.cardImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.equalTo(self).offset(15);
            make.bottom.trailing.equalTo(self).offset(-15);
        }];
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

- (UIView *)cardImgView {
    if (!_cardImgView) {
        _cardImgView = [UIImageView new];
        _cardImgView.image = [UIImage imageNamed:@"card1"];
        _cardImgView.layer.cornerRadius = 10;
        _cardImgView.layer.masksToBounds = YES;
    }
    return _cardImgView;
}

@end

@implementation LTSCKaDetailheaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = YES;
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.lineView];
        [self addSubview:self.textLabel0];
        [self addSubview:self.iconImgView];
        [self addSubview:self.textLabel1];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.trailing.equalTo(self).offset(-15);
            make.top.equalTo(self);
            make.height.equalTo(@0.5);
        }];
        [self.textLabel0 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.centerY.equalTo(self);
        }];
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.textLabel0.mas_trailing).offset(10);
            make.centerY.equalTo(self);
            make.width.height.equalTo(@15);
        }];
        [self.textLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self).offset(-15);
            make.centerY.equalTo(self);
        }];
    }
    return self;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    }
    return _lineView;
}

- (UILabel *)textLabel0 {
    if (!_textLabel0) {
        _textLabel0 = [UILabel new];
        _textLabel0.textColor = [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1.0];
        _textLabel0.font = [UIFont boldSystemFontOfSize:16];
    }
    return _textLabel0;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [UIImageView new];
        _iconImgView.image = [UIImage imageNamed:@"feiyong_mingxi"];
    }
    return _iconImgView;
}

- (UILabel *)textLabel1 {
    if (!_textLabel1) {
        _textLabel1 = [UILabel new];
        _textLabel1.textColor = [UIColor colorWithRed:251/255.0 green:168/255.0 blue:48/255.0 alpha:1.0];
        _textLabel1.font = [UIFont boldSystemFontOfSize:16];
    }
    return _textLabel1;
}

@end

@interface LTSCKaDetailCell ()

@property (nonatomic, strong) UILabel *titleLabel;//

@property (nonatomic, strong) UILabel *detailLabel;//

@end
@implementation LTSCKaDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.titleLabel];
        [self addSubview:self.detailLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.top.equalTo(self);
            make.width.equalTo(@80);
        }];
        [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.titleLabel.mas_trailing);
            make.trailing.equalTo(self).offset(-15);
            make.top.equalTo(self);
            make.width.equalTo(@80);
        }];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1.0];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.text = @"适用范围";
    }
    return _titleLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
        _detailLabel.textColor = [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1.0];
        _detailLabel.font = [UIFont systemFontOfSize:14];
        _detailLabel.text = @"邳州市内公交";
    }
    return _detailLabel;
}

@end

@interface LTSCMoneyCell ()

@end
@implementation LTSCMoneyCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.textColor = [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1.0];
        _titleLabel.layer.borderColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
        _titleLabel.layer.borderWidth = 0.5;
        _titleLabel.layer.cornerRadius = 3;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end


@interface LTSCKaDetailMoneyCell ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) NSInteger currentIndex;

@end
@implementation LTSCKaDetailMoneyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.titleLabel];
        [self addSubview:self.collectionView];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.leading.equalTo(self).offset(15);
            make.height.equalTo(@20);
        }];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
            make.leading.equalTo(self).offset(15);
            make.trailing.equalTo(self).offset(-15);
            make.height.equalTo(@(ceil(6/3.0)*60));
        }];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textColor = [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1.0];
        _titleLabel.text = @"请选择充值金额";
    }
    return _titleLabel;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 15;
        layout.minimumInteritemSpacing = 10;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake((ScreenW - 60)/3.0, 50);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(15, 0, ScreenW - 30, ceil(6/3.0)*60) collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.scrollEnabled = YES;
        [_collectionView registerClass:LTSCMoneyCell.class forCellWithReuseIdentifier:@"LTSCMoneyCell"];
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LTSCMoneyCell *itemCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LTSCMoneyCell" forIndexPath:indexPath];
    itemCell.titleLabel.text = @"50";
    itemCell.titleLabel.layer.borderColor = indexPath.item == self.currentIndex ? [UIColor colorWithRed:251/255.0 green:168/255.0 blue:48/255.0 alpha:1.0].CGColor : [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0].CGColor;
    itemCell.titleLabel.textColor = indexPath.item == self.currentIndex ? [UIColor colorWithRed:251/255.0 green:168/255.0 blue:48/255.0 alpha:1.0] : [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1.0];
    itemCell.backgroundColor = indexPath.item == self.currentIndex ? [UIColor colorWithRed:255/255.0 green:250/255.0 blue:242/255.0 alpha:1.0] : [UIColor whiteColor];
    return itemCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.currentIndex = indexPath.item;
    [self.collectionView reloadData];
    if (self.selectMoneyBlock) {
        self.selectMoneyBlock();
    }
}

@end

@interface LTSCKaDetailBottomView ()

@property (nonatomic, strong) UILabel *moneyLabel;//

@property (nonatomic, strong) UILabel *textLabel;

@end
@implementation LTSCKaDetailBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.moneyLabel];
        [self addSubview:self.mingxiButton];
        [self.mingxiButton addSubview:self.textLabel];
        [self.mingxiButton addSubview:self.iconImgView];
        [self addSubview:self.sureKaiTongButton];
        [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.centerY.equalTo(self);
            make.width.equalTo(@70);
        }];
        [self.mingxiButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.moneyLabel.mas_trailing);
            make.centerY.equalTo(self);
            make.top.bottom.equalTo(self);
            make.trailing.equalTo(self.sureKaiTongButton.mas_leading);
        }];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.mingxiButton);
            make.centerY.equalTo(self.mingxiButton);
        }];
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.textLabel.mas_trailing).offset(5);
            make.centerY.equalTo(self.mingxiButton);
            make.width.equalTo(@7.5);
            make.height.equalTo(@4);
        }];
        [self.sureKaiTongButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self).offset(-15);
            make.centerY.equalTo(self);
            make.width.equalTo(@123);
            make.height.equalTo(@40);
        }];
    }
    return self;
}

- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [UILabel new];
        _moneyLabel.font = [UIFont boldSystemFontOfSize:15];
        _moneyLabel.textColor = [UIColor colorWithRed:251/255.0 green:168/255.0 blue:48/255.0 alpha:1.0];
        _moneyLabel.text = @"¥70.00";
    }
    return _moneyLabel;
}

- (UIButton *)mingxiButton {
    if (!_mingxiButton) {
        _mingxiButton = [UIButton new];
    }
    return _mingxiButton;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [UILabel new];
        _textLabel.font = [UIFont systemFontOfSize:13];
        _textLabel.textColor = [UIColor colorWithRed:167/255.0 green:167/255.0 blue:167/255.0 alpha:1.0];
        _textLabel.text = @"明细";
    }
    return _textLabel;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [UIImageView new];
        _iconImgView.image = [UIImage imageNamed:@"icon_mingxi"];
    }
    return _iconImgView;
}

- (UIButton *)sureKaiTongButton {
    if (!_sureKaiTongButton) {
        _sureKaiTongButton = [UIButton new];
        [_sureKaiTongButton setBackgroundImage:[UIImage imageNamed:@"yellow"] forState:UIControlStateNormal];
        _sureKaiTongButton.layer.cornerRadius = 3;
        _sureKaiTongButton.layer.masksToBounds = YES;
        [_sureKaiTongButton setTitle:@"确认开通" forState:UIControlStateNormal];
        [_sureKaiTongButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _sureKaiTongButton.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _sureKaiTongButton;
}

@end


@implementation LTSCMingXiView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.moneylabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.centerY.equalTo(self);
        }];
        [self.moneylabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self).offset(-15);
            make.centerY.equalTo(self);
        }];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1.0];
        _titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _titleLabel;
}

- (UILabel *)moneylabel {
    if (!_moneylabel) {
        _moneylabel = [UILabel new];
        _moneylabel.textColor = [UIColor colorWithRed:251/255.0 green:168/255.0 blue:48/255.0 alpha:1.0];
        _moneylabel.font = [UIFont boldSystemFontOfSize:15];
    }
    return _moneylabel;
}

@end


@interface LTSCKaDetailMingXiView ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) LTSCMingXiView *chongzhiView;

@property (nonatomic, strong) LTSCMingXiView *kaikaView;

@end
@implementation LTSCKaDetailMingXiView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.chongzhiView];
        [self.bgView addSubview:self.kaikaView];
        [self addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.chongzhiView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bgView).offset(15);
            make.leading.trailing.equalTo(self.bgView);
            make.height.equalTo(@35);
        }];
        [self.kaikaView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.chongzhiView.mas_bottom);
            make.leading.trailing.equalTo(self.bgView);
            make.height.equalTo(@35);
        }];
    }
    return self;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.layer.cornerRadius = 10;
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (LTSCMingXiView *)chongzhiView {
    if (!_chongzhiView) {
        _chongzhiView = [LTSCMingXiView new];
        _chongzhiView.titleLabel.text = @"充值金额";
        _chongzhiView.moneylabel.text = @"¥50.00";
    }
    return _chongzhiView;
}

- (LTSCMingXiView *)kaikaView {
    if (!_kaikaView) {
        _kaikaView = [LTSCMingXiView new];
        _kaikaView.titleLabel.text = @"开卡费用";
        _kaikaView.moneylabel.text = @"¥20.00";
    }
    return _kaikaView;
}

- (void)btnClick {
    [self dismiss];
}

- (void)showAtView:(UIView *)view {
    self.frame = CGRectMake(0, 0, ScreenW, view.bounds.size.height - 80 - TableViewBottomSpace);
    self.backgroundColor = UIColor.clearColor;
    CGFloat height = 95;
    self.bgView.frame = CGRectMake(0, ScreenH, self.frame.size.width, height);
    
    [view addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.3];
        CGRect rect = self.bgView.frame;
        rect.origin.y = ScreenH - 80 - TableViewBottomSpace - height + 10;
        self.bgView.frame =  rect;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = UIColor.clearColor;
        CGRect rect = self.bgView.frame;
        rect.origin.y = ScreenH;
        self.bgView.frame =  rect;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end


//已开卡详情
@implementation LTSCYiKaiKaGongNengButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.iconImgView];
        [self addSubview:self.textLabel];
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self.mas_centerY);
            make.width.height.equalTo(@29);
        }];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.mas_centerY).offset(10);
        }];
    }
    return self;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [UIImageView new];
    }
    return _iconImgView;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [UILabel new];
        _textLabel.textColor = [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1.0];
        _textLabel.font = [UIFont systemFontOfSize:14];
    }
    return _textLabel;
}

@end


@interface LTSCYiKaiKaGongNengCell ()

@end
@implementation LTSCYiKaiKaGongNengCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubviews];
        [self setConstrains];
    }
    return self;
}

- (void)initSubviews {
    [self addSubview:self.moneyLabel];
    [self addSubview:self.textLabel0];
    [self addSubview:self.shukaButton];
    [self addSubview:self.chongzhiButton];
    [self addSubview:self.setMorenButton];
}

- (void)setConstrains {
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.bottom.equalTo(self.mas_centerY).offset(-10);
    }];
    [self.textLabel0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.moneyLabel);
        make.top.equalTo(self.mas_centerY).offset(10);
    }];
    [self.shukaButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.trailing.equalTo(self.chongzhiButton.mas_leading);
        make.width.equalTo(@80);
    }];
    [self.chongzhiButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.trailing.equalTo(self.setMorenButton.mas_leading);
        make.width.equalTo(@80);
    }];
    [self.setMorenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.trailing.equalTo(self).offset(-15);
        make.width.equalTo(@80);
    }];
}

- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [UILabel new];
        _moneyLabel.font = [UIFont boldSystemFontOfSize:20];
        _moneyLabel.textColor = [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1.0];
        _moneyLabel.text = @"78.67";
    }
    return _moneyLabel;
}

- (UILabel *)textLabel0 {
    if (!_textLabel0) {
        _textLabel0 = [UILabel new];
        _textLabel0.font = [UIFont systemFontOfSize:14];
        _textLabel0.textColor = [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1.0];
        _textLabel0.text = @"余额";
    }
    return _textLabel0;
}

- (LTSCYiKaiKaGongNengButton *)shukaButton {
    if (!_shukaButton) {
        _shukaButton = [LTSCYiKaiKaGongNengButton new];
        _shukaButton.iconImgView.image = [UIImage imageNamed:@"shuaka"];
        _shukaButton.textLabel.text = @"刷卡";
    }
    return _shukaButton;
}

- (LTSCYiKaiKaGongNengButton *)chongzhiButton {
    if (!_chongzhiButton) {
        _chongzhiButton = [LTSCYiKaiKaGongNengButton new];
        _chongzhiButton.iconImgView.image = [UIImage imageNamed:@"chongzhi"];
        _chongzhiButton.textLabel.text = @"充值";
    }
    return _chongzhiButton;
}

- (LTSCYiKaiKaGongNengButton *)setMorenButton {
    if (!_setMorenButton) {
        _setMorenButton = [LTSCYiKaiKaGongNengButton new];
        _setMorenButton.iconImgView.image = [UIImage imageNamed:@"shezhimoren"];
        _setMorenButton.textLabel.text = @"设置默认卡";
    }
    return _setMorenButton;
}

@end


@implementation LTSCChongZhiCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.iconImgView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.selectImgView];
        [self addSubview:self.lineView ];
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.centerY.equalTo(self);
            make.width.height.equalTo(@24);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.iconImgView.mas_trailing).offset(15);
            make.centerY.equalTo(self);
        }];
        [self.selectImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self).offset(-15);
            make.centerY.equalTo(self);
            make.width.height.equalTo(@16);
        }];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.trailing.equalTo(self);
            make.leading.equalTo(self).offset(15);
            make.height.equalTo(@0.5);
        }];
    }
    return self;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
    }
    return _iconImgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = CharacterDarkColor;
    }
    return _titleLabel;
}

- (UIImageView *)selectImgView {
    if (!_selectImgView) {
        _selectImgView = [UIImageView new];
    }
    return _selectImgView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
    }
    return _lineView;
}

- (void)setIndexProw:(NSInteger)indexProw {
    _indexProw = indexProw;
    if (_indexProw == 0) {
        [self.iconImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.centerY.equalTo(self);
            make.width.height.equalTo(@24);
        }];
    } else if (_indexProw == 1){
        [self.iconImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.centerY.equalTo(self);
            make.width.equalTo(@24.5);
            make.height.equalTo(@22);
        }];
    } else {
        [self.iconImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.centerY.equalTo(self);
            make.size.equalTo(@24);
        }];
    }
}

@end


@interface LTSCYuECell ()

@property (nonatomic, strong) UILabel *titleLabel;//标题

@property (nonatomic, strong) UILabel *timeLabel;//时间

@property (nonatomic, strong) UILabel *moneyLabel;//钱数

@property (nonatomic, strong) UIView *lineView;

@end
@implementation LTSCYuECell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubviews];
        [self setContrains];
        [self setData];
    }
    return self;
}
/**
 添加视图
 */
- (void)initSubviews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.moneyLabel];
    [self addSubview:self.stateLable];
    [self addSubview:self.lineView];
}

/**
 设置约束
 */
- (void)setContrains {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.bottom.equalTo(self.mas_centerY).offset(-5);
        make.trailing.equalTo(self.moneyLabel.mas_leading);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.top.equalTo(self.mas_centerY).offset(5);
    }];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-15);
        make.centerY.equalTo(self.titleLabel);
    }];
    [self.stateLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-15);
        make.top.equalTo(self.moneyLabel.mas_bottom).offset(10);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.bottom.trailing.equalTo(self);
        make.height.equalTo(@0.5);
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1.0];
    }
    return _titleLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = [UIColor colorWithRed:149/255.0 green:149/255.0 blue:149/255.0 alpha:1.0];
    }
    return _timeLabel;
}

- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.textColor = [UIColor colorWithRed:36/255.0 green:36/255.0 blue:36/255.0 alpha:1.0];
        _moneyLabel.font = [UIFont systemFontOfSize:15];
    }
    return _moneyLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    }
    return _lineView;
}

- (UILabel *)stateLable {
    if (!_stateLable) {
        _stateLable = [UILabel new];
        _stateLable.textColor = [UIColor colorWithRed:252/255.0 green:87/255.0 blue:91/255.0 alpha:1.0];
        _stateLable.font = [UIFont systemFontOfSize:14];
    }
    return _stateLable;
}

- (void)setData {
    self.titleLabel.text = @"提现";
    self.timeLabel.text = @"2018-10-23 10:22";
    self.moneyLabel.text = @"+19.98";
    self.stateLable.text = @"审核中";
}

@end
