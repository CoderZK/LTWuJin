//
//  HSPayTwoVC.h
//  huishou
//
//  Created by zk on 2020/5/15.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HSPayTwoVC : BaseViewController
@property(nonatomic,assign)NSInteger type; // 1.0 支付成功 2.0 支付到账 3 充值失败
@end

NS_ASSUME_NONNULL_END
