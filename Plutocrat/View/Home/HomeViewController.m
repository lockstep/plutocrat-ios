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
    [attackerView setDelegate:self];
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
    else if (user.terminalBuyout)
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
    User * attacker = user.inboundBuyout.initiatingUser;
    [attackerView.attacker setPhotoUrl:attacker.profileImageUrl
                              initials:attacker.initials
                                  name:attacker.displayName
                                 email:attacker.email
                         sharesToMatch:user.inboundBuyout.numberOfShares];
    [infoView setType:HomeInfoTypeCommon];
    [infoView setBuyouts:user.buyoutsUntilPlutocratCount];
}

- (void)styleDefeated
{
    [self layBasicInfoWhenAttacked:NO];

    [homeHeader setType:HomeHeaderTypeDefeated];
    [homeHeader setSurvavalFromDate:user.registeredAt toDate:user.defeatedAt];

    [bigUserView setUserInteractionEnabled:NO];

    [infoView setType:HomeInfoTypeDefeated];
    [infoView setName:user.terminalBuyout.initiatingUser.displayName
               shares:user.terminalBuyout.numberOfShares
              timeAgo:user.terminalBuyout.resolvedTimeAgo];
}

#pragma mark - BigUserViewDelegate

- (void)bigUserViewShouldOpenAccount:(BigUserView *)view
{
    if ([self.delegate respondsToSelector:@selector(homeViewController:shouldNavigateTo:)])
    {
        [self.delegate homeViewController:self shouldNavigateTo:NavigateToAccount];
    }
}

#pragma mark - AttackerViewDelegate

- (void)attackerViewDidAcceptDefeat:(AttackerView *)view
{
    [self showAlertAskForDefeatWithHandler:^()
     {
         [attackerView setUserInteractionEnabled:NO];
         UIActivityIndicatorView * iView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
         [iView setCenter:CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2)];
         [self.view addSubview:iView];
         [iView startAnimating];
         [ApiConnector failToMatchBuyout:user.inboundBuyout.identifier
                              completion:^(User * user, NSString * error)
          {
              [iView removeFromSuperview];
              if (!error)
              {
                  [self updateData];
              }
              else
              {
                  [self showAlertWithErrorText:error];
              }
          }];
     }];
}

- (void)attackerViewDidMatchShares:(AttackerView *)view
{
    if (user.availableSharesCount < user.inboundBuyout.numberOfShares)
    {
        [self showAlertNotEnoughShares];
    }
    else
    {
        [attackerView setUserInteractionEnabled:NO];
        UIActivityIndicatorView * iView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [iView setCenter:CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2)];
        [self.view addSubview:iView];
        [iView startAnimating];
        [ApiConnector matchBuyout:user.inboundBuyout.identifier
                       completion:^(User * user, NSString * error)
         {
             [iView removeFromSuperview];
             if (!error)
             {
                 [self updateData];
             }
             else
             {
                 [self showAlertWithErrorText:error];
             }
         }];
    }
}

#pragma mark - timer

- (void)onTimerBack
{
    [homeHeader setDate:user.inboundBuyout.deadlineAt];
    if ([user.inboundBuyout.deadlineAt timeIntervalSinceNow] >= 0)
    {
        [timer invalidate];
        timer = nil;
        [ApiConnector getProfileWithUserId:user.identifier
                                completion:^(User * user, NSString * error)
         {
             [self updateData];
         }];
    }
}

- (void)onTimerForward
{
    [homeHeader setDate:user.registeredAt];
}

#pragma mark - Alerts

- (void)showAlertAskForDefeatWithHandler:(void (^)())handler
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:NSLocalizedStringFromTable(@"Alert", @"Labels", nil) message:NSLocalizedStringFromTable(@"AskForDefeat", @"Labels", nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * badAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"YES", @"Labels", nil)
                                                             style:UIAlertActionStyleDestructive
                                                           handler:handler];
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"Cancel", @"Labels", nil)
                                                                style:UIAlertActionStyleCancel
                                                              handler:nil];

        [alert addAction:badAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    });
}

- (void)showAlertNotEnoughShares
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:NSLocalizedStringFromTable(@"Alert", @"Labels", nil) message:NSLocalizedStringFromTable(@"NotEnoughShares", @"Labels", nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:nil];

        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    });
}

- (void)showAlertWithErrorText:(NSString *)text
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:NSLocalizedStringFromTable(@"Error", @"Labels", nil) message:text preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:nil];

        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    });
}

@end
