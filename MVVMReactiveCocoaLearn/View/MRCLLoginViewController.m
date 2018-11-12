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
@property (nonatomic, strong) UIView *userView;
@property (nonatomic, strong) UIImageView *userImageView;
@property (nonatomic, strong) UITextField *userTX;
@property (nonatomic, strong) UIView *passView;
@property (nonatomic, strong) UIImageView *passImageView;
@property (nonatomic, strong) UITextField *passTX;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong, readonly) MRCLLoginViewModel *viewModel;
@end

@implementation MRCLLoginViewController

#pragma mark - life cycle

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(223, 223, 223);
    [self.view addSubview:self.avatarButton];
    [self.view addSubview:self.userView];
    [self.view addSubview:self.passView];
    [self.view addSubview:self.loginButton];
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
        make.top.equalTo(self.view.mas_top).offset(90);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(85, 85));
    }];
    [self.userView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.avatarButton.mas_bottom).offset(50);
        make.height.equalTo(@(50));
    }];
    [self.userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userView.mas_left).offset(15);
        make.size.mas_equalTo(CGSizeMake(22, 22));
        make.centerY.equalTo(self.userView.mas_centerY);
    }];
    [self.userTX mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userImageView.mas_right).offset(10);
        make.right.equalTo(self.userView.mas_right).offset(-10);
        make.top.and.bottom.equalTo(self.userView);
    }];
    [self.passView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.userView.mas_bottom).offset(0.5);
        make.height.equalTo(@(50));
    }];
    [self.passImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.passView.mas_left).offset(15);
        make.size.mas_equalTo(CGSizeMake(22, 22));
        make.centerY.equalTo(self.passView.mas_centerY);
    }];
    [self.passTX mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.passImageView.mas_right).offset(10);
        make.right.equalTo(self.passView.mas_right).offset(-10);
        make.top.and.bottom.equalTo(self.passView);
    }];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.equalTo(@(45));
        make.top.equalTo(self.passView.mas_bottom).offset(30);
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

- (UIView *)userView {
    if (!_userView) {
        _userView = [[UIView alloc] init];
        _userView.backgroundColor = UIColor.whiteColor;
        
        [_userView addSubview:self.userImageView];
        [_userView addSubview:self.userTX];
    }
    return _userView;
}

- (UIImageView *)userImageView {
    if (!_userImageView) {
        _userImageView = [[UIImageView alloc] init];
        _userImageView.image = [UIImage octicon_imageWithIdentifier:@"Person" size:CGSizeMake(22, 22)];
    }
    return _userImageView;
}

- (UITextField *)userTX {
    if (!_userTX) {
        _userTX = [[UITextField alloc] init];
        _userTX.placeholder = @"Github username or email";
        _userTX.font = [UIFont systemFontOfSize:15];
    }
    return _userTX;
}

- (UIView *)passView {
    if (!_passView) {
        _passView = [[UIView alloc] init];
        _passView.backgroundColor = UIColor.whiteColor;
        
        [_passView addSubview:self.passImageView];
        [_passView addSubview:self.passTX];
    }
    return _passView;
}

- (UIImageView *)passImageView {
    if (!_passImageView) {
        _passImageView = [[UIImageView alloc] init];
        _passImageView.image = [UIImage octicon_imageWithIdentifier:@"Lock" size:CGSizeMake(22, 22)];
    }
    return _passImageView;
}

- (UITextField *)passTX {
    if (!_passTX) {
        _passTX = [[UITextField alloc] init];
        _passTX.placeholder = @"Github password";
        _passTX.font = [UIFont systemFontOfSize:15];
    }
    return _passTX;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginButton setTitle:@"Log In" forState:UIControlStateNormal];
        _loginButton.clipsToBounds = YES;
        _loginButton.layer.cornerRadius = 2.0f;
        _loginButton.backgroundColor = RGB(109, 127, 123);
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _loginButton;
}

@end
