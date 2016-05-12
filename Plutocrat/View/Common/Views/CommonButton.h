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
    buttonColorGray,
    buttonColorRed,
    buttonColorViolet
};

@interface CommonButton : UIButton

+ (instancetype)smallButtonWithColor:(ButtonColor)buttonColor;
+ (instancetype)textButton:(NSString *)text fontSize:(CGFloat)fontSize;
- (void)setText:(NSString *)text;

@end
