//
//  LoginViewController.h
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-04.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate>

- (void)setupContentsWhenUserIsRegistered:(BOOL)userIsRegistered;

@end
