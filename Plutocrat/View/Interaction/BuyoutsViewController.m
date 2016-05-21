//
//  BuyoutsViewController.m
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-17.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import "BuyoutsViewController.h"
#import "InitiateViewController.h"

@interface BuyoutsViewController ()
{
    NSString * identifier;
}
@end

@implementation BuyoutsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    identifier = @"BuyoutsCell";
    
    [self.table registerClass:NSClassFromString(@"BuyoutsCell") forCellReuseIdentifier:identifier];
    
    [self stub1];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BuyoutsCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    BuyoutsCell * bCell = (BuyoutsCell *)cell;
    [[bCell photo] setImage:[UIImage imageNamed:[self.source objectAtIndex:indexPath.row]]];
    [[bCell name] setText:[self.source objectAtIndex:indexPath.row]];
    [bCell setTag:indexPath.row];
    if (!bCell.delegate)
    {
        [bCell setDelegate:self];
    }
    [self stubCell:bCell];
}

#pragma mark - TargetsBuyoutsCellDelegate

- (void)buttonTappedToEngage:(BOOL)toEngage onCell:(TargetsBuyoutsBaseCell *)cell
{
    if (toEngage)
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
                             InitiateViewController * ivc = [[InitiateViewController alloc] init];
                             [self addChildViewController:ivc];
                             [self.view addSubview:ivc.view];
                             [ivc stubName:[self.source objectAtIndex:cell.tag]];
                             [ivc setBackImageType:BackImageTypeBuyouts];
                             [cell removeFromSuperview];
                             [self.table reloadData];
                         }];
    }
}

#pragma mark - stub

- (void)stub1
{
    [self.header setType:BuyoutsHeader];
    [self.header setNumberOfBuyouts:32];
}

- (void)stubCell:(BuyoutsCell *)cell
{
    int rndValue1 = arc4random() % 50;
    int rndValue2 = arc4random() % 2;
    BuyoutCellState rndValue3 = arc4random() % 4;
    [cell setShares:rndValue1 time:rndValue2 state:rndValue3];
    switch (rndValue3)
    {
        case BuyoutCellDefaultState:
            [cell setEngageButtonState:EngageButtonAttackingYouState];
            break;
            
        case BuyoutCellSuccessedState:
            [cell setEngageButtonState:EngageButtonEliminatedState];
            break;
            
        case BuyoutCellYouFailedState:
            [cell setEngageButtonState:EngageButtonDefaultState];
            break;
            
        case BuyoutCellHeFailed:
            [cell setEngageButtonState:EngageButtonDefaultState];
            break;
            
        default:
            break;
    }
}

@end
