//
//  LTSCAddressModel.h
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/22.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LTSCAddressModel : NSObject

@end




@interface LTSCAddressListModel : NSObject

@property (nonatomic, strong) NSString *id;//地址id

@property (nonatomic, strong) NSString *username;//联系人姓名

@property (nonatomic, strong) NSString *telephone;//联系人手机号

@property (nonatomic, strong) NSString *province;//省

@property (nonatomic, strong) NSString *city;//市

@property (nonatomic, strong) NSString *district;//区

@property (nonatomic, strong) NSString *addressDetail;//详细地址

@property (nonatomic, strong) NSString *defaultStatus;//1：不是默认，2：是默认

@property (nonatomic, assign) CGFloat cellHeight;//高度

@end


@interface LTSCAddressListRootModel : NSObject

@property (nonatomic, strong) NSNumber *count;//

@property (nonatomic, strong) NSArray <LTSCAddressListModel *> *list;

@end

@interface LTSCAddressListRootModel1 : NSObject

@property (nonatomic, strong) NSNumber *key;//key

@property (nonatomic, strong) NSString *message;//

@property (nonatomic, strong) LTSCAddressListRootModel *result;

@end
