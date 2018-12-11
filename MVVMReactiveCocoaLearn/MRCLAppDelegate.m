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
#import "MRCLHomepageViewModel.h"

@interface MRCLAppDelegate ()
@property (nonatomic, strong) MRCLViewModelServicesImpl *services;
@property (nonatomic, strong, readwrite) MRCLNavigationControllerStack *navigationControllerStack;
@property (nonatomic, strong, readwrite) OCTClient *client;
@end

@implementation MRCLAppDelegate

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self configureFMDB];
    [self configureKeyboardManager];
    
    self.services = [[MRCLViewModelServicesImpl alloc] init];
    self.navigationControllerStack = [[MRCLNavigationControllerStack alloc] initWithServices:self.services];

    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.services resetRootViewModel:[self createInitialViewModel]];
    [self.window makeKeyAndVisible];
    
    // Save the application version info.
    [[NSUserDefaults standardUserDefaults] setValue:MRC_APP_VERSION forKey:MRCApplicationVersionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return YES;
}

- (MRCLViewModel *)createInitialViewModel {
    // The user has logged-in.
    if ([SSKeychain rawLogin].isExist && [SSKeychain accessToken].isExist) {
        // Some OctoKit APIs will use the `login` property of `OCTUser`.
        OCTUser *user = [OCTUser mrc_userWithRawLogin:[SSKeychain rawLogin] server:OCTServer.dotComServer];

        OCTClient *authenticatedClient = [OCTClient authenticatedClientWithUser:user token:[SSKeychain accessToken]];
        self.services.client = authenticatedClient;
        self.client = authenticatedClient;
        return [[MRCLHomepageViewModel alloc] initWithServices:self.services params:nil];
    } else {
        return [[MRCLLoginViewModel alloc] initWithServices:self.services params:nil];
    }
}

#pragma mark - Application configuration

- (void)configureFMDB {
    [[FMDatabaseQueue sharedInstance] inDatabase:^(FMDatabase *db) {
        NSString *version = [[NSUserDefaults standardUserDefaults] valueForKey:MRCApplicationVersionKey];
        if (![version isEqualToString:MRC_APP_VERSION]) {
            if (version == nil) {
                [SSKeychain deleteAccessToken];
                
                NSString *path = [[NSBundle mainBundle] pathForResource:@"update_v1_2_0" ofType:@"sql"];
                NSString *sql  = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
                
                if (![db executeStatements:sql]) {
                    MRCLogLastError(db);
                }
            }
        }
    }];
}

- (void)configureKeyboardManager {
    IQKeyboardManager.sharedManager.enableAutoToolbar = NO;
    IQKeyboardManager.sharedManager.shouldResignOnTouchOutside = YES;
}

@end
