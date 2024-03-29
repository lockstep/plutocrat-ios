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
    ButtonColorWhite,
    ButtonColorHardWhite,
    ButtonColorClear
};

@interface CommonButton : UIButton

+ (instancetype)buttonWithText:(NSString *)text color:(ButtonColor)buttonColor;
+ (instancetype)bigButtonWithText:(NSString *)text width:(CGFloat)width;
- (void)setText:(NSString *)text;

@property (nonatomic, strong) UIColor * defColor;
@property (nonatomic, strong) UIColor * highColor;

@end
