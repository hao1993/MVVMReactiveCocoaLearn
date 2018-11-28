//
//  MRCLMemoryCache.m
//  MVVMReactiveCocoaLearn
//
//  Created by hao on 2018/11/28.
//  Copyright © 2018 hao. All rights reserved.
//

#import "MRCLMemoryCache.h"

static MRCLMemoryCache *_memoryCache = nil;

@interface MRCLMemoryCache ()

@property (nonatomic, strong) NSMutableDictionary *dictionary;

@end

@implementation MRCLMemoryCache

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _memoryCache = [[MRCLMemoryCache alloc] init];
    });
    return _memoryCache;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _dictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (id)objectForKey:(NSString *)key {
    return [self.dictionary objectForKey:key];
}

- (void)setObject:(id)object forKey:(NSString *)key {
    [self.dictionary setObject:object forKey:key];
}

- (void)removeObjectForKey:(NSString *)key {
    [self.dictionary removeObjectForKey:key];
}

@end
