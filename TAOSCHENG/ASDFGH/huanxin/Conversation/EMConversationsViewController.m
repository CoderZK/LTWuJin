//
//  EMConversationsViewController.m
//  ChatDemo-UI3.0
//
//  Created by XieYajie on 2019/1/8.
//  Copyright © 2019 XieYajie. All rights reserved.
//

#import "EMConversationsViewController.h"

#import "EMRealtimeSearch.h"
#import "EMConversationHelper.h"

#import "EMConversationCell.h"
#import "UIViewController+Search.h"
#import "EMChatViewController.h"

@interface EMConversationsViewController()<EMChatManagerDelegate, EMGroupManagerDelegate, EMSearchControllerDelegate, EMConversationsDelegate>

@property (nonatomic) BOOL isViewAppear;
@property (nonatomic) BOOL isNeedReload;
@property (nonatomic) BOOL isNeedReloadSorted;
/**  */
@property(nonatomic , strong)NSMutableArray *IDArr;
/**  */
@property(nonatomic , strong)NSMutableArray<LTSCUserInfoModel *> *userArr;

@end

@implementation EMConversationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _setupSubviews];
    self.IDArr = @[].mutableCopy;
    self.userArr = @[].mutableCopy;
    self.navigationItem.title = @"消息中心";
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].groupManager addDelegate:self delegateQueue:nil];
    [[EMConversationHelper shared] addDelegate:self];
    [self _loadAllConversationsFromDBWithIsShowHud:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleGroupSubjectUpdated:) name:GROUP_SUBJECT_UPDATED object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    self.isViewAppear = YES;
    if (self.isNeedReloadSorted) {
        self.isNeedReloadSorted = NO;
        [self _loadAllConversationsFromDBWithIsShowHud:NO];
        
    } else if (self.isNeedReload) {
        self.isNeedReload = NO;
        [self.tableView reloadData];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    self.navigationController.navigationBarHidden = NO;
    self.isViewAppear = NO;
    self.isNeedReload = NO;
    self.isNeedReloadSorted = NO;
}

- (void)dealloc
{
    [[EMClient sharedClient].chatManager removeDelegate:self];
    [[EMClient sharedClient].groupManager removeDelegate:self];
    [[EMConversationHelper shared] removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Subviews

- (void)_setupSubviews
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.showRefreshHeader = YES;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:28];
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(EMVIEWTOPMARGIN + 15);
        make.top.equalTo(self.view).offset(0);
        make.height.equalTo(@0);
    }];
    
    [self enableSearchController];
    [self.searchButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.equalTo(@35);
    }];
    
    self.tableView.rowHeight = 60;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchButton.mas_bottom).offset(15);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    [self _setupSearchResultController];
}

- (void)_setupSearchResultController
{
    __weak typeof(self) weakself = self;
    self.resultController.tableView.rowHeight = 60;
    [self.resultController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
        NSString *cellIdentifier = @"EMConversationCell";
        EMConversationCell *cell = (EMConversationCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[EMConversationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        NSInteger row = indexPath.row;
        EMConversationModel *model = [weakself.resultController.dataArray objectAtIndex:row];
        cell.model = model;
        return cell;
    }];
    [self.resultController setCanEditRowAtIndexPath:^BOOL(UITableView *tableView, NSIndexPath *indexPath) {
        return YES;
    }];
    [self.resultController setCommitEditingAtIndexPath:^(UITableView *tableView, UITableViewCellEditingStyle editingStyle, NSIndexPath *indexPath) {
        if (editingStyle != UITableViewCellEditingStyleDelete) {
            return ;
        }
        
        NSInteger row = indexPath.row;
        EMConversationModel *model = [weakself.resultController.dataArray objectAtIndex:row];
        EMConversation *conversation = model.emModel;
        [[EMClient sharedClient].chatManager deleteConversation:conversation.conversationId isDeleteMessages:YES completion:nil];
        [weakself.resultController.dataArray removeObjectAtIndex:row];
        [weakself.resultController.tableView reloadData];
    }];
    [self.resultController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
        NSInteger row = indexPath.row;
        EMConversationModel *model = [weakself.resultController.dataArray objectAtIndex:row];
        [[NSNotificationCenter defaultCenter] postNotificationName:CHAT_PUSHVIEWCONTROLLER object:model];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"EMConversationCell";
    EMConversationCell *cell = (EMConversationCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[EMConversationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSInteger row = indexPath.row;
    EMConversationModel *model = [self.dataArray objectAtIndex:row];
    cell.model = model;
    
    for (LTSCUserInfoModel * userModel in self.userArr) {
        if ([userModel.im_code isEqualToString:[model.emModel.conversationId uppercaseString]]) {
            [cell.avatarView sd_setImageWithURL:[NSURL URLWithString:[userModel.shop_pic stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet  URLQueryAllowedCharacterSet]]] placeholderImage:[UIImage imageNamed:@"user"] options:SDWebImageRetryFailed];
            cell.nameLabel.text = userModel.shop_name;
        }
    }
//    cell.avatarView.layer.cornerRadius = cell.avatarView.mj_h/2;
//    cell.avatarView.clipsToBounds = YES;
    
    return cell;
}



#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger row = indexPath.row;
    EMConversationModel *model = [self.dataArray objectAtIndex:row];
//    [[NSNotificationCenter defaultCenter] postNotificationName:CHAT_PUSHVIEWCONTROLLER object:model];
    
    EMChatViewController *chatController = [[EMChatViewController alloc] initWithConversationId:model.emModel.conversationId type:EMConversationTypeChat createIfNotExist:YES];
    for (LTSCUserInfoModel * uM  in self.userArr) {
        if ([[model.emModel.conversationId uppercaseString] isEqualToString:uM.im_code]) {
            chatController.toUserHeadPic = uM.shop_pic;
            chatController.toUserName = uM.shop_name;
        }
    }
       [self.navigationController pushViewController:chatController animated:YES];
    
    if ([LTSCTool ShareTool].userModel.imCode.length == 0) {
        [[LTSCTool ShareTool] getHuanXinCodeTwo];
    }
    
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    EMConversationModel *model = [self.dataArray objectAtIndex:row];
    EMConversation *conversation = model.emModel;
    [[EMClient sharedClient].chatManager deleteConversation:conversation.conversationId
                                           isDeleteMessages:YES
                                                 completion:nil];
    [self.dataArray removeObjectAtIndex:row];
    [self.tableView reloadData];
}

#pragma mark - EMChatManagerDelegate

- (void)messagesDidRecall:(NSArray *)aMessages {
    [self _loadAllConversationsFromDBWithIsShowHud:NO];
}

- (void)conversationListDidUpdate:(NSArray *)aConversationList
{
    if (!self.isViewAppear) {
        self.isNeedReloadSorted = YES;
    } else {
        [self _loadAllConversationsFromDBWithIsShowHud:NO];
    }
}

- (void)messagesDidReceive:(NSArray *)aMessages
{
    if (self.isViewAppear) {
        if (!self.isNeedReload) {
            self.isNeedReload = YES;
            [self performSelector:@selector(_reSortedConversationModelsAndReloadView) withObject:nil afterDelay:0.8];
        }
    } else {
        self.isNeedReload = YES;
    }
}

#pragma mark - EMGroupManagerDelegate

- (void)didLeaveGroup:(EMGroup *)aGroup
               reason:(EMGroupLeaveReason)aReason
{
    [[EMClient sharedClient].chatManager deleteConversation:aGroup.groupId isDeleteMessages:NO completion:nil];
}

#pragma mark - EMSearchControllerDelegate

- (void)searchBarWillBeginEditing:(UISearchBar *)searchBar
{
    self.resultController.searchKeyword = nil;
}

- (void)searchBarCancelButtonAction:(UISearchBar *)searchBar
{
    [[EMRealtimeSearch shared] realtimeSearchStop];
    
    [self.resultController.dataArray removeAllObjects];
    [self.resultController.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
}

- (void)searchTextDidChangeWithString:(NSString *)aString
{
    self.resultController.searchKeyword = aString;
    
    __weak typeof(self) weakself = self;
    [[EMRealtimeSearch shared] realtimeSearchWithSource:self.dataArray searchText:aString collationStringSelector:@selector(name) resultBlock:^(NSArray *results) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself.resultController.dataArray removeAllObjects];
            [weakself.resultController.dataArray addObjectsFromArray:results];
            [weakself.resultController.tableView reloadData];
        });
    }];
}

#pragma mark - EMConversationsDelegate

- (void)didConversationUnreadCountToZero:(EMConversationModel *)aConversation
{
    NSInteger index = [self.dataArray indexOfObject:aConversation];
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}

- (void)didResortConversationsLatestMessage
{
    [self _reSortedConversationModelsAndReloadView];
}

#pragma mark - NSNotification

- (void)handleGroupSubjectUpdated:(NSNotification *)aNotif
{
    EMGroup *group = aNotif.object;
    if (!group) {
        return;
    }
    
    NSString *groupId = group.groupId;
    for (EMConversationModel *model in self.dataArray) {
        if ([model.emModel.conversationId isEqualToString:groupId]) {
            model.name = group.subject;
            [self.tableView reloadData];
        }
    }
}

#pragma mark - Data

- (void)_reSortedConversationModelsAndReloadView
{
    NSArray *sorted = [self.dataArray sortedArrayUsingComparator:^(EMConversationModel *obj1, EMConversationModel *obj2) {
        EMMessage *message1 = [obj1.emModel latestMessage];
        EMMessage *message2 = [obj2.emModel latestMessage];
        if(message1.timestamp > message2.timestamp) {
            return(NSComparisonResult)NSOrderedAscending;
        } else {
            return(NSComparisonResult)NSOrderedDescending;
        }}];

    NSMutableArray *conversationModels = [NSMutableArray array];
//    [self.IDArr removeAllObjects];
    NSMutableArray * idArr = @[].mutableCopy;
    for (EMConversationModel *model in sorted) {
        if (!model.emModel.latestMessage) {
            [EMClient.sharedClient.chatManager deleteConversation:model.emModel.conversationId
                                                 isDeleteMessages:NO
                                                       completion:nil];
            continue;
        }
        if (![self.IDArr containsObject:model.emModel.conversationId]) {
            //不包含用户ID
            [idArr addObject:model.emModel.conversationId];
        }
        
        [conversationModels addObject:model];
    }
    
    if (idArr.count > 0) {
        [self.IDArr addObjectsFromArray:idArr];
        [self loadIDsData];
    }else {
        dispatch_async(dispatch_get_main_queue(), ^{
                     
            [self hideHud];
            [self tableViewDidFinishTriggerHeader:YES reload:NO];
            [self.tableView reloadData];
            self.isNeedReload = NO;
        });
    }
    
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:conversationModels];
//    [self.tableView reloadData];
    
    self.isNeedReload = NO;
}

- (void)loadIDsData {
//    if (self.IDArr.count == 0) {
//        [self hideHud];
//        [self tableViewDidFinishTriggerHeader:YES reload:NO];
//        [self.tableView reloadData];
//        self.isNeedReload = NO;
//        return;
//
//    }
    NSMutableDictionary * dict = @{}.mutableCopy;
    dict[@"token"] = TOKEN;
    dict[@"imCodes"] = [[self.IDArr componentsJoinedByString:@","] uppercaseString];
    [LTSCNetworking networkingPOST:get_user_im parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject[@"key"] integerValue] == 1000) {
           
            self.userArr =[LTSCUserInfoModel mj_objectArrayWithKeyValuesArray:responseObject[@"result"][@"list"]];
            [self.tableView reloadData];
            
            dispatch_async(dispatch_get_main_queue(), ^{
              
                [self hideHud];
                [self tableViewDidFinishTriggerHeader:YES reload:NO];
                [self.tableView reloadData];
                self.isNeedReload = NO;
            });
            
            
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                         
               [self hideHud];
               [self tableViewDidFinishTriggerHeader:YES reload:NO];
               [self.tableView reloadData];
               self.isNeedReload = NO;
            });
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        
    }];
    
    
}


- (void)_loadAllConversationsFromDBWithIsShowHud:(BOOL)aIsShowHUD
{
    if (aIsShowHUD) {
        [self showHudInView:self.view hint:@"加载会话列表..."];
    }
    
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
        NSArray *sorted = [conversations sortedArrayUsingComparator:^(EMConversation *obj1, EMConversation *obj2) {
            EMMessage *message1 = [obj1 latestMessage];
            EMMessage *message2 = [obj2 latestMessage];
            if(message1.timestamp > message2.timestamp) {
                return(NSComparisonResult)NSOrderedAscending;
            } else {
                return(NSComparisonResult)NSOrderedDescending;
            }}];
        NSArray *models = [EMConversationHelper modelsFromEMConversations:sorted];
        [weakself.dataArray removeAllObjects];
        [weakself.IDArr removeAllObjects];
        for (EMConversationModel *model in models) {
            if (![self.IDArr containsObject:model.emModel.conversationId]) {
                [weakself.IDArr addObject:model.emModel.conversationId];
                [weakself.dataArray addObject:model];
            }
        }
        [weakself loadIDsData];
        
//        if ([LTSCTool ShareTool].userModel.imCode.length == 0) {
//            [self.dataArray removeAllObjects];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (aIsShowHUD) {
//                    [weakself hideHud];
//                }
//    
//                [weakself tableViewDidFinishTriggerHeader:YES reload:NO];
//                [weakself.tableView reloadData];
//                weakself.isNeedReload = NO;
//            });
//        }else {
//           
//        }
        
//        [weakself loadIDsData];
        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (aIsShowHUD) {
//                [weakself hideHud];
//            }
//
//            [weakself tableViewDidFinishTriggerHeader:YES reload:NO];
//            [weakself.tableView reloadData];
//            weakself.isNeedReload = NO;
//        });
    });
}

- (void)tableViewDidTriggerHeaderRefresh
{
    [self _loadAllConversationsFromDBWithIsShowHud:NO];
}

@end
