//
//  MRCLUserListItemModel.h
//  MVVMReactiveCocoaLearn
//
//  Created by hao on 2018/12/6.
//  Copyright © 2018 hao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MRCLUserListItemModel : NSObject

@property (nonatomic, strong, readonly) OCTUser *user;

@property (nonatomic, copy, readonly) NSURL *avatarURL;
@property (nonatomic, copy, readonly) NSString *login;

@property (nonatomic, strong) RACCommand *operationCommand;

- (instancetype)initWithUser:(OCTUser *)user;

@end

NS_ASSUME_NONNULL_END
