//
//  UIViewController+shareAction.h
//  BYXuNiPan
//
//  Created by zk on 2018/7/17.
//  Copyright © 2018年 kunzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class zkHomelModel;
@interface UIViewController (shareAction)
- (void)shareWithSetPreDefinePlatforms:(NSArray *)platforms withUrl:(NSString *)url shareModel:(NSString *)imgStr withContentStr:(NSString *)contentStr andTitle:(NSString * )titleStr;





@end
