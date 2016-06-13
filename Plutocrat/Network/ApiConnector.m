//
//  ApiConnector.m
//  Plutocrat
//
//  Created by Kuntee Viriyothai on 3/7/16.
//  Copyright © 2016 Whitefly Ventures, Inc. All rights reserved.
//

#import "ApiConnector.h"
#import "AFNetworking.h"
#import "UserManager.h"
#import "CollectionUtils.h"

#define IS_PRODUCTION 0

#define PRODUCTION_SERVER @"https://plutocracy.herokuapp.com"
#define STAGING_SERVER @"https://plutocracy-staging.herokuapp.com"

#define API_PATH @"/api/v1/"

#define SIGN_IN @"users/sign_in"
#define SIGN_UP @"users"
#define SIGN_OUT @"users/sign_out"
#define PASSWORD @"users/password"
#define PROFILE @"users/%d"
#define GET_USERS @"users"
#define GET_BUYOUTS @"users/%d/buyouts"
#define SHARE_PURCHASE @"users/%d/share_purchase"
#define NEW_BUYOUT @"users/%d/buyouts/new"

@implementation ApiConnector

+ (NSString *)getApiFullPath:(NSString *)name {
#if IS_PRODUCTION
    NSString *server = PRODUCTION_SERVER;
#else
    NSString *server = STAGING_SERVER;
#endif
    return [NSString stringWithFormat:@"%@%@%@", server, API_PATH, name];
}

enum ApiMethod {
    Post, Get, Delete, Patch
};

+ (void)connectApi:(NSString *)apiName method:(enum ApiMethod)method params:(NSDictionary *)params json:(BOOL)json completion:(void (^)(NSDictionary *header, id responseObject, NSString *error))completion {
    
    NSString *urlString = [self getApiFullPath:apiName];
    
    NSMutableURLRequest *urlRequest;
    
    NSString *methodString;
    switch (method) {
        case Post:
            methodString = @"POST";
            break;
            
        case Get:
            methodString = @"GET";
            break;
            
        case Delete:
            methodString = @"DELETE";
            break;
            
        case Patch:
            methodString = @"PATCH";
            break;
    }
    
    NSMutableDictionary *normalParams = [NSMutableDictionary dictionary];
    NSMutableDictionary *imageParams = [NSMutableDictionary dictionary];
    for (NSString *key in params.keyEnumerator) {
        id value = params[key];
        if ([value isKindOfClass:[UIImage class]]) {
            [imageParams setObject:value forKey:key];
        } else {
            [normalParams setObject:value forKey:key];
        }
    }
    
    AFHTTPRequestSerializer *requestSerializer;
    if (json) {
        requestSerializer = [AFJSONRequestSerializer serializer];
    } else {
        requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    
    if (imageParams.count > 0) {
        urlRequest = [requestSerializer multipartFormRequestWithMethod:methodString URLString:urlString parameters:normalParams constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            for (NSString *key in imageParams.keyEnumerator) {
                [formData appendPartWithFormData:UIImageJPEGRepresentation(imageParams[key], 1.0) name:key];
            }
        } error:nil];
    } else {
        urlRequest = [requestSerializer requestWithMethod:methodString URLString:urlString parameters:normalParams error:nil];
    }
    if ([UserManager isLogin]) {
        [urlRequest setValue:[UserManager getHeader:@"Access-Token"] forHTTPHeaderField:@"Access-Token"];
        [urlRequest setValue:[UserManager getHeader:@"Token-Type"] forHTTPHeaderField:@"Token-Type"];
        [urlRequest setValue:[UserManager getHeader:@"Client"] forHTTPHeaderField:@"Client"];
        [urlRequest setValue:[UserManager getHeader:@"Expiry"] forHTTPHeaderField:@"Expiry"];
        [urlRequest setValue:[UserManager getHeader:@"Uid"] forHTTPHeaderField:@"Uid"];
    }
    
    NSLog(@"API:[%@] %@ [%d] (%@)", methodString, urlString, method, params);
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:urlRequest uploadProgress:nil downloadProgress:nil completionHandler:
                                      ^(NSURLResponse *response, id responseObject, NSError *error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        long statusCode = httpResponse.statusCode;
        NSLog(@"response(%ld, %ld): %@", statusCode, (long)error.code, responseObject);
        NSDictionary *responseDict = [responseObject cu_compactDictionary];
        NSLog(@"After Remove Null rfesponse(%ld, %ld): %@", statusCode, (long)error.code, responseDict);
        
        switch (statusCode) {
            case 200:
            case 201: {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(httpResponse.allHeaderFields, responseDict, nil);
                });
            }
                break;
                
            case 401: {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSArray *errors = responseObject[@"meta"][@"errors"][@"auth"];
                    completion(httpResponse.allHeaderFields, responseDict, errors.firstObject);//@"Invalid login credentials. Please try again.");
                });
            }
                break;
                
            case 404: {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(httpResponse.allHeaderFields, responseDict, @"Host is not reachable at this time. Please try again.");
                });
            }
                break;
                
            default: {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(httpResponse.allHeaderFields, responseDict, @"Unknown error has occured. Please try again.");
                });
            }
                break;

        }
    }];
    [dataTask resume];
}

+ (void)signInWithEmail:(NSString *)email password:(NSString *)password completion:(void (^)(NSDictionary *response, NSString *error))completion {
    NSDictionary *params = @{ @"email": email, @"password": password };
    [self connectApi:SIGN_IN method:Post params:params json:YES completion:^(NSDictionary *headers, id responseObject, NSString *error) {
        if (!error) {
            [UserManager storeUser:responseObject[@"user"] headers:headers];
        }
        completion(responseObject, error);
    }];
}

+ (void)signUpWithDisplayName:(NSString *)displayName email:(NSString *)email password:(NSString *)password completion:(void (^)(NSDictionary *response, NSString *error))completion {
    NSDictionary *params = @{ @"email": email, @"password": password, @"password_confirmation": password, @"display_name": displayName };
    [self connectApi:SIGN_UP method:Post params:params json:YES completion:^(NSDictionary *headers, id responseObject, NSString *error) {
        NSDictionary *errors = responseObject[@"meta"][@"errors"];
        if ([errors[@"display_name"] count] > 0) {
            completion(responseObject, [NSString stringWithFormat:@"Display name %@", [errors[@"display_name"] firstObject]]);
        } else if ([errors[@"email"] count] > 0) {
            completion(responseObject, [NSString stringWithFormat:@"Email %@", [errors[@"email"] firstObject]]);
        } else if ([errors[@"password"] count] > 0) {
            completion(responseObject, [NSString stringWithFormat:@"Password %@", [errors[@"password"] firstObject]]);
        } else {
            if (!error) {
                [UserManager storeUser:responseObject[@"user"] headers:headers];
            }
            completion(responseObject, error);
        }
    }];
}

+ (void)signOutWithCompletion:(void (^)(NSString *error))completion {
    [self connectApi:SIGN_OUT method:Delete params:nil json:NO completion:^(NSDictionary *headers, id responseObject, NSString *error) {
        if (!error) {
            [UserManager removeUser];
        }
        completion(error);
    }];
}

+ (void)requestPasswordWithEmail:(NSString *)email completion:(void (^)(NSString *error))completion {
    NSDictionary *params = @{ @"email": email };
    [self connectApi:PASSWORD method:Post params:params json:YES completion:^(NSDictionary *headers, id responseObject, NSString *error) {
        completion(error);
    }];
}

+ (void)resetPasswordWithToken:(NSString *)token password:(NSString *)password completion:(void (^)(NSString *error))completion {
    NSDictionary *params = @{ @"reset_password_token": token, @"password": password, @"password_confirmation": password };
    [self connectApi:PASSWORD method:Patch params:params json:YES completion:^(NSDictionary *headers, id responseObject, NSString *error) {
        completion(error);
    }];
}

+ (void)updateProfileWithUserId:(int)userId email:(NSString *)email newPassword:(NSString *)newPassword currentPassword:(NSString *)currentPassword displayName:(NSString *)displayName profileImage:(UIImage *)image eventsEmails:(BOOL)eventsEmails updatesEmails:(BOOL)updatesEmails completion:(void (^)(NSDictionary *, NSString *))completion {
    NSDictionary *paramNoPass = @{ @"email": email, @"display_name": displayName, @"profile_image": image, @"transactional_emails_enabled": [self boolToString:eventsEmails], @"product_emails_enabled": [self boolToString:updatesEmails]};
    NSMutableDictionary * params = [paramNoPass mutableCopy];
    if (newPassword.length > 0)
    {
        [params setObject:newPassword forKey:@"password"];
        [params setObject:currentPassword forKey:@"current_password"];
    }
    [self connectApi:[NSString stringWithFormat:PROFILE, userId] method:Patch params:params json:YES completion:^(NSDictionary *headers, id responseObject, NSString *error) {
        completion(responseObject, error);
    }];
}

+ (void)getProfileWithUserId:(int)userId completion:(void (^)(User *user, NSString *error))completion {
    NSDictionary *params = nil;
    [self connectApi:[NSString stringWithFormat:PROFILE, userId] method:Get params:params json:YES completion:^(NSDictionary *headers, id responseObject, NSString *error) {
        User *user = [User userFromDict:responseObject[@"user"]];
        completion(user, error);
    }];
}

+ (void)getUsersWithPage:(int)page completion:(void (^)(NSArray *users, NSString *error))completion {
    NSDictionary *params = @{ @"page": @(page) };
    [self connectApi:GET_USERS method:Get params:params json:NO completion:^(NSDictionary *headers, id responseObject, NSString *error) {
        NSMutableArray *users = [NSMutableArray array];
        NSArray *userArray = responseObject[@"users"];
        for (NSDictionary *userDict in userArray) {
            User *user = [User userFromDict:userDict];
            [users addObject:user];
        }
        completion(users, error);
    }];
}

+ (void)getBuyoutsWithPage:(int)page completion:(void (^)(NSArray *buyouts, NSString *error))completion {
    NSDictionary *params = @{ @"page": @(page) };
    [self connectApi:[NSString stringWithFormat:GET_BUYOUTS, [UserManager currentUserId]] method:Get params:params json:NO completion:^(NSDictionary *headers, id responseObject, NSString *error) {
        NSMutableArray *buyouts = [NSMutableArray array];
        NSArray *buyoutArray = responseObject[@"buyouts"];
        for (NSDictionary *buyoutDict in buyoutArray) {
            Buyout *buyout = [Buyout buyoutFromDict:buyoutDict];
            [buyouts addObject:buyout];
        }
        completion(buyouts, error);
    }];
}

+ (void)purchaseShare:(int)bundleSize quantity:(int)quantity appleReceiptData:(NSData *)appleReceiptData completion:(void (^)(NSString *error))completion {
    NSDictionary *params = @{ @"share_purchase": @{ @"apple_receipt_data": [appleReceiptData base64EncodedStringWithOptions:0], @"bundle_size": @(bundleSize), @"quantity": @(quantity) } };
    [self connectApi:[NSString stringWithFormat:SHARE_PURCHASE, [UserManager currentUserId]] method:Post params:params json:YES completion:^(NSDictionary *headers, id responseObject, NSString *error) {
        completion(error);
    }];
}

+ (void)initiateBuyout:(int)bundleSize quantity:(int)quantity appleReceiptData:(NSString *)appleReceiptData completion:(void (^)(int availableSharesCount, int minimumAmount, NSString *error))completion {
    NSDictionary *params = @{ @"initiating_user_id": @([UserManager currentUserId]) };
    [self connectApi:[NSString stringWithFormat:NEW_BUYOUT, [UserManager currentUserId]] method:Get params:params json:NO completion:^(NSDictionary *headers, id responseObject, NSString *error) {
        NSDictionary *newBuyout = responseObject[@"new_buyout"];
        completion([newBuyout[@"available_shares_count"] intValue], [newBuyout[@"minimum_amount"] intValue], error);
    }];
}

+ (void)processImageDataWithURLString:(NSString *)urlString andBlock:(void (^)(NSData * imageData))processImage
{
    NSURL * url = [NSURL URLWithString:urlString];

    dispatch_queue_t callerQueue = dispatch_get_main_queue();
    dispatch_queue_t downloadQueue = dispatch_queue_create("com.myapp.processsmagequeue", NULL);
    dispatch_async(downloadQueue, ^{
        NSData * imageData = [NSData dataWithContentsOfURL:url];

        dispatch_async(callerQueue, ^{
            processImage(imageData);
        });
    });
}

+ (NSString *)boolToString:(BOOL)input
{
    return input ? @"true" : @"false";
}

@end
