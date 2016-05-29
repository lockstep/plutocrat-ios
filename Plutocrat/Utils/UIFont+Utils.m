//
//  UIFont+Utils.m
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-05.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import "UIFont+Utils.h"

@implementation UIFont (Utils)

+ (instancetype)regularFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"Helvetica" size:size];
}

+ (instancetype)boldFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"Helvetica-Bold" size:size];
}

@end
