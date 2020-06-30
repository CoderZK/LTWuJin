//
//  LTSCCommentOrderVC.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2020/4/16.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "LTSCCommentOrderVC.h"
#import "LTSCStarView.h"


@interface LTSCCommentOrderVC ()<LTSCStarViewDelegate>

@property (nonatomic, strong) UIButton *rightbtn;

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *footerView;

@property (nonatomic, strong) UILabel *textLabel1;

@property (nonatomic, strong) UILabel *textlabel2;

@property (nonatomic, strong) LTSCStarView *strat1;

@property (nonatomic, strong) UILabel *textlabel3;

@property (nonatomic, strong) LTSCStarView *strat2;

@property (nonatomic, strong) UILabel *textlabel4;

@property (nonatomic, strong) LTSCStarView *strat3;

@end

@implementation LTSCCommentOrderVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray<LTSCOrderDetailModel *> *arr = @[].mutableCopy;
    for (LTSCOrderDetailModel * model in self.orderModel.goods) {
        if (![model.status isEqualToString:@"5"]) {
            [arr addObject:model];
        }
    }
    self.orderModel.goods = arr;
    self.navigationItem.title = @"发表评价";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initSubViews];
    [self setConstrains];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.orderModel.goods.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LTSCCommentOrderCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LTSCCommentOrderCell"];
    if (!cell) {
        cell = [[LTSCCommentOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LTSCCommentOrderCell"];
    }
    cell.model = self.orderModel.goods[indexPath.section];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
    if (!footerView) {
        footerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"UITableViewHeaderFooterView"];
    }
    footerView.contentView.backgroundColor = BGGrayColor;
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 325;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 15;
}

/// 添加视图
- (void)initSubViews {
    self.tableView.backgroundColor = UIColor.whiteColor;
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
    self.tableView.tableHeaderView = self.headerView;
    [self.headerView addSubview:self.titleLabel];
    
    self.footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 300)];
    self.tableView.tableFooterView = self.footerView;
    [self.footerView addSubview:self.textLabel1];
    [self.footerView addSubview:self.textlabel2];
    [self.footerView addSubview:self.strat1];
    [self.footerView addSubview:self.textlabel3];
    [self.footerView addSubview:self.strat2];
    [self.footerView addSubview:self.textlabel4];
    [self.footerView addSubview:self.strat3];
}

/// 设置约束
- (void)setConstrains {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightbtn];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0.5);
        make.leading.trailing.bottom.equalTo(self.view);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.headerView).offset(15);
        make.centerY.equalTo(self.headerView);
    }];
    
    [self.textLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.footerView).offset(15);
        make.leading.equalTo(self.footerView).offset(15);
    }];
    [self.textlabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textLabel1.mas_bottom).offset(30);
        make.leading.equalTo(self.footerView).offset(15);
        make.width.equalTo(@80);
        make.height.equalTo(@20);
    }];
    [self.strat1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.textlabel2);
        make.leading.equalTo(self.textlabel2.mas_trailing).offset(10);
        make.width.equalTo(@160);
        make.height.equalTo(@50);
    }];
    [self.textlabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.strat2);
        make.leading.equalTo(self.footerView).offset(15);
        make.width.equalTo(@80);
        make.height.equalTo(@20);
    }];
    [self.strat2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.strat1.mas_bottom);
        make.leading.equalTo(self.textlabel3.mas_trailing).offset(10);
        make.width.equalTo(@160);
        make.height.equalTo(@50);
    }];
    [self.textlabel4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.strat3);
        make.leading.equalTo(self.footerView).offset(15);
        make.width.equalTo(@80);
        make.height.equalTo(@20);
    }];
    [self.strat3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.strat2.mas_bottom);
        make.leading.equalTo(self.textlabel4.mas_trailing).offset(10);
        make.width.equalTo(@160);
        make.height.equalTo(@50);
    }];
    
}

- (UIButton *)rightbtn {
    if (!_rightbtn) {
        _rightbtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_rightbtn setTitle:@"发布" forState:UIControlStateNormal];
        _rightbtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_rightbtn setTitleColor:MineColor forState:UIControlStateNormal];
        [_rightbtn addTarget:self action:@selector(publishBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _rightbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    return _rightbtn;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = CharacterDarkColor;
        _titleLabel.text = @"说说商品的使用体验";
    }
    return _titleLabel;
}


- (UILabel *)textLabel1 {
    if (!_textLabel1) {
        _textLabel1 = [UILabel new];
        _textLabel1.font = [UIFont systemFontOfSize:16];
        _textLabel1.textColor = CharacterDarkColor;
        _textLabel1.text = @"给店铺服务打个分";
    }
    return _textlabel2;
}

- (UILabel *)textlabel2 {
    if (!_textlabel2) {
        _textlabel2 = [UILabel new];
        _textlabel2.font = [UIFont systemFontOfSize:15];
        _textlabel2.textColor = CharacterDarkColor;
        _textlabel2.text = @"描述相符";
    }
    return _textlabel2;
}

- (LTSCStarView *)strat1 {
    if (!_strat1) {
        _strat1 = [[LTSCStarView alloc] initWithFrame:CGRectMake(0, 0, 160, 50) withSpace:15];
        _strat1.delegate = self;
    }
    return _strat1;
}

- (UILabel *)textlabel3 {
    if (!_textlabel3) {
        _textlabel3 = [UILabel new];
        _textlabel3.font = [UIFont systemFontOfSize:15];
        _textlabel3.textColor = CharacterDarkColor;
        _textlabel3.text = @"服务态度";
    }
    return _textlabel3;
}

- (LTSCStarView *)strat2 {
    if (!_strat2) {
        _strat2 = [[LTSCStarView alloc] initWithFrame:CGRectMake(0, 0, 160, 50) withSpace:15];
        _strat2.delegate = self;
    }
    return _strat2;
}

- (UILabel *)textlabel4 {
    if (!_textlabel4) {
        _textlabel4 = [UILabel new];
        _textlabel4.font = [UIFont systemFontOfSize:15];
        _textlabel4.textColor = CharacterDarkColor;
        _textlabel4.text = @"物流服务";
    }
    return _textlabel4;
}


- (LTSCStarView *)strat3 {
    if (!_strat3) {
        _strat3 = [[LTSCStarView alloc] initWithFrame:CGRectMake(0, 0, 160, 50) withSpace:15];
        _strat3.delegate = self;
    }
    return _strat3;
}

- (void)LTSCStarView:(LTSCStarView *)stratView didClickStar:(NSInteger )star {
    if (stratView == _strat1) {
        _strat1.starNum = star;
    } else if (stratView == _strat2) {
        _strat2.starNum = star;
    } else if (stratView == _strat3) {
        _strat3.starNum = star;
    }
}

- (void)uploadImgCompleted:(void(^)(NSMutableArray *remarks))block {
    dispatch_group_t group = dispatch_group_create();
    NSMutableArray *remarks = [NSMutableArray array];
    for (LTSCOrderDetailModel *m in self.orderModel.goods) {
       NSMutableDictionary *dict = [NSMutableDictionary dictionary];
       if (!m.commentStr.isValid) {
           [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"请输入对商品%@的评价!",m.good_name]];
           return;
       }
       if (m.imgArr.count > 0) {
           dispatch_group_enter(group);
           [self updateFile:m ok:^{
               dict[@"remark"] = m.commentStr;
               dict[@"goodId"] = @(m.good_id.intValue);
               dict[@"subOrderId"] = @(m.id.intValue);
               dict[@"picList"] = m.imgStr;
               [remarks addObject:dict];
               dispatch_group_leave(group);
           } fail:^{
               dict[@"remark"] = m.commentStr;
               dict[@"goodId"] = @(m.good_id.intValue);
               dict[@"subOrderId"] = @(m.id.intValue);
               [remarks addObject:dict];
               dispatch_group_leave(group);
           }];
       } else {
           dict[@"remark"] = m.commentStr;
           dict[@"goodId"] = @(m.good_id.intValue);
           dict[@"subOrderId"] = @(m.id.intValue);
           [remarks addObject:dict];
       }
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (block) {
            block(remarks);
        }
    });
}

/// 发布
- (void)publishBtnClick:(UIButton *)btn {
    [self.view endEditing:YES];
    WeakObj(self);
    [self uploadImgCompleted:^(NSMutableArray *remarks) {
            if (selfWeak.strat1.starNum == 0) {
                [SVProgressHUD showErrorWithStatus:@"请对描述相符度进行打分!"];
                return;
            }
            if (selfWeak.strat2.starNum == 0) {
                [SVProgressHUD showErrorWithStatus:@"请对物流态度进行打分!"];
                return;
            }
            if (selfWeak.strat3.starNum == 0) {
                [SVProgressHUD showErrorWithStatus:@"请对物流服务进行打分!"];
                return;
            }

            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic[@"token"] = SESSION_TOKEN;
            dic[@"remarks"] = [remarks mj_JSONString];
            dic[@"describeStar"] = @(selfWeak.strat1.starNum*2);
            dic[@"serverStar"] = @(selfWeak.strat2.starNum*2);
            dic[@"logisticsStar"] = @(selfWeak.strat3.starNum*2);
            dic[@"shopId"] = @(self.orderModel.shop_id.intValue);
            dic[@"orderId"] = @(self.orderModel.id.intValue);
            
            btn.userInteractionEnabled = NO;
            [LTSCLoadingView show];
            WeakObj(self);
            [LTSCNetworking networkingPOST:commentGood parameters:dic returnClass:LTSCBaseModel.class success:^(NSURLSessionDataTask *task, LTSCBaseModel *responseObject) {
                [LTSCLoadingView dismiss];
                if (responseObject.key.intValue == 1000) {
                    btn.userInteractionEnabled = YES;
                    [LTSCToastView showSuccessWithStatus:@"商品评价成功!"];
                    [selfWeak.navigationController popViewControllerAnimated:YES];
                    [LTSCEventBus sendEvent:@"reloadOrderList" data:nil];
                    [LTSCEventBus sendEvent:@"tuikuanSuccess" data:nil];
                } else {
                    [UIAlertController showAlertWithmessage:responseObject.message];
                    btn.userInteractionEnabled = YES;
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                [LTSCLoadingView dismiss];
                btn.userInteractionEnabled = YES;
            }];
    }];
}


/**
 多张图片上传
 */
- (void)updateFile:(LTSCOrderDetailModel *)m ok:(void(^)(void))okBlock fail:(void(^)(void))failBlock{
    [SVProgressHUD showWithStatus:@"正在上传图片,请稍后..."];
    [LTSCNetworking NetWorkingUpLoad:Base_upload_multi_img_URL images:m.imgArr parameters:nil name:@"files" success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"key"] integerValue] == 1000) {
            [SVProgressHUD dismiss];
            NSArray *arr = responseObject[@"result"][@"list"];
            NSMutableArray *imgs = [NSMutableArray array];
            if ([arr isKindOfClass:NSArray.class]) {
                for (NSDictionary *dict in arr) {
                     LTSCCommenttuPianModel *model = [LTSCCommenttuPianModel mj_objectWithKeyValues:dict];
                    [imgs addObject:model.path];
                }
            }
            m.imgStr = [imgs componentsJoinedByString:@","];
            if (okBlock) {
                okBlock();
            }
           
        } else {
            [SVProgressHUD dismiss];
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
            if (failBlock) {
                failBlock();
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        if (failBlock) {
            failBlock();
        }
    }];
}



@end




@implementation LTSCCommentOrderImgCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imgView];
        [self addSubview:self.deletButton];
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self.deletButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.trailing.equalTo(self);
            make.size.equalTo(@30);
        }];
    }
    return self;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [UIImageView new];
    }
    return _imgView;
}

- (UIButton *)deletButton {
    if (!_deletButton) {
        _deletButton = [UIButton new];
        [_deletButton setImage:[UIImage imageNamed:@"shanchu"] forState:UIControlStateNormal];
        _deletButton.imageEdgeInsets = UIEdgeInsetsMake(0, 14, 14, 0);
        [_deletButton addTarget:self action:@selector(deleteImgClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deletButton;
}

- (void)deleteImgClick:(UIButton *)btn {
    if (self.deleteImgBlock) {
        self.deleteImgBlock(self.indexP);
    }
}

@end


#import <AssetsLibrary/ALAssetsLibrary.h>
#import "MXPhotoPickerController.h"
#import "UIViewController+MXPhotoPicker.h"
#import "MLYPhotoBrowserView.h"

@interface LTSCCommentOrderCell ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MLYPhotoBrowserViewDataSource, UITextViewDelegate>

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIView *centerView;

@property (nonatomic, strong) IQTextView *textView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray <UIImage *>*imgArr;

@end
@implementation LTSCCommentOrderCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubViews];
        [self setConstrains];
        self.imgArr = [NSMutableArray array];
    }
    return self;
}

- (void)initSubViews {
    [self addSubview:self.imgView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.centerView];
    [self.centerView addSubview:self.textView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.collectionView];
}

- (void)setConstrains {
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self).offset(15);
        make.size.equalTo(@60);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView);
        make.leading.equalTo(self.imgView.mas_trailing).offset(15);
        make.trailing.equalTo(self).offset(-15);
    }];
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView.mas_bottom).offset(15);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.height.equalTo(@120);
    }];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self.centerView).offset(10);
        make.trailing.bottom.equalTo(self.centerView).offset(-10);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.centerView.mas_bottom).offset(15);
        make.leading.equalTo(self).offset(15);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.height.equalTo(@53);
    }];
}

- (void)setModel:(LTSCOrderDetailModel *)model {
    _model = model;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:_model.list_pic] placeholderImage:[UIImage imageNamed:@"789789"]];
    _nameLabel.text = _model.good_name;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [UIImageView new];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.layer.cornerRadius = 2;
        _imgView.layer.masksToBounds = YES;
    }
    return _imgView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.textColor = CharacterDarkColor;
    }
    return _nameLabel;
}

- (UIView *)centerView {
    if (!_centerView) {
        _centerView = [UIView new];
        _centerView.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0];
        _centerView.layer.cornerRadius = 2;
        _centerView.layer.masksToBounds = YES;
    }
    return _centerView;
}

- (IQTextView *)textView {
    if (!_textView) {
        _textView = [IQTextView new];
        _textView.placeholder = @"写出你的感受，可以帮助更多小伙伴～";
        _textView.font = [UIFont systemFontOfSize:14];
        _textView.textColor = CharacterDarkColor;
        _textView.backgroundColor = UIColor.clearColor;
        _textView.delegate = self;
    }
    return _textView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = CharacterDarkColor;
        _titleLabel.text = @"上传图片";
    }
    return _titleLabel;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 15;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(53, 53);

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[LTSCCommentOrderImgCell class] forCellWithReuseIdentifier:@"LTSCCommentOrderImgCell"];
    }
    return _collectionView;
}

#pragma --mark collectionView的方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imgArr.count + 1;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LTSCCommentOrderImgCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LTSCCommentOrderImgCell" forIndexPath:indexPath];
    cell.indexP = indexPath;
    cell.deletButton.hidden = indexPath.item == self.imgArr.count;
    cell.imgView.image = indexPath.item == self.imgArr.count ? [UIImage imageNamed:@"add_img"] : self.imgArr[indexPath.row];
    WeakObj(self);
    cell.deleteImgBlock = ^(NSIndexPath *indexP) {
        [selfWeak deleteImg:indexP];
    };
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == self.imgArr.count) {//添加图片
        [self addImage];
    } else {
        MLYPhotoBrowserView *mlyView = [MLYPhotoBrowserView photoBrowserView];
        mlyView.dataSource = self;
        mlyView.currentIndex = indexPath.item;
        [mlyView showWithItemsSpuerView:nil];
    }
}


- (void)addImage {
    if (self.imgArr.count >= 9) {
        [SVProgressHUD showErrorWithStatus:@"最多上传9张图片"];
        return;
    }

    UIAlertController * actionController = [UIAlertController alertControllerWithTitle:nil message:@"选择图片上传方式" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * a1 = [UIAlertAction actionWithTitle:@"打开相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [UIViewController.topViewController showMXPhotoCameraAndNeedToEdit:YES completion:^(UIImage *image, UIImage *originImage, CGRect cutRect) {
            if (image) {
                [self.imgArr addObject:image];
                self.model.imgArr = self.imgArr;
                [self.collectionView reloadData];
            }else {
                [SVProgressHUD showErrorWithStatus:@"相片获取失败"];
            }
        }];
    }];
    UIAlertAction * a2 = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [UIViewController.topViewController showMXPickerWithMaximumPhotosAllow:9 - self.imgArr.count completion:^(NSArray *assets) {
            NSArray *assetArr = assets;
            for (int i = 0; i < assets.count; i++)
            {
                ALAsset *asset = assetArr[i];
                CGImageRef thum = [asset aspectRatioThumbnail];
                UIImage *image = [UIImage imageWithCGImage:thum];
                [self.imgArr addObject:image];
                self.model.imgArr = self.imgArr;
            }
            [self.collectionView reloadData];
        }];
    }];
    UIAlertAction * a3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [actionController addAction:a1];
    [actionController addAction:a2];
    [actionController addAction:a3];
    [UIViewController.topViewController presentViewController:actionController animated:YES completion:nil];
}

/**
 删除图片
 */
- (void)deleteImg:(NSIndexPath *)indexP {
    UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:@"确定要删除这张图片吗?" preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        UIImage *img = [self.imgArr objectAtIndex:indexP.item];
        [self.imgArr removeObject:img];
        self.model.imgArr = self.imgArr;
        [self.collectionView reloadData];

    }]];
    [UIViewController.topViewController presentViewController:alertView animated:YES completion:nil];
}

//图片放大
- (NSInteger)numberOfItemsInPhotoBrowserView:(MLYPhotoBrowserView *)photoBrowserView{
    return self.imgArr.count;
}
- (MLYPhoto *)photoBrowserView:(MLYPhotoBrowserView *)photoBrowserView photoForItemAtIndex:(NSInteger)index{
    MLYPhoto *photo = [[MLYPhoto alloc] init];
    photo.image = self.imgArr[index];
    return photo;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [textView endEditing:YES];
    self.model.commentStr = textView.text;
}

@end
