//
//  CommonButton.m
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-08.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import "CommonButton.h"

@implementation CommonButton

+ (instancetype)buttonWithText:(NSString *)text color:(ButtonColor)buttonColor
{
    UIFont * font = [UIFont regularFontWithSize:12.0f];
    CGRect rect = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 20.0f)
                                     options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                  attributes:@{NSFontAttributeName:font}
                                     context:nil];
    CommonButton * button = [[CommonButton alloc] initWithFrame:CGRectMake(0.0f,
                                                                           0.0f,
                                                                           rect.size.width + 25.0f,
                                                                           rect.size.height + 10.0f)];
    [[button titleLabel] setFont:font];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [button paintButtonToColor:ButtonColorWhite titleColor:buttonColor];
    [button paintBorderToColor:buttonColor];
    [button.layer setBorderWidth:1.0f];
    [button.layer setCornerRadius:5.0f];
    [button.layer setMasksToBounds:YES];
    [button setTitle:text forState:UIControlStateNormal];
    return button;
}

+ (instancetype)bigButtonWithText:(NSString *)text width:(CGFloat)width
{
    UIFont * font = [UIFont regularFontWithSize:12.0f];
    CommonButton * button = [[CommonButton alloc] initWithFrame:CGRectMake(0.0f,
                                                                           0.0f,
                                                                           width,
                                                                           30.0f)];
    [[button titleLabel] setFont:font];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [button paintButtonToColor:ButtonColorClear titleColor:ButtonColorClear];
    [button paintBorderToColor:ButtonColorClear];
    [button.layer setBorderWidth:1.0f];
    [button.layer setCornerRadius:3.0f];
    [button.layer setMasksToBounds:YES];
    [button setTitle:text forState:UIControlStateNormal];
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
            [self setHighColor:[UIColor whiteColor]];
            break;
            
        case ButtonColorGray:
            [self setBackgroundColor:[UIColor grayWithIntense:124.0f]];
            [self setHighColor:[UIColor ourViolet]];
            break;
            
        case ButtonColorViolet:
            [self setBackgroundColor:[UIColor ourViolet]];
            [self setHighColor:[UIColor whiteColor]];
            break;
            
        case ButtonColorWhite:
            [self setBackgroundColor:[UIColor whiteColor]];
            [self setHighColor:[UIColor ourViolet]];
            break;

        case ButtonColorHardWhite:
            [self setBackgroundColor:[UIColor whiteColor]];
            [self setHighColor:[UIColor ourViolet]];
            break;

        case ButtonColorClear:
            [self setBackgroundColor:[UIColor clearColor]];
            [self setHighColor:[UIColor whiteColor]];
            break;

        default:
            break;
    }
    [self setDefColor:self.backgroundColor];

    switch (titleColor)
    {
        case ButtonColorRed:
            [self setTitleColor:[UIColor colorWithRed:193.0f / 255.0f
                                                green:1.0f / 255.0f
                                                 blue:1.0f / 255.0f
                                                alpha:1.0f]
                       forState:UIControlStateNormal];
            [self setTitleColor:[UIColor colorWithRed:193.0f / 255.0f
                                                green:1.0f / 255.0f
                                                 blue:1.0f / 255.0f
                                                alpha:1.0f]
                       forState:UIControlStateHighlighted];
            break;
            
        case ButtonColorGray:
            [self setTitleColor:[UIColor grayWithIntense:124.0f] forState:UIControlStateNormal];
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            break;
            
        case ButtonColorViolet:
            [self setTitleColor:[UIColor ourViolet] forState:UIControlStateNormal];
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            break;
            
        case ButtonColorWhite:
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            break;

        case ButtonColorHardWhite:
            [self setTitleColor:[UIColor ourViolet] forState:UIControlStateNormal];
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            break;

        case ButtonColorClear:
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self setTitleColor:[UIColor ourViolet] forState:UIControlStateHighlighted];
            break;

        default:
            break;
    }
}

- (void)paintBorderToColor:(ButtonColor)buttonColor
{
    switch (buttonColor)
    {
        case ButtonColorRed:
            [self.layer setBorderColor:[UIColor colorWithRed:193.0f / 255.0f
                                                       green:1.0f / 255.0f
                                                        blue:1.0f / 255.0f
                                                       alpha:1.0f].CGColor];
            break;
            
        case ButtonColorGray:
            [self.layer setBorderColor:[UIColor grayWithIntense:124.0f].CGColor];
            break;
            
        case ButtonColorViolet:
            [self.layer setBorderColor:[UIColor ourViolet].CGColor];
            break;
            
        case ButtonColorWhite:
            [self.layer setBorderColor:[UIColor whiteColor].CGColor];
            break;

        case ButtonColorHardWhite:
            [self.layer setBorderColor:[UIColor whiteColor].CGColor];
            break;

        case ButtonColorClear:
            [self.layer setBorderColor:[UIColor whiteColor].CGColor];
            break;

        default:
            break;
    }
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];

    UIColor * paintBack = highlighted ? self.highColor : self.defColor;
    [self setBackgroundColor:paintBack];
}

@end
