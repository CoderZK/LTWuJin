//
//  LTSCSearchVC.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/17.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LTSCSearchVC.h"
#import "LTSCHomeVC.h"
#import "LTSCTitleView.h"
#import "LTSCSearchBgView.h"
#import "LTSCTagView.h"
#import "LTSCSearchManager.h"
#import "LTSCCateModel.h"
#import "LTSCGoodsDetailVC.h"

#define SearchKey @"SearchKey"

@interface LTSCSearchVC ()<UITextFieldDelegate>

@property (nonatomic, strong) LTSCTitleView1 *titleView;

@property (nonatomic, strong) LTSCSearchBgView *searchHoistroyView;//搜索历史

@property (nonatomic , strong) LTSCTagView *tagView;

@property (nonatomic, strong) NSArray <NSString *>*dateArr;//

@property (nonatomic, strong) NSMutableArray <LTSCCateModel *>*keywords;//

@end

@implementation LTSCSearchVC

- (LTSCTitleView1 *)titleView {
    if (!_titleView) {
        _titleView = [[LTSCTitleView1 alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 40)];
    }
    return _titleView;
}

- (LTSCSearchBgView *)searchHoistroyView {
    if (!_searchHoistroyView) {
        _searchHoistroyView = [[LTSCSearchBgView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 100)];
        [_searchHoistroyView.topBtn addTarget:self action:@selector(clean) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchHoistroyView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBarTintColor:UIColor.whiteColor];
    self.tableView.backgroundColor = self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.navigationItem.titleView = self.titleView;
    [self.view addSubview:self.searchHoistroyView];
    [self.titleView.searchView.searchTF becomeFirstResponder];
    self.titleView.searchView.searchTF.delegate = self;
    [self initSearchHistoryView];
    WeakObj(self);
    self.titleView.cancelBlock = ^{
        [selfWeak cancelClick];
    };
    self.keywords = [NSMutableArray array];
}

- (void)initSearchHistoryView {
    self.tagView = [[LTSCTagView alloc] initWithFrame:CGRectMake(0, 50, ScreenW, 100)];
    self.tagView.backgroundColor = UIColor.clearColor;
    self.tagView.cellFontSize = 15;
    self.tagView.cellCornerRadius = 13.5;
    self.tagView.textNormalColor = CharacterDarkColor;
    self.tagView.textSelectedColor = UIColor.whiteColor;
    self.tagView.borderNormalColor = BGGrayColor;
    self.tagView.borderSelectedColor = MineColor;
    self.tagView.bgNormalColor = BGGrayColor;
    self.tagView.bgSelectedColor = MineColor;
    
    
    WeakObj(self);
    self.tagView.didSelectedBlock = ^(NSString *str, NSInteger index) {
        selfWeak.tagView.selectedIndex = 0;
        selfWeak.titleView.searchView.searchTF.text = str;
        [selfWeak searchWithStr:str];
    };
    [self.searchHoistroyView addSubview:self.tagView];
    [self updateTagsViewStatus];
}

- (void)clean {
    [[LTSCSearchManager shared] removeAllSearchRecordForKey:SearchKey];
    [self.tagView setTags:nil];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.searchHoistroyView.hidden = NO;
    self.tableView.hidden = YES;
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    NSString * str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [self loadLianXiangWord:str];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField.text stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0) {
        [LTSCToastView showInFullWithStatus:@"请输入搜索内容"];
        return NO;
    }
    [textField endEditing:YES];
    [[LTSCSearchManager shared] addSearchRecord:textField.text forKey:SearchKey];
    [self updateTagsViewStatus];
    [self searchWithStr:textField.text];
    return YES;
}

- (void)searchWithStr:(NSString *)search {
    if ([search stringByReplacingOccurrencesOfString:@" " withString:@""].length <= 0) {
        return;
    }
    [[LTSCSearchManager shared] addSearchRecord:search forKey:SearchKey];
    [self updateTagsViewStatus];
    if (self.isHome) {
        [LTSCEventBus sendEvent:@"homeSearchClick" data:@{@"searchWord":search}];
    } else if (self.isDianPuSearch) {
        [LTSCEventBus sendEvent:@"dianpuSearchClick" data:@{@"searchWord":search,@"shopId":self.shopId}];
    } else {
        [LTSCEventBus sendEvent:@"searchClick" data:@{@"searchWord":search}];
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)updateTagsViewStatus {
    NSArray *tags = [[LTSCSearchManager shared] searchHistoryForKey:SearchKey];
    [self.tagView  setTags:tags];
    CGFloat height = [_tagView getViewHeight];
    self.tagView .frame = CGRectMake(0, 50, ScreenW, height);
    self.searchHoistroyView.frame = CGRectMake(0, 0, ScreenW, 50 + height);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.keywords.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    cell.textLabel.textColor = CharacterDarkColor;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    LTSCCateModel *model = self.keywords[indexPath.row];
    cell.textLabel.text = model.good_name;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.titleView endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LTSCCateModel *model = self.keywords[indexPath.row];
    LTSCGoodsDetailVC *vc = [[LTSCGoodsDetailVC alloc] init];
    vc.goodsID = model.id;
    [self.navigationController pushViewController:vc animated:YES];
    
}


#pragma 事件处理

/**
 获取联想词
 */
- (void)loadLianXiangWord:(NSString *)str {
    [LTSCNetworking networkingPOST:search_good parameters:@{@"keyword":str} returnClass:[LTSCCateRootModel class] success:^(NSURLSessionDataTask *task, LTSCCateRootModel * responseObject) {
        if (responseObject.key.integerValue == 1000) {
            [self.keywords removeAllObjects];
            [self.keywords addObjectsFromArray:responseObject.result.list];
            if (self.keywords.count >= 1) {
                self.searchHoistroyView.hidden = YES;
                self.tableView.hidden = NO;
                 [self.tableView reloadData];
            }else {
                self.searchHoistroyView.hidden = NO;
                self.tableView.hidden = YES;
            }
            
        }else {
            [UIAlertController showAlertWithmessage:responseObject.message];
            self.searchHoistroyView.hidden = NO;
            self.tableView.hidden = YES;
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

/**
 取消
 */
- (void)cancelClick {
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
