//
//  LTSCSelectAddressVC.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/20.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LTSCSelectAddressVC.h"
#import "LTSCAddressCell.h"
#import "LTSCNewAddressVC.h"
#import "LTSCAddressModel.h"

@interface LTSCSelectAddressVC ()

@property (nonatomic, strong) LTSCEmptyAddressView *emptyView;//空界面

@property (nonatomic, strong) UIImageView *imgView;//顶部背景

@property (nonatomic, strong) UIButton *bottomButton;//底部创建按钮

@property (nonatomic , assign) NSInteger page;

@property (nonatomic , strong) NSMutableArray <LTSCAddressListModel *>*dataArr;

@end

@implementation LTSCSelectAddressVC

- (LTSCEmptyAddressView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[LTSCEmptyAddressView alloc] init];
        _emptyView.hidden = YES;
    }
    return _emptyView;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.image = [UIImage imageNamed:@"addressimage"];
    }
    return _imgView;
}

- (UIButton *)bottomButton {
    if (!_bottomButton) {
        _bottomButton = [[UIButton alloc] init];
        [_bottomButton setTitle:@"+ 新建地址" forState:UIControlStateNormal];
        [_bottomButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_bottomButton setBackgroundImage:[UIImage imageNamed:@"yellow"] forState:UIControlStateNormal];
        _bottomButton.layer.cornerRadius = 3;
        _bottomButton.layer.masksToBounds = YES;
        [_bottomButton addTarget:self action:@selector(newCreateClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomButton;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
  
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择地址";
    [self initEmptyView];
    [self.view addSubview:self.imgView];
    [self.view addSubview:self.bottomButton];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.height.equalTo(@9);
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
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(9);
        make.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.bottomButton.mas_top);
    }];
    
    self.dataArr = [NSMutableArray array];
    self.page = 1;
    [self loadAddressList];
    WeakObj(self);
    self.tableView.mj_header = [LTSCRefreshHeader headerWithRefreshingBlock:^{
        selfWeak.page = 1;
        [selfWeak loadAddressList];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [selfWeak loadAddressList];
    }];
    
    
    [LTSCEventBus registerEvent:@"addressAddSuccess" block:^(id data) {
          self.page = 1;
          [self loadAddressList];
      }];
    
}

/**
 获取地址列表
 */
- (void)loadAddressList {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = SESSION_TOKEN;
    dict[@"pageNum"] = @(self.page);
    [LTSCLoadingView show];
    [LTSCNetworking networkingPOST:address_list parameters:dict returnClass:[LTSCAddressListRootModel1 class] success:^(NSURLSessionDataTask *task, LTSCAddressListRootModel1 *responseObject) {
        [self endRefrish];
        if (responseObject.key.intValue == 1000) {
            if (self.page == 1) {
                [self.dataArr removeAllObjects];
            }
            if (responseObject.result.count.integerValue > self.dataArr.count) {
                [self.dataArr addObjectsFromArray:responseObject.result.list];
            }
            self.page++;
            self.imgView.hidden = self.dataArr.count <= 0;
            self.emptyView.hidden = self.dataArr.count > 0;
            [self.tableView reloadData];
        }else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self endRefrish];
    }];
}



/**
 初始化空数据界面
 */
- (void)initEmptyView {
    [self.view addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.equalTo(@200);
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LTSCAddressCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LTSCAddressCell"];
    if (!cell) {
        cell = [[LTSCAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LTSCAddressCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    LTSCAddressListModel *model = self.dataArr[indexPath.row];
    cell.model = model;
    cell.editBlock = ^(LTSCAddressListModel *model) {
        LTSCNewAddressVC *vc = [[LTSCNewAddressVC alloc] init];
        vc.editModel = model;
        [self.navigationController pushViewController:vc animated:YES];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LTSCAddressListModel *model = self.dataArr[indexPath.row];
    return model.cellHeight;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isSelect) {
        LTSCAddressListModel *model = self.dataArr[indexPath.row];
        LTSCGoodsDetailAdressModel  *m = [LTSCGoodsDetailAdressModel new];
        m.username = model.username;
        m.id = model.id;
        m.telephone = model.telephone;
        m.province = model.province;
        m.city = model.city;
        m.district = model.district;
        m.addressDetail = model.addressDetail;
        m.defaultStatus = model.defaultStatus;
        if (self.selectAddressModelClick) {
            self.selectAddressModelClick(m);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    LTSCAddressListModel *model = self.dataArr[indexPath.row];
    [self deleteAddress:model];
}


/**
 新建地址
 */
- (void)newCreateClick {
    LTSCNewAddressVC *vc = [[LTSCNewAddressVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)deleteAddress:(LTSCAddressListModel *)model {
    [LTSCLoadingView show];
    [LTSCNetworking networkingPOST:del_address parameters:@{@"token":SESSION_TOKEN,@"addressId":model.id} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [LTSCLoadingView dismiss];
        if ([responseObject[@"key"] integerValue] == 1000) {
            [LTSCToastView showSuccessWithStatus:@"已删除"];
            [self.dataArr removeObject:model];
            self.imgView.hidden = self.dataArr.count <= 0;
            self.emptyView.hidden = self.dataArr.count > 0;
            [self.tableView reloadData];
        }else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [LTSCLoadingView dismiss];
    }];
}

@end


@interface LTSCEmptyAddressView()

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UILabel *textLabel;

@end
@implementation LTSCEmptyAddressView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imgView];
        [self addSubview:self.textLabel];
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.centerX.equalTo(self);
            make.width.height.equalTo(@150);
        }];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imgView.mas_bottom).offset(5);
            make.centerX.equalTo(self);
        }];
    }
    return self;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.image = [UIImage imageNamed:@"emptyaddress"];
    }
    return _imgView;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = CharacterLightGrayColor;
        _textLabel.font = [UIFont systemFontOfSize:15];
        _textLabel.text = @"暂无收货地址";
    }
    return _textLabel;
}

@end
