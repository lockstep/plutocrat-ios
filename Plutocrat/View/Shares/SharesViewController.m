//
//  SharesViewController.m
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-03.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import "SharesViewController.h"
#import "SharesHeader.h"

@interface SharesViewController ()
{
    SharesHeader * header;
    UITableView * table;
    NSArray * source;
}
@end

@implementation SharesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    header = [[SharesHeader alloc] initWithFrame:CGRectMake(0.0f,
                                                            0.0f,
                                                            self.view.bounds.size.width,
                                                            [Globals cellHeight] + 20.0f)];
    [self.view addSubview:header];

    table = [[UITableView alloc] initWithFrame:
             CGRectMake(0.0f,
                        header.frame.size.height,
                        self.view.bounds.size.width,
                        self.view.bounds.size.height - header.frame.size.height - 48.0f)
                                         style:UITableViewStylePlain];
    [table setDelegate:self];
    [table setDataSource:self];
    [table setSeparatorColor:[UIColor grayWithIntense:222.0f]];
    [table setSeparatorInset:UIEdgeInsetsMake(0.0f,
                                              [Globals horizontalOffsetInTable],
                                              0.0f,
                                              [Globals horizontalOffsetInTable])];
    [self.view addSubview:table];
    
    [self stub];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [source count];
}

static NSString * identifier = @"SharesCellIdentifier";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SharesTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[SharesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self stubCell:(SharesTableViewCell *)cell onIndexPath:indexPath];
}

#pragma mark – Table view

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [Globals cellHeight];
}

#pragma mark - stub

- (void)stub
{
    [header setNumberOfShares:12];
    source = @[@1, @5, @10, @50];
    [table reloadData];
}

- (void)stubCell:(SharesTableViewCell *)cell onIndexPath:(NSIndexPath *)indexPath
{
    NSArray * prices = @[@25, @125, @200, @750];
    NSArray * amts = @[@(SharesAmountFew), @(SharesAmountAverage), @(SharesAmountAverage), @(SharesAmountMany)];
    NSUInteger shares = [[source objectAtIndex:indexPath.row] integerValue];
    NSUInteger price = [[prices objectAtIndex:indexPath.row] integerValue];
    NSUInteger visualAmount = [[amts objectAtIndex:indexPath.row] integerValue];
    [cell setShares:shares price:price visualAmount:visualAmount];
}

@end
