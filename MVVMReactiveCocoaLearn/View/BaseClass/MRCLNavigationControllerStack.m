//
//  MRCLNavigationControllerStack.m
//  MVVMReactiveCocoaLearn
//
//  Created by 杨世浩 on 2018/11/8.
//  Copyright © 2018 hao. All rights reserved.
//

#import "MRCLNavigationControllerStack.h"
#import "MRCLRouter.h"
#import "MRCLNavigationController.h"
#import "MRCLTabBarController.h"

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

- (void)pushNavigationController:(UINavigationController *)navigationController {
    if ([self.navigationControllers containsObject:navigationController]) return;
    navigationController.delegate = self;
    [self.navigationControllers addObject:navigationController];
}

- (UINavigationController *)popNavigationController {
    UINavigationController *navigationController = self.navigationControllers.lastObject;
    [self.navigationControllers removeLastObject];
    return navigationController;
}

- (UINavigationController *)topNavigationController {
    return self.navigationControllers.lastObject;
}

- (void)registerNavigationHooks {
    @weakify(self)
    
    [[(NSObject *)self.services
      rac_signalForSelector:@selector(resetRootViewModel:)]
     subscribeNext:^(RACTuple *tuple) {
         @strongify(self)
         [self.navigationControllers removeAllObjects];

         UIViewController *viewController = (UIViewController *)[MRCLRouter.sharedInstance viewControllerForViewModel:tuple.first];

         if (![viewController isKindOfClass:[UINavigationController class]] &&
             ![viewController isKindOfClass:[MRCLTabBarController class]]) {
             viewController = [[MRCLNavigationController alloc] initWithRootViewController:viewController];
             [self pushNavigationController:(UINavigationController *)viewController];
         }

         MRCLSharedAppDelegate.window.rootViewController = viewController;
         
     }];
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (IOS11) {
        viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:NULL];
    }
}

@end
