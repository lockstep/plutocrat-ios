//
//  TabBarViewController.m
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-03.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import "TabBarViewController.h"

#import "HomeViewController.h"
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    hvc = [HomeViewController new];
    hvc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Home" image:nil tag:0];

    tvc = [TargetsViewController new];
    tvc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Targets" image:nil tag:1];
    
    bvc = [BuyoutsViewController new];
    bvc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Buyouts" image:nil tag:2];
    
    svc = [SharesViewController new];
    svc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Shares" image:nil tag:3];
    
    avc = [AboutViewController new];
    avc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"About" image:nil tag:4];
    
    self.viewControllers = @[hvc, tvc, bvc, svc, avc];
    // Do any additional setup after loading the view.
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

@end
