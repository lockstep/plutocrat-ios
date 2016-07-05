//
//  TargetsBuyoutsBaseViewController.h
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-17.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TargetsBuyoutsHeader.h"

@class TargetsBuyoutsBaseViewController;

@protocol TargetsBuyoutsViewControllerDelegate <NSObject>
@required

- (void)targetsBuyoutsViewControllerShouldUpdateBuyouts:(TargetsBuyoutsBaseViewController *)controller;

@end

@interface TargetsBuyoutsBaseViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) id <TargetsBuyoutsViewControllerDelegate> delegate;
@property (nonatomic, strong) TargetsBuyoutsHeader * header;
@property (nonatomic, strong) UITableView * table;
@property (nonatomic, strong) UIRefreshControl * refreshControl;
@property NSUInteger currentPage;
@property (nonatomic, strong) NSMutableArray * source;
@property BOOL pulledToRefresh;

- (void)updateOnPush;

@end
