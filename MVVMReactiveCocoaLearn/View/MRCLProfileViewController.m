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
#import "MRCLAvatarHeaderView.h"
#import "MRCLAvatarHeaderModel.h"
#import "MRCLProfileViewModel.h"

@interface MRCLProfileViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MRCLAvatarHeaderView *avatarView;
@property (nonatomic, strong) MRCLProfileViewModel *viewModel;
@end

@implementation MRCLProfileViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    self.viewModel = [[MRCLProfileViewModel alloc] init];
    
    self.avatarView = [[NSBundle mainBundle] loadNibNamed:@"MRCLAvatarHeaderView" owner:nil options:nil].firstObject;
    self.avatarView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 381);
    [self.avatarView bindModel:self.viewModel.avatarHeaderModel];
    
    self.tableView.tableHeaderView = self.avatarView;
    
    @weakify(self);
    [[self.avatarView.followerViewGesture rac_gestureSignal] subscribeNext:^(id x) {
        NSLog(@"%s", __func__);
    }];
    [[self.avatarView.reposityViewGesture rac_gestureSignal] subscribeNext:^(id x) {
        @strongify(self);
        MRCLPublicReposViewController *reposVC = [[MRCLPublicReposViewController alloc] init];
        reposVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:reposVC animated:YES];
    }];
    [[self.avatarView.followingViewGesture rac_gestureSignal] subscribeNext:^(id x) {
        @strongify(self);
        MRCLUserListViewController *reposVC = [[MRCLUserListViewController alloc] init];
        reposVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:reposVC animated:YES];
    }];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint contentOffset = CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y);
    self.viewModel.avatarHeaderModel.contentOffset = contentOffset;
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 4 : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return (section == tableView.numberOfSections - 1) ? 20 : 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellStr = @"profileCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellStr];
    }
    cell.accessoryType  = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.imageView.image = [UIImage octicon_imageWithIcon:@"Organization"
                                                  backgroundColor:UIColor.clearColor
                                                        iconColor:HexRGB(0x24AFFC)
                                                        iconScale:1
                                                          andSize:MRC_LEFT_IMAGE_SIZE];
            cell.textLabel.text = self.viewModel.company;
        } else if (indexPath.row == 1) {
            cell.imageView.image = [UIImage octicon_imageWithIcon:@"Location"
                                                  backgroundColor:UIColor.clearColor
                                                        iconColor:HexRGB(0x30C931)
                                                        iconScale:1
                                                          andSize:MRC_LEFT_IMAGE_SIZE];
            cell.textLabel.text = self.viewModel.location;
        } else if (indexPath.row == 2) {
            cell.imageView.image = [UIImage octicon_imageWithIcon:@"Mail"
                                                  backgroundColor:UIColor.clearColor
                                                        iconColor:HexRGB(0x5586ED)
                                                        iconScale:1
                                                          andSize:MRC_LEFT_IMAGE_SIZE];
            cell.textLabel.text = self.viewModel.email;
            
            if (![self.viewModel.email isEqualToString:MRC_EMPTY_PLACEHOLDER]) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        } else if (indexPath.row == 3) {
            cell.imageView.image = [UIImage octicon_imageWithIcon:@"Link"
                                                  backgroundColor:UIColor.clearColor
                                                        iconColor:HexRGB(0x90DD2F)
                                                        iconScale:1
                                                          andSize:MRC_LEFT_IMAGE_SIZE];
            cell.textLabel.text = self.viewModel.blog;
            
            if (![self.viewModel.blog isEqualToString:MRC_EMPTY_PLACEHOLDER]) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            }
        }
    } else if (indexPath.section == 1) {
        cell.imageView.image = [UIImage octicon_imageWithIcon:@"Gear"
                                              backgroundColor:UIColor.clearColor
                                                    iconColor:HexRGB(0x24AFFC)
                                                    iconScale:1
                                                      andSize:MRC_LEFT_IMAGE_SIZE];
        cell.textLabel.text = @"Settings";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

#pragma mark - CustomDelegate

#pragma mark - event response

#pragma mark - private methods

#pragma mark - getters and setters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = HexRGB(0xf1eef6);
    }
    return _tableView;
}


@end
