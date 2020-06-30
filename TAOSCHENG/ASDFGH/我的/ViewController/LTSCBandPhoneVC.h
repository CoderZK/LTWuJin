//
//  LTSCBandPhoneVC.h
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/21.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"


@interface LTSCBandPhoneVC : BaseTableViewController

@property (nonatomic, strong) NSString *oneCode;

@end

@interface LTSCBandPhoneHeaderView : UIView

@property (nonatomic, strong) UITextField *phoneTF;//手机号

@property (nonatomic, strong) UITextField *codeTF;//验证码

@property (nonatomic, strong) UIButton *sendCodeBtn;//发送验证码

@end

@interface LTSCBandPhoneFooterView : UIView

@property (nonatomic, strong) UILabel *textLabel;//验证码

@end

