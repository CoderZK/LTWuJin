//
//  LTSCMyOrderDetailWuLiuCell.h
//  TAOSCHENG
//
//  Created by kunzhang on 2020/5/30.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LTSCMyOrderDetailWuLiuCell : UITableViewCell
@property (nonatomic, strong) UIImageView *iconImgView;//图标

@property (nonatomic, strong) UILabel *stateLabel;//待发货 已发货 已完成

@property (nonatomic, strong) UILabel *detailLabel;//物流信息

@property (nonatomic, strong) UILabel *timeLabel;//时间

@property (nonatomic, strong) UIImageView *accImgView;//箭头

@property (nonatomic, strong) LTSCWuLiuInfoStateModel *model;



@end

NS_ASSUME_NONNULL_END
