//
//  LTSCHomeCell.m
//  shenbian
//
//  Created by 李晓满 on 2018/10/31.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LTSCBianMinCell.h"

@interface LTSCBianMinCell()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UIView *topView;//头部视图

@property (nonatomic, strong) UIImageView *headerImgView;//发布人头像

@property (nonatomic, strong) UILabel *nameLabel;//发布人名称

@property (nonatomic, strong) UILabel *authorStateLabel;//认证状态

@property (nonatomic, strong) UIButton *seeNumButton;//浏览量

@property (nonatomic, strong) UIView *line;//分割线

@property (nonatomic, strong) UIButton *distanceButton;//距离当前位置的距离

@property (nonatomic, strong) UIButton *typeButton;//类型按钮

@property (nonatomic, strong) UILabel *contentLabel;//发布内容

@property (nonatomic, strong) UICollectionView *imgsCollectionView;//发布图片

@property (nonatomic, strong) UILabel *timeLabel;//创建时间

@end

@implementation LTSCBianMinCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.topView];
        [self.topView addSubview:self.headerImgView];
        [self.topView addSubview:self.nameLabel];
        [self.topView addSubview:self.authorStateLabel];
        [self.topView addSubview:self.seeNumButton];
        [self.topView addSubview:self.distanceButton];
        [self.topView addSubview:self.line];
        [self.topView addSubview:self.typeButton];
        [self addSubview:self.contentLabel];
        [self addSubview:self.imgsCollectionView];
        [self addSubview:self.timeLabel];
        [self setConstrains];
    }
    return self;
}

/**
 设置约束
 */
- (void)setConstrains {
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self);
        make.height.equalTo(@80);
    }];
    [self.headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView);
        make.leading.equalTo(self.topView).offset(15);
        make.width.height.equalTo(@50);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.headerImgView.mas_centerY).offset(-2);
        make.leading.equalTo(self.headerImgView.mas_trailing).offset(10);
        make.width.lessThanOrEqualTo(@120);
    }];
    [self.authorStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerImgView.mas_centerY).offset(2);
        make.leading.equalTo(self.headerImgView.mas_trailing).offset(10);
    }];
    [self.seeNumButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerImgView).offset(-3);
        make.trailing.equalTo(self.line.mas_leading).offset(-2);
        make.leading.greaterThanOrEqualTo(self.nameLabel.mas_trailing);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.seeNumButton);
        make.trailing.equalTo(self.distanceButton.mas_leading).offset(-7);
        make.width.equalTo(@0.5);
        make.height.equalTo(@20);
    }];
    [self.distanceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.topView).offset(-15);
        make.centerY.equalTo(self.seeNumButton);
    }];
    [self.typeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.topView).offset(-15);
        make.top.equalTo(self.seeNumButton.mas_bottom).offset(2);
        make.height.equalTo(@25);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
    }];
    [self.imgsCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.mas_bottom).offset(10);
        make.leading.equalTo(self).offset(15);
        make.height.equalTo(@((ScreenW - 35)/3.0));
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgsCollectionView.mas_bottom).offset(10);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
    }];
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
    }
    return _topView;
}
- (UIImageView *)headerImgView {
    if (!_headerImgView) {
        _headerImgView = [[UIImageView alloc] init];
        _headerImgView.image = [UIImage imageNamed:@"xiaoxi"];
        _headerImgView.layer.cornerRadius = 25;
        _headerImgView.layer.masksToBounds = YES;
    }
    return _headerImgView;
}
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:16];
        _nameLabel.textColor = CharacterDarkColor;
        _nameLabel.text = @"啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦";
    }
    return _nameLabel;
}
- (UILabel *)authorStateLabel {
    if (!_authorStateLabel) {
        _authorStateLabel = [[UILabel alloc] init];
        _authorStateLabel.font = [UIFont systemFontOfSize:14];
        _authorStateLabel.textColor = [UIColor colorWithRed:218/255.0 green:124/255.0 blue:69/255.0 alpha:1];
        _authorStateLabel.text = @"已认证";
    }
    return _authorStateLabel;
}

- (UIButton *)seeNumButton {
    if (!_seeNumButton) {
        _seeNumButton = [[UIButton alloc] init];
        [_seeNumButton setImage:[UIImage imageNamed:@"xiaoxi"] forState:UIControlStateNormal];
        [_seeNumButton setTitle:@"15422" forState:UIControlStateNormal];
        _seeNumButton.titleLabel.font = [UIFont systemFontOfSize:10];
        [_seeNumButton setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
        _seeNumButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
    }
    return _seeNumButton;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = CharacterDarkColor;
    }
    return _line;
}

- (UIButton *)distanceButton {
    if (!_distanceButton) {
        _distanceButton = [[UIButton alloc] init];
        [_distanceButton setImage:[UIImage imageNamed:@"xiaoxi"] forState:UIControlStateNormal];
        [_distanceButton setTitle:@"15422公里" forState:UIControlStateNormal];
        _distanceButton.titleLabel.font = [UIFont systemFontOfSize:10];
        [_distanceButton setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
        _distanceButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
    }
    return _distanceButton;
}

- (UIButton *)typeButton {
    if (!_typeButton) {
        _typeButton = [[UIButton alloc] init];
        [_typeButton setTitle:@"  二手车出售  " forState:UIControlStateNormal];
        _typeButton.titleLabel.font = [UIFont systemFontOfSize:10];
        [_typeButton setTitleColor:[UIColor colorWithRed:169/255.0 green:73/255.0 blue:54/255.0 alpha:1] forState:UIControlStateNormal];
        _typeButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
        _typeButton.layer.cornerRadius = 3;
        _typeButton.layer.borderWidth = 0.5;
        _typeButton.layer.borderColor = [UIColor colorWithRed:169/255.0 green:73/255.0 blue:54/255.0 alpha:1].CGColor;
        _typeButton.layer.masksToBounds = YES;
    }
    return _typeButton;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.text = @"考考你的减肥不方便如果被还能看但是但会奶粉的接口是";
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = CharacterDarkColor;
        _contentLabel.font = [UIFont systemFontOfSize:15];
    }
    return _contentLabel;
}

- (UICollectionView *)imgsCollectionView {
    if (!_imgsCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 10;
        layout.itemSize = CGSizeMake((ScreenW - 35)/3.0, (ScreenW - 35)/3.0);
        
        _imgsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _imgsCollectionView.backgroundColor = [UIColor whiteColor];
        _imgsCollectionView.showsHorizontalScrollIndicator = NO;
        _imgsCollectionView.scrollEnabled = YES;
        _imgsCollectionView.delegate = self;
        _imgsCollectionView.dataSource = self;
        if (@available(iOS 10.0, *)) {
            _imgsCollectionView.prefetchingEnabled = NO;
        }
        [_imgsCollectionView registerClass:[LTSCBianMinCollectionCell class] forCellWithReuseIdentifier:@"LTSCBianMinCollectionCell"];
    }
    return _imgsCollectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LTSCBianMinCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LTSCBianMinCollectionCell" forIndexPath:indexPath];
    
    return cell;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:15];
        _timeLabel.textColor = CharacterGrayColor;
        _timeLabel.text = @"2018-10-23 10:22";
    }
    return _timeLabel;
}


@end

@implementation LTSCBianMinCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imgView];
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.bottom.equalTo(self);
        }];
    }
    return self;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.image = [UIImage imageNamed:@"moren_pic"];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.layer.masksToBounds = YES;
    }
    return _imgView;
}

@end
