//
//  InitiateViewController.h
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-20.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSUInteger, BackImageType)
{
    BackImageTypeTargets,
    BackImageTypeBuyouts
};

@interface InitiateViewController : UIViewController

- (void)stubName:(NSString *)name;
- (void)setBackImageType:(BackImageType)type;

@end
