//
//  InboundBuyout.m
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-06-21.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import "InboundBuyout.h"
#import "DateUtility.h"

@implementation InboundBuyout

+ (instancetype)buyoutFromDict:(NSDictionary *)buyoutDict
{
    InboundBuyout * buyout = [InboundBuyout new];

    buyout.identifier = [buyoutDict[@"id"] unsignedIntegerValue];
    buyout.numberOfShares = [buyoutDict[@"number_of_shares"] unsignedIntegerValue];
    buyout.initiatingUserId = [buyoutDict[@"initiating_user_id"] unsignedIntegerValue];
    buyout.targetUserId = [buyoutDict[@"target_user_id"] unsignedIntegerValue];

    buyout.createdAt = [DateUtility dateFromString:buyoutDict[@"created_at"]];
    buyout.initiatedAt = [DateUtility dateFromString:buyoutDict[@"initiated_at"]];
    buyout.deadlineAt = [DateUtility dateFromString:buyoutDict[@"deadline_at"]];
    buyout.updatedAt = [DateUtility dateFromString:buyoutDict[@"updated_at"]];

    buyout.state = buyoutDict[@"state"];

    return buyout;
}

@end
