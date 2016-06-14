//
//  UIImageView+Cached.m
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-06-15.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import "UIImageView+Cached.h"
#import "ImageCache.h"
#import "ApiConnector.h"

@implementation UIImageView (Cached)

- (void)setUrl:(NSString *)url
{
    __block UIImage * image = [[ImageCache cache] objectForKey:url];
    if (image)
    {
        [self setImage:image];
    }
    else
    {
        UIActivityIndicatorView * photoActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [photoActivity setCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)];
        [self addSubview:photoActivity];
        [photoActivity startAnimating];
        [ApiConnector processImageDataWithURLString:url andBlock:^(NSData * imageData) {
            [photoActivity removeFromSuperview];
            image = imageData ? [UIImage imageWithData:imageData] : [[UIImage alloc] init];
            [self setImage:image];
            [[ImageCache cache] setObject:image forKey:url];
        }];
    }
}

@end
