//
//  HomeViewController.m
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-03.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeHeader.h"
#import "BuyoutsStatsView.h"
#import "AttackerView.h"
#import "User.h"
#import "UserManager.h"
#import "Settings.h"
#import "ApiConnector.h"

@interface HomeViewController ()
{
    UIScrollView * view;
    HomeHeader * homeHeader;
    BigUserView * bigUserView;
    BuyoutsStatsView * buyoutsStatsView;
    HomeInfo * infoView;
    AttackerView * attackerView;
    User * user;
    NSTimer * timer;
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
    [bigUserView setDelegate:self];
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

    [self updateData];
}

#pragma mark - public

- (void)updateData
{
    [timer invalidate];
    
    user = [User userFromDict:[UserManager userDict]];

    [buyoutsStatsView setSuccessful:user.successfulBuyoutsCount
                             failed:user.failedBuyoutsCount
                           defeated:user.matchedBuyoutsCount];

    [bigUserView setPhotoUrl:user.profileImageUrl
                    initials:user.initials
                        name:user.displayName
                       email:user.email
               sharesToMatch:0];

    if (user.underBuyoutThreat)
    {
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                 target:self
                                               selector:@selector(onTimerBack)
                                               userInfo:nil
                                                repeats:YES];
        [self styleAttacked];
    }
    else if (user.defeatedAt)
    {
        [self styleDefeated];
    }
    else
    {
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                 target:self
                                               selector:@selector(onTimerForward)
                                               userInfo:nil
                                                repeats:YES];
        [self styleNormal];
    }
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
}

- (void)styleNormal
{
    [self layBasicInfoWhenAttacked:NO];
    
    [homeHeader setType:HomeHeaderTypeCommon];
    [homeHeader setDate:user.registeredAt];
    [infoView setBuyouts:user.buyoutsUntilPlutocratCount];
    [infoView setType:[Settings typeOfHomeAlert]];
}

- (void)styleAttacked
{
    [self layBasicInfoWhenAttacked:YES];
    
    [homeHeader setType:HomeHeaderTypeThreated];
    [homeHeader setDate:user.inboundBuyout.deadlineAt];

    UIActivityIndicatorView * iView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [iView setCenter:CGPointMake(attackerView.attacker.frame.size.width / 2,
                                 attackerView.attacker.frame.size.height / 2)];
    [attackerView.attacker addSubview:iView];
    [iView startAnimating];
    [ApiConnector getProfileWithUserId:user.inboundBuyout.initiatingUserId
                            completion:^(User * attacker, NSString * error)
                            {
                                [iView removeFromSuperview];
                                if (!error)
                                {
                                    [attackerView.attacker setPhotoUrl:attacker.profileImageUrl
                                                              initials:attacker.initials
                                                                  name:attacker.displayName
                                                                 email:attacker.email
                                                        sharesToMatch:user.inboundBuyout.numberOfShares];
                                }
                            }];

    [infoView setType:HomeInfoTypeCommon];
    [infoView setBuyouts:user.buyoutsUntilPlutocratCount];
}

- (void)styleDefeated
{
    [self layBasicInfoWhenAttacked:NO];
    
    [homeHeader setType:HomeHeaderTypeDefeated];
    [homeHeader setDate:[NSDate dateWithTimeInterval:-127526 sinceDate:[NSDate date]]];
    
    [infoView setType:HomeInfoTypeDefeated];
    [infoView setName:@"Aaron Pinchai" shares:32 daysAgo:4];
}

#pragma mark - BigUserViewDelegate

- (void)bigUserViewShouldOpenAccount:(BigUserView *)view
{
    if ([self.delegate respondsToSelector:@selector(homeViewController:shouldNavigateTo:)])
    {
        [self.delegate homeViewController:self shouldNavigateTo:NavigateToAccount];
    }
}

#pragma mark - timer

- (void)onTimerBack
{
    [homeHeader setDate:user.inboundBuyout.deadlineAt];
}

- (void)onTimerForward
{
    [homeHeader setDate:user.registeredAt];
}

@end
