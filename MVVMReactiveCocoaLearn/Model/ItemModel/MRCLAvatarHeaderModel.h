//
//  MRCLAvatarHeaderModel.h
//  MVVMReactiveCocoaLearn
//
//  Created by hao on 2018/12/14.
//  Copyright © 2018 hao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MRCLAvatarHeaderModel : NSObject
@property (nonatomic, strong, readonly) OCTUser *user;

/// The contentOffset of the scroll view.
@property (nonatomic, assign) CGPoint contentOffset;

@property (nonatomic, strong) RACCommand *operationCommand;
@property (nonatomic, strong) RACCommand *followersCommand;
@property (nonatomic, strong) RACCommand *repositoriesCommand;
@property (nonatomic, strong) RACCommand *followingCommand;

- (instancetype)initWithUser:(OCTUser *)user;

@end

NS_ASSUME_NONNULL_END
