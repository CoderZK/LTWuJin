//
//  LTSCPublicModel.h
//  shenbian
//
//  Created by 李晓满 on 2018/10/31.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTSCHomeBannerModel : NSObject

@property (nonatomic, strong) NSString *pic;//路径

@property (nonatomic, strong) NSString *info_id;//跳转的商品id或者大类id

@property (nonatomic, strong) NSString *info_type;//跳转类型：'1：商品id，2：大类列表

@end


@interface LTSCChooseListModel : NSObject

@property (nonatomic, strong) NSString *good_name;//

@property (nonatomic, strong) NSString *id;//

@property (nonatomic, strong) NSString *normal_price;//

@property (nonatomic, strong) NSString *list_pic;//

@property (nonatomic, strong) NSString *info_type;//1-严选，2-爆款  

@end


@interface LTSCPublicModel : NSObject

@property (nonatomic, strong) NSString *type_id;//二类id

@property (nonatomic, strong) NSString *type_pic;//二类图片

@property (nonatomic, strong) NSString *type_name;//二类名称

@property (nonatomic, strong) NSString *info_type;//跳转类型：'1：商品id，2：大类列表

@property (nonatomic, strong) NSString *link_type;//当index_type为3的时候出现,1.机票，2.火车票，3.酒店

@property (nonatomic, strong) NSString *index_type;//1.一级分类，2.充值中心，3.火车票，机票，酒店

@end


@interface LTSCHomeQuestionModel : NSObject

@property (nonatomic, strong) NSString *ID;//itemID

@property (nonatomic, strong) NSString *title;//标题

@property (nonatomic, strong) NSString *content;//描述

@property (nonatomic, strong) NSString *status;//

@property (nonatomic, strong) NSString *createTime;//

@property (nonatomic, strong) NSMutableAttributedString *titleAtt;//

@property (nonatomic, strong) NSMutableAttributedString *contentAtt;//

@property (nonatomic, assign) CGFloat cellheight;

@end

@interface LTSCHomeMapModel : NSObject

@property (nonatomic, strong) NSArray <LTSCHomeQuestionModel *>*qaList;

@property (nonatomic, strong) NSArray <LTSCChooseListModel *>*hotList;

@property (nonatomic, strong) NSArray <LTSCPublicModel *>*typeList;

@property (nonatomic, strong) NSArray <LTSCHomeBannerModel *>*banner;

@property (nonatomic, strong) NSArray <LTSCChooseListModel *>*chooseList;

@end


@interface LTSCHomeModel : NSObject

@property (nonatomic, strong) LTSCHomeMapModel *map;

@end


@interface LTSCHomeRootModel : NSObject

@property (nonatomic, strong) NSString *key;

@property (nonatomic, strong) NSString *message;

@property (nonatomic, strong) LTSCHomeModel *result;

@end


/**
 人气严选
 */
@interface LTSCHomeReQiYanXuanModel : NSObject

@property (nonatomic, strong) NSString *count;

@property (nonatomic, strong) NSArray <LTSCChooseListModel *>*list;

@end

@interface LTSCHomeReQiYanXuanRootModel : NSObject

@property (nonatomic, strong) NSString *key;

@property (nonatomic, strong) NSString *message;

@property (nonatomic, strong) LTSCHomeReQiYanXuanModel *result;

@end

/**
 常见问题自助专区
 */
@interface LTSCHomeAQListModel : NSObject

@property (nonatomic, strong) NSString *count;

@property (nonatomic, strong) NSArray <LTSCHomeQuestionModel *>*list;

@end

@interface LTSCHomeAQListRootModel : NSObject

@property (nonatomic, strong) NSString *key;

@property (nonatomic, strong) NSString *message;

@property (nonatomic, strong) LTSCHomeAQListModel *result;

@end



//第三方外链-跳转直接登录
@interface LTSCHomeThirdLoginModel : NSObject

@property (nonatomic, strong) NSString *data;

@end

@interface LTSCHomeThirdLoginRootModel : NSObject

@property (nonatomic, strong) NSString *key;

@property (nonatomic, strong) NSString *message;

@property (nonatomic, strong) LTSCHomeThirdLoginModel *result;

@end

//优惠券列表

@interface LTSCYouHuiQuanModel : NSObject

@property (nonatomic, strong) NSString *reduce_money;//优惠的金额

@property (nonatomic, strong) NSString *create_time;//开始时间

@property (nonatomic, strong) NSString *last_time;//结束时间

@property (nonatomic, strong) NSString *full_money;//满减的金额

@property (nonatomic, strong) NSString *type;//1.满减，2.抵扣

@property (nonatomic, strong) NSString *id;//优惠券id

@property (nonatomic, strong) NSString *isReceive;//是否领取

@property (nonatomic, strong) NSString *status;//1.待领取，2.可用，3.已用

@property (nonatomic, assign) BOOL isSelect;

@end

@interface LTSCYouHuiQuanMapModel : NSObject

@property (nonatomic, strong) NSString *lastNum;//已过期

@property (nonatomic, strong) NSString *noUseNum;//未使用

@property (nonatomic, strong) NSString *useNum;//已使用

@end


@interface LTSCYouHuiQuanListModel : NSObject

@property (nonatomic, strong) NSArray <LTSCYouHuiQuanModel *> *list;

@property (nonatomic, strong) LTSCYouHuiQuanMapModel *map;

@property (nonatomic, strong) NSString *allPageNumber;

@property (nonatomic, strong) NSString *count;

@property (nonatomic, strong) NSString *data;

@end

@interface LTSCYouHuiQuanRootModel : NSObject

@property (nonatomic, strong) NSString *key;

@property (nonatomic, strong) NSString *message;

@property (nonatomic, strong) LTSCYouHuiQuanListModel *result;

@end


