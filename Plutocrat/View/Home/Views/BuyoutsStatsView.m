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
        CGFloat elementsWidth = (self.bounds.size.width - bordersOffset * 6) / 3;
        const CGFloat bigFontSize = 54.0f;
        const CGFloat smallFontSize = 10.0f;
        
        successValue = [[UILabel alloc] initWithFrame:CGRectMake(bordersOffset,
                                                                 bordersOffset,
                                                                 elementsWidth,
                                                                 60.0f)];
        [successValue setFont:[UIFont regularFontWithSize:bigFontSize]];
        [successValue setTextColor:darkGray];
        [successValue setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:successValue];
        
        failedValue = [[UILabel alloc] initWithFrame:
                       CGRectMake(successValue.frame.origin.x + elementsWidth +  bordersOffset * 2,
                                  bordersOffset,
                                  elementsWidth,
                                  60.0f)];
        [failedValue setFont:[UIFont regularFontWithSize:bigFontSize]];
        [failedValue setTextColor:darkGray];
        [failedValue setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:failedValue];
        
        defeatedValue = [[UILabel alloc] initWithFrame:
                         CGRectMake(failedValue.frame.origin.x + elementsWidth + bordersOffset * 2,
                                    bordersOffset,
                                    elementsWidth,
                                    60.0f)];
        [defeatedValue setFont:[UIFont regularFontWithSize:bigFontSize]];
        [defeatedValue setTextColor:darkGray];
        [defeatedValue setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:defeatedValue];
        
        
        NSArray * smallLabelsText = @[NSLocalizedStringFromTable(@"SuccessfullBuyouts", @"Labels", nil), NSLocalizedStringFromTable(@"FailedBuyouts", @"Labels", nil),NSLocalizedStringFromTable(@"DefeatedBuyouts", @"Labels", nil)];
        for (int i = 0; i < 3; ++i)
        {
            CGFloat startX = bordersOffset + elementsWidth * i + bordersOffset * 2 * i;
            UILabel * label = [[UILabel alloc] initWithFrame:
            CGRectMake(startX,
                       successValue.frame.origin.y + successValue.frame.size.height,
                       elementsWidth,
                       30.0f)];
            [label setFont:[UIFont regularFontWithSize:smallFontSize]];
            [label setTextColor:paleGray];
            [label setTextAlignment:NSTextAlignmentCenter];
            [label setNumberOfLines:0];
            [label setLineBreakMode:NSLineBreakByWordWrapping];
            [label setText:[smallLabelsText objectAtIndex:i]];
            [self addSubview:label];
        }
        
        CommonSeparator * sep = [[CommonSeparator alloc] initWithFrame:
                                 CGRectMake(bordersOffset,
                                            self.bounds.size.height - 1.0f,
                                            self.bounds.size.width - bordersOffset * 2,
                                            1.0f)];
        [self addSubview:sep];
        
        [self fillStub];
    }
    return self;
}

- (void)fillStub
{
    [successValue setText:@"12"];
    [failedValue setText:@"5"];
    [defeatedValue setText:@"17"];
}

@end
