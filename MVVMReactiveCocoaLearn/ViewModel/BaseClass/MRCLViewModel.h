//
//  MRCLViewModel.h
//  MVVMReactiveCocoaLearn
//
//  Created by 杨世浩 on 2018/11/8.
//  Copyright © 2018 hao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MRCLViewModelServices;

/// The type of the title view.
typedef NS_ENUM(NSUInteger, MRCLTitleViewType) {
    /// System title view
    MRCLTitleViewTypeDefault,
    /// Double title view
    MRCLTitleViewTypeDoubleTitle,
    /// Loading title view
    MRCLTitleViewTypeLoadingTitle
};

@interface MRCLViewModel : NSObject

/// Initialization method. This is the preferred way to create a new view model.
///
/// services - The service bus of the `Model` layer.
/// params   - The parameters to be passed to view model.
///
/// Returns a new view model.
- (instancetype)initWithServices:(id<MRCLViewModelServices>)services params:(NSDictionary *)params;

/// The `services` parameter in `-initWithServices:params:` method.
@property (nonatomic, strong, readonly) id<MRCLViewModelServices> services;

/// The `params` parameter in `-initWithServices:params:` method.
@property (nonatomic, copy, readonly) NSDictionary *params;

@property (nonatomic, assign) MRCLTitleViewType titleViewType;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

/// The callback block.
@property (nonatomic, copy) VoidBlock_id callback;

/// A RACSubject object, which representing all errors occurred in view model.
@property (nonatomic, strong, readonly) RACSubject *errors;

@property (nonatomic, assign) BOOL shouldFetchLocalDataOnViewModelInitialize;
@property (nonatomic, assign) BOOL shouldRequestRemoteDataOnViewDidLoad;

@property (nonatomic, strong, readonly) RACSubject *willDisappearSignal;

/// An additional method, in which you can initialize data, RACCommand etc.
///
/// This method will be execute after the execution of `-initWithServices:params:` method. But
/// the premise is that you need to inherit `MRCViewModel`.
- (void)initialize;

@end

NS_ASSUME_NONNULL_END
