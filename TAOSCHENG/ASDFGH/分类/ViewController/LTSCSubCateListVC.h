//
//  LTSCSubCateListVC.h
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/20.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseViewController.h"
#import "LTSCCateModel.h"

@interface LTSCSubCateListVC : BaseViewController

@property (nonatomic, strong) NSString *shopId;

@property (nonatomic, strong) NSNumber *type;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) NSString *keywords;

@property (nonatomic, strong) LTSCCateModel *cateModel;

- (void)reloadData:(NSString *)keywords;

- (void)reloadData1;

@end


@interface LTSCSubCateListInfoCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UILabel *moneyLabel;

@end

@interface LTSCSubCateListDianPuCell : UICollectionViewCell

@property (nonatomic, strong) LTSCCateModel *model;

@property (nonatomic, copy) void(^didSelectGoods)(LTSCCateModel *model);

@end
