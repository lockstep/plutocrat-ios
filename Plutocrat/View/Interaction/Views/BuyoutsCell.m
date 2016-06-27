//
//  BuyoutsCell.m
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-18.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import "BuyoutsCell.h"

@implementation BuyoutsCell

#pragma mark - public

- (void)setShares:(NSUInteger)shares timeAgo:(NSString *)timeAgo state:(BuyoutCellState)state
{
    NSString * firstLine;
    NSString * status;
    UIColor * lastRowColor;
    UIColor * gray = [UIColor grayWithIntense:114.0f];
    UIColor * green = [UIColor colorWithRed:0.0f / 255.0f
                                      green:147.0f / 255.0f
                                       blue:12.0f / 255.0f
                                      alpha:1.0f];
    UIColor * red = [UIColor colorWithRed:203.0f / 255.0f
                                    green:2.0f / 255.0f
                                    blue:2.0f / 255.0f
                                    alpha:1.0f];
    UIFont * font = [UIFont regularFontWithSize:12.0f];
    UIFont * italicFont = [UIFont italicFontWithSize:12.0f];

    switch (state)
    {
        case BuyoutCellOutcomingState:
            firstLine = NSLocalizedStringFromTable(@"YouInitiatedWith", @"Labels", nil);
            status = NSLocalizedStringFromTable(@"OutcomePending", @"Labels", nil);
            lastRowColor = gray;
            break;

        case BuyoutCellIncomingState:
            firstLine = NSLocalizedStringFromTable(@"ThreatedYouWith", @"Labels", nil);
            status = NSLocalizedStringFromTable(@"OutcomePending", @"Labels", nil);
            lastRowColor = gray;
            break;

        case BuyoutCellSuccessedState:
            firstLine = NSLocalizedStringFromTable(@"YouInitiatedWith", @"Labels", nil);
            status = NSLocalizedStringFromTable(@"BuyoutSucceeded", @"Labels", nil);
            lastRowColor = green;
            break;
            
        case BuyoutCellYouFailedState:
            firstLine = NSLocalizedStringFromTable(@"YouInitiatedWith", @"Labels", nil);
            status = NSLocalizedStringFromTable(@"BuyoutFailed", @"Labels", nil);
            lastRowColor = red;
            break;
            
        case BuyoutCellHeFailedState:
            firstLine = NSLocalizedStringFromTable(@"ThreatedYouWith", @"Labels", nil);
            status = NSLocalizedStringFromTable(@"BuyoutFailed", @"Labels", nil);
            lastRowColor = green;
            break;
            
        default:
            break;
    }
    
    NSString * str = [NSString stringWithFormat:NSLocalizedStringFromTable(@"BuyoutsCellFormat", @"Labels", nil), firstLine, shares, timeAgo, status];
    
    NSDictionary * baseAttrs = @{NSFontAttributeName:font,
                                 NSForegroundColorAttributeName:gray};
    
    
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:str attributes:baseAttrs];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 3.0f;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, str.length)];
    
    NSDictionary * subAttrs = @{NSFontAttributeName:italicFont,
                                NSForegroundColorAttributeName:lastRowColor};
    const NSRange range = [str rangeOfString:status];
    [attributedString setAttributes:subAttrs range:range];
    [self.info setAttributedText:attributedString];
}

@end
