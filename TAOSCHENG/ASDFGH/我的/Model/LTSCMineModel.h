//
//  LTSCMineModel.h
//  salaryStatus
//
//  Created by 李晓满 on 2019/1/30.
//  Copyright © 2019年 李晓满. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LTSCMineModel : NSObject

@end

@interface LTSCUserInfoModel : NSObject<NSCoding>

@property (nonatomic , strong) NSString *userType;//1：企业用户，2：个人用户

@property (nonatomic , strong) NSString *nickname;//昵称

@property (nonatomic , strong) NSString *tel;//手机号

@property (nonatomic , strong) NSString *username;//昵称
/**  */
@property(nonatomic , strong)NSString *shop_name;
@property(nonatomic , strong)NSString *shop_pic;

@property (nonatomic , strong) NSString *userHead;//昵称

@property (nonatomic , strong) NSString *headPic;//头像

@property (nonatomic, strong) NSString *pay_order;

@property (nonatomic, strong) NSString *send_order;

@property (nonatomic, strong) NSString *sex;

@property (nonatomic, strong) NSString *get_order;

@property (nonatomic, strong) NSString *apply_order;

@property (nonatomic, strong) NSString *comment_order;

@property (nonatomic, strong) NSString *followShopNum;//已关注店铺数量

@property (nonatomic, strong) NSString *couponNum;//未使用优惠券数量

@property (nonatomic, strong) NSString *user_type;/**1-卖家 2-买家*/
@property (nonatomic, strong) NSString *balance;/**余额*/
@property (nonatomic, strong) NSString *head_pic;/**头像*/
@property (nonatomic, strong) NSString *telephone;/**手机号*/
@property (nonatomic, strong) NSString *status;/**1*/
@property (nonatomic, strong) NSString *real_status;/**1-未实名 2-已实名 3-待审核*/
@property (nonatomic, strong) NSString *imPass;/**1*/
@property (nonatomic, strong) NSString *imCode;/**1-未实名 2-已实名 3-待审核*/
@property (nonatomic, strong) NSString *im_code;


@end




/**
 物流详情
 */
@interface LTSCWuLiuInfoListModel : NSObject

@property (nonatomic, strong) NSString *create_time;/**时间*/

@property (nonatomic, strong) NSString *context;/**描述*/

@property (nonatomic, strong) NSString *year;/** 年 */

@property (nonatomic, strong) NSString *diff;/** 时间 */

@property (nonatomic, strong) NSString *day;/** 月日 */

@property (nonatomic, strong) NSString *time;/** 时间 */

@property (nonatomic, assign) CGFloat detailH;

@property (nonatomic, assign) CGFloat cellH;

@end




@interface LTSCWuLiuInfoStateModel : NSObject

@property (nonatomic, strong) NSString *title;/** 标题 */

@property (nonatomic, strong) NSArray  <LTSCWuLiuInfoListModel *>*list;/* 订单列表 */

@end


@interface LTSCWuLiuInfoMapModel : NSObject

@property (nonatomic, strong) NSString *orderCode;/**订单号*/

@property (nonatomic, strong) NSString *company;/**物流公司*/

@property (nonatomic, strong) NSString *status;/**1：待支付，2：待发货，3：待确认收货,4:待补货，5：已完成，6：已取消*/

@end



/**
 选择银行
 */
@interface LTSCSelcetBankModel : NSObject

@property (nonatomic, strong) NSString *bank;

@property (nonatomic, assign) BOOL isSelect;

@end

//已关注店铺
@interface LTSCFollowShopModel : NSObject

@property (nonatomic , strong) NSString *shopId;//店铺id

@property (nonatomic , strong) NSString *shop_name;//店铺名

@property (nonatomic , strong) NSString *shop_pic;//店铺头像

@property (nonatomic , strong) NSString *goodNum;//上新数量

@property (nonatomic , strong) NSString *id;//关注id

@end

@interface LTSCFollowShopListModel : NSObject

@property (nonatomic, strong) NSArray <LTSCFollowShopModel *>*list;

@property (nonatomic, strong) NSString *allPageNumber;

@property (nonatomic, strong) NSString *count;

@property (nonatomic, strong) NSString *data;

@end

@interface LTSCFollowShopRootModel : NSObject

@property (nonatomic, strong) NSNumber *key;//

@property (nonatomic, strong) NSString *message;//

@property (nonatomic, strong) LTSCFollowShopListModel *result;//

@end

@interface LTSCCommenttuPianModel : NSObject

@property (nonatomic , strong) NSString *path;//图片路径

@property (nonatomic , strong) NSString *width;

@property (nonatomic , strong) NSString *height;

@end
