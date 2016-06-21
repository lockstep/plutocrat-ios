//
//  AccountViewController.m
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-10.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import "AccountViewController.h"
#import "CommonSeparator.h"
#import "CommonHeader.h"
#import "CommonButton.h"
#import "User.h"
#import "UserManager.h"
#import "Settings.h"
#import "ApiConnector.h"
#import "UIImageView+Cached.h"
#import <LocalAuthentication/LAContext.h>

@interface AccountViewController ()
{
    UIScrollView * view;
    UIImageView * photo;
    UITextField * displayName;
    UITextField * email;
    UITextField * newPassword;
    UISwitch * eventsSwitch;
    UISwitch * updatesSwitch;
    UISwitch * touchIDSwitch;
    UITextField * currentPassword;
    CommonButton * button;
    User * user;
    UIActivityIndicatorView * iView;
    BOOL addedHeight;
}
@end

@implementation AccountViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.view setBackgroundColor:[UIColor whiteColor]];

    UIColor * paleGray = [UIColor grayWithIntense:146.0f];
    const CGFloat fontSize = 14.0f;
    CGFloat horizontalOffset = [Globals horizontalOffset];
    CGFloat heightsOfTextFields = 34.0f;
    CGFloat componentsWidth = self.view.bounds.size.width - horizontalOffset * 2;
    NSMutableArray * curYs = [NSMutableArray array];
    NSArray * labs = @[NSLocalizedStringFromTable(@"DisplayName", @"Labels", nil),
                       NSLocalizedStringFromTable(@"Email", @"Labels", nil),
                       NSLocalizedStringFromTable(@"NewPassword", @"Labels", nil)];

    CommonHeader * header = [[CommonHeader alloc] initWithFrame:CGRectMake(0.0f,
                                                                           0.0f,
                                                                           self.view.bounds.size.width,
                                                                           [Globals headerHeight])];
    [header setText:NSLocalizedStringFromTable(@"ACCOUNT", @"Labels", nil)];
    [self.view addSubview:header];

    view = [[UIScrollView alloc] initWithFrame:
            CGRectMake(0.0f,
                       header.frame.size.height,
                       self.view.bounds.size.width,
                       self.view.bounds.size.height - [Globals tabBarHeight] - header.frame.size.height)];
    [self.view addSubview:view];

    CGFloat curY = 20.0f;

    photo = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 88.0f, 88.0f)];
    [photo setImage:[UIImage imageNamed:@"empty-profile-image"]];
    [[photo layer] setCornerRadius:photo.frame.size.width / 2];
    [[photo layer] setMasksToBounds:YES];
    [photo setCenter:CGPointMake(self.view.bounds.size.width / 2, curY + photo.frame.size.height / 2)];
    [view addSubview:photo];
    UITapGestureRecognizer * tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped)];
    [photo setUserInteractionEnabled:YES];
    [photo addGestureRecognizer:tgr];
    curY += photo.frame.size.height + 5.0f;

    UILabel * tapToChange = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,
                                                                      curY,
                                                                      self.view.bounds.size.width,
                                                                      12.0f)];
    [tapToChange setFont:[UIFont italicFontWithSize:10.0f]];
    [tapToChange setTextColor:paleGray];
    [tapToChange setTextAlignment:NSTextAlignmentCenter];
    [tapToChange setText:NSLocalizedStringFromTable(@"TapToChange", @"Labels", nil)];
    [view addSubview:tapToChange];
    curY += tapToChange.frame.size.height + 8.0f;
    [curYs addObject:@(curY)];

    displayName = [[UITextField alloc] initWithFrame:CGRectMake(horizontalOffset,
                                                                curY,
                                                                componentsWidth,
                                                                heightsOfTextFields)];
    [displayName setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [displayName setFont:[UIFont boldFontWithSize:fontSize]];
    [displayName setTextColor:paleGray];
    [displayName setTextAlignment:NSTextAlignmentRight];
    [displayName setReturnKeyType:UIReturnKeyDone];
    [displayName setDelegate:self];
    [view addSubview:displayName];

    curY += heightsOfTextFields;
    [curYs addObject:@(curY)];

    CommonSeparator * sep = [[CommonSeparator alloc] initWithFrame:CGRectMake(0.0f,
                                                                              0.0f,
                                                                              componentsWidth,
                                                                              1.0f)];
    [displayName addSubview:sep];

    email = [[UITextField alloc] initWithFrame:CGRectMake(horizontalOffset,
                                                          curY,
                                                          componentsWidth,
                                                          heightsOfTextFields)];
    [email setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [email setFont:[UIFont boldFontWithSize:fontSize]];
    [email setTextColor:paleGray];
    [email setTextAlignment:NSTextAlignmentRight];
    [email setKeyboardType:UIKeyboardTypeEmailAddress];
    [email setReturnKeyType:UIReturnKeyDone];
    [email setDelegate:self];
    [view addSubview:email];
    curY += heightsOfTextFields;
    [curYs addObject:@(curY)];

    CommonSeparator * sep1 = [[CommonSeparator alloc] initWithFrame:CGRectMake(0.0f,
                                                                               0.0f,
                                                                               componentsWidth,
                                                                               1.0f)];
    [email addSubview:sep1];


    newPassword = [[UITextField alloc] initWithFrame:CGRectMake(horizontalOffset,
                                                                curY,
                                                                componentsWidth,
                                                                heightsOfTextFields)];
    [newPassword setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [newPassword setFont:[UIFont boldFontWithSize:fontSize]];
    [newPassword setTextColor:paleGray];
    [newPassword setTextAlignment:NSTextAlignmentRight];
    [newPassword setSecureTextEntry:YES];
    [newPassword setReturnKeyType:UIReturnKeyDone];
    [newPassword setDelegate:self];
    [view addSubview:newPassword];
    curY += heightsOfTextFields;

    CommonSeparator * sep2 = [[CommonSeparator alloc] initWithFrame:CGRectMake(0.0f,
                                                                               0.0f,
                                                                               componentsWidth,
                                                                               1.0f)];
    [newPassword addSubview:sep2];

    CommonSeparator * sep3 = [[CommonSeparator alloc] initWithFrame:
                              CGRectMake(0.0f,
                                         heightsOfTextFields - 1.0f,
                                         componentsWidth,
                                         1.0f)];
    [newPassword addSubview:sep3];

    [curYs enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL * stop)
    {
        CGFloat y = [obj floatValue];
        UIFont * font = [UIFont regularFontWithSize:fontSize];
        NSString * str = [labs objectAtIndex:idx];
        CGRect rect = [str boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, heightsOfTextFields)
                                        options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                     attributes:@{NSFontAttributeName:font}
                                        context:nil];
        UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(horizontalOffset,
                                                                  y + 8.0f,
                                                                  rect.size.width + 3.0f,
                                                                  rect.size.height)];
        [lab setBackgroundColor:[UIColor whiteColor]];
        [[lab layer] setBorderColor:[UIColor whiteColor].CGColor];
        [[lab layer] setBorderWidth:1.0f];
        [lab setFont:font];
        [lab setTextColor:paleGray];
        [lab setText:str];
        [view addSubview:lab];
    }];

    curY += 25.0f;

    curYs = [NSMutableArray arrayWithObject:@(curY)];

    eventsSwitch = [UISwitch new];
    [eventsSwitch setCenter:CGPointMake(horizontalOffset + eventsSwitch.frame.size.width / 2,
                                        curY + eventsSwitch.frame.size.height / 2)];
    [view addSubview:eventsSwitch];

    CGFloat switchLabsOriginX = eventsSwitch.frame.origin.x + eventsSwitch.frame.size.width + 10.0f;
    curY += 50.0f;
    [curYs addObject:@(curY)];

    updatesSwitch = [UISwitch new];
    [updatesSwitch setCenter:CGPointMake(horizontalOffset + updatesSwitch.frame.size.width / 2,
                                         curY + updatesSwitch.frame.size.height / 2)];
    [view addSubview:updatesSwitch];

    labs = @[NSLocalizedStringFromTable(@"EmailEvents", @"Labels", nil),
             NSLocalizedStringFromTable(@"EmailUpdates", @"Labels", nil)];

    LAContext * context = [LAContext new];
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil])
    {
        curY += 55.0f;
        touchIDSwitch = [UISwitch new];

        [touchIDSwitch setCenter:CGPointMake(horizontalOffset + touchIDSwitch.frame.size.width / 2,
                                             curY + touchIDSwitch.frame.size.height / 2)];
        [view addSubview:touchIDSwitch];

        labs = @[NSLocalizedStringFromTable(@"EmailEvents", @"Labels", nil),
                 NSLocalizedStringFromTable(@"EmailUpdates", @"Labels", nil),
                 NSLocalizedStringFromTable(@"TouchID", @"Labels", nil)];
        [curYs addObject:@(curY)];
    }

    [curYs enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL * stop)
     {
         CGFloat y = [obj floatValue];
         UIFont * font = [UIFont regularFontWithSize:13.0f];
         NSString * str = [labs objectAtIndex:idx];
         CGFloat width = view.frame.size.width - horizontalOffset - switchLabsOriginX;
         UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(switchLabsOriginX,
                                                                   0.0f,
                                                                   width,
                                                                   100.0f)];
         [lab setNumberOfLines:0];
         [lab setLineBreakMode:NSLineBreakByWordWrapping];
         [lab setBackgroundColor:[UIColor whiteColor]];
         [lab setFont:font];
         [lab setTextColor:paleGray];
         [lab setText:str];
         [view addSubview:lab];
         [lab sizeToFit];
         [lab setCenter:CGPointMake(lab.center.x, y + updatesSwitch.frame.size.height / 2)];
     }];

    curY += 55.0f;

    currentPassword = [[UITextField alloc] initWithFrame:CGRectMake(horizontalOffset,
                                                                    curY,
                                                                    componentsWidth,
                                                                    heightsOfTextFields)];
    [currentPassword setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [currentPassword setFont:[UIFont boldFontWithSize:fontSize]];
    [currentPassword setTextColor:paleGray];
    [currentPassword setTextAlignment:NSTextAlignmentRight];
    [currentPassword setSecureTextEntry:YES];
    [currentPassword setReturnKeyType:UIReturnKeyDone];
    [currentPassword setDelegate:self];
    [view addSubview:currentPassword];

    CommonSeparator * sep4 = [[CommonSeparator alloc] initWithFrame:CGRectMake(0.0f,
                                                                               0.0f,
                                                                               componentsWidth,
                                                                               1.0f)];
    [currentPassword addSubview:sep4];

    CommonSeparator * sep5 = [[CommonSeparator alloc] initWithFrame:
                              CGRectMake(0.0f,
                                         heightsOfTextFields - 1.0f,
                                         componentsWidth,
                                         1.0f)];
    [currentPassword addSubview:sep5];

    UIFont * font = [UIFont regularFontWithSize:fontSize];
    NSString * str = NSLocalizedStringFromTable(@"CurrentPassword", @"Labels", nil);
    CGRect rect = [str boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, heightsOfTextFields)
                                    options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                 attributes:@{NSFontAttributeName:font}
                                    context:nil];
    UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(horizontalOffset,
                                                              curY + 8.0f,
                                                              rect.size.width + 3.0f,
                                                              rect.size.height)];
    [lab setBackgroundColor:[UIColor whiteColor]];
    [[lab layer] setBorderColor:[UIColor whiteColor].CGColor];
    [[lab layer] setBorderWidth:1.0f];
    [lab setFont:font];
    [lab setTextColor:paleGray];
    [lab setText:str];
    [view addSubview:lab];

    curY += heightsOfTextFields + 10.0f;

    UILabel * currentPasswordReq = [[UILabel alloc] initWithFrame:
                                    CGRectMake(0.0f,
                                               curY,
                                               componentsWidth,
                                               50.0f)];
    [currentPasswordReq setFont:[UIFont italicFontWithSize:fontSize]];
    [currentPasswordReq setTextColor:paleGray];
    [currentPasswordReq setNumberOfLines:0];
    [currentPasswordReq setLineBreakMode:NSLineBreakByWordWrapping];
    [currentPasswordReq setTextAlignment:NSTextAlignmentCenter];
    [currentPasswordReq setText:NSLocalizedStringFromTable(@"PasswordRequired", @"Labels", nil)];
    [view addSubview:currentPasswordReq];
    [currentPasswordReq sizeToFit];
    [currentPasswordReq setCenter:CGPointMake(view.frame.size.width / 2, currentPasswordReq.center.y)];

    curY += currentPasswordReq.frame.size.height + 20.0f;

    button = [CommonButton buttonWithText:NSLocalizedStringFromTable(@"SAVE", @"Buttons", nil) color:ButtonColorViolet];
    [button setCenter:CGPointMake(horizontalOffset + button.frame.size.width / 2,
                                  curY + button.frame.size.height / 2)];
    [button addTarget:self action:@selector(saveTapped) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];

    curY += button.frame.size.height + 20.0f;

    CGFloat totalY = MAX(curY, view.frame.size.height + 1.0f);
    [view setContentSize:CGSizeMake(view.frame.size.width, totalY)];

    user = [User userFromDict:[UserManager userDict]];
    user.email = [Settings userEmail];

    [self setSwitches];
    [self setData];
}

#pragma mark - Image

- (void)imageTapped
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        return;
    }
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    [picker setDelegate:self];
    [picker setAllowsEditing:YES];
    [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage * chosenImage = info[UIImagePickerControllerEditedImage];
    [photo setImage:chosenImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (addedHeight) return;
    addedHeight = YES;
    if (textField == newPassword)
    {
        if (self.view.frame.size.height < 600.0f)
        {
            [view setContentSize:CGSizeMake(view.frame.size.width, view.contentSize.height + 20.0f)];
            [view scrollRectToVisible:CGRectMake(0.0f, view.contentSize.height - 1.0f, view.frame.size.width, 1.0f) animated:YES];
        }
        [currentPassword setUserInteractionEnabled:NO];
    }
    if (textField == currentPassword)
    {
        [view setContentSize:CGSizeMake(view.frame.size.width, view.contentSize.height + 100.0f)];
        [view scrollRectToVisible:CGRectMake(0.0f, view.contentSize.height - 1.0f, view.frame.size.width, 1.0f) animated:YES];
        [newPassword setUserInteractionEnabled:NO];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    addedHeight = NO;
    if (textField == newPassword)
    {
        if (self.view.frame.size.height < 600.0f)
        {
            [view setContentSize:CGSizeMake(view.frame.size.width, view.contentSize.height - 20.0f)];
            [view scrollRectToVisible:textField.frame animated:YES];
        }
        [currentPassword setUserInteractionEnabled:YES];
    }
    if (textField == currentPassword)
    {
        [view setContentSize:CGSizeMake(view.frame.size.width, view.contentSize.height - 100.0f)];
        [view scrollRectToVisible:textField.frame animated:YES];
        [newPassword setUserInteractionEnabled:YES];
    }
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - Load data

- (void)setSwitches
{
    [eventsSwitch setOn:[Settings isEventsNotificationsEnabled]];
    [updatesSwitch setOn:[Settings isUpdatesEmailsEnabled]];
    [touchIDSwitch setOn:[Settings isTouchIDEnabled]];
}

- (void)setData
{
    [displayName setText:user.displayName];
    [email setText:user.email];
    [photo setUrl:user.profileImageUrl initials:user.initials compeltionHandler:nil];
}

#pragma mark - Save data

- (void)saveTapped
{
    if (newPassword.text.length > 0 && currentPassword.text.length == 0)
    {
        [self showAlertEmptyPassword];
        return;
    }
    [self startActivity];
    [ApiConnector updateProfileWithUserId:user.identifier
                                    email:user.email
                              newPassword:newPassword.text
                          currentPassword:currentPassword.text
                              displayName:displayName.text
                             profileImage:photo.image
                               eventsEmails:eventsSwitch.isOn
                            updatesEmails:updatesSwitch.isOn
                               completion:^(NSDictionary * response, NSString * error) {
                                   [self stopActivity];
                                   if (!error)
                                   {
                                       user = [User userFromDict:response];
                                       [Settings enableEventsNotifiations:eventsSwitch.isOn];
                                       [Settings enableUpdatesEmails:updatesSwitch.isOn];
                                       [Settings enableTouchID:touchIDSwitch.isOn];
                                       [self showAlertOk];
                                       if ([self.delegate respondsToSelector:@selector(accountViewControllerUpdatedData:)])
                                       {
                                           [self.delegate accountViewControllerUpdatedData:self];
                                       }
                                   }
                                   else
                                   {
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
        [photo setUserInteractionEnabled:NO];
        [email setUserInteractionEnabled:NO];
        [currentPassword setUserInteractionEnabled:NO];
        [displayName setUserInteractionEnabled:NO];
        [newPassword setUserInteractionEnabled:NO];
        [eventsSwitch setUserInteractionEnabled:NO];
        [updatesSwitch setUserInteractionEnabled:NO];
        [touchIDSwitch setUserInteractionEnabled:NO];
        [button setEnabled:NO];
        [view setScrollEnabled:NO];
    });
}

- (void)stopActivity
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [photo setUserInteractionEnabled:YES];
        [email setUserInteractionEnabled:YES];
        [currentPassword setUserInteractionEnabled:YES];
        [displayName setUserInteractionEnabled:YES];
        [newPassword setUserInteractionEnabled:YES];
        [eventsSwitch setUserInteractionEnabled:YES];
        [updatesSwitch setUserInteractionEnabled:YES];
        [touchIDSwitch setUserInteractionEnabled:YES];
        [button setEnabled:YES];
        [view setScrollEnabled:YES];
        [iView removeFromSuperview];
    });
}

#pragma mark - Alerts

- (void)showAlertEmptyPassword
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:NSLocalizedStringFromTable(@"Alert", @"Labels", nil)
            message:NSLocalizedStringFromTable(@"EmptyPassword", @"Labels", nil) preferredStyle:UIAlertControllerStyleAlert];
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

- (void)showAlertOk
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedStringFromTable(@"SettingsUpdated", @"Labels", nil) preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissViewControllerAnimated:YES completion:nil];
        });
    });
}

@end
