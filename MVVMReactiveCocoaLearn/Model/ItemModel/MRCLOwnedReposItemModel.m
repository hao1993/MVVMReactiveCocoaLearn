//
//  MRCLOwnedReposItemModel.m
//  MVVMReactiveCocoaLearn
//
//  Created by hao on 2018/12/12.
//  Copyright © 2018 hao. All rights reserved.
//

#import "MRCLOwnedReposItemModel.h"
#import <FormatterKit/TTTTimeIntervalFormatter.h>

@interface MRCLOwnedReposItemModel ()
@property (nonatomic, strong, readwrite) OCTRepository *repository;

@property (nonatomic, copy, readwrite) NSAttributedString *name;
@property (nonatomic, copy, readwrite) NSAttributedString *repoDescription;
@property (nonatomic, copy, readwrite) NSString *updateTime;
@property (nonatomic, copy, readwrite) NSString *language;

@property (nonatomic, assign, readwrite) CGFloat height;
//@property (nonatomic, assign, readwrite) MRCReposViewModelOptions options;

@end

@implementation MRCLOwnedReposItemModel

- (instancetype)initWithRepository:(OCTRepository *)repository {
    if (self == [super init]) {
        self.repository = repository;
        
//        self.options = options;
        
        self.language = repository.language ?: @"";
        self.name = [[NSAttributedString alloc] initWithString:self.repository.name].copy;
        
        TTTTimeIntervalFormatter *timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc] init];
        timeIntervalFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        self.updateTime = [timeIntervalFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:repository.dateUpdated];
        
        CGFloat height = 0;
        if (self.repository.repoDescription.length > 0) {
            NSDictionary *attributes = @{ NSFontAttributeName: [UIFont systemFontOfSize:15.0] };
            
            CGFloat width = SCREEN_WIDTH - 38 - 8;
//            if (self.options & MRCReposViewModelOptionsSectionIndex) {
//                width -= 15;
//            }
            
            CGRect rect = [self.repository.repoDescription boundingRectWithSize:CGSizeMake(width, 0)
                                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                                     attributes:attributes
                                                                        context:nil];
            height = MIN(ceil(rect.size.height), 18 * 3);
        }
        self.height = 8 + 21 + 5 + height + 5 + 15 + 8 + 1;
    }
    return self;
}

@end
