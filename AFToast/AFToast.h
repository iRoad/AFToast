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

/** 显示为图片的背景颜色-->适合图文图片 */
+ (void)showImage:(UIImage *)image;
+ (void)showImage:(UIImage *)image withText:(NSString *)text;
+ (void)showImage:(UIImage *)image withText:(NSString *)text withFont:(UIFont *)font;

/** 背景默认半透明黑色 字体默认白色 字体默认16号 */
+ (void)showText:(NSString *)text withFont:(UIFont *)font textColor:(UIColor *)textColor backgroundColor:(UIColor *)bgColor;
/** 背景默认半透明黑色 字体默认白色 字体默认16号 */
+ (void)showImage:(UIImage *)image withText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor backgroundColor:(UIColor *)bgColor;
@end
