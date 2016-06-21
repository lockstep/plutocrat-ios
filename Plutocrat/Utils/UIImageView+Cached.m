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

- (void)setUrl:(NSString *)url initials:(NSString *)initials compeltionHandler:(void (^)(UIImage *))completion
{
    [self setImage:[UIImage imageNamed:@"empty-profile-image"]];
    if ([url rangeOfString:@"missing.png"].location != NSNotFound)
    {
        if ([self.subviews count] == 0)
        {
            UILabel * lab = [[UILabel alloc] initWithFrame:self.frame];
            [lab setTextColor:[UIColor grayWithIntense:114.0f]];
            [lab setFont:[UIFont regularFontWithSize:24.0f]];
            [lab setTextAlignment:NSTextAlignmentCenter];
            [lab setText:initials];
            [lab setCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)];
            [self addSubview:lab];
        }
        else
        {
            UIView * subview = [self.subviews firstObject];
            if ([subview isKindOfClass:[UILabel class]])
            {
                UILabel * lab = (UILabel *)subview;
                [lab setHidden:NO];
                [lab setText:initials];
            }
        }
        return;
    }
    UIView * subview = [self.subviews firstObject];
    if ([subview isKindOfClass:[UILabel class]])
    {
        [subview setHidden:YES];
    }
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
            image = imageData ? [UIImage imageWithData:imageData] : [UIImage imageNamed:@"empty-profile-image"];
            [[ImageCache cache] setObject:image forKey:url];
            dispatch_async(dispatch_get_main_queue(), ^{
                [photoActivity removeFromSuperview];
                if (!completion)
                {
                    [self setImage:image];
                }
                else
                {
                    completion(image);
                }
            });
        }];
    }
}

@end
