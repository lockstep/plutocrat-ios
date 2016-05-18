//
//  TargetsCell.m
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-18.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import "TargetsCell.h"

@implementation TargetsCell

#pragma mark - public

- (void)setBuyouts:(NSUInteger)buyouts threats:(NSUInteger)threats days:(NSUInteger)days
{
    NSString * str = [NSString stringWithFormat:NSLocalizedStringFromTable(@"TargetsCellFormat", @"Labels", nil), buyouts, threats, days];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 3.0f;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, str.length)];
    [self.info setAttributedText:attributedString];
}

@end
