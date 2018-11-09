//
//  MRCLRouter.h
//  MVVMReactiveCocoaLearn
//
//  Created by hao on 2018/11/9.
//  Copyright © 2018 hao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MRCLViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MRCLRouter : NSObject

/// Retrieves the shared router instance.
///
/// Returns the shared router instance.
+ (instancetype)sharedInstance;

/// Retrieves the view corresponding to the given view model.
///
/// viewModel - The view model
///
/// Returns the view corresponding to the given view model.
- (MRCLViewController *)viewControllerForViewModel:(MRCLViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_END
