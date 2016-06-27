//
//  TabBarViewController.h
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-03.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "AccountViewController.h"

@class TabBarViewController;

@protocol TabBarViewControllerDelegate <NSObject>
@required

- (void)tabBarViewController:(TabBarViewController *)controller shouldNavigateTo:(NavigateTo)dest;
- (void)tabBarViewControllerAskedForPushes:(TabBarViewController *)controller;

@end

@interface TabBarViewController : UITabBarController <HomeViewControllerDelegate, AccountViewControllerDelegate>

- (void)setupDefeated:(BOOL)defeated;

@property (nonatomic, weak) id <TabBarViewControllerDelegate> customDelegate;

@end
