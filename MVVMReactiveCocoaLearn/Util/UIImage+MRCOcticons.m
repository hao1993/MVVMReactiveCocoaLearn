//
//  UIImage+MRCOcticons.m
//  MVVMReactiveCocoaLearn
//
//  Created by hao on 2018/11/12.
//  Copyright © 2018 hao. All rights reserved.
//

#import "UIImage+MRCOcticons.h"
#import "UIImage+Octicons.h"

@implementation UIImage (MRCOcticons)

+ (UIImage *)octicon_imageWithIdentifier:(NSString *)identifier size:(CGSize)size {
    return [UIImage octicon_imageWithIcon:identifier
                          backgroundColor:[UIColor clearColor]
                                iconColor:[UIColor darkGrayColor]
                                iconScale:1
                                  andSize:size];
}

@end
