//
//  Globals.h
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-17.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSUInteger, NavigateTo)
{
    NavigateToAccount,
    NavigateToFAQ,
    NavigateToTargets,
    NavigateToSignOut
};

@interface Globals : NSObject

+ (CGFloat)horizontalOffset;
+ (CGFloat)horizontalOffsetInTable;
+ (CGFloat)cellHeight;
+ (CGFloat)offsetFromPhoto;
+ (CGFloat)tabBarHeight;
+ (CGFloat)headerHeight;

@end
