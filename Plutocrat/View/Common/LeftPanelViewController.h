//
//  LeftPanelViewController.h
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-03.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LeftPanelViewController;

@protocol LeftPanelDelegate <NSObject>
@required

- (void)leftPanelViewController:(LeftPanelViewController *)viewController shouldNavigateTo:(NavigateTo)dest;

@end

@interface LeftPanelViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) id <LeftPanelDelegate> delegate;

@end
