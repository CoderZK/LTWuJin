//
//  LTSCTitleView.h
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/17.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTSCHomeVC.h"

@interface LTSCTitleView : UIView

@property (nonatomic, strong) LTSCHomeSearchView *searchView;//搜索

- (CGSize)intrinsicContentSize;
@property (nonatomic, copy) void(^searchBlock)(void);

@end

@interface LTSCTitleView1 : UIView

@property (nonatomic, strong) LTSCHomeSearchView *searchView;//搜索

@property (nonatomic, strong) UIButton *cancelButton;//取消

- (CGSize)intrinsicContentSize;

@property (nonatomic, copy) void(^searchBlock)(void);

@property (nonatomic, copy) void(^cancelBlock)(void);

@end

/**
 首页 表尾查看更多>
 */
@interface LTSCHomeMoreButtonView : UIControl

@end

@interface LTSCChargeCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *moneyLabel;

@property (nonatomic, strong) UILabel *detailLabel;

@end


@interface LTSCChargeCenterTopView : UIView

@property (nonatomic, copy) void(^didMoneyClickBlock)(NSString *money);

@end
