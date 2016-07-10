//
//  HomeHeader.m
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-13.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import "HomeHeader.h"
#import "DateUtility.h"

@implementation HomeHeader
{
    UIImageView * background;
    UILabel * firstLine;
    UILabel * secondLine;
    BOOL attacked;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        const CGFloat bigFontSize = 30.0f;
        const CGFloat smallFontSize = 22.0f;
        
        background = [[UIImageView alloc] initWithFrame:frame];
        [self addSubview:background];
        
        firstLine = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,
                                                              25.0f,
                                                              frame.size.width,
                                                              frame.size.height / 2)];
        [firstLine setFont:[UIFont regularFontWithSize:bigFontSize]];
        [firstLine setTextColor:[UIColor whiteColor]];
        [firstLine setTextAlignment:NSTextAlignmentCenter];
        firstLine.shadowColor = [UIColor blackColor];
        firstLine.shadowOffset = CGSizeMake(0.0f, 2.0f);
        [self addSubview:firstLine];
        
        secondLine = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,
                                                               60.0f,
                                                               frame.size.width,
                                                               frame.size.height / 2)];
        [secondLine setFont:[UIFont regularFontWithSize:smallFontSize]];
        [secondLine setTextColor:[UIColor whiteColor]];
        [secondLine setTextAlignment:NSTextAlignmentCenter];
        secondLine.shadowColor = [UIColor blackColor];
        secondLine.shadowOffset = CGSizeMake(0.0f, 2.0f);
        [self addSubview:secondLine];
    }
    return self;
}

#pragma mark - public

- (void)setType:(HomeHeaderType)type
{
    switch (type)
    {
        case HomeHeaderTypeCommon:
            [background setImage:[UIImage imageNamed:@"Background-gray"]];
            [firstLine setText:NSLocalizedStringFromTable(@"SurvivalTime", @"Labels", nil)];
            attacked = NO;
            break;
            
        case HomeHeaderTypeThreated:
            [background setImage:[UIImage imageNamed:@"Background-red"]];
            [firstLine setText:NSLocalizedStringFromTable(@"ActiveBuyoutThreat", @"Labels", nil)];
            attacked = YES;
            break;
            
        case HomeHeaderTypeDefeated:
            [background setImage:[UIImage imageNamed:@"Background-red"]];
            [firstLine setText:NSLocalizedStringFromTable(@"YouSurvived", @"Labels", nil)];
            attacked = NO;
            break;
            
        default:
            break;
    }
}

- (void)setDate:(NSDate *)date
{
    NSString * timeStr = [DateUtility timeUntilNow:date];
    if (attacked)
    {
        timeStr = [NSString stringWithFormat:@"%@: %@", NSLocalizedStringFromTable(@"Deadline", @"Labels", nil), timeStr];
    }
    [secondLine setText:timeStr];
}

- (void)setSurvavalFromDate:(NSDate *)registered toDate:(NSDate *)defeated
{
    NSString * timeStr = [DateUtility timeFromDate:registered toDate:defeated];
    [secondLine setText:timeStr];
}

@end
