//
//  RootViewController.m
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-11.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import "RootViewController.h"
#import "JASidePanelController.h"
#import "UserManager.h"

#define FAQ_ADDRESS @"https://www.whiteflyventuresinc.com/plutocrat/about.html"

@interface RootViewController ()
{
    JASidePanelController * sidePanelViewController;
    TabBarViewController * tabBarViewController;
    LeftPanelViewController * leftPanelViewController;
}
@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initInLoginStateAndReset:NO];
}

#pragma mark - public

- (void)updateOnPush
{
    [tabBarViewController updateOnPush];
}

#pragma mark - setup

- (void)initInLoginStateAndReset:(BOOL)reset
{
    LoginViewController * loginViewController = [LoginViewController new];
    [loginViewController setDelegate:self];
    [self addChildViewController:loginViewController];
    [self.view addSubview:loginViewController.view];
    if (reset)
    {
        [loginViewController flushEmailAndPassword];
    }
    [loginViewController setupContentsWhenUserIsRegistered:[UserManager hasLastLogin]];
}

- (void)initInReadyState
{
    sidePanelViewController = [JASidePanelController new];
    leftPanelViewController = [LeftPanelViewController new];
    [leftPanelViewController setDelegate:self];
    sidePanelViewController.leftPanel = leftPanelViewController;
    tabBarViewController = [TabBarViewController new];
    [tabBarViewController setCustomDelegate:self];
    [tabBarViewController setupDefeated:[UserManager isDefeated]];
    sidePanelViewController.centerPanel = tabBarViewController;
    [self addChildViewController:sidePanelViewController];
    [self.view addSubview:sidePanelViewController.view];
}

#pragma mark - Navigation

- (void)navigateTo:(NavigateTo)dest
{
    switch (dest)
    {
        case NavigateToAccount:
            [sidePanelViewController showCenterPanelAnimated:YES];
            [tabBarViewController setSelectedIndex:[[tabBarViewController viewControllers] count] - 1];
            break;
            
        case NavigateToTargets:
            [tabBarViewController setSelectedIndex:1];
            break;
            
        case NavigateToFAQ:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:FAQ_ADDRESS]];
            break;
            
        case NavigateToSignOut:
            [sidePanelViewController.view removeFromSuperview];
            [sidePanelViewController removeFromParentViewController];
            [self initInLoginStateAndReset:YES];
            break;
            
        default:
            break;
    }
}

#pragma mark - LoginViewControllerDelegate

- (void)loginViewControllerShouldDismiss:(LoginViewController *)loginViewController
{
    [loginViewController.view removeFromSuperview];
    [loginViewController removeFromParentViewController];
    [self initInReadyState];
}

#pragma mark - LeftPanelDelegate

- (void)leftPanelViewController:(LeftPanelViewController *)viewController shouldNavigateTo:(NavigateTo)dest
{
    [self navigateTo:dest];
}

#pragma mark - TabBarViewControllerDelegate

- (void)tabBarViewController:(TabBarViewController *)controller shouldNavigateTo:(NavigateTo)dest
{
    [self navigateTo:dest];
}

- (void)tabBarViewControllerAskedForPushes:(TabBarViewController *)controller
{
    UIUserNotificationSettings * settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound) categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
}

- (void)tabBarViewControllerDidSetDefeated:(TabBarViewController *)controller
{
    [sidePanelViewController.view removeFromSuperview];
    [sidePanelViewController removeFromParentViewController];
    [self initInReadyState];
}

@end
