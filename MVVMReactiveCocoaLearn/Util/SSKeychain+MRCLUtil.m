//
//  SSKeychain+MRCLUtil.m
//  MVVMReactiveCocoaLearn
//
//  Created by 杨世浩 on 2018/11/8.
//  Copyright © 2018 hao. All rights reserved.
//

#import "SSKeychain+MRCLUtil.h"

@implementation SSKeychain (MRCLUtil)

+ (NSString *)rawLogin {
    return [[NSUserDefaults standardUserDefaults] objectForKey:MRCL_RAW_LOGIN];
}

+ (NSString *)password {
    return [self passwordForService:MRCL_SERVICE_NAME account:MRCL_PASSWORD];
}

+ (NSString *)accessToken {
    return [self passwordForService:MRCL_SERVICE_NAME account:MRCL_ACCESS_TOKEN];
}

+ (BOOL)setRawLogin:(NSString *)rawLogin {
    if (rawLogin == nil) NSLog(@"+setRawLogin: %@", rawLogin);
    
    [[NSUserDefaults standardUserDefaults] setObject:rawLogin forKey:MRCL_RAW_LOGIN];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return YES;
}

+ (BOOL)setPassword:(NSString *)password {
    return [self setPassword:password forService:MRCL_SERVICE_NAME account:MRCL_PASSWORD];
}

+ (BOOL)setAccessToken:(NSString *)accessToken {
    return [self setPassword:accessToken forService:MRCL_SERVICE_NAME account:MRCL_ACCESS_TOKEN];
}

+ (BOOL)deleteAccessToken {
    return [self deletePasswordForService:MRCL_SERVICE_NAME account:MRCL_ACCESS_TOKEN];
}

@end
