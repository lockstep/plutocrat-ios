//
//  TargetsCell.h
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-18.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import "TargetsBuyoutsBaseCell.h"

@interface TargetsCell : TargetsBuyoutsBaseCell

- (void)setBuyouts:(NSUInteger)buyouts threats:(NSUInteger)threats days:(NSUInteger)days;

@end
