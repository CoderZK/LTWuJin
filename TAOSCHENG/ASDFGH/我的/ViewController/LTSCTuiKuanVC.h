//
//  LTSCTuiKuanVC.h
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/21.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"
#import "LTSCCateModel.h"

@interface LTSCTuiKuanVC : BaseTableViewController

@property (nonatomic, strong) LTSCOrderDetailModel *goodsModel;//订单详情

@end

@interface LTSCTuiKuanCell : UITableViewCell

@property (nonatomic, strong) LTSCOrderDetailModel *goodsModel;

@end
