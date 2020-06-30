//
//  LTSCSearchVC.h
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/17.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTSCSearchVC : BaseTableViewController

@property (nonatomic, assign) BOOL isHome;

@property (nonatomic, assign) BOOL isDianPuSearch;

@property (nonatomic, strong) NSString *shopId;//店铺id

@end

NS_ASSUME_NONNULL_END
