//
//  CommonSeparator.m
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-06.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import "CommonSeparator.h"

@implementation CommonSeparator


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor grayWithIntense:146.0f].CGColor);
    CGContextSetAllowsAntialiasing(context, false);
    CGContextSetLineWidth(context, 1.0f);
    CGContextMoveToPoint(context, 0.0f, 0.0f);
    CGContextAddLineToPoint(context, rect.size.width, 0.0f);
    CGContextStrokePath(context);
}


@end
