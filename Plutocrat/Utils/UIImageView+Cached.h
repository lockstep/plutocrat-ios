//
//  UIImageView+Cached.h
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-06-15.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Cached)

- (void)setUrl:(NSString *)url initials:(NSString *)initials compeltionHandler:(void (^)(UIImage * image))completion;
- (void)removeInitials:(BOOL)remove;

@end
