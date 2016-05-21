//
//  SelectShares.h
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-20.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectShares : UIView

- (void)setMin:(NSUInteger)min value:(NSUInteger)value max:(NSUInteger)max;
- (NSUInteger)value;

@end
