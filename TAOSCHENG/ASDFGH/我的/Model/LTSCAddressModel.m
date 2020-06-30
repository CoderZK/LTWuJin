//
//  LTSCAddressModel.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/22.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LTSCAddressModel.h"

@implementation LTSCAddressModel

@end


@implementation LTSCAddressListModel
@synthesize cellHeight = _cellHeight;
- (CGFloat)cellHeight {
    if (_cellHeight == 0) {
        NSString *str = [NSString stringWithFormat:@"%@%@%@%@", self.province,self.city,self.district,self.addressDetail];
        CGFloat h = [str getSizeWithMaxSize:CGSizeMake(ScreenW - 180, 9999) withFontSize:14].height;
        _cellHeight = 15 + 30 + 15 + h + 15;
    }
    return _cellHeight;
}


@end


@implementation LTSCAddressListRootModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"list" : @"LTSCAddressListModel"
             };
}

@end

@implementation LTSCAddressListRootModel1

@end
