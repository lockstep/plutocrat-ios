//
//  Settings.m
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-06-09.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import "Settings.h"

#define EVENTS_NOTIFICATIONS_KEY @"eventsNotificatonsKey"
#define UPDATES_EMAILS_KEY @"updatesEmailsKey"
#define TOUCH_ID_KEY @"touchIDKey"
#define USER_EMAIL_KEY @"userEmailKey"

@implementation Settings

+ (BOOL)isEventsNotificationsEnabled
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:EVENTS_NOTIFICATIONS_KEY];
}

+ (BOOL)enableEventsNotifiations:(BOOL)enable
{
    [[NSUserDefaults standardUserDefaults] setBool:enable forKey:EVENTS_NOTIFICATIONS_KEY];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isUpdatesEmailsEnabled
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:UPDATES_EMAILS_KEY];
}

+ (BOOL)enableUpdatesEmails:(BOOL)enable
{
    [[NSUserDefaults standardUserDefaults] setBool:enable forKey:UPDATES_EMAILS_KEY];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isTouchIDEnabled
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:TOUCH_ID_KEY];
}

+ (BOOL)enableTouchID:(BOOL)enable
{
    [[NSUserDefaults standardUserDefaults] setBool:enable forKey:TOUCH_ID_KEY];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)userEmail
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:USER_EMAIL_KEY];
}

+ (BOOL)setUserEmail:(NSString *)email
{
    [[NSUserDefaults standardUserDefaults] setObject:email forKey:USER_EMAIL_KEY];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)setDefaults
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:EVENTS_NOTIFICATIONS_KEY];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:UPDATES_EMAILS_KEY];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:TOUCH_ID_KEY];
    return [[NSUserDefaults standardUserDefaults] synchronize];

}

@end
