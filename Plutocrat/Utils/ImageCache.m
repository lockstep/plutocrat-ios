//
//  ImageCache.m
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-06-15.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import "ImageCache.h"

@implementation ImageCache

static ImageCache * instance;

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.imageCache = [[NSCache alloc] init];
    }
    return self;
}

+ (instancetype)cache
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ImageCache alloc] init];
    });
    return instance;
}

- (id)objectForKey:(NSString *)key
{
    return [instance.imageCache objectForKey:key];
}

- (void)setObject:(id)object forKey:(NSString *)key
{
    [instance.imageCache setObject:object forKey:key];
}

@end
