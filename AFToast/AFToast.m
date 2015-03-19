//
//  AFToast.m
//  Demo
//
//  Created by 李建平 on 15/3/19.
//  Copyright (c) 2015年 Jianping. All rights reserved.
//

#import "AFToast.h"

@interface AFToast()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *textLabel;
@end

static AFToast *sharedView = nil;

@implementation AFToast

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (AFToast *)sharedView {
    sharedView = [[AFToast alloc] init];
    sharedView.layer.cornerRadius = 10;
    sharedView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5];
    return sharedView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
    }
    return _imageView;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = [UIColor whiteColor];
        [self addSubview:_textLabel];
    }
    return _textLabel;
}

#pragma mark - Show Methods
+ (void)showText:(NSString *)text {
    [self showImage:nil withText:text withFont:nil];
}
+ (void)showText:(NSString *)text withFont:(UIFont *)font {
    [self showImage:nil withText:text withFont:font];
}

+ (void)showImage:(UIImage *)image {
    [self showImage:image withText:nil withFont:nil];
}
+ (void)showImage:(UIImage *)image withText:(NSString *)text {
    [self showImage:image withText:text withFont:nil];
}
+ (void)showImage:(UIImage *)image withText:(NSString *)text withFont:(UIFont *)font {
    [[AFToast sharedView] showImage:image withText:text withFont:font];
}

- (void)showImage:(UIImage *)image withText:(NSString *)text withFont:(UIFont *)font {
    if (image == nil && text == nil) {
        return;
    }
    
    if (font == nil) {
        font = [UIFont systemFontOfSize:16];
    }
    
    //只存在text
    if (image == nil) {//设置label和self的size
        self.imageView.hidden = YES;
        CGSize textSize = [self sizeForText:text Font:font constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        CGFloat textWidth = textSize.width;
        CGFloat textHeight = textSize.height;
        self.bounds = CGRectMake(0, 0, textWidth + 15 * 2, textHeight + 10 * 2);
        self.textLabel.frame = CGRectMake(15, 10, textWidth, textHeight);
    } else {
        self.imageView.hidden = NO;
        self.imageView.image = image;
    }
    
    //只存在image
    if (text == nil) {//设置imageView和self的size
        self.textLabel.hidden = YES;
        self.backgroundColor = [UIColor clearColor];
        CGFloat imageWidth = image.size.width;
        CGFloat imageHeight = image.size.height;
        self.bounds = CGRectMake(0, 0, imageWidth, imageHeight);
        self.imageView.frame = CGRectMake(0, 0, imageWidth, imageHeight);
    } else {
        self.textLabel.hidden = NO;
        self.textLabel.text = text;
        self.textLabel.font = font;
    }
    
    //同时存在image和text
    if (NO == self.imageView.hidden && NO == self.textLabel.hidden) {
        self.bounds = CGRectMake(0, 0, AFT_Default_Width, AFT_Default_Height);
        
        CGFloat imageWidth = image.size.width;
        CGFloat imageHeight = image.size.height;
        CGFloat imageX = (AFT_Default_Width - imageWidth) / 2.0;
        CGFloat imageY = AFT_ImageView_Top;
        self.imageView.frame = CGRectMake(imageX, imageY, imageWidth, imageHeight);
        
        CGSize textSize = [self sizeForText:text Font:font constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        CGFloat textWidth = textSize.width;
        CGFloat textHeight = textSize.height;
        CGFloat textX = (AFT_Default_Width - textWidth) / 2.0;
        CGFloat textY = AFT_Default_Height - textHeight - (AFT_Default_Height - CGRectGetMaxY(self.imageView.frame) - textHeight) / 2.0;
        self.textLabel.frame = CGRectMake(textX, textY, textWidth, textHeight);
    }
    
    [self show];
}

#pragma mark - Private Methods
- (void)show {
    [self positionHUD:nil];
    [self registerNotifications];
    
    if (self.alpha != 1) {
        [self registerNotifications];
    }
    
    self.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    __weak AFToast *weakSelf = self;
    [UIView animateWithDuration:0.382 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakSelf.alpha = 1.0;
    } completion:^(BOOL finished) {
        [weakSelf performSelector:@selector(hide) withObject:nil afterDelay:.9];
    }];
}
- (void)hide {
    __weak AFToast *weakSelf = self;
    [UIView animateWithDuration:0.382 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakSelf.alpha = 0.0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
    sharedView = nil;
}

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(positionHUD:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
}

- (void)positionHUD:(NSNotification*)notification {
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGRect orientationFrame = [UIScreen mainScreen].bounds;
    
    if(UIInterfaceOrientationIsLandscape(orientation)) {
        float temp = orientationFrame.size.width;
        orientationFrame.size.width = orientationFrame.size.height;
        orientationFrame.size.height = temp;
    }
    
    CGFloat activeHeight = orientationFrame.size.height;
    
    CGFloat posY = floor(activeHeight * 0.5);
    CGFloat posX = orientationFrame.size.width / 2;
    
    CGPoint newCenter;
    CGFloat rotateAngle;
    
    switch (orientation) {
        case UIInterfaceOrientationPortraitUpsideDown:
            rotateAngle = M_PI;
            newCenter = CGPointMake(posX, orientationFrame.size.height-posY);
            break;
        case UIInterfaceOrientationLandscapeLeft:
            rotateAngle = -M_PI/2.0f;
            newCenter = CGPointMake(posY, posX);
            break;
        case UIInterfaceOrientationLandscapeRight:
            rotateAngle = M_PI/2.0f;
            newCenter = CGPointMake(orientationFrame.size.height-posY, posX);
            break;
        default: // as UIInterfaceOrientationPortrait
            rotateAngle = 0.0;
            newCenter = CGPointMake(posX, posY);
            break;
    }
    
    self.transform = CGAffineTransformMakeRotation(rotateAngle);
    self.center = newCenter;
}

#pragma mark - tools
- (CGSize)sizeForText:(NSString *)text Font:(UIFont *)font constrainedToSize:(CGSize)constrainedToSize {
    CGSize size = CGSizeZero;
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0) {
        NSDictionary *attribute = @{NSFontAttributeName : font};
        size = [text boundingRectWithSize:constrainedToSize options:NSStringDrawingTruncatesLastVisibleLine attributes:attribute context:nil].size;
    } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000
        size = [text sizeWithFont:font constrainedToSize:constrainedToSize lineBreakMode:NSLineBreakByWordWrapping];
#endif
    }
    return size;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
