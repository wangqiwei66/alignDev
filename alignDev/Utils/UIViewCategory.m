//
//  UIViewCategory.m
//  iGBSMobile
//
//  Created by Yu Ye on 20/01/2017.
//  Copyright © 2017 yy. All rights reserved.
//

#import <objc/runtime.h>
#import "UIViewCategory.h"

NSString const *blurBackgroundKey = @"blurBackgroundKey";
NSString const *blurVibrancyBackgroundKey = @"blurVibrancyBackgroundKey";
NSString const *blurTintColorKey = @"blurTintColorKey";
NSString const *blurTintColorIntensityKey = @"blurTintColorIntensityKey";
NSString const *blurTintColorLayerKey = @"blurTintColorLayerKey";
NSString const *blurStyleKey = @"blurStyleKey";

@implementation UIView (Blur)

@dynamic blurBackground;
@dynamic blurTintColor;
@dynamic blurTintColorIntensity;
@dynamic isBlurred;
@dynamic blurStyle;

#pragma mark - category methods
-(void)enableBlur:(BOOL) enable
{
    if(enable) {
        UIVisualEffectView* view = (UIVisualEffectView*)self.blurBackground;
        UIVisualEffectView* vibrancyView = self.blurVibrancyBackground;
        if(!view || !vibrancyView) {
            [self blurBuildBlurAndVibrancyViews];
        }
        
        //        view.barTintColor = [self.blurTintColor colorWithAlphaComponent:0.4f];
    } else {
        if(self.blurBackground) {
            [self.blurBackground removeFromSuperview];
            objc_setAssociatedObject(self, &blurBackgroundKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
}

-(void) blurBuildBlurAndVibrancyViews NS_AVAILABLE_IOS(8_0)
{
    UIBlurEffectStyle style = UIBlurEffectStyleDark;
    
    if(self.blurStyle == UIViewBlurExtraLightStyle) {
        style = UIBlurEffectStyleExtraLight;
    } else if(self.blurStyle == UIViewBlurLightStyle) {
        style = UIBlurEffectStyleLight;
    }
    // use UIVisualEffectView
    UIVisualEffectView* view = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:style]];
    view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    view.frame = self.bounds;
    [self addSubview:view];
    objc_setAssociatedObject(self, &blurBackgroundKey, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // save subviews of existing vibrancy view
    NSArray* subviews = self.blurVibrancyBackground.contentView.subviews;
    
    // create vibrancy view
    UIVisualEffectView* vibrancyView = [[UIVisualEffectView alloc]initWithEffect:[UIVibrancyEffect effectForBlurEffect:(UIBlurEffect*)view.effect]];
    vibrancyView.frame = self.bounds;
    [view.contentView addSubview:vibrancyView];
    view.contentView.backgroundColor = [self.blurTintColor colorWithAlphaComponent:self.blurTintColorIntensity];
    
    // add back subviews to vibrancy view
    if(subviews) {
        for (UIView* v in subviews) {
            [vibrancyView.contentView addSubview:v];
        }
    }
    objc_setAssociatedObject(self, &blurVibrancyBackgroundKey, vibrancyView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - getters/setters
-(UIColor*) blurTintColor
{
    UIColor* color = objc_getAssociatedObject(self, &blurTintColorKey);
    if(!color) {
        color = [UIColor clearColor];
        objc_setAssociatedObject(self, &blurTintColorKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return color;
}

-(void) setBlurTintColor:(UIColor *)blurTintColor
{
    objc_setAssociatedObject(self, &blurTintColorKey, blurTintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    ((UIVisualEffectView*)self.blurBackground).contentView.backgroundColor = [blurTintColor colorWithAlphaComponent:self.blurTintColorIntensity];}

-(UIView*)blurBackground
{
    return objc_getAssociatedObject(self, &blurBackgroundKey);
}

-(UIVisualEffectView*) blurVibrancyBackground NS_AVAILABLE_IOS(8_0)
{
    return objc_getAssociatedObject(self, &blurVibrancyBackgroundKey);
}

-(UIViewBlurStyle) blurStyle
{
    NSNumber* style = objc_getAssociatedObject(self, &blurStyleKey);
    if(!style) {
        style = @0;
    }
    return (UIViewBlurStyle)style.integerValue;
}

-(void)setBlurStyle:(UIViewBlurStyle)viewBlurStyle
{
    NSNumber *style = [NSNumber numberWithInteger:viewBlurStyle];
    objc_setAssociatedObject(self, &blurStyleKey, style, OBJC_ASSOCIATION_RETAIN);
    
    if(self.blurBackground) {
        [self.blurBackground removeFromSuperview];
        [self blurBuildBlurAndVibrancyViews];
    }
}

-(void)setBlurTintColorIntensity:(double)blurTintColorIntensity
{
    NSNumber *intensity = [NSNumber numberWithDouble:blurTintColorIntensity];
    objc_setAssociatedObject(self, &blurTintColorIntensityKey, intensity, OBJC_ASSOCIATION_RETAIN);
}

-(double)blurTintColorIntensity
{
    NSNumber *intensity = objc_getAssociatedObject(self, &blurTintColorIntensityKey);
    if(!intensity) {
        intensity = @0.3;
    }
    return intensity.doubleValue;
}
@end

@implementation UIView (Utilities)


- (UIActivityIndicatorView*)startLoadingView:(UIView*)view color:(UIColor*)color{
    
    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithFrame: CGRectMake(0, 0, 70, 70)];
    loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    loadingView.backgroundColor = [UIColor clearColor];
    loadingView.color = [UIColor blackColor];
//        loadingView.alpha = 0.5;
//        loadingView.layer.cornerRadius = 6;
//        loadingView.layer.masksToBounds = YES;
    //设置显示位置
    [loadingView setCenter:CGPointMake(view.frame.size.width / 2.0, view.frame.size.height / 2.0)];
    
    //开始显示Loading动画
    [loadingView startAnimating];
    [view addSubview:loadingView];
    return loadingView;
}

- (void)hideLoadingView:(UIActivityIndicatorView*)view {
    [view startAnimating];
    [view removeFromSuperview];
}

- (void)drawDashLine:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:self.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  set color
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  set every unit line width
    [shapeLayer setLineWidth:CGRectGetHeight(self.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  set space betwen two lines
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(self.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    
    [self.layer addSublayer:shapeLayer];
}
@end

@implementation UIView (Layout)

- (void)centerInVertical
{
    UIView *superView = self.superview;
    if (superView) {
        CGSize size = superView.frame.size;
        CGPoint center = self.center;
        center.y = size.height/2.0f;
        self.center = center;
    }
}

- (void)centerInHorizontal
{
    UIView *superView = self.superview;
    if (superView) {
        CGSize size = superView.frame.size;
        CGPoint center = self.center;
        center.x = size.width/2.0f;
        self.center = center;
    }
}

- (void)centerInGravity
{
    UIView *superView = self.superview;
    if (superView) {
//        CGSize size = superView.frame.size;
//        CGPoint center = CGPointMake(size.width/2.0f, size.height/2.0f);
        self.center = superView.center;
    }
}

-(void)hideToTop{
    CGRect frame = self.frame;
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    CGPoint center = CGPointMake(screenFrame.size.width/2.0f, -frame.size.height/2.0f);
    self.center = center;
}

-(void)showOnTop{
    CGRect frame = self.frame;
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    CGPoint center = CGPointMake(screenFrame.size.width/2.0f, frame.size.height/2.0f);
    if (screenFrame.size.height > 800) {
        //iphoneX
        center = CGPointMake(screenFrame.size.width/2.0f, frame.size.height/2.0f + 20);
    }
    self.center = center;
}

-(void)hideToBottom{
    CGRect frame = self.frame;
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    CGPoint center = CGPointMake(screenFrame.size.width/2.0f, screenFrame.size.height + frame.size.height/2.0f);
    self.center = center;
}

-(void)showOnBottom{
    CGRect frame = self.frame;
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    CGPoint center = CGPointMake(screenFrame.size.width/2.0f, screenFrame.size.height - frame.size.height/2.0f);
    self.center = center;
}

-(void) modifyToHeight:(CGFloat)height{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

-(void) modifyHeightBy:(CGFloat)byValue{
    CGRect frame = self.frame;
    frame.size.height += byValue;
    self.frame = frame;
}

-(void) modifyToWidth:(CGFloat)width{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

-(void) modifyToX:(CGFloat)x{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

-(void) modifyToY:(CGFloat)y{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

-(void)modifyYBy:(CGFloat)byValue{
    CGRect frame = self.frame;
    frame.origin.y += byValue;
    self.frame = frame;
}

-(void)modifyXBy:(CGFloat)byValue{
    CGRect frame = self.frame;
    frame.origin.x += byValue;
    self.frame = frame;
}

-(void) modifyToOrign:(CGPoint)point{
    CGRect frame = self.frame;
    frame.origin = point;
    self.frame = frame;
}

-(void) modifyToSize:(CGSize)size{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

-(void)logFrame:(NSString *)preLogStr{
    CGRect frame = self.frame;
    NSLog(@"%@, x:%f,y:%f,width:%f,height:%f",preLogStr ,frame.origin.x
          ,frame.origin.y, frame.size.width ,frame.size.height);
}

-(void)fadeinWithin:(NSTimeInterval)sec{
    __weak typeof(self) weakself = self;
    self.hidden = NO;
    self.alpha = 0;
    [UIView animateWithDuration:sec animations:^{
        weakself.alpha = 1;
    }];
}

@end


