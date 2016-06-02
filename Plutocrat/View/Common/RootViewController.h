//
//  RootViewController.h
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-11.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "LeftPanelViewController.h"
#import "TabBarViewController.h"

@interface RootViewController : UIViewController <LoginViewControllerDelegate, LeftPanelDelegate, TabBarViewControllerDelegate>

@end
