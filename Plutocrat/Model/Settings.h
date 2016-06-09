//
//  Settings.h
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-06-09.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Settings : NSObject

+ (BOOL)isEventsNotificationsEnabled;
+ (BOOL)enableEventsNotifiations:(BOOL)enable;

+ (BOOL)isUpdatesEmailsEnabled;
+ (BOOL)enableUpdatesEmails:(BOOL)enable;

+ (BOOL)isTouchIDEnabled;
+ (BOOL)enableTouchID:(BOOL)enable;

+ (NSString *)userEmail;
+ (BOOL)setUserEmail:(NSString *)email;

+ (BOOL)setDefaults;

@end
