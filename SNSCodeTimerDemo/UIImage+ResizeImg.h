//
//  CYLSNSCodeButtonViewController.h
//  SNSCodeTimerDemo
//
//  Created by CHENYI LONG on 14-11-23.
//  Copyright (c) 2014年 CHENYI LONG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ResizeImg)
+ (UIImage *)imageWithName:(NSString *)name;
+ (UIImage *)resizedImage:(NSString *)name;
+ (UIImage *)resizedImage:(NSString *)name left:(CGFloat)left top:(CGFloat)top;
@end
