//
//  LTSCNewAddressVC.h
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/20.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"
#import "LTSCAddressModel.h"

@interface LTSCNewAddressVC : BaseTableViewController

@property (nonatomic, strong) LTSCAddressListModel *editModel;

@end

@interface LTSCLeftTextRightTFView : UIView

@property (nonatomic, strong) UILabel *leftLabel;//左侧label

@property (nonatomic, strong) UITextField *rightTF;//右侧输入框

@property (nonatomic, strong) UIView *lineView;//线

@end


@interface LTSCLeftTextRightTFView1 : UIButton

@property (nonatomic, strong) UILabel *leftLabel;//左侧label

@property (nonatomic, strong) UILabel *rightLabel;//右侧label

@property (nonatomic, strong) UIView *lineView;//线

@end
