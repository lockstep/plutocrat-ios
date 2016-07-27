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

#define IS_PRODUCTION 1

#define PRODUCTION_SERVER @"https://plutocracy.herokuapp.com"
#define STAGING_SERVER @"https://plutocracy-staging.herokuapp.com"

#define API_PATH @"/api/v1/"

#define SIGN_IN @"users/sign_in"
#define SIGN_UP @"users"
#define SIGN_OUT @"users/sign_out"
#define PASSWORD @"users/password"
#define PROFILE @"users/%lu"
#define GET_USERS @"users"
#define GET_BUYOUTS @"users/%lu/buyouts"
#define SHARE_PURCHASE @"users/%lu/receipt"
#define PREPARE_BUYOUT @"users/%lu/buyouts/new"
#define INITIATE_BUYOUT @"users/%lu/buyout"
#define MATCH_BUYOUT @"buyouts/%lu/match"
#define FAIL_TO_MATCH_BUYOUT @"buyouts/%lu/fail_to_match"

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

+ (void)connectApi:(NSString *)apiName
            method:(enum ApiMethod)method
            params:(NSDictionary *)params
              json:(BOOL)json
        completion:(void (^)(NSDictionary * header, id responseObject, NSString * error))completion
{    
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

        switch (statusCode) {
            case 200:
            case 201: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    NSDictionary * meta = responseObject[@"meta"];
                    NSString * err;
                    if (meta[@"errors"])
                    {
                        err = [self sanitizedError:[[[meta[@"errors"] allValues] firstObject] description]];
                    }
                    completion(httpResponse.allHeaderFields, responseObject, err);
                });
            }
                break;
                
            case 401: {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSArray *errors = responseObject[@"meta"][@"errors"][@"auth"];
                    completion(httpResponse.allHeaderFields, responseObject, errors.firstObject);//@"Invalid login credentials. Please try again.");
                });
            }
                break;
                
            case 404: {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(httpResponse.allHeaderFields, responseObject, @"Host is not reachable at this time. Please try again.");
                });
            }
                break;

            case 422: {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSDictionary * meta = responseObject[@"meta"];
                    NSString * err;
                    if (meta[@"errors"])
                    {
                        if ([meta[@"errors"][@"full_messages"] respondsToSelector:@selector(firstObject)])
                        {
                            err = [meta[@"errors"][@"full_messages"] firstObject];
                        }
                    }
                    completion(httpResponse.allHeaderFields, responseObject, err);
                });
            }
                break;

            default: {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(httpResponse.allHeaderFields, nil, @"Unknown error has occured. Please try again.");
                });
            }
                break;

        }
    }];
    [dataTask resume];
}

+ (void)signInWithEmail:(NSString *)email
               password:(NSString *)password
             completion:(void (^)(NSDictionary * response, NSString * error))completion
{
    NSDictionary * params = @{@"email": email, @"password": password};
    [self connectApi:SIGN_IN
              method:Post
              params:params
                json:YES
          completion:^(NSDictionary * headers, id responseObject, NSString * error) {
        if (!error)
        {
            [UserManager storeUser:responseObject[@"user"] headers:headers];
        }
        completion(responseObject, error);
    }];
}

+ (void)signUpWithDisplayName:(NSString *)displayName
                        email:(NSString *)email
                     password:(NSString *)password
                   completion:(void (^)(NSDictionary * response, NSString * error))completion
{
    NSDictionary * params = @{@"email": email,
                              @"password": password,
                              @"password_confirmation": password,
                              @"display_name": displayName};
    [self connectApi:SIGN_UP
              method:Post
              params:params
                json:YES
          completion:^(NSDictionary * headers, id responseObject, NSString * error) {
        NSDictionary * errors = responseObject[@"meta"][@"errors"];
        if ([errors[@"display_name"] count] > 0)
        {
            completion(responseObject, [NSString stringWithFormat:@"Display name %@", [errors[@"display_name"] firstObject]]);
        }
        else if ([errors[@"email"] count] > 0)
        {
            completion(responseObject, [NSString stringWithFormat:@"Email %@", [errors[@"email"] firstObject]]);
        }
        else if ([errors[@"password"] count] > 0)
        {
            completion(responseObject, [NSString stringWithFormat:@"Password %@", [errors[@"password"] firstObject]]);
        } else
        {
            if (!error)
            {
                [UserManager storeUser:responseObject[@"user"] headers:headers];
            }
            completion(responseObject, error);
        }
    }];
}

+ (void)signOutWithEmail:(NSString *)email
              completion:(void (^)(NSString *))completion
{
    NSDictionary * params = @{@"email": email};
    [self connectApi:SIGN_OUT
              method:Delete
              params:params
                json:YES
          completion:^(NSDictionary * headers, id responseObject, NSString * error) {
        if (!error)
        {
            [UserManager removeUser];
        }
        completion(error);
    }];
}

+ (void)requestPasswordWithEmail:(NSString *)email
                      completion:(void (^)(NSString *error))completion
{
    NSDictionary * params = @{@"email": email};
    [self connectApi:PASSWORD
              method:Post params:params
                json:YES
          completion:^(NSDictionary * headers, id responseObject, NSString * error) {
        completion(error);
    }];
}

+ (void)resetPasswordWithToken:(NSString *)token
                      password:(NSString *)password
                    completion:(void (^)(NSString *error))completion {
    NSDictionary * params = @{@"reset_password_token": token, @"password": password};
    [self connectApi:PASSWORD
              method:Patch
              params:params
                json:YES
          completion:^(NSDictionary * headers, id responseObject, NSString * error) {
        completion(error);
    }];
}

+ (void)updateProfileWithUserId:(NSUInteger)userId
                          email:(NSString *)email
                    newPassword:(NSString *)newPassword
                currentPassword:(NSString *)currentPassword
                    displayName:(NSString *)displayName
                   profileImage:(UIImage *)image
                   eventsEmails:(BOOL)eventsEmails
                  updatesEmails:(BOOL)updatesEmails
                     completion:(void (^)(NSDictionary *, NSString *))completion
{
    NSDictionary * paramsStatic = @{@"email": email,
                                    @"display_name": displayName,
                                    @"transactional_emails_enabled": @(eventsEmails),
                                    @"product_emails_enabled": @(updatesEmails)};
    NSMutableDictionary * params = [paramsStatic mutableCopy];
    if (newPassword.length > 0 && currentPassword.length > 0)
    {
        [params setObject:newPassword forKey:@"password"];
        [params setObject:currentPassword forKey:@"current_password"];
    }
    if (currentPassword.length > 0 && email.length > 0)
    {
        [params setObject:currentPassword forKey:@"current_password"];
    }
    if (image)
    {
        [params setObject:image forKey:@"profile_image"];
    }
    [self connectApi:[NSString stringWithFormat:PROFILE, (unsigned long)userId]
              method:Patch
              params:params
                json:YES
          completion:^(NSDictionary * headers, id responseObject, NSString * error) {
        if (!error)
        {
            [UserManager storeUser:responseObject[@"user"] headers:headers];
        }
        completion(responseObject, error);
    }];
}

+ (void)updateDeviceToken:(NSString *)token
               completion:(void (^)(User *, NSString *))completion
{
    NSDictionary * params = @{@"devices_attributes":@[@{@"token": token, @"platform": @"ios"}]};
    NSUInteger userId = [UserManager currentUserId];
    [self connectApi:[NSString stringWithFormat:PROFILE, (unsigned long)userId]
              method:Patch
              params:params
                json:YES
          completion:^(NSDictionary * headers, id responseObject, NSString * error) {
              if (!error)
              {
                  [UserManager storeUser:responseObject[@"user"] headers:headers];
              }
              if (completion)
              {
                  completion(responseObject, error);
              }
          }];
}

+ (void)getProfileWithUserId:(NSUInteger)userId
                  completion:(void (^)(User *, NSString *))completion
{
    NSDictionary * params = nil;
    [self connectApi:[NSString stringWithFormat:PROFILE, (unsigned long)userId]
              method:Get
              params:params
                json:YES
          completion:^(NSDictionary * headers, id responseObject, NSString * error) {
              User * user = [User userFromDict:responseObject[@"user"]];
              if (!error && [UserManager currentUserId] == userId)
              {
                  [UserManager storeUser:responseObject[@"user"] headers:headers];
              }
              completion(user, error);
    }];
}

+ (void)getUsersWithPage:(NSUInteger)page
              completion:(void (^)(NSArray *, NSUInteger, BOOL, NSString *))completion
{
    NSDictionary * params = @{@"page": @(page)};
    [self connectApi:GET_USERS
              method:Get
              params:params
                json:NO
          completion:^(NSDictionary * headers, id responseObject, NSString * error) {
        NSMutableArray * users = [NSMutableArray array];
        NSArray * userArray = responseObject[@"users"];
        NSDictionary * meta = responseObject[@"meta"];
        NSUInteger current_page = [(NSString *)meta[@"current_page"] integerValue];
        NSUInteger total_pages = [(NSString *)meta[@"total_pages"] integerValue];
        NSUInteger perPage = [(NSString *)meta[@"per_page"] integerValue];
        for (NSDictionary * userDict in userArray)
        {
            User * user = [User userFromDict:userDict];
            [users addObject:user];
        }
        completion(users, perPage, current_page==total_pages, error);
    }];
}

+ (void)getBuyoutsWithPage:(NSUInteger)page
                completion:(void (^)(NSArray *, NSUInteger, BOOL, NSString *))completion
{
    NSDictionary *params = @{@"page": @(page)};
    [self connectApi:[NSString stringWithFormat:GET_BUYOUTS, (unsigned long)[UserManager currentUserId]]
              method:Get
              params:params
                json:NO
          completion:^(NSDictionary * headers, id responseObject, NSString * error) {
         NSDictionary * meta = responseObject[@"meta"];
         NSUInteger current_page = [(NSString *)meta[@"current_page"] integerValue];
         NSUInteger total_pages = [(NSString *)meta[@"total_pages"] integerValue];
         NSUInteger perPage = [(NSString *)meta[@"per_page"] integerValue];
         NSMutableArray * buyouts = [NSMutableArray array];
         NSArray * buyoutArray = responseObject[@"buyouts"];
         for (NSDictionary * buyoutDict in buyoutArray)
         {
             Buyout *buyout = [Buyout buyoutFromDict:buyoutDict];
             [buyouts addObject:buyout];
         }
         completion(buyouts, perPage, current_page==total_pages, error);
    }];
}

+ (void)purchaseSharesWithAppleReceiptData:(NSData *)appleReceiptData
                                completion:(void (^)(NSString *))completion
{
    NSDictionary * params = @{@"purchase_token": [appleReceiptData base64EncodedStringWithOptions:0], @"type": @"ios"};

    [self connectApi:[NSString stringWithFormat:SHARE_PURCHASE, (unsigned long)[UserManager currentUserId]]
              method:Post
              params:params
                json:YES
          completion:^(NSDictionary * headers, id responseObject, NSString * error) {
        completion(error);
    }];
}

+ (void)prepareBuyoutToUser:(NSUInteger)userId
                 completion:(void (^)(NSUInteger, NSUInteger, NSString *))completion
{
    [self connectApi:[NSString stringWithFormat:PREPARE_BUYOUT, (unsigned long)userId]
              method:Get
              params:nil
                json:NO
          completion:^(NSDictionary * headers, id responseObject, NSString * error) {
        NSDictionary * newBuyout = responseObject[@"new_buyout"];
        NSUInteger availableSharesCount = [newBuyout[@"available_shares_count"] unsignedIntegerValue];
        NSUInteger minimumBuyoutShares = [newBuyout[@"minimum_buyout_shares"] unsignedIntegerValue];
        completion(availableSharesCount, minimumBuyoutShares, error);
    }];
}

+ (void)initiateBuyoutToUser:(NSUInteger)userId
              amountOfShares:(NSUInteger)amount
                  completion:(void (^)(Buyout *, NSString *))completion
{
    NSDictionary * params = @{@"buyout":
                                  @{@"number_of_shares":@(amount)}
                              };
    [self connectApi:[NSString stringWithFormat:INITIATE_BUYOUT, (unsigned long)userId]
              method:Post
              params:params
                json:YES
          completion:^(NSDictionary * headers, id responseObject, NSString * error) {
         NSDictionary * buyoutDict = responseObject[@"buyout"];
         Buyout * buyout = [Buyout buyoutFromDict:buyoutDict];
         completion(buyout, error);
     }];
}

+ (void)matchBuyout:(NSUInteger)buyoutId
         completion:(void (^)(User *, NSString *))completion
{
    [self connectApi:[NSString stringWithFormat:MATCH_BUYOUT, (unsigned long)buyoutId]
              method:Patch
              params:nil
                json:NO
          completion:^(NSDictionary * headers, id responseObject, NSString * error) {
         if (!error)
         {
             [UserManager storeUser:responseObject[@"user"] headers:headers];
         }
         User * user = [User userFromDict:responseObject[@"user"]];
         completion(user, error);
     }];
}

+ (void)failToMatchBuyout:(NSUInteger)buyoutId
               completion:(void (^)(User *, NSString *))completion
{
    [self connectApi:[NSString stringWithFormat:FAIL_TO_MATCH_BUYOUT, (unsigned long)buyoutId]
              method:Patch
              params:nil
                json:NO
          completion:^(NSDictionary * headers, id responseObject, NSString * error) {
         if (!error)
         {
             [UserManager storeUser:responseObject[@"user"] headers:headers];
         }
         User * user = [User userFromDict:responseObject[@"user"]];
         completion(user, error);
     }];
}

+ (void)processImageDataWithURLString:(NSString *)urlString
                             andBlock:(void (^)(NSData *))processImage
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

+ (NSString *)sanitizedError:(NSString *)error
{
    return [[[[error stringByReplacingOccurrencesOfString:@"(" withString:@""] stringByReplacingOccurrencesOfString:@")" withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
}

@end
