//
//  Buyout.m
//  Plutocrat
//
//  Created by Kuntee Viriyothai on 3/8/16.
//  Copyright © 2016 Whitefly Ventures, Inc. All rights reserved.
//

#import "Buyout.h"
#import "DateUtility.h"

@implementation Buyout

+ (Buyout *)buyoutFromDict:(NSDictionary *)buyoutDict {
    Buyout *buyout = [Buyout new];
    buyout.identifier = [buyoutDict[@"id"] intValue];
    buyout.initiatedAt = [DateUtility dateFromString:buyoutDict[@"initiated_at"]];
    buyout.initiatedTimeAgo = buyoutDict[@"initiated_time_ago"];
    buyout.deadlineAt = [DateUtility dateFromString:buyoutDict[@"deadline_at"]];
    buyout.amount = [buyoutDict[@"amount"] intValue];
    buyout.state = buyoutDict[@"state"];
    buyout.resolvedAt = [DateUtility dateFromString:buyoutDict[@"resolved_at"]];
    buyout.resolvedTimeAgo = buyoutDict[@"resolved_time_ago"];
    buyout.initiatingUser = [User userFromDict:buyoutDict[@"initiating_user"]];
    buyout.targetUser = [User userFromDict:buyoutDict[@"target_user"]];
    return buyout;
}

@end
