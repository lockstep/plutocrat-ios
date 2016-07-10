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
    UILabel * desc;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIImageView * background = [[UIImageView alloc] initWithFrame:frame];
        [background setImage:[UIImage imageNamed:@"Background-gray"]];
        [self addSubview:background];

        const CGFloat bigFontSize = 30.0f;
        const CGFloat smallFontSize = 22.0f;

        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,
                                                          25.0f,
                                                          frame.size.width,
                                                          frame.size.height / 2)];
        [label setFont:[UIFont regularFontWithSize:bigFontSize]];
        [label setTextColor:[UIColor whiteColor]];
        [label setTextAlignment:NSTextAlignmentCenter];
        label.shadowColor = [UIColor blackColor];
        label.shadowOffset = CGSizeMake(1.0f, 1.0f);
        [self addSubview:label];

        desc = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,
                                                         60.0f,
                                                         frame.size.width,
                                                         frame.size.height / 2)];
        [desc setFont:[UIFont regularFontWithSize:smallFontSize]];
        [desc setTextColor:[UIColor whiteColor]];
        [desc setTextAlignment:NSTextAlignmentCenter];
        desc.shadowColor = [UIColor blackColor];
        desc.shadowOffset = CGSizeMake(1.0f, 1.0f);
        [self addSubview:desc];
    }
    return self;
}

- (void)setText:(NSString *)text descText:(NSString *)descText
{
    [label setText:text];
    [desc setText:descText];
}

@end
