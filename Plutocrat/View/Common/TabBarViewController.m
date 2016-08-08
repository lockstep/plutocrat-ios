//
//  TabBarViewController.m
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-03.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import "TabBarViewController.h"

#import "Settings.h"
#import "UserManager.h"

@interface TabBarViewController ()
{
    HomeViewController * hvc;
    TargetsViewController * tvc;
    BuyoutsViewController * bvc;
    SharesViewController * svc;
    AccountViewController * avc;
}
@end

@implementation TabBarViewController

#pragma mark - public

- (void)setupDefeated:(BOOL)defeated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    [self.tabBar setBackgroundImage:[UIImage imageNamed:@"white_bg.jpg"]];
    [self.tabBar setTintColor:[UIColor ourViolet]];
    CGFloat sizeOfStatusBar = [[UIApplication sharedApplication] statusBarFrame].size.height;

    if (sizeOfStatusBar > 20.0f)
    {
        [self.tabBar setFrame:CGRectMake(0.0f,
                                         [[UIScreen mainScreen] applicationFrame].size.height - self.tabBar.frame.size.height,
                                         self.tabBar.frame.size.width,
                                         self.tabBar.frame.size.height)];
    }

    hvc = [HomeViewController new];
    [hvc setDelegate:self];
    UIImage * hvcImgInact = [[UIImage imageNamed:@"home-inactive"]
                             imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage * hvcImgAct = [[UIImage imageNamed:@"home-active"]
                           imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    hvc.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Home", @"Labels", nil)
                                                   image:hvcImgInact
                                           selectedImage:hvcImgAct];

    if (!defeated)
    {
        tvc = [TargetsViewController new];
        [tvc setDelegate:self];
        UIImage * tvcImgInact = [[UIImage imageNamed:@"targets-inactive"]
                                 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage * tvcImgAct = [[UIImage imageNamed:@"targets-active"]
                               imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        tvc.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Targets", @"Labels", nil) image:tvcImgInact selectedImage:tvcImgAct];
        
        bvc = [BuyoutsViewController new];
        UIImage * bvcImgInact = [[UIImage imageNamed:@"buyouts-inactive"]
                                 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage * bvcImgAct = [[UIImage imageNamed:@"buyouts-active"]
                               imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        bvc.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Buyouts", @"Labels", nil) image:bvcImgInact selectedImage:bvcImgAct];
        
        svc = [SharesViewController new];
        UIImage * svcImgInact = [[UIImage imageNamed:@"shares-inactive"]
                                 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage * svcImgAct = [[UIImage imageNamed:@"shares-active"]
                                imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        svc.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Shares", @"Labels", nil) image:svcImgInact selectedImage:svcImgAct];
    }
    
    avc = [AccountViewController new];
    [avc setDelegate:self];
    UIImage * avcImgInact = [[UIImage imageNamed:@"settings-inactive"]
                             imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage * avcImgAct = [[UIImage imageNamed:@"settings-active"]
                           imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    avc.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Settings", @"Labels", nil)
                                                   image:avcImgInact
                                           selectedImage:avcImgAct];

    if (!defeated)
    {
        self.viewControllers = @[hvc, tvc, bvc, svc, avc];
    }
    else
    {
        self.viewControllers = @[hvc, avc];
    }
}

- (void)updateOnPush
{
    [hvc refreshData];
}

#pragma mark - HomeViewControllerDelegate

- (void)homeViewController:(HomeViewController *)controller shouldNavigateTo:(NavigateTo)dest
{
    if ([self.customDelegate respondsToSelector:@selector(tabBarViewController:shouldNavigateTo:)])
    {
        [Settings setTypeOfHomeAlert:2];
        [self.customDelegate tabBarViewController:self shouldNavigateTo:dest];
    }
}

- (void)homeViewControllerAskedForPushes:(HomeViewController *)controller
{
    if ([self.customDelegate respondsToSelector:@selector(tabBarViewControllerAskedForPushes:)])
    {
        [Settings setTypeOfHomeAlert:1];
        [self.customDelegate tabBarViewControllerAskedForPushes:self];
    }
}

- (void)homeViewControllerDefeated:(HomeViewController *)controller
{
    if ([self.customDelegate respondsToSelector:@selector(tabBarViewControllerDidSetDefeated:)])
    {
        [self.customDelegate tabBarViewControllerDidSetDefeated:self];
    }
}

#pragma mark - TargetsBuyoutsViewControllerDelegate

- (void)targetsBuyoutsViewControllerShouldUpdateBuyouts:(TargetsBuyoutsBaseViewController *)controller
{
    [bvc updateOnPush];
}

#pragma mark - AccountViewControllerDelegate

- (void)accountViewControllerUpdatedData:(AccountViewController *)accountViewController
{
    [hvc refreshData];
    [tvc updateCurrentUserName];
}

@end
