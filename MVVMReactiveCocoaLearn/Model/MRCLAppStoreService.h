//
//  MRCLAppStoreService.h
//  MVVMReactiveCocoaLearn
//
//  Created by 杨世浩 on 2018/11/8.
//  Copyright © 2018 hao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MRCLAppStoreService <NSObject>

- (RACSignal *)requestAppInfoFromAppStoreWithAppID:(NSString *)appID;

@end

NS_ASSUME_NONNULL_END
