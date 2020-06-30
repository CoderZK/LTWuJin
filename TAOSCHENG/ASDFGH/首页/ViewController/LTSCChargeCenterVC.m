//
//  LTSCChargeCenterVC.m
//  huishou
//
//  Created by 李晓满 on 2020/4/2.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "LTSCChargeCenterVC.h"
#import "LTSCTitleView.h"
#import <ContactsUI/ContactsUI.h>
#import <Contacts/Contacts.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import "LTSCSelectPayTypeVC.h"
@interface LTSCChargeCenterVC ()<CNContactPickerDelegate,MFMessageComposeViewControllerDelegate>

@property (nonatomic, strong) UIImageView *bgImgView;

@property (nonatomic, strong) LTSCChargeCenterTopView *topView;

@property (nonatomic, strong) UIButton *leftButton;//返回按钮

@property (nonatomic, strong) UILabel *titleLabel;//标题

@property (nonatomic, strong) UIView *bottomView;//底部按钮视图

@property (nonatomic, strong) UIButton *tixianButton;//提现

@property (nonatomic, strong) UITextField *phoneTF;

@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) UIButton *hukoubuButton;
/**  */
@property(nonatomic , strong)NSString *moneyStr;

@end

@implementation LTSCChargeCenterVC

- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [UIImageView new];
        _bgImgView.image = [UIImage imageNamed:@"yu_e_bg"];
        _bgImgView.backgroundColor = MineColor;
        _bgImgView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImgView.layer.masksToBounds = YES;
    }
    return _bgImgView;
}

- (LTSCChargeCenterTopView *)topView {
    if (!_topView) {
        _topView = [LTSCChargeCenterTopView new];
        WeakObj(self);
        _topView.didMoneyClickBlock = ^(NSString *money) {
            selfWeak.moneyStr = money;
             [selfWeak.tixianButton setTitle:[NSString stringWithFormat:@"¥%@ 立即充值", money.getPriceStr] forState:UIControlStateNormal];
        };
    }
    return _topView;
}

- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [UIButton new];
        [_leftButton setImage:[UIImage imageNamed:@"nav_white_back"] forState:UIControlStateNormal];
        _leftButton.imageEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 40);
        [_leftButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.textColor = UIColor.whiteColor;
        _titleLabel.text = @"充值中心";
    }
    return _titleLabel;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [UIView new];
        _bottomView.layer.shadowColor = [CharacterDarkColor colorWithAlphaComponent:0.2].CGColor;
        _bottomView.layer.shadowRadius = 5;
        _bottomView.layer.shadowOpacity = 0.5;
        _bottomView.layer.shadowOffset = CGSizeMake(0, 0);
    }
    return _bottomView;
}

-(UITextField *)phoneTF {
    if (_phoneTF == nil) {
        _phoneTF = [[UITextField alloc] init];
        _phoneTF.font = [UIFont boldSystemFontOfSize:25];
        _phoneTF.textColor = UIColor.whiteColor;
        _phoneTF.tintColor = [UIColor whiteColor];
        _phoneTF.keyboardType = UIKeyboardTypePhonePad;
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"请输入充值手机号" attributes:
             @{NSForegroundColorAttributeName:[UIColor whiteColor],
             NSFontAttributeName:_phoneTF.font
             }];
             _phoneTF.attributedPlaceholder = attrString;
        
    }
    return _phoneTF;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [UILabel new];
        _textLabel.font = [UIFont systemFontOfSize:12];
        _textLabel.textColor = UIColor.whiteColor;
    }
    return _textLabel;
}

- (UIButton *)hukoubuButton {
    if (!_hukoubuButton) {
        _hukoubuButton = [UIButton new];
        _hukoubuButton.imageEdgeInsets = UIEdgeInsetsMake(0, 22, 18, 0);
        [_hukoubuButton setImage:[UIImage imageNamed:@"hukoubo"] forState:UIControlStateNormal];
        [_hukoubuButton addTarget:self action:@selector(pageToHuKouBu) forControlEvents:UIControlEventTouchUpInside];
    }
    return _hukoubuButton;
}

- (UIButton *)tixianButton {
    if (!_tixianButton) {
        _tixianButton = [UIButton new];
        [_tixianButton setBackgroundImage:[UIImage imageNamed:@"yellow"] forState:UIControlStateNormal];
        _tixianButton.layer.cornerRadius = 3;
        _tixianButton.layer.masksToBounds = YES;
        [_tixianButton setTitle:@"¥10 立即充值" forState:UIControlStateNormal];
        [_tixianButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _tixianButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_tixianButton addTarget:self action:@selector(chargeNowClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tixianButton;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];
    self.moneyStr = @"10.0";
    self.phoneTF.text = LTSCTool.ShareTool.userModel.tel;
    self.textLabel.text = [NSString stringWithFormat:@"默认号码%@",@""];
}

- (void)initSubViews {
    [self.view addSubview:self.bgImgView];
    [self.view addSubview:self.leftButton];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.textLabel];
    [self.view addSubview:self.phoneTF];
    [self.view addSubview:self.hukoubuButton];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.tixianButton];
    
    [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.height.equalTo(@(156 + NavigationSpace));
    }];
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(NavigationSpace - 39);
        make.leading.equalTo(self.view).offset(15);
        make.width.equalTo(@49);
        make.height.equalTo(@37);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.leftButton);
    }];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(15);
        make.bottom.equalTo(self.topView.mas_top);
    }];
    [self.phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(15);
        make.bottom.equalTo(self.textLabel.mas_top).offset(-5);
    }];
    [self.hukoubuButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.view).offset(-15);
        make.top.equalTo(self.phoneTF);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImgView.mas_bottom).offset(-100);
        make.leading.trailing.equalTo(self.view);
        make.height.equalTo(@260);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.equalTo(self.view);
        make.height.equalTo(@(TableViewBottomSpace + 60));
    }];
    [self.tixianButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView).offset(10);
        make.centerX.equalTo(self.bottomView);
        make.leading.equalTo(self.bottomView).offset(15);
        make.trailing.equalTo(self.bottomView).offset(-15);
        make.height.equalTo(@40);
    }];
}



- (void)backClick:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

/// 跳转到户口簿
- (void)pageToHuKouBu {
    CNContactPickerViewController * contactVc = [CNContactPickerViewController new];
    contactVc.delegate = self;
    [self presentViewController:contactVc animated:YES completion:nil];
}

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact {

    for (CNLabeledValue *labeledValue in contact.phoneNumbers){
        CNPhoneNumber *phoneValue = labeledValue.value;
        NSString * phoneNumber = phoneValue.stringValue;
        NSLog(@"number: %@",phoneNumber);
        NSString *phoneNum = [self phoneNumberFormat:phoneNumber];
        NSString *area = [NSString pushSignIn:phoneNum];
        self.phoneTF.text = phoneNum;
        self.textLabel.text = [NSString stringWithFormat:@"默认号码%@",@""];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


//通讯录手机号转换纯数字
- (NSString *)phoneNumberFormat:(NSString *)phoneNum{
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:@"[^\\d]" options:0 error:NULL];
    phoneNum = [regular stringByReplacingMatchesInString:phoneNum options:0 range:NSMakeRange(0, [phoneNum length]) withTemplate:@""];
    return phoneNum;
}

//立即充值
- (void)chargeNowClick:(UIButton *)btn {
    
    
    if (self.phoneTF.text.length == 0) {
          [SVProgressHUD showErrorWithStatus:@"请选择充值的手机号"];
          return;
      }
      
    if (self.phoneTF.text.length != 11) {
              [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
              return;
          }
    
      LTSCSelectPayTypeVC * vc =[[LTSCSelectPayTypeVC alloc] initWithTableViewStyle:(UITableViewStyleGrouped)];
      vc.hidesBottomBarWhenPushed = YES;
      vc.isChongZhi = YES;
      vc.phoneStr = self.phoneTF.text;
      vc.moneyStr = self.moneyStr;
      [self.navigationController pushViewController:vc animated:YES];
    
}

@end
