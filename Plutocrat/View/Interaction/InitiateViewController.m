//
//  InitiateViewController.m
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-20.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import "InitiateViewController.h"
#import "SelectShares.h"
#import "CommonButton.h"
#import "TargetsBuyoutsHeader.h"
#import "TargetsCell.h"
#import "DateUtility.h"
#import "ApiConnector.h"

@interface InitiateViewController ()
{
    TargetsBuyoutsHeader * header;
    UIImageView * anotherBack;
    TargetsCell * anotherHeader;
    SelectShares * selectShares;
    CommonButton * abort;
    CommonButton * execute;
    NSUInteger userId;
    NSUInteger cellTag;
}
@end

@implementation InitiateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    header = [[TargetsBuyoutsHeader alloc] initWithFrame:
              CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, [Globals cellHeight] + 20.0f)];
    [header setHidden:YES];
    [self.view addSubview:header];
    
    anotherBack = [[UIImageView alloc] initWithFrame:header.frame];
    [anotherBack setHidden:YES];
    [self.view addSubview:anotherBack];
    
    anotherHeader = [[TargetsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [anotherHeader setFrame:CGRectMake(0.0f, 20.0f, self.view.bounds.size.width, [Globals cellHeight])];
    [anotherHeader setBackgroundColor:[UIColor whiteColor]];
    [anotherHeader setHidden:YES];
    [self.view addSubview:anotherHeader];
    
    UIScrollView * view = [[UIScrollView alloc] initWithFrame:
                           CGRectMake(0.0f,
                                      header.frame.size.height,
                                      self.view.bounds.size.width,
                                      self.view.bounds.size.height - header.frame.size.height - [Globals tabBarHeight])];
    [self.view addSubview:view];
    
    selectShares = [[SelectShares alloc] initWithFrame:
                    CGRectMake(0.0f,
                               0.0f,
                               self.view.bounds.size.width,
                               300.0f)];
    [view addSubview:selectShares];
    
    abort = [CommonButton buttonWithText:NSLocalizedStringFromTable(@"ABORT", @"Buttons", nil) color:ButtonColorGray];
    [abort setCenter:CGPointMake([Globals horizontalOffsetInTable] + abort.frame.size.width / 2, selectShares.frame.size.height + abort.frame.size.height / 2 + 40.0f)];
    [abort addTarget:self action:@selector(abortTapped) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:abort];
    
    execute = [CommonButton buttonWithText:NSLocalizedStringFromTable(@"EXECUTE", @"Buttons", nil) color:ButtonColorViolet];
    [execute setCenter:CGPointMake(self.view.bounds.size.width - [Globals horizontalOffsetInTable] - execute.frame.size.width / 2, selectShares.frame.size.height + execute.frame.size.height / 2 + 40.0f)];
    [execute setUserInteractionEnabled:NO];
    [execute addTarget:self action:@selector(executeTapped) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:execute];

    CGFloat contentY = MAX(execute.frame.origin.y + execute.frame.size.height + 20.0f,
                           view.frame.size.height + 1.0f);
    [view setContentSize:CGSizeMake(view.frame.size.width, contentY)];
}

#pragma mark - public

- (void)setUser:(User *)user cellTag:(NSUInteger)tag
{
    cellTag = tag;
    userId = user.identifier;
    [header setHidden:YES];
    [anotherBack setHidden:NO];
    [anotherHeader setHidden:NO];
    [[anotherHeader photo] setUrl:user.profileImageUrl initials:user.initials compeltionHandler:nil];
    [[anotherHeader name] setText:user.displayName];
    [anotherHeader setEngageButtonState:EngageButtonHidden];
    [anotherHeader setBuyouts:user.successfulBuyoutsCount
                      threats:user.matchedBuyoutsCount
                         days:[DateUtility daysFromNow:user.registeredAt]];
    UIActivityIndicatorView * iView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [iView setCenter:CGPointMake(selectShares.frame.size.width / 2, selectShares.frame.size.height / 2)];
    [selectShares addSubview:iView];
    [selectShares setUserInteractionEnabled:NO];
    [iView startAnimating];
    [ApiConnector prepareBuyoutToUser:user.identifier
                           completion:^(NSUInteger availableSharesCount, NSUInteger minimumAmount, NSString * error)
     {
         [iView removeFromSuperview];
         if (!error)
         {
             [selectShares setMin:minimumAmount value:minimumAmount max:availableSharesCount];
             [selectShares setUserInteractionEnabled:YES];
             if (minimumAmount <= availableSharesCount)
             {
                 [execute setUserInteractionEnabled:YES];
             }
         }
     }];
}

- (void)setBackImageType:(BackImageType)type
{
    switch (type)
    {
        case BackImageTypeTargets:
            [anotherBack setImage:[UIImage imageNamed:@"Background-blue"]];
            break;
            
        case BackImageTypeBuyouts:
            [anotherBack setImage:[UIImage imageNamed:@"Background-gray"]];
            break;
            
        default:
            break;
    }
}

#pragma mark - buttons

- (void)abortTapped
{
    [self exit];
}

- (void)executeTapped
{
    [execute setEnabled:NO];
    [abort setEnabled:NO];
    UIActivityIndicatorView * iView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [iView setCenter:CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2)];
    [self.view addSubview:iView];
    [iView startAnimating];

    [ApiConnector initiateBuyoutToUser:userId
                        amountOfShares:[selectShares value]
                            completion:^(Buyout * buyout, NSString * error)
     {
         [execute setEnabled:YES];
         [abort setEnabled:YES];
         [iView removeFromSuperview];
         if (!error)
         {
             [self showAlertOk:^()
              {
                  if ([self.delegate respondsToSelector:@selector(initiateViewController:initiatedBuyoutAndShouldRefreshCellWithTag:)])
                  {
                      [self.delegate initiateViewController:self initiatedBuyoutAndShouldRefreshCellWithTag:cellTag];
                  }
                  [self exit];
              }];
         }
     }];
}

#pragma mark - TargetsBuyotsHeaderDelegate

- (void)buttonTappedToEngage:(BOOL)toEngage
{
    if (!toEngage)
    {
        [self exit];
    }
}

#pragma mark - exit

- (void)exit
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Alerts

- (void)showAlertWithErrorText:(NSString *)text
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:NSLocalizedStringFromTable(@"Error", @"Labels", nil)
                                                                        message:text preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:nil];

        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    });
}

- (void)showAlertOk:(void (^)())completion
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedStringFromTable(@"SuccessfulInitiation", @"Labels", nil) preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissViewControllerAnimated:YES completion:^()
            {
                completion();
            }];
        });
    });
}

@end
