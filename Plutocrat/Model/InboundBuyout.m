//
//  InboundBuyout.m
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-06-21.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import "InboundBuyout.h"
#import "DateUtility.h"
#import "User.h"

@implementation InboundBuyout

+ (instancetype)buyoutFromDict:(NSDictionary *)buyoutDict
{
    InboundBuyout * buyout = [InboundBuyout new];

    buyout.identifier = [buyoutDict[@"id"] unsignedIntegerValue];
    buyout.numberOfShares = [buyoutDict[@"number_of_shares"] unsignedIntegerValue];
    buyout.targetUserId = [buyoutDict[@"target_user_id"] unsignedIntegerValue];

    buyout.initiatedAt = [DateUtility dateFromString:buyoutDict[@"initiated_at"]];
    buyout.deadlineAt = [DateUtility dateFromString:buyoutDict[@"deadline_at"]];
    buyout.resolvedAt = [DateUtility dateFromString:buyoutDict[@"resolved_at"]];

    buyout.initiatedTimeAgo = buyoutDict[@"initiated_time_ago"];
    buyout.resolvedTimeAgo = buyoutDict[@"resolved_time_ago"];
    buyout.state = buyoutDict[@"state"];

    buyout.initiatingUser = [User userFromDict:buyoutDict[@"initiating_user"]];

    return buyout;
}

@end
