//
//  MRCLProfileViewModel.m
//  MVVMReactiveCocoaLearn
//
//  Created by hao on 2018/11/21.
//  Copyright © 2018 hao. All rights reserved.
//

#import "MRCLProfileViewModel.h"
#import "MRCLPublicReposViewController.h"

@interface MRCLProfileViewModel ()
@property (nonatomic, strong, readwrite) OCTUser *user;
@property (nonatomic, strong, readwrite) MRCLAvatarHeaderModel *avatarHeaderModel;
@end

@implementation MRCLProfileViewModel

- (instancetype)init {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    @weakify(self);
    
    self.user = [OCTUser mrc_currentUser];
    self.avatarHeaderModel = [[MRCLAvatarHeaderModel alloc] initWithUser:self.user];
    
}

@end
