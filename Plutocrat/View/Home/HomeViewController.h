//
//  HomeViewController.h
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-03.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BigUserView.h"
#import "HomeInfo.h"
#import "AttackerView.h"

@class HomeViewController;

@protocol HomeViewControllerDelegate <NSObject>
@required

- (void)homeViewController:(HomeViewController *)controller shouldNavigateTo:(NavigateTo)dest;
- (void)homeViewControllerAskedForPushes:(HomeViewController *)controller;
- (void)homeViewControllerDefeated:(HomeViewController *)controller;

@end

@interface HomeViewController : UIViewController <HomeInfoDelegate, BigUserViewDelegate, AttackerViewDelegate>

@property (nonatomic, weak) id <HomeViewControllerDelegate> delegate;

- (void)refreshData;

@end
