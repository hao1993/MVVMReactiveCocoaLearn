//
//  MRCLRouter.m
//  MVVMReactiveCocoaLearn
//
//  Created by hao on 2018/11/9.
//  Copyright © 2018 hao. All rights reserved.
//

#import "MRCLRouter.h"

@interface MRCLRouter ()

@property (nonatomic, copy) NSDictionary *viewModelViewMappings; // viewModel到view的映射

@end

@implementation MRCLRouter

+ (instancetype)sharedInstance {
    static MRCLRouter *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (MRCLViewController *)viewControllerForViewModel:(MRCLViewModel *)viewModel {
    NSString *viewController = self.viewModelViewMappings[NSStringFromClass(viewModel.class)];
    
    NSParameterAssert([NSClassFromString(viewController) isSubclassOfClass:[MRCLViewController class]]);
    NSParameterAssert([NSClassFromString(viewController) instancesRespondToSelector:@selector(initWithViewModel:)]);
    
    return [[NSClassFromString(viewController) alloc] initWithViewModel:viewModel];
}

- (NSDictionary *)viewModelViewMappings {
    return @{
             @"MRCLLoginViewModel": @"MRCLLoginViewController",
             
             };
}

@end
