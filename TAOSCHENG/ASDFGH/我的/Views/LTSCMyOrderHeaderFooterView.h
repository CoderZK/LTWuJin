//
//  LTSCMyOrderHeaderFooterView.h
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/21.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTSCCateModel.h"

@interface LTSCMyOrderHeaderFooterView : UITableViewHeaderFooterView

@end

@interface LTSCMyOrderHeaderView : UITableViewHeaderFooterView

@property (nonatomic, copy) void(^bgButtonClickBlock)(void);

@property (nonatomic, strong) LTSCOrderListDetailModel *detailModel;

@property (nonatomic, strong) LTSCOrderObjectModel *objModel;
@property (nonatomic, strong) UILabel *stateLabel;//状态
@end

@interface LTSCMyOrderFooterView : UITableViewHeaderFooterView

@property (nonatomic, copy) void(^bgButtonClickBlock)(void);

@property (nonatomic, strong) LTSCOrderObjectModel *objModel;

@property (nonatomic, copy) void(^footerButtonClickBlock)(LTSCOrderObjectModel *objModel, NSInteger index);

@end

@interface LTSCAlertView : UIView

@property (nonatomic, strong) UILabel *timeLabel;//有效期label

@end
