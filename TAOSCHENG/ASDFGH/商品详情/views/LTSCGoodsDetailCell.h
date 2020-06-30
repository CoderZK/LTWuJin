//
//  LTSCGoodsDetailCell.h
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/17.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTSCCateModel.h"

@interface LTSCGoodsDetailCell : UITableViewCell

@property (nonatomic, strong) LTSCGoodsDetailModel *detailModel;

@end

@interface LTSCGoodsDetailGuiGeCell : UITableViewCell

@property (nonatomic, strong) LTSCGoodsDetailModel *detailModel;

@end

@interface LTSCGoodsAddressCell : UITableViewCell

@property (nonatomic, strong) LTSCGoodsDetailAdressModel *addressModel;//地址

@end

@interface LTSCGoodsNoteCell : UITableViewCell

@end

@interface LTSCGoodsImgCell : UITableViewCell

@property (nonatomic, strong) LTSCGoodsDetailTuPianModel *tupianModel;

@end

@interface LTSCNoneAddressCell : UITableViewCell

@end


@interface LTSCGoodsDetailHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) NSString *goodsId;

@property (nonatomic, strong) NSString *evalNum;

@end

//商品评价

@interface LTSCPingJiaImgCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imgView;

@end

@interface LTSCPingJiaCell : UITableViewCell

@property (nonatomic, strong) LTSCGoodsDetailEvalModel *evalModel;

@property (nonatomic, strong) LTSCGoodsDetailEvalModel *evalModel1;

@end


@interface LTSCPingJiaHeaderView : UITableViewHeaderFooterView

@property (nonatomic, copy) void(^didSelectBlock)(NSInteger index);

@property (nonatomic, strong) UILabel *moreLabel;//更多

@end


@interface LTSCPingJiaSellectCell : UITableViewCell

@property (nonatomic, strong) LTSCPingJiaMapModel *model;

@property (nonatomic, copy) void(^didSelectBlock)(NSInteger index);

@end

//商品详情 顶部  商品 评价  详情
@interface LTSCGoodsDetailTopButton : UIButton

@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) UIView *lineView;

@end


@interface LTSCGoodsDetailTopView : UIView

@property (nonatomic, assign) BOOL noDefaultSelected;

@property (nonatomic, copy) void(^selectTopButtonBlock)(NSInteger index);

- (void)setSelectIndex: (NSInteger)index;

- (void)hiddenComment:(BOOL)hide;

@end
