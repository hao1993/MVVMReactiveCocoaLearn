//
//  MRCLViewModelServicesImpl.m
//  MVVMReactiveCocoaLearn
//
//  Created by 杨世浩 on 2018/11/8.
//  Copyright © 2018 hao. All rights reserved.
//

#import "MRCLViewModelServicesImpl.h"
#import "MRCLRepositoryServiceImpl.h"
#import "MRCLAppStoreServiceImpl.h"

@implementation MRCLViewModelServicesImpl

@synthesize client = _client;
@synthesize repositoryService = _repositoryService;
@synthesize appStoreService = _appStoreService;

- (instancetype)init {
    self = [super init];
    if (self) {
        _repositoryService = [[MRCLRepositoryServiceImpl alloc] init];
        _appStoreService   = [[MRCLAppStoreServiceImpl alloc] init];
    }
    return self;
}

- (void)pushViewModel:(MRCLViewModel *)viewModel animated:(BOOL)animated {}

- (void)popViewModelAnimated:(BOOL)animated {}

- (void)popToRootViewModelAnimated:(BOOL)animated {}

- (void)presentViewModel:(MRCLViewModel *)viewModel animated:(BOOL)animated completion:(VoidBlock)completion {}

- (void)dismissViewModelAnimated:(BOOL)animated completion:(VoidBlock)completion {}

- (void)resetRootViewModel:(MRCLViewModel *)viewModel {}

@end
