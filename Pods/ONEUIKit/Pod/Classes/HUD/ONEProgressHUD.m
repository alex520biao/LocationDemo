//
// ONEProgressHUD.m
// Version 0.5
// Created by Matej Bukovinski on 2.4.09.
//

#import "ONEProgressHUD.h"


#if __has_feature(objc_arc)
#define ONE_AUTORELEASE(exp) exp
#define ONE_RELEASE(exp) exp
#define ONE_RETAIN(exp) exp
#else
#define ONE_AUTORELEASE(exp) [exp autorelease]
#define ONE_RELEASE(exp) [exp release]
#define ONE_RETAIN(exp) [exp retain]
#endif

//static const CGFloat kVerticalPadding      = 18.f;          //上下内边距
static const CGFloat kHorizontalPadding    = 16.f;          //左右内边距
static const CGFloat kLabelFontSize        = 14.f;          //label字体
static const CGFloat kDetailsLabelFontSize = 12.f;          //detailLabel字体
static const CGSize  kIndicatorSize        = {24,24};       //UIActivityIndicatorView的默认尺寸
//static const CGFloat kopacity              = .9f;
static const CGFloat kHUDheight            = 50.f;
static const CGFloat kHUDhigherSubHeight   = 33.5;
static const CGFloat kSpace                = 10.f;
static const CGFloat kLabelMaxWidth        = 180.f;
static const CGFloat kTextLabelLineSpacing = 5.f;

@interface ONEProgressHUD ()

- (void)setupLabels;
- (void)registerForKVO;
- (void)unregisterFromKVO;
- (NSArray *)observableKeypaths;
- (void)registerForNotifications;
- (void)unregisterFromNotifications;
- (void)updateUIForKeypath:(NSString *)keyPath;
- (void)hideUsingAnimation:(BOOL)animated;
- (void)showUsingAnimation:(BOOL)animated;
- (void)done;
- (void)updateIndicators;
- (void)handleGraceTimer:(NSTimer *)theTimer;
- (void)handleMinShowTimer:(NSTimer *)theTimer;
- (void)setTransformForCurrentOrientation:(BOOL)animated;
- (void)cleanUp;
- (void)launchExecution;
- (void)deviceOrientationDidChange:(NSNotification *)notification;
- (void)hideDelayed:(NSNumber *)animated;

@property (nonatomic, ONE_STRONG) UIView *indicator;
@property (nonatomic, ONE_STRONG) NSTimer *graceTimer;
@property (nonatomic, ONE_STRONG) NSTimer *minShowTimer;
@property (nonatomic, ONE_STRONG) NSDate *showStarted;
@property (assign) CGSize size;

@end


@implementation ONEProgressHUD {
    BOOL useAnimation;
    SEL methodForExecution;
    id targetForExecution;
    id objectForExecution;
    UILabel *label;
    UILabel *detailsLabel;
    BOOL isFinished;
    CGAffineTransform rotationTransform;
    UIColor *_labelColor;
    UIColor *_detailsLabelColor;
    UIColor *_progressColor;
}

#pragma mark - Properties

@synthesize animationType;
@synthesize delegate;
@synthesize opacity;
@synthesize labelFont;
@synthesize detailsLabelFont;
@synthesize indicator;
@synthesize xOffset;
@synthesize yOffset;
@synthesize minSize;
@synthesize square;
@synthesize margin;
@synthesize dimBackground;
@synthesize graceTime;
@synthesize minShowTime;
@synthesize graceTimer;
@synthesize minShowTimer;
@synthesize taskInProgress;
@synthesize removeFromSuperViewOnHide;
@synthesize customView;
@synthesize showStarted;
@synthesize mode;
@synthesize labelText;
@synthesize detailsLabelText;
@synthesize progress;
@synthesize size;
@synthesize progressColor;
@synthesize labelColor;
@synthesize detailsLabelColor;

#pragma mark - Class methods

+ (ONEProgressHUD *)showHUDAddedTo:(UIView *)view animated:(BOOL)animated {
    ONEProgressHUD *hud = [[ONEProgressHUD alloc] initWithView:view];
    [view addSubview:hud];
    [hud show:animated];
    return ONE_AUTORELEASE(hud);
}

+ (BOOL)hideHUDForView:(UIView *)view animated:(BOOL)animated {
    ONEProgressHUD *hud = [ONEProgressHUD HUDForView:view];
    if (hud != nil) {
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:animated];
        return YES;
    }
    return NO;
}

+ (NSUInteger)hideAllHUDsForView:(UIView *)view animated:(BOOL)animated {
    NSArray *huds = [self allHUDsForView:view];
    for (ONEProgressHUD *hud in huds) {
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:animated];
    }
    return [huds count];
}

+ (ONEProgressHUD *)HUDForView:(UIView *)view {
    ONEProgressHUD *hud = nil;
    NSArray *subviews = view.subviews;
    Class hudClass = [ONEProgressHUD class];
    for (UIView *view in subviews) {
        if ([view isKindOfClass:hudClass]) {
            hud = (ONEProgressHUD *)view;
        }
    }
    return hud;
}

+ (NSArray *)allHUDsForView:(UIView *)view {
    NSMutableArray *huds = [NSMutableArray array];
    NSArray *subviews = view.subviews;
    Class hudClass = [ONEProgressHUD class];
    for (UIView *view in subviews) {
        if ([view isKindOfClass:hudClass]) {
            [huds addObject:view];
        }
    }
    return [NSArray arrayWithArray:huds];
}

#pragma mark - Lifecycle

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Set default values for properties
        self.animationType = ONEProgressHUDAnimationFade;
        self.mode = ONEProgressHUDModeIndeterminate;
        self.labelText = nil;
        self.detailsLabelText = nil;
        self.opacity = 0.9f;
        self.labelFont = [UIFont boldSystemFontOfSize:kLabelFontSize];
        self.detailsLabelFont = [UIFont boldSystemFontOfSize:kDetailsLabelFontSize];
        self.xOffset = 0.0f;
        self.yOffset = 0.0f;
        self.dimBackground = NO;
        self.margin = 20.0f;
        self.graceTime = 0.0f;
        self.minShowTime = 0.0f;
        self.removeFromSuperViewOnHide = NO;
        self.minSize = CGSizeZero;
        self.square = NO;
        self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin
								| UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        // Transparent background
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        // Make it invisible for now
        self.alpha = 0.0f;
        
        //add by zack 2012.5.9
        self.labelColor = [UIColor whiteColor];
        self.detailsLabelColor = [UIColor whiteColor];
        self.progressColor = [UIColor whiteColor];
        
        //end
        
        taskInProgress = NO;
        rotationTransform = CGAffineTransformIdentity;
        
        //		[self setupLabels];
        [self updateIndicators];
        [self registerForKVO];
        [self registerForNotifications];
    }
    return self;
}

- (id)initWithView:(UIView *)view {
    NSAssert(view, @"View must not be nil.");
    id me = [self initWithFrame:view.bounds];
    // We need to take care of rotation ourselfs if we're adding the HUD to a window
    if ([view isKindOfClass:[UIWindow class]]) {
        [self setTransformForCurrentOrientation:NO];
    }
    return me;
}

- (id)initWithWindow:(UIWindow *)window {
    return [self initWithView:window];
}

- (void)dealloc {
    [self unregisterFromNotifications];
    [self unregisterFromKVO];
#if !__has_feature(objc_arc)
    [indicator release];
    [label release];
    [detailsLabel release];
    [labelText release];
    [detailsLabelText release];
    [graceTimer release];
    [minShowTimer release];
    [showStarted release];
    [customView release];
    [labelColor release];
    [detailsLabelColor release];
    [progressColor release];
    [super dealloc];
#endif
}

#pragma mark - Show & hide

- (void)show:(BOOL)animated {
    [self setupLabels];
    useAnimation = animated;
    // If the grace time is set postpone the HUD display
    if (self.graceTime > 0.0) {
        self.graceTimer = [NSTimer scheduledTimerWithTimeInterval:self.graceTime target:self
                                                         selector:@selector(handleGraceTimer:) userInfo:nil repeats:NO];
    }
    // ... otherwise show the HUD imediately
    else {
        [self setNeedsDisplay];
        [self showUsingAnimation:useAnimation];
    }
}

- (void)hide:(BOOL)animated {
    useAnimation = animated;
    // If the minShow time is set, calculate how long the hud was shown,
    // and pospone the hiding operation if necessary
    if (self.minShowTime > 0.0 && showStarted) {
        NSTimeInterval interv = [[NSDate date] timeIntervalSinceDate:showStarted];
        if (interv < self.minShowTime) {
            self.minShowTimer = [NSTimer scheduledTimerWithTimeInterval:(self.minShowTime - interv) target:self
                                                               selector:@selector(handleMinShowTimer:) userInfo:nil repeats:NO];
            return;
        }
    }
    // ... otherwise hide the HUD immediately
    [self hideUsingAnimation:useAnimation];
}

- (void)hide:(BOOL)animated afterDelay:(NSTimeInterval)delay {
    [self performSelector:@selector(hideDelayed:) withObject:[NSNumber numberWithBool:animated] afterDelay:delay];
}

- (void)hideDelayed:(NSNumber *)animated {
    [self hide:[animated boolValue]];
}

#pragma mark - Timer callbacks

- (void)handleGraceTimer:(NSTimer *)theTimer {
    // Show the HUD only if the task is still running
    if (taskInProgress) {
        [self setNeedsDisplay];
        [self showUsingAnimation:useAnimation];
    }
}

- (void)handleMinShowTimer:(NSTimer *)theTimer {
    [self hideUsingAnimation:useAnimation];
}

#pragma mark - Internal show & hide operations

- (void)showUsingAnimation:(BOOL)animated {
    self.alpha = 0.0f;
    if (animated && animationType == ONEProgressHUDAnimationZoom) {
        self.transform = CGAffineTransformConcat(rotationTransform, CGAffineTransformMakeScale(1.5f, 1.5f));
    }
    self.showStarted = [NSDate date];
    // Fade in
    if (animated) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.30];
        self.alpha = 1.0f;
        if (animationType == ONEProgressHUDAnimationZoom) {
            self.transform = rotationTransform;
        }
        [UIView commitAnimations];
    }
    else {
        self.alpha = 1.0f;
    }
}

- (void)hideUsingAnimation:(BOOL)animated {
    // Fade out
    if (animated && showStarted) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.30];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
        // 0.02 prevents the hud from passing through touches during the animation the hud will get completely hidden
        // in the done method
        if (animationType == ONEProgressHUDAnimationZoom) {
            self.transform = CGAffineTransformConcat(rotationTransform, CGAffineTransformMakeScale(0.5f, 0.5f));
        }
        self.alpha = 0.02f;
        [UIView commitAnimations];
    }
    else {
        self.alpha = 0.0f;
        [self done];
    }
    //edit by zack 2012.4.25
    //    self.showStarted = nil;
    //--------------------------
}

- (void)animationFinished:(NSString *)animationID finished:(BOOL)finished context:(void*)context {
    [self done];
}

- (void)done {
    //edit by zack 2012.4.25
    self.showStarted = nil;
    //--------------------------
    
    isFinished = YES;
    self.alpha = 0.0f;
    if ([delegate respondsToSelector:@selector(hudWasHidden:)]) {
        [delegate performSelector:@selector(hudWasHidden:) withObject:self];
    }
    if (removeFromSuperViewOnHide) {
        [self removeFromSuperview];
    }
}

#pragma mark - Threading

- (void)showWhileExecuting:(SEL)method onTarget:(id)target withObject:(id)object animated:(BOOL)animated {
    methodForExecution = method;
    targetForExecution = ONE_RETAIN(target);
    objectForExecution = ONE_RETAIN(object);
    // Launch execution in new thread
    self.taskInProgress = YES;
    [NSThread detachNewThreadSelector:@selector(launchExecution) toTarget:self withObject:nil];
    // Show HUD view
    [self show:animated];
}

- (void)launchExecution {
    @autoreleasepool {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        // Start executing the requested task
        [targetForExecution performSelector:methodForExecution withObject:objectForExecution];
#pragma clang diagnostic pop
        // Task completed, update view in main thread (note: view operations should
        // be done only in the main thread)
        [self performSelectorOnMainThread:@selector(cleanUp) withObject:nil waitUntilDone:NO];
    }
}

- (void)cleanUp {
    taskInProgress = NO;
    self.indicator = nil;
#if !__has_feature(objc_arc)
    [targetForExecution release];
    [objectForExecution release];
#endif
    [self hide:useAnimation];
}

#pragma mark - UI


- (void)setupLabels {
    if (label==nil) {
        label = [[UILabel alloc] initWithFrame:self.bounds];
        label.adjustsFontSizeToFitWidth = NO;
        label.textAlignment = NSTextAlignmentLeft;
        label.opaque = NO;
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 0;
        //label尺寸设置了最大值文本内容需要末尾补...
        label.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:label];
    }
    label.textColor = self.labelColor;
    label.font = self.labelFont;
    label.text = self.labelText;
    
    if (detailsLabel==nil) {
        detailsLabel = [[UILabel alloc] initWithFrame:self.bounds];
        detailsLabel.adjustsFontSizeToFitWidth = NO;
        detailsLabel.textAlignment = NSTextAlignmentCenter;
        detailsLabel.opaque = NO;
        detailsLabel.backgroundColor = [UIColor clearColor];
        detailsLabel.numberOfLines = 0;
        detailsLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:detailsLabel];
    }
    detailsLabel.textColor = self.detailsLabelColor;
    detailsLabel.font = self.detailsLabelFont;
    detailsLabel.text = self.detailsLabelText;
}

- (void)updateIndicators {
    
    BOOL isActivityIndicator = [indicator isKindOfClass:[UIActivityIndicatorView class]];
    BOOL isRoundIndicator = [indicator isKindOfClass:[ONERoundProgressView class]];
    
    if (mode == ONEProgressHUDModeIndeterminate &&  !isActivityIndicator) {
        // Update to indeterminate indicator
        [indicator removeFromSuperview];
        self.indicator = ONE_AUTORELEASE([[UIActivityIndicatorView alloc]
                                         initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite]);
        [(UIActivityIndicatorView *)indicator startAnimating];
        [self addSubview:indicator];
        
        //设置indicator默认尺寸kIndicatorSize
        CGRect frame=self.indicator.frame;
        frame.size=kIndicatorSize;
        self.indicator.frame=frame;
    }
    else if (mode == ONEProgressHUDModeDeterminate || mode == ONEProgressHUDModeAnnularDeterminate) {
        if (!isRoundIndicator) {
            // Update to determinante indicator
            [indicator removeFromSuperview];
            self.indicator = ONE_AUTORELEASE([[ONERoundProgressView alloc] init]);
            ONERoundProgressView *progressView = (ONERoundProgressView*)self.indicator;
            progressView.progressColor = self.progressColor;
            [self addSubview:indicator];
        }
        if (mode == ONEProgressHUDModeAnnularDeterminate) {
            [(ONERoundProgressView *)indicator setAnnular:YES];
        }
    }
    else if (mode == ONEProgressHUDModeCustomView && customView != indicator) {
        // Update custom view indicator
        [indicator removeFromSuperview];
        self.indicator = customView;
        [self addSubview:indicator];
    } else if (mode == ONEProgressHUDModeText) {
        [indicator removeFromSuperview];
        self.indicator = nil;
    }
}

#pragma mark - Layout

- (CGRect)adjustLabelFrameHeight:(UILabel *)aLabel maxWidth:(CGFloat )maxWidth{
    CGFloat height;
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    context.minimumScaleFactor = 1.0;
    CGRect bounds = [aLabel.text
                     boundingRectWithSize:CGSizeMake(maxWidth, FLT_MAX)
                     options:NSStringDrawingUsesLineFragmentOrigin
                     attributes:@{ NSFontAttributeName: aLabel.font }
                     context:context];
    height = bounds.size.height;
    
    return CGRectMake(aLabel.frame.origin.x, aLabel.frame.origin.y, bounds.size.width, height);
}

- (void)layoutSubviews {

    CGRect bounds = self.bounds;
    
    NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = label.lineBreakMode;
    style.alignment = label.textAlignment;
    style.lineSpacing = kTextLabelLineSpacing;
    
    CGRect labelRect = [self adjustLabelFrameHeight:label maxWidth:kLabelMaxWidth];
    CGSize labelSize = labelRect.size;
    
    // 只显示两行
    if (labelSize.height > 33) {
        labelSize.height = 34;
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:label.text];
        NSMutableParagraphStyle *style = [NSParagraphStyle defaultParagraphStyle].mutableCopy;
        style.lineSpacing = kTextLabelLineSpacing;
        style.lineBreakMode = NSLineBreakByWordWrapping;
        style.alignment = NSTextAlignmentLeft;
        [str addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, str.length)];
        [str addAttribute:NSFontAttributeName value:label.font range:NSMakeRange(0, str.length)];
        [str addAttribute:NSForegroundColorAttributeName value:label.textColor range:NSMakeRange(0, str.length)];
        label.attributedText = str;
    }
    
    if (label.text.length==0) {
        labelSize = CGSizeZero;
    }
    //labelSize最小值为kLabelMinSize
    
    label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, labelSize.width, labelSize.height);
    [label sizeToFit];
    labelSize = label.frame.size;
    
    if (labelSize.height > 20) {
        self.size = CGSizeMake(kHorizontalPadding * 2 + kIndicatorSize.width + kSpace + labelSize.width, labelSize.height + kHUDhigherSubHeight);
    } else {
        self.size = CGSizeMake(kHorizontalPadding * 2 + kIndicatorSize.width + kSpace + labelSize.width, kHUDheight);
    }
    
    if (indicator) {
        label.frame = CGRectMake((bounds.size.width - self.size.width) / 2 + kHorizontalPadding + kSpace + kIndicatorSize.width, 0, labelSize.width, labelSize.height);
        label.center = CGPointMake(label.center.x, bounds.size.height / 2);
        indicator.frame = CGRectMake((bounds.size.width - self.size.width) / 2 + kHorizontalPadding, 0, kIndicatorSize.width, kIndicatorSize.height);
        indicator.center = CGPointMake(indicator.center.x, bounds.size.height / 2);
    } else {
        label.frame = CGRectMake(0, 0, labelSize.width, bounds.size.height / 2);
        label.center = self.center;
        
        self.size = CGSizeMake(kHorizontalPadding * 2 + labelSize.width - 1, self.size.height);
    }
    
    // offset 支持
    label.center = CGPointMake(label.center.x + self.xOffset, label.center.y + self.yOffset);
    indicator.center = CGPointMake(indicator.center.x + self.xOffset, indicator.center.y + self.yOffset);
}

- (void)setIndicator:(UIView *)newIndicator {
    indicator = newIndicator;
}

#pragma mark BG Drawing

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (dimBackground) {
        //Gradient colours
        size_t gradLocationsNum = 2;
        CGFloat gradLocations[2] = {0.0f, 1.0f};
        CGFloat gradColors[8] = {0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.75f};
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, gradColors, gradLocations, gradLocationsNum);
        CGColorSpaceRelease(colorSpace);
        //Gradient center
        CGPoint gradCenter= CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        //Gradient radius
        float gradRadius = MIN(self.bounds.size.width , self.bounds.size.height) ;
        //Gradient draw
        CGContextDrawRadialGradient (context, gradient, gradCenter,
                                     0, gradCenter, gradRadius,
                                     kCGGradientDrawsAfterEndLocation);
        CGGradientRelease(gradient);
    }
    
    // Center HUD
    CGRect allRect = self.bounds;
    // Draw rounded HUD bacgroud rect
    CGRect boxRect = CGRectMake(roundf((allRect.size.width - size.width) / 2) + self.xOffset,
                                roundf((allRect.size.height - size.height) / 2) + self.yOffset, size.width - 1, size.height);
    float radius = 2.0f;
    CGContextBeginPath(context);
    CGContextSetRGBFillColor(context, 0x25 / 255.0, 0x26 / 255.0, 0x2d / 255.0, .9f);
    //	CGContextSetGrayFillColor(context, 0.0f, self.opacity);
    CGContextMoveToPoint(context, CGRectGetMinX(boxRect) + radius, CGRectGetMinY(boxRect));
    CGContextAddArc(context, CGRectGetMaxX(boxRect) - radius, CGRectGetMinY(boxRect) + radius, radius, 3 * (float)M_PI / 2, 0, 0);
    CGContextAddArc(context, CGRectGetMaxX(boxRect) - radius, CGRectGetMaxY(boxRect) - radius, radius, 0, (float)M_PI / 2, 0);
    CGContextAddArc(context, CGRectGetMinX(boxRect) + radius, CGRectGetMaxY(boxRect) - radius, radius, (float)M_PI / 2, (float)M_PI, 0);
    CGContextAddArc(context, CGRectGetMinX(boxRect) + radius, CGRectGetMinY(boxRect) + radius, radius, (float)M_PI, 3 * (float)M_PI / 2, 0);
    CGContextClosePath(context);
    CGContextFillPath(context);
}

#pragma mark - KVO

- (void)registerForKVO {
    for (NSString *keyPath in [self observableKeypaths]) {
        [self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL];
    }
}

- (void)unregisterFromKVO {
    for (NSString *keyPath in [self observableKeypaths]) {
        [self removeObserver:self forKeyPath:keyPath];
    }
}

- (NSArray *)observableKeypaths {
    return [NSArray arrayWithObjects:@"mode", @"customView", @"labelText", @"labelFont",
            @"detailsLabelText", @"detailsLabelFont", @"progress", nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(updateUIForKeypath:) withObject:keyPath waitUntilDone:NO];
    } else {
        [self updateUIForKeypath:keyPath];
    }
}

- (void)updateUIForKeypath:(NSString *)keyPath {
    if ([keyPath isEqualToString:@"mode"] || [keyPath isEqualToString:@"customView"]) {
        [self updateIndicators];
    } else if ([keyPath isEqualToString:@"labelText"]) {
        label.text = self.labelText;
    } else if ([keyPath isEqualToString:@"labelFont"]) {
        label.font = self.labelFont;
    } else if ([keyPath isEqualToString:@"detailsLabelText"]) {
        detailsLabel.text = self.detailsLabelText;
    } else if ([keyPath isEqualToString:@"detailsLabelFont"]) {
        detailsLabel.font = self.detailsLabelFont;
    } else if ([keyPath isEqualToString:@"progress"]) {
        if ([indicator respondsToSelector:@selector(setProgress:)]) {
            [(id)indicator setProgress:progress];
        }
        return;
    }
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

#pragma mark - Notifications

- (void)registerForNotifications {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(deviceOrientationDidChange:)
               name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)unregisterFromNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)deviceOrientationDidChange:(NSNotification *)notification {
    UIView *superview = self.superview;
    if (!superview) {
        return;
    } else if ([superview isKindOfClass:[UIWindow class]]) {
        [self setTransformForCurrentOrientation:YES];
    } else {
        self.bounds = self.superview.bounds;
        [self setNeedsDisplay];
    }
    self.center = superview.center;
}

- (void)setTransformForCurrentOrientation:(BOOL)animated {
#if 0
    // Stay in sync with the superview
    if (self.superview) {
        self.bounds = self.superview.bounds;
        [self setNeedsDisplay];
    }
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    float radians = 0;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        if (orientation == UIInterfaceOrientationLandscapeLeft) { radians = -M_PI_2; }
        else { radians = M_PI_2; }
        // Window coordinates differ!
        self.bounds = CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.width);
    } else {
        if (orientation == UIInterfaceOrientationPortraitUpsideDown) { radians = M_PI; }
        else { radians = 0; }
    }
    rotationTransform = CGAffineTransformMakeRotation(radians);
    
    if (animated) {
        [UIView beginAnimations:nil context:nil];
    }
    [self setTransform:rotationTransform];
    if (animated) {
        [UIView commitAnimations];
    }
#endif
}

@end


@implementation ONERoundProgressView {
    float _progress;
    BOOL _annular;
    UIColor *_progressColor;
}

#pragma mark - Accessors

- (float)progress {
    return _progress;
}

- (void)setProgress:(float)progress {
    _progress = progress;
    [self setNeedsDisplay];
}

- (BOOL)isAnnular {
    return _annular;
}

- (void)setAnnular:(BOOL)annular {
    _annular = annular;
    [self setNeedsDisplay];
}

- (UIColor*)progressColor
{
    return _progressColor;
}

- (void)setProgressColor:(UIColor*)progressColor
{
    _progressColor = progressColor;
    [self setNeedsDisplay];
}


#pragma mark - Lifecycle

- (id)init {
    return [self initWithFrame:CGRectMake(0.f, 0.f, 37.f, 37.f)];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        _progress = 0.f;
        _annular = NO;
        _progressColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - Drawing
#if 0
- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    
    CGRect allRect = self.bounds;
    CGRect circleRect = CGRectInset(allRect, 2.0f, 2.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (_annular) {
        // Draw background
        CGFloat lineWidth = 5.f;
        UIBezierPath *processBackgroundPath = [UIBezierPath bezierPath];
        processBackgroundPath.lineWidth = lineWidth;
        processBackgroundPath.lineCapStyle = kCGLineCapRound;
        CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        CGFloat radius = (self.bounds.size.width - lineWidth)/2;
        CGFloat startAngle = - ((float)M_PI / 2); // 90 degrees
        CGFloat endAngle = (2 * (float)M_PI) + startAngle;
        [processBackgroundPath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
        [[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1] set];
        [processBackgroundPath stroke];
        // Draw progress
        UIBezierPath *processPath = [UIBezierPath bezierPath];
        processPath.lineCapStyle = kCGLineCapRound;
        processPath.lineWidth = lineWidth;
        endAngle = (self.progress * 2 * (float)M_PI) + startAngle;
        [processPath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
        [[UIColor whiteColor] set];
        [processPath stroke];
    } else {
        // Draw background
        //		CGContextSetRGBStrokeColor(context, 1.0f, 1.0f, 1.0f, 1.0f); // white
        CGContextSetRGBFillColor(context, 1.0f, 1.0f, 1.0f, 0.1f); // translucent white
        CGContextSetStrokeColorWithColor(context, self.progressColor.CGColor);
        CGContextSetLineWidth(context, 2.0f);
        CGContextFillEllipseInRect(context, circleRect);
        CGContextStrokeEllipseInRect(context, circleRect);
        // Draw progress
        CGPoint center = CGPointMake(allRect.size.width / 2, allRect.size.height / 2);
        CGFloat radius = (allRect.size.width - 4) / 2;
        CGFloat startAngle = - ((float)M_PI / 2); // 90 degrees
        CGFloat endAngle = (self.progress * 2 * (float)M_PI) + startAngle;
        //		CGContextSetRGBFillColor(context, 1.0f, 1.0f, 1.0f, 1.0f); // white
        CGContextSetFillColorWithColor(context, self.progressColor.CGColor);
        CGContextMoveToPoint(context, center.x, center.y);
        CGContextAddArc(context, center.x, center.y, radius, startAngle, endAngle, 0);
        CGContextClosePath(context);
        CGContextFillPath(context);
    }
}
#endif
@end
