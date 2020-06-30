//
//  HSPayTwoVC.m
//  huishou
//
//  Created by zk on 2020/5/15.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "HSPayTwoVC.h"
#import "LTSCChargeCenterVC.h"
@interface HSPayTwoVC ()
@property (weak, nonatomic) IBOutlet UIImageView *imgV;

@end

@implementation HSPayTwoVC



- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.type == 1) {
        self.imgV.image = [UIImage imageNamed:@"hs102"];
        self.navigationItem.title = @"充值成功";
        
    }else if (self.type == 2){
        self.imgV.image = [UIImage imageNamed:@"hs101"];
        self.navigationItem.title = @"支付成功";
    }else {
         self.imgV.image = [UIImage imageNamed:@"hs100"];
        self.navigationItem.title = @"支付失败";
    }
   UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitle:@"完成" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"home_back"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
            leftItem.tintColor = CharacterGrayColor;
    //        leftItem.imageInsets = UIEdgeInsetsMake(0, -10, 0, 10);
            self.navigationItem.leftBarButtonItem = leftItem;
    
    
}

- (void)back {
    
    if (self.navigationController.childViewControllers.count >= 3) {
        
        UIViewController * payVC = self.navigationController.childViewControllers[self.self.navigationController.childViewControllers.count - 3];
        
        if ([payVC isKindOfClass:[LTSCChargeCenterVC class]]){
            [self.navigationController popToViewController:payVC animated:YES];
        }else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
   
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
