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
@property (nonatomic, strong) OCTClient *client;
@property (nonatomic, strong) RACCommand *operationCommand;
@property (nonatomic, strong, readwrite) NSMutableArray *users;
@property (nonatomic, strong, readwrite) NSArray *dataSource;
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

    self.page = 1;
    self.perPage = MRCL_MAX_PERPAGE;
    
    self.client = MRCLSharedAppClient;
    self.users = [NSMutableArray array];
    
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
        if (self.page == 1) {
            [self.users removeAllObjects];
            [self.users addObjectsFromArray:users];
        } else {
            [self.users addObjectsFromArray:users];
        }
        self.dataSource = [self dataSourceWithUsers:self.users];
    }];
}

- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
    OCTUser *user = [OCTUser mrc_currentUser];
    OCTClient *client = MRCLSharedAppClient;
    return [[[[client fetchFollowingForUser:user offset:[self offsetForPage:page] perPage:self.perPage]
              take:self.perPage]
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


- (NSUInteger)offsetForPage:(NSUInteger)page {
    return (page - 1) * self.perPage;
}

@end
