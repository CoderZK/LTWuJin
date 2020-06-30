//
//  LTSCNewAddressVC.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/20.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LTSCNewAddressVC.h"
#import "AddressPickerView.h"

@interface LTSCNewAddressVC ()<AddressPickerViewDelegate>

@property (nonatomic, strong) LTSCLeftTextRightTFView *nameView;//收货人

@property (nonatomic, strong) LTSCLeftTextRightTFView *phoneView;//收货人

@property (nonatomic, strong) LTSCLeftTextRightTFView1 *addressView;//所在地区

@property (nonatomic, strong) LTSCLeftTextRightTFView *detailView;//详细地址

@property (nonatomic, strong) UIButton *morenButton;//设置默认

@property (nonatomic, strong) UIImageView *morenImgView;//设为默认

@property (nonatomic, strong) UILabel *setMorenLabel;//设置为默认

@property (nonatomic, strong) AddressPickerView * pickerView;

@property (nonatomic, assign) NSInteger ismoren;

@property (nonatomic, strong) NSString  *province;

@property (nonatomic, strong) NSString  *city;

@property (nonatomic, strong) NSString  *district;

@end

@implementation LTSCNewAddressVC

- (LTSCLeftTextRightTFView *)nameView {
    if (!_nameView) {
        _nameView = [[LTSCLeftTextRightTFView alloc] init];
        _nameView.leftLabel.text = @"收货人";
        if (self.editModel) {
            _nameView.rightTF.text = self.editModel.username;
        }else {
            _nameView.rightTF.placeholder = @"请填写收货人姓名";
        }
    }
    return _nameView;
}
- (LTSCLeftTextRightTFView *)phoneView {
    if (!_phoneView) {
        _phoneView = [[LTSCLeftTextRightTFView alloc] init];
        _phoneView.leftLabel.text = @"手机号码";
        _phoneView.rightTF.keyboardType = UIKeyboardTypeNumberPad;
        if (self.editModel) {
            _phoneView.rightTF.text = self.editModel.telephone;
        }else {
            _phoneView.rightTF.placeholder = @"请输入收货手机号码";
        }
    }
    return _phoneView;
}
- (LTSCLeftTextRightTFView1 *)addressView {
    if (!_addressView) {
        _addressView = [[LTSCLeftTextRightTFView1 alloc] init];
        _addressView.leftLabel.text = @"所在地区";
        [_addressView addTarget:self action:@selector(selectAddressClick) forControlEvents:UIControlEventTouchUpInside];
        if (self.editModel) {
            _addressView.rightLabel.text = [NSString stringWithFormat:@"%@%@%@", self.editModel.province,self.editModel.city,self.editModel.district];
        }
    }
    return _addressView;
}
- (LTSCLeftTextRightTFView *)detailView {
    if (!_detailView) {
        _detailView = [[LTSCLeftTextRightTFView alloc] init];
        _detailView.leftLabel.text = @"详细地址";
        _detailView.rightTF.placeholder = @"街道、楼牌号等";
        if (self.editModel) {
            _detailView.rightTF.text = self.editModel.addressDetail;
        }
    }
    return _detailView;
}

- (UIButton *)morenButton {
    if (!_morenButton) {
        _morenButton = [[UIButton alloc] init];
        [_morenButton addTarget:self action:@selector(morenClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _morenButton;
}

- (UIImageView *)morenImgView {
    if (!_morenImgView) {
        _morenImgView = [[UIImageView alloc] init];
        if (self.editModel) {
            _morenImgView.image = [UIImage imageNamed:self.editModel.defaultStatus.intValue == 1 ? @"selcet_n" : @"selcet_y"];
        }else {
            _morenImgView.image = [UIImage imageNamed:@"selcet_n"];
        }
    }
    return _morenImgView;
}

- (UILabel *)setMorenLabel {
    if (!_setMorenLabel) {
        _setMorenLabel = [[UILabel alloc] init];
        _setMorenLabel.font = [UIFont systemFontOfSize:16];
        _setMorenLabel.textColor = CharacterDarkColor;
        _setMorenLabel.text = @"设置为默认地址";
    }
    return _setMorenLabel;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.editModel ? @"修改收货地址" : @"新建地址";
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self initNav];
    [self initHeadView];
    [self.view addSubview:self.pickerView];
    
    if (self.editModel) {
        self.ismoren = self.editModel.defaultStatus.intValue;
        self.province = self.editModel.province;
        self.city = self.editModel.city;
        self.district = self.editModel.district;
    }else {
        self.ismoren = 1;
    }
    
}

- (void)initNav {
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [rightButton setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightButton addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)initHeadView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 250)];
    self.tableView.tableHeaderView = headerView;
    
    [headerView addSubview:self.nameView];
    [headerView addSubview:self.phoneView];
    [headerView addSubview:self.addressView];
    [headerView addSubview:self.detailView];
    [headerView addSubview:self.morenButton];
    [self.morenButton addSubview:self.morenImgView];
    [self.morenButton addSubview:self.setMorenLabel];
    
    [self.nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(headerView);
        make.height.equalTo(@50);
    }];
    [self.phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameView.mas_bottom);
        make.leading.trailing.equalTo(headerView);
        make.height.equalTo(@50);
    }];
    [self.addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneView.mas_bottom);
        make.leading.trailing.equalTo(headerView);
        make.height.equalTo(@50);
    }];
    [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressView.mas_bottom);
        make.leading.trailing.equalTo(headerView);
        make.height.equalTo(@50);
    }];
    [self.morenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailView.mas_bottom);
        make.leading.trailing.equalTo(headerView);
        make.height.equalTo(@50);
    }];
    [self.morenImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.morenButton).offset(15);
        make.centerY.equalTo(self.morenButton);
        make.width.height.equalTo(@22);
    }];
    [self.setMorenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.morenImgView.mas_trailing).offset(15);
        make.centerY.equalTo(self.morenButton);
    }];
}

- (AddressPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[AddressPickerView alloc] init];
        _pickerView.delegate = self;
        _pickerView.titleColor = MineColor;
        _pickerView.pickerViewColor = BGGrayColor;
        [_pickerView setTitleHeight:50 pickerViewHeight:300];
        _pickerView.isAutoOpenLast = NO;
    }
    return _pickerView;
}

- (void)selectAddressClick{
    [self.tableView endEditing:YES];
    [self.pickerView show];
}

- (void)morenClick:(UIButton *)btn {
    btn.selected = !btn.selected;
    self.ismoren = btn.selected ? 2 : 1;
    self.morenImgView.image = [UIImage imageNamed:btn.selected ? @"selcet_y" : @"selcet_n"];
}



/** 取消按钮点击事件*/
- (void)cancelBtnClick {
    [self.pickerView hide];
}

/**
 *  完成按钮点击事件
 *
 *  @param province 当前选中的省份
 *  @param city     当前选中的市
 *  @param area     当前选中的区
 */
- (void)sureBtnClickReturnProvince:(NSString *)province
                              City:(NSString *)city
                              Area:(NSString *)area {
    [self.pickerView hide];
    self.addressView.rightLabel.text = [NSString stringWithFormat:@"%@%@%@",province,city, area];
    self.province = province;
    self.city = city;
    self.district = area;
}

/**
 保存
 */
- (void)rightClick {
    [self.tableView endEditing:YES];
    if (self.nameView.rightTF.text.length == 0 || [self.nameView.rightTF.text isKong]) {
        [LTSCToastView showInFullWithStatus:@"请填写收货人姓名"];
        return;
    }
    if (self.phoneView.rightTF.text.length == 0 || [self.phoneView.rightTF.text isKong] ) {
        [LTSCToastView showInFullWithStatus:@"请输入收货手机号码"];
        return;
    }
    if (self.phoneView.rightTF.text.length != 11) {
        [LTSCToastView showInFullWithStatus:@"请输入11位手机号码"];
        return;
    }
    if (self.addressView.rightLabel.text.length == 0 || [self.addressView.rightLabel.text isKong]) {
        [LTSCToastView showInFullWithStatus:@"请选择所在省市区"];
        return;
    }
    if (self.detailView.rightTF.text.length == 0 || [self.detailView.rightTF.text isKong]) {
        [LTSCToastView showInFullWithStatus:@"请填写详情收货地址"];
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = SESSION_TOKEN;
    dict[@"linkName"] = [self.nameView.rightTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    dict[@"linkPhone"] = [self.phoneView.rightTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    dict[@"province"] = self.province;
    dict[@"city"] = self.city;
    dict[@"district"] = self.district;
    dict[@"detailAddress"] = self.detailView.rightTF.text;
    dict[@"default_status"] = @(self.ismoren);
    if (self.editModel) {
        dict[@"id"] = self.editModel.id;
    }
    [LTSCLoadingView show];
    [LTSCNetworking networkingPOST:add_up_address parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [LTSCLoadingView dismiss];
        if ([responseObject[@"key"] integerValue] == 1000) {
            if (self.editModel) {
                [LTSCToastView showSuccessWithStatus:@"地址修改成功"];
            }else {
               [LTSCToastView showSuccessWithStatus:@"地址添加成功"];
            }
            [LTSCEventBus sendEvent:@"addressAddSuccess" data:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            
             [UIAlertController showAlertWithKey:responseObject[@"key"] message:responseObject[@"message"]];
            
//            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [LTSCLoadingView dismiss];
    }];
    
}

@end

@interface LTSCLeftTextRightTFView()

@end
@implementation LTSCLeftTextRightTFView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.leftLabel];
        [self addSubview:self.rightTF];
        [self addSubview:self.lineView];
        [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.centerY.equalTo(self);
            make.width.equalTo(@100);
        }];
        [self.rightTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.leftLabel.mas_trailing);
            make.centerY.equalTo(self);
            make.trailing.equalTo(self).offset(-15);
            make.top.bottom.equalTo(self);
        }];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.trailing.bottom.equalTo(self);
            make.height.equalTo(@0.5);
        }];
    }
    return self;
}

- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.textColor = CharacterDarkColor;
        _leftLabel.font = [UIFont systemFontOfSize:16];
    }
    return _leftLabel;
}

- (UITextField *)rightTF {
    if (!_rightTF) {
        _rightTF = [[UITextField alloc] init];
        _rightTF.textColor = CharacterDarkColor;
        _rightTF.font = [UIFont systemFontOfSize:16];
    }
    return _rightTF;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

@end

@interface LTSCLeftTextRightTFView1()

@property (nonatomic, strong) UIImageView *imgView;

@end
@implementation LTSCLeftTextRightTFView1

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.leftLabel];
        [self addSubview:self.rightLabel];
        [self addSubview:self.imgView];
        [self addSubview:self.lineView];
        [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.centerY.equalTo(self);
            make.width.equalTo(@100);
        }];
        [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.leftLabel.mas_trailing);
            make.centerY.equalTo(self);
            make.trailing.equalTo(self).offset(-50);
        }];
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self).offset(-15);
            make.centerY.equalTo(self);
            make.width.height.equalTo(@22);
        }];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.trailing.bottom.equalTo(self);
            make.height.equalTo(@0.5);
        }];
    }
    return self;
}

- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.textColor = CharacterDarkColor;
        _leftLabel.font = [UIFont systemFontOfSize:16];
    }
    return _leftLabel;
}

- (UILabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.textColor = CharacterDarkColor;
        _rightLabel.font = [UIFont systemFontOfSize:16];
    }
    return _rightLabel;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.image = [UIImage imageNamed:@"next"];
    }
    return _imgView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

@end
