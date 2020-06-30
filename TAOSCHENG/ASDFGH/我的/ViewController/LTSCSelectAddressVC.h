//
//  LTSCSelectAddressVC.h
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/20.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"
#import "LTSCCateModel.h"


@interface LTSCSelectAddressVC : BaseTableViewController

@property (nonatomic, assign) BOOL isSelect;

@property (nonatomic, copy) void(^selectAddressModelClick)(LTSCGoodsDetailAdressModel *addressModel);

@end


@interface LTSCEmptyAddressView : UIView

@end
