//
//  HomeViewController.m
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-03.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeHeader.h"
#import "BigUserView.h"
#import "BuyoutsStatsView.h"

@interface HomeViewController ()
{
    HomeHeader * homeHeader;
    BigUserView * bigUserView;
    BuyoutsStatsView * buyoutsStatsView;
}
@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    homeHeader = [[HomeHeader alloc] initWithFrame:CGRectMake(0.0f,
                                                              0.0f,
                                                              self.view.bounds.size.width,
                                                              124.0f)];
    [homeHeader setType:HomeHeaderTypeCommon];
    [homeHeader setDate:[NSDate dateWithTimeInterval:-127526 sinceDate:[NSDate date]]];
    [self.view addSubview:homeHeader];
    
    
    bigUserView = [[BigUserView alloc] initWithFrame:CGRectMake(0.0f,
                                                                124.0f,
                                                                self.view.bounds.size.width,
                                                                136.0f)];
    [self.view addSubview:bigUserView];
    
    buyoutsStatsView = [[BuyoutsStatsView alloc] initWithFrame:
                        CGRectMake(0.0f, 260.0f, self.view.bounds.size.width, 136.0f)];
    [self.view addSubview:buyoutsStatsView];
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
