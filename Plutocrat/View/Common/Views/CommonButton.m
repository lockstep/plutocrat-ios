//
//  CommonButton.m
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-08.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import "CommonButton.h"

@implementation CommonButton

+ (instancetype)smallButtonWithColor:(ButtonColor)buttonColor
{
    CommonButton * button = [[CommonButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 65.0f, 24.0f)];
    [button setBackgroundColor:[UIColor grayWithIntense:124.0f]];
    [[button layer] setCornerRadius:4.0f];
    [[button titleLabel] setFont:[UIFont snFontWithSize:14.0f]];
    return button;
}

+ (instancetype)textButton:(NSString *)text
{
    UIFont * font = [UIFont snFontWithSize:14.0f];
    CGRect rect = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 20.0f)
                                     options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                  attributes:@{NSFontAttributeName:font}
                                     context:nil];
    CommonButton * button = [[CommonButton alloc] initWithFrame:CGRectMake(0.0f,
                                                                           0.0f,
                                                                           rect.size.width,
                                                                           rect.size.height)];
    [[button titleLabel] setFont:font];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [button setTitleColor:[UIColor colorWithRed:65.0f / 255.0f
                                          green:12.0f / 255.0f
                                           blue:91.0f / 255.0f
                                          alpha:1.0f] forState:UIControlStateNormal];

    [button setText:text];
    return button;
}

- (void)setText:(NSString *)text
{
    [self setTitle:text forState:UIControlStateNormal];
}

@end
