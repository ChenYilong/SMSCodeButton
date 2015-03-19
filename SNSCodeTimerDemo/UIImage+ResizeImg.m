//
//  CYLSNSCodeButtonViewController.h
//  SNSCodeTimerDemo
//
//  Created by CHENYI LONG on 14-11-23.
//  Copyright (c) 2014年 CHENYI LONG. All rights reserved.
//

#import "UIImage+ResizeImg.h"

@implementation UIImage (ResizeImg)
+ (UIImage *)imageWithName:(NSString *)name
{
    return [self imageNamed:name];
}

+ (UIImage *)resizedImage:(NSString *)name
{
    return [self resizedImage:name left:0.5 top:0.5];
}

+ (UIImage *)resizedImage:(NSString *)name left:(CGFloat)left top:(CGFloat)top
{
    UIImage *image = [self imageWithName:name];
    
    return [image stretchableImageWithLeftCapWidth:image.size.width * left topCapHeight:image.size.height * top];
}
@end
