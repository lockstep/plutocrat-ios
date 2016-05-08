//
//  CommonCheckBoxWithText.m
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-09.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import "CommonCheckBoxWithText.h"

@implementation CommonCheckBoxWithText

+ (instancetype)checkBoxWithText:(NSString *)text size:(CGSize)size defaultState:(BOOL)selected
{
    CommonCheckBoxWithText * checkBox = [[CommonCheckBoxWithText alloc] initWithFrame:CGRectMake(0.0f, 0.0f, size.width, size.height)];

    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 0.0f, size.width - 20.0f, size.height)];
    [label setLineBreakMode:NSLineBreakByWordWrapping];
    [label setNumberOfLines:0];
    [label setTextColor:[UIColor grayWithIntense:146.0f]];
    [label setFont:[UIFont snFontWithSize:12.0f]];
    [label setText:text];
    [checkBox addSubview:label];
    
    return checkBox;
}

@end
