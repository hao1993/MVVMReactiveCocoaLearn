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

@property (nonatomic, copy, readwrite) NSString *company;
@property (nonatomic, copy, readwrite) NSString *location;
@property (nonatomic, copy, readwrite) NSString *email;
@property (nonatomic, copy, readwrite) NSString *blog;
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
    
    id(^map)(NSString *) = ^(NSString *value) {
        return (value.length > 0 && ![value isEqualToString:@"(null)"] ? value : MRC_EMPTY_PLACEHOLDER);
    };
    
    RAC(self, company) = [RACObserve(self.user, company) map:map];
    RAC(self, location) = [RACObserve(self.user, location) map:map];
    RAC(self, email) = [RACObserve(self.user, email) map:map];
    RAC(self, blog) = [RACObserve(self.user, blog) map:map];
}

@end
