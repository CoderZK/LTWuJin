//
//  LTSCCateListVC.h
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/20.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseViewController.h"
#import "LTSCCateModel.h"

@interface LTSCCateListVC : BaseViewController

@property (nonatomic, strong) NSString *titleStr;

@property (nonatomic, strong) NSString *keyWords;

@property (nonatomic, strong) NSString *shopId;

@property (nonatomic, assign) BOOL isSearch;//是否是搜索

@property (nonatomic, assign) BOOL isHome;//是否是搜索

@property (nonatomic, assign) BOOL isNOAll;//是否是搜索

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) LTSCCateModel *cateModel;

@property (nonatomic, strong) NSArray <LTSCCateModel *>*secondCateArr;

@end

@interface LTSCCateTopView : UIView

@property (nonatomic, copy) void(^buttonClickBlock)(NSInteger index, NSInteger count);

@end

@interface LTSCCateButton : UIButton

@property (nonatomic, strong) UILabel *textLabel;//文字

@property (nonatomic, strong) UIImageView *iconImgView;//图片

@end
