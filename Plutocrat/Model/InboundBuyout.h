//
//  InboundBuyout.h
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-06-21.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

@interface InboundBuyout : NSObject

@property NSUInteger identifier;
@property NSUInteger numberOfShares;
@property NSUInteger targetUserId;

@property (nonatomic, copy) NSDate * initiatedAt;
@property (nonatomic, copy) NSDate * deadlineAt;
@property (nonatomic, copy) NSDate * resolvedAt;

@property (nonatomic, copy) NSString * initiatedTimeAgo;
@property (nonatomic, copy) NSString * resolvedTimeAgo;
@property (nonatomic, copy) NSString * state;

@property (nonatomic, strong) User * initiatingUser;

+ (instancetype)buyoutFromDict:(NSDictionary *)buyoutDict;

@end
