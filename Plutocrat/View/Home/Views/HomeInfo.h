//
//  HomeInfo.h
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-06-02.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSUInteger, HomeInfoType)
{
    HomeInfoTypeFind,
    HomeInfoTypePush,
    HomeInfoTypeCommon,
    HomeInfoTypeDefeated
};

@class HomeInfo;

@protocol HomeInfoDelegate <NSObject>
@required

- (void)homeInfoShouldNavigateToTargets:(HomeInfo *)homeInfo;
- (void)homeInfoShouldEnablePushes:(HomeInfo *)homeInfo;

@end

@interface HomeInfo : UIView

@property (nonatomic, weak) id <HomeInfoDelegate> delegate;

- (void)setType:(HomeInfoType)type;
- (void)setBuyouts:(NSUInteger)buyouts;
- (void)setName:(NSString *)name shares:(NSUInteger)shares daysAgo:(NSUInteger)days;

@end