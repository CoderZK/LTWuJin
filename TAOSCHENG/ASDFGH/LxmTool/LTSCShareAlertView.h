//
//  LTSCAlertView.h
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/6/7.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LTSCShareAlertView : UIView

- (void)show;

- (void)dismiss;

@property (nonatomic, copy) void(^shareClickBlock)(NSInteger index);

@end

@interface LTSCShareButton : UIButton

@property (nonatomic, strong) UIImageView *iconImgView;//图标

@property (nonatomic, strong) UILabel *textLabel;//文字

@end
