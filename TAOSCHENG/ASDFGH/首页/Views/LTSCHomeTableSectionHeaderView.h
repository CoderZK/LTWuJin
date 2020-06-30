//
//  LTSCHomeTableSectionHeaderView.h
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/16.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTSCPublicModel.h"
#import "LTSCCateModel.h"

@interface LTSCHomeTableSectionHeaderView : UITableViewHeaderFooterView

@property (nonatomic, copy) void(^sectionHeaderClick)(NSInteger section);

@property (nonatomic, assign) NSInteger section;

@end

@interface LTSCHomeTableSectionHeaderView1 : UITableViewHeaderFooterView

@end

//首页优惠券
@interface LTSCYouHuiQuanCell : UICollectionViewCell

@property (nonatomic, strong) LTSCYouHuiQuanModel *model;

@end

@interface LTSCHomeYouHuiQuanCell : UITableViewCell

@property (nonatomic, strong) NSArray <LTSCYouHuiQuanModel *> *list;

@property (nonatomic, copy) void(^lingquyouHuiQuanClickBlock)(LTSCYouHuiQuanModel *model);

@end


@interface LTSCHomeReQiCell : UITableViewCell

@property (nonatomic, strong) LTSCChooseListModel *chooseModel;

@end

@interface LTSCHomeBaoKuanCell : UITableViewCell

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, copy) void(^selectItemBlock)(LTSCChooseListModel *model);

@property (nonatomic, strong) NSArray <LTSCChooseListModel *>*dataArr;


@end

@interface LTSCHomeBaoKuanCollectionCell : UICollectionViewCell

@property (nonatomic, strong) LTSCCateModel *model;

@property (nonatomic, strong) LTSCCateModel *dianPuGoodsModel;

@property (nonatomic, strong) LTSCChooseListModel *chooseModel;


@end

@interface LTSCHomeQuestionCell : UITableViewCell

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) LTSCHomeQuestionModel *model;

@end
