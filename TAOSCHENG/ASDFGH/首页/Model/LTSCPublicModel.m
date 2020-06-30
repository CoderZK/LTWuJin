//
//  LTSCPublicModel.m
//  shenbian
//
//  Created by 李晓满 on 2018/10/31.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LTSCPublicModel.h"

@implementation LTSCHomeBannerModel

@end

@implementation LTSCChooseListModel

@end


@implementation LTSCPublicModel

@end


@implementation LTSCHomeQuestionModel
@synthesize titleAtt = _titleAtt;
@synthesize contentAtt = _contentAtt;
@synthesize cellheight = _cellheight;

- (NSMutableAttributedString *)titleAtt {
    if (!_titleAtt) {
        NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc] initWithString:self.title];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:2];
        [string1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.title.length)];
        _titleAtt = string1;
    }
    return _titleAtt;
}

- (NSMutableAttributedString *)contentAtt {
    if (!_contentAtt) {
        NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:self.content];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:2];
        [string2 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.content.length)];
        _contentAtt = string2;
    }
    return _contentAtt;
}

- (CGFloat)cellheight {
    if (_cellheight == 0) {
        CGFloat titleH = [NSString getString:self.title lineSpacing:2 font:[UIFont systemFontOfSize:15] width:(ScreenW - 69)];
        CGFloat contetH = [NSString getString:self.content lineSpacing:0 font:[UIFont systemFontOfSize:11] width:(ScreenW - 69)];
        _cellheight = 15 + titleH + 3 + contetH + 15;
        
    }
    return _cellheight;
}
@end


@implementation LTSCHomeMapModel : NSObject

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"qaList" : @"LTSCHomeQuestionModel",
             @"hotList" : @"LTSCChooseListModel",
             @"typeList" : @"LTSCPublicModel",
             @"banner" : @"LTSCHomeBannerModel",
             @"chooseList" : @"LTSCChooseListModel"
             };
}

@end

@implementation LTSCHomeModel

@end


@implementation LTSCHomeRootModel

@end


/**
 人气严选
 */
@implementation LTSCHomeReQiYanXuanModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"list" : @"LTSCChooseListModel"
             };
}

@end


@implementation LTSCHomeReQiYanXuanRootModel 

@end

/**
 常见问题自助专区
 */
@implementation LTSCHomeAQListModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"list" : @"LTSCHomeQuestionModel"
             };
}

@end

@implementation LTSCHomeAQListRootModel 

@end

//第三方外链-跳转直接登录
@implementation LTSCHomeThirdLoginModel

@end

@implementation LTSCHomeThirdLoginRootModel

@end

//优惠券列表

@implementation LTSCYouHuiQuanModel

@end

@implementation LTSCYouHuiQuanMapModel 

@end

@implementation LTSCYouHuiQuanListModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"list" : @"LTSCYouHuiQuanModel"
             };
}

@end

@implementation LTSCYouHuiQuanRootModel

@end
