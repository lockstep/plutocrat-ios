//
//  ResetPasswordViewController.m
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-10.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "CommonHeader.h"
#import "CommonButton.h"
#import "CommonSeparator.h"
#import "ApiConnector.h"

@interface ResetPasswordViewController ()
{
    BOOL haveTokenMode;
    UIScrollView * view;
   // UILabel * firstLine;
    CommonHeader * header;
    UILabel * secondLine;
    UILabel * actionLabel;
    UITextField * email;
    UITextField * token;
    UITextField * password;
    CommonButton * submitButton;
    CommonButton * loginButton;
    CommonButton * alreadyHaveButton;
    UIActivityIndicatorView * iView;
}
@end

@implementation ResetPasswordViewController

#pragma mark - private

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

    [self.view setBackgroundColor:[UIColor whiteColor]];

    [self setupCommon];

    [self setupDerived:NO];
}

- (void)setupCommon
{
    header = [[CommonHeader alloc] initWithFrame:CGRectMake(0.0f,
                                                            0.0f,
                                                            self.view.bounds.size.width,
                                                            [Globals headerHeight])];
    [self.view addSubview:header];

    view = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f,
                                                          [Globals headerHeight],
                                                          self.view.bounds.size.width,
                                                          self.view.bounds.size.height - [Globals headerHeight])];
    [self.view addSubview:view];

    UIColor * paleGray = [UIColor grayWithIntense:146.0f];
    const CGFloat bigFontSize = 18.0f;
    const CGFloat smallFontSize = 12.0f;
    CGFloat horizontalOffset = [Globals horizontalOffset];
    CGFloat heightsOfTextFields = 34.0f;
    CGFloat componentsWidth = self.view.bounds.size.width - horizontalOffset * 2;

//    firstLine = [[UILabel alloc] initWithFrame:CGRectMake(horizontalOffset,
//                                                          80.0f,
//                                                          componentsWidth,
//                                                          30.0f)];
//    [firstLine setTextColor:paleGray];
//    [firstLine setFont:[UIFont regularFontWithSize:bigFontSize]];
//    [view addSubview:firstLine];

    secondLine = [[UILabel alloc] initWithFrame:CGRectMake(horizontalOffset,
                                                          10.0f,
                                                          componentsWidth,
                                                          80.0f)];
    [secondLine setTextColor:paleGray];
    [secondLine setFont:[UIFont regularFontWithSize:smallFontSize]];
    [secondLine setNumberOfLines:0];
    [secondLine setLineBreakMode:NSLineBreakByWordWrapping];
    [view addSubview:secondLine];

    actionLabel = [[UILabel alloc] initWithFrame:CGRectMake(horizontalOffset,
                                                            90.0f,
                                                            componentsWidth,
                                                            30.0f)];
    [actionLabel setTextColor:paleGray];
    [actionLabel setFont:[UIFont regularFontWithSize:bigFontSize]];
    [view addSubview:actionLabel];

    email = [[UITextField alloc] initWithFrame:CGRectMake(horizontalOffset,
                                                          130.0f,
                                                          componentsWidth,
                                                          heightsOfTextFields)];
    [email setPlaceholder:NSLocalizedStringFromTable(@"Email", @"Labels", nil)];
    [email setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [email setKeyboardType:UIKeyboardTypeEmailAddress];
    [email setReturnKeyType:UIReturnKeyDone];
    [email setFont:[UIFont regularFontWithSize:smallFontSize]];
    [email setDelegate:self];
    [view addSubview:email];

    CommonSeparator * sep = [[CommonSeparator alloc] initWithFrame:CGRectMake(0.0f,
                                                                              0.0f,
                                                                              componentsWidth,
                                                                              1.0f)];
    [email addSubview:sep];

    CommonSeparator * sepD = [[CommonSeparator alloc] initWithFrame:CGRectMake(0.0f,
                                                                               heightsOfTextFields - 1.0f,
                                                                               componentsWidth,
                                                                               1.0f)];
    [email addSubview:sepD];

    token = [[UITextField alloc] initWithFrame:email.frame];
    [token setPlaceholder:NSLocalizedStringFromTable(@"ResetToken", @"Labels", nil)];
    [token setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [token setReturnKeyType:UIReturnKeyNext];
    [token setFont:[UIFont regularFontWithSize:smallFontSize]];
    [token setDelegate:self];
    [view addSubview:token];

    CommonSeparator * sep1 = [[CommonSeparator alloc] initWithFrame:CGRectMake(0.0f,
                                                                               0.0f,
                                                                               componentsWidth,
                                                                               1.0f)];
    [token addSubview:sep1];


    password = [[UITextField alloc] initWithFrame:CGRectMake(horizontalOffset,
                                                             token.frame.origin.y + heightsOfTextFields,
                                                             componentsWidth,
                                                             heightsOfTextFields)];
    [password setPlaceholder:NSLocalizedStringFromTable(@"NewPassword", @"Labels", nil)];
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

    alreadyHaveButton = [CommonButton buttonWithText:NSLocalizedStringFromTable(@"HAVETOKEN", @"Buttons", nil) color:ButtonColorViolet];
    [alreadyHaveButton addTarget:self action:@selector(alreadyHaveButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    [alreadyHaveButton setCenter:
     CGPointMake(email.frame.origin.x + alreadyHaveButton.frame.size.width / 2,
                 email.frame.origin.y + heightsOfTextFields + 50.0f + alreadyHaveButton.frame.size.height)];
    [view addSubview:alreadyHaveButton];

    loginButton = [CommonButton buttonWithText:NSLocalizedStringFromTable(@"LOGIN", @"Buttons", nil) color:ButtonColorViolet];
    [loginButton addTarget:self action:@selector(loginButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setCenter:CGPointMake(password.frame.origin.x + loginButton.frame.size.width / 2,
                                       view.bounds.size.height - loginButton.frame.size.height)];
    [view addSubview:loginButton];

    [view setContentSize:CGSizeMake(view.frame.size.width, view.frame.size.height + 1.0f)];
}

- (void)setupDerived:(BOOL)haveToken
{
    haveTokenMode = haveToken;

    CGFloat heightsOfTextFields = 34.0f;
    CGFloat submitY = haveToken ? password.frame.origin.y : email.frame.origin.y;
    submitY += heightsOfTextFields;

    [email setHidden:haveToken];
    [token setHidden:!haveToken];
    [password setHidden:!haveToken];
    [alreadyHaveButton setHidden:haveToken];

    [submitButton setCenter:CGPointMake(password.frame.origin.x + submitButton.frame.size.width / 2,
                                        submitY + submitButton.frame.size.height / 2 + 20.0f)];


    NSMutableString * step = [NSMutableString stringWithString:NSLocalizedStringFromTable(@"PasswordResetStep", @"Labels", nil)];
    if (haveToken)
    {
        [step appendString:@"2"];
        [secondLine setText:NSLocalizedStringFromTable(@"SetNewPassword", @"Texts", nil)];
        [actionLabel setText:NSLocalizedStringFromTable(@"ResetPassword", @"Labels", nil)];
    }
    else
    {
        [step appendString:@"1"];
        [secondLine setText:NSLocalizedStringFromTable(@"RequestToken", @"Texts", nil)];
        [actionLabel setText:NSLocalizedStringFromTable(@"RequestResetToken", @"Labels", nil)];
    }
    [header setText:step];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == email)
    {
        [email resignFirstResponder];
    }
    if (textField == token)
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
    if (!haveTokenMode)
    {
        NSString * emailStr = email.text;
        if (emailStr.length == 0)
        {
            [self showAlertEmptyFields];
        }
        else
        {
            [self startActivity];
            [ApiConnector requestPasswordWithEmail:email.text
                                        completion:^(NSString * error)
             {
                 [self stopActivity];
                 [self showAlertOk:NSLocalizedStringFromTable(@"TokenWasSent", @"Labels", nil)
                        completion:^()
                  {
                     [self setupDerived:YES];
                 }];

             }];
        }
    }
    else
    {
        NSString * tokenStr = token.text;
        NSString * passwordStr = password.text;
        if (tokenStr.length * passwordStr.length == 0)
        {
            [self showAlertEmptyFields];
        }
        else
        {
            [self startActivity];
            [ApiConnector resetPasswordWithToken:tokenStr
                                        password:passwordStr
                                      completion:^(NSString * error)
             {
                 [self stopActivity];
                 if (error)
                 {
                     [self showAlertWithErrorText:error];
                 }
                 else
                 {
                     [self showAlertOk:NSLocalizedStringFromTable(@"PasswordReseted", @"Labels", nil)
                            completion:^()
                      {
                         [self loginButtonTouched];
                     }];
                 }
             }];
        }
    }
}

- (void)alreadyHaveButtonTouched
{
    [self setupDerived:YES];
}

- (void)loginButtonTouched
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
        [alreadyHaveButton setEnabled:NO];
        [email setUserInteractionEnabled:NO];
        [token setUserInteractionEnabled:NO];
        [password setUserInteractionEnabled:NO];
        [email resignFirstResponder];
        [password resignFirstResponder];
        [token resignFirstResponder];
        [loginButton setEnabled:NO];
    });
}

- (void)stopActivity
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [submitButton setEnabled:YES];
        [alreadyHaveButton setEnabled:YES];
        [email setUserInteractionEnabled:YES];
        [token setUserInteractionEnabled:YES];
        [password setUserInteractionEnabled:YES];
        [loginButton setEnabled:YES];
        [iView removeFromSuperview];
    });
}

#pragma mark - Alerts

- (void)showAlertEmptyFields
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:NSLocalizedStringFromTable(@"Alert", @"Labels", nil) message:NSLocalizedStringFromTable(@"EmptyFields", @"Labels", nil) preferredStyle:UIAlertControllerStyleAlert];
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
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:NSLocalizedStringFromTable(@"Error", @"Labels", nil) message:text preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:nil];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    });
}

- (void)showAlertOk:(NSString *)text completion:(void (^)())completion
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:text preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissViewControllerAnimated:YES completion:completion];
        });
    });
}

@end
