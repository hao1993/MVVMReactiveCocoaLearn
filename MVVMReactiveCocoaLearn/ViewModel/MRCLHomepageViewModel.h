//
//  MRCLHomepageViewModel.h
//  MVVMReactiveCocoaLearn
//
//  Created by hao on 2018/11/20.
//  Copyright © 2018 hao. All rights reserved.
//

#import "MRCLTabBarViewModel.h"
#import "MRCLNewsViewModel.h"
#import "MRCLReposViewModel.h"
#import "MRCLExploreViewModel.h"
#import "MRCLProfileViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MRCLHomepageViewModel : MRCLTabBarViewModel

/// The view model of `News` interface.
@property (nonatomic, strong, readonly) MRCLNewsViewModel *newsViewModel;

/// The view model of `Repositories` interface.
@property (nonatomic, strong, readonly) MRCLReposViewModel *reposViewModel;

/// The view model of `Explore` interface.
@property (nonatomic, strong, readonly) MRCLExploreViewModel *exploreViewModel;

/// The view model of `Profile` interface.
@property (nonatomic, strong, readonly) MRCLProfileViewModel *profileViewModel;

@end

NS_ASSUME_NONNULL_END
