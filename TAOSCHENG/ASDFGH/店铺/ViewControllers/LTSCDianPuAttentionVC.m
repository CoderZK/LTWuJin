//
//  LTSCDianPuAttentionVC.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2020/4/8.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "LTSCDianPuAttentionVC.h"
#import "LTSCDianPuYinXiangVC.h"
#import "LTSCDianPuTabBarController.h"

@interface LTSCDianPuAttentionVC ()

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray <LTSCFollowShopModel *> *dataArr;

@property (nonatomic, assign) NSInteger allPageNum;

@end

@implementation LTSCDianPuAttentionVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = UIColor.whiteColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.navigationItem.title = @"店铺关注";
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0.5);
        make.leading.trailing.bottom.equalTo(self.view);
    }];
    
    self.dataArr = [NSMutableArray array];
    self.allPageNum = 1;
    self.page = 1;
    [self loadData];
    WeakObj(self);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       selfWeak.page = 1;
       selfWeak.allPageNum = 1;
       [self loadData];
    }];

    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
       [selfWeak loadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LTSCDianPuAttentionCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LTSCDianPuAttentionCell"];
    if (!cell) {
        cell = [[LTSCDianPuAttentionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LTSCDianPuAttentionCell"];
    }
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LTSCDianPuTabBarController *tabVC = [LTSCDianPuTabBarController new];
    tabVC.shopId = self.dataArr[indexPath.row].shopId;
//    tabVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:tabVC animated:NO completion:nil];
}

/**
 请求数据
 */
- (void)loadData {
    if (self.page <= self.allPageNum) {
        if (self.dataArr.count <= 0) {
            [LTSCLoadingView show];
        }
        [LTSCNetworking networkingPOST:followShopList parameters:@{@"token":SESSION_TOKEN,@"pageNum" : @(self.page),@"pageSize" : @10} returnClass:LTSCFollowShopRootModel.class success:^(NSURLSessionDataTask *task, LTSCFollowShopRootModel *responseObject) {
            [self endRefrish];
            if (responseObject.key.intValue == 1000) {
                self.allPageNum = responseObject.result.allPageNumber.intValue;
                if (self.page == 1) {
                    [self.dataArr removeAllObjects];
                }
                if (self.page <= responseObject.result.allPageNumber.intValue) {
                    [self.dataArr addObjectsFromArray:responseObject.result.list];
                }
                self.page ++;
                [self.tableView reloadData];
            } else {
                [UIAlertController showAlertWithmessage:responseObject.message];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [self endRefrish];
        }];
    }
}



@end

//cell
@interface LTSCDianPuAttentionCell ()

@property (nonatomic, strong) UIImageView *imgView;//店铺logo

@property (nonatomic, strong) UILabel *nameLabel;//店铺名称

@property (nonatomic, strong) UILabel *shangxinLabel;//9件上新

@property (nonatomic, strong) UIView *lineView;//线

@end
@implementation LTSCDianPuAttentionCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubViews];
        [self setConstains];
    }
    return self;
}

- (void)initSubViews {
    [self addSubview:self.imgView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.shangxinLabel];
    [self addSubview:self.lineView];
}

- (void)setConstains {
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.centerY.equalTo(self);
        make.size.equalTo(@40);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.imgView.mas_trailing).offset(10);
        make.bottom.equalTo(self.mas_centerY).offset(-2);
    }];
    [self.shangxinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.imgView.mas_trailing).offset(10);
        make.top.equalTo(self.mas_centerY).offset(2);
        make.height.equalTo(@18);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.trailing.bottom.equalTo(self);
        make.height.equalTo(@0.5);
    }];
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [UIImageView new];
        _imgView.layer.cornerRadius = 20;
        _imgView.layer.masksToBounds = YES;
    }
    return _imgView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.font = [UIFont boldSystemFontOfSize:15];
        _nameLabel.textColor = CharacterDarkColor;
    }
    return _nameLabel;
}

- (UILabel *)shangxinLabel {
    if (!_shangxinLabel) {
        _shangxinLabel = [UILabel new];
        
        _shangxinLabel.font = [UIFont systemFontOfSize:11];
        _shangxinLabel.textColor = MineColor;
        _shangxinLabel.backgroundColor = [UIColor colorWithRed:255/255.0 green:245/255.0 blue:230/255.0 alpha:1.0];
        _shangxinLabel.layer.cornerRadius = 9;
        _shangxinLabel.layer.masksToBounds = YES;
    }
    return _shangxinLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0];
    }
    return _lineView;
}

- (void)setModel:(LTSCFollowShopModel *)model {
    _model = model;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:_model.shop_pic] placeholderImage:[UIImage imageNamed:@"789789"]];
    _nameLabel.text = _model.shop_name;
    if (_model.goodNum.intValue == 0) {
        _shangxinLabel.text = @"  暂无上新  ";
    } else {
        _shangxinLabel.text = [NSString stringWithFormat:@"  %d件上新  ", _model.goodNum.intValue];
    }
}

@end
