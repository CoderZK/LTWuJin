//
//  LTSCGuiGeView.h
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/17.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTSCCateModel.h"

@interface LTSCGuiGeView : UIControl

@property (nonatomic, copy) void(^pushShopCarVC)(void);
@property (nonatomic, copy) void(^dianPuVCBlock)(void);

@property (nonatomic, copy) void(^lijiGouMaiBlock)(LTSCGoodsDetailSUKModel * currentModel,NSInteger num);

@property (nonatomic, strong) UIViewController *topViewController;

@property (nonatomic, assign) BOOL isGoods;//是否是商品详情

@property (nonatomic, copy) void(^currentSKUDidChanged)(LTSCGoodsDetailSUKModel * currentModel, NSString *currrentStatus, NSInteger num);

@property (nonatomic, copy) void(^closeBlock)(BOOL isclose);

@property (nonatomic, strong) LTSCGoodsDetailModel *goodsModel;

@property (nonatomic, strong) NSString *carNum;

@property (nonatomic, strong) NSArray <LTSCGoodsDetailGuiGeModel *>*guigeArr;//规格

@property (nonatomic, strong) NSArray <LTSCGoodsDetailSUKModel *>*skuArr;//

- (void)reloadData;

- (void)show;

- (void)dismiss;

- (void)updateCurrentSelectedModel:(LTSCGoodsDetailSUKModel *)skuModel;

@property (nonatomic, copy) void(^sureBlock)(LTSCGoodsDetailSUKModel * currentModel,NSInteger num);

@end

@interface LTSCGuiGeTopView : UIView

@property (nonatomic, strong) UIButton *closeBtn;//关闭

@property (nonatomic, strong) UIImageView *imgView;//图片

@property (nonatomic, strong) UILabel *priceLabel;//价格

@property (nonatomic, strong) UILabel *kucunLabel;//库存

@property (nonatomic, strong) UILabel *yxggLabel;//已选规格

@end

@interface LTSCGuiGeNumView : UICollectionReusableView

@property (nonatomic, strong) UIButton *decButton;//减少

@property (nonatomic, strong) UITextField *numTF;//数量

@property (nonatomic, strong) UIButton *incButton;//增加

@end

@interface LTSCGoodsBottomButton : UIButton

@property (nonatomic, strong) UIImageView *iconImgView;

@property (nonatomic, strong) UILabel *textLabel;

@end


@interface LTSCGoodsGuiGeBottomView : UIView

@property (nonatomic, copy) void(^dianpuClickBlock)(void);//店铺

@property (nonatomic, copy) void(^shopCarBlock)(void);//购物车

@property (nonatomic, copy) void(^lijigoumaiBlock)(void);//立即购买

@property (nonatomic, copy) void(^addShopCarBlock)(void);//加入购物车

@property (nonatomic, strong) UILabel *numLabel;//购物车数量

@property (nonatomic, strong) UIButton *lijiButton;//立即购买

@property (nonatomic, strong) UIButton *addCarButton;//加入购物车


@end

@interface PropertyCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *propertyL;

@end

@interface PropertyHeader : UICollectionReusableView

@property (nonatomic, strong) UILabel *guigeLabel;

@end
