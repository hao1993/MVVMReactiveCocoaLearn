//
//  MRCLReactiveView.h
//  MVVMReactiveCocoaLearn
//
//  Created by hao on 2018/12/10.
//  Copyright © 2018 hao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MRCLReactiveView <NSObject>
- (void)bindModel:(id)model;
@end

NS_ASSUME_NONNULL_END
