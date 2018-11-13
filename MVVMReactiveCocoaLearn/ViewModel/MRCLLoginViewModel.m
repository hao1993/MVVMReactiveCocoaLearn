//
//  MRCLLoginViewModel.m
//  MVVMReactiveCocoaLearn
//
//  Created by hao on 2018/11/9.
//  Copyright © 2018 hao. All rights reserved.
//

#import "MRCLLoginViewModel.h"

@interface MRCLLoginViewModel ()
@property (nonatomic, copy, readwrite) NSURL *avatarURL;

@property (nonatomic, strong, readwrite) RACSignal *validLoginSignal;
@property (nonatomic, strong, readwrite) RACCommand *loginCommand;
@property (nonatomic, strong, readwrite) RACCommand *browserLoginCommand;
@property (nonatomic, strong, readwrite) RACCommand *exchangeTokenCommand;
@end

@implementation MRCLLoginViewModel

- (void)initialize {
    [super initialize];
    
    @weakify(self)
    void (^doNext)(OCTClient *) = ^(OCTClient *authenticatedClient) {
        @strongify(self)
//        [[MRCMemoryCache sharedInstance] setObject:authenticatedClient.user forKey:@"currentUser"];
//
//        self.services.client = authenticatedClient;
//
//        [authenticatedClient.user mrc_saveOrUpdate];
//        [authenticatedClient.user mrc_updateRawLogin]; // The only place to update rawLogin, I hate the logic of rawLogin.
//
//        SSKeychain.rawLogin = authenticatedClient.user.rawLogin;
//        SSKeychain.password = self.password;
//        SSKeychain.accessToken = authenticatedClient.token;
//
//        MRCHomepageViewModel *viewModel = [[MRCHomepageViewModel alloc] initWithServices:self.services params:nil];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.services resetRootViewModel:viewModel];
//        });
    };
    
    self.loginCommand = [[RACCommand alloc] initWithSignalBlock:^(NSString *oneTimePassword) {
        @strongify(self)
        OCTUser *user = [OCTUser userWithRawLogin:self.username server:OCTServer.dotComServer];
        return [[OCTClient signInAsUser:user password:self.password oneTimePassword:oneTimePassword scopes:OCTClientAuthorizationScopesUser | OCTClientAuthorizationScopesRepository]
                doNext:doNext];
    }];
    
//    self.exchangeTokenCommand = [[RACCommand alloc] initWithSignalBlock:^(NSString *code) {
//        OCTClient *client = [[OCTClient alloc] initWithServer:[OCTServer dotComServer]];
//        return [[[[[client
//                    exchangeAccessTokenWithCode:code]
//                   doNext:^(OCTAccessToken *accessToken) {
//                       [client setValue:accessToken.token forKey:@"token"];
//                   }]
//                  flattenMap:^(id value) {
//                      return [[client
//                               fetchUserInfo]
//                              doNext:^(OCTUser *user) {
//                                  NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] init];
//
//                                  [mutableDictionary addEntriesFromDictionary:user.dictionaryValue];
//
//                                  if (user.rawLogin.length == 0) {
//                                      mutableDictionary[@keypath(user.rawLogin)] = user.login;
//                                  }
//
//                                  user = [OCTUser modelWithDictionary:mutableDictionary error:NULL];
//
//                                  [client setValue:user forKey:@"user"];
//                              }];
//                  }]
//                 mapReplace:client]
//                doNext:doNext];
//    }];
}

- (void)setUsername:(NSString *)username {
    _username = [username stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

@end
