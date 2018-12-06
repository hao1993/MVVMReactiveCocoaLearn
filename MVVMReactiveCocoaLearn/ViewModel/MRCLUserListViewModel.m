//
//  MRCLUserListViewModel.m
//  MVVMReactiveCocoaLearn
//
//  Created by hao on 2018/12/6.
//  Copyright © 2018 hao. All rights reserved.
//

#import "MRCLUserListViewModel.h"
#import "MRCLUserListItemModel.h"

@interface MRCLUserListViewModel ()
@property (nonatomic, strong, readwrite) RACCommand *requestRemoteDataCommand;
@property (nonatomic, copy, readwrite) NSArray *users;
@end

@implementation MRCLUserListViewModel

- (instancetype)init {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    @weakify(self);
    self.requestRemoteDataCommand = [[RACCommand alloc] initWithSignalBlock:^(NSNumber *page) {
        @strongify(self)
        return [[self requestRemoteDataSignalWithPage:page.unsignedIntegerValue] takeUntil:self.rac_willDeallocSignal];
    }];
    
    [self.requestRemoteDataCommand.executionSignals.switchToLatest subscribeNext:^(NSArray *users) {
        @strongify(self);
        self.users = [users mutableCopy];
    }];
    
    RAC(self, dataSource) = [RACObserve(self, users) map:^(NSArray *users) {
        @strongify(self)
        return [self dataSourceWithUsers:users];
    }];
}

- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
    OCTUser *user = [OCTUser mrc_currentUser];
    OCTClient *authenticatedClient = [OCTClient authenticatedClientWithUser:user token:[SSKeychain accessToken]];
    
    return [[[[authenticatedClient fetchFollowingForUser:user offset:0 perPage:100]
              take:100]
             collect]
            map:^(NSArray *users) {
                return users;
            }];
}

- (NSArray *)dataSourceWithUsers:(NSArray *)users {
    if (users.count == 0) return nil;
    
    NSArray *models = [users.rac_sequence map:^id(OCTUser *user) {
        MRCLUserListItemModel *model = [[MRCLUserListItemModel alloc] initWithUser:user];
        return model;
    }].array;
    
    return models;
}

@end
