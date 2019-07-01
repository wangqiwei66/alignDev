//
//  UIViewCategory.h
//  iGBSMobile
//
//  Created by Yu Ye on 20/01/2017.
//  Copyright © 2017 yy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UIViewBlurStyle) {
    UIViewBlurExtraLightStyle,
    UIViewBlurLightStyle,
    UIViewBlurDarkStyle
};

@interface UIView (Blur)

/* The UIToolbar/UIVisualEffectView(ios8) that has been put on the current view, use it to do your bidding */
@property (strong,nonatomic,readonly) UIView* blurBackground;

/* The UIVisualEffectView that should be used for vibrancy element, add subviews to .contentView */
@property (strong,nonatomic,readonly) UIVisualEffectView* blurVibrancyBackground NS_AVAILABLE_IOS(8_0);

/* tint color of the blurred view */
@property (strong,nonatomic) UIColor* blurTintColor;

/* intensity of blurTintColor applied on the blur 0.0-1.0, default 0.6f */
@property (assign,nonatomic) double blurTintColorIntensity;

/* returns if blurring is enabled */
@property (readonly,nonatomic) BOOL isBlurred;

/* Style of Toolbar, remapped to UIViewBlurStyle typedef above */
@property (assign,nonatomic) UIViewBlurStyle blurStyle;

/* method to enable Blur on current UIView */
-(void)enableBlur:(BOOL) enable;

@end

@interface UIView (Utilities)
- (UIActivityIndicatorView*)startLoadingView:(UIView*)view color:(UIColor*)color;
- (void)hideLoadingView:(UIActivityIndicatorView*)view;
- (void)drawDashLine:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;

@end
@interface UIView (Layout)
- (void)centerInVertical;

- (void)centerInHorizontal;

- (void)centerInGravity;

-(void) modifyToHeight:(CGFloat)height;
-(void) modifyHeightBy:(CGFloat)byValue;
-(void) modifyToWidth:(CGFloat)width;
-(void) modifyToX:(CGFloat)x;
-(void) modifyToY:(CGFloat)y;
-(void) modifyToOrign:(CGPoint)point;
-(void) modifyToSize:(CGSize)size;
-(void) modifyYBy:(CGFloat)byValue;
-(void) modifyXBy:(CGFloat)byValue;
-(void) logFrame:(NSString *)preLogStr;
-(void) hideToTop;
-(void) showOnTop;
-(void) hideToBottom;
-(void) showOnBottom;
-(void) fadeinWithin:(NSTimeInterval)sec;
@end

