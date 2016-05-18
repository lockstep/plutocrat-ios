//
//  TargetsViewController.m
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-17.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import "TargetsViewController.h"
#import "TargetsCell.h"

@interface TargetsViewController ()
{
    NSString * identifier;
}
@end

@implementation TargetsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    identifier = @"TargetsCell";
    
    [self.table registerClass:NSClassFromString(@"TargetsCell") forCellReuseIdentifier:identifier];
        
    [self stub2];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TargetsCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    TargetsCell * tCell = (TargetsCell *)cell;
    [[tCell photo] setImage:[UIImage imageNamed:[self.source objectAtIndex:indexPath.row]]];
    [[tCell name] setText:[self.source objectAtIndex:indexPath.row]];
    
    [self stubCell:tCell];
}

#pragma mark - stub

- (void)stub1
{
    [self.header setType:TargetsHeaderNoPlutocrat];
}

- (void)stub2
{
    [self.header setType:TargetsHeaderWithPlutocrat];
    [self.header setImage:[UIImage imageNamed:@"me"]];
    [self.header setName:@"Pavel Dolgov"];
    [self.header setNumberOfBuyouts:35];
}

- (void)stubCell:(TargetsCell *)cell
{
    int rndValue1 = arc4random() % 30;
    int rndValue2 = arc4random() % 15;
    int rndValue3 = arc4random() % 120;
    int rndValue4 = arc4random() % 2;
    [cell setBuyouts:rndValue1 threats:rndValue2 days:rndValue3];
    [cell setEngageButtonState:rndValue4];
}

@end
