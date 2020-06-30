//
//  LTSCShopCarCell.h
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/16.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTSCCateModel.h"

@interface LTSCShopCarCell : UITableViewCell

@property (nonatomic, copy) void(^modifyCarSuccess)(LTSCGoodsDetailSUKModel *model);

@property (nonatomic, strong) LTSCGoodsDetailSUKModel *model;

@property (nonatomic, copy) void(^selectModelBlock)(LTSCGoodsDetailSUKModel *model, NSString *numStr);

@property (nonatomic, copy) void(^guigeClickBlock)(LTSCGoodsDetailSUKModel *model);

@end

@interface LTSCShopGuiGeButton : UIButton

@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) UIImageView *iconImgView;

@end

@interface LTSCShopNumView : UIView

@property (nonatomic, strong) UIButton *decButton;//减少

@property (nonatomic, strong) UITextField *numTF;//数量

@property (nonatomic, strong) UIButton *incButton;//增加

@end


@interface LTSCShopCarHeaderView : UITableViewHeaderFooterView

@property (nonatomic, assign) BOOL isXiaDan;

@property (nonatomic, strong) LTSCShopCarDianPuModel *model;

@property (nonatomic, copy) void(^didSelectDianpuBlock)(LTSCShopCarDianPuModel *model);

@property (nonatomic, copy) void(^didSelectDianpuAllGoodsBlock)(LTSCShopCarDianPuModel *model);

@end


@interface LTSCXiaDanFooterView : UITableViewHeaderFooterView

@property (nonatomic, strong) LTSCShopCarDianPuModel *model;

@end
