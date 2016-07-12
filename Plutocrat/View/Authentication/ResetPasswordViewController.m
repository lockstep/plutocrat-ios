//
//  ResetPasswordViewController.m
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-10.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "CommonButton.h"
#import "CommonSeparator.h"
#import "ApiConnector.h"

@interface ResetPasswordViewController ()
{
    BOOL haveTokenMode;
    UIScrollView * view;
    UILabel * firstLine;
   // CommonHeader * header;
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

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    [self.view setBackgroundColor:[UIColor blackColor]];

    [self setupCommon];

    [self setupDerived:NO];
}

- (void)setupCommon
{
//    header = [[CommonHeader alloc] initWithFrame:CGRectMake(0.0f,
//                                                            0.0f,
//                                                            self.view.bounds.size.width,
//                                                            [Globals headerHeight])];
//    [self.view addSubview:header];

    view = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f,
                                                          0.0f,
                                                          self.view.bounds.size.width,
                                                          self.view.bounds.size.height)];
    UIImageView * back = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Big-back-red"]];
    [back setCenter:view.center];
    [view addSubview:back];
    [self.view addSubview:view];

    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)]];

    const CGFloat bigFontSize = 18.0f;
    const CGFloat smallFontSize = 12.0f;
    NSDictionary * placeholderAttrs = @{NSFontAttributeName: [UIFont regularFontWithSize:smallFontSize], NSForegroundColorAttributeName: [UIColor whiteColor]};
    CGFloat horizontalOffset = [Globals horizontalOffset];
    CGFloat heightsOfTextFields = 34.0f;
    CGFloat componentsWidth = self.view.bounds.size.width - horizontalOffset * 2;

    firstLine = [[UILabel alloc] initWithFrame:CGRectMake(horizontalOffset,
                                                          80.0f,
                                                          componentsWidth,
                                                          30.0f)];
    [firstLine setTextColor:[UIColor whiteColor]];
    [firstLine setFont:[UIFont regularFontWithSize:bigFontSize]];
    [view addSubview:firstLine];

    secondLine = [[UILabel alloc] initWithFrame:CGRectMake(horizontalOffset,
                                                          120.0f,
                                                          componentsWidth,
                                                          80.0f)];
    [secondLine setTextColor:[UIColor whiteColor]];
    [secondLine setFont:[UIFont regularFontWithSize:smallFontSize]];
    [secondLine setNumberOfLines:0];
    [secondLine setLineBreakMode:NSLineBreakByWordWrapping];
    [view addSubview:secondLine];

    actionLabel = [[UILabel alloc] initWithFrame:CGRectMake(horizontalOffset,
                                                            200.0f,
                                                            componentsWidth,
                                                            30.0f)];
    [actionLabel setTextColor:[UIColor whiteColor]];
    [actionLabel setFont:[UIFont regularFontWithSize:bigFontSize]];
    [view addSubview:actionLabel];

    email = [[UITextField alloc] initWithFrame:CGRectMake(horizontalOffset,
                                                          230.0f,
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

    token = [[UITextField alloc] initWithFrame:email.frame];
    [token setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [token setReturnKeyType:UIReturnKeyDone];
    [token setAutocorrectionType:UITextAutocorrectionTypeNo];
    [token setFont:[UIFont regularFontWithSize:smallFontSize]];
    [token setTextColor:[UIColor whiteColor]];
    [token setDelegate:self];
    [view addSubview:token];

    NSString * tokenString = NSLocalizedStringFromTable(@"ResetToken", @"Labels", nil);
    NSAttributedString * tokenPlaceholder = [[NSAttributedString alloc] initWithString:tokenString attributes:placeholderAttrs];
    [token setAttributedPlaceholder:tokenPlaceholder];

    CommonSeparator * sepT = [[CommonSeparator alloc] initWithFrame:
                              CGRectMake(0.0f,
                                         heightsOfTextFields - 1.0f,
                                         componentsWidth,
                                         1.0f)];
    [sepT makeWhite];
    [token addSubview:sepT];


    password = [[UITextField alloc] initWithFrame:CGRectMake(horizontalOffset,
                                                             token.frame.origin.y + heightsOfTextFields + 20.0f,
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

    alreadyHaveButton = [CommonButton bigButtonWithText:NSLocalizedStringFromTable(@"HAVETOKEN", @"Buttons", nil) width:view.frame.size.width - 2 * horizontalOffset];
    [alreadyHaveButton addTarget:self action:@selector(alreadyHaveButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    [alreadyHaveButton setCenter:
     CGPointMake(email.frame.origin.x + alreadyHaveButton.frame.size.width / 2,
                 email.frame.origin.y + heightsOfTextFields + 50.0f + alreadyHaveButton.frame.size.height)];
    [view addSubview:alreadyHaveButton];

    loginButton = [CommonButton bigButtonWithText:NSLocalizedStringFromTable(@"LOGIN", @"Buttons", nil) width:view.frame.size.width - 2 * horizontalOffset];
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
    [firstLine setText:step];
}

#pragma mark - Tap Gesture

- (void)hideKeyboard
{
    [token resignFirstResponder];
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
