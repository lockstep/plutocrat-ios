//
//  TabBarViewController.m
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-03.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import "TabBarViewController.h"

#import "TargetsViewController.h"
#import "BuyoutsViewController.h"
#import "SharesViewController.h"
#import "AboutViewController.h"

@interface TabBarViewController ()
{
    HomeViewController * hvc;
    TargetsViewController * tvc;
    BuyoutsViewController * bvc;
    SharesViewController * svc;
    AboutViewController * avc;
}
@end

@implementation TabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self.tabBar setTintColor:[UIColor ourViolet]];
    
    hvc = [HomeViewController new];
    [hvc setDelegate:self];
    UIImage * hvcImgInact = [[UIImage imageNamed:@"home-inactive"]
                             imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage * hvcImgAct = [[UIImage imageNamed:@"home-active"]
                           imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    hvc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Home"
                                                   image:hvcImgInact
                                           selectedImage:hvcImgAct];

    tvc = [TargetsViewController new];
    UIImage * tvcImgInact = [[UIImage imageNamed:@"targets-inactive"]
                             imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage * tvcImgAct = [[UIImage imageNamed:@"targets-active"]
                           imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tvc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Targets"
                                                   image:tvcImgInact
                                           selectedImage:tvcImgAct ];
    
    bvc = [BuyoutsViewController new];
    UIImage * bvcImgInact = [[UIImage imageNamed:@"buyouts-inactive"]
                             imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage * bvcImgAct = [[UIImage imageNamed:@"buyouts-active"]
                           imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    bvc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Buyouts"
                                                   image:bvcImgInact
                                           selectedImage:bvcImgAct];
    
    svc = [SharesViewController new];
    UIImage * svcImgInact = [[UIImage imageNamed:@"shares-inactive"]
                             imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage * svcImgAct = [[UIImage imageNamed:@"shares-active"]
                           imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    svc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Shares"
                                                   image:svcImgInact
                                           selectedImage:svcImgAct];
    
    avc = [AboutViewController new];
    UIImage * avcImgInact = [[UIImage imageNamed:@"about-inactive"]
                             imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage * avcImgAct = [[UIImage imageNamed:@"about-active"]
                           imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    avc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"About"
                                                   image:avcImgInact
                                           selectedImage:avcImgAct];
    
    self.viewControllers = @[hvc, tvc, bvc, svc, avc];
}

#pragma mark - HomeViewControllerDelegate

- (void)homeViewController:(HomeViewController *)controller shouldNavigateTo:(NavigateTo)dest
{
    if ([self.customDelegate respondsToSelector:@selector(tabBarViewController:shouldNavigateTo:)])
    {
        [self.customDelegate tabBarViewController:self shouldNavigateTo:dest];
    }
}

- (void)homeViewControllerAskedForPushes:(HomeViewController *)controller
{
    if ([self.customDelegate respondsToSelector:@selector(tabBarViewControllerAskedForPushes:)])
    {
        [self.customDelegate tabBarViewControllerAskedForPushes:self];
    }
}

@end
