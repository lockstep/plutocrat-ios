//
//  SelectShares.m
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-20.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import "SelectShares.h"
#import "CommonSeparator.h"

@implementation SelectShares
{
    UILabel * shares;
    UILabel * minimumBuyout;
    UILabel * availableShares;
    NSUInteger minimumValue;
    NSUInteger currentValue;
    NSUInteger maximumValue;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIFont * textFont = [UIFont snFontWithSize:12.0f];
        UIFont * tinyFont = [UIFont snFontWithSize:14.0f];
        UIFont * smallFont = [UIFont snFontWithSize:18.0f];
        UIFont * bigFont = [UIFont snFontWithSize:72.0f];
        UIColor * grayColor = [UIColor grayWithIntense:146.0f];
        UIColor * violetColor = [UIColor colorWithRed:65.0f / 255.0f
                                                green:12.0f / 255.0f
                                                 blue:91.0f / 255.0f
                                                alpha:1.0f];
        
        UILabel * firstLine = [[UILabel alloc] initWithFrame:
                               CGRectMake(0.0f, 0.0f, frame.size.width, 50.0f)];
        [firstLine setFont:smallFont];
        [firstLine setTextColor:grayColor];
        [firstLine setText:NSLocalizedStringFromTable(@"InitiateBuyoutWith", @"Labels", nil)];
        [firstLine setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:firstLine];
        
        shares = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,
                                                           firstLine.frame.size.height,
                                                           frame.size.width,
                                                           58.0f)];
        [shares setFont:bigFont];
        [shares setTextColor:violetColor];
        [shares setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:shares];
        
        UILabel * lastLine = [[UILabel alloc] initWithFrame:
                              CGRectMake(0.0f,
                                         shares.frame.origin.y + shares.frame.size.height,
                                         frame.size.width,
                                         50.0f)];
        [lastLine setFont:smallFont];
        [lastLine setTextColor:grayColor];
        [lastLine setText:NSLocalizedStringFromTable(@"Shares", @"Labels", nil)];
        [lastLine setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:lastLine];
        
        CommonSeparator * sep = [[CommonSeparator alloc] initWithFrame:
                                 CGRectMake([Globals horizontalOffsetInTable],
                                            lastLine.frame.origin.y + lastLine.frame.size.height,
                                            frame.size.width - 2 * [Globals horizontalOffsetInTable],
                                            1.0f)];
        [self addSubview:sep];
        
        minimumBuyout = [[UILabel alloc] initWithFrame:
                         CGRectMake([Globals horizontalOffsetInTable],
                                    lastLine.frame.origin.y + lastLine.frame.size.height + 20.0f,
                                    140.0f,
                                    16.0f)];
        [minimumBuyout setFont:tinyFont];
        [minimumBuyout setTextColor:grayColor];
        [self addSubview:minimumBuyout];
        
        availableShares = [[UILabel alloc] initWithFrame:
                           CGRectMake(frame.size.width - 140.0f - [Globals horizontalOffsetInTable],
                                      lastLine.frame.origin.y + lastLine.frame.size.height + 20.0f,
                                      140.0f,
                                      16.0f)];
        [availableShares setFont:tinyFont];
        [availableShares setTextColor:grayColor];
        [availableShares setTextAlignment:NSTextAlignmentRight];
        [self addSubview:availableShares];
        
        UILabel * text = [[UILabel alloc] initWithFrame:
                          CGRectMake([Globals horizontalOffsetInTable],
                                     availableShares.frame.origin.y + availableShares.frame.size.height,
                                     frame.size.width - [Globals horizontalOffsetInTable] * 2,
                                     120.0f)];
        [text setFont:textFont];
        [text setTextColor:grayColor];
        [text setNumberOfLines:0];
        [text setLineBreakMode:NSLineBreakByWordWrapping];
        [text setText:NSLocalizedStringFromTable(@"BuyoutAttempts", @"Texts", nil)];
        [self addSubview:text];
    }
    return self;
}

#pragma mark - public

- (void)setMin:(NSUInteger)min value:(NSUInteger)value max:(NSUInteger)max
{
    minimumValue = min;
    currentValue = value;
    maximumValue = max;
    [shares setText:[NSString stringWithFormat:@"%lu", (unsigned long)value]];
    [minimumBuyout setText:
     [NSString stringWithFormat:@"%@: %lu", NSLocalizedStringFromTable(@"MinimumBuyout", @"Labels", nil), (unsigned long)min]];
    [availableShares setText:
     [NSString stringWithFormat:@"%@: %lu", NSLocalizedStringFromTable(@"AvailableShares", @"Labels", nil), (unsigned long)max]];
}

- (NSUInteger)value
{
    return currentValue;
}

@end
