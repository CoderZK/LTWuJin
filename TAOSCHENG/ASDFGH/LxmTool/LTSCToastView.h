//
//  LTSCToastView.h
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/6/11.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LTSCToastView : UIView

+ (void)showSuccessWithStatus:(NSString *)string;

+ (void)showErrorWithStatus:(NSString *)string;

+ (void)showInFullWithStatus:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
