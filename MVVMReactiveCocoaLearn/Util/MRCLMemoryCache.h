//
//  MRCLMemoryCache.h
//  MVVMReactiveCocoaLearn
//
//  Created by hao on 2018/11/28.
//  Copyright © 2018 hao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MRCLMemoryCache : NSObject

+ (instancetype)sharedInstance;

- (id)objectForKey:(NSString *)key;
- (void)setObject:(id)object forKey:(NSString *)key;
- (void)removeObjectForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
