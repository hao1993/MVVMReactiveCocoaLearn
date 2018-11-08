//
//  MRCLRepositoryService.h
//  MVVMReactiveCocoaLearn
//
//  Created by 杨世浩 on 2018/11/8.
//  Copyright © 2018 hao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MRCLRepositoryService <NSObject>

- (RACSignal *)requestRepositoryReadmeHTML:(OCTRepository *)repository reference:(NSString *)reference;
- (RACSignal *)requestTrendingRepositoriesSince:(NSString *)since language:(NSString *)language;

/// Request showcases from http://trending.leichunfeng.com/v2/showcases
///
/// @return Showcases
- (RACSignal *)requestShowcases;

/// Request showcase repos , such as http://trending.leichunfeng.com/v2/showcases/swift
///
/// @param slug
///
/// @return
- (RACSignal *)requestShowcaseRepositoriesWithSlug:(NSString *)slug;

@end

NS_ASSUME_NONNULL_END
