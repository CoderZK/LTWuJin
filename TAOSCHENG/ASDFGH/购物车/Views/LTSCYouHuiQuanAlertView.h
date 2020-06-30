//
//  LTSCYouHuiQuanAlertView.h
//  TAOSCHENG
//
//  Created by 李晓满 on 2020/4/15.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTSCYouHuiQuanAlertView : UIView

@property (nonatomic, assign) double allPrice;//商品金额

@property (nonatomic, strong) NSMutableArray <LTSCYouHuiQuanModel *>*youhuiquanArr;//优惠券数据

@property (nonatomic, copy) void(^didSelectYouHuiQuanModelBlock)(LTSCYouHuiQuanModel *model);

- (void)show;

- (void)dismiss;

@end

