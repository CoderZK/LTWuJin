//
//  LTSCCommentOrderVC.h
//  TAOSCHENG
//
//  Created by 李晓满 on 2020/4/16.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"
#import "LTSCCateModel.h"

@interface LTSCCommentOrderVC : BaseTableViewController

@property (nonatomic, strong) LTSCOrderObjectModel *orderModel;

@end


@interface LTSCCommentOrderImgCell : UICollectionViewCell

@property (nonatomic, strong) NSIndexPath *indexP;

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UIButton *deletButton;

@property (nonatomic, copy) void(^deleteImgBlock)(NSIndexPath *indexP);

@end


@interface LTSCCommentOrderCell : UITableViewCell

@property (nonatomic, strong) LTSCOrderDetailModel *model;

@end
