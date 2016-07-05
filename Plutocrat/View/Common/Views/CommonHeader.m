//
//  CommonHeader.m
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-06-08.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import "CommonHeader.h"

@implementation CommonHeader
{
    UILabel * label;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIImageView * background = [[UIImageView alloc] initWithFrame:frame];
        [background setImage:[UIImage imageNamed:@"Background-gray"]];
        [self addSubview:background];

        label = [[UILabel alloc] initWithFrame:frame];
        [label setFont:[UIFont regularFontWithSize:20.0f]];
        [label setTextColor:[UIColor whiteColor]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:label];
    }
    return self;
}

- (void)setText:(NSString *)text
{
    [label setText:text];
}

@end
