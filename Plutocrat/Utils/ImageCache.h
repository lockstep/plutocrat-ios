//
//  ImageCache.h
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-06-15.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageCache : NSObject

@property (nonatomic, strong) NSCache * imageCache;

+ (instancetype)cache;
- (id)objectForKey:(NSString *)key;
- (void)setObject:(id)object forKey:(NSString *)key;

@end
