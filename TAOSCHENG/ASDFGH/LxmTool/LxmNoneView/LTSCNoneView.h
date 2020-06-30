//
//  LTSCNoneView.h
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/6/7.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LTSCNoneView : UIControl

@property (nonatomic, copy) void(^clickBlock)(void);

@property (nonatomic, strong) UIButton *loginButton;//登录按钮

- (void)showNoneNetViewAt:(UIView *)view;

- (void)showNoneDataViewAt:(UIView *)view img:(UIImage *)img tips:(NSString *)tips;

- (void)dismiss;

@property (nonatomic, copy) void(^loginButtonBlock)(void);

@end

NS_ASSUME_NONNULL_END
