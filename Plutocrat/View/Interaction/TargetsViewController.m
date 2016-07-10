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
    BOOL setNoPlutocrat;
    UIActivityIndicatorView * iView;
    User * pluto;
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

#pragma mark - TableView

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
    User * target = [self.source objectAtIndex:cell.tag];
    InitiateViewController * ivc = [[InitiateViewController alloc] init];
    [self presentViewController:ivc animated:YES completion:^(){
        [ivc setUser:target cellTag:cell.tag];
        [ivc setBackImageType:BackImageTypeTargets];
        [ivc setDelegate:self];
    }];
}

#pragma mark - Header delegate

- (void)buttonTappedToEngage
{
    InitiateViewController * ivc = [[InitiateViewController alloc] init];
    [self presentViewController:ivc animated:YES completion:^(){
        [ivc setUser:pluto cellTag:-1];
        [ivc setBackImageType:BackImageTypeTargets];
        [ivc setDelegate:self];
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
    if ([self.source count] == 0 && !self.pulledToRefresh)
    {
        iView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [iView setCenter:CGPointMake(self.table.frame.size.width / 2, self.table.frame.size.height / 2)];
        [self.table addSubview:iView];
        [self.table setScrollEnabled:NO];
        [iView startAnimating];
    }
    [ApiConnector getUsersWithPage:self.currentPage completion:^(NSArray * users, NSUInteger perPage, BOOL isLastPage, NSString * error) {
        if (self.pulledToRefresh)
        {
            self.pulledToRefresh = NO;
            [self.refreshControl endRefreshing];
            self.source = [NSMutableArray new];
            [self.table reloadData];
        }
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
                [self setPlutocrat:plutocrat];
                [filteredOfPlutocrat removeObject:plutocrat];
            }
            else
            {
                [self noPlutocrat];
            }
            [filteredOfPlutocrat sortUsingComparator:^NSComparisonResult(User * first, User * second ) {
                if (first.successfulBuyoutsCount > second.successfulBuyoutsCount)
                {
                    return NSOrderedAscending;
                }
                else if (first.successfulBuyoutsCount < second.successfulBuyoutsCount)
                {
                    return NSOrderedDescending;
                }
                else
                {
                    return [first.displayName compare:second.displayName];
                }
            }];
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
            for (NSUInteger i = startingIndex; i < filteredOfPlutocrat.count; ++i)
            {
                NSIndexPath * newIndexPath = [NSIndexPath indexPathForRow:oldDataCount + i inSection:0];
                [indexPathes addObject:newIndexPath];
            }
            if (self.currentPage != NSUIntegerMax && filteredOfPlutocrat.count > 0)
            {
                NSIndexPath * newIndexPath = [NSIndexPath indexPathForRow:oldDataCount + filteredOfPlutocrat.count inSection:0];
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
    User * user;
    if (tag == -1)
    {
        user = pluto;
        user.underBuyoutThreat = YES;
        [self setPlutocrat:user];
    }
    else
    {
        user = [self.source objectAtIndex:tag];
        user.underBuyoutThreat = YES;
        [self.table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:tag inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
    if ([self.delegate respondsToSelector:@selector(targetsBuyoutsViewControllerShouldUpdateBuyouts:)])
    {
        [self.delegate targetsBuyoutsViewControllerShouldUpdateBuyouts:self];
    }
}

#pragma mark - Plutocrat

- (void)noPlutocrat
{
    if (setNoPlutocrat) return;
    setNoPlutocrat = YES;
    [self.header setType:TargetsHeaderNoPlutocrat];
}

- (void)setPlutocrat:(User *)plutocrat
{
    TargetsBuyoutsHeaderType type = TargetsHeaderWithPlutocrat;
    if (plutocrat.underBuyoutThreat)
    {
        type = TargetsHeaderWithPlutocratUnderThreat;
    }
    if (plutocrat.attackingCurrentUser)
    {
        type = TargetsHeaderWithPlutocratAttackingYou;
    }
    [self.header setType:type];
    [self.header setImageUrl:plutocrat.profileImageUrl initials:plutocrat.initials];
    [self.header setName:plutocrat.displayName];
    [self.header setNumberOfBuyouts:plutocrat.successfulBuyoutsCount];
    [self.header setDelegate:self];
    pluto = plutocrat;
}

@end
