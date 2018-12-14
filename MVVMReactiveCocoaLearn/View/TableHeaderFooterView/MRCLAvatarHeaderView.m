//
//  MRCLAvatarHeaderView.m
//  MVVMReactiveCocoaLearn
//
//  Created by hao on 2018/12/14.
//  Copyright © 2018 hao. All rights reserved.
//

#import "MRCLAvatarHeaderView.h"
#import "MRCLAvatarHeaderModel.h"
#import "TGRImageZoomAnimationController.h"
#import "TGRImageViewController.h"
#import "MRCLUserListViewController.h"
#import "MRCLPublicReposViewController.h"

#define MRCAvatarHeaderViewContentOffsetRadix 40.0f

@interface MRCLAvatarHeaderView () <UIViewControllerTransitioningDelegate>
@property (weak, nonatomic) IBOutlet UIView *overView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;
@property (weak, nonatomic) IBOutlet UILabel *repositoriesLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingLabel;

@property (weak, nonatomic) IBOutlet UIButton *avatarButton;

@property (nonatomic, strong) UIImage *avatarImage;
@property (nonatomic, strong) MRCLAvatarHeaderModel *model;

@property (nonatomic, strong) GPUImageGaussianBlurFilter *gaussianBlurFilter;

@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIImageView *bluredCoverImageView;
@end

@implementation MRCLAvatarHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.avatarButton.imageView.layer.borderColor  = [UIColor whiteColor].CGColor;
    self.avatarButton.imageView.layer.borderWidth  = 2;
    self.avatarButton.imageView.layer.cornerRadius = CGRectGetWidth(self.avatarButton.frame) / 2;
    self.avatarButton.imageView.backgroundColor = HexRGB(0xEBE9E5);
    self.avatarButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.avatarImage = [UIImage imageNamed:@"defaultAvatar"];
}

- (void)bindModel:(MRCLAvatarHeaderModel *)model {
    self.model = model;
    
    @weakify(self);
    [RACObserve(self, avatarImage) subscribeNext:^(UIImage *avatarImage) {
        @strongify(self)
        [self.avatarButton setImage:avatarImage forState:UIControlStateNormal];
    }];
    
    // configure coverImageView
    self.coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, iPhoneX ? 323 + 24 : 323)];
    
    self.coverImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.coverImageView.clipsToBounds = YES;
    
    // configure bluredCoverImageView
    self.bluredCoverImageView = [[UIImageView alloc] initWithFrame:self.coverImageView.bounds];
    
    self.bluredCoverImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.bluredCoverImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.bluredCoverImageView.clipsToBounds = YES;
    
    [self.coverImageView addSubview:self.bluredCoverImageView];
    [self.overView insertSubview:self.coverImageView atIndex:0];
    
    self.gaussianBlurFilter = [[GPUImageGaussianBlurFilter alloc] init];
    self.gaussianBlurFilter.blurRadiusInPixels = 20;
    
    RAC(self.coverImageView, image) = RACObserve(self, avatarImage);
    
    RAC(self.bluredCoverImageView, image) = [RACObserve(self, avatarImage) map:^(UIImage *avatarImage) {
        @strongify(self)
        return [self.gaussianBlurFilter imageByFilteringImage:avatarImage];
    }];
    
    
    RAC(self.nameLabel, text) = RACObserve(self.model.user, login);
    
    NSString *(^toString)(NSNumber *) = ^(NSNumber *value) {
        NSString *text = value.stringValue;
        
        if (value.unsignedIntegerValue >= 1000) {
            text = [NSString stringWithFormat:@"%.1fk", value.unsignedIntegerValue / 1000.0];
        }
        
        return text;
    };
    
    RAC(self.repositoriesLabel, text) = [RACObserve(model.user, publicRepoCount) map:toString];
    RAC(self.followersLabel, text)    = [[RACObserve(model.user, followers) map:toString] deliverOnMainThread];
    RAC(self.followingLabel, text)    = [[RACObserve(model.user, following) map:toString] deliverOnMainThread];
    
    [[[RACObserve(self.model.user, avatarURL) ignore:nil] distinctUntilChanged] subscribeNext:^(NSURL *avatarURL) {
         [SDWebImageManager.sharedManager downloadImageWithURL:avatarURL
                                                       options:SDWebImageRefreshCached
                                                      progress:NULL
                                                     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                         @strongify(self)
                                                         if (image && finished) self.avatarImage = image;
                                                     }];
     }];
    
    [[self.avatarButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *avatarButton) {
         @strongify(self)
         MRCLSharedAppDelegate.window.backgroundColor = [UIColor blackColor];
         TGRImageViewController *viewController = [[TGRImageViewController alloc] initWithImage:[avatarButton imageForState:UIControlStateNormal]];
         viewController.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
         viewController.transitioningDelegate = self;
         [MRCLSharedAppDelegate.window.rootViewController presentViewController:viewController animated:YES completion:NULL];
     }];
    
    [[RACObserve(model, contentOffset)
      filter:^(id value) {
          return @([value CGPointValue].y <= 0).boolValue;
      }]
     subscribeNext:^(id x) {
         @strongify(self)
         
         CGPoint contentOffset = [x CGPointValue];
         
         self.coverImageView.frame = CGRectMake(0, 0 + contentOffset.y, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) + ABS(contentOffset.y) - 58);
         
         CGFloat diff  = MIN(ABS(contentOffset.y), MRCAvatarHeaderViewContentOffsetRadix);
         CGFloat scale = diff / MRCAvatarHeaderViewContentOffsetRadix;
         
         CGFloat alpha = 1 * (1 - scale);
         
         self.avatarButton.imageView.alpha = alpha;
         self.nameLabel.alpha = alpha;
//         self.operationButton.alpha = alpha;
         self.bluredCoverImageView.alpha = alpha;
     }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.overView addBottomBorderWithHeight:MRC_1PX_WIDTH andColor:HexRGB(colorB2)];
}

- (IBAction)followerViewAction:(id)sender {
    
}

- (IBAction)reposViewAction:(id)sender {
    MRCLPublicReposViewController *reposVC = [[MRCLPublicReposViewController alloc] init];
    reposVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:reposVC animated:YES];
}

- (IBAction)followingViewAction:(id)sender {
    MRCLUserListViewController *reposVC = [[MRCLUserListViewController alloc] init];
    reposVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:reposVC animated:YES];
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    if ([presented isKindOfClass:[TGRImageViewController class]]) {
        return [[TGRImageZoomAnimationController alloc] initWithReferenceImageView:self.avatarButton.imageView];
    }
    return nil;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    if ([dismissed isKindOfClass:[TGRImageViewController class]]) {
        return [[TGRImageZoomAnimationController alloc] initWithReferenceImageView:self.avatarButton.imageView];
    }
    return nil;
}

@end
