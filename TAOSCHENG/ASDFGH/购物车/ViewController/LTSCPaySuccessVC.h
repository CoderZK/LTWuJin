//
//  LTSCPaySuccessVC.h
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/21.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTSCPaySuccessVC : BaseTableViewController

@property (nonatomic, strong) NSString  *orderID;//订单号
/**  */
@property(nonatomic , strong)NSString *orderType;//1 跳转到订单列表 // 2 跳转到详情


@end

NS_ASSUME_NONNULL_END
