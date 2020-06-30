//
//  LTSCSubYouHuiQuanVC.h
//  TAOSCHENG
//
//  Created by 李晓满 on 2020/4/9.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

@interface LTSCSubYouHuiQuanVC : BaseTableViewController

@property (nonatomic, strong) NSString *index;

@end

@interface LTSCSubYouHuiQuanCell : UITableViewCell

@property (nonatomic, strong) NSString *index;

@property (nonatomic, strong) LTSCYouHuiQuanModel *model;

@property (nonatomic, strong) LTSCYouHuiQuanModel *cellModel;

@property (nonatomic, strong) LTSCYouHuiQuanModel *userModel;

@property (nonatomic, copy) void(^userClickBlock)(LTSCYouHuiQuanModel *model);

@end
