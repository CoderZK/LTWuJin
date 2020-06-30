//
//  LTSCSearchManager.m
//  54school
//
//  Created by 宋乃银 on 2018/8/26.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LTSCSearchManager.h"

#define SearchDefalutKey @"SearchDefalutKey"

@interface LTSCSearchManager()
{
    NSMutableDictionary<NSString *, NSArray *> *_intenalDict;
}
@end

@implementation LTSCSearchManager

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    static LTSCSearchManager *__manager = nil;
    dispatch_once(&onceToken, ^{
        __manager = [[LTSCSearchManager alloc] init];
    });
    return __manager;
}

- (NSArray<NSString *> *)searchHistoryForKey:(NSString *)key {
    if (!key) {
        key = SearchDefalutKey;
    }
    return _intenalDict[key];
}

- (void)addSearchRecord:(NSString *)record forKey:(NSString *)key {
    if (!key) {
        key = SearchDefalutKey;
    }
    if (record) {
        NSArray *arr = _intenalDict[key];
        NSMutableArray *tempArr = [NSMutableArray array];
        if (arr.count > 0) {
            [tempArr addObjectsFromArray:arr];
        }
        if ([tempArr containsObject:record]) {
            [tempArr removeObject:record];
        }
        [tempArr insertObject:record atIndex:0];
        if (_maxCount > 0 && tempArr.count > _maxCount) {
            [tempArr removeObjectsInRange:NSMakeRange(_maxCount, tempArr.count - _maxCount)];
        }
        _intenalDict[key] = tempArr;
    }
    [self save];
}

- (void)removeSearchRecordAtIndex:(NSInteger)index forKey:(NSString *)key {
    if (!key) {
        key = SearchDefalutKey;
    }
    NSArray *arr = _intenalDict[key];
    NSMutableArray *tempArr = [NSMutableArray array];
    if (arr.count > 0) {
        [tempArr addObjectsFromArray:arr];
    }
    if (index < tempArr.count) {
        [tempArr removeObjectAtIndex:index];
    }
    _intenalDict[key] = tempArr;
    [self save];
}

- (void)removeAllSearchRecordForKey:(NSString *)key {
    if (!key) {
        key = SearchDefalutKey;
    }
    _intenalDict[key] = @[];
    [self save];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _maxCount = 10;
        _intenalDict = [NSMutableDictionary dictionary];
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"SearchIntenalDict"];
        if ([dict isKindOfClass:[NSDictionary class]]) {
            [_intenalDict setDictionary:dict];
        }
    }
    return self;
}

- (void)save {
    [[NSUserDefaults standardUserDefaults] setObject:_intenalDict forKey:@"SearchIntenalDict"];
}

@end
