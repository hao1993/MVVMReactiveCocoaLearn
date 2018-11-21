//
//  MRCLHomepageViewModel.m
//  MVVMReactiveCocoaLearn
//
//  Created by hao on 2018/11/20.
//  Copyright © 2018 hao. All rights reserved.
//

#import "MRCLHomepageViewModel.h"

@interface MRCLHomepageViewModel ()

@property (nonatomic, strong, readwrite) MRCLNewsViewModel    *newsViewModel;
@property (nonatomic, strong, readwrite) MRCLReposViewModel   *reposViewModel;
@property (nonatomic, strong, readwrite) MRCLExploreViewModel *exploreViewModel;
@property (nonatomic, strong, readwrite) MRCLProfileViewModel *profileViewModel;

@end

@implementation MRCLHomepageViewModel

- (void)initialize {
    [super initialize];
    
    self.newsViewModel = [[MRCLNewsViewModel alloc] initWithServices:self.services params:nil];
    self.reposViewModel = [[MRCLReposViewModel alloc] initWithServices:self.services params:nil];
    self.exploreViewModel = [[MRCLExploreViewModel alloc] initWithServices:self.services params:nil];
    self.profileViewModel = [[MRCLProfileViewModel alloc] initWithServices:self.services params:nil];
}

@end
