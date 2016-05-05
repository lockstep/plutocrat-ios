//
//  LoginViewController.m
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-04.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import "LoginViewController.h"
#import "CommonSeparator.h"

@interface LoginViewController ()
{
    UILabel * actionLabel;
    UITextField * displayName;
    UITextField * email;
    UITextField * password;
}
@end

@implementation LoginViewController

#pragma mark - public

- (void)setupContentsWhenUserIsRegistered:(BOOL)userIsRegistered
{
    [self setupTopLabels:userIsRegistered];
}

#pragma mark - private

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (void)setupTopLabels:(BOOL)userIsRegistered
{
    UIColor * paleGray = [UIColor grayWithIntense:146.0f];
    const CGFloat bigFontSize = 20.0f;
    const CGFloat smallFontSize = 12.0f;
    CGFloat horizontalOffset = 28.0f;
    CGFloat componentsWidth = self.view.bounds.size.width - horizontalOffset * 2;
    
    UILabel * welcome = [[UILabel alloc] initWithFrame:CGRectMake(horizontalOffset,
                                                                  90.0f,
                                                                  componentsWidth,
                                                                  40.0f)];
    [welcome setText:NSLocalizedStringFromTable(@"WelcomeTo", @"Texts", nil)];
    [welcome setTextColor:paleGray];
    [welcome setFont:[UIFont snFontWithSize:bigFontSize]];
    [self.view addSubview:welcome];
    
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
    [self.view addSubview:useShares];
    
    CGFloat heightsOfTextFields = 34.0f;
    CGFloat modeDiff = userIsRegistered ? 0 : heightsOfTextFields;
    
    [actionLabel removeFromSuperview];
    actionLabel = [[UILabel alloc] initWithFrame:CGRectMake(horizontalOffset,
                                                            250.0f,
                                                            componentsWidth,
                                                            30.0f)];
    [actionLabel setTextColor:paleGray];
    [actionLabel setFont:[UIFont snFontWithSize:20.0f]];
    [self.view addSubview:actionLabel];
    
    [displayName removeFromSuperview];
    if (userIsRegistered)
    {
        [actionLabel setText:NSLocalizedStringFromTable(@"SignIn", @"Labels", nil)];
    }
    else
    {
        [actionLabel setText:NSLocalizedStringFromTable(@"Register", @"Labels", nil)];
        
        displayName = [[UITextField alloc] initWithFrame:CGRectMake(horizontalOffset,
                                                                    290.0f,
                                                                    componentsWidth,
                                                                    heightsOfTextFields)];
        [displayName setPlaceholder:NSLocalizedStringFromTable(@"DisplayName", @"Labels", nil)];
        [displayName setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [displayName setReturnKeyType:UIReturnKeyNext];
        [displayName setFont:[UIFont systemFontOfSize:12.0f]];
        [displayName setDelegate:self];
        [self.view addSubview:displayName];
        
        CommonSeparator * sep = [[CommonSeparator alloc] initWithFrame:CGRectMake(0.0f,
                                                                                  0.0f,
                                                                                  componentsWidth,
                                                                                  1.0f)];
        [displayName addSubview:sep];
    }
    
    [email removeFromSuperview];
    email = [[UITextField alloc] initWithFrame:CGRectMake(horizontalOffset,
                                                          290.0f + modeDiff,
                                                          componentsWidth,
                                                          heightsOfTextFields)];
    [email setPlaceholder:NSLocalizedStringFromTable(@"Email", @"Labels", nil)];
    [email setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [email setKeyboardType:UIKeyboardTypeEmailAddress];
    [email setReturnKeyType:UIReturnKeyNext];
    [email setFont:[UIFont snFontWithSize:12.0f]];
    [email setDelegate:self];
    [self.view addSubview:email];
    
    CommonSeparator * sep1 = [[CommonSeparator alloc] initWithFrame:CGRectMake(0.0f,
                                                                               0.0f,
                                                                               componentsWidth,
                                                                               1.0f)];
    [email addSubview:sep1];
    
    
    [password removeFromSuperview];
    password = [[UITextField alloc] initWithFrame:CGRectMake(horizontalOffset,
                                                             290.0f + modeDiff + heightsOfTextFields,
                                                             componentsWidth,
                                                             heightsOfTextFields)];
    [password setPlaceholder:NSLocalizedStringFromTable(@"Password", @"Labels", nil)];
    [password setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [password setSecureTextEntry:YES];
    [password setReturnKeyType:UIReturnKeyGo];
    [password setFont:[UIFont snFontWithSize:12.0f]];
    [password setDelegate:self];
    [self.view addSubview:password];
    
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
        // login or register
    }
    return NO;
}

@end
