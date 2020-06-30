//
//  LTSCTool.h
//  emptyCityNote
//
//  Created by 李晓满 on 2017/11/22.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LTSCMineModel.h"


@interface LTSCTool : NSObject
+(LTSCTool *)ShareTool;

@property(nonatomic,assign)bool isLogin;
@property(nonatomic,strong)NSString * session_uid;
@property(nonatomic,strong)NSString * session_token;

@property (nonatomic,strong)LTSCUserInfoModel * userModel;

//推送token
//@property(nonatomic,strong)NSString * deviceToken;

@property(nonatomic,strong)NSString * pushToken;

@property(nonatomic, assign) BOOL isPublic;
@property(nonatomic, copy) void(^okBlock)(void);

-(void)uploadDeviceToken;

/// 登录环信
- (void)loginHuanXin;
- (void)getHuanXinCode;
/** 此处主要用来处理获取环信异常的 */
- (void)getHuanXinCodeTwo;


@end
