//
//  BuyoutsStatsView.h
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-12.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuyoutsStatsView : UIView

- (void)setSuccessful:(NSUInteger)successful
               failed:(NSUInteger)failed
             defeated:(NSUInteger)defeated;

@end
