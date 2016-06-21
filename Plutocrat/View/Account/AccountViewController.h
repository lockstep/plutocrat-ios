//
//  AccountViewController.h
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-10.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AccountViewController;

@protocol AccountViewControllerDelegate <NSObject>
@required

- (void)accountViewControllerUpdatedData:(AccountViewController *)accountViewController;

@end

@interface AccountViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>

@property (nonatomic, weak) id <AccountViewControllerDelegate> delegate;

@end
