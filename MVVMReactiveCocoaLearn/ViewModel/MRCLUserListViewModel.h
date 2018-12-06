//
//  MRCLUserListViewModel.h
//  MVVMReactiveCocoaLearn
//
//  Created by hao on 2018/12/6.
//  Copyright © 2018 hao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MRCLUserListViewModel : NSObject

@property (nonatomic, strong, readonly) RACCommand *requestRemoteDataCommand;
@property (nonatomic, copy, readonly) NSArray *users;
@property (nonatomic, copy) NSArray *dataSource;

@end

NS_ASSUME_NONNULL_END
