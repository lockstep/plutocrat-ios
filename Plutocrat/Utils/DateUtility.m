//
//  DateUtility.m
//  Plutocrat
//
//  Created by Kuntee Viriyothai on 3/8/16.
//  Copyright © 2016 Whitefly Ventures, Inc. All rights reserved.
//

#import "DateUtility.h"

@implementation DateUtility

+ (NSDate *)dateFromString:(NSString *)dateString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    return [formatter dateFromString:dateString];
}

+ (int)daysFromNow:(NSDate *)date {
    int days = [date timeIntervalSinceNow] / 86400;
    return abs(days);
}

+ (NSString *)timeUntilNow:(NSDate *)date {
    long interval = fabs([date timeIntervalSinceNow]);
    long days = interval / 86400;
    interval %= 86400;
    long hours = interval / 3600;
    interval %= 3600;
    long minutes = interval / 60;
    long seconds = interval % 60;
    return [NSString stringWithFormat:@"%ld d %ld h %ld m %ld s", days, hours, minutes, seconds];
}

@end
