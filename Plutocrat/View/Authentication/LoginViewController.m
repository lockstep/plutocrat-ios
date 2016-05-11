//
//  LoginViewController.m
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-04.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import "LoginViewController.h"
#import "CommonSeparator.h"
#import "CommonCheckBoxWithText.h"
#import "CommonButton.h"
#import "ApiConnector.h"

#import <LocalAuthentication/LAContext.h>

@interface LoginViewController ()
{
    BOOL loginMode;
    UIView * scrollableContentHolder;
    UILabel * actionLabel;
    UITextField * displayName;
    UITextField * email;
    UITextField * password;
    CommonCheckBoxWithText * useTouchId;
    CommonButton * enterButton;
    CommonButton * loginButton;
    CommonButton * forgotPasswordButton;
    CommonButton * registerButton;
}
@end

@implementation LoginViewController

#pragma mark - public

- (void)setupContentsWhenUserIsRegistered:(BOOL)userIsRegistered
{
    loginMode = userIsRegistered;
    [self setupDerived:userIsRegistered];
}

#pragma mark - private

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setupCommon];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)setupCommon
{
    scrollableContentHolder = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scrollableContentHolder];
    
    UIColor * paleGray = [UIColor grayWithIntense:146.0f];
    const CGFloat bigFontSize = 20.0f;
    const CGFloat smallFontSize = 12.0f;
    CGFloat horizontalOffset = 28.0f;
    CGFloat heightsOfTextFields = 34.0f;
    CGFloat componentsWidth = self.view.bounds.size.width - horizontalOffset * 2;
    
    UILabel * welcome = [[UILabel alloc] initWithFrame:CGRectMake(horizontalOffset,
                                                                  90.0f,
                                                                  componentsWidth,
                                                                  40.0f)];
    [welcome setText:NSLocalizedStringFromTable(@"WelcomeTo", @"Texts", nil)];
    [welcome setTextColor:paleGray];
    [welcome setFont:[UIFont snFontWithSize:bigFontSize]];
    [scrollableContentHolder addSubview:welcome];
    
    UITextView * useShares = [[UITextView alloc] initWithFrame:CGRectMake(horizontalOffset,
                                                                          130.0f,
                                                                          componentsWidth,
                                                                          140.0f)];
    [useShares setEditable:NO];
    [useShares setSelectable:NO];
    [useShares.textContainer setLineFragmentPadding:0.0f];
    [useShares setTextContainerInset:UIEdgeInsetsZero];
    NSDictionary * baseAttrs = @{NSFontAttributeName:[UIFont snFontWithSize:smallFontSize],
                                 NSForegroundColorAttributeName:paleGray};
    
    NSString * useSharesString = NSLocalizedStringFromTable(@"UseShares", @"Texts", nil);
    NSString * stringToBold = NSLocalizedStringFromTable(@"UseSharesToBold", @"Texts", nil);
    
    NSDictionary * subAttrs = @{NSFontAttributeName:[UIFont snBoldFontWithSize:smallFontSize],
                                NSForegroundColorAttributeName:paleGray};
    const NSRange range = [useSharesString rangeOfString:stringToBold];
    
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithString:useSharesString attributes:baseAttrs];
    [attrStr setAttributes:subAttrs range:range];
    [useShares setAttributedText:attrStr];
    [scrollableContentHolder addSubview:useShares];
    
    actionLabel = [[UILabel alloc] initWithFrame:CGRectMake(horizontalOffset,
                                                            250.0f,
                                                            componentsWidth,
                                                            30.0f)];
    [actionLabel setTextColor:paleGray];
    [actionLabel setFont:[UIFont snFontWithSize:bigFontSize]];
    [scrollableContentHolder addSubview:actionLabel];
    
    
    displayName = [[UITextField alloc] initWithFrame:CGRectMake(horizontalOffset,
                                                                290.0f,
                                                                componentsWidth,
                                                                heightsOfTextFields)];
    [displayName setPlaceholder:NSLocalizedStringFromTable(@"DisplayName", @"Labels", nil)];
    [displayName setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [displayName setReturnKeyType:UIReturnKeyNext];
    [displayName setFont:[UIFont snFontWithSize:smallFontSize]];
    [displayName setDelegate:self];
    [displayName setHidden:YES];
    [scrollableContentHolder addSubview:displayName];
    
    CommonSeparator * sep = [[CommonSeparator alloc] initWithFrame:CGRectMake(0.0f,
                                                                              0.0f,
                                                                              componentsWidth,
                                                                              1.0f)];
    [displayName addSubview:sep];
    
    email = [[UITextField alloc] initWithFrame:CGRectMake(horizontalOffset,
                                                          0.0f,
                                                          componentsWidth,
                                                          heightsOfTextFields)];
    [email setPlaceholder:NSLocalizedStringFromTable(@"Email", @"Labels", nil)];
    [email setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [email setKeyboardType:UIKeyboardTypeEmailAddress];
    [email setReturnKeyType:UIReturnKeyNext];
    [email setFont:[UIFont snFontWithSize:smallFontSize]];
    [email setDelegate:self];
    [scrollableContentHolder addSubview:email];
    
    CommonSeparator * sep1 = [[CommonSeparator alloc] initWithFrame:CGRectMake(0.0f,
                                                                               0.0f,
                                                                               componentsWidth,
                                                                               1.0f)];
    [email addSubview:sep1];
    
    
    password = [[UITextField alloc] initWithFrame:CGRectMake(horizontalOffset,
                                                             0.0f,
                                                             componentsWidth,
                                                             heightsOfTextFields)];
    [password setPlaceholder:NSLocalizedStringFromTable(@"Password", @"Labels", nil)];
    [password setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [password setSecureTextEntry:YES];
    [password setReturnKeyType:UIReturnKeyDone];
    [password setFont:[UIFont snFontWithSize:smallFontSize]];
    [password setDelegate:self];
    [scrollableContentHolder addSubview:password];
    
    CommonSeparator * sep2 = [[CommonSeparator alloc] initWithFrame:CGRectMake(0.0f,
                                                                               0.0f,
                                                                               componentsWidth,
                                                                               1.0f)];
    [password addSubview:sep2];
    
    CommonSeparator * sep3 = [[CommonSeparator alloc] initWithFrame:CGRectMake(0.0f,
                                                                               heightsOfTextFields - 1.0f,
                                                                               componentsWidth,
                                                                               1.0f)];
    [password addSubview:sep3];
    
    useTouchId = [CommonCheckBoxWithText checkBoxWithText:NSLocalizedStringFromTable(@"UseTouchId", @"Labels", nil) size:CGSizeMake(componentsWidth, 20.0f) defaultState:YES];
    [self.view addSubview:useTouchId];
    
    LAContext *context = [LAContext new];
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil])
    {
        [useTouchId setHidden:NO];
    }
    else
    {
        [useTouchId setHidden:YES];
    }
    
    enterButton = [CommonButton smallButtonWithColor:buttonColorGray];
    [enterButton setText:NSLocalizedStringFromTable(@"ENTER", @"Buttons", nil)];
    [enterButton addTarget:self action:@selector(enterButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:enterButton];
    
    loginButton = [CommonButton textButton:NSLocalizedStringFromTable(@"Login", @"Labels", nil)];
    [loginButton addTarget:self action:@selector(loginButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    forgotPasswordButton = [CommonButton textButton:NSLocalizedStringFromTable(@"ForgotPassword", @"Labels", nil)];
    [forgotPasswordButton addTarget:self action:@selector(forgotPasswordButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgotPasswordButton];
    
    registerButton = [CommonButton textButton:NSLocalizedStringFromTable(@"Register", @"Labels", nil)];
    [registerButton addTarget:self action:@selector(registerButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerButton];
}

- (void)setupDerived:(BOOL)userIsRegistered
{    
    CGFloat heightsOfTextFields = 34.0f;
    CGFloat modeDiff = userIsRegistered ? 0 : heightsOfTextFields;

    [displayName setHidden:userIsRegistered];
    
    [email setFrame:CGRectMake(email.frame.origin.x,
                              290.0f + modeDiff,
                              email.frame.size.width,
                              email.frame.size.height)];
    
    [password setFrame:CGRectMake(password.frame.origin.x,
                                  email.frame.origin.y + heightsOfTextFields,
                                  password.frame.size.width,
                                  password.frame.size.height)];
    
    [useTouchId setFrame:CGRectMake(password.frame.origin.x,
                                    password.frame.origin.y + heightsOfTextFields + 10.0f,
                                    useTouchId.frame.size.width,
                                    useTouchId.frame.size.height)];
    
    CGFloat enterButtonOriginY = useTouchId.frame.origin.y;
    if (!useTouchId.isHidden) enterButtonOriginY += useTouchId.frame.size.height + 10.0f;
    
    [enterButton setFrame:CGRectMake(password.frame.origin.x,
                                enterButtonOriginY,
                                enterButton.frame.size.width,
                                enterButton.frame.size.height)];
    
    CGFloat spaceLeftStartPoint = enterButton.frame.origin.y + enterButton.frame.size.height;
    CGFloat spaceLeftHeight = self.view.bounds.size.height - spaceLeftStartPoint;
    CGFloat spaceLeftCenter = spaceLeftStartPoint + spaceLeftHeight / 2;
    [loginButton setCenter:CGPointMake(password.frame.origin.x + loginButton.frame.size.width / 2,
                                       spaceLeftCenter)];
    [forgotPasswordButton setCenter:CGPointMake(password.frame.origin.x + forgotPasswordButton.frame.size.width / 2,
                                                spaceLeftCenter - 15.0f)];
    [registerButton setCenter:CGPointMake(password.frame.origin.x + registerButton.frame.size.width / 2,
                                          spaceLeftCenter + 15.0f)];
    
    [loginButton setHidden:userIsRegistered];
    [forgotPasswordButton setHidden:!userIsRegistered];
    [registerButton setHidden:!userIsRegistered];
    
    if (userIsRegistered)
    {
        [actionLabel setText:NSLocalizedStringFromTable(@"SignIn", @"Labels", nil)];
    }
    else
    {
        [actionLabel setText:NSLocalizedStringFromTable(@"Register", @"Labels", nil)];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == displayName)
    {
        [email becomeFirstResponder];
    }
    if (textField == email)
    {
        [password becomeFirstResponder];
    }
    if (textField == password)
    {
        [password resignFirstResponder];
    }
    return NO;
}

#pragma mark - Keyboard

static CGFloat fieldsAndKeyboardTotalHeight = 620.0f;

CGFloat scrollingHeight()
{
    CGFloat res = 0.0f;
    if ([UIScreen mainScreen].bounds.size.height < fieldsAndKeyboardTotalHeight) // small iPhones
    {
        res = fieldsAndKeyboardTotalHeight - [UIScreen mainScreen].bounds.size.height;
    }
    return res;
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGRect frame = scrollableContentHolder.frame;
    if (frame.origin.y < 0.0f) return;
    
    void (^animations)() = ^() {
        CGRect frame = scrollableContentHolder.frame;
        frame.origin.y -= scrollingHeight();
        scrollableContentHolder.frame = frame;
    };
    
    [UIView animateWithDuration:0.5f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:animations
                     completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    CGRect frame = scrollableContentHolder.frame;
    if (frame.origin.y >= 0.0f) return;
    
    void (^animations)() = ^() {
        CGRect frame = scrollableContentHolder.frame;
        frame.origin.y += scrollingHeight();
        scrollableContentHolder.frame = frame;
    };
    
    [UIView animateWithDuration:0.5f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:animations
                     completion:nil];
}

#pragma mark - Buttons handlers

- (void)enterButtonTouched
{
    if ([self.delegate respondsToSelector:@selector(loginViewControllerShouldDismiss:)])
    {
        [self.delegate loginViewControllerShouldDismiss:self];
    }
    
//    if (loginMode)
//    {
//        NSString * emailStr = email.text;
//        NSString * passwordStr = password.text;
//        [ApiConnector signInWithEmail:emailStr password:passwordStr completion:
//         ^(NSDictionary * response, NSString * error) {
//             
//         }];
//    }
//    else
//    {
//        NSString * displayNameStr = displayName.text;
//        NSString * emailStr = email.text;
//        NSString * passwordStr = password.text;
//        [ApiConnector signUpWithDisplayName:displayNameStr email:emailStr password:passwordStr completion:
//         ^(NSDictionary * response, NSString * error) {
//            
//        }];
//    }
}

- (void)loginButtonTouched
{
    [self setupContentsWhenUserIsRegistered:YES];
}

- (void)forgotPasswordButtonTouched
{
    //TODO: to forgot password screen
}

- (void)registerButtonTouched
{
    [self setupContentsWhenUserIsRegistered:NO];
}

@end
