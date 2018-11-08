//
//  MRCLViewModelServices.h
//  MVVMReactiveCocoaLearn
//
//  Created by 杨世浩 on 2018/11/8.
//  Copyright © 2018 hao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MRCLNavigationProtocol.h"
#import "MRCLRepositoryService.h"
#import "MRCLAppStoreService.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MRCLViewModelServices <NSObject, MRCLNavigationProtocol>

@property (nonatomic, strong) OCTClient *client;
@property (nonatomic, strong, readonly) id<MRCLRepositoryService> repositoryService;
@property (nonatomic, strong, readonly) id<MRCLAppStoreService> appStoreService;

@end

NS_ASSUME_NONNULL_END
