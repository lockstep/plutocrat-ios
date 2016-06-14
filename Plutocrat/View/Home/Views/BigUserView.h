//
//  BigUserView.h
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-12.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+Cached.h"

@class BigUserView;

@protocol BigUserViewDelegate <NSObject>
@optional

- (void)bigUserViewShouldOpenAccount:(BigUserView *)view;

@end

@interface BigUserView : UIView

@property (nonatomic, weak) id <BigUserViewDelegate> delegate;

- (void)setPhotoUrl:(NSString *)url
               name:(NSString *)nameStr
              email:(NSString *)emailStr
      sharesToMatch:(NSUInteger)toMatch;

@end
