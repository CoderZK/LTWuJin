//
//  LTSCShopModel.h
//  TAOSCHENG
//
//  Created by 李晓满 on 2020/4/9.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LTSCPublicModel.h"

//店铺详情
@interface LTSCShopSalesModel : NSObject

@property (nonatomic, strong) NSString *list_pic;//商品图片

@property (nonatomic, strong) NSString *id;//商品id

@property (nonatomic, strong) NSString *good_name;//商品名称

@property (nonatomic, assign) NSInteger orderNum;//付款人数量

@end

@interface LTSCShopMapModel1 : NSObject

@property (nonatomic, strong) NSString *describeStar;//描述相符评分

@property (nonatomic, strong) NSString *logisticsStar;//物流服务评分

@property (nonatomic, strong) NSString *shopAllStar;//描述相符评分

@property (nonatomic, strong) NSString *describeOtherStar;//描述相符高于同行评分，负数为低于同行

@property (nonatomic, strong) NSString *logisticsOtherStar;//物流服务高于同行评分，负数为低于同行

@property (nonatomic, strong) NSString *serverOtherStar;//服务态度高于同行评分，负数为低于同行

@property (nonatomic, strong) NSString *serverStar;//服务态度评分

@end


@interface LTSCShopModel : NSObject

@property (nonatomic, strong) NSString *isFollow;//是否已关注，false未关注，true已关注

@property (nonatomic, strong) NSString *update_time;//开店时间

@property (nonatomic, strong) NSString *followNum;//关注人数

@property (nonatomic, strong) NSString *province;//省

@property (nonatomic, strong) NSString *city;//市

@property (nonatomic, strong) NSString *user_name;//掌柜名

@property (nonatomic, strong) NSString *server_telephone;//服务电话

@property (nonatomic, strong) NSString *shop_name;//店铺名
@property (nonatomic, strong) NSString *shop_im_code;//店铺名

@property (nonatomic, strong) NSString *shop_pic;//店铺头像

@property (nonatomic, strong) NSArray <LTSCShopSalesModel *> *sales;//销量排行

@property (nonatomic, strong) NSArray <LTSCShopSalesModel *> *hotGood;//人气商品

@end


@interface LTSCShopMapModel : NSObject

@property (nonatomic, strong) LTSCShopModel *map;//

@end

@interface LTSCShopRootModel : NSObject

@property (nonatomic, strong) NSNumber *key;//key

@property (nonatomic, strong) NSString *message;//

@property (nonatomic, strong) LTSCShopMapModel *result;

@end

//猜你喜欢 逛逛更多

@interface LTSCShopGoodsListModel : NSObject

@property (nonatomic, strong) NSArray <LTSCChooseListModel *> *list;//商品列表

@end

@interface LTSCShopGoodsRootModel : NSObject

@property (nonatomic, strong) NSNumber *key;//key

@property (nonatomic, strong) NSString *message;//

@property (nonatomic, strong) LTSCShopGoodsListModel *result;

@end

//店铺分类
@interface LTSCDianPuCataModel : NSObject

@property (nonatomic, strong) NSString *type_name;//二级分类名称

@property (nonatomic, strong) NSString *list_pic;//二级分类图片

@property (nonatomic, strong) NSString *id;//二级分类id

@end

@interface LTSCDianPuFirstCataModel : NSObject

@property (nonatomic, strong) NSString *type_name;//一级分类名称

@property (nonatomic, strong) NSString *id;//一级分类id

@property (nonatomic, strong) NSArray <LTSCDianPuCataModel *> *secondType;//二级分类列表

@end

@interface LTSCDianPuCataListModel : NSObject

@property (nonatomic, strong) NSArray <LTSCDianPuFirstCataModel *> *list;

@end


@interface LTSCDianPuCataRootModel : NSObject

@property (nonatomic, strong) NSNumber *key;//key

@property (nonatomic, strong) NSString *message;//

@property (nonatomic, strong) LTSCDianPuCataListModel *result;

@end
