//
//  LTSCCateModel.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/23.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LTSCCateModel.h"

@implementation LTSCCateModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"goodList" : @"LTSCCateModel"
             };
}

@end

@implementation LTSCCateListModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"list" : @"LTSCCateModel"
             };
}

@end

@implementation LTSCCateRootModel


@end


//商品详情

@implementation LTSCGoodsDetailAdressModel
@synthesize cellHeight = _cellHeight;
@synthesize cellHeight1 = _cellHeight1;

- (CGFloat)cellHeight {
    if (_cellHeight == 0) {
        NSString *str = [NSString stringWithFormat:@"%@%@%@%@",self.province, self.city, self.district, self.addressDetail];
        CGFloat h = [str getSizeWithMaxSize:CGSizeMake(ScreenW - 120, 9999) withFontSize:15].height;
        CGFloat h1 = [@"18:00前完成支付,预计(后天)04月24日送达" getSizeWithMaxSize:CGSizeMake(ScreenW - 120, 9999) withFontSize:13].height;
        _cellHeight = 15 + h + 10 + h1 + 15;
    }
    return _cellHeight;
}

- (CGFloat)cellHeight1 {
    if (_cellHeight1 == 0) {
        NSString *str = [NSString stringWithFormat:@"%@%@%@%@",self.province, self.city, self.district, self.addressDetail];
        CGFloat h = [str getSizeWithMaxSize:CGSizeMake(ScreenW - 65, 9999) withFontSize:14].height;
        _cellHeight1 = 70 + h;
    }
    return _cellHeight1;
}


@end

@implementation LTSCGoodsDetailGuiGeModel

- (NSMutableArray<NSString *> *)propsArr {
    if (!_propsArr) {
        _propsArr = [NSMutableArray array];
    }
    return _propsArr;
}

@end

@implementation LTSCGoodsDetailSUKModel 
@synthesize titleAtt = _titleAtt;
@synthesize contentAtt = _contentAtt;
@synthesize contentHeight = _contentHeight;
@synthesize cellheight = _cellheight;

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"goodId":@[@"goodId", @"good_id"]};
}

- (NSMutableAttributedString *)titleAtt {
    if (!_titleAtt) {
        NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc] initWithString:self.good_name];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:0];
        [paragraphStyle setLineBreakMode:(NSLineBreakByCharWrapping)];
        [string1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.good_name.length)];
        _titleAtt = string1;
    }
    return _titleAtt;
}

- (NSMutableAttributedString *)contentAtt {
    if (!_contentAtt) {
        NSArray *propertiesArr = [self.properties mj_JSONObject];
        propertiesArr = [propertiesArr sortedArrayUsingComparator:^NSComparisonResult(NSDictionary * obj1, NSDictionary * obj2) {
            return [obj1[@"id"] integerValue] > [obj2[@"id"] integerValue];
        }];
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *tempDict in propertiesArr) {
            [arr addObject:[NSString stringWithFormat:@"%@",tempDict[@"value"]]];
        }
        NSString *str = [NSString stringWithFormat:@"已选: %@",[arr componentsJoinedByString:@";"]];
        NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:str];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:0];
        [paragraphStyle setLineBreakMode:(NSLineBreakByCharWrapping)];
        [string2 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, str.length)];
        _contentAtt = string2;
    }
    return _contentAtt;
}


- (CGFloat)contentHeight {
    if (_contentHeight == 0) {
        NSArray *propertiesArr = [self.properties mj_JSONObject];
        propertiesArr = [propertiesArr sortedArrayUsingComparator:^NSComparisonResult(NSDictionary * obj1, NSDictionary * obj2) {
            return [obj1[@"id"] integerValue] > [obj2[@"id"] integerValue];
        }];
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *tempDict in propertiesArr) {
            [arr addObject:[NSString stringWithFormat:@"%@",tempDict[@"value"]]];
        }
        NSString *str = [NSString stringWithFormat:@"已选: %@",[arr componentsJoinedByString:@";"]];
        CGFloat contetH = [NSString getString:str lineSpacing:0 font:[UIFont systemFontOfSize:11] width:(ScreenW - 160 - 15 - 37)];
        _contentHeight = 5 + contetH + 5;
    }
    return _contentHeight;
}

- (CGFloat)cellheight {
    if (_cellheight == 0) {
        NSArray *propertiesArr = [self.properties mj_JSONObject];
        propertiesArr = [propertiesArr sortedArrayUsingComparator:^NSComparisonResult(NSDictionary * obj1, NSDictionary * obj2) {
            return [obj1[@"id"] integerValue] > [obj2[@"id"] integerValue];
        }];
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *tempDict in propertiesArr) {
            [arr addObject:[NSString stringWithFormat:@"%@",tempDict[@"value"]]];
        }
        
        NSString *str = [NSString stringWithFormat:@"已选: %@",[arr componentsJoinedByString:@";"]];
        CGFloat titleH = [NSString getString:self.good_name lineSpacing:2 font:[UIFont systemFontOfSize:15] width:(ScreenW - 160)];
        CGFloat contetH = [NSString getString:str lineSpacing:0 font:[UIFont systemFontOfSize:11] width:(ScreenW - 160 - 15 - 37)];
        if (self.sku_id) {
            _cellheight = 15 + titleH + 10 +  5 + contetH + 5 + 25 + 30 + 15;
        }else {
            _cellheight = 15 + titleH + 10 +  0 + 25 + 30 + 15;
        }
    }
    return _cellheight < 120 ? 120 : _cellheight;
}


@end


@implementation LTSCGoodsDetailModel
@synthesize cellHeight = _cellHeight;

- (CGFloat)cellHeight {
    if (_cellHeight == 0) {
        CGFloat h = [self.goodName getSizeWithMaxSize:CGSizeMake(ScreenW - 30, 9999) withFontSize:15].height;
        return 25 + 20 + 15 + h + 25;
    }
    return _cellHeight;
}

@end


@implementation LTSCGoodsDetailEvalModel 
@synthesize cellHeight = _cellHeight;

@synthesize cellHeight1 = _cellHeight1;

- (CGFloat)cellHeight {
    if (_cellHeight == 0) {
        CGFloat contentH = [self.remark getSizeWithMaxSize:CGSizeMake(ScreenW - 30, 9999) withFontSize:13].height;
        
        _cellHeight = 40 + contentH + 18 + (self.list_pic.isValid ? floor((ScreenW - 50)/3.0) + 18 : 0) ;
    }
    return _cellHeight;
}

- (CGFloat)cellHeight1 {
    if (_cellHeight1 == 0) {
        CGFloat contentH = [self.remark getSizeWithMaxSize:CGSizeMake(ScreenW - 30, 9999) withFontSize:13].height;
        NSArray *imgs = [NSArray array];
        if (self.list_pic.isValid) {
            imgs = [self.list_pic componentsSeparatedByString:@","];
        }
        _cellHeight1 = 55 + contentH + 18 + (self.list_pic.isValid ? (floor((ScreenW - 50)/3.0) + 10) * ceil(imgs.count/3.0) + 18 : 0) ;
    }
    return _cellHeight1;
}


@end



@implementation LTSCGoodsDetailMapModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"guideList" : @"LTSCGoodsDetailGuiGeModel",
             @"skuList" : @"LTSCGoodsDetailSUKModel"
             };
}

@end

@implementation LTSCGoodsDetailResultModel

@end

@implementation LTSCGoodsDetailRootModel 

@end


//购物车列表

@implementation LTSCShopCarDianPuModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"goodList" : @"LTSCGoodsDetailSUKModel"
             };
}


@end


@implementation LTSCShopCarModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"list" : @"LTSCShopCarDianPuModel"
             };
}

@end


@implementation LTSCShopCarRootModel

@end


/**
 图片
 */
@implementation LTSCGoodsDetailTuPianModel

@end



/**
 我的订单列表
 */
@implementation LTSCOrderDetailModel
@synthesize yixuanAttStr = _yixuanAttStr;

- (NSMutableAttributedString *)yixuanAttStr {
    if (!_yixuanAttStr) {
        NSArray *propertiesArr = [self.properties mj_JSONObject];
        propertiesArr = [propertiesArr sortedArrayUsingComparator:^NSComparisonResult(NSDictionary * obj1, NSDictionary * obj2) {
            return [obj1[@"id"] integerValue] > [obj2[@"id"] integerValue];
        }];
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *tempDict in propertiesArr) {
            [arr addObject:[NSString stringWithFormat:@"%@",tempDict[@"value"]]];
        }
        NSString *str = [NSString stringWithFormat:@"已选: %@",[arr componentsJoinedByString:@";"]];
        NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:str];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:0];
        [paragraphStyle setLineBreakMode:(NSLineBreakByCharWrapping)];
        [string2 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, str.length)];
        _yixuanAttStr = string2;
    }
    return _yixuanAttStr;
}

@end

@implementation LTSCOrderObjectModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"goods" : @"LTSCOrderDetailModel"
             };
}

@end

@implementation LTSCOrderModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"list" : @"LTSCOrderObjectModel"
             };
}

@end

@implementation LTSCOrderRootModel

@end


//订单详情

@implementation LTSCOrderListDetailModel

@synthesize cellHeight = _cellHeight;
@synthesize cellHeight1 = _cellHeight1;

- (CGFloat)cellHeight {
    if (_cellHeight == 0) {
        NSString *str = [NSString stringWithFormat:@"%@%@%@%@",self.province, self.city, self.district, self.address_detail1];
        CGFloat h = [str getSizeWithMaxSize:CGSizeMake(ScreenW - 120, 9999) withFontSize:15].height;
        CGFloat h1 = [@"18:00前完成支付,预计(后天)04月24日送达" getSizeWithMaxSize:CGSizeMake(ScreenW - 120, 9999) withFontSize:13].height;
        _cellHeight = 15 + h + 10 + h1 + 15;
    }
    return _cellHeight;
}

- (CGFloat)cellHeight1 {
    if (_cellHeight1 == 0) {
        NSString *str = [NSString stringWithFormat:@"%@%@%@%@",self.province, self.city, self.district, self.address_detail1];
        CGFloat h = [str getSizeWithMaxSize:CGSizeMake(ScreenW - 65, 9999) withFontSize:14].height;
        _cellHeight1 = 70 + h;
    }
    return _cellHeight1;
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"subOrders" : @"LTSCOrderDetailModel"
             };
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"address_detail1":@"address_detail"};
}

@end

/**
 退款原因
 */
@implementation LTSCTuiKuanReasonModel

@end

@implementation LTSCTuiKuanReasonListModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"list" : @"LTSCTuiKuanReasonModel"
             };
}

@end

@implementation LTSCTuiKuanReasonRootModel

@end


//评价列表

@implementation LTSCPingJiaMapModel 

@end

@implementation LTSCPingJiaListModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"list" : @"LTSCGoodsDetailEvalModel"
             };
}

@end

@implementation LTSCPingJiaRootModel

@end
