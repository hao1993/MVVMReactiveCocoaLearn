//
//  MRCLUserListItemModel.m
//  MVVMReactiveCocoaLearn
//
//  Created by hao on 2018/12/6.
//  Copyright © 2018 hao. All rights reserved.
//

#import "MRCLUserListItemModel.h"

@interface MRCLUserListItemModel ()
@property (nonatomic, strong, readwrite) OCTUser *user;

@property (nonatomic, copy, readwrite) NSURL *avatarURL;
@property (nonatomic, copy, readwrite) NSString *login;
@end

@implementation MRCLUserListItemModel

- (instancetype)initWithUser:(OCTUser *)user {
    self = [super init];
    if (self) {
        self.user = user;
        self.avatarURL = user.avatarURL;
        self.login = user.login;
    }
    return self;
}

@end
