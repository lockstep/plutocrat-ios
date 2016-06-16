//
//  TargetsBuyoutsHeader.m
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-17.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import "TargetsBuyoutsHeader.h"
#import "CommonButton.h"
#import "UIImageView+Cached.h"

@implementation TargetsBuyoutsHeader
{
    UIImageView * background;
    UILabel * noPlutocrat;
    UIImageView * photo;
    UILabel * name;
    UILabel * plutocratBuyouts;
    CommonButton * engageButton;
    UILabel * successfulBuyouts;
    BOOL plutocratExists;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        const CGFloat averageFontSize = 24.0f;
        const CGFloat smallFontSize = 14.0f;
        
        background = [[UIImageView alloc] initWithFrame:frame];
        [self addSubview:background];
        
        noPlutocrat = [[UILabel alloc] initWithFrame:frame];
        [noPlutocrat setFont:[UIFont regularFontWithSize:averageFontSize]];
        [noPlutocrat setTextColor:[UIColor whiteColor]];
        [noPlutocrat setTextAlignment:NSTextAlignmentCenter];
        [noPlutocrat setText:NSLocalizedStringFromTable(@"NoPlutocrat", @"Labels", nil)];
        [noPlutocrat setHidden:YES];
        [self addSubview:noPlutocrat];
        
        CGFloat bordersOffset = [Globals horizontalOffsetInTable];
        photo = [[UIImageView alloc] initWithFrame:CGRectMake(bordersOffset,
                                                              28.0f,
                                                              74.0f,
                                                              74.0f)];
        [[photo layer] setCornerRadius:photo.frame.size.width / 2];
        [[photo layer] setBorderColor:[UIColor whiteColor].CGColor];
        [[photo layer] setBorderWidth:2.0f];
        [[photo layer] setMasksToBounds:YES];
        [photo setImage:[UIImage imageNamed:@"empty-profile-image"]];
        [photo setHidden:YES];
        [self addSubview:photo];
        
        CGFloat startingXForLabels = bordersOffset + photo.frame.size.width + [Globals offsetFromPhoto];
        name = [[UILabel alloc] initWithFrame:CGRectMake(startingXForLabels,
                                                         photo.frame.origin.y + 10.0f,
                                                         frame.size.width - startingXForLabels * 2,
                                                         24.0f)];
        [name setAdjustsFontSizeToFitWidth:YES];
        [name setFont:[UIFont regularFontWithSize:averageFontSize]];
        [name setTextColor:[UIColor whiteColor]];
        [name setHidden:YES];
        [self addSubview:name];
        
        plutocratBuyouts = [[UILabel alloc] initWithFrame:CGRectMake(startingXForLabels,
                                                         name.frame.origin.y + name.frame.size.height,
                                                         frame.size.width - startingXForLabels * 2,
                                                         40.0f)];
        [plutocratBuyouts setFont:[UIFont regularFontWithSize:smallFontSize]];
        [plutocratBuyouts setTextColor:[UIColor whiteColor]];
        [plutocratBuyouts setHidden:YES];
        [plutocratBuyouts setNumberOfLines:2];
        [self addSubview:plutocratBuyouts];
        
        engageButton = [CommonButton buttonWithText:NSLocalizedStringFromTable(@"ENGAGE", @"Buttons", nil) color:ButtonColorViolet];
        [engageButton setCenter:
         CGPointMake(frame.size.width - bordersOffset - engageButton.frame.size.width / 2,
                     frame.size.height / 2 + 10.0f)];
        [engageButton setHidden:YES];
        [engageButton addTarget:self action:@selector(buttonTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:engageButton];
        
        successfulBuyouts = [[UILabel alloc] initWithFrame:frame];
        [successfulBuyouts setFont:[UIFont regularFontWithSize:averageFontSize]];
        [successfulBuyouts setTextColor:[UIColor whiteColor]];
        [successfulBuyouts setTextAlignment:NSTextAlignmentCenter];
        [successfulBuyouts setHidden:YES];
        [self addSubview:successfulBuyouts];
    }
    return self;
}

#pragma mark - public

- (void)setType:(TargetsBuyoutsHeaderType)type
{
    switch (type)
    {
        case TargetsHeaderNoPlutocrat:
            [background setImage:[UIImage imageNamed:@"Background-blue"]];
            [noPlutocrat setHidden:NO];
            [photo setHidden:YES];
            [name setHidden:YES];
            [plutocratBuyouts setHidden:YES];
            [engageButton setHidden:YES];
            [successfulBuyouts setHidden:YES];
            plutocratExists = NO;
            break;
            
        case TargetsHeaderWithPlutocrat:
            [background setImage:[UIImage imageNamed:@"Background-blue"]];
            [noPlutocrat setHidden:YES];
            [photo setHidden:NO];
            [name setHidden:NO];
            [plutocratBuyouts setHidden:NO];
            [engageButton setHidden:NO];
            [successfulBuyouts setHidden:YES];
            plutocratExists = YES;
            break;
            
        case BuyoutsHeader:
            [background setImage:[UIImage imageNamed:@"Background-gray"]];
            [noPlutocrat setHidden:YES];
            [photo setHidden:YES];
            [name setHidden:YES];
            [plutocratBuyouts setHidden:YES];
            [engageButton setHidden:YES];
            [successfulBuyouts setHidden:NO];
            plutocratExists = NO;
            break;
            
        default:
            break;
    }
}

- (void)setImageUrl:(NSString *)url
{
    [photo setUrl:url compeltionHandler:nil];
}

- (void)setName:(NSString *)nameString
{
    [name setText:nameString];
}

- (void)setNumberOfBuyouts:(NSUInteger)number
{
    if (plutocratExists)
    {
        [plutocratBuyouts setText:
         [NSString stringWithFormat:NSLocalizedStringFromTable(@"PlutocratBuyouts", @"Labels", nil), number]];
    }
    else
    {
        [successfulBuyouts setText:
         [NSString stringWithFormat:NSLocalizedStringFromTable(@"SuccessfulBuyouts", @"Labels", nil), number]];
    }
}

- (void)buttonHide:(BOOL)hide
{
    [engageButton setHidden:hide];
}

#pragma mark - Button

- (void)buttonTapped
{
    if ([self.delegate respondsToSelector:@selector(buttonTappedToEngage)])
    {
        [self.delegate buttonTappedToEngage];
    }
}

@end
