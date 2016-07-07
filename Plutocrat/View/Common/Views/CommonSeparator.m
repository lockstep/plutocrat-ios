//
//  CommonSeparator.m
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-06.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import "CommonSeparator.h"

@implementation CommonSeparator
{
    BOOL white;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)makeWhite
{
    white = YES;
}

- (void)drawRect:(CGRect)rect
{
    CGColorRef colorRef = white ? [UIColor whiteColor].CGColor : [UIColor grayWithIntense:146.0f].CGColor;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, colorRef);
    CGContextSetAllowsAntialiasing(context, false);
    CGContextSetLineWidth(context, 1.0f);
    CGContextMoveToPoint(context, 0.0f, 0.0f);
    CGContextAddLineToPoint(context, rect.size.width, 0.0f);
    CGContextStrokePath(context);
}

@end
