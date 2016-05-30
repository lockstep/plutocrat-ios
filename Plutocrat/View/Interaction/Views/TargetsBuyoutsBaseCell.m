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
    BOOL buttonEngages;
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
        [self addSubview:self.photo];
        
        CGFloat startingXForLabels = bordersOffset + self.photo.frame.size.width + [Globals offsetFromPhoto];
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(startingXForLabels,
                                                         self.photo.frame.origin.y,
                                                         self.frame.size.width - startingXForLabels * 2,
                                                         20.0f)];
        [self.name setAdjustsFontSizeToFitWidth:YES];
        [self.name setFont:[UIFont regularFontWithSize:18.0f]];
        [self.name setTextColor:[UIColor grayWithIntense:114.0f]];
        [self addSubview:self.name];
        
        self.info = [[UILabel alloc] initWithFrame:
                     CGRectMake(startingXForLabels,
                                self.name.frame.origin.y + self.name.frame.size.height - 5.0f,
                                120.0f,
                                60.0f)];
        [self.info setFont:[UIFont regularFontWithSize:11.0f]];
        [self.info setTextColor:[UIColor grayWithIntense:112.0f]];
        [self.info setNumberOfLines:3];
        [self addSubview:self.info];
        
        engageButton = [CommonButton smallButtonWithColor:ButtonColorGray titleColor:ButtonColorWhite];
        [engageButton setCenter:
         CGPointMake(self.frame.size.width - bordersOffset - engageButton.frame.size.width / 2,
                     [Globals cellHeight] / 2)];
        [engageButton setHidden:YES];
        [engageButton addTarget:self action:@selector(buttonTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:engageButton];
        
        engageReplace = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 65.0f, 28.0f)];
        [engageReplace setFont:[UIFont regularFontWithSize:11.0f]];
        [engageReplace setTextColor:[UIColor colorWithRed:208.0f / 255.0f green:0.0f blue:0.0f alpha:1.0f]];
        [engageReplace setNumberOfLines:0];
        [engageReplace setLineBreakMode:NSLineBreakByWordWrapping];
        [engageReplace setHidden:YES];
        [engageReplace setTextAlignment:NSTextAlignmentCenter];
        [engageReplace setCenter:
         CGPointMake(self.frame.size.width - bordersOffset - engageReplace.frame.size.width / 2,
                                             [Globals cellHeight] / 2)];
        [self addSubview:engageReplace];
        
        CommonSeparator * sep = [[CommonSeparator alloc] initWithFrame:
                                 CGRectMake([Globals horizontalOffsetInTable],
                                            [Globals cellHeight] - 1.0f,
                                            self.frame.size.width - [Globals horizontalOffsetInTable] * 2,
                                            1.0f)];
        [self addSubview:sep];
    }
    return self;
}

#pragma mark - public

- (void)setEngageButtonState:(EngageButtonState)state
{
    switch (state)
    {
        case EngageButtonDefaultState:
            [engageButton setHidden:NO];
            [engageButton setText:NSLocalizedStringFromTable(@"ENGAGE", @"Buttons", nil)];
            [engageReplace setHidden:YES];
            buttonEngages = YES;
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
            
        case EngageButtonToAbortState:
            [engageButton setHidden:NO];
            [engageButton setText:NSLocalizedStringFromTable(@"ABORT", @"Buttons", nil)];
            [engageReplace setHidden:YES];
            buttonEngages = NO;
            break;
            
        default:
            break;
    }
}

#pragma mark - button

- (void)buttonTapped
{
    if ([self.delegate respondsToSelector:@selector(buttonTappedToEngage:onCell:)])
    {
        [self.delegate buttonTappedToEngage:buttonEngages onCell:self];
    }
}

@end
