//
//  LoginViewController.h
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-04.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoginViewController;

@protocol LoginViewControllerDelegate <NSObject>
@required

- (void)loginViewControllerShouldDismiss:(LoginViewController *)loginViewController;

@end

@interface LoginViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, weak) id <LoginViewControllerDelegate> delegate;

- (void)setupContentsWhenUserIsRegistered:(BOOL)userIsRegistered;
- (void)flushEmailAndPassword;

@end
