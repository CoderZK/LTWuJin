//
//  LTSCRegistView.h
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/15.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"
#import "LTSCPutinView.h"

@interface LTSCRegistVC : BaseTableViewController

@end

/**
 企业注册 个人注册
 */
@interface LTSCRegistTopView : UIView

- (CGSize)intrinsicContentSize;

@property (nonatomic, copy) void(^buttonClickBlock)(NSInteger index);

- (void)selectIndex:(NSInteger)index;

@end

/**
 个人注册
 */
@interface LTSCGerenView : UIView

@property (nonatomic, strong) LTSCPutinView *phoneView;//负责人手机号

@property (nonatomic, strong) UIButton *codeButton;//获取验证码

@property (nonatomic, strong) LTSCPutinView *codeView;//验证码

@property (nonatomic, strong) LTSCPutinView *passwordView;//密码

@property (nonatomic, strong) LTSCPutinView *surePasswordView;//确认密码

@property (nonatomic, strong) LTSCRegistXieYiButton *xieYibutton;//用户协议

@property (nonatomic, strong) UIButton *registeButton;//注册

@end
