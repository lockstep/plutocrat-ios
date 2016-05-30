//
//  AboutHeader.m
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-30.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import "AboutHeader.h"

@implementation AboutHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIImageView * background = [[UIImageView alloc] initWithFrame:frame];
        [background setImage:[UIImage imageNamed:@"Background-gray"]];
        [self addSubview:background];
        
        UILabel * faq = [[UILabel alloc] initWithFrame:frame];
        [faq setFont:[UIFont regularFontWithSize:20.0f]];
        [faq setTextColor:[UIColor whiteColor]];
        [faq setTextAlignment:NSTextAlignmentCenter];
        [faq setText:NSLocalizedStringFromTable(@"FAQ", @"Labels", nil)];
        [self addSubview:faq];
    }
    return self;
}

@end
