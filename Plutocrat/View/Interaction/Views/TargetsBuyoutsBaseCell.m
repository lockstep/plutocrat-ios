//
//  TargetsBuyoutsBaseCell.m
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-18.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import "TargetsBuyoutsBaseCell.h"
#import "CommonButton.h"
#import "CommonSeparator.h"

@implementation TargetsBuyoutsBaseCell
{
    CommonButton * engageButton;
    UILabel * engageReplace;
    UIActivityIndicatorView * iView;
    CommonSeparator * sep;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        CGFloat bordersOffset = [Globals horizontalOffsetInTable];
        self.photo = [[UIImageView alloc] initWithFrame:CGRectMake(bordersOffset,
                                                              13.0f,
                                                              74.0f,
                                                              74.0f)];
        [[self.photo layer] setCornerRadius:self.photo.frame.size.width / 2];
        [[self.photo layer] setMasksToBounds:YES];
        [self.contentView addSubview:self.photo];
        
        CGFloat startingXForLabels = bordersOffset + self.photo.frame.size.width + [Globals offsetFromPhoto];
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(startingXForLabels,
                                                         self.photo.frame.origin.y,
                                                         self.frame.size.width - startingXForLabels * 2,
                                                         20.0f)];
        [self.name setAdjustsFontSizeToFitWidth:YES];
        [self.name setFont:[UIFont regularFontWithSize:18.0f]];
        [self.name setTextColor:[UIColor grayWithIntense:114.0f]];
        [self.contentView addSubview:self.name];
        
        self.info = [[UILabel alloc] initWithFrame:
                     CGRectMake(startingXForLabels,
                                self.name.frame.origin.y + self.name.frame.size.height - 5.0f,
                                110.0f,
                                60.0f)];
        [self.info setFont:[UIFont regularFontWithSize:11.0f]];
        [self.info setTextColor:[UIColor grayWithIntense:112.0f]];
        [self.info setNumberOfLines:3];
        [self.contentView addSubview:self.info];
        
        engageButton = [CommonButton buttonWithText:NSLocalizedStringFromTable(@"ENGAGE", @"Buttons", nil) color:ButtonColorViolet];
        [engageButton setCenter:
         CGPointMake(self.frame.size.width - bordersOffset - engageButton.frame.size.width / 2,
                     [Globals cellHeight] / 2)];
        [engageButton setHidden:YES];
        [engageButton addTarget:self action:@selector(buttonTapped) forControlEvents:UIControlEventTouchUpInside];
        [engageButton setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
        [self.contentView addSubview:engageButton];
        
        engageReplace = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 65.0f, 28.0f)];
        [engageReplace setFont:[UIFont regularFontWithSize:11.0f]];
        [engageReplace setTextColor:[UIColor ourRed]];
        [engageReplace setNumberOfLines:0];
        [engageReplace setLineBreakMode:NSLineBreakByWordWrapping];
        [engageReplace setHidden:YES];
        [engageReplace setTextAlignment:NSTextAlignmentCenter];
        [engageReplace setCenter:
         CGPointMake(self.frame.size.width - bordersOffset - engageReplace.frame.size.width / 2,
                                             [Globals cellHeight] / 2)];
        [engageReplace setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
        [self.contentView addSubview:engageReplace];
        
        sep = [[CommonSeparator alloc] initWithFrame:
               CGRectMake([Globals horizontalOffsetInTable],
                          [Globals cellHeight] - 1.0f,
                          self.frame.size.width - [Globals horizontalOffsetInTable] * 2,
                          1.0f)];
        [sep setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [self.contentView addSubview:sep];
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self.photo setImage:nil];
    [self.name setText:@""];
    [self.info setText:@""];
    [engageButton setHidden:YES];
    [engageReplace setHidden:YES];
    [sep setHidden:YES];
}

#pragma mark - public

- (void)setEngageButtonState:(EngageButtonState)state
{
    switch (state)
    {
        case EngageButtonDefaultState:
            [engageButton setHidden:NO];
            [engageReplace setHidden:YES];
            break;
            
        case EngageButtonUnderThreatState:
            [engageButton setHidden:YES];
            [engageReplace setHidden:NO];
            [engageReplace setText:NSLocalizedStringFromTable(@"UnderThreat", @"Labels", nil)];
            break;
            
        case EngageButtonAttackingYouState:
            [engageButton setHidden:YES];
            [engageReplace setHidden:NO];
            [engageReplace setText:NSLocalizedStringFromTable(@"AttackingYou", @"Labels", nil)];
            break;
            
        case EngageButtonEliminatedState:
            [engageButton setHidden:YES];
            [engageReplace setHidden:NO];
            [engageReplace setText:NSLocalizedStringFromTable(@"Eliminated", @"Labels", nil)];
            break;

        case EngageButtonHidden:
            [engageButton setHidden:YES];
            [engageReplace setHidden:YES];
            break;
            
        default:
            break;
    }
}

- (void)setLoading:(BOOL)loading
{
    if (loading)
    {
        iView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [iView setCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)];
        [self.contentView addSubview:iView];
        [iView startAnimating];
    }
    else
    {
        [iView removeFromSuperview];
    }
    [sep setHidden:loading];
    [self.photo setHidden:loading];
    [self.name setHidden:loading];
    [self.info setHidden:loading];
}

- (void)hideSep
{
    [sep setHidden:YES];
}

#pragma mark - button

- (void)buttonTapped
{
    if ([self.delegate respondsToSelector:@selector(buttonTappedToEngageOnCell:)])
    {
        [self.delegate buttonTappedToEngageOnCell:self];
    }
}

@end
