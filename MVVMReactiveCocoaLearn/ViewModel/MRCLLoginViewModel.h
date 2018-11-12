//
//  MRCLLoginViewModel.h
//  MVVMReactiveCocoaLearn
//
//  Created by hao on 2018/11/9.
//  Copyright © 2018 hao. All rights reserved.
//

#import "MRCLViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MRCLLoginViewModel : MRCLViewModel

/// The avatar URL of the user.
@property (nonatomic, copy, readonly) NSURL *avatarURL;

/// The username entered by the user.
@property (nonatomic, copy) NSString *username;

/// The password entered by the user.
@property (nonatomic, copy) NSString *password;

@property (nonatomic, strong, readonly) RACSignal *validLoginSignal;

/// The command of login button.
@property (nonatomic, strong, readonly) RACCommand *loginCommand;

/// The command of uses browser to login button.
@property (nonatomic, strong, readonly) RACCommand *browserLoginCommand;
@property (nonatomic, strong, readonly) RACCommand *exchangeTokenCommand;

@end

NS_ASSUME_NONNULL_END
