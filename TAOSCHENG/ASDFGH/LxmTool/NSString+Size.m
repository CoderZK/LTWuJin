//
//  NSString+Size.m
//  JawboneUP
//
//  Created by 李晓满 on 2017/10/17.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "NSString+Size.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Size)



/**
 获得属性字符串的大小
 */
+ (CGFloat)getString:(NSString *)string lineSpacing:(CGFloat)lineSpacing font:(UIFont*)font width:(CGFloat)width {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = lineSpacing;
    NSDictionary *dic = @{ NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle };
    CGSize size = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return  ceilf(size.height);
}


-(CGSize)getSizeWithMaxSize:(CGSize)maxSize withFontSize:(int)fontSize
{
    CGSize size=[self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]} context:nil].size;
    return size;
}

-(CGSize)getSizeWithMaxSize:(CGSize)maxSize withBoldFontSize:(int)fontSize
{
    CGSize size=[self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:fontSize]} context:nil].size;
    return size;
}

/* MD5字符串 */
+ (NSString *)stringToMD5:(NSString *)str
{
    const char *fooData = [str UTF8String];//UTF-8编码字符串
    unsigned char result[CC_MD5_DIGEST_LENGTH];//字符串数组，接收MD5
    CC_MD5(fooData, (CC_LONG)strlen(fooData), result);//计算并存入数组
    NSMutableString *saveResult = [NSMutableString string];//字符串保存加密结果
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [saveResult appendFormat:@"%02x", result[i]];
    }
    return saveResult;
}

+ (NSDate *)getCurrentTime{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateTime=[formatter stringFromDate:[NSDate date]];
    NSDate *date = [formatter dateFromString:dateTime];
    
    NSLog(@"---------- currentDate == %@",date);
    return date;
}

+(NSDate *)dataWithStr:(NSString *)str
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return  [formatter dateFromString:str];
}
/****
 ios比较日期大小默认会比较到秒
 ****/
+(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    NSLog(@"date1 : %@, date2 : %@", oneDay, anotherDay);
    if (result == NSOrderedDescending) {
        //NSLog(@"Date1  is in the future");
        return 1;
    }
    else if (result ==NSOrderedAscending){
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //NSLog(@"Both dates are the same");
    return 0;
    
}


+(NSString *)convertToJsonData:(id )dict

{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return [NSMutableString stringWithString:jsonString];
}
+ (CGFloat)getHeightWith:(NSString *)str{
    
    NSArray * arr = [str componentsSeparatedByString:@","];
    NSString * str1 = arr.lastObject;
    NSArray * arr1 = [str1 componentsSeparatedByString:@"*"];
    NSString * w = arr1.firstObject;
    NSString * h = arr1.lastObject;
    return (CGFloat)((w.intValue*h.intValue)/ScreenW);
    
}

/**
 转化时间
 */

+(NSString *)stringWithTime:(NSString *)str
{
    NSTimeInterval beTime = 0;
    if (str.length > 10) {
        //以毫秒为单位 就除以1000 默认以秒为单位
        NSDateFormatter *df0 = [[NSDateFormatter alloc] init];
        if([str containsString:@"."]){
            [df0 setDateFormat:@"yyyy.MM.dd HH:mm:ss"];
        }else if([str containsString:@"-"]){
            [df0 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
        }else if([str containsString:@"/"]){
            [df0 setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
            
        }
        
        NSDate *date0 = [df0 dateFromString:str];
        beTime = [date0 timeIntervalSince1970];
        
    }else {
        
        beTime = [str longLongValue];
    }
    
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    double distanceTime = now - beTime;
    NSString * distanceStr;
    
    NSDate * beDate = [NSDate dateWithTimeIntervalSince1970:beTime];
    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"HH:mm"];
    NSString * timeStr = [df stringFromDate:beDate];
    
    [df setDateFormat:@"yyyy"];
    NSString * nowYear = [df stringFromDate:[NSDate date]];
    NSString * lastYear = [df stringFromDate:beDate];
    
    [df setDateFormat:@"dd"];
    NSString * nowDay = [df stringFromDate:[NSDate date]];
    NSString * lastDay = [df stringFromDate:beDate];
    
    if (distanceTime < 60)
    {   //小于一分钟
        distanceStr = @"刚刚";
    }
    else if (distanceTime < 60*60)
    {   //时间小于一个小时
        distanceStr = [NSString stringWithFormat:@"%ld分钟前",(long)distanceTime/60];
    }
    else if(distanceTime < 24*60*60 && [nowDay integerValue] == [lastDay integerValue])
    {  //时间小于一天
        distanceStr = [NSString stringWithFormat:@"今天 %@",timeStr];
    }
    else if(distanceTime< 24*60*60*2 && [nowDay integerValue] != [lastDay integerValue])
    {
        if ([nowDay integerValue] - [lastDay integerValue] == 1 || ([lastDay integerValue] - [nowDay integerValue] > 10 && [nowDay integerValue] == 1))
        {
            distanceStr = [NSString stringWithFormat:@"昨天 %@",timeStr];
        }
        else
        {
            [df setDateFormat:@"HH:mm"];
            distanceStr = [NSString stringWithFormat:@"前天 %@",[df stringFromDate:beDate]];
        }
        
    }
    else if(distanceTime < 24*60*60*365)
    {
        if ([nowDay integerValue] - [lastDay integerValue] == 2 || ([lastDay integerValue] - [nowDay integerValue] > 10 && [nowDay integerValue] == 1))
        {//包含前天的部分
            [df setDateFormat:@"HH:mm"];
            distanceStr = [NSString stringWithFormat:@"前天 %@",[df stringFromDate:beDate]];
        }
        else
        {
            if ([nowYear integerValue] == [lastYear integerValue])
            {//包含今年的部分
                [df setDateFormat:@"MM-dd HH:mm"];
                distanceStr = [df stringFromDate:beDate];
            }
            else
            {
                [df setDateFormat:@"yyyy-MM-dd HH:mm"];
                distanceStr = [df stringFromDate:beDate];
            }
        }
    }
    else
    {
        [df setDateFormat:@"yyyy-MM-dd HH:mm"];
        distanceStr = [df stringFromDate:beDate];
    }
    return distanceStr;
}

/**
 格式化时间
 */
+ (NSString *)formatterTime:(NSString *)str {
//    2019-04-16 09:42:25
    NSArray *arr = [str componentsSeparatedByString:@" "];
    if (arr.count == 2) {
        NSString *str = arr.firstObject;
        str = [str stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
        return str;
    }
    return str;
}
/**
 格式化时间
 */
+ (NSString *)formatterYouHuiQuanTime:(NSString *)str {
    NSArray *arr = [str componentsSeparatedByString:@"-"];
    if (arr.count == 3) {
        NSString *str = [NSString stringWithFormat:@"%@.%@",arr[1], arr[2]];
        return str;
    }
    return str;
}

/**
 格式化时间
 */
+ (NSString *)formatterYouHuiQuanTime1:(NSString *)str {
    NSArray *arr = [str componentsSeparatedByString:@"-"];
    if (arr.count == 3) {
        NSString *str = [NSString stringWithFormat:@"%@.%@.%@", arr[0], arr[1], arr[2]];
        return str;
    }
    return str;
}

/**
 获得日子
 */
+ (NSString *)getDay:(NSString *)str {
    NSArray *arr = [str componentsSeparatedByString:@" "];
    if (arr.count == 2 || arr.count == 1) {
        NSString *str = arr.firstObject;
        NSArray *arr1 = [str componentsSeparatedByString:@"-"];
        return arr1.lastObject;
    }
    return str;
}

- (BOOL)isKong {
    if (self.length == 0 || [self isEqualToString:@""] || [[self stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
        return YES;
    }
    return NO;
}


- (BOOL)isValid {
    if (self.length > 0 && ![[self stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

- (BOOL)isContrainsKong {
    if ([self containsString:@" "]) {
        return YES;
    }
    return NO;
}

/**
 转化时间倒计时
 */
+(double)chaWithCreateTime:(NSString *)creatTime {
    NSTimeInterval beTime = 0;
    if (creatTime.length > 10) {
        //以毫秒为单位 就除以1000 默认以秒为单位
        NSDateFormatter *df0 = [[NSDateFormatter alloc] init];
        [df0 setTimeZone:[NSTimeZone localTimeZone]];
        if([creatTime containsString:@"."]){
            [df0 setDateFormat:@"yyyy.MM.dd HH:mm:ss"];
        }else if([creatTime containsString:@"-"]){
            [df0 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
        }else if([creatTime containsString:@"/"]){
            [df0 setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
            
        }
        NSDate *date0 = [df0 dateFromString:creatTime];
        date0 = [date0 dateByAddingTimeInterval:1800];
        beTime = [date0 timeIntervalSince1970];
    } else {
        beTime = [creatTime longLongValue];
        beTime = beTime + 1800;
    }
    NSTimeInterval now = [[NSDate serverDate] timeIntervalSince1970];
    double distanceTime = beTime - now;
    return distanceTime;
}

+ (NSString *)durationTimeStringWithDuration:(NSInteger)time {
    NSString *h = [NSString stringWithFormat:@"%02ld", time / 3600];
    NSString *m = [NSString stringWithFormat:@"%02ld", (time % 3600) / 60];
    NSString *s = [NSString stringWithFormat:@"%02ld", time % 60];
    NSString * timeStr = [NSString stringWithFormat:@"%@:%@:%@", h, m, s];
    return timeStr;
}

+ (NSString *)pushSignIn:(NSString *)str {
    
    
    return @"";
    
    /**
     * 移动号段正则表达式
     */
    NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
    /**
     * 联通号段正则表达式
     */
    NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
    /**
     * 电信号段正则表达式
     */
    NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
    BOOL isMatch1 = [pred1 evaluateWithObject:str];
    NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
    BOOL isMatch2 = [pred2 evaluateWithObject:str];
    NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
    BOOL isMatch3 = [pred3 evaluateWithObject:str];
    if (isMatch1) {
        return @"中国移动";
    } else if (isMatch2) {
        return @"中国联通";
    } else if (isMatch3) {
        return @"中国电信";
    } else {
        return nil;
    }
}

//YYYY-MM-dd
- (NSString *)getIntervalToZHXTime {
    //将对象类型的时间转换为NSDate类型
    NSDate * myDate = [NSDate dateWithTimeIntervalSince1970:self.doubleValue/1000];
    //设置时间格式
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM-dd"];
    //将时间转换为字符串
    NSString *timeStr = [formatter stringFromDate:myDate];
    return timeStr;
}

- (NSString *)getPriceStr {
    
    NSString * str =  [NSString stringWithFormat:@"%.2f",self.floatValue];;
    
    
    if ([[str substringFromIndex:str.length-2] isEqualToString:@"00"]){
        return [str substringToIndex:str.length-3];
    }
    
    if ([[str substringFromIndex:str.length - 1] isEqualToString:@"0"]) {
        str = [str substringToIndex:str.length-1];
    }

    
    return str;
    
    
    
}



@end
