//
//  AFToast.h
//  Demo
//
//  Created by 李建平 on 15/3/19.
//  Copyright (c) 2015年 Jianping. All rights reserved.
//

#import <UIKit/UIKit.h>

#define AFT_Default_Width 160
#define AFT_Default_Height 160

#define AFT_ImageView_Top 30

@interface AFToast : UIView
+ (void)showText:(NSString *)text;
+ (void)showText:(NSString *)text withFont:(UIFont *)font;

+ (void)showImage:(UIImage *)image;
+ (void)showImage:(UIImage *)image withText:(NSString *)text;
+ (void)showImage:(UIImage *)image withText:(NSString *)text withFont:(UIFont *)font;
@end
