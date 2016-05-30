//
//  LeftPanelViewController.h
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-03.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSUInteger, NavigateTo)
{
    NavigateToAccount,
    NavigateToFAQ,
    NavigateToSignOut
};

@class LeftPanelViewController;

@protocol LeftPanelDelegate <NSObject>
@required

- (void)leftPanelViewController:(LeftPanelViewController *)viewController should:(NavigateTo)dest;

@end

@interface LeftPanelViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) id <LeftPanelDelegate> delegate;

@end
