//
//  LTSCUserInfoVC.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/21.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LTSCUserInfoVC.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import "MXPhotoPickerController.h"
#import "UIViewController+MXPhotoPicker.h"

@interface LTSCUserInfoVC ()

@property (nonatomic, strong) UIView *headerView;//头视图

@property (nonatomic, strong) UIImageView *userImgView;//头像

@property (nonatomic, strong) UILabel *textlabel;//点击修改头像

@property (nonatomic, strong) UIView *lineView1;

@property (nonatomic, strong) LTSCNickView *nickView;//昵称

@property (nonatomic, strong) LTSCSexView *sexView;//性别

@property (nonatomic, assign) NSInteger sexIndex;

@property (nonatomic, strong) LTSCNickView *nameView;//用户名

@property (nonatomic, strong) LTSCNickView *qiyeNameView;//企业名称

@property (nonatomic, strong) LTSCNickView *yyzzView;//营业执照号

@property (nonatomic, strong) LTSCNickView *yyzzView1;//营业执照

@property (nonatomic, strong) UIImageView *imgView;//营业执照图片

@property (nonatomic, strong) LTSCNickView *shuihaoView;//税号

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) NSString *imgStr;

@end

@implementation LTSCUserInfoVC

- (UIImageView *)userImgView {
    if (!_userImgView) {
        _userImgView = [[UIImageView alloc] init];
        _userImgView.layer.cornerRadius = 30;
        _userImgView.layer.masksToBounds = YES;
        _userImgView.layer.borderWidth = 1;
        _userImgView.layer.borderColor = [UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1].CGColor;
        [_userImgView sd_setImageWithURL:[NSURL URLWithString:[LTSCTool ShareTool].userModel.userHead] placeholderImage:[UIImage imageNamed:@"scpeople"]];
        _userImgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uploadUserHeader)];
        [_userImgView addGestureRecognizer:tap];
        _userImgView.tag = 345;
    }
    return _userImgView;
}

- (UILabel *)textlabel {
    if (!_textlabel) {
        _textlabel = [[UILabel alloc] init];
        _textlabel.font = [UIFont systemFontOfSize:16];
        _textlabel.textColor = CharacterDarkColor;
        _textlabel.text = @"点击修改头像";
    }
    return _textlabel;
}

- (UIView *)lineView1 {
    if (!_lineView1) {
        _lineView1 = [[UIView alloc] init];
        _lineView1.backgroundColor = BGGrayColor;
    }
    return _lineView1;
}

- (LTSCNickView *)nickView {
    if (!_nickView) {
        _nickView = [[LTSCNickView alloc] init];
        _nickView.textlabel.text = @"昵称";
        _nickView.nickTF.text = [LTSCTool ShareTool].userModel.nickname;
    }
    return _nickView;
}

- (LTSCSexView *)sexView {
    if (!_sexView) {
        _sexView = [[LTSCSexView alloc] init];
        _sexView.userModel = [LTSCTool ShareTool].userModel;
    }
    return _sexView;
}

- (LTSCNickView *)nameView {
    if (!_nameView) {
        _nameView = [[LTSCNickView alloc] init];
        _nameView.textlabel.text = @"用户名";
        _nameView.nickTF.placeholder = @"用户名";
//        _nameView.nickTF.text = [LTSCTool ShareTool].userModel.nickname;
    }
    return _nameView;
}

- (LTSCNickView *)qiyeNameView {
    if (!_qiyeNameView) {
        _qiyeNameView = [[LTSCNickView alloc] init];
        _qiyeNameView.textlabel.text = @"企业名称";
        _qiyeNameView.nickTF.placeholder = @"企业名称";
//        _qiyeNameView.nickTF.text = [LTSCTool ShareTool].userModel.comName;
    }
    return _qiyeNameView;
}

- (LTSCNickView *)yyzzView {
    if (!_yyzzView) {
        _yyzzView = [[LTSCNickView alloc] init];
        _yyzzView.textlabel.text = @"营业执照号";
        _yyzzView.nickTF.placeholder = @"营业执照号";
//        _yyzzView.nickTF.text = [LTSCTool ShareTool].userModel.licenseNo;
    }
    return _yyzzView;
}

- (LTSCNickView *)yyzzView1 {
    if (!_yyzzView1) {
        _yyzzView1 = [[LTSCNickView alloc] init];
        _yyzzView1.textlabel.text = @"营业执照";
        _yyzzView1.nickTF.placeholder = @"营业执照";
        _yyzzView1.nickTF.userInteractionEnabled = NO;
        _yyzzView1.lineView.hidden = YES;
    }
    return _yyzzView1;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
//        [_imgView sd_setImageWithURL:[NSURL URLWithString:[LTSCTool ShareTool].userModel.licensePic] placeholderImage:[UIImage imageNamed:@"paizhao"]];
        _imgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uploadyyzzImg)];
        [_imgView addGestureRecognizer:tap1];
        _imgView.tag = 123;
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

- (LTSCNickView *)shuihaoView {
    if (!_shuihaoView) {
        _shuihaoView = [[LTSCNickView alloc] init];
        _shuihaoView.textlabel.text = @"税号";
        _shuihaoView.nickTF.placeholder = @"税号";
//        _shuihaoView.nickTF.text = [LTSCTool ShareTool].userModel.taxNo;
    }
    return _shuihaoView;
}


- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}




- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人信息";
    self.tableView.backgroundColor = UIColor.whiteColor;
    [self initNav];
    [self initHeadView];
    WeakObj(self);
    self.sexView.sexClickBlock = ^(NSInteger index) {
        selfWeak.sexIndex = index;
    };
}

- (void)initNav {
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [rightButton setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightButton addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)initHeadView {
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 150 + 10 + 50 + 50)];
    self.headerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = self.headerView;
    [self.headerView addSubview:self.userImgView];
    [self.headerView addSubview:self.textlabel];
    [self.headerView addSubview:self.lineView1];
    [self.userImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView).offset(20);
        make.centerX.equalTo(self.headerView);
        make.width.height.equalTo(@60);
    }];
    [self.textlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userImgView.mas_bottom).offset(15);
        make.centerX.equalTo(self.headerView);
    }];
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView).offset(150);
        make.leading.trailing.equalTo(self.headerView);
        make.height.equalTo(@10);
    }];
    
    if (self.isQiYe) {
        self.headerView.frame = CGRectMake(0, 0, ScreenW, 150 + 10 + 300);
        [self.headerView addSubview:self.nameView];
        [self.headerView addSubview:self.qiyeNameView];
        [self.headerView addSubview:self.yyzzView];
        [self.headerView addSubview:self.yyzzView1];
        [self.headerView addSubview:self.imgView];
        [self.headerView addSubview:self.lineView];
        [self.headerView addSubview:self.shuihaoView];
        [self.nameView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineView1.mas_bottom);
            make.leading.trailing.equalTo(self.headerView);
            make.height.equalTo(@50);
        }];
        [self.qiyeNameView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameView.mas_bottom);
            make.leading.trailing.equalTo(self.headerView);
            make.height.equalTo(@50);
        }];
        [self.yyzzView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.qiyeNameView.mas_bottom);
            make.leading.trailing.equalTo(self.headerView);
            make.height.equalTo(@50);
        }];
        [self.yyzzView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.yyzzView.mas_bottom).offset(20);
            make.leading.equalTo(self.headerView);
            make.width.equalTo(@115);
            make.height.equalTo(@50);
        }];
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.yyzzView1);
            make.leading.equalTo(self.yyzzView1.mas_trailing);
            make.width.height.equalTo(@50);
        }];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imgView.mas_bottom).offset(15);
            make.leading.equalTo(self.headerView).offset(15);
            make.trailing.equalTo(self.headerView).offset(-15);
            make.height.equalTo(@.5);
        }];
        [self.shuihaoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineView.mas_bottom);
            make.leading.trailing.equalTo(self.headerView);
            make.height.equalTo(@50);
        }];
    }else {
        self.headerView.frame = CGRectMake(0, 0, ScreenW, 150 + 10 + 50 + 50);
        [self.headerView addSubview:self.nickView];
        self.nickView.nickTF.text = self.nick_nameStr;
        [self.headerView addSubview:self.sexView];
        
        if (self.sex.intValue == 1) {
            self.sexView.maleButton.selected = YES;
            self.sexView.femaleButton.selected = NO;
        }else {
            self.sexView.maleButton.selected = NO;
            self.sexView.femaleButton.selected = YES;
        }
        
        [self.nickView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineView1.mas_bottom);
            make.leading.trailing.equalTo(self.headerView);
            make.height.equalTo(@50);
        }];
        [self.sexView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nickView.mas_bottom);
            make.leading.trailing.equalTo(self.headerView);
            make.height.equalTo(@50);
        }];
    }
}

/**
 上传头像
 */
- (void)uploadUserHeader {
    UIAlertController * actionController = [UIAlertController alertControllerWithTitle:nil message:@"选择图片上传方式" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * a1 = [UIAlertAction actionWithTitle:@"打开相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showMXPhotoCameraAndNeedToEdit:YES completion:^(UIImage *image, UIImage *originImage, CGRect cutRect) {
            if (image) {
                [self updateFile:image];
            }else {
                [LTSCToastView showErrorWithStatus:@"相片获取失败"];
            }
        }];
    }];
    
    UIAlertAction * a2 = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showMXPhotoPickerControllerAndNeedToEdit:YES completion:^(UIImage *image, UIImage *originImage, CGRect cutRect) {
            if (image) {
                [self updateFile:image];
            }else {
                [LTSCToastView showErrorWithStatus:@"相片获取失败"];
            }
        }];
    }];
    UIAlertAction * a3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [actionController addAction:a1];
    [actionController addAction:a2];
    [actionController addAction:a3];
    [self presentViewController:actionController animated:YES completion:nil];
}

- (void)uploadyyzzImg {
    UIAlertController * actionController = [UIAlertController alertControllerWithTitle:nil message:@"选择图片上传方式" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * a1 = [UIAlertAction actionWithTitle:@"打开相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showMXPhotoCameraAndNeedToEdit:YES completion:^(UIImage *image, UIImage *originImage, CGRect cutRect) {
            if (image) {
                self.imgView.tag = 321;
                self.imgView.image = image;
                [self updateFile1:image];
            }else {
                [LTSCToastView showErrorWithStatus:@"相片获取失败"];
            }
        }];
    }];
    
    UIAlertAction * a2 = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showMXPhotoPickerControllerAndNeedToEdit:YES completion:^(UIImage *image, UIImage *originImage, CGRect cutRect) {
            if (image) {
                self.imgView.tag = 321;
                self.imgView.image = image;
                [self updateFile1:image];
            }else {
                [LTSCToastView showErrorWithStatus:@"相片获取失败"];
            }
        }];
    }];
    UIAlertAction * a3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [actionController addAction:a1];
    [actionController addAction:a2];
    [actionController addAction:a3];
    [self presentViewController:actionController animated:YES completion:nil];
}


- (void)updateFile:(UIImage *)image {
    [LTSCNetworking NetWorkingUpLoad:Base_upload_img_URL image:image parameters:nil name:@"file" success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"key"] integerValue] == 1000) {
            NSString *str = [NSString stringWithFormat:@"%@",responseObject[@"result"][@"map"][@"path"]];
            [self.userImgView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"user1"]];
            [self modifyInfo:str];
        }else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)updateFile1:(UIImage *)image {
    [LTSCNetworking NetWorkingUpLoad:Base_upload_img_URL image:image parameters:nil name:@"file" success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"key"] integerValue] == 1000) {
            NSString *str = [NSString stringWithFormat:@"%@",responseObject[@"result"][@"map"][@"path"]];
            [self.imgView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"paizhao"]];
            self.imgStr = str;
        }else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

/**
 保存
 */
- (void)saveClick {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (self.isQiYe) {
        if (self.nameView.nickTF.text) {
            dict[@"nickName"] = self.nameView.nickTF.text;
        }
        if (self.qiyeNameView.nickTF.text) {
            dict[@"comName"] = self.qiyeNameView.nickTF.text;
        }
        if (self.yyzzView.nickTF.text) {
            dict[@"licenseNo"] = self.yyzzView.nickTF.text;
        }
        if (self.shuihaoView.nickTF.text) {
            dict[@"taxNo"] = self.shuihaoView.nickTF.text;
        }
        if (self.imgView.tag == 321) {
            [self updateFile1:self.imgView.image];
            if (self.imgStr) {
                dict[@"licencePic"] = self.imgStr;
            }
        }
        
    }else {
        
        if (self.nickView.nickTF.text.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"昵称不能为空"];
            return;
        }
        dict[@"nickName"] = self.nickView.nickTF.text;
     
        if (self.sexIndex != 0) {
            dict[@"sex"] = @(self.sexIndex);
        }
    }
    dict[@"token"] = SESSION_TOKEN;
    
    
    if (dict.allKeys.count >= 1) {
        [LTSCLoadingView show];
        [LTSCNetworking networkingPOST:up_base_info parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [LTSCLoadingView dismiss];
            if ([responseObject[@"key"] integerValue] == 1000) {
                [self loadMyUserInfoWithOkBlock:nil];
                [LTSCEventBus sendEvent:@"userInfo" data:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                [UIAlertController showAlertWithmessage:responseObject[@"message"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [LTSCLoadingView dismiss];
        }];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

/**
 修改个人信息
 */
- (void)modifyInfo:(NSString *)headPath {
    [LTSCLoadingView show];
    [LTSCNetworking networkingPOST:up_base_info parameters:@{@"token":SESSION_TOKEN,@"userPic":headPath} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [LTSCLoadingView dismiss];
        if ([responseObject[@"key"] integerValue] == 1000) {
            [self loadMyUserInfoWithOkBlock:nil];
            [LTSCEventBus sendEvent:@"userInfo" data:nil];
        }else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [LTSCLoadingView dismiss];
    }];
}


@end


@interface LTSCNickView()

@end
@implementation LTSCNickView
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.textlabel];
        [self addSubview:self.nickTF];
        [self.textlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.centerY.equalTo(self);
            make.width.equalTo(@100);
        }];
        [self.nickTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.textlabel.mas_trailing);
            make.centerY.equalTo(self);
            make.trailing.equalTo(self).offset(-15);
        }];
        self.lineView = [[UIView alloc] init];
        self.lineView.backgroundColor = BGGrayColor;
        [self addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.bottom.trailing.equalTo(self);
            make.height.equalTo(@0.5);
        }];
    }
    return self;
}
- (UILabel *)textlabel {
    if (!_textlabel) {
        _textlabel = [[UILabel alloc] init];
        _textlabel.font = [UIFont systemFontOfSize:16];
        _textlabel.textColor = CharacterDarkColor;
    }
    return _textlabel;
}

- (UITextField *)nickTF {
    if (!_nickTF) {
        _nickTF = [[UITextField alloc] init];
        _nickTF.placeholder = @"请输入昵称";
        _nickTF.textAlignment = NSTextAlignmentLeft;
        _nickTF.textColor = CharacterDarkColor;
        _nickTF.font = [UIFont systemFontOfSize:16];
    }
    return _nickTF;
}

@end

@interface LTSCSexView()




@end
@implementation LTSCSexView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.textlabel];
        [self addSubview:self.maleButton];
        [self addSubview:self.femaleButton];
        [self.textlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.centerY.equalTo(self);
            make.width.equalTo(@80);
        }];
        [self.maleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.textlabel.mas_trailing);
            make.centerY.equalTo(self);
            make.width.equalTo(@100);
            make.height.equalTo(@50);
        }];
        [self.femaleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.maleButton.mas_trailing);
            make.centerY.equalTo(self);
            make.width.equalTo(@100);
            make.height.equalTo(@50);
        }];
        UIView * line = [[UIView alloc] init];
        line.backgroundColor = BGGrayColor;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.bottom.trailing.equalTo(self);
            make.height.equalTo(@0.5);
        }];
    }
    return self;
}
- (UILabel *)textlabel {
    if (!_textlabel) {
        _textlabel = [[UILabel alloc] init];
        _textlabel.font = [UIFont systemFontOfSize:16];
        _textlabel.textColor = CharacterDarkColor;
        _textlabel.text = @"性别";
    }
    return _textlabel;
}

- (UIButton *)maleButton {
    if (!_maleButton) {
        _maleButton = [[UIButton alloc] init];
        [_maleButton setImage:[UIImage imageNamed:@"selcet_n"] forState:UIControlStateNormal];
        [_maleButton setImage:[UIImage imageNamed:@"selcet_y"] forState:UIControlStateSelected];
        [_maleButton setTitle:@"男" forState:UIControlStateNormal];
        [_maleButton setTitleColor:CharacterGrayColor forState:UIControlStateNormal];
        _maleButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_maleButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _maleButton.tag = 1;
        _maleButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
        _maleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _maleButton;
}

- (UIButton *)femaleButton {
    if (!_femaleButton) {
        _femaleButton = [[UIButton alloc] init];
        [_femaleButton setImage:[UIImage imageNamed:@"selcet_n"] forState:UIControlStateNormal];
        [_femaleButton setImage:[UIImage imageNamed:@"selcet_y"] forState:UIControlStateSelected];
        [_femaleButton setTitle:@"女" forState:UIControlStateNormal];
        [_femaleButton setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
        _femaleButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_femaleButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _femaleButton.tag = 2;
        _femaleButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
        _femaleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _femaleButton;
}

- (void)btnClick:(UIButton *)btn {
    if (btn == _maleButton) {
        _maleButton.selected = YES;
        _femaleButton.selected = NO;
    }else {
        _maleButton.selected = NO;
        _femaleButton.selected = YES;
    }
    if (self.sexClickBlock) {
        self.sexClickBlock(btn.tag);
    }
}

- (void)setUserModel:(LTSCUserInfoModel *)userModel {
    _userModel = userModel;
//    if (_userModel.sex) {
//        if (_userModel.sex.intValue == 1) {
//            _maleButton.selected = YES;
//            _femaleButton.selected = NO;
//        }else {
//            _maleButton.selected = NO;
//            _femaleButton.selected = YES;
//        }
//    }else {
//        _maleButton.selected = NO;
//        _femaleButton.selected = NO;
//    }
}

@end
