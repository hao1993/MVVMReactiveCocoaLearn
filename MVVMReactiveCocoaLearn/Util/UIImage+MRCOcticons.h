//
//  UIImage+MRCOcticons.h
//  MVVMReactiveCocoaLearn
//
//  Created by hao on 2018/11/12.
//  Copyright © 2018 hao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (MRCOcticons)
/// Generating icon image using the GitHub's icons font.
///
/// identifier - The identifier of GitHub's icons font
/// size       - The size of icon image
///
/// Returns the icon image.
+ (UIImage *)octicon_imageWithIdentifier:(NSString *)identifier size:(CGSize)size;
@end

NS_ASSUME_NONNULL_END
