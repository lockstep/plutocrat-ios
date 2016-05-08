//
//  CommonCheckBoxWithText.h
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-09.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonCheckBoxWithText : UIView

+ (instancetype)checkBoxWithText:(NSString *)text size:(CGSize)size defaultState:(BOOL)selected;

@end
