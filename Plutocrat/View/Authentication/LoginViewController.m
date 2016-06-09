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
#import "UserManager.h"
#import "Settings.h"
#import "KeychainWrapper.h"

#import <LocalAuthentication/LAContext.h>

#define EULA_ADDRESS @"http://www.whiteflyventuresinc.com/plutocrat/eula.html"
#define PRIVACY_ADDRESS @"https://www.whiteflyventuresinc.com/plutocrat/privacy.html"

@interface LoginViewController ()
{
    BOOL loginMode;
    UIScrollView * view;
    UILabel * actionLabel;
    UITextField * displayName;
    UITextField * email;
    UITextField * password;
    CommonButton * submitButton;
    CommonButton * loginButton;
    CommonButton * registerButton;
    CommonButton * eulaButton;
    CommonButton * privacyButton;
    CommonButton * forgotPasswordButton;
    KeychainWrapper * wrapper;
    UIActivityIndicatorView * iView;
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
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setupCommon];
}

- (void)setupCommon
{
    view = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:view];

    UIColor * paleGray = [UIColor grayWithIntense:146.0f];
    const CGFloat bigFontSize = 24.0f;
    const CGFloat smallFontSize = 14.0f;
    CGFloat horizontalOffset = [Globals horizontalOffset];
    CGFloat heightsOfTextFields = 34.0f;
    CGFloat componentsWidth = self.view.bounds.size.width - horizontalOffset * 2;

    actionLabel = [[UILabel alloc] initWithFrame:CGRectMake(horizontalOffset,
                                                            50.0f,
                                                            componentsWidth,
                                                            30.0f)];
    [actionLabel setTextColor:paleGray];
    [actionLabel setFont:[UIFont regularFontWithSize:bigFontSize]];
    [view addSubview:actionLabel];
    
    
    displayName = [[UITextField alloc] initWithFrame:CGRectMake(horizontalOffset,
                                                                100.0f,
                                                                componentsWidth,
                                                                heightsOfTextFields)];
    [displayName setPlaceholder:NSLocalizedStringFromTable(@"DisplayName", @"Labels", nil)];
    [displayName setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [displayName setReturnKeyType:UIReturnKeyNext];
    [displayName setFont:[UIFont regularFontWithSize:smallFontSize]];
    [displayName setDelegate:self];
    [displayName setHidden:YES];
    [view addSubview:displayName];
    
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
    [email setFont:[UIFont regularFontWithSize:smallFontSize]];
    [email setDelegate:self];
    [view addSubview:email];
    
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
    [password setFont:[UIFont regularFontWithSize:smallFontSize]];
    [password setDelegate:self];
    [view addSubview:password];
    
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

    submitButton = [CommonButton buttonWithText:NSLocalizedStringFromTable(@"SUBMIT", @"Buttons", nil) color:ButtonColorViolet];
    [submitButton addTarget:self action:@selector(submitButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:submitButton];
    
    loginButton = [CommonButton buttonWithText:NSLocalizedStringFromTable(@"LOGIN", @"Buttons", nil) color:ButtonColorViolet];
    [loginButton addTarget:self action:@selector(loginButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:loginButton];
    
    registerButton = [CommonButton buttonWithText:NSLocalizedStringFromTable(@"REGISTER", @"Buttons", nil) color:ButtonColorViolet];
    [registerButton addTarget:self action:@selector(registerButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:registerButton];

    eulaButton = [CommonButton buttonWithText:NSLocalizedStringFromTable(@"EULA", @"Buttons", nil) color:ButtonColorGray];
    [eulaButton setCenter:CGPointMake(view.frame.size.width / 2 + eulaButton.frame.size.width / 2,
                                      view.bounds.size.height - eulaButton.frame.size.height)];
    [eulaButton addTarget:self action:@selector(eulaButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:eulaButton];

    privacyButton = [CommonButton buttonWithText:NSLocalizedStringFromTable(@"PRIVACY", @"Buttons", nil) color:ButtonColorGray];
    [privacyButton setCenter:
     CGPointMake(view.frame.size.width - horizontalOffset -  privacyButton.frame.size.width / 2,
                 view.bounds.size.height - privacyButton.frame.size.height)];
    [privacyButton addTarget:self action:@selector(privacyButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:privacyButton];

    forgotPasswordButton = [CommonButton buttonWithText:NSLocalizedStringFromTable(@"FORGOTPASSWORD", @"Buttons", nil) color:ButtonColorGray];
    [forgotPasswordButton setCenter:
     CGPointMake(view.frame.size.width - horizontalOffset -  forgotPasswordButton.frame.size.width / 2,
                 view.bounds.size.height - forgotPasswordButton.frame.size.height)];
    [forgotPasswordButton addTarget:self action:@selector(forgotPasswordButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:forgotPasswordButton];

    [view setContentSize:CGSizeMake(view.frame.size.width, view.frame.size.height + 1.0f)];

    wrapper = [KeychainWrapper new];
}

- (void)setupDerived:(BOOL)userIsRegistered
{    
    CGFloat heightsOfTextFields = 34.0f;
    CGFloat modeDiff = userIsRegistered ? 0 : heightsOfTextFields;

    [displayName setHidden:userIsRegistered];
    
    [email setFrame:CGRectMake(email.frame.origin.x,
                              100.0f + modeDiff,
                              email.frame.size.width,
                              email.frame.size.height)];
    
    [password setFrame:CGRectMake(password.frame.origin.x,
                                  email.frame.origin.y + heightsOfTextFields,
                                  password.frame.size.width,
                                  password.frame.size.height)];

    [submitButton setCenter:CGPointMake(password.frame.origin.x + submitButton.frame.size.width / 2,
                                        password.frame.origin.y + heightsOfTextFields + submitButton.frame.size.height / 2 + 20.0f)];

    [loginButton setCenter:CGPointMake(password.frame.origin.x + loginButton.frame.size.width / 2,
                                       view.bounds.size.height - loginButton.frame.size.height)];
    [registerButton setCenter:CGPointMake(password.frame.origin.x + registerButton.frame.size.width / 2,
                                          view.bounds.size.height - registerButton.frame.size.height)];

    [loginButton setHidden:userIsRegistered];
    [registerButton setHidden:!userIsRegistered];
    [eulaButton setHidden:userIsRegistered];
    [privacyButton setHidden:userIsRegistered];
    [forgotPasswordButton setHidden:!userIsRegistered];
    
    if (userIsRegistered)
    {
        [actionLabel setText:NSLocalizedStringFromTable(@"SignIn", @"Labels", nil)];
        LAContext * context = [LAContext new];
        if ([Settings isTouchIDEnabled] && [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil])
        {
            [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:NSLocalizedStringFromTable(@"UseTouchIDToLogin", @"Labels", nil) reply:^(BOOL success, NSError * error)
             {
                 if (success)
                 {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [email setText:[Settings userEmail]];
                         [password setText:@"xxxxxxxx"];
                     });
                     [self loginWithEmail:[Settings userEmail]
                                 password:[wrapper myObjectForKey:(__bridge id)kSecValueData]];
                 }
                 else
                 {
                     if (error.code != 3 && error.code != -2)
                     {
                         [self showAlertWithErrorText:[error localizedDescription]];
                     }
                 }
             }];
        }
    }
    else
    {
        [Settings setDefaults];
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

#pragma mark - Buttons handlers

- (void)submitButtonTouched
{
    if (loginMode)
    {
        NSString * emailStr = email.text;
        NSString * passwordStr = password.text;
        if (emailStr.length * passwordStr.length == 0)
        {
            [self showAlertEmptyFields];
        }
        else
        {
            [self loginWithEmail:emailStr password:passwordStr];
        }
    }
    else
    {
        NSString * displayNameStr = displayName.text;
        NSString * emailStr = email.text;
        NSString * passwordStr = password.text;
        if (displayNameStr.length * emailStr.length * passwordStr.length == 0)
        {
            [self showAlertEmptyFields];
        }
        else
        {
            [self registerWithName:displayNameStr email:emailStr password:passwordStr];
        }
    }
}

- (void)loginButtonTouched
{
    [self setupContentsWhenUserIsRegistered:YES];
}

- (void)registerButtonTouched
{
    [self setupContentsWhenUserIsRegistered:NO];
}

- (void)eulaButtonTouched
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:EULA_ADDRESS]];
}

- (void)privacyButtonTouched
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:PRIVACY_ADDRESS]];
}

- (void)forgotPasswordButtonTouched
{

}

#pragma mark - Login and Register

- (void)loginWithEmail:(NSString *)emailStr password:(NSString *)passwordStr
{
    [self startActivity];
    [ApiConnector signInWithEmail:emailStr password:passwordStr completion:
     ^(NSDictionary * response, NSString * error) {
         if (!error)
         {
             [Settings setUserEmail:emailStr];
             [wrapper mySetObject:passwordStr forKey:(__bridge id)kSecValueData];
             if ([self.delegate respondsToSelector:@selector(loginViewControllerShouldDismiss:)])
             {
                 [self.delegate loginViewControllerShouldDismiss:self];
             }
         }
         else
         {
             [self stopActivity];
             [self showAlertWithErrorText:error];
         }
     }];
}

- (void)registerWithName:(NSString *)nameStr email:(NSString *)emailStr password:(NSString *)passwordStr
{
    [self startActivity];
    [ApiConnector signUpWithDisplayName:nameStr email:emailStr password:passwordStr completion:
     ^(NSDictionary * response, NSString * error)
     {
         if (!error)
         {
             if ([self.delegate respondsToSelector:@selector(loginViewControllerShouldDismiss:)])
             {
                 [self.delegate loginViewControllerShouldDismiss:self];
             }
         }
         else
         {
             [self stopActivity];
             [self showAlertWithErrorText:error];
         }
     }];
}

#pragma mark - Activity

- (void)startActivity
{
    iView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    dispatch_async(dispatch_get_main_queue(), ^{
        [iView setCenter:self.view.center];
        [self.view addSubview:iView];
        [iView startAnimating];
        [submitButton setEnabled:NO];
        [email setUserInteractionEnabled:NO];
        [password setUserInteractionEnabled:NO];
        [displayName setUserInteractionEnabled:NO];
        [email resignFirstResponder];
        [password resignFirstResponder];
        [displayName resignFirstResponder];
        [loginButton setEnabled:NO];
        [registerButton setEnabled:NO];
        [eulaButton setEnabled:NO];
        [privacyButton setEnabled:NO];
        [forgotPasswordButton setEnabled:NO];
    });
}

- (void)stopActivity
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [submitButton setEnabled:YES];
        [email setUserInteractionEnabled:YES];
        [password setUserInteractionEnabled:YES];
        [displayName setUserInteractionEnabled:YES];
        [loginButton setEnabled:YES];
        [registerButton setEnabled:YES];
        [eulaButton setEnabled:YES];
        [privacyButton setEnabled:YES];
        [forgotPasswordButton setEnabled:YES];
        [iView removeFromSuperview];
    });
}

#pragma mark - Alerts

- (void)showAlertEmptyFields
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:NSLocalizedStringFromTable(@"Alert", @"Labels", nil)
            message:NSLocalizedStringFromTable(@"EmptyFields", @"Labels", nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:nil];

        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    });
}

- (void)showAlertWithErrorText:(NSString *)text
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:NSLocalizedStringFromTable(@"Error", @"Labels", nil)
            message:text preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:nil];

        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    });
}

@end
