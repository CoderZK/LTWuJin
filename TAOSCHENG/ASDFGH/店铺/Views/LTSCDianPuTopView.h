//
//  LTSCDianPuTopView.h
//  TAOSCHENG
//
//  Created by 李晓满 on 2020/4/8.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTSCHomeVC.h"

@interface LTSCDianPuTopView : UIView

@property (nonatomic, strong) LTSCShopModel *shopModel;

@property (nonatomic, strong) UIButton *backButton;//返回

@property (nonatomic, strong) UIButton *dianpuButton;

@property (nonatomic, strong) UIButton *attentendButton;//关注

@property (nonatomic, strong) LTSCHomeSearchView *searchView;//搜索

- (CGSize)intrinsicContentSize;

@property (nonatomic, copy) void(^searchBlock)(void);

@end


@interface LTSCDianPuAttentionRankView : UITableViewHeaderFooterView


@end


@interface LTSCDianPuAttentionLikeView : UITableViewHeaderFooterView

@property (nonatomic, strong) UILabel *titleLabel;

@end


@interface LTSCDianPuAttentionRankCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UIImageView *rankImgView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *numLabel;

@end

@interface LTSCDianPuAttentionBaoKuanCell : UITableViewCell

@property (nonatomic, strong) UILabel *buyButton;//立即购买

@property (nonatomic, strong) UIImageView *imgView1;

@property (nonatomic, strong) UIImageView *imgView2;


@end

@interface LTSCDianPuAttentionRankCell : UITableViewCell

@property (nonatomic, copy) void(^didSelectCellClickBlock)(LTSCShopSalesModel *model);

@property (nonatomic, strong) NSArray <LTSCShopSalesModel *>*salesArr;

@end
