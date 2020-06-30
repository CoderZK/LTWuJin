//
//  LTSCTool.m
//  emptyCityNote
//
//  Created by 李晓满 on 2017/11/22.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "LTSCTool.h"

static LTSCTool * __tool = nil;
@implementation LTSCTool
@synthesize isLogin = _isLogin;

+(LTSCTool *)ShareTool
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __tool=[[LTSCTool alloc] init];
    });
    return __tool;
}
- (instancetype)init
{
    if (self = [super init])
    {
        _isLogin = [self isLogin];
    }
    return self;
}
-(void)setIsLogin:(BOOL)isLogin
{
    _isLogin = isLogin;
    [[NSUserDefaults standardUserDefaults] setBool:isLogin forKey:@"isLogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(BOOL)isLogin {
    _isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"];
    return _isLogin;
}

-(void)setSession_token:(NSString *)session_token {
    [[NSUserDefaults standardUserDefaults] setObject:session_token forKey:@"session_token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSString *)session_token {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"session_token"];
}

- (void)setSession_uid:(NSString *)session_uid {
    [[NSUserDefaults standardUserDefaults] setObject:session_uid forKey:@"session_uid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString *)session_uid {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"session_uid"];
}

- (void)setDeviceToken:(NSString *)deviceToken {
    [[NSUserDefaults standardUserDefaults] setObject:deviceToken forKey:@"deviceToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString *)deviceToken {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
}

- (void)setUserModel:(LTSCUserInfoModel *)userModel{
    if (userModel) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userModel];
        if (data) {
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"userModel"];
        }
    }
}
- (LTSCUserInfoModel *)userModel{
    //取出
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"userModel"];
    if (data) {
        LTSCUserInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        return model;
    }
    return nil;
}

-(void)uploadDeviceToken
{
    if (self.session_token&&self.pushToken)
    {
        NSDictionary * dic = @{
            @"dev_id":[[[UIDevice currentDevice] identifierForVendor] UUIDString],
            @"token":self.session_token,
            @"umeng_id":self.pushToken,
            @"device_type":@1,
            @"send_status":@"1"
        };
        [LTSCNetworking networkingPOST:umeng_id_up parameters:dic returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"推送token上传成功:%@",responseObject);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }
}

- (void)getHuanXinCode {
    
    NSMutableDictionary * dic = @{}.mutableCopy;
    dic[@"token"] = self.session_token;
    [LTSCNetworking networkingPOST:get_huanxin parameters:dic returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject[@"key"] intValue] == 1000) {
            LTSCUserInfoModel * model =  [LTSCTool ShareTool].userModel;
            model.imCode = responseObject[@"result"][@"map"][@"imCode"];
            model.imPass = responseObject[@"result"][@"map"][@"imPass"];
            [LTSCTool ShareTool].userModel = model;
            //登录环信
            [self loginHuanXin];
            
        }else {
            self.userModel.imCode = @"";
            self.userModel.imPass = @"";
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}

/** 此处主要用来处理获取环信异常的 */
- (void)getHuanXinCodeTwo {
    
    NSMutableDictionary * dic = @{}.mutableCopy;
    dic[@"token"] = self.session_token;
    [LTSCNetworking networkingPOST:get_huanxin parameters:dic returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject[@"key"] intValue] == 1000) {
            LTSCUserInfoModel * model =  [LTSCTool ShareTool].userModel;
            model.imCode = responseObject[@"result"][@"map"][@"imCode"];
            model.imPass = responseObject[@"result"][@"map"][@"imPass"];
            [LTSCTool ShareTool].userModel = model;
            //登录环信
            [self loginHuanXin];
            
        }else {
            [SVProgressHUD showErrorWithStatus:@"聊天功能暂时无法使用，请稍后再试"];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}

/// 登录环信
- (void)loginHuanXin {
    // 传入在应用（appkey）下注册的IM用户user1，密码123，用于登录环信服务
    [[EMClient sharedClient] loginWithUsername:self.userModel.imCode password:self.userModel.imPass completion:^(NSString *aUsername, EMError *aError) {
        if (!aError) {
            NSLog(@"登录成功");
        } else {
            NSLog(@"登录失败的原因---%@", aError.errorDescription);
        }
    }];
}




@end
