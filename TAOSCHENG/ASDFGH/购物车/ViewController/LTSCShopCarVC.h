//
//  LTSCShopCarVC.h
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/15.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

@interface LTSCShopCarVC : BaseTableViewController

@property (nonatomic, assign) BOOL isTabarVC;

@property (nonatomic, strong) NSString *goodsId;//商品id

@property (nonatomic, copy)void(^tanGuigeViewBlock)(void);

@end

@interface LTSCShopCarBottomView : UIView

@property (nonatomic, strong) UIButton *allSelectButton;//全选

@property (nonatomic, strong) UILabel *allPrice;//合计

@property (nonatomic, strong) UIButton *jiesuanButton;//结算

@end
