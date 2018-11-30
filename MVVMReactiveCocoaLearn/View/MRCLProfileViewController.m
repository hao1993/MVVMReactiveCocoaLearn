//
//  MRCLProfileViewController.m
//  MVVMReactiveCocoaLearn
//
//  Created by hao on 2018/11/21.
//  Copyright © 2018 hao. All rights reserved.
//

#import "MRCLProfileViewController.h"
#import "MRCLPublicReposViewController.h"
#import "MRCLUserListViewController.h"

@interface MRCLProfileViewController ()

@end

@implementation MRCLProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *reposityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    reposityButton.frame = CGRectMake(100, 100, 200, 100);
    reposityButton.backgroundColor = [UIColor clearColor];
    [reposityButton setTitle:@"repositories" forState:UIControlStateNormal];
    [reposityButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:reposityButton];
    
    @weakify(self);
    [[reposityButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        MRCLPublicReposViewController *reposVC = [[MRCLPublicReposViewController alloc] init];
        reposVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:reposVC animated:YES];
    }];
    
    UIButton *followButton = [UIButton buttonWithType:UIButtonTypeCustom];
    followButton.frame = CGRectMake(100, 200, 200, 100);
    followButton.backgroundColor = [UIColor clearColor];
    [followButton setTitle:@"following" forState:UIControlStateNormal];
    [followButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:followButton];
    
    [[followButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        MRCLUserListViewController *reposVC = [[MRCLUserListViewController alloc] init];
        reposVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:reposVC animated:YES];
    }];
}



@end
