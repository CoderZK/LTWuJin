//
//  LTSCMineModel.m
//  salaryStatus
//
//  Created by 李晓满 on 2019/1/30.
//  Copyright © 2019年 李晓满. All rights reserved.
//

#import "LTSCMineModel.h"

@implementation LTSCMineModel

@end

@implementation LTSCUserInfoModel

MJCodingImplementation

@end

/**
 选择银行
 */
@implementation LTSCSelcetBankModel

@end

/**
 物流详情
 */
@implementation LTSCWuLiuInfoListModel

@synthesize cellH = _cellH;
@synthesize detailH = _detailH;

- (CGFloat)detailH {
    if (_detailH == 0) {
        CGFloat h = [self.context getSizeWithMaxSize:CGSizeMake(ScreenW - 75, 9999) withFontSize:14].height;
        _detailH = 15 + 20 + 10 + h + 15;
    }
    return _detailH;
}

- (CGFloat)cellH {
    if (_cellH == 0) {
        
        CGFloat h = [self.context getSizeWithMaxSize:CGSizeMake(ScreenW - 51, 9999) withFontSize:12].height;
        _cellH = 10 + h + 5 + 10 + 5;
        
    }
    return _cellH;
}

@end

@implementation LTSCWuLiuInfoStateModel

- (void)setList:(NSArray<LTSCWuLiuInfoListModel *> *)list {
    _list = [LTSCWuLiuInfoListModel mj_objectArrayWithKeyValuesArray:list];
}

@end


@implementation LTSCWuLiuInfoMapModel

@end


//已关注店铺
@implementation LTSCFollowShopModel

@end

@implementation LTSCFollowShopListModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"list" : @"LTSCFollowShopModel"
             };
}

@end

@implementation LTSCFollowShopRootModel 

@end


@implementation LTSCCommenttuPianModel 

@end
