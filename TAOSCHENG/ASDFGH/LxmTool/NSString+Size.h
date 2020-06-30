//
//  NSString+Size.h
//  JawboneUP
//
//  Created by 李晓满 on 2017/10/17.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDate+ServerDate.h"

@interface NSString (Size)

- (NSString *)getPriceStr;

/**
 获得字符串的大小
 */
+ (CGFloat)getString:(NSString *)string lineSpacing:(CGFloat)lineSpacing font:(UIFont*)font width:(CGFloat)width;
/**
 获得字符串的大小
 */
-(CGSize)getSizeWithMaxSize:(CGSize)maxSize withFontSize:(int)fontSize;
/**
 获得字符串的大小 粗体
 */
- (CGSize)getSizeWithMaxSize:(CGSize)maxSize withBoldFontSize:(int)fontSize;
/* MD5字符串 */
+ (NSString *)stringToMD5:(NSString *)str;

+ (NSDate *)dataWithStr:(NSString *)str;
/****
 ios比较日期大小默认会比较到秒
 ****/
+ (int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay;


+ (NSString *)convertToJsonData:(id)dict;
+ (CGFloat)getHeightWith:(NSString *)str;

/**
 转化时间
 */
+ (NSString *)stringWithTime:(NSString *)str;

/**
 格式化时间
 */
+ (NSString *)formatterTime:(NSString *)str;

/**
 格式化时间
 */
+ (NSString *)formatterYouHuiQuanTime:(NSString *)str;

/**
 格式化时间
 */
+ (NSString *)formatterYouHuiQuanTime1:(NSString *)str;

/**
 获得日子
 */
+ (NSString *)getDay:(NSString *)str;

- (BOOL)isKong;

- (BOOL)isContrainsKong;

- (BOOL)isValid;


/**
 转化时间倒计时
 */
+(double)chaWithCreateTime:(NSString *)creatTime;

+ (NSString *)durationTimeStringWithDuration:(NSInteger)time;

//判断手机号是移动 联通 还是电信
+ (NSString *)pushSignIn:(NSString *)str;


//YYYY-MM-dd
- (NSString *)getIntervalToZHXTime;

@end
