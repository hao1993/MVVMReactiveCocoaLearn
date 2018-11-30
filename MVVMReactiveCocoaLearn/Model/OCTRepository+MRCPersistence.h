//
//  OCTRepository+MRCPersistence.h
//  MVVMReactiveCocoaLearn
//
//  Created by hao on 2018/11/29.
//  Copyright © 2018 hao. All rights reserved.
//

#import <OctoKit/OctoKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCTRepository (MRCPersistence)

+ (BOOL)mrc_saveOrUpdateRepositories:(NSArray *)repositories;
+ (BOOL)mrc_saveOrUpdateStarredStatusWithRepositories:(NSArray *)repositories;

@end

NS_ASSUME_NONNULL_END
