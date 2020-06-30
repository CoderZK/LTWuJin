//
//  LTSCHomeVC.h
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/15.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

@interface LTSCHomeVC : BaseTableViewController

@end

/**
 导航栏部分的搜索栏
 */
@interface LTSCHomeSearchView : UIView

@property (nonatomic, strong) UIButton *bgButton;//背景按钮

@property (nonatomic, strong) UITextField *searchTF;//搜索栏

@end
