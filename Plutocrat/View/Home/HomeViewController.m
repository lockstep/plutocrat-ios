//
//  HomeViewController.m
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-03.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeHeader.h"
#import "BigUserView.h"
#import "BuyoutsStatsView.h"
#import "AttackerView.h"

@interface HomeViewController ()
{
    UIScrollView * view;
    HomeHeader * homeHeader;
    BigUserView * bigUserView;
    BuyoutsStatsView * buyoutsStatsView;
    UITextView * tapHere;
    AttackerView * attackerView;
    UILabel * youWereBoughtOut;
    NSUInteger tapCount;
}
@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    homeHeader = [[HomeHeader alloc] initWithFrame:CGRectMake(0.0f,
                                                              0.0f,
                                                              self.view.bounds.size.width,
                                                              124.0f)];
    [self.view addSubview:homeHeader];
    
    view = [[UIScrollView alloc] initWithFrame:
            CGRectMake(0.0f,
                       homeHeader.frame.size.height,
                       self.view.bounds.size.width,
                       self.view.bounds.size.height - homeHeader.frame.size.height)];
    [view setContentSize:CGSizeMake(view.bounds.size.width, view.bounds.size.height + 1.0f)];
    [self.view addSubview:view];
    
    CGFloat curY = 0.0f;
    bigUserView = [[BigUserView alloc] initWithFrame:CGRectMake(0.0f,
                                                                0.0f,
                                                                self.view.bounds.size.width,
                                                                136.0f)];
    [view addSubview:bigUserView];
    curY += bigUserView.frame.size.height;
    
    buyoutsStatsView = [[BuyoutsStatsView alloc] initWithFrame:CGRectMake(0.0f,
                                                                          curY,
                                                                          self.view.bounds.size.width,
                                                                          136.0f)];
    [buyoutsStatsView setHidden:YES];
    [view addSubview:buyoutsStatsView];
    curY += buyoutsStatsView.frame.size.height;
    
    UIFont * smallFont = [UIFont snFontWithSize:12.0f];
    UIColor * paleGray = [UIColor grayWithIntense:168.0f];

    tapHere = [[UITextView alloc] initWithFrame:
               CGRectMake(0.0f,
                          curY + (self.view.bounds.size.height - 396.0f - 80.0f - 40.0f) / 2,
                          self.view.bounds.size.width,
                          80.0f)];
    [tapHere setEditable:NO];
    [tapHere setSelectable:NO];
    [tapHere setHidden:YES];
    [view addSubview:tapHere];

    
    attackerView = [[AttackerView alloc] initWithFrame:CGRectMake(0.0f,
                                                                  0.0f,
                                                                  self.view.bounds.size.width,
                                                                  270.0f)];
    [attackerView setHidden:YES];
    [view addSubview:attackerView];
    curY = attackerView.frame.size.height;
    
    youWereBoughtOut = [[UILabel alloc] initWithFrame:
                        CGRectMake(0.0f,
                                   curY + (self.view.bounds.size.height - 396.0f - 50.0f - 40.0f) / 2,
                                   self.view.bounds.size.width,
                                   50.0f)];
    [youWereBoughtOut setHidden:YES];
    [youWereBoughtOut setFont:smallFont];
    [youWereBoughtOut setTextColor:paleGray];
    [youWereBoughtOut setTextAlignment:NSTextAlignmentCenter];
    [youWereBoughtOut setNumberOfLines:0];
    [youWereBoughtOut setLineBreakMode:NSLineBreakByWordWrapping];
    [view addSubview:youWereBoughtOut];
    
    
    UIButton * but = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [but addTarget:self action:@selector(change) forControlEvents:UIControlEventTouchUpInside];
    [but setCenter:CGPointMake(30.0f, 30.0f)];
    [but setAlpha:0.1f];
    [homeHeader addSubview:but];
    tapCount = 1;
    [self stub1];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - stub

- (void)change
{
    if (tapCount == 3)
    {
        tapCount = 1;
        [self stub1];
        return;
    }
    if (tapCount == 1)
    {
        tapCount = 2;
        [self stub2];
        return;
    }
    if (tapCount == 2)
    {
        tapCount = 3;
        [self stub3];
        return;
    }
}

- (void)stub1
{
    [homeHeader setType:HomeHeaderTypeCommon];
    [homeHeader setDate:[NSDate dateWithTimeInterval:-127526 sinceDate:[NSDate date]]];
    [bigUserView fillStub1];
    [bigUserView setFrame:CGRectMake(bigUserView.frame.origin.x,
                                     0.0f,
                                     bigUserView.frame.size.width,
                                     bigUserView.frame.size.height)];
    
    UIFont * smallFont = [UIFont snFontWithSize:10.0f];
    UIColor * paleGray = [UIColor grayWithIntense:168.0f];
    UIColor * coloredViolet = [UIColor colorWithRed:65.0f / 255.0f
                                              green:12.0f / 255.0f
                                               blue:91.0f / 255.0f
                                              alpha:1.0f];
    NSDictionary * baseAttrs = @{NSFontAttributeName:smallFont,
                                 NSForegroundColorAttributeName:paleGray};
    
    NSString * tapHereStr = [NSString stringWithFormat:
                             NSLocalizedStringFromTable(@"TapHere", @"Texts", nil), 4];
    
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithString:tapHereStr attributes:baseAttrs];
    
    NSString * stringToColor1 = NSLocalizedStringFromTable(@"TapHereColored1", @"Texts", nil);
    NSString * stringToColor2 = [NSString stringWithFormat:
                                 NSLocalizedStringFromTable(@"TapHereColored2", @"Texts", nil), 4];
    NSString * stringToColor3 = NSLocalizedStringFromTable(@"TapHereColored3", @"Texts", nil);
    
    NSArray * arr = @[stringToColor1, stringToColor2, stringToColor3];
    
    for (int i = 0; i < 3; ++i)
    {
        NSDictionary * subAttrs = @{NSFontAttributeName:smallFont,
                                    NSForegroundColorAttributeName:coloredViolet};
        const NSRange range = [tapHereStr rangeOfString:[arr objectAtIndex:i]];
        [attrStr setAttributes:subAttrs range:range];
    }
    [tapHere setAttributedText:attrStr];
    [tapHere setTextAlignment:NSTextAlignmentCenter];
    [tapHere setHidden:NO];
    [buyoutsStatsView setHidden:NO];
    [attackerView setHidden:YES];
    [youWereBoughtOut setHidden:YES];
}

- (void)stub2
{
    [homeHeader setType:HomeHeaderTypeThreated];
    [homeHeader setDate:[NSDate dateWithTimeInterval:-127526 sinceDate:[NSDate date]]];
    [bigUserView fillStub1];
    [bigUserView setFrame:CGRectMake(bigUserView.frame.origin.x,
                                     270.0f,
                                     bigUserView.frame.size.width,
                                     bigUserView.frame.size.height)];
    [tapHere setHidden:YES];
    [buyoutsStatsView setHidden:YES];
    [attackerView setHidden:NO];
    [youWereBoughtOut setHidden:YES];
}

- (void)stub3
{
    [homeHeader setType:HomeHeaderTypeDefeated];
    [homeHeader setDate:[NSDate dateWithTimeInterval:-127526 sinceDate:[NSDate date]]];
    [bigUserView fillStub1];
    [bigUserView setFrame:CGRectMake(bigUserView.frame.origin.x,
                                     0.0f,
                                     bigUserView.frame.size.width,
                                     bigUserView.frame.size.height)];
    [tapHere setHidden:YES];
    [buyoutsStatsView setHidden:NO];
    [attackerView setHidden:YES];
    [youWereBoughtOut setHidden:NO];
    [youWereBoughtOut setText:
     [NSString stringWithFormat:NSLocalizedStringFromTable(@"YourWereBoughtOut", @"Texts", nil),
                               @"Aaron Pinchai", 32, 4]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
