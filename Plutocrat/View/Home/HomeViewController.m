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
#import "AttackerView.h"

@interface HomeViewController ()
{
    UIScrollView * view;
    HomeHeader * homeHeader;
    BigUserView * bigUserView;
    BuyoutsStatsView * buyoutsStatsView;
    HomeInfo * infoView;
    AttackerView * attackerView;
    NSUInteger tapCount;
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
                                                              [Globals headerHeight])];
    [self.view addSubview:homeHeader];
    
    view = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f,
                                                          homeHeader.frame.size.height,
                                                          self.view.bounds.size.width,
                                                          self.view.bounds.size.height - homeHeader.frame.size.height - [Globals tabBarHeight])];
    [self.view addSubview:view];
    
    bigUserView = [[BigUserView alloc] initWithFrame:CGRectMake(0.0f,
                                                                0.0f,
                                                                self.view.bounds.size.width,
                                                                136.0f)];
    [view addSubview:bigUserView];
    
    buyoutsStatsView = [[BuyoutsStatsView alloc] initWithFrame:CGRectMake(0.0f,
                                                                          0.0f,
                                                                          self.view.bounds.size.width,
                                                                          136.0f)];
    [view addSubview:buyoutsStatsView];
    
    infoView = [[HomeInfo alloc] initWithFrame:CGRectMake(0.0f,
                                                          0.0f,
                                                          self.view.bounds.size.width,
                                                          136.0f)];
    [infoView setDelegate:self];
    [view addSubview:infoView];
    
    attackerView = [[AttackerView alloc] initWithFrame:CGRectMake(0.0f,
                                                                  0.0f,
                                                                  self.view.bounds.size.width,
                                                                  270.0f)];
    [view addSubview:attackerView];
    

#pragma mark - stubbed
    
    UIButton * but = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [but addTarget:self action:@selector(change) forControlEvents:UIControlEventTouchUpInside];
    [but setCenter:CGPointMake(30.0f, 30.0f)];
    [but setAlpha:0.1f];
    [homeHeader addSubview:but];
    tapCount = 1;
    [self stub1];
}

#pragma mark - layout

- (void)layBasicInfoWhenAttacked:(BOOL)attacked
{
    CGFloat curY = attacked ? attackerView.frame.size.height : 0.0f;
    
    [bigUserView setCenter:CGPointMake(bigUserView.center.x, curY + bigUserView.frame.size.height / 2)];
    
    curY += bigUserView.frame.size.height;
    
    [buyoutsStatsView setCenter:CGPointMake(buyoutsStatsView.center.x,
                                            curY + buyoutsStatsView.frame.size.height / 2)];
    
    curY += buyoutsStatsView.frame.size.height;
    
    [infoView setCenter:CGPointMake(infoView.center.x, curY + infoView.frame.size.height / 2)];
    
    curY += infoView.frame.size.height;
    
    if (curY > view.frame.size.height)
    {
        [view setContentSize:CGSizeMake(view.bounds.size.width, curY)];
    }
    else
    {
        [view setContentSize:CGSizeMake(view.bounds.size.width, view.bounds.size.height + 1.0f)];
    }
    
    [attackerView setHidden:!attacked];
}

#pragma mark - HomeInfoDelegate

- (void)homeInfoShouldNavigateToTargets:(HomeInfo *)homeInfo
{
    if ([self.delegate respondsToSelector:@selector(homeViewController:shouldNavigateTo:)])
    {
        [self.delegate homeViewController:self shouldNavigateTo:NavigateToTargets];
    }
    [infoView setType:HomeInfoTypePush];
}

- (void)homeInfoShouldEnablePushes:(HomeInfo *)homeInfo
{
    if ([self.delegate respondsToSelector:@selector(homeViewControllerAskedForPushes:)])
    {
        [self.delegate homeViewControllerAskedForPushes:self];
    }
    [infoView setType:HomeInfoTypeCommon];
    [infoView setBuyouts:4];
}

#pragma mark - stub

- (void)change
{
    if (tapCount == 3)
    {
        tapCount = 1;
        [self stub1];
        return;
    }
    if (tapCount == 1)
    {
        tapCount = 2;
        [self stub2];
        return;
    }
    if (tapCount == 2)
    {
        tapCount = 3;
        [self stub3];
        return;
    }
}

- (void)stub1
{
    [self layBasicInfoWhenAttacked:NO];
    
    [homeHeader setType:HomeHeaderTypeCommon];
    [homeHeader setDate:[NSDate dateWithTimeInterval:-127526 sinceDate:[NSDate date]]];
    
    [buyoutsStatsView setSuccessful:88 failed:88 defeated:88];
    [bigUserView fillStub1];
    [infoView setType:HomeInfoTypeFind];
}

- (void)stub2
{
    [self layBasicInfoWhenAttacked:YES];
    
    [homeHeader setType:HomeHeaderTypeThreated];
    [homeHeader setDate:[NSDate dateWithTimeInterval:-127526 sinceDate:[NSDate date]]];
    
    [buyoutsStatsView setSuccessful:88 failed:88 defeated:88];
    [bigUserView fillStub1];
    [infoView setType:HomeInfoTypeCommon];
    [infoView setBuyouts:4];
}

- (void)stub3
{
    [self layBasicInfoWhenAttacked:NO];
    
    [homeHeader setType:HomeHeaderTypeDefeated];
    [homeHeader setDate:[NSDate dateWithTimeInterval:-127526 sinceDate:[NSDate date]]];
    
    [buyoutsStatsView setSuccessful:88 failed:88 defeated:88];
    [bigUserView fillStub1];
    [infoView setType:HomeInfoTypeDefeated];
    [infoView setName:@"Aaron Pinchai" shares:32 daysAgo:4];
}

@end
