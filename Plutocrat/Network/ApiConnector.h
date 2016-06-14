//
//  ApiConnector.h
//  Plutocrat
//
//  Created by Kuntee Viriyothai on 3/7/16.
//  Copyright © 2016 Whitefly Ventures, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Buyout.h"

@interface ApiConnector : NSObject

+ (void)signInWithEmail:(NSString *)email password:(NSString *)password completion:(void (^)(NSDictionary *response, NSString *error))completion;
+ (void)signUpWithDisplayName:(NSString *)displayName email:(NSString *)email password:(NSString *)password completion:(void (^)(NSDictionary *response, NSString *error))completion;
+ (void)signOutWithCompletion:(void (^)(NSString *error))completion;
+ (void)requestPasswordWithEmail:(NSString *)email completion:(void (^)(NSString *error))completion;
+ (void)resetPasswordWithToken:(NSString *)token password:(NSString *)password completion:(void (^)(NSString *error))completion;

+ (void)updateProfileWithUserId:(int)userId
                          email:(NSString *)email
                    newPassword:(NSString *)newPassword
                currentPassword:(NSString *)currentPassword
                    displayName:(NSString *)displayName
                   profileImage:(UIImage *)image
                   eventsEmails:(BOOL)eventsEmails
                  updatesEmails:(BOOL)updatesEmails
                     completion:(void (^)(NSDictionary *response, NSString *error))completion;

+ (void)getProfileWithUserId:(int)userId completion:(void (^)(User *user, NSString *error))completion;

+ (void)getUsersWithPage:(NSUInteger)page completion:(void (^)(NSArray *users, NSUInteger perPage, BOOL isLastPage, NSString *error))completion;
+ (void)getBuyoutsWithPage:(int)page completion:(void (^)(NSArray *buyouts, NSString *error))completion;

+ (void)purchaseShare:(int)bundleSize quantity:(int)quantity appleReceiptData:(NSData *)appleReceiptData completion:(void (^)(NSString *error))completion;
+ (void)initiateBuyout:(int)bundleSize quantity:(int)quantity appleReceiptData:(NSString *)appleReceiptData completion:(void (^)(int availableSharesCount, int minimumAmount, NSString *error))completion;
+ (void)processImageDataWithURLString:(NSString *)urlString andBlock:(void (^)(NSData * imageData))processImage;

@end
