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
    UILabel * noBuyouts;
}
@end

@implementation BuyoutsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    identifier = @"BuyoutsCell";
    
    [self.table registerClass:NSClassFromString(@"BuyoutsCell") forCellReuseIdentifier:identifier];

    noBuyouts = [[UILabel alloc] initWithFrame:
                 CGRectMake([Globals horizontalOffset],
                            self.view.frame.size.height / 2 - 40.0f,
                            self.view.frame.size.width - [Globals horizontalOffset] * 2,
                            80.0f)];
    [noBuyouts setTextAlignment:NSTextAlignmentCenter];
    [noBuyouts setFont:[UIFont regularFontWithSize:20.0f]];
    [noBuyouts setTextColor:[UIColor grayWithIntense:114.0f]];
    [noBuyouts setLineBreakMode:NSLineBreakByWordWrapping];
    [noBuyouts setNumberOfLines:0];
    [noBuyouts setText:NSLocalizedStringFromTable(@"NoBuyouts", @"Labels", nil])];
    [noBuyouts setHidden:YES];
    [self.view addSubview:noBuyouts];

    [self loadStatic];
    [self loadData];
}

#pragma mark - TableView

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
    Buyout * buyout = [self.source objectAtIndex:cell.tag];
    User * target = buyout.targetUser;
    InitiateViewController * ivc = [[InitiateViewController alloc] init];
    [self presentViewController:ivc animated:YES completion:^(){
        [ivc setUser:target cellTag:cell.tag];
        [ivc setBackImageType:BackImageTypeBuyouts];
        [ivc setDelegate:self];
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
    if ([self.source count] == 0 && !self.pulledToRefresh)
    {
        iView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [iView setCenter:CGPointMake(self.table.frame.size.width / 2, self.table.frame.size.height / 2)];
        [self.table addSubview:iView];
        [self.table setScrollEnabled:NO];
        [iView startAnimating];
    }
    [ApiConnector getBuyoutsWithPage:self.currentPage completion:^(NSArray * users, NSUInteger perPage, BOOL isLastPage, NSString * error) {
        if (self.pulledToRefresh)
        {
            self.pulledToRefresh = NO;
            [self.refreshControl endRefreshing];
            self.source = [NSMutableArray new];
            self.currentPage = 1;
            [self.table reloadData];
        }
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
        [noBuyouts setHidden:(self.source.count != 0)];
    }];
}

#pragma mark - InitiateViewControllerDelegate

- (void)initiateViewController:(InitiateViewController *)controller initiatedBuyoutAndShouldRefreshCellWithTag:(NSUInteger)tag
{
    [self updateOnPush];
}

@end
