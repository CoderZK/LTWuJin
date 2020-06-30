//
//  LTSCSelectPayTypeVC.h
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/20.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTSCSelectPayTypeVC : BaseTableViewController

@property (nonatomic, assign) CGFloat allPrice;//商品金额

@property (nonatomic, strong) NSString  *orderID;//订单号

/**  */
@property(nonatomic , strong)NSString *orderCode;

@property(nonatomic,strong)NSString *phoneStr,*moneyStr;

@property (nonatomic, assign) BOOL isChongZhi;//商品金额

@end

NS_ASSUME_NONNULL_END
