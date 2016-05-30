//
//  RootViewController.m
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-11.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import "RootViewController.h"
#import "JASidePanelController.h"
#import "TabBarViewController.h"

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

    [self initInLoginState];
}

- (void)initInLoginState
{
    LoginViewController * loginViewController = [LoginViewController new];
    [loginViewController setDelegate:self];
    [self addChildViewController:loginViewController];
    [self.view addSubview:loginViewController.view];
    [loginViewController setupContentsWhenUserIsRegistered:YES];
}

- (void)initInReadyState
{
    sidePanelViewController = [JASidePanelController new];
    leftPanelViewController = [LeftPanelViewController new];
    [leftPanelViewController setDelegate:self];
    sidePanelViewController.leftPanel = leftPanelViewController;
    tabBarViewController = [TabBarViewController new];
    sidePanelViewController.centerPanel = tabBarViewController;
    [self addChildViewController:sidePanelViewController];
    [self.view addSubview:sidePanelViewController.view];
}

#pragma mark - LoginViewControllerDelegate

- (void)loginViewControllerShouldDismiss:(LoginViewController *)loginViewController
{
    [loginViewController.view removeFromSuperview];
    [loginViewController removeFromParentViewController];
    [self initInReadyState];
}

#pragma mark - LeftPanelDelegate

- (void)leftPanelViewController:(LeftPanelViewController *)viewController should:(NavigateTo)dest
{
    switch (dest)
    {
        case NavigateToAccount:
            break;
            
        case NavigateToFAQ:
        {
            [sidePanelViewController showCenterPanelAnimated:YES];
            [tabBarViewController setSelectedIndex:4];
        }
            break;
            
        case NavigateToSignOut:
        {
            [sidePanelViewController.view removeFromSuperview];
            [sidePanelViewController removeFromParentViewController];
            [self initInLoginState];
        }
            break;
            
        default:
            break;
    }
}

@end
