//
//  LTSCShopModel.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2020/4/9.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "LTSCShopModel.h"

//店铺详情
@implementation LTSCShopSalesModel

@end

@implementation LTSCShopMapModel1

@end


@implementation LTSCShopModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
            @"sales" : @"LTSCShopSalesModel",
            @"hotGood" : @"LTSCShopSalesModel"
             };
}

@end

@implementation LTSCShopMapModel

@end

@implementation LTSCShopRootModel

@end

//猜你喜欢 逛逛更多

@implementation LTSCShopGoodsListModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
            @"list" : @"LTSCChooseListModel"
             };
}

@end

@implementation LTSCShopGoodsRootModel

@end

//店铺分类
@implementation LTSCDianPuCataModel

@end

@implementation LTSCDianPuFirstCataModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
            @"secondType" : @"LTSCDianPuCataModel"
             };
}

@end

@implementation LTSCDianPuCataListModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
            @"list" : @"LTSCDianPuFirstCataModel"
             };
}

@end


@implementation LTSCDianPuCataRootModel

@end
