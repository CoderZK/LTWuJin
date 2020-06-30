//
//  LTSCUserInfoVC.h
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/21.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"


@interface LTSCUserInfoVC : BaseTableViewController

@property (nonatomic, assign) BOOL isQiYe;
@property (nonatomic, strong) NSString *headStr;
@property(nonatomic , strong)NSString *nick_nameStr,*sex;



@end

@interface LTSCNickView : UIView

@property (nonatomic, strong) UILabel *textlabel;

@property (nonatomic, strong) UITextField *nickTF;//昵称

@property (nonatomic, strong) UIView *lineView;

@end

@interface LTSCSexView : UIView

@property (nonatomic, strong) UILabel *textlabel;

@property (nonatomic, strong) UIButton *maleButton;

@property (nonatomic, strong) UIButton *femaleButton;

@property (nonatomic, strong) LTSCUserInfoModel *userModel;

@property (nonatomic, copy) void(^sexClickBlock)(NSInteger index);

@end
