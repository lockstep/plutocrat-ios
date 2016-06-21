//
//  DateUtility.h
//  Plutocrat
//
//  Created by Kuntee Viriyothai on 3/8/16.
//  Copyright © 2016 Whitefly Ventures, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtility : NSObject

+ (NSDate *)dateFromString:(NSString *)dateString;
+ (NSUInteger)daysFromNow:(NSDate *)date;
+ (NSString *)timeUntilNow:(NSDate *)date;

@end
