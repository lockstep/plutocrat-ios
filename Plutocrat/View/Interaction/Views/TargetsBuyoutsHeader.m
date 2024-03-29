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
#import "CommonHeader.h"

@implementation TargetsBuyoutsHeader
{
    UIImageView * background;
    UILabel * noPlutocrat;
    UIImageView * photo;
    UILabel * name;
    UILabel * plutocratBuyouts;
    CommonButton * engageButton;
    UILabel * engageReplace;
    BOOL plutocratExists;
    CommonHeader * buyoutsHeader;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        const CGFloat bigFontSize = 28.0f;
        const CGFloat averageFontSize = 20.0f;
        const CGFloat smallFontSize = 16.0f;
        
        background = [[UIImageView alloc] initWithFrame:frame];
        [background setImage:[UIImage imageNamed:@"Background-blue"]];
        [self addSubview:background];
        
        noPlutocrat = [[UILabel alloc] initWithFrame:frame];
        [noPlutocrat setFont:[UIFont regularFontWithSize:averageFontSize]];
        [noPlutocrat setTextColor:[UIColor whiteColor]];
        [noPlutocrat setTextAlignment:NSTextAlignmentCenter];
        [noPlutocrat setText:NSLocalizedStringFromTable(@"NoPlutocrat", @"Labels", nil)];
        [noPlutocrat setShadowColor:[UIColor blackColor]];
        [noPlutocrat setShadowOffset:CGSizeMake(1.0f, 1.0f)];
        [noPlutocrat setHidden:YES];
        [self addSubview:noPlutocrat];
        
        CGFloat bordersOffset = [Globals horizontalOffsetInTable];
        photo = [[UIImageView alloc] initWithFrame:CGRectMake(bordersOffset,
                                                              40.0f,
                                                              74.0f,
                                                              74.0f)];
        [[photo layer] setCornerRadius:photo.frame.size.width / 2];
        [[photo layer] setBorderColor:[UIColor whiteColor].CGColor];
        [[photo layer] setBorderWidth:1.0f];
        [[photo layer] setMasksToBounds:YES];
        [photo setImage:[UIImage imageNamed:@"empty-profile-image"]];
        [photo setHidden:YES];
        [self addSubview:photo];
        
        CGFloat startingXForLabels = bordersOffset + photo.frame.size.width + [Globals offsetFromPhoto];
        name = [[UILabel alloc] initWithFrame:CGRectMake(startingXForLabels,
                                                         photo.frame.origin.y,
                                                         frame.size.width - startingXForLabels * 2,
                                                         28.0f)];
        [name setAdjustsFontSizeToFitWidth:YES];
        [name setFont:[UIFont regularFontWithSize:bigFontSize]];
        [name setTextColor:[UIColor whiteColor]];
        [name setHidden:YES];
        name.shadowColor = [UIColor blackColor];
        name.shadowOffset = CGSizeMake(1.0f, 1.0f);
        [self addSubview:name];
        
        plutocratBuyouts = [[UILabel alloc] initWithFrame:CGRectMake(startingXForLabels,
                                                         name.frame.origin.y + name.frame.size.height + 5.0f,
                                                         frame.size.width - startingXForLabels * 2,
                                                         40.0f)];
        [plutocratBuyouts setFont:[UIFont regularFontWithSize:smallFontSize]];
        [plutocratBuyouts setTextColor:[UIColor whiteColor]];
        [plutocratBuyouts setHidden:YES];
        [plutocratBuyouts setNumberOfLines:2];
        [self addSubview:plutocratBuyouts];
        
        engageButton = [CommonButton buttonWithText:NSLocalizedStringFromTable(@"ENGAGE", @"Buttons", nil) color:ButtonColorHardWhite];
        [engageButton setBackgroundColor:[UIColor whiteColor]];
        [engageButton setCenter:
         CGPointMake(frame.size.width - bordersOffset - engageButton.frame.size.width / 2,
                     frame.size.height / 2 + 10.0f)];
        [engageButton setHidden:YES];
        [engageButton addTarget:self action:@selector(buttonTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:engageButton];

        engageReplace = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 65.0f, 28.0f)];
        [engageReplace setFont:[UIFont regularFontWithSize:11.0f]];
        [engageReplace setTextColor:[UIColor whiteColor]];
        [engageReplace setNumberOfLines:0];
        [engageReplace setLineBreakMode:NSLineBreakByWordWrapping];
        [engageReplace setHidden:YES];
        [engageReplace setTextAlignment:NSTextAlignmentCenter];
        [engageReplace setCenter:
         CGPointMake(self.frame.size.width - bordersOffset - engageReplace.frame.size.width / 2,
                     frame.size.height / 2 + 10.0f)];
        [self addSubview:engageReplace];

        buyoutsHeader = [[CommonHeader alloc] initWithFrame:frame];
        [buyoutsHeader setHidden:YES];
        [self addSubview:buyoutsHeader];
    }
    return self;
}

#pragma mark - public

- (void)setType:(TargetsBuyoutsHeaderType)type
{
    switch (type)
    {
        case TargetsHeaderNoPlutocrat:
            [noPlutocrat setHidden:NO];
            [photo setHidden:YES];
            [name setHidden:YES];
            [plutocratBuyouts setHidden:YES];
            [engageButton setHidden:YES];
            [engageReplace setHidden:YES];
            [buyoutsHeader setHidden:YES];
            plutocratExists = NO;
            break;
            
        case TargetsHeaderWithPlutocrat:
            [noPlutocrat setHidden:YES];
            [photo setHidden:NO];
            [name setHidden:NO];
            [plutocratBuyouts setHidden:NO];
            [engageButton setHidden:NO];
            [engageReplace setHidden:YES];
            [buyoutsHeader setHidden:YES];
            plutocratExists = YES;
            break;

        case TargetsHeaderWithPlutocratUnderThreat:
            [noPlutocrat setHidden:YES];
            [photo setHidden:NO];
            [name setHidden:NO];
            [plutocratBuyouts setHidden:NO];
            [engageButton setHidden:YES];
            [engageReplace setHidden:NO];
            [engageReplace setText:NSLocalizedStringFromTable(@"UnderThreat", @"Labels", nil)];
            [buyoutsHeader setHidden:YES];
            plutocratExists = YES;
            break;

        case TargetsHeaderWithPlutocratAttackingYou:
            [noPlutocrat setHidden:YES];
            [photo setHidden:NO];
            [name setHidden:NO];
            [plutocratBuyouts setHidden:NO];
            [engageButton setHidden:YES];
            [engageReplace setHidden:NO];
            [engageReplace setText:NSLocalizedStringFromTable(@"AttackingYou", @"Labels", nil)];
            [buyoutsHeader setHidden:YES];
            plutocratExists = YES;
            break;

        case TargetsHeaderWithPlutocratIsYou:
            [noPlutocrat setHidden:YES];
            [photo setHidden:NO];
            [name setHidden:NO];
            [plutocratBuyouts setHidden:NO];
            [engageButton setHidden:YES];
            [engageReplace setHidden:YES];
            [buyoutsHeader setHidden:YES];
            plutocratExists = YES;
            break;

        case BuyoutsHeader:
            [noPlutocrat setHidden:YES];
            [photo setHidden:YES];
            [name setHidden:YES];
            [plutocratBuyouts setHidden:YES];
            [engageButton setHidden:YES];
            [engageReplace setHidden:YES];
            [buyoutsHeader setHidden:NO];
            plutocratExists = NO;
            break;
            
        default:
            break;
    }
}

- (void)setImageUrl:(NSString *)url initials:(NSString *)initials
{
    [photo setUrl:url initials:initials compeltionHandler:nil];
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
         [NSString stringWithFormat:NSLocalizedStringFromTable(@"PlutocratBuyouts", @"Labels", nil), number, number == 1 ? @"" : @"s"]];
    }
    else
    {
        [buyoutsHeader setText:NSLocalizedStringFromTable(@"BuyoutHistory", @"Labels", nil) descText:[NSString stringWithFormat:NSLocalizedStringFromTable(@"SuccessfulBuyouts", @"Labels", nil), number, number == 1 ? @"" : @"s"]];
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
