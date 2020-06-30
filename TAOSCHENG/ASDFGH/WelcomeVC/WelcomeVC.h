//
//  WelcomeVC.h
//  Elem1
//
//  Created by sny on 15/9/23.
//  Copyright (c) 2015年 cznuowang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WelcomeVCDelegate;
@interface WelcomeVC : BaseViewController
@property(nonatomic,strong)NSArray *imgArr;
@property(nonatomic,assign)id<WelcomeVCDelegate>delegate;
@end
@protocol WelcomeVCDelegate <NSObject>

-(void)WelcomeVC:(WelcomeVC *)welcome;

@end
