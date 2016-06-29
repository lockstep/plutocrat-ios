//
//  BuyoutsViewController.m
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-17.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import "BuyoutsViewController.h"
#import "InitiateViewController.h"
#import "UserManager.h"
#import "Buyout.h"
#import "ApiConnector.h"

@interface BuyoutsViewController ()
{
    NSString * identifier;
    BOOL loading;
    UIActivityIndicatorView * iView;
}
@end

@implementation BuyoutsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    identifier = @"BuyoutsCell";
    
    [self.table registerClass:NSClassFromString(@"BuyoutsCell") forCellReuseIdentifier:identifier];
    
    [self loadStatic];
    [self loadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BuyoutsCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.tag = indexPath.row;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    BuyoutsCell * bCell = (BuyoutsCell *)cell;
    if (indexPath.row == [self.source count] && self.currentPage != NSUIntegerMax)
    {
        [bCell setLoading:YES];
        [self loadData];
    }
    else
    {
        __weak BuyoutsCell * bCell = (BuyoutsCell *)cell;
        [bCell setTag:indexPath.row];
        if (!bCell.delegate)
        {
            [bCell setDelegate:self];
        }
        Buyout * buyout  = [self.source objectAtIndex:indexPath.row];
        [bCell setLoading:NO];
        BuyoutCellState state = BuyoutCellIncomingState;
        if (buyout.state == BuyoutStateMatched || buyout.state == BuyoutStateInitiated)
        {
            if (buyout.targetUser.identifier == [UserManager currentUserId])
            {
                if (buyout.state == BuyoutStateMatched)
                {
                    state = BuyoutCellHeFailedState;
                    if (buyout.initiatingUser.underBuyoutThreat) [bCell setEngageButtonState:EngageButtonUnderThreatState];
                }
                else
                {
                    state = BuyoutCellIncomingState;
                    [bCell setEngageButtonState:EngageButtonAttackingYouState];
                }
                [[bCell name] setText:buyout.initiatingUser.displayName];
                [bCell.photo setUrl:buyout.initiatingUser.profileImageUrl initials:buyout.initiatingUser.initials compeltionHandler:^(UIImage * image)
                 {
                     if (cell.tag == indexPath.row)
                     {
                         [bCell.photo setImage:image];
                         [bCell setNeedsLayout];
                     }
                 }];
            }
            else
            {
                if (buyout.state == BuyoutStateMatched)
                {
                    state = BuyoutCellYouFailedState;
                    if (buyout.targetUser.attackingCurrentUser)
                    {
                        [bCell setEngageButtonState:EngageButtonAttackingYouState];
                    }
                    else if (buyout.targetUser.underBuyoutThreat)
                    {
                        [bCell setEngageButtonState:EngageButtonUnderThreatState];
                    }
                    else if (buyout.targetUser.defeatedAt)
                    {
                        [bCell setEngageButtonState:EngageButtonEliminatedState];
                    }
                    else
                    {
                        [bCell setEngageButtonState:EngageButtonDefaultState];
                    }
                }
                else
                {
                    state = BuyoutCellOutcomingState;
                    [bCell setEngageButtonState:EngageButtonUnderThreatState];
                }
                [[bCell name] setText:buyout.targetUser.displayName];
                [bCell.photo setUrl:buyout.targetUser.profileImageUrl initials:buyout.targetUser.initials compeltionHandler:^(UIImage * image)
                 {
                     if (cell.tag == indexPath.row)
                     {
                         [bCell.photo setImage:image];
                         [bCell setNeedsLayout];
                     }
                 }];

            }
        }
        else if (buyout.state == BuyoutStateSucceeded)
        {
            [bCell setEngageButtonState:EngageButtonEliminatedState];
            state = BuyoutCellSuccessedState;
            [[bCell name] setText:buyout.targetUser.displayName];
            [bCell.photo setUrl:buyout.targetUser.profileImageUrl initials:buyout.targetUser.initials compeltionHandler:^(UIImage * image)
             {
                 if (cell.tag == indexPath.row)
                 {
                     [bCell.photo setImage:image];
                     [bCell setNeedsLayout];
                 }
             }];
        }
        NSString * timeAgo = buyout.resolvedAt ? buyout.resolvedTimeAgo : buyout.initiatedTimeAgo;
        [bCell setShares:buyout.numberOfShares timeAgo:timeAgo state:state];
        if (indexPath.row == [self.source count] - 1 && self.currentPage == NSUIntegerMax)
        {
            [bCell hideSep];
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
    void (^animations)() = ^() {
        CGRect frame = cell.frame;
        frame.origin.y = 20.0f;
        cell.frame = frame;
    };

    [UIView animateWithDuration:0.5f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:animations
                     completion:^(BOOL finished){
                         User * target = [self.source objectAtIndex:cell.tag];
                         InitiateViewController * ivc = [[InitiateViewController alloc] init];
                         [self addChildViewController:ivc];
                         [self.view addSubview:ivc.view];
                         [ivc setUser:target cellTag:cell.tag];
                         [ivc setBackImageType:BackImageTypeBuyouts];
                         [ivc setDelegate:self];
                         [cell removeFromSuperview];
                         [self.table reloadData];
                     }];
}

#pragma mark - Load Data

- (void)loadStatic
{
    [self.header setType:BuyoutsHeader];
    [self.header setNumberOfBuyouts:[UserManager successfulBuyouts]];
}

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
    [ApiConnector getBuyoutsWithPage:self.currentPage completion:^(NSArray * users, NSUInteger perPage, BOOL isLastPage, NSString * error) {
        loading = NO;
        [iView removeFromSuperview];
        [self.table setScrollEnabled:YES];
        if (!error)
        {
            NSUInteger oldDataCount = [self.source count];
            [self.source addObjectsFromArray:users];
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
            if (self.currentPage != NSUIntegerMax && users.count > 0)
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

@end
