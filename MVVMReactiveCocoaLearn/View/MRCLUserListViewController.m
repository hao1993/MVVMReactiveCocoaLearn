//
//  MRCLUserListViewController.m
//  MVVMReactiveCocoaLearn
//
//  Created by hao on 2018/11/30.
//  Copyright © 2018 hao. All rights reserved.
//

#import "MRCLUserListViewController.h"
#import "MRCLUserListViewModel.h"
#import "MRCLUserListCell.h"

@interface MRCLUserListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MRCLUserListViewModel *viewModel;
@end

@implementation MRCLUserListViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    [self bindViewModel];
    [self.tableView registerNib:[UINib nibWithNibName:@"MRCLUserListCell" bundle:nil] forCellReuseIdentifier:@"UserListCell"];

}

- (void)bindViewModel {
    self.viewModel = [[MRCLUserListViewModel alloc] init];
    [self.viewModel.requestRemoteDataCommand execute:@1];
    
    @weakify(self)
    [[[RACObserve(self.viewModel, dataSource) distinctUntilChanged] deliverOnMainThread] subscribeNext:^(id x) {
         @strongify(self)
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
    return 75;
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
    MRCLUserListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserListCell" forIndexPath:indexPath];
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
            self.viewModel.page = 1;
            [[[self.viewModel.requestRemoteDataCommand execute:@(self.viewModel.page)] deliverOnMainThread] subscribeNext:^(id x) {
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
            [[[self.viewModel.requestRemoteDataCommand execute:@(self.viewModel.page)] deliverOnMainThread] subscribeNext:^(id x) {
                
            } error:^(NSError *error) {
                @strongify(self);
                [self.tableView.mj_footer endRefreshing];
            } completed:^{
                @strongify(self);
                [self.tableView.mj_footer endRefreshing];
            }];
        }];
    }
    return _tableView;
}

@end
