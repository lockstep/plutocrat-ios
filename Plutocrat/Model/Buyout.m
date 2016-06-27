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

+ (Buyout *)buyoutFromDict:(NSDictionary *)buyoutDict
{
    Buyout * buyout = [Buyout new];

    buyout.identifier = [buyoutDict[@"id"] unsignedIntegerValue];
    buyout.numberOfShares = [buyoutDict[@"number_of_shares"] unsignedIntegerValue];

    buyout.state = stringToState(buyoutDict[@"state"]);

    buyout.initiatedAt = [DateUtility dateFromString:buyoutDict[@"initiated_at"]];
    buyout.deadlineAt = [DateUtility dateFromString:buyoutDict[@"deadline_at"]];
    buyout.resolvedAt = [DateUtility dateFromString:buyoutDict[@"resolved_at"]];

    buyout.initiatedTimeAgo = buyoutDict[@"initiated_time_ago"];
    buyout.resolvedTimeAgo = buyoutDict[@"resolved_time_ago"];

    buyout.initiatingUser = [User userFromDict:buyoutDict[@"initiating_user"]];
    buyout.targetUser = [User userFromDict:buyoutDict[@"target_user"]];
    
    return buyout;
}

static BuyoutState stringToState(NSString * string)
{
    if ([string isEqualToString:@"initiated"]) return BuyoutStateInitiated;
    if ([string isEqualToString:@"matched"]) return BuyoutStateMatched;
    if ([string isEqualToString:@"succeeded"]) return BuyoutStateSucceeded;
    return NSUIntegerMax;
}

@end
