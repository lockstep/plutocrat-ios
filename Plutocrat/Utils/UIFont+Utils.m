//
//  UIFont+Utils.m
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-05.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import "UIFont+Utils.h"

@implementation UIFont (Utils)

+ (instancetype)snFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"Sansation-Regular" size:size];
}

+ (instancetype)snBoldFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"Sansation-Bold" size:size];
}

@end
