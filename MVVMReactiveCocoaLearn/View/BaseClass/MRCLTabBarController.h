//
//  MRCLTabBarController.h
//  MVVMReactiveCocoaLearn
//
//  Created by hao on 2018/11/9.
//  Copyright © 2018 hao. All rights reserved.
//

#import "MRCLViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MRCLTabBarController : MRCLViewController <UITabBarControllerDelegate>

@property (nonatomic, strong, readonly) UITabBarController *tabBarController;

@end

NS_ASSUME_NONNULL_END
