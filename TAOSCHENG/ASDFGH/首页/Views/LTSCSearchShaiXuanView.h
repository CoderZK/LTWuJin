//
//  LTSCSearchShaiXuanView.h
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/22.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTSCSearchShaiXuanView : UIView

- (void)show;

- (void)dismiss;

@end

@interface LTSCSearchShaiXuanHeaderView : UITableViewHeaderFooterView

@property (nonatomic, assign) NSInteger section;

@end

@interface LTSCSearchShaiXuanPriceCell : UITableViewCell

@end

@interface LTSCSearchShaiXuanCollectionCell : UITableViewCell

@end

@interface LTSCSearchCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UIButton *bgButton;

@end


@interface LTSCShaiXuanBottomView : UIView

@property (nonatomic, strong) UIButton *resetButton;//重置

@property (nonatomic, strong) UIButton *sureButton;//确定

@end
