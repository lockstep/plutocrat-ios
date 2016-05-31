//
//  SharesHeader.m
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-31.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import "SharesHeader.h"

@implementation SharesHeader
{
    UILabel * shares;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIImageView * background = [[UIImageView alloc] initWithFrame:frame];
        [background setImage:[UIImage imageNamed:@"Background-gray"]];
        [self addSubview:background];
        
        shares = [[UILabel alloc] initWithFrame:frame];
        [shares setFont:[UIFont regularFontWithSize:24.0f]];
        [shares setTextColor:[UIColor whiteColor]];
        [shares setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:shares];
    }
    return self;
}

#pragma mark - public

- (void)setNumberOfShares:(NSUInteger)number
{
    [shares setText:[NSString stringWithFormat:NSLocalizedStringFromTable(@"UnusedSharesFormat", @"Labels", nil), number]];
}

@end
