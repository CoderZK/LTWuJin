//
//  BaseViewController.h
//  LTSC_learnSny海食汇
//
//  Created by sny on 15/10/13.
//  Copyright © 2015年 cznuowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTSCNoneView.h"

@interface BaseViewController : UIViewController

@property (nonatomic, strong) LTSCNoneView *noneView;

- (void)loadMyUserInfoWithOkBlock:(void(^)(BOOL isOk))okBlock;

/**
 获取图片的真实宽高
 */
-(CGSize)getImageSizeWithURL:(id)imageURL;

- (void)gotoLogin;

@end

  
