//
//  BigUserView.m
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-12.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import "BigUserView.h"
#import "CommonSeparator.h"
#import "CommonButton.h"

@implementation BigUserView
{
    UIImageView * photo;
    UILabel * name;
    UILabel * email;
    UIButton * manageButton;
    UILabel * sharesToMatch;
    CommonSeparator * separator;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIColor * paleGray = [UIColor grayWithIntense:114.0f];
        CGFloat bordersOffset = [Globals horizontalOffset];
        const CGFloat bigFontSize = 24.0f;
        const CGFloat smallFontSize = 12.0f;
        
        photo = [[UIImageView alloc] initWithFrame:CGRectMake(bordersOffset,
                                                              25.0f,
                                                              88.0f,
                                                              88.0f)];
        [[photo layer] setCornerRadius:photo.frame.size.width / 2];
        [[photo layer] setMasksToBounds:YES];
        [self addSubview:photo];
        
        CGFloat startingXForLabels = bordersOffset + photo.frame.size.width + [Globals offsetFromPhoto];
        
        name = [[UILabel alloc] initWithFrame:
                CGRectMake(startingXForLabels,
                           25.0f * 1.5f,
                           self.bounds.size.width - startingXForLabels - bordersOffset,
                           28.0f)];
        [name setNumberOfLines:1];
        [name setAdjustsFontSizeToFitWidth:YES];
        [name setTextColor:paleGray];
        [name setFont:[UIFont regularFontWithSize:bigFontSize]];
        [self addSubview:name];
        
        email = [[UILabel alloc] initWithFrame:
                 CGRectMake(startingXForLabels,
                            name.frame.origin.y + name.frame.size.height + 5.0f,
                            self.bounds.size.width - startingXForLabels - bordersOffset,
                            14.0f)];
        [email setNumberOfLines:1];
        [email setAdjustsFontSizeToFitWidth:YES];
        [email setTextColor:paleGray];
        [email setFont:[UIFont regularFontWithSize:smallFontSize]];
        [email setHidden:YES];
        [self addSubview:email];
        
        manageButton = [CommonButton buttonWithText:NSLocalizedStringFromTable(@"ManageAccount", @"Buttons", nil) color:ButtonColorViolet];
        [manageButton setFrame:CGRectMake(startingXForLabels,
                                          email.frame.origin.y + email.frame.size.height + 5.0f,
                                          manageButton.frame.size.width,
                                          manageButton.frame.size.height)];
        [manageButton setHidden:YES];
        [self addSubview:manageButton];
        
        sharesToMatch = [[UILabel alloc] initWithFrame:CGRectMake(startingXForLabels, name.frame.origin.y + name.frame.size.height + 5.0f, self.bounds.size.width - startingXForLabels - bordersOffset,  14.0f)];
        [sharesToMatch setNumberOfLines:1];
        [sharesToMatch setAdjustsFontSizeToFitWidth:YES];
        [sharesToMatch setTextColor:[UIColor colorWithRed:193.0f / 255.0f
                                                    green:1.0f / 255.0f
                                                     blue:1.0f / 255.0f
                                                    alpha:1.0f]];
        [sharesToMatch setFont:[UIFont regularFontWithSize:15.0f]];
        [sharesToMatch setHidden:YES];
        [self addSubview:sharesToMatch];
        
        
        separator = [[CommonSeparator alloc] initWithFrame:CGRectMake(bordersOffset, self.bounds.size.height - 1.0f, self.bounds.size.width - bordersOffset * 2, 1.0f)];
        [separator setHidden:YES];
        [self addSubview:separator];        
    }
    return self;
}

- (void)fillStub1
{
    [photo setImage:[UIImage imageNamed:@"778.png"]];
    [name setText:@"Danielle Steele"];
    [email setText:@"danielle@watershedcapital.com"];
    [email setHidden:NO];
    [manageButton setHidden:NO];
    [separator setHidden:NO];
}

- (void)fillStub2
{
    [photo setImage:[UIImage imageNamed:@"779.png"]];
    [name setText:@"Aaron Pinchai"];
    [sharesToMatch setText:@"Shares to Match: 23"];
    [sharesToMatch setHidden:NO];
}

@end
