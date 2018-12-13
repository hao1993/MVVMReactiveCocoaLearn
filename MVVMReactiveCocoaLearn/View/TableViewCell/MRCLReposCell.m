//
//  MRCLReposCell.m
//  MVVMReactiveCocoaLearn
//
//  Created by hao on 2018/12/13.
//  Copyright © 2018 hao. All rights reserved.
//

#import "MRCLReposCell.h"
#import "MRCLOwnedReposViewModel.h"
#import "MRCLOwnedReposItemModel.h"

static UIImage *_repoIcon = nil;
static UIImage *_repoForkedIcon = nil;
static UIImage *_lockIcon = nil;

static UIImage *_starIcon = nil;
static UIImage *_gitBranchIcon = nil;
static UIImage *_tintedStarIcon = nil;

@interface MRCLReposCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *updateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *languageLabel;
@property (weak, nonatomic) IBOutlet UILabel *starCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *forkCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *starIconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *forkIconImageView;
@property (strong, nonatomic) MRCLOwnedReposItemModel *model;
@end

@implementation MRCLReposCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _repoIcon = [UIImage octicon_imageWithIdentifier:@"Repo" size:self.iconImageView.frame.size];
        _repoForkedIcon = [UIImage octicon_imageWithIdentifier:@"RepoForked" size:self.iconImageView.frame.size];
        _lockIcon = [UIImage octicon_imageWithIcon:@"Lock"
                                   backgroundColor:[UIColor clearColor]
                                         iconColor:HexRGB(colorI4)
                                         iconScale:1
                                           andSize:self.iconImageView.frame.size];
        
        _starIcon = [UIImage octicon_imageWithIdentifier:@"Star" size:self.starIconImageView.frame.size];
        _gitBranchIcon = [UIImage octicon_imageWithIdentifier:@"GitBranch" size:self.forkIconImageView.frame.size];
//        _tintedStarIcon = [_starIcon rt_tintedImageWithColor:HexRGB(colorI5)];
    });
    
    self.forkIconImageView.image = _gitBranchIcon;
    self.starIconImageView.image = _starIcon;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)bindModel:(MRCLOwnedReposItemModel *)model {
    self.model = model;
    self.nameLabel.attributedText = self.model.name;
    self.languageLabel.text  = model.language;
    self.desLabel.text = model.repository.repoDescription;
    self.forkCountLabel.text = @(model.repository.forksCount).stringValue;
    self.starCountLabel.text = @(model.repository.stargazersCount).stringValue;
    self.updateTimeLabel.text = self.model.updateTime;
    
    if (model.repository.isPrivate) {
        self.iconImageView.image = _lockIcon;
    } else if (model.repository.isFork) {
        self.iconImageView.image = _repoForkedIcon;
    } else {
        self.iconImageView.image = _repoIcon;
    }
    
}

@end
