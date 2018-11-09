//
//  MRCLAppDelegate.m
//  MVVMReactiveCocoaLearn
//
//  Created by 杨世浩 on 2018/11/8.
//  Copyright © 2018 hao. All rights reserved.
//

#import "MRCLAppDelegate.h"
#import "MRCLViewModelServicesImpl.h"
#import "MRCLNavigationControllerStack.h"
#import "MRCLLoginViewModel.h"

@interface MRCLAppDelegate ()
@property (nonatomic, strong) MRCLViewModelServicesImpl *services;
@property (nonatomic, strong, readwrite) MRCLNavigationControllerStack *navigationControllerStack;
@end

@implementation MRCLAppDelegate

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.services = [[MRCLViewModelServicesImpl alloc] init];
    self.navigationControllerStack = [[MRCLNavigationControllerStack alloc] initWithServices:self.services];

    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.services resetRootViewModel:[self createInitialViewModel]];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (MRCLViewModel *)createInitialViewModel {
    // The user has logged-in.
//    if ([SSKeychain rawLogin].isExist && [SSKeychain accessToken].isExist) {
//        // Some OctoKit APIs will use the `login` property of `OCTUser`.
//        OCTUser *user = [OCTUser mrc_userWithRawLogin:[SSKeychain rawLogin] server:OCTServer.dotComServer];
//
//        OCTClient *authenticatedClient = [OCTClient authenticatedClientWithUser:user token:[SSKeychain accessToken]];
//        self.services.client = authenticatedClient;
//
//        return [[MRCHomepageViewModel alloc] initWithServices:self.services params:nil];
//    } else {
        return [[MRCLLoginViewModel alloc] initWithServices:self.services params:nil];
//    }
}

@end
