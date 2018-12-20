//
//  MRCLOwnedReposViewModel.h
//  MVVMReactiveCocoaLearn
//
//  Created by hao on 2018/12/12.
//  Copyright © 2018 hao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MRCLOwnedReposViewModel : NSObject
@property (nonatomic, strong, readonly) RACCommand *requestRemoteDataCommand;
@property (nonatomic, strong, readonly) NSMutableArray *users;
@property (nonatomic, strong, readonly) NSArray *dataSource;

@property (nonatomic, assign) NSUInteger page;
@property (nonatomic, assign) NSUInteger perPage;

- (NSUInteger)offsetForPage:(NSUInteger)page;
@end

NS_ASSUME_NONNULL_END
