//
//  MRCLNavigationControllerStack.m
//  MVVMReactiveCocoaLearn
//
//  Created by 杨世浩 on 2018/11/8.
//  Copyright © 2018 hao. All rights reserved.
//

#import "MRCLNavigationControllerStack.h"

@interface MRCLNavigationControllerStack () <UINavigationControllerDelegate>
@property (nonatomic, strong) id<MRCLViewModelServices> services;
@property (nonatomic, strong) NSMutableArray *navigationControllers;
@end

@implementation MRCLNavigationControllerStack

- (instancetype)initWithServices:(id<MRCLViewModelServices>)services {
    self = [super init];
    if (self) {
        self.services = services;
        self.navigationControllers = [[NSMutableArray alloc] init];
        [self registerNavigationHooks];
    }
    return self;
}

- (void)registerNavigationHooks {

}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (IOS11) {
        viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:NULL];
    }
}

@end
