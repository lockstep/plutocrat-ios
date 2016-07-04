//
//  UserManager.m
//  Plutocrat
//
//  Created by Kuntee Viriyothai on 3/7/16.
//  Copyright © 2016 Whitefly Ventures, Inc. All rights reserved.
//

#import "UserManager.h"

#define USER_KEY @"user"
#define HEADER_KEY @"header"
#define LAST_LOGIN_KEY @"last_login"

@implementation UserManager

+ (void)storeUser:(NSDictionary *)userDict headers:(NSDictionary *)headerDict { 
    /*
     user =     {
     "attacking_current_user" = 0;
     "display_name" = test;
     id = 1;
     "is_plutocrat" = 0;
     "matched_buyouts_count" = 0;
     "profile_image_url" = "/profile_images/original/missing.png";
     "registered_at" = "2016-03-07T14:43:18Z";
     "successful_buyouts_count" = 0;
     "under_buyout_threat" = 0;
     };
     
     { user: { id: 2, display_name: "A User", email: "test@example.com", transactional_emails_enabled: true, product_emails_enabled: false, available_shares_count: 12, buyouts_until_plutocrat_count: 22, successful_buyouts_count: 2, failed_buyouts_count: 4, matched_buyouts_count: 4, registered_at: "2015-10-25T23:48:46Z", defeated_at: null, profile_image_url: "https://img.png", is_plutocrat: false, active_inbound_buyout: { BUYOUT_JSON }, defeating_buyout: { BUYOUT_JSON } } }
     
     "access-token": "xxxxxx", 
     "token-type":  "Bearer", 
     "client": "xxxxxx", 
     "expiry": "xxxxx", 
     "uid": "xxxxxx"
     
     "Access-Token" = "yT6SCLIPNFO_9dV13lKCiw";
     "Cache-Control" = "max-age=0, private, must-revalidate";
     Client = "Gwf1D59wO4ciku_oCXGbWA";
     Connection = "keep-alive";
     "Content-Type" = "application/json; charset=utf-8";
     Date = "Tue, 08 Mar 2016 02:49:45 GMT";
     Etag = "W/\"daf1b2b8f61cd33da4965bff1288fba3\"";
     Expiry = 1458614985;
     Server = Cowboy;
     "Token-Type" = Bearer;
     "Transfer-Encoding" = Identity;
     Uid = "test@test.com";
     Via = "1.1 vegur";
     "X-Content-Type-Options" = nosniff;
     "X-Frame-Options" = SAMEORIGIN;
     "X-Request-Id" = "651c7c4c-7325-44e1-a07b-eb099547569e";
     "X-Runtime" = "0.463555";
     "X-Xss-Protection" = "1; mode=block";
     */
    
    [[NSUserDefaults standardUserDefaults] setObject:userDict forKey:USER_KEY];
    [[NSUserDefaults standardUserDefaults] setObject:headerDict forKey:HEADER_KEY];
    [[NSUserDefaults standardUserDefaults] setObject:userDict[@"id"] forKey:LAST_LOGIN_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)removeUser {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_KEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:HEADER_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isLogin {
    return [[NSUserDefaults standardUserDefaults] objectForKey:USER_KEY] != nil;
}

+ (BOOL)isDefeated
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:USER_KEY][@"terminal_buyout"] != nil;
}

+ (BOOL)hasLastLogin {
    return [[NSUserDefaults standardUserDefaults] objectForKey:LAST_LOGIN_KEY] != nil;
}

+ (int)lastLogin {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:LAST_LOGIN_KEY] intValue];
}

+ (NSUInteger)currentUserId {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:USER_KEY][@"id"] unsignedIntegerValue];
}

+ (NSString *)displayName {
    return [[NSUserDefaults standardUserDefaults] objectForKey:USER_KEY][@"display_name"];
}

+ (NSUInteger)successfulBuyouts {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:USER_KEY][@"successful_buyouts_count"] unsignedIntegerValue];
}

+ (NSUInteger)availableShares
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:USER_KEY][@"available_shares_count"] unsignedIntegerValue];
}

+ (int)failedBuyouts {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:USER_KEY][@"matched_buyouts_count"] intValue];
}

+ (int)defeatedBuyouts {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:USER_KEY][@"matched_buyouts_count"] intValue];
}

+ (NSString *)getHeader:(NSString *)key {
    NSDictionary *headers = [[NSUserDefaults standardUserDefaults] objectForKey:HEADER_KEY];
    return headers[key];
}

+ (NSDictionary *)userDict
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:USER_KEY];
}

@end
