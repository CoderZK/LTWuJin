//
//  LTSCSearchManager.h
//  54school
//
//  Created by 宋乃银 on 2018/8/26.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTSCSearchManager : NSObject

+ (instancetype)shared;

/**
 最大记录数 默认5
 */
@property (nonatomic, assign) NSInteger maxCount;

- (NSArray<NSString *> *)searchHistoryForKey:(NSString *)key;

- (void)addSearchRecord:(NSString *)record forKey:(NSString *)key;

- (void)removeSearchRecordAtIndex:(NSInteger)index forKey:(NSString *)key;

- (void)removeAllSearchRecordForKey:(NSString *)key;

@end
