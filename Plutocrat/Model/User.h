//
//  User.h
//  Plutocrat
//
//  Created by Kuntee Viriyothai on 3/8/16.
//  Copyright © 2016 Whitefly Ventures, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InboundBuyout.h"

@class Buyout;

@interface User : NSObject

@property NSUInteger identifier;

@property (nonatomic, copy) NSString * displayName;
@property (nonatomic, copy) NSString * email;
@property (nonatomic, copy) NSString * initials;
@property (nonatomic, copy) NSString * profileImageUrl;

@property NSUInteger successfulBuyoutsCount;
@property NSUInteger failedBuyoutsCount;
@property NSUInteger matchedBuyoutsCount;
@property NSUInteger availableSharesCount;
@property NSUInteger buyoutsUntilPlutocratCount;

@property BOOL underBuyoutThreat;
@property BOOL attackingCurrentUser;
@property BOOL isPlutocrat;

@property (nonatomic, copy) NSDate * registeredAt;
@property (nonatomic, copy) NSDate * defeatedAt;

@property (nonatomic, strong) InboundBuyout * inboundBuyout;
@property (nonatomic, strong) Buyout * terminalBuyout;

+ (instancetype)userFromDict:(NSDictionary *)userDict;

@end
