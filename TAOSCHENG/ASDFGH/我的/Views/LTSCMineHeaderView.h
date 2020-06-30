//
//  LTSCMineHeaderView.h
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/17.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTSCMineHeaderView : UIView

@property (nonatomic, strong) LTSCUserInfoModel *model;

@property (nonatomic, copy) void(^buttonClickBlock)(NSInteger index);

@property (nonatomic, copy) void(^seeAllOrderBlock)(void);

@property (nonatomic, strong) UIView *hearderView1;//背景

@end

@interface LTSCMineItemButton : UIButton

@property (nonatomic, strong) UILabel *numLabel;

@property (nonatomic, strong) UILabel *itemLabel;

@end


@interface LTSCMineUserView : UIView

@property (nonatomic, copy) void(^topBtnClickBlock)(void);

@property (nonatomic, strong) LTSCUserInfoModel *infoMode;

@property (nonatomic, strong) LTSCMineItemButton *dianpuButton;

@property (nonatomic, strong) LTSCMineItemButton *youhuiquanButton;
@property(nonatomic,strong)UIButton *messageBt;
@property (nonatomic, strong) UIButton *topButton;//

@end


@interface LTSCMineButtonView : UIView

@property (nonatomic, strong) LTSCUserInfoModel *model;

@property (nonatomic, copy) void(^buttonClickBlock)(NSInteger index);

@end

@interface LTSCMineButton : UIButton

@property (nonatomic, strong) UILabel *redNumLabel;

@property (nonatomic, strong) NSString *redNumStr;

@property (nonatomic, strong) UIImageView *iconImgView;

@property (nonatomic, strong) UILabel *textLabel;

@end

@interface LTSCMineCell : UITableViewCell

@property (nonatomic, assign) NSInteger index;

@end
