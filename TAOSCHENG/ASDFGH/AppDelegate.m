//
//  AppDelegate.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/15.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "AppDelegate.h"
#import "LTSCLoginVC.h"
#import "LTSCTabBarVC.h"
#import "WelcomeVC.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import <UserNotifications/UserNotifications.h>
#import "LTSCWebViewController.h"
#import "LTSCPushModel.h"
#import "LTSCOrderDetailVC.h"
#import "HSPayTwoVC.h"
#import "Crash.h"

#import <UMPush/UMessage.h>
#import <UMShare/UMShare.h>
#import <UMCommon/UMCommon.h>

#import <WXApi.h>
//https://lanhuapp.com/url/YR5KS-b3iNv   电商
//https://lanhuapp.com/url/KCZf4-VpZB9   回收
//https://www.czmakj.com/collect/API%E6%96%87%E6%A1%A3.html
//https://note.youdao.com/ynoteshare1/mobile.html?id=c8c74195c3d4bfadb48ff3ffb01c1070&type=note
//禅道bug 地址  http://www.biuworks.com/zentao/user-login.html

//电商测试账号 13951227244 密码 123456 或 111111
//回收测试账号 13951227243 密码 123456 或 111111

//苹果帐号：tnroqb@163.com 帐号密码：Gg11223344 邮箱密码：x05652 验证手机：13316478532
//友盟账号 awiwwiw  密码 zft20200401

#define HuanXin_AppKey @"1109200401065660#dianshangappios"
#define HuanXin_ClientID @"YXA6TyTro2oOT_-MsF1PNAI18g"
#define HuanXin_ClientSecret @"YXA69sKwSGVQPyfHdvuRqCWL-JHs3FA"

//上架苹果账号
//电商苹果帐号：tnroqb@163.com    掌盟公司名称
//帐号密码：Gg11223344
//邮箱密码：x05652
//验证手机：13316478532
#define UMKey @"5eb6555d167edde483000500"
//友盟安全密钥//r6xbw5gy0zenei6x56xtm9wmkrrz653y

//新浪
#define SinaAppKey @"3386016286"
#define SinaAppSecret @"081a4efee947710f9082ab3f0a7b8de8"

//微信
#define WXAppID @"wx04d5152632699702"
#define WXAppSecret @"d0783c077a6eeab29c8669237263b4c3"

//QQ
#define QQAppID @"1110575800"
#define QQAppKey @"CeFZ9Hw61B0UOYFe"



@interface AppDelegate ()<WelcomeVCDelegate,UNUserNotificationCenterDelegate,WXApiDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.backgroundColor = UIColor.whiteColor;
    [UIApplication sharedApplication].statusBarStyle =  UIStatusBarStyleDefault;
    
    
    self.window.rootViewController = [self instantiateRootVC];
    
    [self.window makeKeyAndVisible];
    
    //    /* 设置友盟appkey分享用 */
    //    [[UMSocialManager defaultManager] setUmSocialAppkey:UMKey];
    //    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    //
    //    [self configUSharePlatforms];
    //    [self initUMeng:launchOptions];
    
    [WXApi registerApp:WXAppID universalLink:@"https://www.zmzt99.com/wujin/"];
    [self initPush];
    [self initUMeng:launchOptions];
    
    // U-Share 平台设置
    [self configUSharePlatforms];
    
    
    [self initHuanXin];
    
    
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    // 发送崩溃日志
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *dataPath = [path stringByAppendingPathComponent:@"error.log"];
    
    NSData *data = [NSData dataWithContentsOfFile:dataPath];
    NSString *content=[NSString stringWithContentsOfFile:dataPath encoding:NSUTF8StringEncoding error:nil];
    if (data != nil) {
        NSString *content=[NSString stringWithContentsOfFile:dataPath encoding:NSUTF8StringEncoding error:nil];
        [self  updateErrLogWithContent:content];
    }
    return YES;
}

- (void)updateErrLogWithContent:(NSString *)content{
    NSMutableDictionary * dict = @{}.mutableCopy;
    dict[@"param"] = content;
    
    [LTSCNetworking networkingPOST:error_file_up parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",@"uuuu");
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",@"ffff");
    }];
    
    
    
}


//设置根视图控制器
- (UIViewController *)instantiateRootVC{
    
    //    //没有引导页
    //    TabBarController *BarVC=[[TabBarController alloc] init];
    //    return BarVC;
    
    
    
    //获取app运行的版本号
    NSString *currentVersion =[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    //取出本地缓存的版本号
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *localVersion = [defaults objectForKey:@"appversion"];
    if ([currentVersion isEqualToString:localVersion]) {
        
        return [[LTSCTabBarVC alloc] init];
    }else{
        WelcomeVC *welcome = [[WelcomeVC alloc] init];
        welcome.delegate = self;
        welcome.imgArr = @[
            @"yindaoye1",
            @"yindaoye2",
            @"yindaoye3"
        ];
        
        return welcome;
    }
}



- (void)configUSharePlatforms
{
    
    //打开图片水印
    [UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    //关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WXAppID appSecret:WXAppSecret redirectURL:@"http://mobile.umeng.com/social"];
    /*
     * 移除相应平台的分享，如微信收藏
     */
    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQAppID/*设置QQ平台的appID*/  appSecret:QQAppKey redirectURL:@"http://mobile.umeng.com/social"];
    
    /* 设置新浪的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:SinaAppKey  appSecret:SinaAppSecret redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
    
    
}

-(void)initPush
{
    //1.向系统申请推送
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        
        UIUserNotificationSettings *uns = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:uns];
    }
    else
    {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
#else
    UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge);
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
#endif
    
}


-(void)initUMeng:(NSDictionary *)launchOptions
{
    [UMConfigure initWithAppkey:UMKey channel:@"App Store"];
    // Push组件基本功能配置
    UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
    //type是对推送的几个参数的选择，可以选择一个或者多个。默认是三个全部打开，即：声音，弹窗，角标
    entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionSound|UMessageAuthorizationOptionAlert;
    if (@available(iOS 10.0, *)) {
        [UNUserNotificationCenter currentNotificationCenter].delegate=self;
        
    } else {
        // Fallback on earlier versions
    }
    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity     completionHandler:^(BOOL granted, NSError * _Nullable error) {
        
        
        if (error) {
            NSLog(@"error===%@",error.description);
        }
        
        if (granted) {
            
        }else{
        }
    }];
    
}


//在用户接受推送通知后系统会调用
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    
    //    self.pushToken = deviceToken;
    //    if (![LTSCTool ShareTool].isClosePush)
    //    {
    [UMessage registerDeviceToken:deviceToken];
    NSString * token = @"";
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 13) {
        if (![deviceToken isKindOfClass:[NSData class]]) {
            //记录获取token失败的描述
            return;
        }
        const unsigned *tokenBytes = (const unsigned *)[deviceToken bytes];
        token = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                 ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                 ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                 ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
        NSLog(@"deviceToken1:%@", token);
    } else {
        token = [NSString
                 stringWithFormat:@"%@",deviceToken];
        token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
        token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
        token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
        
    }
    //将deviceToken给后台
    NSLog(@"send_token:%@",token);
    [LTSCTool ShareTool].pushToken = token;
    [[LTSCTool ShareTool] uploadDeviceToken];
    //    }
    //    else
    //    {
    //        [UMessage registerDeviceToken:nil];
    //        [LTSCTool ShareTool].deviceToken = @"";
    //        [[LTSCTool ShareTool] uploadDeviceToken];
    //    }
    //
    
    
    //    self.pushToken = deviceToken;
    //    if (![LTSCTool ShareTool].isClosePush)
    //    {
    //        [UMessage registerDeviceToken:deviceToken];
    //        //2.获取到deviceToken
    //        NSString *token = [[[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
    //
    //        //将deviceToken给后台
    //        NSLog(@"send_token:%@",token);
    //        [LTSCTool ShareTool].deviceToken = token;
    //        [[LTSCTool ShareTool] uploadDeviceToken];
    //    }
    //    else
    //    {
    //        [UMessage registerDeviceToken:nil];
    //        [LTSCTool ShareTool].deviceToken = @"";
    //        [[LTSCTool ShareTool] uploadDeviceToken];
    //    }
    
}
//iOS10以下使用这两个方法接收通知
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [UMessage setAutoAlert:NO];
    if([[[UIDevice currentDevice] systemVersion]intValue] < 10){
        [UMessage didReceiveRemoteNotification:userInfo];
    }
    //过滤掉Push的撤销功能，因为PushSDK内部已经调用的completionHandler(UIBackgroundFetchResultNewData)，
    //防止两次调用completionHandler引起崩溃
    if(![userInfo valueForKeyPath:@"aps.recall"])
    {
        completionHandler(UIBackgroundFetchResultNewData);
    }
}
//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [UMessage setAutoAlert:NO];
        //应用处于前台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
    }else{
        //应用处于前台时的本地推送接受
    }
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}
//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    NSLog(@"===\n3===%@",userInfo);
    if (@available(iOS 10.0, *)) {
        if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [UMessage didReceiveRemoteNotification:userInfo];
            [UMessage setAutoAlert:NO];
            //应用处于前台时的远程推送接受
            //必须加这句代码
            [UMessage didReceiveRemoteNotification:userInfo];
            
            
            LTSCPushModel *model = [LTSCPushModel mj_objectWithKeyValues:userInfo];
            // 1-系统通知(infoUrl有值时跳转)，2-发货中 3-退款中 4-退款成功 5-退款失败
            LTSCTabBarVC * bar = (LTSCTabBarVC *)self.window.rootViewController;
            BaseNavigationController * nav  = (BaseNavigationController *)bar.selectedViewController;
            [self pageTo:model nav:nav];
            
        }else{
            //应用处于前台时的本地推送接受
            LTSCPushModel *model = [LTSCPushModel mj_objectWithKeyValues:userInfo];
            //  1-系统通知(infoUrl有值时跳转)，2-发货中 3-退款中 4-退款成功 5-退款失败
            LTSCTabBarVC * bar = (LTSCTabBarVC *)self.window.rootViewController;
            BaseNavigationController * nav  = (BaseNavigationController *)bar.selectedViewController;
            [self pageTo:model nav:nav];
        }
    } else {
        // Fallback on earlier versions
    }
    if (@available(iOS 10.0, *)) {
        completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
    } else {
        // Fallback on earlier versions
    }
}


//10一下的系统
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    [UMessage didReceiveRemoteNotification:userInfo];
    
    NSLog(@"===\n1===%@",userInfo);
    
    LTSCPushModel *model = [LTSCPushModel mj_objectWithKeyValues:userInfo];
    if (![LTSCTool ShareTool].isLogin) {
        [SVProgressHUD showErrorWithStatus:@"您目前处于离线状态"];
        return;
    }
    //1-系统通知，2-代理变动，3-钱包消息，4-接单消息，5-订单消息，6-投诉消息，7-素材消息
    LTSCTabBarVC * bar = (LTSCTabBarVC *)self.window.rootViewController;
    BaseNavigationController * nav  = (BaseNavigationController *)bar.selectedViewController;
    [self pageTo:model nav:nav];
    
}

- (void)pageTo:(LTSCPushModel *)model nav:(BaseNavigationController *)nav {
    
    if (model.infoType.intValue == 1) {
        if (model.infoUrl.isValid) {
            LTSCWebViewController *vc = [[LTSCWebViewController alloc] init];
            vc.navigationItem.title = @"系统消息";
            vc.loadUrl = [NSURL URLWithString:model.infoUrl];
            vc.hidesBottomBarWhenPushed = YES;
            [nav pushViewController:vc animated:YES];
        }
    }else if (model.infoType.intValue <= 5) {
        LTSCOrderDetailVC *vc = [[LTSCOrderDetailVC alloc] initWithTableViewStyle:UITableViewStyleGrouped];
        vc.orderID = model.infoId;
        vc.hidesBottomBarWhenPushed = YES;
        [nav pushViewController:vc animated:YES];
    }else if (model.infoType.intValue  == 6) {//
        HSPayTwoVC *vc = [[HSPayTwoVC alloc] init];
        vc.type = 2;
        vc.hidesBottomBarWhenPushed = YES;
        [nav pushViewController:vc animated:YES];
    }else if (model.infoType.intValue == 7) {
        HSPayTwoVC *vc = [[HSPayTwoVC alloc] init];
        vc.type = 3;
        vc.hidesBottomBarWhenPushed = YES;
        [nav pushViewController:vc animated:YES];
    }
}


#pragma mark -支付宝 微信支付
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    //跳转到支付宝支付的情况
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            //发送一个通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ZFBPAY" object:resultDic];
            NSLog(@"result ======================== %@",resultDic);
        }];
    } else if ([url.absoluteString hasPrefix: [NSString stringWithFormat:@"%@://pay",WXAppID]] ) {
        //微信
        [WXApi handleOpenURL:url delegate:self];
        
    }else {//友盟
        //        [[UMSocialManager defaultManager] handleOpenURL:url];
    }
    return YES;
    
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    //跳转到支付宝支付的情况
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            //发送一个通知,告诉支付界面要做什么
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ZFBPAY" object:resultDic];
            NSLog(@"result ======================== %@",resultDic);
        }];
    } else if ([url.absoluteString hasPrefix: [NSString stringWithFormat:@"%@://pay",WXAppID]] ) {
        
        [WXApi handleOpenURL:url delegate:self];
        
        
    }else {
        //        [[UMSocialManager defaultManager] handleOpenURL:url];
    }
    
    return YES;
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    //跳转到支付宝支付的情况
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            //发送一个通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ZFBPAY" object:resultDic];
            
            NSLog(@"result ======================== %@",resultDic);
        }];
    } else if ([url.absoluteString hasPrefix: [NSString stringWithFormat:@"%@://pay",WXAppID]] ) {
        [WXApi handleOpenURL:url delegate:self];
        
    }else {
        //        [[UMSocialManager defaultManager] handleOpenURL:url options:options];
    }
    return YES;
}
//微信支付结果
- (void)onResp:(BaseResp *)resp {
    //发送一个通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WXPAY" object:resp];
}



-(void)WelcomeVC:(WelcomeVC *)welcome {
    //更新本地储存的版本号
    
    NSString *currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:@"appversion"];
    //同步到物理文件存储
    [[NSUserDefaults standardUserDefaults] synchronize];
    [UIApplication sharedApplication].statusBarHidden = NO;
    self.window.rootViewController = [[LTSCTabBarVC alloc] init];
}

/// 注册环信
- (void)initHuanXin {
    //         appkey替换成自己在环信管理后台注册应用中的appkey
    EMOptions *options = [EMOptions optionsWithAppkey:HuanXin_AppKey];
    // apnsCertName是证书名称，可以先传nil，等后期配置apns推送时在传入证书名称
    options.apnsCertName = @"scPushDEV";
    [[EMClient sharedClient] initializeSDKWithOptions:options];
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
