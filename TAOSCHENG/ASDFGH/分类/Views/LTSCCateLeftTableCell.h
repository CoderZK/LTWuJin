//
//  LTSCCateLeftTableCell.h
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/16.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTSCCateModel.h"
#import "LTSCShopModel.h"

@interface LTSCCateLeftTableCell : UITableViewCell

@property (nonatomic, strong) UIView *yellowLineView;//黄线条

@property (nonatomic, strong) UILabel *titleLabel;//标题

@end

@interface LTSCCateRightCollectionCell : UICollectionViewCell

@property (nonatomic, strong) LTSCCateModel *model;

@property (nonatomic, strong) LTSCDianPuCataModel *dianpuModel;

@end

