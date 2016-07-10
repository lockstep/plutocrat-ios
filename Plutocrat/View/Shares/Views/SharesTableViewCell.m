//
//  SharesTableViewCell.m
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-31.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import "SharesTableViewCell.h"
#import "CommonButton.h"
#import "CommonSeparator.h"

@implementation SharesTableViewCell
{
    UIImageView * visual;
    UILabel * sharesInRound;
    UILabel * descriptInRound;
    UILabel * perShareVal;
    UILabel * totalVal;
    CommonButton * buy;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setBackgroundColor:[UIColor clearColor]];
        
        visual = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 50.0f, 50.0f)];
        [visual setCenter:CGPointMake([Globals horizontalOffsetInTable] + visual.frame.size.width / 2,
                                      [Globals cellHeight] / 2)];
        [self addSubview:visual];
        
        sharesInRound = [[UILabel alloc] initWithFrame:CGRectMake([Globals horizontalOffsetInTable],
                                                                  [Globals cellHeight] / 2 - 20.0f,
                                                                  50.0f,
                                                                  30.0f)];
        [sharesInRound setBackgroundColor:[UIColor clearColor]];
        [sharesInRound setFont:[UIFont regularFontWithSize:20.0f]];
        [sharesInRound setTextColor:[UIColor ourViolet]];
        [sharesInRound setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:sharesInRound];
        
        descriptInRound = [[UILabel alloc] initWithFrame:CGRectMake([Globals horizontalOffsetInTable],
                                                                    [Globals cellHeight] / 2 + 3.0f,
                                                                    50.0f,
                                                                    12.0f)];
        [descriptInRound setBackgroundColor:[UIColor clearColor]];
        [descriptInRound setFont:[UIFont regularFontWithSize:8.0f]];
        [descriptInRound setTextColor:[UIColor ourViolet]];
        [descriptInRound setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:descriptInRound];
        
        UILabel * perShareLab = [[UILabel alloc] initWithFrame:
                                 CGRectMake(visual.frame.size.width + [Globals horizontalOffsetInTable] * 2, [Globals cellHeight] / 2 - 20.0f, 60.0f, 15.0f)];
        [perShareLab setBackgroundColor:[UIColor clearColor]];
        [perShareLab setFont:[UIFont regularFontWithSize:12.0f]];
        [perShareLab setTextColor:[UIColor grayWithIntense:114.0f]];
        [perShareLab setText:NSLocalizedStringFromTable(@"PerShare", @"Labels", nil)];
        [self addSubview:perShareLab];
        
        perShareVal = [[UILabel alloc] initWithFrame:
                       CGRectMake(visual.frame.size.width + [Globals horizontalOffsetInTable] * 2 + 60.0f, [Globals cellHeight] / 2 - 20.0f, 60.0f, 15.0f)];
        [perShareVal setBackgroundColor:[UIColor clearColor]];
        [perShareVal setFont:[UIFont regularFontWithSize:12.0f]];
        [perShareVal setTextColor:[UIColor grayWithIntense:114.0f]];
        [perShareVal setTextAlignment:NSTextAlignmentRight];
        [perShareVal setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
        [perShareLab setAdjustsFontSizeToFitWidth:YES];
        [self addSubview:perShareVal];
        
        CommonSeparator * sep = [[CommonSeparator alloc] initWithFrame:
                                 CGRectMake(visual.frame.size.width + [Globals horizontalOffsetInTable] * 2, [Globals cellHeight] / 2, 120.0f, 1.0f)];
        [sep setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [self addSubview:sep];
        
        UILabel * totalLab = [[UILabel alloc] initWithFrame:
                              CGRectMake(visual.frame.size.width + [Globals horizontalOffsetInTable] * 2, [Globals cellHeight] / 2 + 5.0f, 60.0f, 15.0f)];
        [totalLab setBackgroundColor:[UIColor clearColor]];
        [totalLab setFont:[UIFont regularFontWithSize:12.0f]];
        [totalLab setTextColor:[UIColor grayWithIntense:114.0f]];
        [totalLab setText:NSLocalizedStringFromTable(@"Total", @"Labels", nil)];
        [self addSubview:totalLab];
        
        totalVal = [[UILabel alloc] initWithFrame:
                        CGRectMake(visual.frame.size.width + [Globals horizontalOffsetInTable] * 2 + 40.0f, [Globals cellHeight] / 2 + 5.0f, 80.0f, 15.0f)];
        [totalVal setBackgroundColor:[UIColor clearColor]];
        [totalVal setFont:[UIFont italicFontWithSize:12.0f]];
        [totalVal setTextColor:[UIColor grayWithIntense:114.0f]];
        [totalVal setTextAlignment:NSTextAlignmentRight];
        [totalVal setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
        [totalVal setAdjustsFontSizeToFitWidth:YES];
        [self addSubview:totalVal];
        
        buy = [CommonButton buttonWithText:NSLocalizedStringFromTable(@"BUY", @"Buttons", nil)
                                     color:ButtonColorViolet];
        [buy setCenter:CGPointMake(self.bounds.size.width - [Globals horizontalOffsetInTable] - buy.frame.size.width / 2, [Globals cellHeight] / 2)];
        [buy addTarget:self action:@selector(tapped) forControlEvents:UIControlEventTouchUpInside];
        [buy setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
        [self addSubview:buy];
    }
    return self;
}

#pragma mark - button

- (void)tapped
{
    if ([self.delegate respondsToSelector:@selector(buttonTappedToByOnCell:)])
    {
        [self.delegate buttonTappedToByOnCell:self];
    }
}

#pragma mark - public

- (void)setShares:(NSUInteger)shares
            price:(CGFloat)price
         currency:(NSString *)currency
     visualAmount:(SharesAmount)amount
{
    [sharesInRound setText:[NSString stringWithFormat:@"%lu", (unsigned long)shares]];
    NSString * descText = (shares == 1) ? NSLocalizedStringFromTable(@"Share", @"Labels", nil) : NSLocalizedStringFromTable(@"Shares", @"Labels", nil);
    [descriptInRound setText:descText];
    [totalVal setText:[NSString stringWithFormat:@"%.2f %@", price, currency]];
    if (shares != 0)
    {
        [perShareVal setText:[NSString stringWithFormat:@"%.2f %@", (price / shares), currency]];
    }
    switch (amount)
    {
        case SharesAmountFew:
            [visual setImage:[UIImage imageNamed:@"shares-few"]];
            break;
            
        case SharesAmountAverage:
            [visual setImage:[UIImage imageNamed:@"shares-average"]];
            break;
            
        case SharesAmountMany:
            [visual setImage:[UIImage imageNamed:@"shares-many"]];
            break;
            
        default:
            break;
    }
}

@end
