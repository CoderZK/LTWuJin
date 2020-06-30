//
//  LTSCGoodsDeatilTopView.h
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/17.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTSCGoodsDeatilTopView : UIView

@end

@interface LTSCGoodsDeatilNavView: UIView

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, copy) void(^navButtonSelectIndex)(NSInteger index);
@property (nonatomic, strong) UIButton *shareButton;

@end
