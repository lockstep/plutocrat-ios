//
//  TargetsViewController.m
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-17.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import "TargetsViewController.h"
#import "ApiConnector.h"
#import "DateUtility.h"
#import "UserManager.h"

@interface TargetsViewController ()
{
    NSString * identifier;
    BOOL loading;
    UIActivityIndicatorView * iView;
}
@end

@implementation TargetsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    identifier = @"TargetsCell";
    
    [self.table registerClass:NSClassFromString(@"TargetsCell") forCellReuseIdentifier:identifier];
        
    [self noPlutocrat];
    [self loadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TargetsCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.tag = indexPath.row;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    TargetsCell * tCell = (TargetsCell *)cell;
    if (indexPath.row == [self.source count] && self.currentPage != NSUIntegerMax)
    {
        [tCell setLoading:YES];
        [self loadData];
    }
    else
    {
        __weak TargetsCell * tCell = (TargetsCell *)cell;
        [tCell setTag:indexPath.row];
        if (!tCell.delegate)
        {
            [tCell setDelegate:self];
        }
        User * user = [self.source objectAtIndex:indexPath.row];
        [tCell setLoading:NO];
        [tCell setBuyouts:user.successfulBuyoutsCount threats:user.matchedBuyoutsCount days:[DateUtility daysFromNow:user.registeredAt]];
        [[tCell name] setText:user.displayName];
        [tCell setEngageButtonState:EngageButtonDefaultState];
        if (user.identifier == [UserManager currentUserId])
            [tCell setEngageButtonState:EngageButtonHidden];
        else if (user.underBuyoutThreat)
            [tCell setEngageButtonState:EngageButtonUnderThreatState];
        else if (user.attackingCurrentUser)
            [tCell setEngageButtonState:EngageButtonAttackingYouState];
        [tCell.photo setUrl:user.profileImageUrl initials:user.initials compeltionHandler:^(UIImage * image)
         {
             if (cell.tag == indexPath.row)
             {
                 [tCell.photo setImage:image];
                 [tCell setNeedsLayout];
             }
         }];
        if (indexPath.row == [self.source count] - 1 && self.currentPage == NSUIntegerMax)
        {
            [tCell hideSep];
        }
    }
}

#pragma mark - TargetsBuyoutsCellDelegate

- (void)buttonTappedToEngageOnCell:(TargetsBuyoutsBaseCell *)cell
{
    CGRect frame = cell.frame;
    frame.origin.y += self.table.frame.origin.y;
    cell.frame = frame;
    [self.view addSubview:cell];
    void (^animations)() = ^()
    {
        CGRect frame = cell.frame;
        frame.origin.y = 20.0f;
        cell.frame = frame;
    };
    
    [UIView animateWithDuration:0.5f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:animations
                     completion:^(BOOL finished)
    {
        User * target = [self.source objectAtIndex:cell.tag];
        InitiateViewController * ivc = [[InitiateViewController alloc] init];
        [self addChildViewController:ivc];
        [self.view addSubview:ivc.view];
        [ivc setUser:target cellTag:cell.tag];
        [ivc setBackImageType:BackImageTypeTargets];
        [ivc setDelegate:self];
        [cell removeFromSuperview];
        [self.table reloadData];
    }];
}

#pragma mark - Load Data

- (void)loadData
{
    if (self.currentPage == NSUIntegerMax || loading)
    {
        return;
    }
    loading = YES;
    if ([self.source count] == 0)
    {
        iView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [iView setCenter:CGPointMake(self.table.frame.size.width / 2, self.table.frame.size.height / 2)];
        [self.table addSubview:iView];
        [self.table setScrollEnabled:NO];
        [iView startAnimating];
    }
    [ApiConnector getUsersWithPage:self.currentPage completion:^(NSArray * users, NSUInteger perPage, BOOL isLastPage, NSString * error) {
        loading = NO;
        [iView removeFromSuperview];
        [self.table setScrollEnabled:YES];
        if (!error)
        {
            NSMutableArray * filteredOfPlutocrat = [NSMutableArray arrayWithArray:users];
            __block User * plutocrat;
            [filteredOfPlutocrat enumerateObjectsUsingBlock:^(User * user, NSUInteger idx, BOOL * stop)
             {
                 if (user.isPlutocrat)
                 {
                     plutocrat = user;
                     *stop = YES;
                 }
             }];
            if (plutocrat)
            {
                [filteredOfPlutocrat removeObject:plutocrat];
                [self setPlutocrat:plutocrat];
            }
            else
            {
                [self noPlutocrat];
            }
            NSUInteger oldDataCount = [self.source count];
            [self.source addObjectsFromArray:filteredOfPlutocrat];
            NSUInteger startingIndex = self.currentPage == 1 ? 0 : 1;
            if (isLastPage)
            {
                self.currentPage = NSUIntegerMax;
            }
            else
            {
                self.currentPage++;
            }
            NSMutableArray * indexPathes = [NSMutableArray array];
            for (NSUInteger i = startingIndex; i < users.count; ++i)
            {
                NSIndexPath * newIndexPath = [NSIndexPath indexPathForRow:oldDataCount + i inSection:0];
                [indexPathes addObject:newIndexPath];
            }
            if (self.currentPage != NSUIntegerMax)
            {
                NSIndexPath * newIndexPath = [NSIndexPath indexPathForRow:oldDataCount + users.count inSection:0];
                [indexPathes addObject:newIndexPath];
            }
            [self.table insertRowsAtIndexPaths:indexPathes withRowAnimation:UITableViewRowAnimationNone];
            if (oldDataCount > 0)
            {
                [self.table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:oldDataCount inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
    }];
}

#pragma mark - InitiateViewControllerDelegate

- (void)initiateViewController:(InitiateViewController *)controller initiatedBuyoutAndShouldRefreshCellWithTag:(NSUInteger)tag
{
    [self.table reloadData];
}

- (void)noPlutocrat
{
    [self.header setType:TargetsHeaderNoPlutocrat];
}

- (void)setPlutocrat:(User *)plutocrat
{
    [self.header setType:TargetsHeaderWithPlutocrat];
    [self.header setImageUrl:plutocrat.profileImageUrl initials:plutocrat.initials];
    [self.header setName:plutocrat.displayName];
    [self.header setNumberOfBuyouts:plutocrat.successfulBuyoutsCount];
}

@end
