//
//  BaseViewController.m
//  LTSC
//
//  Created by LTSC on 15/10/13.
//  Copyright © 2015年 LTSC. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()<UIGestureRecognizerDelegate>

@end
@implementation BaseViewController

- (LTSCNoneView *)noneView {
    if (!_noneView) {
        _noneView= [[LTSCNoneView alloc] init];
    }
    return _noneView;
}


- (BOOL)shouldAutorotate
{
    return NO;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
	return NO;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = BGGrayColor;
    
    self.navigationController.navigationBar.tintColor = CharacterGrayColor;
    if (self.navigationController.viewControllers.count > 1) {
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"home_back"] style:UIBarButtonItemStyleDone target:self action:@selector(baseLeftBtnClick)];
        leftItem.tintColor = CharacterGrayColor;
//        leftItem.imageInsets = UIEdgeInsetsMake(0, -10, 0, 10);
        self.navigationItem.leftBarButtonItem = leftItem;
    }
    
}

- (void)baseLeftBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //开启iOS7的滑动返回效果
//    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        //只有在二级页面生效
//        if ([self.navigationController.viewControllers count] > 1) {
//            self.navigationController.interactivePopGestureRecognizer.delegate = self;
//        } else {
//            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
//        }
//    }
}


- (void)loadMyUserInfoWithOkBlock:(void(^)(BOOL isOK))okBlock {
    //获取个人信息
    
    NSMutableDictionary * dict = @{}.mutableCopy;
    dict[@"token"] = SESSION_TOKEN;
    
    [LTSCNetworking networkingPOST:my_info parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"key"] integerValue] == 1000) {
            [LTSCTool ShareTool].userModel = [LTSCUserInfoModel mj_objectWithKeyValues:responseObject[@"result"][@"map"]];
//            [MobClick profileSignInWithPUID:[LTSCTool ShareTool].userModel.user_id];
            [LTSCEventBus sendEvent:@"userInfo" data:nil];
            if (okBlock) {
                okBlock(YES);
            }
        } else {
            if (okBlock) {
                okBlock(NO);
            }
            [UIAlertController showAlertWithKey:responseObject[@"key"] message:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {

    }];
}

-(CGSize)getImageSizeWithURL:(id)imageURL {
    NSURL* URL = nil;
    if([imageURL isKindOfClass:[NSURL class]]) {
        URL = imageURL;
    }
    if([imageURL isKindOfClass:[NSString class]]) {
        URL = [NSURL URLWithString:imageURL];
    }
    NSData *data = [NSData dataWithContentsOfURL:URL];UIImage *image = [UIImage imageWithData:data];
    return CGSizeMake(image.size.width, image.size.height);
}

- (void)gotoLogin {
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:[[LTSCLoginVC alloc] init]];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
    
}

@end
