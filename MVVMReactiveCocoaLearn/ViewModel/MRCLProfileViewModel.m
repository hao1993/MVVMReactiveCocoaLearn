//
//  MRCLProfileViewModel.m
//  MVVMReactiveCocoaLearn
//
//  Created by hao on 2018/11/21.
//  Copyright © 2018 hao. All rights reserved.
//

#import "MRCLProfileViewModel.h"

@interface MRCLProfileViewModel ()
@property (nonatomic, strong, readwrite) OCTUser *user;
@property (nonatomic, strong, readwrite) MRCLAvatarHeaderModel *avatarHeaderModel;
@end

@implementation MRCLProfileViewModel

- (instancetype)initWithServices:(id<MRCLViewModelServices>)services params:(NSDictionary *)params {
    self = [super initWithServices:services params:params];
    if (self) {
        id user = params[@"user"];
        
        if ([user isKindOfClass:[OCTUser class]]) {
            self.user = params[@"user"];
        } else if ([user isKindOfClass:[NSDictionary class]]) {
            self.user = [OCTUser modelWithDictionary:user error:nil];
        } else {
            self.user = [OCTUser mrc_currentUser];
        }
    }
    return self;
}

@end
