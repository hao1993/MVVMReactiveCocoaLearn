//
//  MRCLOwnedReposViewModel.m
//  MVVMReactiveCocoaLearn
//
//  Created by hao on 2018/12/12.
//  Copyright © 2018 hao. All rights reserved.
//

#import "MRCLOwnedReposViewModel.h"
#import "MRCLOwnedReposItemModel.h"

@interface MRCLOwnedReposViewModel ()
@property (nonatomic, strong, readwrite) RACCommand *requestRemoteDataCommand;
@property (nonatomic, strong) OCTClient *client;
@property (nonatomic, copy, readwrite) NSArray *repositories;
@property (nonatomic, strong, readwrite) NSMutableArray *users;
@property (nonatomic, strong, readwrite) NSArray *dataSource;
@end

@implementation MRCLOwnedReposViewModel

- (instancetype)init {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.client = MRCLSharedAppClient;
    @weakify(self);
    
    self.requestRemoteDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *page) {
        @strongify(self);
        RACSignal *signal = [[self requestRemoteDataSignalWithPage:page.unsignedIntegerValue] takeUntil:self.rac_willDeallocSignal];
        return signal;
    }];
    
    [self.requestRemoteDataCommand.executionSignals.switchToLatest subscribeNext:^(NSArray *repositories) {
        @strongify(self);
        self.repositories = [repositories mutableCopy];
    }];
    
    RAC(self, dataSource) = [RACObserve(self, repositories) map:^(NSArray *repositories) {
        return [self dataSourceSignalWithRepositories:repositories];
    }];
}

- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
    return [[self.client fetchUserRepositories] collect];
}

- (NSArray *)dataSourceSignalWithRepositories:(NSArray *)repositories {
    if (repositories.count == 0) return nil;
    
    NSArray *models = [repositories.rac_sequence map:^(OCTRepository *repository) {
        return [[MRCLOwnedReposItemModel alloc] initWithRepository:repository];
    }].array;
    return models;
}



@end
