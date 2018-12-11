//
//  MRCLUserListCell.m
//  MVVMReactiveCocoaLearn
//
//  Created by hao on 2018/12/10.
//  Copyright © 2018 hao. All rights reserved.
//

#import "MRCLUserListCell.h"
#import "MRCLFollowButton.h"
#import "MRCLUserListItemModel.h"

@interface MRCLUserListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet MRCLFollowButton *operationButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UILabel *loginLabel;
@property (weak, nonatomic) IBOutlet UILabel *htmlLabel;
@property (strong, nonatomic) MRCLUserListItemModel *model;
@end

@implementation MRCLUserListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.avatarImageView.backgroundColor = HexRGB(colorI6);
    RACSignal *operationCommandSignal = RACObserve(self, model.operationCommand);
    RACSignal *followingStatusSignal  = RACObserve(self, model.user.followingStatus).deliverOnMainThread;

    RACSignal *combinedSignal = [RACSignal combineLatest:@[ operationCommandSignal, followingStatusSignal]];
    
    RAC(self.activityIndicatorView, hidden) = [combinedSignal reduceEach:^(RACCommand *operationCommand, NSNumber *followingStatus) {
        if (operationCommand == nil) return @YES;
        if (followingStatus.unsignedIntegerValue != OCTUserFollowingStatusUnknown) return @YES;
        return @NO;
    }];
    
    RAC(self.operationButton, hidden) = [combinedSignal reduceEach:^(RACCommand *operationCommand, NSNumber *followingStatus) {
        if (operationCommand == nil) return @YES;
        if (followingStatus.unsignedIntegerValue == OCTUserFollowingStatusUnknown) return @YES;
        return @NO;
    }];
    
    RAC(self.operationButton, selected) = [followingStatusSignal map:^(NSNumber *followingStatus) {
        return followingStatus.unsignedIntegerValue == OCTUserFollowingStatusYES ? @YES : @NO;
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)bindModel:(MRCLUserListItemModel *)model {
    self.model = model;
    [self.avatarImageView sd_setImageWithURL:model.avatarURL];
    
    self.loginLabel.text = model.login;
    self.htmlLabel.text  = model.user.HTMLURL.absoluteString;
    
    if (!self.activityIndicatorView.isAnimating) {
        [self.activityIndicatorView startAnimating];
    }
}

- (IBAction)operationButtonAction:(id)sender {
    self.operationButton.enabled = NO;
    
    @weakify(self);
    [[[self.model.operationCommand execute:self.model] deliverOnMainThread] subscribeCompleted:^{
        @strongify(self);
        self.operationButton.enabled = YES;
    }];
}

@end
