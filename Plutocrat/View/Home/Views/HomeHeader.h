//
//  HomeHeader.h
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-13.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSUInteger, HomeHeaderType)
{
    HomeHeaderTypeCommon,
    HomeHeaderTypeThreated,
    HomeHeaderTypeDefeated
};

@interface HomeHeader : UIView

- (void)setType:(HomeHeaderType)type;
- (void)setDate:(NSDate *)date;
- (void)setSurvavalFromDate:(NSDate *)registered toDate:(NSDate *)defeated;

@end
