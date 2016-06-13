//
//  User.h
//  Plutocrat
//
//  Created by Kuntee Viriyothai on 3/8/16.
//  Copyright © 2016 Whitefly Ventures, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property int identifier;
@property (nonatomic, retain) NSString *displayName;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSDate *registeredAt;
@property int successfulBuyoutsCount;
@property int failedBuyoutsCount;
@property int matchedBuyoutsCount;
@property (nonatomic, retain) NSString *profileImageUrl;
@property BOOL underBuyoutThreat;
@property BOOL attackingCurrentUser;
@property (nonatomic, retain) NSDate *defeatedAt;
@property BOOL isPlutocrat;

+ (User *)userFromDict:(NSDictionary *)userDict;

@end
