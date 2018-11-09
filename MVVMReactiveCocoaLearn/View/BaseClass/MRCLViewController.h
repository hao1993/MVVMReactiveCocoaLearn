//
//  MRCLViewController.h
//  MVVMReactiveCocoaLearn
//
//  Created by hao on 2018/11/9.
//  Copyright © 2018 hao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MRCLViewController : UIViewController

/// Initialization method. This is the preferred way to create a new view.
///
/// viewModel - corresponding view model
///
/// Returns a new view.
- (instancetype)initWithViewModel:(MRCLViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_END
