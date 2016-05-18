//
//  CommonButton.m
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-08.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import "CommonButton.h"

@implementation CommonButton

+ (instancetype)smallButtonWithColor:(ButtonColor)buttonColor titleColor:(ButtonColor)titleColor
{
    CommonButton * button = [[CommonButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 65.0f, 24.0f)];
    [button paintButtonToColor:buttonColor titleColor:titleColor];
    [[button layer] setCornerRadius:4.0f];
    [[button titleLabel] setFont:[UIFont snFontWithSize:14.0f]];
    return button;
}
+ (instancetype)smallButtonWithColor:(ButtonColor)buttonColor
{
    return [self smallButtonWithColor:buttonColor titleColor:ButtonColorWhite];
}

+ (instancetype)bigButtonWithColor:(ButtonColor)buttonColor
{
    CommonButton * button = [[CommonButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 110.0f, 24.0f)];
    [button paintButtonToColor:buttonColor titleColor:ButtonColorWhite];
    [[button layer] setCornerRadius:4.0f];
    [[button titleLabel] setFont:[UIFont snFontWithSize:12.0f]];
    return button;
}

+ (instancetype)textButton:(NSString *)text fontSize:(CGFloat)fontSize
{
    UIFont * font = [UIFont snFontWithSize:fontSize];
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

#pragma mark - private

- (void)paintButtonToColor:(ButtonColor)buttonColor titleColor:(ButtonColor)titleColor
{
    switch (buttonColor)
    {
        case ButtonColorRed:
            [self setBackgroundColor:[UIColor colorWithRed:193.0f / 255.0f
                                                     green:1.0f / 255.0f
                                                      blue:1.0f / 255.0f
                                                     alpha:1.0f]];
            break;
            
        case ButtonColorGray:
            [self setBackgroundColor:[UIColor grayWithIntense:124.0f]];
            break;
            
        case ButtonColorViolet:
            [self setBackgroundColor:[UIColor colorWithRed:65.0f / 255.0f
                                                     green:12.0f / 255.0f
                                                      blue:91.0f / 255.0f
                                                     alpha:1.0f]];
            break;
            
        case ButtonColorWhite:
            [self setBackgroundColor:[UIColor whiteColor]];
            break;
            
        default:
            break;
    }
    
    switch (titleColor)
    {
        case ButtonColorRed:
            [self setTitleColor:[UIColor colorWithRed:193.0f / 255.0f
                                                green:1.0f / 255.0f
                                                 blue:1.0f / 255.0f
                                                alpha:1.0f]
                       forState:UIControlStateNormal];
            break;
            
        case ButtonColorGray:
            [self setTitleColor:[UIColor grayWithIntense:124.0f] forState:UIControlStateNormal];
            break;
            
        case ButtonColorViolet:
            [self setTitleColor:[UIColor colorWithRed:65.0f / 255.0f
                                                green:12.0f / 255.0f
                                                 blue:91.0f / 255.0f
                                                alpha:1.0f]
                       forState:UIControlStateNormal];
            break;
            
        case ButtonColorWhite:
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
}

@end
