//
//  LeftPanelViewController.m
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-03.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import "LeftPanelViewController.h"

@interface LeftPanelViewController ()
{
    NSArray * labels;
}
@end

@implementation LeftPanelViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    labels = @[@"",
               NSLocalizedStringFromTable(@"ManageAccount", @"Labels", nil),
               NSLocalizedStringFromTable(@"FAQ", @"Labels", nil),
               NSLocalizedStringFromTable(@"SignOut", @"Labels", nil)];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"black_bg_texture"]]];
    
    UIImageView * logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    [logo setCenter:CGPointMake(self.view.bounds.size.width / 2 * 0.8f, 70.0f)];
    [self.view addSubview:logo];

    UITableView * table = [[UITableView alloc] initWithFrame:
                           CGRectMake(0.0f, 100.0f, self.view.bounds.size.width * 0.8f, 184.0f)
                                                       style:UITableViewStylePlain];
    [table setSeparatorInset:UIEdgeInsetsMake(0.0f,
                                              25.0f,
                                              0.0f,
                                              25.0f)];
    [table setSeparatorColor:[UIColor grayWithIntense:151.0f]];
    [table setBackgroundColor:[UIColor clearColor]];
    [table setDelegate:self];
    [table setDataSource:self];
    [table setScrollEnabled:NO];
    [self.view addSubview:table];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [labels count];
}

static NSString * identifier = @"LeftPanelCellIdentifier";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [[cell textLabel] setTextColor:[UIColor grayWithIntense:168.0f]];
        [[cell textLabel] setFont:[UIFont regularFontWithSize:16.0f]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[cell textLabel] setText:[labels objectAtIndex:indexPath.row]];
}

#pragma mark – Table view

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) return 2.0f;
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 1:
        {
            if ([self.delegate respondsToSelector:@selector(leftPanelViewController:shouldNavigateTo:)])
            {
                [self.delegate leftPanelViewController:self shouldNavigateTo:NavigateToAccount];
            }
        }
            break;
            
        case 2:
        {
            if ([self.delegate respondsToSelector:@selector(leftPanelViewController:shouldNavigateTo:)])
            {
                [self.delegate leftPanelViewController:self shouldNavigateTo:NavigateToFAQ];
            }
        }
            break;
            
        case 3:
        {
            if ([self.delegate respondsToSelector:@selector(leftPanelViewController:shouldNavigateTo:)])
            {
                [self.delegate leftPanelViewController:self shouldNavigateTo:NavigateToSignOut];
            }
        }
            break;
            
        default:
            break;
    }
}

@end
