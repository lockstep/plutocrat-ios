//
//  UserManager.h
//  Plutocrat
//
//  Created by Kuntee Viriyothai on 3/7/16.
//  Copyright © 2016 Whitefly Ventures, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserManager : NSObject

+ (void)storeUser:(NSDictionary *)userDict headers:(NSDictionary *)headerDict;
+ (void)removeUser;
+ (BOOL)isLogin;
+ (int)currentUserId;
+ (NSString *)getHeader:(NSString *)key;
+ (BOOL)hasLastLogin;
+ (int)lastLogin;
+ (NSDictionary *)userDict;
+ (NSUInteger)successfulBuyouts;

@end
