//
//  UIColor+Utils.m
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-05.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import "UIColor+Utils.h"

@implementation UIColor (Utils)

+ (instancetype)grayWithIntense:(CGFloat)intense
{
    return [UIColor colorWithRed:intense / 255.0f
                           green:intense / 255.0f
                            blue:intense / 255.0f
                           alpha:1.0f];
}

+ (instancetype)ourViolet
{
    return [UIColor colorWithRed:65.0f / 255.0f
                           green:12.0f / 255.0f
                            blue:91.0f / 255.0f
                           alpha:1.0f];
}

+ (instancetype)ourRed
{
    return [UIColor colorWithRed:208.0f / 255.0f
                           green:0.0f
                            blue:0.0f
                           alpha:1.0f];
}

@end
