//
//  MRCLAppDelegate.m
//  MVVMReactiveCocoaLearn
//
//  Created by 杨世浩 on 2018/11/8.
//  Copyright © 2018 hao. All rights reserved.
//

#import "MRCLAppDelegate.h"
#import "MRCLViewModelServicesImpl.h"

@interface MRCLAppDelegate ()
@property (nonatomic, strong) MRCLViewModelServicesImpl *services;
@end

@implementation MRCLAppDelegate

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.services = [[MRCLViewModelServicesImpl alloc] init];


    return YES;
}

@end
