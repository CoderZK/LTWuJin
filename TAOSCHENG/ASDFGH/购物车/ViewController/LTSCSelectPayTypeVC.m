//
//  LTSCSelectPayTypeVC.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/20.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LTSCSelectPayTypeVC.h"
#import "LTSCPaySuccessVC.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "HSPayTwoVC.h"
#import "LTSCShopCarVC.h"
#import "LTSCGoodsDetailVC.h"
@interface LTSCSelectPayTypeVC ()

@property (nonatomic, strong) UIButton *bottomButton;//底部创建按钮

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic,strong)NSDictionary *payDic;
/** <#注释#> */
@property(nonatomic , strong)NSString *orderType;

@end

@implementation LTSCSelectPayTypeVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WWWWX:) name:@"WXPAY" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ZFBPAY:) name:@"ZFBPAY" object:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated {
   
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}




- (UIButton *)bottomButton {
    if (!_bottomButton) {
        _bottomButton = [[UIButton alloc] init];
        [_bottomButton setTitle:@"确定" forState:UIControlStateNormal];
        [_bottomButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_bottomButton setBackgroundImage:[UIImage imageNamed:@"yellow"] forState:UIControlStateNormal];
        _bottomButton.layer.cornerRadius = 3;
        _bottomButton.layer.masksToBounds = YES;
        [_bottomButton addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomButton;
}

/**
 确定
 */
- (void)sureClick {
    
    if (self.isChongZhi) {
        [self submitClick:nil];
        return;
    }else {
        [self payWithDataNo:self.orderCode];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIButton * back = [UIButton new];
    [back setImage:[UIImage imageNamed:@"home_back"] forState:UIControlStateNormal];
//    back.imageEdgeInsets = UIEdgeInsetsMake(12.5, 0, 12.5, 30);
    [back addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    
    self.navigationItem.title = @"选择付款方式";
    [self.view addSubview:self.bottomButton];
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
    self.tableView.separatorColor = BGGrayColor;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(1);
        make.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.bottomButton.mas_top);
    }];
}

- (void)backClick {
    
    if (self.navigationController.childViewControllers.count >=3) {
      UIViewController *   vc = self.navigationController.childViewControllers[self.navigationController.childViewControllers.count - 3];
        if ([vc isKindOfClass:[LTSCShopCarVC class]] ||[vc isKindOfClass:[LTSCGoodsDetailVC class]]) {
          
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您的订单还未支付成功,是否继续支付" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self.navigationController popToViewController:vc animated:YES];
                
            }];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"继续支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                
                
            }];
            [ac addAction:action2];
            [ac addAction:action1];
            [self.navigationController presentViewController:ac animated:YES completion:nil];
            
        }else {
           [self.navigationController popViewControllerAnimated:YES];
        }
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
    
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textColor = CharacterDarkColor;
        cell.textLabel.text = [NSString stringWithFormat:@"应付金额: ¥%.2f",self.allPrice];
        if (self.isChongZhi) {
            cell.textLabel.text = [NSString stringWithFormat:@"应付金额: ¥%.2f",[self.moneyStr floatValue]];
        }
        return cell;
    }else {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
            imgView.tag = 111;
            imgView.image = [UIImage imageNamed:indexPath.row == 0 ? @"selcet_y" : @"selcet_n"];
            cell.accessoryView = imgView;
            
        }
        UIImageView *imgView = [cell viewWithTag:111];
        imgView.image = [UIImage imageNamed:self.currentIndex == indexPath.row ? @"selcet_y" : @"selcet_n"];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = CharacterDarkColor;
        if (indexPath.row == 0) {
            cell.textLabel.text = @"支付宝";
            cell.imageView.image = [UIImage imageNamed:@"alipay"];
        }else {
            cell.textLabel.text = @"微信支付";
            cell.imageView.image = [UIImage imageNamed:@"wechat"];
        }
        return cell;
    }
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.currentIndex = indexPath.row;
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

/// 提交
- (void)submitClick:(UIButton *)btn {
    
   
    
    NSMutableDictionary * dict = @{}.mutableCopy;
//    dict[@"type"] = @(self.currentIndex+1);
    dict[@"telephone"] = self.phoneStr;
    dict[@"amount"] = self.moneyStr;
    dict[@"token"] = TOKEN;
    
    NSLog(@"%@",TOKEN);
     WeakObj(self);
    [LTSCNetworking networkingPOST:recharge parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"key"] integerValue] == 1000) {
            
            [self payWithDataNo:responseObject[@"result"][@"data"]];
            

        } else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
         [SVProgressHUD dismiss];
    }];

    
}

- (void)payWithDataNo:(NSString *)no{
    
    NSString * str = ali_pay;
    if (self.currentIndex == 1) {
        str = wei_pay_code;
    }
       NSMutableDictionary * dict = @{}.mutableCopy;
        dict[@"type"] = @"2";
        dict[@"orderCode"] = no;
        dict[@"token"] = TOKEN;
        dict[@"amount"] = @"20";
        NSLog(@"%@",TOKEN);
         WeakObj(self);
        [LTSCNetworking networkingPOST:str parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
           
            if ([responseObject[@"key"] integerValue] == 1000) {
                if (self.currentIndex == 0) {
                self.payDic = responseObject[@"result"];
                [self goZFB];
                self.orderType = responseObject[@"result"][@"map"][@"orderType"];
                }else {
                    self.payDic = responseObject[@"result"][@"data"];
                    self.orderType = responseObject[@"result"][@"map"][@"orderType"];
                    [self goWXpay];
                }
                
            } else {
                [UIAlertController showAlertWithmessage:responseObject[@"message"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
             [SVProgressHUD dismiss];
        }];
    
    
    
    
}

//微信支付结果处理
- (void)WXPAY:(NSNotification *)no {
    
    BaseResp * resp = no.object;
    if (resp.errCode==WXSuccess)
    {
        
        [self showPaySucess];
    }
    else if (resp.errCode==WXErrCodeUserCancel)
    {
        [SVProgressHUD showErrorWithStatus:@"用户取消支付"];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"支付失败"];
    }
    
}



#pragma mark -微信、支付宝支付
- (void)goWXpay {
    PayReq * req = [[PayReq alloc]init];
    req.partnerId = [NSString stringWithFormat:@"%@",self.payDic[@"partnerid"]];
    req.prepayId =  [NSString stringWithFormat:@"%@",self.payDic[@"prepayid"]];
    req.nonceStr =  [NSString stringWithFormat:@"%@",self.payDic[@"noncestr"]];
    //注意此处是int 类型
    req.timeStamp = [self.payDic[@"timestamp"] intValue];
    req.package =  [NSString stringWithFormat:@"%@",self.payDic[@"package"]];
    req.sign =  [NSString stringWithFormat:@"%@",self.payDic[@"sign"]];
    
    //发起支付
    [WXApi sendReq:req completion:^(BOOL success) {



    }];
    
//    [WXApi sendReq:req];
    
}

//微信支付结果处理
- (void)WWWWX:(NSNotification *)no {
    
    BaseResp * resp = no.object;
    if (resp.errCode==WXSuccess)
    {
        
        [self showPaySucess];
    }
    else if (resp.errCode==WXErrCodeUserCancel)
    {
        [SVProgressHUD showErrorWithStatus:@"用户取消支付"];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"支付失败"];
    }
    
}



//支付宝支付结果处理
- (void)goZFB{
    if (![self.payDic.allKeys containsObject:@"data"]) {
        return;
    }
    [[AlipaySDK defaultService] payOrder:self.payDic[@"data"] fromScheme:@"com.biuwork.TAOSCHENG" callback:^(NSDictionary *resultDic) {
        if ([resultDic[@"resultStatus"] isEqualToString:@"6001"]) {
            //用户取消支付
            [SVProgressHUD showErrorWithStatus:@"用户取消支付"];
        } else if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
            [self showPaySucess];
        } else {
            [SVProgressHUD showErrorWithStatus:@"支付失败"];
        }
    }];
}

- (void)showPaySucess {
    
    [SVProgressHUD showSuccessWithStatus:@"支付成功"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (self.isChongZhi) {
            
            HSPayTwoVC * vc =[[HSPayTwoVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.type = 1;
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            
            LTSCPaySuccessVC *vc = [[LTSCPaySuccessVC alloc] init];
            vc.orderID = self.orderID;
            vc.orderType = self.orderType;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        

    });
    
    
}


//支付宝支付结果处理,此处是app 被杀死之后用的
- (void)ZFBPAY:(NSNotification *)notic {
    NSDictionary *resultDic = notic.object;
    if ([resultDic[@"resultStatus"] isEqualToString:@"6001"]) {
        //用户取消支付
        [SVProgressHUD showErrorWithStatus:@"用户取消支付"];
        
    } else if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
        
        [self showPaySucess];
    } else {
        [SVProgressHUD showErrorWithStatus:@"支付失败"];
    }
    
}


@end
