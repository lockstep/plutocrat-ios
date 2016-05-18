//
//  BuyoutsCell.h
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-18.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import "TargetsBuyoutsBaseCell.h"

typedef NS_ENUM (NSUInteger, BuyoutCellState)
{
    BuyoutCellDefaultState,
    BuyoutCellSuccessedState,
    BuyoutCellYouFailedState,
    BuyoutCellHeFailed
};

@interface BuyoutsCell : TargetsBuyoutsBaseCell

- (void)setShares:(NSUInteger)shares time:(NSUInteger)time state:(BuyoutCellState)state;

@end
