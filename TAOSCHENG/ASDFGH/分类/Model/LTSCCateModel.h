//
//  LTSCCateModel.h
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/23.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTSCCateModel : NSObject

@property (nonatomic, strong) NSString *id;//大类id

@property (nonatomic, strong) NSString *typeName;//大类名称

@property (nonatomic, strong) NSString *listPic;//图标或列表图片

@property (nonatomic, strong) NSString *pid;//父类id

@property (nonatomic, strong) NSString *goodName;//商品名称

@property (nonatomic, strong) NSString *firstTypeId;//大类id

@property (nonatomic, strong) NSString *secondTypeId;//二类id

@property (nonatomic, strong) NSString *normalPrice;//价格

@property (nonatomic, strong) NSString *good_name;//商品名称

@property (nonatomic, strong) NSString *info_type;//1-严选，2-爆款

@property (nonatomic, strong) NSString *list_pic;//图标或列表图片

@property (nonatomic, strong) NSString *normal_price;//商品价格

@property (nonatomic, strong) NSString *shop_name;//店铺名称

@property (nonatomic, strong) NSString *shop_pic;//店铺logo

@property (nonatomic, strong) NSString *shopId;//店铺id

@property (nonatomic, strong) NSString *shop_store_id;//店铺id

@property (nonatomic, strong) NSString *goodNum;//在售商品

@property (nonatomic, strong) NSString *followNum;//关注人数

@property (nonatomic, strong) NSArray <LTSCCateModel *>*goodList;//商品列表

@end

@interface LTSCCateListModel : NSObject

@property (nonatomic, strong) NSArray <LTSCCateModel *>*list;

@property (nonatomic, strong) NSString *allPageNumber;

@property (nonatomic, strong) NSString *count;

@property (nonatomic, strong) NSString *data;

@end

@interface LTSCCateRootModel : NSObject

@property (nonatomic, strong) NSNumber *key;//

@property (nonatomic, strong) NSString *message;//

@property (nonatomic, strong) LTSCCateListModel *result;//

@end

//商品详情

@interface LTSCGoodsDetailAdressModel : NSObject

@property (nonatomic, strong) NSString *username;//联系人姓名

@property (nonatomic, strong) NSString *id;//地址id，下单的时候需要

@property (nonatomic, strong) NSString *telephone;//联系电话

@property (nonatomic, strong) NSString *province;//省

@property (nonatomic, strong) NSString *city;//市

@property (nonatomic, strong) NSString *district;//区县

@property (nonatomic, strong) NSString *addressDetail;//详细地址

@property (nonatomic, assign) CGFloat cellHeight;//地址栏高度

@property (nonatomic, strong) NSString *defaultStatus;//是否是默认 1：不是默认，2：是默认

@property (nonatomic, assign) CGFloat cellHeight1;//地址栏高度

@end

@interface LTSCGoodsDetailGuiGeModel : NSObject

@property (nonatomic, strong) NSString *property;//规格名称

@property (nonatomic, strong) NSString *id;//规格id

@property (nonatomic, strong) NSString *good_name;//商品名称

@property (nonatomic, strong) NSMutableArray<NSString *> *propsArr;

@end

@class LTSCGoodsDetailRootModel;
@interface LTSCGoodsDetailSUKModel : NSObject <MJKeyValue>

@property (nonatomic, strong) LTSCGoodsDetailRootModel *rootModel;

@property (nonatomic, assign) BOOL isSelect;//是否选中

@property (nonatomic, strong) NSString *id;//购物车id

@property (nonatomic, strong) NSString *goodId;//规格id

@property (nonatomic, strong) NSString *good_id;//商品id

@property (nonatomic, strong) NSString *properties;// sku格式

@property (nonatomic, strong) NSString *createTime;//创建时间

@property (nonatomic, strong) NSString *status;//创建时间

@property (nonatomic, strong) NSString *goodPrice;//商品价格

@property (nonatomic, strong) NSString *goodNum;//商品数量

@property (nonatomic, strong) NSString *yixuanStr;//已选商品规格

@property (nonatomic, strong) NSString *yixuanStr1;//已选商品规格

//购物车列表用到的
@property (nonatomic, strong) NSString *good_num;//商品数量

@property (nonatomic, strong) NSString *good_price;//商品价格

@property (nonatomic, strong) NSString *list_pic;//列表图片

@property (nonatomic, strong) NSString *create_time;//创建时间

@property (nonatomic, strong) NSString *user_id;//用户id

@property (nonatomic, strong) NSString *num;//购买数量

@property (nonatomic, strong) NSString *sku_id;//规格id
@property (nonatomic, strong) NSString *skuId;//规格id

@property (nonatomic, strong) NSString *good_name;//商品名称

@property (nonatomic, strong) NSMutableAttributedString *titleAtt;//

@property (nonatomic, strong) NSMutableAttributedString *contentAtt;//

@property (nonatomic, assign) CGFloat contentHeight;//

@property (nonatomic, assign) CGFloat cellheight;

@property (nonatomic, assign) BOOL isCart;//是否是购物车跳转过来的


@end


@interface LTSCGoodsDetailModel : NSObject

@property (nonatomic, strong) NSString *id;//商品id

@property (nonatomic, strong) NSString *goodName;//商品名称

@property (nonatomic, strong) NSString *firstTypeId;//一级分类id

@property (nonatomic, strong) NSString *secondTypeId;//二级分类id

@property (nonatomic, strong) NSString *listPic;//列表图片

@property (nonatomic, strong) NSString *mainPic;//轮播图片，多张链接逗号隔开

@property (nonatomic, strong) NSString *normalPrice;//商品价格

@property (nonatomic, strong) NSString *downUrl;//分享的下载地址


@property (nonatomic, strong) NSString *content;//详情图片，多张链接逗号隔开

@property (nonatomic, strong) NSString *shopStoreId;//店铺id

@property (nonatomic, assign) CGFloat cellHeight;//商品名称cell高度

@property (nonatomic, strong) NSString *yixuanStr;//已选商品规格

@property (nonatomic, strong) NSString *info_type;//1-严选，2-爆款
@property (nonatomic, strong) NSString *goodNum;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *status;

@end


@interface LTSCGoodsDetailEvalModel : NSObject

@property (nonatomic, strong) NSString *create_time;//创建时间

@property (nonatomic, strong) NSString *list_pic;//店铺id

@property (nonatomic, strong) NSString *head_pic;//店铺id

@property (nonatomic, strong) NSString *remark;//店铺id

@property (nonatomic, strong) NSString *id;//评价id

@property (nonatomic, strong) NSString *username;//店铺id

@property (nonatomic, assign) CGFloat cellHeight;//高度

@property (nonatomic, assign) CGFloat cellHeight1;//高度

@end



@interface LTSCGoodsDetailMapModel : NSObject

@property (nonatomic, strong) LTSCGoodsDetailAdressModel *address;//地址模型

@property (nonatomic, strong) NSArray <LTSCGoodsDetailGuiGeModel *>*guideList;

@property (nonatomic, strong) NSArray <LTSCGoodsDetailSUKModel *>*skuList;

@property (nonatomic, strong) NSNumber *num;//已经加入购物车的数量，没有就返回0

@property (nonatomic, strong) LTSCGoodsDetailModel *detail;//商品模型

@property (nonatomic, strong) NSString *shopName;//店铺名称

@property (nonatomic, strong) LTSCGoodsDetailEvalModel *eval;//评价

@property (nonatomic, strong) NSString *evalNum;//评价数量


@end


@interface LTSCGoodsDetailResultModel : NSObject

@property (nonatomic, strong) LTSCGoodsDetailMapModel *map;//

@end


@interface LTSCGoodsDetailRootModel : NSObject

@property (nonatomic, strong) NSNumber *key;

@property (nonatomic, strong) NSString *message;

@property (nonatomic, strong) LTSCGoodsDetailResultModel *result;

@end




//购物车列表


@interface LTSCShopCarDianPuModel : NSObject

@property (nonatomic, strong) NSString *shopId;//店铺id

@property (nonatomic, strong) NSString *shop_name;//店铺名称

@property (nonatomic, strong) NSString *remark;//备注

@property (nonatomic, strong) NSArray <LTSCGoodsDetailSUKModel *>*goodList;//商品列表

@property (nonatomic, assign) BOOL isSelect;

@end




@interface LTSCShopCarModel : NSObject

@property (nonatomic, strong) NSString *count;

@property (nonatomic, strong) NSString *allPageNumber;

@property (nonatomic, strong) NSArray <LTSCShopCarDianPuModel *> *list;//

@end



@interface LTSCShopCarRootModel : NSObject

@property (nonatomic, strong) NSNumber *key;

@property (nonatomic, strong) NSString *message;

@property (nonatomic, strong) LTSCShopCarModel *result;

@end


/**
 图片
 */
@interface LTSCGoodsDetailTuPianModel : NSObject

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *url;

@property (nonatomic, strong) NSString *height;

@property (nonatomic, strong) NSString *width;

@property (nonatomic, strong) NSString *uid;

@property (nonatomic, strong) NSString *status;

@end


/**
 我的订单列表
 */
@interface LTSCOrderDetailModel : NSObject

@property (nonatomic, strong) NSString *status;//3：驳回退款，4：待退款,5.退款成功

@property (nonatomic, strong) NSString *good_id;/**商品id*/

@property (nonatomic, strong) NSString *good_name;/**商品名称*/

@property (nonatomic, strong) NSString *list_pic;/**商品图片*/

@property (nonatomic, strong) NSString *good_price;/**商品价格*/

@property (nonatomic, strong) NSString *properties;/**商品规格*/

@property (nonatomic, strong) NSString *num;

@property (nonatomic, strong) NSString *total_money;

@property (nonatomic, strong) NSString *id;

@property (nonatomic, strong) NSMutableAttributedString *yixuanAttStr;//已选商品规格

@property (nonatomic, strong) NSMutableArray <UIImage *>*imgArr;/**评价图*/

@property (nonatomic, strong) NSString *imgStr;/**评价图*/

@property (nonatomic, strong) NSString *commentStr;/**评价内容*/

@end

@interface LTSCOrderObjectModel : NSObject

@property (nonatomic, strong) NSString *system_time;/**店铺id*/

@property (nonatomic, strong) NSString *shop_id;/**店铺id*/

@property (nonatomic, strong) NSString *shop_name;/**店铺名称*/

@property (nonatomic, strong) NSString *order_code;/**订单号*/

@property (nonatomic, strong) NSString *create_time;

@property (nonatomic, strong) NSString *current_time;/**创建时间*/

@property (nonatomic, strong) NSString *id;/**订单id*/

@property (nonatomic, strong) NSString *base_money;/**原价*/

@property (nonatomic, strong) NSString *total_money;/**优惠后的价格*/

@property (nonatomic, strong) NSString *status;/**1：待支付，2：已付款，3：已发货，4：已确认收货，5.待退款，6.已取消*/

@property (nonatomic, strong) NSString *user_id;

@property (nonatomic, strong) NSString *address_id;

@property (nonatomic, strong) NSString *del_status;



@property (nonatomic, strong) NSArray <LTSCOrderDetailModel *> *goods;//

@end

@interface LTSCOrderModel : NSObject

@property (nonatomic, strong) NSString *count;

@property (nonatomic, strong) NSString *allPageNumber;

@property (nonatomic, strong) NSString *data;

@property (nonatomic, strong) NSArray <LTSCOrderObjectModel *> *list;//

@end

@interface LTSCOrderRootModel : NSObject

@property (nonatomic, strong) NSString *key;

@property (nonatomic, strong) NSString *message;

@property (nonatomic, strong) LTSCOrderModel *result;//

@end


//订单详情

@interface LTSCOrderListDetailModel : NSObject

@property (nonatomic, strong) NSString *express_num;

@property (nonatomic, strong) NSString *city;

@property (nonatomic, strong) NSString *freight;

@property (nonatomic, strong) NSString *del_status;

@property (nonatomic, strong) NSString *base_money;

@property (nonatomic, strong) NSString *remark;

@property (nonatomic, strong) NSString *express_company;

@property (nonatomic, strong) NSString *address_detail1;

@property (nonatomic, strong) NSString *province;

@property (nonatomic, strong) NSString *pay_type;

@property (nonatomic, strong) NSString *id;

@property (nonatomic, strong) NSString *order_type;

@property (nonatomic, strong) NSString *create_time;

@property (nonatomic, strong) NSString *address_id;

@property (nonatomic, strong) NSString *telephone;

@property (nonatomic, strong) NSString *shop_name;

@property (nonatomic, strong) NSString *order_code;

@property (nonatomic, strong) NSString *shop_id;

@property (nonatomic, strong) NSString *user_id;

@property (nonatomic, strong) NSString *district;

@property (nonatomic, strong) NSString *total_money;

@property (nonatomic, strong) NSString *status;//1：待支付，2：已付款，3：已发货，4：已确认收货，5.待退款，6.已取消，7.已评论

@property (nonatomic, strong) NSString *username;


@property (nonatomic, strong) NSString *userId;

@property (nonatomic, strong) NSString *orderCode;

@property (nonatomic, strong) NSString *createTime;

@property (nonatomic, strong) NSString *addressId;

@property (nonatomic, strong) NSString *totalMoney;

@property (nonatomic, strong) NSString *delStatus;

@property (nonatomic, strong) NSString *judgeId;

@property (nonatomic, strong) NSString *disId;

@property (nonatomic, strong) NSString *baseMoney;

@property (nonatomic, strong) NSString *reason;

@property (nonatomic, strong) NSString *apply_time;

@property (nonatomic, strong) NSString *payType;//支付方式

@property (nonatomic, strong) NSArray <LTSCOrderDetailModel *> *subOrders;//订单列表

@property (nonatomic, strong) LTSCGoodsDetailAdressModel *address;

@property (nonatomic, assign) CGFloat cellHeight;//地址栏高度

@property (nonatomic, assign) CGFloat cellHeight1;//地址栏高度


@end


/**
 退款原因
 */
@interface LTSCTuiKuanReasonModel : NSObject

@property (nonatomic, strong) NSString *id;

@property (nonatomic, strong) NSString *reason;

@property (nonatomic, strong) NSString *createTime;

@property (nonatomic, strong) NSString *status;

@end

@interface LTSCTuiKuanReasonListModel : NSObject

@property (nonatomic, strong) NSArray <LTSCTuiKuanReasonModel *> *list;//订单列表

@end

@interface LTSCTuiKuanReasonRootModel : NSObject

@property (nonatomic, strong) NSString *key;

@property (nonatomic, strong) NSString *message;

@property (nonatomic, strong) LTSCTuiKuanReasonListModel *result;

@end

//评价列表

@interface LTSCPingJiaMapModel : NSObject

@property (nonatomic, strong) NSString *picNum;//有图评价总数

@end

@interface LTSCPingJiaListModel : NSObject

@property (nonatomic, strong) NSArray <LTSCGoodsDetailEvalModel *> *list;

@property (nonatomic, strong) LTSCPingJiaMapModel *map;

@property (nonatomic, strong) NSString *allPageNumber;

@property (nonatomic, strong) NSString *count;

@property (nonatomic, strong) NSString *data;

@end

@interface LTSCPingJiaRootModel : NSObject

@property (nonatomic, strong) NSString *key;

@property (nonatomic, strong) NSString *message;

@property (nonatomic, strong) LTSCPingJiaListModel *result;

@end
