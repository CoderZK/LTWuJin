//
//  LTSCDianPuYinXiangVC.h
//  TAOSCHENG
//
//  Created by 李晓满 on 2020/4/9.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

@interface LTSCDianPuYinXiangVC : BaseTableViewController

@property (nonatomic, strong) NSString *shopId;

@end

//店铺信息
@interface LTSCDianPuYinXiangInfoCell : UITableViewCell

@property (nonatomic, strong) LTSCShopModel *shopModel;

@property (nonatomic, copy) void(^attendClickBlock)(LTSCShopModel *shopModel);

@end

@interface LTSCDianPuYinXiangTitleCell : UITableViewCell

@property (nonatomic, strong) UILabel *leftLabel;//左侧label

@end

@interface LTSCDianPuYinXiangPingJiaCell : UITableViewCell

@property (nonatomic, strong) UILabel *leftLabel;//左侧label

@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, strong) UILabel *numLabel;

@property (nonatomic, strong) UILabel *infoLabel;

@end


@interface LTSCDianPuYinXiangBasicInfoCell : UITableViewCell

@property (nonatomic, strong) UILabel *leftLabel;//左侧label

@property (nonatomic, strong) UILabel *rightLabel;//右侧label

@end
