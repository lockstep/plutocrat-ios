//
//  User.m
//  Plutocrat
//
//  Created by Kuntee Viriyothai on 3/8/16.
//  Copyright © 2016 Whitefly Ventures, Inc. All rights reserved.
//

#import "User.h"
#import "DateUtility.h"

@implementation User

+ (User *)userFromDict:(NSDictionary *)userDict {
    User *user = [User new];
    user.identifier = [userDict[@"id"] intValue];
    user.displayName = userDict[@"display_name"];
    user.email = userDict[@"email"];
    user.registeredAt = [DateUtility dateFromString:userDict[@"registered_at"]];
    user.successfulBuyoutsCount = [userDict[@"successful_buyouts_count"] intValue];
    if (userDict[@"failed_buyouts_count"]) {
        user.failedBuyoutsCount = [userDict[@"failed_buyouts_count"] intValue];
    }
    user.matchedBuyoutsCount = [userDict[@"matched_buyouts_count"] intValue];
    user.profileImageUrl = userDict[@"profile_image_url"];
    user.underBuyouyThreat = [userDict[@"under_buyout_threat"] boolValue];
    user.attackingCurrentUser = [userDict[@"attacking_current_user"] boolValue];
    user.defeatedAt = [DateUtility dateFromString:userDict[@"defeated_at"]];
    user.isPlutocrat = [userDict[@"is_plutocrat"] boolValue];
    return user;
}

@end
