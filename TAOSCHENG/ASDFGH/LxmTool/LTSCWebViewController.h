//
//  LTSCWebViewController.h
//  zhima
//
//  Created by LTSC on 14/11/19.
//  Copyright (c) 2014年 LTSC. All rights reserved.
//
#import "BaseViewController.h"

#define PregressColor MainColor

@interface LTSCWebViewController: BaseViewController
@property(nonatomic,strong)NSURL * loadUrl;
@property(nonatomic,strong)NSString * postParames;
-(void)loadHtmlStr:(NSString *)htmlStr withBaseUrl:(NSString *)urlStr;
@end
