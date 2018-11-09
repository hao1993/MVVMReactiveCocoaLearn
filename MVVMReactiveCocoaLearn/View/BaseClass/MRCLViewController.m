//
//  MRCLViewController.m
//  MVVMReactiveCocoaLearn
//
//  Created by hao on 2018/11/9.
//  Copyright © 2018 hao. All rights reserved.
//

#import "MRCLViewController.h"

@interface MRCLViewController ()
@property (nonatomic, strong, readwrite) MRCLViewModel *viewModel;
@end

@implementation MRCLViewController

- (MRCLViewController *)initWithViewModel:(id)viewModel {
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

@end
