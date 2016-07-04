//
//  TargetsBuyoutsBaseViewController.m
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-17.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import "TargetsBuyoutsBaseViewController.h"
#import "InitiateViewController.h"
#import "TargetsBuyoutsBaseCell.h"

@interface TargetsBuyoutsBaseViewController ()
{
    
}
@end

@implementation TargetsBuyoutsBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.header = [[TargetsBuyoutsHeader alloc] initWithFrame:
              CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, [Globals headerHeight])];
    [self.view addSubview:self.header];

    self.source = [NSMutableArray new];
    self.currentPage = 1;
    
    self.table = [[UITableView alloc] initWithFrame:
                  CGRectMake(0.0f,
                             self.header.frame.size.height,
                             self.view.bounds.size.width,
                             self.view.bounds.size.height - self.header.frame.size.height - [Globals tabBarHeight])];
    [self.table setDelegate:self];
    [self.table setDataSource:self];
    [self.table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.table];

    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(handleRefresh) forControlEvents:UIControlEventValueChanged];
    [self.table addSubview:self.refreshControl];
}


#pragma mark - public

- (void)updateOnPush
{
    self.source = [NSMutableArray new];
    [self.table reloadData];
    self.currentPage = 1;
    [self loadData];
}

#pragma mark - refresh

- (void)handleRefresh
{
    self.pulledToRefresh = YES;
    [self loadData];
}

- (void)loadData
{
    NSAssert(NO, @"Must be overrided");
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.source count] == 0) return 0;
    NSUInteger extraRow = (self.currentPage == NSUIntegerMax) ? 0 : 1;
    return [self.source count] + extraRow;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSAssert(false, @"Should be overrided");
    return [UITableViewCell new];
}

#pragma mark – Table view

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [Globals cellHeight];
}

#pragma mark - Engage

- (void)buttonTappedToEngage
{
    
}

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
                         InitiateViewController * ivc = [[InitiateViewController alloc] init];
                         [self addChildViewController:ivc];
                         [self.view addSubview:ivc.view];
                         [cell removeFromSuperview];
                         [self.table reloadData];
                     }];
}

@end
