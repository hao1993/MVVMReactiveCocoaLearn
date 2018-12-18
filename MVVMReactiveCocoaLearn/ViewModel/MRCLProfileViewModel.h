//
//  MRCLProfileViewModel.h
//  MVVMReactiveCocoaLearn
//
//  Created by hao on 2018/11/21.
//  Copyright © 2018 hao. All rights reserved.
//

#import "MRCLTabBarViewModel.h"
#import "MRCLAvatarHeaderModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MRCLProfileViewModel : NSObject

/// The current `user`.
@property (nonatomic, strong, readonly) OCTUser *user;
@property (nonatomic, strong, readonly) MRCLAvatarHeaderModel *avatarHeaderModel;

@end

NS_ASSUME_NONNULL_END
