//
//  Buyout.h
//  Plutocrat
//
//  Created by Kuntee Viriyothai on 3/8/16.
//  Copyright © 2016 Whitefly Ventures, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Buyout : NSObject

@property int identifier;
@property (nonatomic, retain) NSDate *initiatedAt;
@property (nonatomic, retain) NSString *initiatedTimeAgo;
@property (nonatomic, retain) NSDate *deadlineAt;
@property NSUInteger numberOfShares;
@property (nonatomic, retain) NSString *state;
@property (nonatomic, retain) NSDate *resolvedAt;
@property (nonatomic, retain) NSString *resolvedTimeAgo;
@property (nonatomic, retain) User *initiatingUser;
@property (nonatomic, retain) User *targetUser;

+ (Buyout *)buyoutFromDict:(NSDictionary *)buyoutDict;

@end
