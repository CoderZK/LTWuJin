//
//  LTSCOrderDetailVC.h
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/21.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"
#import "LTSCCateModel.h"

@interface LTSCOrderDetailVC : BaseTableViewController

@property (nonatomic, strong) NSString *orderID;//订单号
@property(nonatomic , assign)BOOL isPP;

@end

@interface LTSCOrderDetailAddressCell : UITableViewCell

@property (nonatomic, strong) LTSCGoodsDetailAdressModel *model;

@property (nonatomic, strong) LTSCOrderListDetailModel *detailModel;

@end


@interface LTSCOrderDetailCell : UITableViewCell

@property (nonatomic, strong) LTSCOrderListDetailModel *detailModel;

@property (nonatomic, strong) LTSCOrderDetailModel *model;

@property (nonatomic, strong) LTSCOrderDetailModel *tuikuanModel;//退款详情

@property (nonatomic, copy) void(^tuikuanBlock)(LTSCOrderListDetailModel *detailModel, LTSCOrderDetailModel *goodsModel);

@end

@interface LTSCOrderDetailBottomView : UIView

@property (nonatomic, copy) void(^bottomActionBlock)(NSInteger index);

@property (nonatomic, strong) LTSCOrderListDetailModel *detailModel;

@end
