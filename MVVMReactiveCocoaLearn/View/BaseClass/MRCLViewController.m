//
//  MRCLViewController.m
//  MVVMReactiveCocoaLearn
//
//  Created by hao on 2018/11/9.
//  Copyright © 2018 hao. All rights reserved.
//

#import "MRCLViewController.h"
#import "MRCLDoubleTitleView.h"
#import "MRCLLoginViewModel.h"

@interface MRCLViewController () <UIGestureRecognizerDelegate>
@property (nonatomic, strong, readwrite) MRCLViewModel *viewModel;
@property (nonatomic, strong, readwrite) UIPercentDrivenInteractiveTransition *interactivePopTransition;
@end

@implementation MRCLViewController

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    MRCLViewController *viewController = [super allocWithZone:zone];
    
    @weakify(viewController)
    [[viewController
      rac_signalForSelector:@selector(viewDidLoad)]
     subscribeNext:^(id x) {
         @strongify(viewController)
         [viewController bindViewModel];
     }];
    
    return viewController;
}

- (MRCLViewController *)initWithViewModel:(id)viewModel {
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    if (self.navigationController != nil && self != self.navigationController.viewControllers.firstObject) {
        UIPanGestureRecognizer *popRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePopRecognizer:)];
        [self.view addGestureRecognizer:popRecognizer];
        popRecognizer.delegate = self;
    }
}

- (void)bindViewModel {
    // System title view
    RAC(self, title) = RACObserve(self.viewModel, title);
    
    UIView *titleView = self.navigationItem.titleView;
    
    // Double title view
    MRCLDoubleTitleView *doubleTitleView = [[MRCLDoubleTitleView alloc] init];
    
    RAC(doubleTitleView.titleLabel, text)    = RACObserve(self.viewModel, title);
    RAC(doubleTitleView.subtitleLabel, text) = RACObserve(self.viewModel, subtitle);
    
    @weakify(self)
    [[self
      rac_signalForSelector:@selector(viewWillTransitionToSize:withTransitionCoordinator:)]
     subscribeNext:^(id x) {
         @strongify(self)
         doubleTitleView.titleLabel.text    = self.viewModel.title;
         doubleTitleView.subtitleLabel.text = self.viewModel.subtitle;
     }];
    
    // Loading title view
//    MRCLoadingTitleView *loadingTitleView = [[NSBundle mainBundle] loadNibNamed:@"MRCLoadingTitleView" owner:nil options:nil].firstObject;
//    loadingTitleView.frame = CGRectMake((SCREEN_WIDTH - CGRectGetWidth(loadingTitleView.frame)) / 2.0, 0, CGRectGetWidth(loadingTitleView.frame), CGRectGetHeight(loadingTitleView.frame));
    
    RAC(self.navigationItem, titleView) = [RACObserve(self.viewModel, titleViewType).distinctUntilChanged map:^(NSNumber *value) {
        MRCLTitleViewType titleViewType = value.unsignedIntegerValue;
        switch (titleViewType) {
            case MRCLTitleViewTypeDefault:
                return titleView;
            case MRCLTitleViewTypeDoubleTitle:
                return (UIView *)doubleTitleView;
            case MRCLTitleViewTypeLoadingTitle:
                return [[UIView alloc] init];//(UIView *)loadingTitleView;
        }
    }];
    
    [self.viewModel.errors subscribeNext:^(NSError *error) {
        @strongify(self)
        
        MRCLogError(error);
        
        if ([error.domain isEqual:OCTClientErrorDomain] && error.code == OCTClientErrorAuthenticationFailed) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:MRC_ALERT_TITLE
                                                                                     message:@"Your authorization has expired, please login again"
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                @strongify(self)
//                [SSKeychain deleteAccessToken];
                
                MRCLLoginViewModel *loginViewModel = [[MRCLLoginViewModel alloc] initWithServices:self.viewModel.services params:nil];
                [self.viewModel.services resetRootViewModel:loginViewModel];
            }]];
            
            [self presentViewController:alertController animated:YES completion:NULL];
        } else if (error.code != OCTClientErrorTwoFactorAuthenticationOneTimePasswordRequired && error.code != OCTClientErrorConnectionFailed) {
            MRCError(error.localizedDescription);
        }
    }];
    
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [UIDevice currentDevice].isPad ? UIInterfaceOrientationMaskAll : UIInterfaceOrientationMaskPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - UIPanGestureRecognizer handlers

- (void)handlePopRecognizer:(UIPanGestureRecognizer *)recognizer {
    CGFloat progress = [recognizer translationInView:self.view].x / CGRectGetWidth(self.view.frame);
    progress = MIN(1.0, MAX(0.0, progress));
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        // Create a interactive transition and pop the view controller
        self.interactivePopTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        [self.navigationController popViewControllerAnimated:YES];
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        // Update the interactive transition's progress
        [self.interactivePopTransition updateInteractiveTransition:progress];
    } else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
        // Finish or cancel the interactive transition
        if (progress > 0.2) {
            [self.interactivePopTransition finishInteractiveTransition];
        } else {
            [self.interactivePopTransition cancelInteractiveTransition];
        }
        
        self.interactivePopTransition = nil;
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)recognizer {
    return [recognizer velocityInView:self.view].x > 0;
}

@end
