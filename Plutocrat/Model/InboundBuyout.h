//
//  InboundBuyout.h
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-06-21.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InboundBuyout : NSObject

@property NSUInteger identifier;
@property NSUInteger numberOfShares;
@property NSUInteger initiatingUserId;
@property NSUInteger targetUserId;

@property (nonatomic, copy) NSDate * createdAt;
@property (nonatomic, copy) NSDate * initiatedAt;
@property (nonatomic, copy) NSDate * deadlineAt;
@property (nonatomic, copy) NSDate * updatedAt;

@property (nonatomic, copy) NSString * state;

+ (instancetype)buyoutFromDict:(NSDictionary *)buyoutDict;

@end
