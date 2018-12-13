//
//  MRCLOwnedReposItemModel.h
//  MVVMReactiveCocoaLearn
//
//  Created by hao on 2018/12/12.
//  Copyright © 2018 hao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MRCLOwnedReposItemModel : NSObject

@property (nonatomic, strong, readonly) OCTRepository *repository;

@property (nonatomic, copy, readonly) NSAttributedString *name;
@property (nonatomic, copy, readonly) NSAttributedString *repoDescription;
@property (nonatomic, copy, readonly) NSString *updateTime;
@property (nonatomic, copy, readonly) NSString *language;

@property (nonatomic, assign, readonly) CGFloat height;
//@property (nonatomic, assign, readonly) MRCReposViewModelOptions options;

- (instancetype)initWithRepository:(OCTRepository *)repository; //options:(MRCReposViewModelOptions)options;

@end

NS_ASSUME_NONNULL_END
