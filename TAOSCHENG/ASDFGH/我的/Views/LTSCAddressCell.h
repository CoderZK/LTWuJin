//
//  LTSCAddressCell.h
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/20.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTSCAddressModel.h"
#import "LTSCCateModel.h"

@interface LTSCAddressCell : UITableViewCell

@property (nonatomic, strong) LTSCAddressListModel *model;

@property (nonatomic, assign) BOOL isSureOrder;

@property (nonatomic, strong) UIButton *editBtn;//编辑

@property (nonatomic, copy) void(^editBlock)(LTSCAddressListModel *model);

@end

@interface LTSCOrderStateCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UILabel *stateLabel;

@property (nonatomic, strong) LTSCOrderListDetailModel *model;

@end
