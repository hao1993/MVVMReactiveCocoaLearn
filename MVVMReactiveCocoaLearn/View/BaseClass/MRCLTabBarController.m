//
//  MRCLTabBarController.m
//  MVVMReactiveCocoaLearn
//
//  Created by hao on 2018/11/9.
//  Copyright © 2018 hao. All rights reserved.
//

#import "MRCLTabBarController.h"

@interface MRCLTabBarController ()

@property (nonatomic, strong, readwrite) UITabBarController *tabBarController;

@end

@implementation MRCLTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBarController = [[UITabBarController alloc] init];
    
    [self addChildViewController:self.tabBarController];
    [self.view addSubview:self.tabBarController.view];
}

- (BOOL)shouldAutorotate {
    return self.tabBarController.selectedViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.tabBarController.selectedViewController.supportedInterfaceOrientations;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.tabBarController.selectedViewController.preferredStatusBarStyle;
}

@end
