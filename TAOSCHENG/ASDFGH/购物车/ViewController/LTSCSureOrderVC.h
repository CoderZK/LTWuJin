//
//  LTSCSureOrderVC.h
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/20.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"
#import "LTSCCateModel.h"
#import "LTSCShopCarCell.h"
#import "LTSCAddressModel.h"
@interface LTSCSureOrderVC : BaseTableViewController

@property (nonatomic, strong) NSMutableDictionary *dict;

@property (nonatomic, strong) NSString *orderID;//订单id

@property (nonatomic, strong) NSString *ids;//购物车选中商品的购物车id

@property (nonatomic, strong) NSMutableArray <LTSCGoodsDetailSUKModel *> *dataArr;//购物车选中的商品

@property (nonatomic, strong) NSMutableArray <LTSCShopCarDianPuModel *> *dianpuArr;

@property (nonatomic, assign) CGFloat allPrice;//商品金额

@property (nonatomic, copy)void(^tanGuigeViewBlock)(void);


@property (nonatomic, strong) LTSCAddressListModel *addressModel;


@end

@interface LTSCSureOrderGoodsCell : UITableViewCell

@property (nonatomic, strong) LTSCGoodsDetailSUKModel *goodsModel;

@property (nonatomic, strong) LTSCOrderDetailModel *detailModel;

@property (nonatomic, copy) void(^refreshTableView)(LTSCGoodsDetailSUKModel *goodsModel);

@property(nonatomic , strong)UIImageView *xiaJiaImgV;

@end

@interface LTSCSureOrderGoodsOtherCell : UITableViewCell

@property (nonatomic, strong) UILabel *leftLabel;

@property (nonatomic, strong) UILabel *rightLabel;

@end

@interface LTSCSureOrderBottomView : UIView

@property (nonatomic, strong) UILabel *moneyLabel;//价格

@property (nonatomic, copy) void(^submitOrderBlock)(void);

@end


@interface LTSCSureOrderYouhuiQuanCell : UITableViewCell

@property(nonatomic , strong)UIImageView *imagV;
@property (nonatomic, strong) UILabel *leftLabel;

@property (nonatomic, strong) UILabel *rightTwoLabel;
@property (nonatomic, strong) UILabel *rightLabel;


@end
