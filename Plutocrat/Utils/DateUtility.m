//
//  DateUtility.m
//  Plutocrat
//
//  Created by Kuntee Viriyothai on 3/8/16.
//  Copyright © 2016 Whitefly Ventures, Inc. All rights reserved.
//

#import "DateUtility.h"

@implementation DateUtility

+ (NSDate *)toLocalTime:(NSDate *)date
{
    NSTimeZone *tz = [NSTimeZone defaultTimeZone];
    NSInteger seconds = [tz secondsFromGMTForDate:date];
    return [NSDate dateWithTimeInterval: seconds sinceDate:date];
}

+ (NSDate *)dateFromString:(NSString *)dateString
{
    if (!dateString || [dateString isMemberOfClass:[NSNull class]]) return nil;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    return [self toLocalTime:[formatter dateFromString:dateString]];
}

+ (NSUInteger)daysFromNow:(NSDate *)date
{
    NSUInteger days = [[NSDate date] timeIntervalSinceDate:date] / 86400;
    return days;
}

+ (NSString *)timeUntilNow:(NSDate *)date
{
    long interval = fabs([date timeIntervalSinceNow]);
    long days = interval / 86400;
    interval %= 86400;
    long hours = interval / 3600;
    interval %= 3600;
    long minutes = interval / 60;
    long seconds = interval % 60;
    return [NSString stringWithFormat:@"%ld d %ld h %ld m %ld s", days, hours, minutes, seconds];
}

+ (NSString *)timeFromDate:(NSDate *)start toDate:(NSDate *)end
{
    long interval = [end timeIntervalSinceDate:start];
    long days = interval / 86400;
    interval %= 86400;
    long hours = interval / 3600;
    interval %= 3600;
    long minutes = interval / 60;
    long seconds = interval % 60;
    return [NSString stringWithFormat:@"%ld d %ld h %ld m %ld s", days, hours, minutes, seconds];
}

@end
