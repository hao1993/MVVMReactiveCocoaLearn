//
//  MRCLAvatarHeaderModel.m
//  MVVMReactiveCocoaLearn
//
//  Created by hao on 2018/12/14.
//  Copyright © 2018 hao. All rights reserved.
//

#import "MRCLAvatarHeaderModel.h"

@interface MRCLAvatarHeaderModel ()
@property (nonatomic, strong, readwrite) OCTUser *user;

@end

@implementation MRCLAvatarHeaderModel

- (instancetype)initWithUser:(OCTUser *)user {
    self = [super init];
    if (self) {
        self.user = user;
    }
    return self;
}

@end
