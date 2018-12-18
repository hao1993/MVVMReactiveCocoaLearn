//
//  MRCLAvatarHeaderView.h
//  MVVMReactiveCocoaLearn
//
//  Created by hao on 2018/12/14.
//  Copyright © 2018 hao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MRCLAvatarHeaderView : UIView <MRCLReactiveView>
@property (weak, nonatomic, readonly) IBOutlet UITapGestureRecognizer *followerViewGesture;
@property (weak, nonatomic, readonly) IBOutlet UITapGestureRecognizer *reposityViewGesture;
@property (weak, nonatomic, readonly) IBOutlet UITapGestureRecognizer *followingViewGesture;


@end

NS_ASSUME_NONNULL_END
