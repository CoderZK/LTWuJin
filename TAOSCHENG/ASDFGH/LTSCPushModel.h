//
//  LTSCPushModel.h
//  huishou
//
//  Created by kunzhang on 2020/5/26.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LTSCPushModel : NSObject
@property (nonatomic, strong) NSString *d;/** 友盟id */

@property (nonatomic, strong) NSString *p;/** 0 */

@property (nonatomic, strong) NSString *infoType;/** 1-系统通知，2-代理变动，3-钱包消息，4-接单消息，5-订单消息，6-投诉消息，7-素材消息 */

@property (nonatomic, strong) NSString *infoUrl;/** 系统通知跳转的url */

@property (nonatomic, strong) NSString *secondType;/**  */

@property (nonatomic, strong) NSString *infoId;/** 跳转到的id */
@end

NS_ASSUME_NONNULL_END
