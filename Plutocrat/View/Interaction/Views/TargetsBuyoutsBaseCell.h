//
//  TargetsBuyoutsBaseCell.h
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-18.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSUInteger, EngageButtonState)
{
    EngageButtonDefaultState,
    EngageButtonUnderThreatState,
    EngageButtonAttackingYouState,
    EngageButtonEliminatedState,
    EngageButtonHidden
};

@class TargetsBuyoutsBaseCell;
@protocol TargetsBuyoutsCellDelegate <NSObject>

- (void)buttonTappedToEngageOnCell:(TargetsBuyoutsBaseCell *)cell;

@end

@interface TargetsBuyoutsBaseCell : UITableViewCell

@property (nonatomic, weak) id <TargetsBuyoutsCellDelegate> delegate;
@property (nonatomic, strong) UIImageView * photo;
@property (nonatomic, strong) UILabel * name;
@property (nonatomic, strong) UILabel * info;

- (void)setEngageButtonState:(EngageButtonState)state;

@end