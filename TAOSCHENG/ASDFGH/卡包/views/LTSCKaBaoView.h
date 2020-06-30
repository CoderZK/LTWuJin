//
//  LTSCKaBaoView.h
//  huishou
//
//  Created by 李晓满 on 2020/3/13.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTSCKaBaoView : UIView

@end

@interface LTSCKaBaoHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *moreLabel;

@end

@interface LTSCKaBaoCardCell : UITableViewCell

@end

@interface LTSCKaBaoEmptyCell : UITableViewCell

@end

@interface LTSCKaDetailView : UIView

@end

@interface LTSCKaDetailheaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UILabel *textLabel0;

@property (nonatomic, strong) UIImageView *iconImgView;

@property (nonatomic, strong) UILabel *textLabel1;

@end

@interface LTSCKaDetailCell : UITableViewCell

@end

@interface LTSCMoneyCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *titleLabel;

@end

@interface LTSCKaDetailMoneyCell : UITableViewCell

@property (nonatomic, copy) void(^selectMoneyBlock)(void);

@end

@interface LTSCKaDetailBottomView : UIView

@property (nonatomic, strong) UIButton *mingxiButton;

@property (nonatomic, strong) UIImageView *iconImgView;

@property (nonatomic, strong) UIButton *sureKaiTongButton;//确认开通

@end

@interface LTSCMingXiView : UIView

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *moneylabel;

@end

@interface LTSCKaDetailMingXiView : UIControl

- (void)showAtView:(UIView *)view;

- (void)dismiss;

@end


//已开卡详情
@interface LTSCYiKaiKaGongNengButton : UIButton

@property (nonatomic, strong) UIImageView *iconImgView;

@property (nonatomic, strong) UILabel *textLabel;

@end


@interface LTSCYiKaiKaGongNengCell : UITableViewCell

@property (nonatomic, strong) UILabel *moneyLabel;

@property (nonatomic, strong) UILabel *textLabel0;

@property (nonatomic, strong) LTSCYiKaiKaGongNengButton *shukaButton;

@property (nonatomic, strong) LTSCYiKaiKaGongNengButton *chongzhiButton;

@property (nonatomic, strong) LTSCYiKaiKaGongNengButton *setMorenButton;

@end

//充值
@interface LTSCChongZhiCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconImgView;//图标

@property (nonatomic, strong) UILabel *titleLabel;//标题

@property (nonatomic, strong) UIImageView *selectImgView;//选择

@property (nonatomic, strong) UIView *lineView;//线

@property (nonatomic, assign) NSInteger indexProw;

@end


@interface LTSCYuECell : UITableViewCell

@property (nonatomic, strong) UILabel *stateLable;//状态

@end
