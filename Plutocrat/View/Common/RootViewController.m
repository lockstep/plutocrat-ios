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
#import "LeftPanelViewController.h"

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
    
    LoginViewController * loginViewController = [LoginViewController new];
    [loginViewController setDelegate:self];
    [self addChildViewController:loginViewController];
    [self.view addSubview:loginViewController.view];
    [loginViewController setupContentsWhenUserIsRegistered:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - LoginViewControllerDelegate

- (void)loginViewControllerShouldDismiss:(LoginViewController *)loginViewController
{
    sidePanelViewController = [JASidePanelController new];
    leftPanelViewController = [LeftPanelViewController new];
    sidePanelViewController.leftPanel = leftPanelViewController;
    tabBarViewController = [TabBarViewController new];
    sidePanelViewController.centerPanel = tabBarViewController;
    [loginViewController.view removeFromSuperview];
    [loginViewController removeFromParentViewController];
    [self addChildViewController:sidePanelViewController];
    [self.view addSubview:sidePanelViewController.view];
}

@end
