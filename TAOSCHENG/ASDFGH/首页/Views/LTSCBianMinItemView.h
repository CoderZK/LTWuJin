//
//  LTSCHomeItemView.h
//  mag
//
//  Created by 李晓满 on 2018/7/3.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTSCPublicModel.h"

@interface LTSCBianMinItemView : UIView
- (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic , strong)NSArray <LTSCPublicModel *>*dataArr;

@property (nonatomic, copy) void(^didselectItem)(LTSCPublicModel *model);

@end

@interface LTSCBianMinItemCell: UICollectionViewCell

@property (nonatomic , strong)UIImageView * imgView;
@property (nonatomic , strong)UILabel * titleLab;

@end
