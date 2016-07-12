//
//  BuyoutsStatsView.m
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-12.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import "BuyoutsStatsView.h"
#import "CommonSeparator.h"

@implementation BuyoutsStatsView
{
    UILabel * successValue;
    UILabel * failedValue;
    UILabel * defeatedValue;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIColor * darkGray = [UIColor grayWithIntense:128.0f];
        UIColor * paleGray = [UIColor grayWithIntense:168.0f];
        CGFloat bordersOffset = [Globals horizontalOffset];
        CGFloat elementsWidth = (self.bounds.size.width - bordersOffset * 4) / 3;
        const CGFloat bigFontSize = 54.0f;
        const CGFloat smallFontSize = 16.0f;
        const CGFloat verticalOffset = 5.0f;
        
        successValue = [[UILabel alloc] initWithFrame:CGRectMake(bordersOffset,
                                                                 verticalOffset,
                                                                 elementsWidth,
                                                                 60.0f)];
        [successValue setFont:[UIFont regularFontWithSize:bigFontSize]];
        [successValue setTextColor:darkGray];
        [successValue setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:successValue];
        
        failedValue = [[UILabel alloc] initWithFrame:
                       CGRectMake(successValue.frame.origin.x + elementsWidth + bordersOffset,
                                  verticalOffset,
                                  elementsWidth,
                                  60.0f)];
        [failedValue setFont:[UIFont regularFontWithSize:bigFontSize]];
        [failedValue setTextColor:darkGray];
        [failedValue setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:failedValue];
        
        defeatedValue = [[UILabel alloc] initWithFrame:
                         CGRectMake(failedValue.frame.origin.x + elementsWidth + bordersOffset,
                                    verticalOffset,
                                    elementsWidth,
                                    60.0f)];
        [defeatedValue setFont:[UIFont regularFontWithSize:bigFontSize]];
        [defeatedValue setTextColor:darkGray];
        [defeatedValue setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:defeatedValue];
        
        
        NSArray * smallLabelsText = @[NSLocalizedStringFromTable(@"SuccessfullBuyouts", @"Labels", nil), NSLocalizedStringFromTable(@"FailedBuyouts", @"Labels", nil),NSLocalizedStringFromTable(@"DefeatedBuyouts", @"Labels", nil)];
        for (int i = 0; i < 3; ++i)
        {
            CGFloat startX = bordersOffset + elementsWidth * i + bordersOffset * i;
            UILabel * label = [[UILabel alloc] initWithFrame:
            CGRectMake(startX,
                       successValue.frame.origin.y + successValue.frame.size.height,
                       elementsWidth,
                       40.0f)];
            [label setFont:[UIFont regularFontWithSize:smallFontSize]];
            [label setTextColor:paleGray];
            [label setTextAlignment:NSTextAlignmentCenter];
            [label setNumberOfLines:2];
            [label setLineBreakMode:NSLineBreakByWordWrapping];
            [label setText:[smallLabelsText objectAtIndex:i]];
            [label setAdjustsFontSizeToFitWidth:YES];
            [self addSubview:label];
        }
        
        CommonSeparator * sep = [[CommonSeparator alloc] initWithFrame:
                                 CGRectMake(bordersOffset,
                                            self.bounds.size.height - 12.0f,
                                            self.bounds.size.width - bordersOffset * 2,
                                            1.0f)];
        [self addSubview:sep];
    }
    return self;
}

#pragma mark - public

- (void)setSuccessful:(NSUInteger)successful failed:(NSUInteger)failed defeated:(NSUInteger)defeated
{
    [successValue setText:[NSString stringWithFormat:@"%lu", (unsigned long)successful]];
    [failedValue setText:[NSString stringWithFormat:@"%lu", (unsigned long)failed]];
    [defeatedValue setText:[NSString stringWithFormat:@"%lu", (unsigned long)defeated]];
}

@end
