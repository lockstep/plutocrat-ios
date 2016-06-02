//
//  InitiateViewController.m
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-20.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import "InitiateViewController.h"
#import "SelectShares.h"
#import "CommonButton.h"

@interface InitiateViewController ()
{
    TargetsBuyoutsHeader * header;
    UIImageView * anotherBack;
    TargetsCell * anotherHeader;
    SelectShares * selectShares;
}
@end

@implementation InitiateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    header = [[TargetsBuyoutsHeader alloc] initWithFrame:
              CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, [Globals cellHeight] + 20.0f)];
    [header setHidden:YES];
    [header setDelegate:self];
    [self.view addSubview:header];
    
    anotherBack = [[UIImageView alloc] initWithFrame:header.frame];
    [anotherBack setHidden:YES];
    [self.view addSubview:anotherBack];
    
    anotherHeader = [[TargetsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [anotherHeader setFrame:CGRectMake(0.0f, 20.0f, self.view.bounds.size.width, [Globals cellHeight])];
    [anotherHeader setBackgroundColor:[UIColor whiteColor]];
    [anotherHeader setDelegate:self];
    [anotherHeader setHidden:YES];
    [self.view addSubview:anotherHeader];
    
    UIScrollView * view = [[UIScrollView alloc] initWithFrame:
                           CGRectMake(0.0f,
                                      header.frame.size.height,
                                      self.view.bounds.size.width,
                                      self.view.bounds.size.height - header.frame.size.height - [Globals tabBarHeight])];
    [view setContentSize:CGSizeMake(view.frame.size.width, view.frame.size.height + 1.0f)];
    [self.view addSubview:view];
    
    selectShares = [[SelectShares alloc] initWithFrame:
                    CGRectMake(0.0f,
                               0.0f,
                               self.view.bounds.size.width,
                               300.0f)];
    [view addSubview:selectShares];
    
    CommonButton * abort = [CommonButton smallButtonWithColor:ButtonColorGray];
    [abort setText:NSLocalizedStringFromTable(@"ABORT", @"Buttons", nil)];
    [abort setCenter:CGPointMake([Globals horizontalOffsetInTable] + abort.frame.size.width / 2, selectShares.frame.size.height + abort.frame.size.height / 2 + 40.0f)];
    [abort addTarget:self action:@selector(abortTapped) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:abort];
    
    CommonButton * execute = [CommonButton smallButtonWithColor:ButtonColorViolet];
    [execute setText:NSLocalizedStringFromTable(@"EXECUTE", @"Buttons", nil)];
    [execute setCenter:CGPointMake(self.view.bounds.size.width - [Globals horizontalOffsetInTable] - execute.frame.size.width / 2, selectShares.frame.size.height + execute.frame.size.height / 2 + 40.0f)];
    [execute addTarget:self action:@selector(executeTapped) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:execute];
 
    [self stub2];
}

- (void)setBackImageType:(BackImageType)type
{
    switch (type)
    {
        case BackImageTypeTargets:
            [anotherBack setImage:[UIImage imageNamed:@"Background-blue"]];
            break;
            
        case BackImageTypeBuyouts:
            [anotherBack setImage:[UIImage imageNamed:@"Background-gray"]];
            break;
            
        default:
            break;
    }
}

#pragma mark - Buttons

- (void)abortTapped
{
    [self exit];
}

- (void)executeTapped
{
    [self exit];
}

#pragma mark - TargetsBuyotsHeaderDelegate

- (void)buttonTappedToEngage:(BOOL)toEngage
{
    if (!toEngage)
    {
        [self exit];
    }
}

#pragma mark - TargetsBuyoutsCellDelegate

- (void)buttonTappedToEngage:(BOOL)toEngage onCell:(TargetsBuyoutsBaseCell *)cell
{
    if (!toEngage)
    {
        [self exit];
    }
}

#pragma mark - stub

- (void)stubName:(NSString *)name
{
    [header setHidden:YES];
    [anotherBack setHidden:NO];
    [anotherHeader setHidden:NO];
    [[anotherHeader photo] setImage:[UIImage imageNamed:name]];
    [[anotherHeader name] setText:name];
    [anotherHeader setEngageButtonState:EngageButtonToAbortState];
    [self stubCell:anotherHeader];
}

- (void)stub2
{
    [header setHidden:NO];
    [header setType:TargetsHeaderWithPlutocrat];
    [header setImage:[UIImage imageNamed:@"me"]];
    [header setName:@"Pavel Dolgov"];
    [header setNumberOfBuyouts:35];
    [header setButtonToEngageState:NO];
    [anotherBack setHidden:YES];
    [anotherHeader setHidden:YES];
    [selectShares setMin:12 value:12 max:23];
}

- (void)stubCell:(TargetsCell *)cell
{
    int rndValue1 = arc4random() % 30;
    int rndValue2 = arc4random() % 15;
    int rndValue3 = arc4random() % 120;
    [cell setBuyouts:rndValue1 threats:rndValue2 days:rndValue3];
}

- (void)exit
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

@end
