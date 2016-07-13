//
//  AttackerView.m
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-12.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import "AttackerView.h"
#import "CommonButton.h"
#import "CommonSeparator.h"

@implementation AttackerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.attacker = [[BigUserView alloc] initWithFrame:CGRectMake(0.0f,
                                                                      0.0f,
                                                                      frame.size.width,
                                                                      136.0f)];
        [self addSubview:self.attacker];
        
        CGFloat bordersOffset = [Globals horizontalOffset];
        UILabel * warning = [[UILabel alloc] initWithFrame:
                             CGRectMake(bordersOffset,
                                        136.0f,
                                        frame.size.width - bordersOffset * 2,
                                        100.0f)];
                                        
                                                                      
        [warning setFont:[UIFont regularFontWithSize:11.0f]];
        [warning setTextColor:[UIColor grayWithIntense:146.0f]];
        [warning setNumberOfLines:0];
        [warning setLineBreakMode:NSLineBreakByWordWrapping];
        [warning setText:NSLocalizedStringFromTable(@"WARNING", @"Texts", nil)];
        [self addSubview:warning];
        
        CommonButton * accept = [CommonButton buttonWithText:NSLocalizedStringFromTable(@"ACCEPT", @"Buttons", nil) color:ButtonColorRed];
        [accept setCenter:CGPointMake(bordersOffset + accept.frame.size.width / 2,
                                      256.0f + accept.frame.size.height / 2)];
        [accept addTarget:self action:@selector(acceptTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:accept];
        
        CommonButton * match = [CommonButton buttonWithText:NSLocalizedStringFromTable(@"MATCH", @"Buttons", nil) color:ButtonColorViolet];
        [match setCenter:CGPointMake(self.frame.size.width -  bordersOffset - match.frame.size.width / 2,
                                      256.0f + match.frame.size.height / 2)];
        [match addTarget:self action:@selector(matchTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:match];
        
        CommonSeparator * sep = [[CommonSeparator alloc] initWithFrame:
                                 CGRectMake(bordersOffset,
                                            frame.size.height - 1.0f,
                                            frame.size.width - bordersOffset * 2,
                                            1.0f)];
        [self addSubview:sep];
    }
    return self;
}

#pragma mark - buttons

- (void)acceptTapped
{
    if ([self.delegate respondsToSelector:@selector(attackerViewDidAcceptDefeat:)])
    {
        [self.delegate attackerViewDidAcceptDefeat:self];
    }
}

- (void)matchTapped
{
    if ([self.delegate respondsToSelector:@selector(attackerViewDidMatchShares:)])
    {
        [self.delegate attackerViewDidMatchShares:self];
    }
}

@end
