//
//  LTSCVerifyIdentifyVC.h
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/21.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

@interface LTSCVerifyIdentifyVC : BaseTableViewController

@property (nonatomic, copy) void(^firstStepSuccessBlock)(void);

@end

@interface LTSCVerifyIdentifyHeaderView : UIView

@property (nonatomic, strong) UITextField *phoneTF;//手机号

@property (nonatomic, strong) UITextField *codeTF;//验证码

@property (nonatomic, strong) UIButton *sendCodeBtn;//发送验证码

@end
