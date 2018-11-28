//
//  SSKeychain+MRCLUtil.h
//  MVVMReactiveCocoaLearn
//
//  Created by 杨世浩 on 2018/11/8.
//  Copyright © 2018 hao. All rights reserved.
//

#import "SSKeychain.h"

NS_ASSUME_NONNULL_BEGIN

@interface SSKeychain (MRCLUtil)

+ (NSString *)rawLogin;
+ (NSString *)password;
+ (NSString *)accessToken;

+ (BOOL)setRawLogin:(NSString *)rawLogin;
+ (BOOL)setPassword:(NSString *)password;
+ (BOOL)setAccessToken:(NSString *)accessToken;

+ (BOOL)deleteAccessToken;
@end

NS_ASSUME_NONNULL_END
