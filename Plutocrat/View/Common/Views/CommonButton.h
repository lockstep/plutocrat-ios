//
//  CommonButton.h
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-08.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSUInteger, ButtonColor)
{
    ButtonColorGray,
    ButtonColorRed,
    ButtonColorViolet,
    ButtonColorWhite
};

@interface CommonButton : UIButton

+ (instancetype)smallButtonWithColor:(ButtonColor)buttonColor;
+ (instancetype)smallButtonWithColor:(ButtonColor)buttonColor titleColor:(ButtonColor)titleColor;
+ (instancetype)bigButtonWithColor:(ButtonColor)buttonColor;
+ (instancetype)textButton:(NSString *)text fontSize:(CGFloat)fontSize;
+ (instancetype)lightButtonWithText:(NSString *)text color:(ButtonColor)buttonColor;
- (void)setText:(NSString *)text;

@end
