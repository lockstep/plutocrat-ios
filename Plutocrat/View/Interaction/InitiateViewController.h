//
//  InitiateViewController.h
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-20.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

typedef NS_ENUM (NSUInteger, BackImageType)
{
    BackImageTypeTargets,
    BackImageTypeBuyouts
};

@class InitiateViewController;

@protocol InitiateViewControllerDelegate <NSObject>
@required

- (void)initiateViewController:(InitiateViewController *)controller initiatedBuyoutAndShouldRefreshCellWithTag:(NSUInteger)tag;

@end

@interface InitiateViewController : UIViewController

@property (nonatomic, weak) id <InitiateViewControllerDelegate> delegate;

- (void)setUser:(User *)user cellTag:(NSUInteger)tag;
- (void)setBackImageType:(BackImageType)type;

@end
