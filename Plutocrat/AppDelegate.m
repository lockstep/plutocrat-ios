//
//  AppDelegate.m
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-02.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "ApiConnector.h"
#import "UserManager.h"

#define GOING_BACKGROUND @"goingBackground"

@interface AppDelegate ()
{
    RootViewController * rootViewController;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    rootViewController = [RootViewController new];
    self.window.rootViewController = rootViewController;
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark - Pushes

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString * deviceTokenString = [[[[deviceToken description]
                                      stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                     stringByReplacingOccurrencesOfString: @">" withString: @""]
                                    stringByReplacingOccurrencesOfString: @" " withString: @""];
    [ApiConnector updateDeviceToken:deviceTokenString
                         completion:nil];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [ApiConnector getProfileWithUserId:[UserManager currentUserId]
                            completion:^(User * user, NSString * error) {
                                [rootViewController updateOnPush];
                            }];
}

#pragma mark - change state

//TODO: update

- (void)applicationWillResignActive:(UIApplication *)application {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:GOING_BACKGROUND];
    [[NSUserDefaults standardUserDefaults] synchronize];
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:GOING_BACKGROUND];
    [[NSUserDefaults standardUserDefaults] synchronize];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:GOING_BACKGROUND];
    [[NSUserDefaults standardUserDefaults] synchronize];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:GOING_BACKGROUND])
    {
        [rootViewController updateOnPush];
    }
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:GOING_BACKGROUND];
    [[NSUserDefaults standardUserDefaults] synchronize];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:GOING_BACKGROUND];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
