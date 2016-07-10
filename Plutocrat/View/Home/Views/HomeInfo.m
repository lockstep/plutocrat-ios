//
//  HomeInfo.m
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-06-02.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import "HomeInfo.h"
#import "CommonButton.h"

@implementation HomeInfo
{
    UILabel * gettingStarted;
    UILabel * info;
    CommonButton * find;
    CommonButton * enable;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIColor * darkGray = [UIColor grayWithIntense:128.0f];
        
        gettingStarted = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, frame.size.width, 20.0f)];
        [gettingStarted setFont:[UIFont regularFontWithSize:18.0f]];
        [gettingStarted setTextColor:darkGray];
        [gettingStarted setTextAlignment:NSTextAlignmentCenter];
        [gettingStarted setText:NSLocalizedStringFromTable(@"GettingStarted", @"Labels", nil)];
        [gettingStarted setHidden:YES];
        [self addSubview:gettingStarted];
        
        info = [[UILabel alloc] initWithFrame:
                CGRectMake([Globals horizontalOffset],
                           25.0f,
                           frame.size.width - [Globals horizontalOffset] * 2,
                           60.0f)];
        [info setLineBreakMode:NSLineBreakByWordWrapping];
        [info setNumberOfLines:0];
        [info setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:info];
        
        find = [CommonButton buttonWithText:NSLocalizedStringFromTable(@"FINDTARGET", @"Buttons", nil)
                                      color:ButtonColorViolet];
        [find setCenter:CGPointMake(frame.size.width / 2, 105.0f)];
        [find setHidden:YES];
        [find addTarget:self action:@selector(findTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:find];
        
        enable = [CommonButton buttonWithText:NSLocalizedStringFromTable(@"ENABLENOTIFICATIONS", @"Buttons", nil) color:ButtonColorViolet];
        [enable setCenter:CGPointMake(frame.size.width / 2, 105.0f)];
        [enable setHidden:YES];
        [enable addTarget:self action:@selector(enableTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:enable];
        
    }
    return self;
}

#pragma mark - buttons

- (void)findTapped
{
    if ([self.delegate respondsToSelector:@selector(homeInfoShouldNavigateToTargets:)])
    {
        [self.delegate homeInfoShouldNavigateToTargets:self];
    }
}

- (void)enableTapped
{
    if ([self.delegate respondsToSelector:@selector(homeInfoShouldEnablePushes:)])
    {
        [self.delegate homeInfoShouldEnablePushes:self];
    }
}

#pragma mark - public

- (void)setType:(HomeInfoType)type
{
    UIColor * darkGray = [UIColor grayWithIntense:128.0f];
    UIColor * paleGray = [UIColor grayWithIntense:168.0f];
    UIFont * bigFont = [UIFont regularFontWithSize:15.0f];
    UIFont * smallFont = [UIFont regularFontWithSize:14.0f];
    
    switch (type)
    {
        case HomeInfoTypeFind:
            [gettingStarted setHidden:NO];
            [info setTextColor:darkGray];
            [info setFont:bigFont];
            [info setText:NSLocalizedStringFromTable(@"ToFindTip", @"Texts", nil)];
            [find setHidden:NO];
            [enable setHidden:YES];
            break;
            
        case HomeInfoTypePush:
            [gettingStarted setHidden:NO];
            [info setTextColor:darkGray];
            [info setFont:bigFont];
            [info setText:NSLocalizedStringFromTable(@"ToEnableTip", @"Texts", nil)];
            [find setHidden:YES];
            [enable setHidden:NO];
            break;
            
        case HomeInfoTypeCommon:
            [gettingStarted setHidden:YES];
            [info setTextColor:paleGray];
            [info setFont:smallFont];
            [find setHidden:YES];
            [enable setHidden:YES];
            break;
            
        case HomeInfoTypeDefeated:
            [gettingStarted setHidden:YES];
            [info setTextColor:paleGray];
            [info setFont:bigFont];
            [find setHidden:YES];
            [enable setHidden:YES];
            break;
            
        default:
            break;
    }
}

- (void)setBuyouts:(NSUInteger)buyouts
{
    [info setText:[NSString stringWithFormat:NSLocalizedStringFromTable(@"YouNeedMore", @"Texts", nil), buyouts]];
}

- (void)setName:(NSString *)name shares:(NSUInteger)shares timeAgo:(NSString *)timeAgo
{
    [info setText:[NSString stringWithFormat:NSLocalizedStringFromTable(@"YourWereBoughtOut", @"Texts", nil), name, shares, timeAgo]];
}

@end
