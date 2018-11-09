//
//  MRCLNavigationControllerStack.h
//  MVVMReactiveCocoaLearn
//
//  Created by 杨世浩 on 2018/11/8.
//  Copyright © 2018 hao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MRCLViewModelServices;

NS_ASSUME_NONNULL_BEGIN

@interface MRCLNavigationControllerStack : NSObject

/// Initialization method. This is the preferred way to create a new navigation controller stack.
///
/// services - The service bus of the `Model` layer.
///
/// Returns a new navigation controller stack.
- (instancetype)initWithServices:(id<MRCLViewModelServices>)services;

@end

NS_ASSUME_NONNULL_END
