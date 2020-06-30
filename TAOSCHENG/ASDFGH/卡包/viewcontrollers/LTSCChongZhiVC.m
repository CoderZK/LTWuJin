
//
//  LTSCChongZhiVC.m
//  huishou
//
//  Created by 李晓满 on 2020/3/20.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "LTSCChongZhiVC.h"
#import "LTSCKaBaoView.h"

#import "HSPayTwoVC.h"
@interface LTSCChongZhiVC ()

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIView *footerView;

@property (nonatomic, strong) UIButton *submitButton;//提交

@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic,strong)NSDictionary *payDic;
@end

@implementation LTSCChongZhiVC

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    }
    return _lineView;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 100)];
    }
    return _footerView;
}

- (UIButton *)submitButton {
    if (!_submitButton) {
        _submitButton = [UIButton new];
        [_submitButton setBackgroundImage:[UIImage imageNamed:@"yellow"] forState:UIControlStateNormal];
        _submitButton.layer.cornerRadius = 3;
        _submitButton.layer.masksToBounds = YES;
        [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
        [_submitButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _submitButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_submitButton addTarget:self action:@selector(submitClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}
//
//
//
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WWWWX:) name:@"WXPAY" object:nil];
//       [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ZFBPAY:) name:@"ZFBPAY" object:nil];
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}
//
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
//    self.tableView.backgroundColor = [UIColor whiteColor];
//    self.navigationItem.title = @"选择充值方式";
//    [self initViews];
//}
//
//- (void)initViews {
//    [self.view addSubview:self.lineView];
//    self.tableView.tableFooterView = self.footerView;
//    [self.footerView addSubview:self.submitButton];
//    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.leading.trailing.equalTo(self.view);
//        make.height.equalTo(@0.5);
//    }];
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.lineView.mas_bottom);
//        make.leading.bottom.trailing.equalTo(self.view);
//    }];
//    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(self.footerView).offset(15);
//        make.trailing.equalTo(self.footerView).offset(-15);
//        make.bottom.equalTo(self.footerView);
//        make.height.equalTo(@40);
//    }];
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 2;
//}
//
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return section == 0 ? 1 : 2;
//}
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 0) {
//        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
//        if (!cell) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
//        }
//        cell.textLabel.textColor = CharacterDarkColor;
//        cell.textLabel.font = [UIFont systemFontOfSize:18];
//        cell.textLabel.text = @"应付金额：¥50.00";
//        return cell;
//    }
//    LTSCChongZhiCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LTSCChongZhiCell"];
//    if (!cell) {
//        cell = [[LTSCChongZhiCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LTSCChongZhiCell"];
//    }
//    cell.indexProw = indexPath.row;
//    cell.selectImgView.image = [UIImage imageNamed:self.currentIndex == indexPath.row ? @"selcet_y" : @"selcet_n"] ;
//    cell.iconImgView.image = [UIImage imageNamed:indexPath.row == 0 ? @"alipay" : @"wechat"];
//    cell.titleLabel.text = indexPath.row == 0 ? @"支付宝" : @"微信";
//    return cell;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
//    if (!headerView) {
//        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"UITableViewHeaderFooterView"];
//    }
//    headerView.contentView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
//    return headerView;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 60;
//}
//
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return section == 0 ? 15 : 0;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    self.currentIndex = indexPath.row;
//    [self.tableView reloadData];
//}
//
//
///// 提交
//- (void)submitClick:(UIButton *)btn {
//
////    NSMutableDictionary * dict = @{}.mutableCopy;
//////    dict[@"type"] = @(self.currentIndex+1);
////    dict[@"telephone"] = self.phoneStr;
////    dict[@"money"] = self.moneyStr;
////    dict[@"token"] = TOKEN;
////
////    NSLog(@"%@",TOKEN);
////     WeakObj(self);
////    [LTSCNetworking networkingPOST:recharge parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
////        [SVProgressHUD dismiss];
////        if ([responseObject[@"key"] integerValue] == 1000) {
////
////            [self payWithDataNo:responseObject[@"result"][@"data"]];
////
////        } else {
////            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
////        }
////    } failure:^(NSURLSessionDataTask *task, NSError *error) {
////         [SVProgressHUD dismiss];
////    }];
////
//
//}
//
//- (void)payWithDataNo:(NSString *)no{
//
//    NSString * str = @"";
//    if (self.currentIndex == 1) {
//
//    }
//       NSMutableDictionary * dict = @{}.mutableCopy;
//    //    dict[@"type"] = @(self.currentIndex+1);
//        dict[@"type"] = @"2";
//        dict[@"orderCode"] = no;
//        dict[@"token"] = TOKEN;
//
//        NSLog(@"%@",TOKEN);
//         WeakObj(self);
//        [LTSCNetworking networkingPOST:str parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//
//            if ([responseObject[@"key"] integerValue] == 1000) {
//                if (self.currentIndex == 0) {
//                self.payDic = responseObject[@"result"];
//                    [self goZFB];
//                }else {
//
//                }
//
//            } else {
//                [UIAlertController showAlertWithmessage:responseObject[@"message"]];
//            }
//        } failure:^(NSURLSessionDataTask *task, NSError *error) {
//             [SVProgressHUD dismiss];
//        }];
//
//
//
//
//}
//
////微信支付结果处理
//- (void)WXPAY:(NSNotification *)no {
//
//    BaseResp * resp = no.object;
//    if (resp.errCode==WXSuccess)
//    {
//
//        [self showPaySucess];
//    }
//    else if (resp.errCode==WXErrCodeUserCancel)
//    {
//        [SVProgressHUD showErrorWithStatus:@"用户取消支付"];
//    }
//    else
//    {
//        [SVProgressHUD showErrorWithStatus:@"支付失败"];
//    }
//
//}
//
//
//
//#pragma mark -微信、支付宝支付
//- (void)goWXpay {
//    PayReq * req = [[PayReq alloc]init];
//    req.partnerId = [NSString stringWithFormat:@"%@",self.payDic[@"partnerid"]];
//    req.prepayId =  [NSString stringWithFormat:@"%@",self.payDic[@"prepayid"]];
//    req.nonceStr =  [NSString stringWithFormat:@"%@",self.payDic[@"noncestr"]];
//    //注意此处是int 类型
//    req.timeStamp = [self.payDic[@"timestamp"] intValue];
//    req.package =  [NSString stringWithFormat:@"%@",self.payDic[@"package"]];
//    req.sign =  [NSString stringWithFormat:@"%@",self.payDic[@"sign"]];
//
//    //发起支付
//    [WXApi sendReq:req completion:^(BOOL success) {
//
//
//
//    }];
//
//}
//
////微信支付结果处理
//- (void)WWWWX:(NSNotification *)no {
//
//    BaseResp * resp = no.object;
//    if (resp.errCode==WXSuccess)
//    {
//
//        [self showPaySucess];
//    }
//    else if (resp.errCode==WXErrCodeUserCancel)
//    {
//        [SVProgressHUD showErrorWithStatus:@"用户取消支付"];
//    }
//    else
//    {
//        [SVProgressHUD showErrorWithStatus:@"支付失败"];
//    }
//
//}
//
//
//
////支付宝支付结果处理
//- (void)goZFB{
//    [[AlipaySDK defaultService] payOrder:self.payDic[@"data"] fromScheme:@"com.biuwork.huishou" callback:^(NSDictionary *resultDic) {
//        if ([resultDic[@"resultStatus"] isEqualToString:@"6001"]) {
//            //用户取消支付
//            [SVProgressHUD showErrorWithStatus:@"用户取消支付"];
//        } else if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
//            [self showPaySucess];
//        } else {
//            [SVProgressHUD showErrorWithStatus:@"支付失败"];
//        }
//    }];
//}
//
//- (void)showPaySucess {
//
//    [SVProgressHUD showSuccessWithStatus:@"支付成功"];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//        HSPayTwoVC * vc =[[HSPayTwoVC alloc] init];
//        vc.hidesBottomBarWhenPushed = YES;
//        vc.type = 1;
//        [self.navigationController pushViewController:vc animated:YES];
//
//    });
//
//
//}
//
//
////支付宝支付结果处理,此处是app 被杀死之后用的
//- (void)ZFBPAY:(NSNotification *)notic {
//    NSDictionary *resultDic = notic.object;
//    if ([resultDic[@"resultStatus"] isEqualToString:@"6001"]) {
//        //用户取消支付
//        [SVProgressHUD showErrorWithStatus:@"用户取消支付"];
//
//    } else if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
//
//        [self showPaySucess];
//    } else {
//        [SVProgressHUD showErrorWithStatus:@"支付失败"];
//    }
//
//}


@end
