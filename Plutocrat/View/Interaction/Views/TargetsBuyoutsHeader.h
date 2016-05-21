//
//  TargetsBuyoutsHeader.h
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-17.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSUInteger, TargetsBuyoutsHeaderType)
{
    TargetsHeaderNoPlutocrat,
    TargetsHeaderWithPlutocrat,
    BuyoutsHeader
};

@protocol TargetsBuyotsHeaderDelegate <NSObject>

- (void)buttonTappedToEngage:(BOOL)toEngage;

@end

@interface TargetsBuyoutsHeader : UIView

@property (nonatomic, weak) id <TargetsBuyotsHeaderDelegate> delegate;

- (void)setType:(TargetsBuyoutsHeaderType)type;
- (void)setImage:(UIImage *)image;
- (void)setName:(NSString *)nameString;
- (void)setNumberOfBuyouts:(NSUInteger)number;
- (void)setButtonToEngageState:(BOOL)state;

@end
