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
@property (nonatomic, strong) OCTClient *client;
@property (nonatomic, strong) RACCommand *operationCommand;
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

    self.client = MRCLSharedAppClient;
    
    self.operationCommand = [[RACCommand alloc] initWithSignalBlock:^(MRCLUserListItemModel *model) {
        @strongify(self)
        if (model.user.followingStatus == OCTUserFollowingStatusYES) {
            return [self.client mrc_unfollowUser:model.user];
        } else if (model.user.followingStatus == OCTUserFollowingStatusNO) {
            return [self.client mrc_followUser:model.user];
        }
        return [RACSignal empty];
    }];
    
    self.operationCommand.allowsConcurrentExecution = YES;
    
    self.requestRemoteDataCommand = [[RACCommand alloc] initWithSignalBlock:^(NSNumber *page) {
        @strongify(self)
        RACSignal *signal = [[self requestRemoteDataSignalWithPage:page.unsignedIntegerValue] takeUntil:self.rac_willDeallocSignal];
        return signal == nil ? [RACSignal empty] : signal;
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
    OCTClient *client = MRCLSharedAppClient;
    return [[[[client fetchFollowingForUser:user offset:0 perPage:100]
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
        
        if (user.followingStatus == OCTUserFollowingStatusUnknown) {
            [[self.client doesFollowUser:user]
             subscribeNext:^(NSNumber *isFollowing) {
                 if (isFollowing.boolValue) {
                     user.followingStatus = OCTUserFollowingStatusYES;
                 } else {
                     user.followingStatus = OCTUserFollowingStatusNO;
                 }
             }];
        }
        
        if (![user.objectID isEqualToString:[OCTUser mrc_currentUserId]]) { // Exclude myself
            model.operationCommand = self.operationCommand;
        }
        
        return model;
    }].array;
    
    return models;
}

@end
