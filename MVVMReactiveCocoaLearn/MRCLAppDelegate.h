//
//  MRCLAppDelegate.h
//  MVVMReactiveCocoaLearn
//
//  Created by 杨世浩 on 2018/11/8.
//  Copyright © 2018 hao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRCLNavigationControllerStack.h"

NS_ASSUME_NONNULL_BEGIN

@interface MRCLAppDelegate : UIResponder <UIApplicationDelegate>

/// The window of current application.
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong, readonly) MRCLNavigationControllerStack *navigationControllerStack;
@property (nonatomic, strong, readonly) OCTClient *client;
@end

NS_ASSUME_NONNULL_END
