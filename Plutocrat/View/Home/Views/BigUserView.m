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
#import "ApiConnector.h"

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
        const CGFloat smallFontSize = 16.0f;
        
        photo = [[UIImageView alloc] initWithFrame:CGRectMake(bordersOffset,
                                                              25.0f,
                                                              88.0f,
                                                              88.0f)];
        [photo setImage:[UIImage imageNamed:@"empty-profile-image"]];
        [[photo layer] setCornerRadius:photo.frame.size.width / 2];
        [[photo layer] setMasksToBounds:YES];
        [self addSubview:photo];
        
        CGFloat startingXForLabels = bordersOffset + photo.frame.size.width + [Globals offsetFromPhoto];
        
        name = [[UILabel alloc] initWithFrame:
                CGRectMake(startingXForLabels,
                           25.0f,
                           self.bounds.size.width - startingXForLabels - bordersOffset,
                           28.0f)];
        [name setNumberOfLines:1];
        [name setTextAlignment:NSTextAlignmentCenter];
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
        [email setTextAlignment:NSTextAlignmentCenter];
        [email setAdjustsFontSizeToFitWidth:YES];
        [email setTextColor:paleGray];
        [email setFont:[UIFont regularFontWithSize:smallFontSize]];
        [email setHidden:YES];
        [self addSubview:email];
        
        manageButton = [CommonButton buttonWithText:NSLocalizedStringFromTable(@"ManageAccount", @"Buttons", nil) color:ButtonColorViolet];
        [manageButton setFrame:CGRectMake(0.0f,
                                          email.frame.origin.y + email.frame.size.height + 15.0f,
                                          manageButton.frame.size.width,
                                          manageButton.frame.size.height)];
        [manageButton setCenter:CGPointMake(email.center.x, manageButton.center.y)];
        [manageButton addTarget:self action:@selector(manageButtonTapped) forControlEvents:UIControlEventTouchUpInside];
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

#pragma mark - button

- (void)manageButtonTapped
{
    if ([self.delegate respondsToSelector:@selector(bigUserViewShouldOpenAccount:)])
    {
        [self.delegate bigUserViewShouldOpenAccount:self];
    }
}

#pragma mark - private

- (void)setPhotoUrl:(NSString *)url
           initials:(NSString *)initials
               name:(NSString *)nameStr
              email:(NSString *)emailStr
      sharesToMatch:(NSUInteger)toMatch
{
    [name setText:nameStr];
    [email setText:emailStr];
    [email setHidden:toMatch];
    [manageButton setHidden:toMatch];
    [separator setHidden:toMatch];
    [sharesToMatch setText:[NSString stringWithFormat:NSLocalizedStringFromTable(@"SharesToMatchFormat", @"Labels", nil), toMatch]];
    [sharesToMatch setHidden:!toMatch];
    [photo setUrl:url initials:initials compeltionHandler:nil];

}

@end
