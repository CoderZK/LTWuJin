//
//  LTSCMineVC.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/15.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LTSCMineVC.h"
#import "LTSCMineHeaderView.h"
#import "LTSCSelectAddressVC.h"
#import "LTSCUserInfoVC.h"
#import "LTSCSettingVC.h"
#import "LTSCMyOrderVC.h"
#import <SDWebImage/UIImage+GIF.h>
#import "LTSCLoginVC.h"
#import "LTSCDianPuAttentionVC.h"
#import "LTSCYouHuiQuanVC.h"

@interface LTSCMineVC ()

@property (nonatomic, strong) LTSCMineUserView *navView;//导航栏

@property (nonatomic, strong) LTSCMineHeaderView *headerView;//表头视图

@end

@implementation LTSCMineVC

- (LTSCMineUserView *)navView {
    if (!_navView) {
        _navView = [[LTSCMineUserView alloc] init];
        _navView.backgroundColor = MineColor;
        [_navView.dianpuButton addTarget:self action:@selector(dianpuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_navView.youhuiquanButton addTarget:self action:@selector(dianpuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
         [_navView.messageBt addTarget:self action:@selector(messageAction) forControlEvents:UIControlEventTouchUpInside];
        [_navView.topButton addTarget:self action:@selector(topAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navView;
}

- (LTSCMineHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[LTSCMineHeaderView alloc] initWithFrame:CGRectMake(0, 150, ScreenW, 190)];
        _headerView.backgroundColor = [UIColor clearColor];
    }
    return _headerView;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    if (ISLOGIN && SESSION_TOKEN) {
        WeakObj(self);
      
     
        
          [self loadMyUserInfoWithOkBlock:^(BOOL isOk) {
              if (isOk == NO) {
                  [self endRefrish];
                  return;
                  
              }
            selfWeak.headerView.model = [LTSCTool ShareTool].userModel;
            selfWeak.navView.infoMode = [LTSCTool ShareTool].userModel;
            [selfWeak.tableView reloadData];
        }];
        self.navView.messageBt.hidden = NO;
        NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
        NSInteger unreadCount = 0;
        for (EMConversation *conversation in conversations) {
            unreadCount += conversation.unreadMessagesCount;
        }
        if (unreadCount > 0) {
            [self.navView.messageBt setImage:[UIImage imageNamed:@"mmd"] forState:UIControlStateNormal];
        }else {
            [self.navView.messageBt setImage:[UIImage imageNamed:@"mmk"] forState:UIControlStateNormal];
        }
    } else {
        self.headerView.model = nil;
        self.navView.infoMode = nil;
//        self.headerView
        self.navView.messageBt.hidden = YES;
    
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubviews];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    WeakObj(self);
//    self.navView.topBtnClickBlock = ^{
//
//    };
    self.headerView.buttonClickBlock = ^(NSInteger index) {
        [selfWeak pageTo:index + 1];
    };
    self.headerView.seeAllOrderBlock = ^{
        [selfWeak pageTo:0];
    };

    [LTSCEventBus registerEvent:@"backHomeVC" block:^(id data) {
        selfWeak.tabBarController.selectedIndex = 0;
    }];
    [LTSCEventBus registerEvent:@"goHomeClick" block:^(id data) {
        selfWeak.tabBarController.selectedIndex = 0;
        [selfWeak.navigationController popToRootViewControllerAnimated:YES];
    }];
    
    if (ISLOGIN && SESSION_TOKEN) {
        LTSCRefreshHeader *header = [LTSCRefreshHeader headerWithRefreshingBlock:^{
             [self loadMyUserInfoWithOkBlock:^(BOOL isOk) {
                         if (isOk == NO) {
                             [self endRefrish];
                             return;
                         }
                [self endRefrish];
                self.headerView.model = [LTSCTool ShareTool].userModel;
                self.navView.infoMode = [LTSCTool ShareTool].userModel;
            }];
        }];
        NSMutableArray *imgs = [NSMutableArray array];
        UIImage *img = [UIImage sd_imageWithGIFData:[NSData dataWithContentsOfFile:[NSBundle.mainBundle pathForResource:@"refresh_white.gif" ofType:nil]]];
        
        for (UIImage *imgItem in img.images) {
            NSData *data = UIImagePNGRepresentation(imgItem);
            UIImage *image = [UIImage imageWithData:data scale:3];
            [imgs addObject:image];
        }
        [header setImages:imgs forState:MJRefreshStatePulling];
        [header setImages:imgs forState:MJRefreshStateRefreshing];
        [header setImages:imgs forState:MJRefreshStateIdle];
        header.stateLabel.textColor = UIColor.whiteColor;
        self.tableView.mj_header = header;
    }

    [LTSCEventBus registerEvent:@"loginSuccess" block:^(id data) {
         [self endRefrish];
        self.headerView.model = [LTSCTool ShareTool].userModel;
        self.navView.infoMode = [LTSCTool ShareTool].userModel;
    }];
}

- (void)initSubviews {
    [self.view addSubview:self.navView];
    [self.view bringSubviewToFront:self.tableView];
    [self.view sendSubviewToBack:self.navView];
//    [self.view addSubview:self.headerView];
    self.tableView.tableHeaderView = self.headerView;
    
    
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.height.equalTo(@(NavigationSpace + 120));
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navView.mas_bottom);
        make.leading.trailing.bottom.equalTo(self.view);
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [scrollView bringSubviewToFront:scrollView.mj_header];
    if (scrollView.contentOffset.y <= 0) {
        self.headerView.hearderView1.frame = CGRectMake(0, scrollView.contentOffset.y, ScreenW, self.headerView.frame.size.height - scrollView.contentOffset.y);
        NSLog(@"%@", NSStringFromCGRect(self.headerView.hearderView1.frame));
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LTSCMineCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LTSCMineCell"];
    if (!cell) {
        cell = [[LTSCMineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LTSCMineCell"];
    }
    cell.index = indexPath.row;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        if (ISLOGIN && SESSION_TOKEN) {
            LTSCSelectAddressVC *vc = [[LTSCSelectAddressVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [self gotoLogin];
        }
    }else {
        if (ISLOGIN && SESSION_TOKEN) {
            LTSCSettingVC *vc = [[LTSCSettingVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [self gotoLogin];
        }
    }
}


- (void)pageTo:(NSInteger)index {
    if (ISLOGIN && SESSION_TOKEN) {
        LTSCMyOrderVC *vc = [[LTSCMyOrderVC alloc] init];
        vc.index = index;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [self gotoLogin];
    }
}

//点击消息
- (void)messageAction{
    
    if (ISLOGIN) {
        
        if ([LTSCTool ShareTool].userModel.imCode.length == 0) {
            [[LTSCTool ShareTool] getHuanXinCodeTwo];
            return;
        }
        
        
           EMConversationsViewController *conversationVC = [[EMConversationsViewController alloc] init];
        conversationVC.hidesBottomBarWhenPushed = YES;
        UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] init];
        backBarButtonItem.title = @"";
         self.navigationItem.backBarButtonItem = backBarButtonItem;
           [self.navigationController pushViewController:conversationVC animated:YES];
       }else {
        LTSCLoginVC *vc = [[LTSCLoginVC alloc] init];
        BaseNavigationController * nav  = [[BaseNavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
       }
    
}

//点击登录或者修改问题
- (void)topAction {
    if (ISLOGIN && SESSION_TOKEN) {
                LTSCUserInfoVC *vc = [[LTSCUserInfoVC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                vc.nick_nameStr = [LTSCTool ShareTool].userModel.username;
                vc.sex = [LTSCTool ShareTool].userModel.sex;
                [self.navigationController pushViewController:vc animated:YES];
                
            } else {
                
                
                 LTSCLoginVC *vc = [[LTSCLoginVC alloc] init];
                BaseNavigationController * nav  = [[BaseNavigationController alloc] initWithRootViewController:vc];
                //         vc.modalPresentationStyle = UIModalPresentationFullScreen;
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
                        return;
                
    //            [selfWeak gotoLogin];
            }
}

//店铺关注
- (void)dianpuButtonClick:(UIButton *)btn {
    if (ISLOGIN && SESSION_TOKEN) {
        if (btn == _navView.dianpuButton) {
            LTSCDianPuAttentionVC *vc = [LTSCDianPuAttentionVC new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            LTSCYouHuiQuanVC *vc = [LTSCYouHuiQuanVC new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else {
        [self gotoLogin];
    }
}


@end
