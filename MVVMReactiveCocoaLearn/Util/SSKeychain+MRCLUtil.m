//
//  SSKeychain+MRCLUtil.m
//  MVVMReactiveCocoaLearn
//
//  Created by 杨世浩 on 2018/11/8.
//  Copyright © 2018 hao. All rights reserved.
//

#import "SSKeychain+MRCLUtil.h"

@implementation SSKeychain (MRCLUtil)

+ (NSString *)accessToken {
    return [self passwordForService:MRCL_SERVICE_NAME account:MRCL_ACCESS_TOKEN];
}

@end
