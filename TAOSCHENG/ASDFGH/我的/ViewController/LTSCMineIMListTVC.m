//
//  LTSCMineIMListTVC.m
//  TAOSCHENG
//
//  Created by kunzhang on 2020/6/8.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "LTSCMineIMListTVC.h"

@interface LTSCMineIMListTVC ()
/** 注释 */
@property(nonatomic , strong)NSMutableArray *dataArray;
/**  */
@property(nonatomic , strong)NSMutableArray *IDArr;
/**  */
@property(nonatomic , strong)NSMutableArray<LTSCUserInfoModel *> *userArr;
@end

@implementation LTSCMineIMListTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = @[].mutableCopy;
    self.IDArr = @[].mutableCopy;
    self.userArr = @[].mutableCopy;
    self.navigationItem.title = @"我的会话";
    
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
        
        [weakself.dataArray removeAllObjects];
        [self.IDArr removeAllObjects];
        NSArray *models = [EMConversationHelper modelsFromEMConversations:sorted];
        [weakself.dataArray addObjectsFromArray:models];
       [self.IDArr removeAllObjects];
        for (EMConversationModel *model in models) {
           
            [weakself.IDArr addObject:model.emModel.conversationId];

        }
        [weakself loadIDsData];
        
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
                [self.tableView reloadData];
            
            });
            
            
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                         
               [self hideHud];
               [self.tableView reloadData];
            });
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        
    }];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 75;
}
- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    // cell.nameLB.text = @"fgkodkgfeoprkgkp";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
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
