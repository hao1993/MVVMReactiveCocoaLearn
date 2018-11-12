//
//  MRCLLoginViewController.m
//  MVVMReactiveCocoaLearn
//
//  Created by hao on 2018/11/9.
//  Copyright © 2018 hao. All rights reserved.
//

#import "MRCLLoginViewController.h"
#import "MRCLLoginViewModel.h"
#import "TGRImageViewController.h"
#import "TGRImageZoomAnimationController.h"

@interface MRCLLoginViewController () <UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) UIButton *avatarButton;
@property (nonatomic, strong, readonly) MRCLLoginViewModel *viewModel;
@end

@implementation MRCLLoginViewController

#pragma mark - life cycle

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(223, 223, 223);
    NSLog(@"loginVC");
    [self.view addSubview:self.avatarButton];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self setUpContrains];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    if ([presented isKindOfClass:TGRImageViewController.class]) {
        return [[TGRImageZoomAnimationController alloc] initWithReferenceImageView:self.avatarButton.imageView];
    }
    return nil;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    if ([dismissed isKindOfClass:TGRImageViewController.class]) {
        return [[TGRImageZoomAnimationController alloc] initWithReferenceImageView:self.avatarButton.imageView];
    }
    return nil;
}

#pragma mark - event response

#pragma mark - private methods

- (void)bindViewModel {
    [super bindViewModel];
    
    @weakify(self)
    [RACObserve(self.viewModel, avatarURL) subscribeNext:^(NSURL *avatarURL) {
        @strongify(self)
        [self.avatarButton sd_setImageWithURL:avatarURL forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default-avatar"]];
    }];
    [[self.avatarButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *avatarButton) {
        @strongify(self);
        MRCLSharedAppDelegate.window.backgroundColor = [UIColor blackColor];
        TGRImageViewController *viewController = [[TGRImageViewController alloc] initWithImage:[avatarButton imageForState:UIControlStateNormal]];
        
        viewController.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        viewController.transitioningDelegate = self;
        
        [self presentViewController:viewController animated:YES completion:NULL];
    }];
}

- (void)setUpContrains {
    [self.avatarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(100);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
}

#pragma mark - getters and setters

- (UIButton *)avatarButton {
    if (!_avatarButton) {
        _avatarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _avatarButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _avatarButton.layer.borderWidth = 2.0f;
        _avatarButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _avatarButton;
}

@end
