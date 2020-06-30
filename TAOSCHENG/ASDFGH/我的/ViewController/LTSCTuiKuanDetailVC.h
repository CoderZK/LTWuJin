//
//  LTSCTuiKuanDetailVC.h
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/6/11.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"
#import "LTSCCateModel.h"

typedef NS_ENUM(NSInteger, LTSCTuiKuanDetailVC_type) {
    LTSCTuiKuanDetailVC_type_doing,
    LTSCTuiKuanDetailVC_type_success
};

@interface LTSCTuiKuanDetailVC : BaseTableViewController

@property (nonatomic, strong) LTSCOrderListDetailModel *detailModel;

- (instancetype)initWithTableViewStyle:(UITableViewStyle)style type:(LTSCTuiKuanDetailVC_type)type;

@end

