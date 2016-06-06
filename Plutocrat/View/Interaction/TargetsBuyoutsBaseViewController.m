//
//  TargetsBuyoutsBaseViewController.m
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-17.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import "TargetsBuyoutsBaseViewController.h"
#import "InitiateViewController.h"

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
    [self.header setDelegate:self];
    [self.view addSubview:self.header];
    
    self.table = [[UITableView alloc] initWithFrame:
                  CGRectMake(0.0f,
                             self.header.frame.size.height,
                             self.view.bounds.size.width,
                             self.view.bounds.size.height - self.header.frame.size.height - [Globals tabBarHeight])];
    [self.table setDelegate:self];
    [self.table setDataSource:self];
    [self.table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.table];
    
    [self stub];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.source count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark – Table view

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [Globals cellHeight];
}

#pragma mark - TargetsBuyotsHeaderDelegate

- (void)buttonTappedToEngage
{
    InitiateViewController * ivc = [[InitiateViewController alloc] init];
    [self addChildViewController:ivc];
    [self.view addSubview:ivc.view];
}

#pragma mark - global stub

- (void)stub
{
    self.source = @[@"Aaron Pinchai", @"Sara Mayer", @"Peter Cook", @"M. Dorsey"];
    [self.table reloadData];
}

@end
