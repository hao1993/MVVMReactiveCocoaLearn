//
//  MRCLAppStoreServiceImpl.m
//  MVVMReactiveCocoaLearn
//
//  Created by 杨世浩 on 2018/11/8.
//  Copyright © 2018 hao. All rights reserved.
//

#import "MRCLAppStoreServiceImpl.h"

@implementation MRCLAppStoreServiceImpl

- (RACSignal *)requestAppInfoFromAppStoreWithAppID:(NSString *)appID {
    return [[[RACSignal
              createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                  MKNetworkEngine *networkEngine = [[MKNetworkEngine alloc] initWithHostName:@"itunes.apple.com"];

                  MKNetworkOperation *operation = [networkEngine operationWithPath:@"lookup"
                                                                            params:@{ @"id": appID }
                                                                        httpMethod:@"GET"];

                  [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
                      [subscriber sendNext:completedOperation.responseJSON];
                      [subscriber sendCompleted];
                  } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
                      [subscriber sendError:error];
                  }];

                  [networkEngine enqueueOperation:operation];

                  return [RACDisposable disposableWithBlock:^{
                      [operation cancel];
                  }];
              }]
             replayLazily]
            setNameWithFormat:@"-requestAppInfoFromAppStoreWithAppID: %@", appID];
}

@end

