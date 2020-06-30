//
//  LTSCSettingVC.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/21.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LTSCSettingVC.h"
#import "LTSCAccountSafeVC.h"
#import "LTSCLoginVC.h"
#import "NSFileManager+FileSize.h"
#import "LTSCWebViewController.h"

@interface LTSCSettingVC ()

@property (nonatomic, strong) UIButton *bottomButton;//底部创建按钮

@property (nonatomic , assign) CGFloat cacheSize;

@end

@implementation LTSCSettingVC

- (UIButton *)bottomButton {
    if (!_bottomButton) {
        _bottomButton = [[UIButton alloc] init];
        [_bottomButton setTitle:@"退出登录" forState:UIControlStateNormal];
        [_bottomButton setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
        [_bottomButton setBackgroundImage:[UIImage imageNamed:@"white"] forState:UIControlStateNormal];
        _bottomButton.layer.cornerRadius = 3;
        _bottomButton.layer.masksToBounds = YES;
        [_bottomButton addTarget:self action:@selector(exitClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomButton;
}

/**
 退出登录
 */
- (void)exitClick {
    [LTSCLoadingView show];
    self.bottomButton.userInteractionEnabled = NO;
    NSMutableDictionary * dict = @{}.mutableCopy;
    dict[@"token"] = SESSION_TOKEN;
    [LTSCNetworking networkingPOST:app_logout parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        self.bottomButton.userInteractionEnabled = YES;
        [LTSCLoadingView dismiss];
        if ([responseObject[@"key"] integerValue] == 1000) {
            [LTSCToastView showSuccessWithStatus:@"已退出登录"];
            [LTSCTool ShareTool].session_token = nil;
            [LTSCTool ShareTool].userModel = nil;
            [LTSCTool ShareTool].isLogin = NO;
            
            [[EMClient sharedClient] logout:YES];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [LTSCLoadingView dismiss];
        self.bottomButton.userInteractionEnabled = YES;
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    NSString * cachePath = [NSSearchPathForDirectoriesInDomains (NSCachesDirectory , NSUserDomainMask , YES ) firstObject];
    self.cacheSize = [NSFileManager getFileSizeForDir:cachePath];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
    self.tableView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    self.tableView.separatorColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self.view addSubview:self.bottomButton];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(1);
        make.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.bottomButton.mas_top);
    }];
    if (kDevice_Is_iPhoneX) {
        [self.bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tableView.mas_bottom);
            make.leading.equalTo(self.view).offset(15);
            make.trailing.equalTo(self.view).offset(-15);
            make.bottom.equalTo(self.view).offset(-(15 + TableViewBottomSpace));
            make.height.equalTo(@50);
        }];
    }else {
        [self.bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tableView.mas_bottom);
            make.leading.equalTo(self.view).offset(15);
            make.trailing.equalTo(self.view).offset(-15);
            make.bottom.equalTo(self.view).offset(-15);
            make.height.equalTo(@50);
        }];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
        imgView.tag = 222;
        imgView.image = [UIImage imageNamed:@"next"];
        cell.accessoryView = imgView;
    }
    cell.textLabel.textColor = CharacterDarkColor;
    cell.textLabel.font = cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
    cell.detailTextLabel.textColor = CharacterGrayColor;
    if (indexPath.row == 0) {
        cell.textLabel.text = @"账号安全";
        cell.detailTextLabel.text = @"";
    }else if (indexPath.row == 1) {
        cell.textLabel.text = @"清空缓存";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fM",self.cacheSize];
    }else {
        cell.textLabel.text = @"关于质农优选";
        cell.detailTextLabel.text = @"";
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        LTSCAccountSafeVC *vc = [[LTSCAccountSafeVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 1) {
        //清除缓存
        if (self.cacheSize > 0) {
            UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:@"确定要清除缓存吗?" preferredStyle:UIAlertControllerStyleAlert];
            [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
            [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                NSString * path = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/default/com.hackemist.SDWebImageCache.default"];
                [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
                self.cacheSize = 0;
                [LTSCToastView showSuccessWithStatus:@"清理成功" ];
                [self.tableView reloadData];
                
            }]];
            [self presentViewController:alertView animated:YES completion:nil];
        } else {
            [LTSCToastView showInFullWithStatus:@"暂无缓存可清理!"];
        }
    } else {
        LTSCWebViewController *webVC = [[LTSCWebViewController alloc] init];
        webVC.navigationItem.title = @"关于质农优选";
        webVC.loadUrl = [NSURL URLWithString:@"http://www.zmzt99.com/aboutMe.html"];
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

@end
