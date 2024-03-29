//
//  User.m
//  Plutocrat
//
//  Created by Kuntee Viriyothai on 3/8/16.
//  Copyright © 2016 Whitefly Ventures, Inc. All rights reserved.
//

#import "User.h"
#import "DateUtility.h"
#import "Buyout.h"

@implementation User

+ (instancetype)userFromDict:(NSDictionary *)userDict
{
    User * user = [User new];
    user.identifier = [userDict[@"id"] unsignedIntegerValue];

    user.displayName = userDict[@"display_name"];
    user.email = userDict[@"email"];
    user.initials = userDict[@"initials"];
    user.profileImageUrl = userDict[@"profile_image_url"];

    user.successfulBuyoutsCount = [userDict[@"successful_buyouts_count"] unsignedIntegerValue];
    user.failedBuyoutsCount = [userDict[@"failed_buyouts_count"] unsignedIntegerValue];
    user.matchedBuyoutsCount = [userDict[@"matched_buyouts_count"] unsignedIntegerValue];
    user.availableSharesCount = [userDict[@"available_shares_count"] unsignedIntegerValue];
    user.buyoutsUntilPlutocratCount = [userDict[@"buyouts_until_plutocrat_count"] unsignedIntegerValue];
    
    user.underBuyoutThreat = [userDict[@"under_buyout_threat"] boolValue];
    user.attackingCurrentUser = [userDict[@"attacking_current_user"] boolValue];
    user.isPlutocrat = [userDict[@"is_plutocrat"] boolValue];

    user.registeredAt = [DateUtility dateFromString:userDict[@"registered_at"]];
    user.defeatedAt = [DateUtility dateFromString:userDict[@"defeated_at"]];

    if (userDict[@"active_inbound_buyout"] && [userDict[@"active_inbound_buyout"] isKindOfClass:[NSDictionary class]])
    {
        user.inboundBuyout = [InboundBuyout buyoutFromDict:userDict[@"active_inbound_buyout"]];
    }

    if (userDict[@"terminal_buyout"] && [userDict[@"terminal_buyout"] isKindOfClass:[NSDictionary class]])
    {
        user.terminalBuyout = [Buyout buyoutFromDict:userDict[@"terminal_buyout"]];
    }

    return user;
}

@end
