//
//  LTSCCutomBar.m
//  TAOSCHENG
//
//  Created by kunzhang on 2020/6/8.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "LTSCCutomBar.h"
#import "LTSCDianPuTabBarController.h"
#import "EMChatViewController.h"
@implementation LTSCCutomBar


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
//        [self setBackgroundImage:[UIImage imageNamed:@"alpha"]];
//        [self setShadowImage:[UIImage imageNamed:@"alpha"]];
//        self.translucent = NO;
//        //给一个tabbar加阴影
//        self.backgroundColor = [UIColor whiteColor];
//        self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
//        //阴影偏移
//        self.layer.shadowOffset = CGSizeMake(0.5, 0.5);
//        //阴影透明度
//        self.layer.shadowOpacity = 0.5;
//        //阴影半径
//        self.layer.shadowRadius = 5;
        
        
        
        UIButton *publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [publishButton setBackgroundImage:[UIImage imageNamed:@"dianpu_kefu_n"] forState:(UIControlStateNormal)];
        publishButton.frame = CGRectMake(0, 0, 49, 49);
        publishButton.backgroundColor = [UIColor redColor];
        [self addSubview:publishButton];
//        self.publishButton = publishButton;
        [publishButton addTarget:self action:@selector(pushView) forControlEvents:UIControlEventTouchUpInside];
        
//        [self setBackgroundImage:[UIImage imageNamed:@"tabbarImage.png"]];
//        // [UITabBar appearance].clipsToBounds = YES; // 添加的图片大小不匹配的话，加上此句，屏蔽掉tabbar多余部分
//        [self setShadowImage:[UIImage imageNamed:@"tabbarImage.png"]];
        
//        CGRect rect = CGRectMake(0, 0, frame.size.width, frame.size.height);
//        UIGraphicsBeginImageContext(rect.size);
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
//        CGContextFillRect(context, rect);
//        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//
//        [self setBackgroundImage:img];
//        // [UITabBar appearance].clipsToBounds = YES; // 添加的图片大小不匹配的话，加上此句，屏蔽掉tabbar多余部分
//        [self setShadowImage:img];
        
        
        
    }
   
    return self;
}



- (void)pushView {//弹出中间发布页面

  
    
}

@end
