//
//  LoginViewController.m
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-04.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import "LoginViewController.h"
#import "CommonSeparator.h"
#import "CommonButton.h"
#import "ApiConnector.h"
#import "UserManager.h"
#import "Settings.h"
#import "KeychainWrapper.h"
#import "ResetPasswordViewController.h"

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
    UIView * blocker;
}
@end

@implementation LoginViewController

#pragma mark - public

- (void)setupContentsWhenUserIsRegistered:(BOOL)userIsRegistered
{
    loginMode = userIsRegistered;
    [self setupDerived:userIsRegistered];
}

- (void)flushEmailAndPassword
{
    [Settings removeUserEmail];
    wrapper = [KeychainWrapper new];
    [wrapper resetKeychainItem];
}

#pragma mark - private

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    [self.view setBackgroundColor:[UIColor blackColor]];

    [self setupCommon];
}

- (void)setupCommon
{
    view = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f,
                                                          0.0f,
                                                          self.view.bounds.size.width,
                                                          self.view.bounds.size.height)];
    UIImageView * back = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Big-back-red"]];
    [back setCenter:view.center];
    [view addSubview:back];
    [self.view addSubview:view];

    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)]];

    UIImageView * logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    [logo setCenter:CGPointMake(view.frame.size.width / 2, 80.0f)];
    [view addSubview:logo];

//    UIColor * paleGray = [UIColor grayWithIntense:146.0f];
  //  const CGFloat bigFontSize = 24.0f;
    CGFloat smallFontSize = 14.0f;
    NSDictionary * placeholderAttrs = @{NSFontAttributeName: [UIFont regularFontWithSize:smallFontSize], NSForegroundColorAttributeName: [UIColor whiteColor]};
    CGFloat horizontalOffset = [Globals horizontalOffset];
    CGFloat heightsOfTextFields = 34.0f;
    CGFloat componentsWidth = self.view.bounds.size.width - horizontalOffset * 2;

    actionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,
                                                            0.0f,
                                                            view.bounds.size.width,
                                                            30.0f)];
    [actionLabel setTextColor:[UIColor whiteColor]];
    [actionLabel setFont:[UIFont regularFontWithSize:smallFontSize]];
    [actionLabel setTextAlignment:NSTextAlignmentCenter];
    [view addSubview:actionLabel];


    displayName = [[UITextField alloc] initWithFrame:CGRectMake(horizontalOffset,
                                                                120.0f,
                                                                componentsWidth,
                                                                heightsOfTextFields)];
    [displayName setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [displayName setReturnKeyType:UIReturnKeyDone];
    [displayName setAutocorrectionType:UITextAutocorrectionTypeNo];
    [displayName setFont:[UIFont regularFontWithSize:smallFontSize]];
    [displayName setTextColor:[UIColor whiteColor]];
    [displayName setDelegate:self];
    [displayName setHidden:YES];
    [view addSubview:displayName];

    NSString * displayNameString = NSLocalizedStringFromTable(@"DisplayName", @"Labels", nil);
    NSAttributedString * displayNamePlaceholder = [[NSAttributedString alloc] initWithString:displayNameString attributes:placeholderAttrs];
    [displayName setAttributedPlaceholder:displayNamePlaceholder];
    
    CommonSeparator * sepD = [[CommonSeparator alloc] initWithFrame:
                              CGRectMake(0.0f,
                                         heightsOfTextFields - 1.0f,
                                         componentsWidth,
                                         1.0f)];
    [sepD makeWhite];
    [displayName addSubview:sepD];
    
    email = [[UITextField alloc] initWithFrame:CGRectMake(horizontalOffset,
                                                          0.0f,
                                                          componentsWidth,
                                                          heightsOfTextFields)];
    [email setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [email setKeyboardType:UIKeyboardTypeEmailAddress];
    [email setReturnKeyType:UIReturnKeyDone];
    [email setAutocorrectionType:UITextAutocorrectionTypeNo];
    [email setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [email setFont:[UIFont regularFontWithSize:smallFontSize]];
    [email setTextColor:[UIColor whiteColor]];
    [email setDelegate:self];
    [view addSubview:email];

    NSString * emailString = NSLocalizedStringFromTable(@"Email", @"Labels", nil);
    NSAttributedString * emailPlaceholder = [[NSAttributedString alloc] initWithString:emailString attributes:placeholderAttrs];
    [email setAttributedPlaceholder:emailPlaceholder];
    
    CommonSeparator * sepE = [[CommonSeparator alloc] initWithFrame:
                              CGRectMake(0.0f,
                                         heightsOfTextFields - 1.0f,
                                         componentsWidth,
                                         1.0f)];
    [sepE makeWhite];
    [email addSubview:sepE];

    password = [[UITextField alloc] initWithFrame:CGRectMake(horizontalOffset,
                                                             0.0f,
                                                             componentsWidth,
                                                             heightsOfTextFields)];
    [password setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [password setSecureTextEntry:YES];
    [password setReturnKeyType:UIReturnKeyDone];
    [password setFont:[UIFont regularFontWithSize:smallFontSize]];
    [password setTextColor:[UIColor whiteColor]];
    [password setDelegate:self];
    [view addSubview:password];

    NSString * passwordString = NSLocalizedStringFromTable(@"Password", @"Labels", nil);
    NSAttributedString * passwordPlaceholder = [[NSAttributedString alloc] initWithString:passwordString attributes:placeholderAttrs];
    [password setAttributedPlaceholder:passwordPlaceholder];
    
    CommonSeparator * sepP = [[CommonSeparator alloc] initWithFrame:
                              CGRectMake(0.0f,
                                         heightsOfTextFields - 1.0f,
                                         componentsWidth,
                                         1.0f)];
    [sepP makeWhite];
    [password addSubview:sepP];

    submitButton = [CommonButton bigButtonWithText:NSLocalizedStringFromTable(@"SUBMIT", @"Buttons", nil) width:view.frame.size.width - 2 * horizontalOffset];
    [submitButton addTarget:self action:@selector(submitButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:submitButton];
    
    loginButton = [CommonButton bigButtonWithText:NSLocalizedStringFromTable(@"AlreadyAMember", @"Buttons", nil) width:view.frame.size.width - 2 * horizontalOffset];
    [loginButton addTarget:self action:@selector(loginButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setCenter:CGPointMake(view.center.x,
                                       view.frame.size.height - loginButton.frame.size.height - 20.0f)];
    [view addSubview:loginButton];
    
    registerButton = [CommonButton bigButtonWithText:NSLocalizedStringFromTable(@"REGISTER", @"Buttons", nil) width:view.frame.size.width - 2 * horizontalOffset];
    [registerButton addTarget:self action:@selector(registerButtonTouched) forControlEvents:UIControlEventTouchUpInside];

    [registerButton setCenter:CGPointMake(view.center.x,
                                          320.0f)];
    [view addSubview:registerButton];

    eulaButton = [CommonButton bigButtonWithText:NSLocalizedStringFromTable(@"EULA", @"Buttons", nil) width:120.0f];
    [eulaButton setCenter:CGPointMake(horizontalOffset + eulaButton.frame.size.width / 2,
                                      380.0f)];
    [eulaButton addTarget:self action:@selector(eulaButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:eulaButton];

    privacyButton = [CommonButton bigButtonWithText:NSLocalizedStringFromTable(@"PRIVACY", @"Buttons", nil) width:120.0f];
    [privacyButton setCenter:
     CGPointMake(view.frame.size.width - horizontalOffset -  privacyButton.frame.size.width / 2,
                 380.0f)];
    [privacyButton addTarget:self action:@selector(privacyButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:privacyButton];

    forgotPasswordButton = [CommonButton bigButtonWithText:NSLocalizedStringFromTable(@"FORGOTPASSWORD", @"Buttons", nil) width:view.frame.size.width - 2 * horizontalOffset];
    [forgotPasswordButton setCenter:
     CGPointMake(horizontalOffset + forgotPasswordButton.frame.size.width / 2,
                 view.bounds.size.height - forgotPasswordButton.frame.size.height)];
    [forgotPasswordButton addTarget:self action:@selector(forgotPasswordButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:forgotPasswordButton];

    [view setContentSize:CGSizeMake(view.frame.size.width, view.frame.size.height + 1.0f)];

    wrapper = [KeychainWrapper new];
}

- (void)setupDerived:(BOOL)userIsRegistered
{    
    CGFloat heightsOfTextFields = 34.0f;
    CGFloat modeDiff = userIsRegistered ? 0.0f : heightsOfTextFields + 20.0f;
    CGFloat gapForAction = userIsRegistered ? 0.0f : 55.0f;

    [displayName setHidden:userIsRegistered];
    
    [email setFrame:CGRectMake(email.frame.origin.x,
                              120.0f + modeDiff,
                              email.frame.size.width,
                              email.frame.size.height)];
    
    [password setFrame:CGRectMake(password.frame.origin.x,
                                  email.frame.origin.y + heightsOfTextFields + 20.0f,
                                  password.frame.size.width,
                                  password.frame.size.height)];

    [submitButton setCenter:CGPointMake(password.frame.origin.x + submitButton.frame.size.width / 2,
                                        password.frame.origin.y + heightsOfTextFields + submitButton.frame.size.height / 2 + 30.0f)];

    [actionLabel setCenter:CGPointMake(view.center.x, 285.0f + gapForAction)];

    [loginButton setHidden:userIsRegistered];
    [registerButton setHidden:!userIsRegistered];
    [eulaButton setHidden:userIsRegistered];
    [privacyButton setHidden:userIsRegistered];
    [forgotPasswordButton setHidden:!userIsRegistered];
    
    if (userIsRegistered)
    {
        [submitButton setText:NSLocalizedStringFromTable(@"LOGIN", @"Buttons", nil)];
        [actionLabel setText:NSLocalizedStringFromTable(@"or", @"Labels", nil)];
        LAContext * context = [LAContext new];
        if ([Settings isTouchIDEnabled] &&
            [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil] &&
            [[Settings userEmail] length] > 0 &&
            [[wrapper myObjectForKey:(__bridge id)kSecValueData] isKindOfClass:[NSString class]] &&
            [[wrapper myObjectForKey:(__bridge id)kSecValueData] length] > 0)
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
        [submitButton setText:NSLocalizedStringFromTable(@"REGISTER", @"Buttons", nil)];
        [actionLabel setText:NSLocalizedStringFromTable(@"byRegisteringYouAgreeTo", @"Labels", nil)];
    }
}

#pragma mark - Tap Gesture

- (void)hideKeyboard
{
    [displayName resignFirstResponder];
    [email resignFirstResponder];
    [password resignFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
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
    ResetPasswordViewController * rpvc = [ResetPasswordViewController new];
    [self presentViewController:rpvc animated:YES completion:nil];
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

#pragma mark - Activity

- (void)startActivity
{
    iView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    dispatch_async(dispatch_get_main_queue(), ^{
        blocker = [[UIView alloc] initWithFrame:self.view.frame];
        [blocker setBackgroundColor:[UIColor blackColor]];
        [blocker setAlpha:0.7f];
        [self.view addSubview:blocker];
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
        [blocker removeFromSuperview];
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
