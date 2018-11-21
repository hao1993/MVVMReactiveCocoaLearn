//
//  MRCLHomepageViewController.m
//  MVVMReactiveCocoaLearn
//
//  Created by hao on 2018/11/20.
//  Copyright © 2018 hao. All rights reserved.
//

#import "MRCLHomepageViewController.h"
#import "MRCLHomepageViewModel.h"
#import "MRCLNavigationController.h"
#import "MRCLNewsViewController.h"
#import "MRCLReposViewController.h"
#import "MRCLExploreViewController.h"
#import "MRCLProfileViewController.h"

@interface MRCLHomepageViewController ()
@property (nonatomic, strong) MRCLHomepageViewModel *viewModel;
@end

@implementation MRCLHomepageViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINavigationController *newsNavigationController = ({
        MRCLNewsViewController *newsViewController = [[MRCLNewsViewController alloc] initWithViewModel:self.viewModel.newsViewModel];
        
        UIImage *newsImage = [UIImage octicon_imageWithIcon:@"Rss"
                                            backgroundColor:[UIColor clearColor]
                                                  iconColor:[UIColor lightGrayColor]
                                                  iconScale:1
                                                    andSize:CGSizeMake(25, 25)];
        UIImage *newsHLImage = [UIImage octicon_imageWithIcon:@"Rss"
                                              backgroundColor:[UIColor clearColor]
                                                    iconColor:HexRGB(colorI3)
                                                    iconScale:1
                                                      andSize:CGSizeMake(25, 25)];
        
        newsViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"News" image:newsImage selectedImage:newsHLImage];
        
        [[MRCLNavigationController alloc] initWithRootViewController:newsViewController];
    });
    
    UINavigationController *reposNavigationController = ({
        MRCLReposViewController *reposViewController = [[MRCLReposViewController alloc] initWithViewModel:self.viewModel.reposViewModel];
        
        UIImage *reposImage = [UIImage octicon_imageWithIcon:@"Repo"
                                             backgroundColor:[UIColor clearColor]
                                                   iconColor:[UIColor lightGrayColor]
                                                   iconScale:1
                                                     andSize:CGSizeMake(25, 25)];
        UIImage *reposHLImage = [UIImage octicon_imageWithIcon:@"Repo"
                                               backgroundColor:[UIColor clearColor]
                                                     iconColor:HexRGB(colorI3)
                                                     iconScale:1
                                                       andSize:CGSizeMake(25, 25)];
        
        reposViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Repositories" image:reposImage selectedImage:reposHLImage];
        
        [[MRCLNavigationController alloc] initWithRootViewController:reposViewController];
    });
    
    UINavigationController *exploreNavigationController = ({
        MRCLExploreViewController *exploreViewController = [[MRCLExploreViewController alloc] initWithViewModel:self.viewModel.exploreViewModel];
        
        UIImage *exploreImage = [UIImage octicon_imageWithIcon:@"Search"
                                               backgroundColor:[UIColor clearColor]
                                                     iconColor:[UIColor lightGrayColor]
                                                     iconScale:1
                                                       andSize:CGSizeMake(25, 25)];
        UIImage *exploreHLImage = [UIImage octicon_imageWithIcon:@"Search"
                                                 backgroundColor:[UIColor clearColor]
                                                       iconColor:HexRGB(colorI3)
                                                       iconScale:1
                                                         andSize:CGSizeMake(25, 25)];
        
        exploreViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Explore" image:exploreImage selectedImage:exploreHLImage];
        
        [[MRCLNavigationController alloc] initWithRootViewController:exploreViewController];
    });
    
    UINavigationController *profileNavigationController = ({
        MRCLProfileViewController *profileViewController = [[MRCLProfileViewController alloc] initWithViewModel:self.viewModel.profileViewModel];
        
        UIImage *profileImage = [UIImage octicon_imageWithIcon:@"Person"
                                               backgroundColor:[UIColor clearColor]
                                                     iconColor:[UIColor lightGrayColor]
                                                     iconScale:1
                                                       andSize:CGSizeMake(25, 25)];
        UIImage *profileHLImage = [UIImage octicon_imageWithIcon:@"Person"
                                                 backgroundColor:[UIColor clearColor]
                                                       iconColor:HexRGB(colorI3)
                                                       iconScale:1
                                                         andSize:CGSizeMake(25, 25)];
        
        profileViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Profile" image:profileImage selectedImage:profileHLImage];
        
        [[MRCLNavigationController alloc] initWithRootViewController:profileViewController];
    });
    
    self.tabBarController.viewControllers = @[newsNavigationController, reposNavigationController, exploreNavigationController, profileNavigationController];
    
    [MRCLSharedAppDelegate.navigationControllerStack pushNavigationController:newsNavigationController];
    
    [[self rac_signalForSelector:@selector(tabBarController:didSelectViewController:) fromProtocol:@protocol(UITabBarControllerDelegate)] subscribeNext:^(RACTuple *tuple) {
        [MRCLSharedAppDelegate.navigationControllerStack popNavigationController];
        [MRCLSharedAppDelegate.navigationControllerStack pushNavigationController:tuple.second];
    }];
    self.tabBarController.delegate = self;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if (self.tabBarController.selectedViewController == viewController) {
        UINavigationController *navigationController = (UINavigationController *)self.tabBarController.selectedViewController;
        UIViewController *viewController = navigationController.topViewController;
        if ([viewController isKindOfClass:[MRCLNewsViewController class]]) {
            MRCLNewsViewController *newsViewController = (MRCLNewsViewController *)viewController;
            [newsViewController refresh];
        }
    }
    return YES;
}

@end
