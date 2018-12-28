//
//  MRCLPublicReposViewController.m
//  MVVMReactiveCocoaLearn
//
//  Created by hao on 2018/11/29.
//  Copyright © 2018 hao. All rights reserved.
//

#import "MRCLPublicReposViewController.h"
#import "MRCLOwnedReposViewModel.h"
#import "MRCLReposCell.h"

@interface MRCLPublicReposViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MRCLOwnedReposViewModel *viewModel;
@end

@implementation MRCLPublicReposViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MRCLReposCell" bundle:nil] forCellReuseIdentifier:@"ReposCell"];
    [self bindViewModel];
}

- (void)bindViewModel {
    self.viewModel = [[MRCLOwnedReposViewModel alloc] init];
    [self.viewModel.requestRemoteDataCommand execute:@1];
    
    @weakify(self);
    [[[[RACObserve(self.viewModel, dataSource) skip:1] distinctUntilChanged] deliverOnMainThread] subscribeNext:^(id x) {
        @strongify(self);
        if (self.viewModel.dataSource.count > 10 && self.viewModel.dataSource.count < MRCL_MAX_PERPAGE) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        } else if (self.viewModel.dataSource.count == MRCL_MAX_PERPAGE) {
            self.tableView.mj_footer.hidden = NO;
        }
        [self.tableView reloadData];
    }];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.5f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MRCLReposCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReposCell" forIndexPath:indexPath];
    [cell bindModel:self.viewModel.dataSource[indexPath.row]];
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
        @weakify(self);
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVITETION_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVITETION_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self);
            [[[self.viewModel.requestRemoteDataCommand execute:@1] deliverOnMainThread] subscribeNext:^(NSArray *users) {
                
            } error:^(NSError *error) {
                @strongify(self);
                [self.tableView.mj_header endRefreshing];
            } completed:^{
                @strongify(self);
                [self.tableView.mj_header endRefreshing];
            }];
        }];
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            self.viewModel.page += 1;
            [[[self.viewModel.requestRemoteDataCommand execute:@(self.viewModel.page)] deliverOnMainThread] subscribeNext:^(NSArray *users) {
                if (users.count < MRCL_MAX_PERPAGE) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [self.tableView.mj_footer endRefreshing];
                }
            } error:^(NSError *error) {
                @strongify(self);
                [self.tableView.mj_footer endRefreshing];
            } completed:^{
                
            }];
        }];
        _tableView.mj_footer.hidden = YES;
    }
    return _tableView;
}

@end
