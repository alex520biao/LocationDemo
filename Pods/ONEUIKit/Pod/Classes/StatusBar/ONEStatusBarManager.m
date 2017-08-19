//
//  ONEStatusBarManager.m
//  Pods
//
//  Created by 张华威 on 2017/3/17.
//
//

#import "ONEStatusBarManager.h"
#import <ONEUIKit/ONEUIKit.h>
#import <ONEFoundation/ONEFoundation.h>

#define oneStatusBarWindowLevel UIWindowLevelStatusBar + 21.f

static CGFloat const oneStatusBarDuration = .4f;

typedef void(^ONEStatusBarDidTouched)();

@interface ONEStatusBarManager ()

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, assign) ONEStatusBarPriority priority;
@property (nonatomic, copy) ONEStatusBarDidTouched didTouched;

@end

@implementation ONEStatusBarManager

#pragma mark - public

ARC_SYNTHESIZE_SINGLETON_FOR_CLASS(ONEStatusBarManager)

- (BOOL)showText:(id)text didTouched:(ONEStatusBarDidTouched)didTouchedBlock hideAfter:(NSUInteger)secs priority:(ONEStatusBarPriority)priority withIdentifier:(NSString *)identifier {
    
    if (![ONEValidJudge isValidString:identifier]) {
        NSAssert(NO, @"identifier 不合法");
        return NO;
    }
    
    if ([identifier isEqualToString:self.identifier]) {
        NSLog(@"要显示的identifier与当前相同");
        return NO;
    }
    
    if (priority < self.priority) {
        return NO;
    }
    
    if ([text isKindOfClass:[NSString class]]) {
        if (![ONEValidJudge isValidString:text]) {
            NSAssert(NO, @"text 不合法");
            return NO;
        }
        [self.button setTitle:text forState:UIControlStateNormal];
        [self.button setTitleColor:[self.class titleColorWithPriority:priority] forState:UIControlStateNormal];
    } else if ([text isKindOfClass:[NSAttributedString class]]) {
        if (![ONEValidJudge isValidString:[(NSAttributedString *)text string]]) {
            NSAssert(NO, @"text 不合法");
            return NO;
        }
        [self.button.titleLabel setAttributedText:text];
    }
    
    [self.button setBackgroundColor:[self.class backgroundColorWithPriority:priority]];
    
    if (!self.window.hidden) {
        [self hideWithIdentifier:self.identifier completion:^{
            [self show];
            _isShowing = YES;
        }];
    } else {
        [self show];
        _isShowing = YES;
    }
    
    self.didTouched = didTouchedBlock;
    self.identifier = identifier;
    self.priority = priority;
    
    if (secs > 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(secs * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hideWithIdentifier:identifier];
        });
    }
    
    
    return YES;
}

- (BOOL)hideWithIdentifier:(NSString *)identifier {
    return [self hideWithIdentifier:identifier completion:nil];
}

- (BOOL)hideWithIdentifier:(NSString *)identifier completion:(void (^)(void))completion{
    if ([identifier isEqualToString:self.identifier]) {
        self.identifier = nil;
        self.priority = ONEStatusBarPriorityDefault;
#if DEBUG
        self.priority = ONEStatusBarPriorityDebug;
#endif
        self.didTouched = nil;
        
        [UIView animateWithDuration:oneStatusBarDuration animations:^{
            [self.window setFrame:CGRectMake(0, -self.window.height, self.window.width, self.window.height)];
        } completion:^(BOOL finished) {
            self.window.hidden = YES;
            _isShowing = NO;
            if (completion) {
                completion();
            }
        }];
        
        return YES;
    }
    
    if (completion) {
        completion();
    }
    return NO;
}

#pragma mark - private

- (instancetype)init {
    if (self = [super init]) {
        [self layoutViews];
#if DEBUG
        _priority = ONEStatusBarPriorityDebug;
#endif
    }
    return self;
}

- (void)layoutViews {
    [self.window addSubview:self.button];
}

- (void)show {
    
    CGRect showFrame = CGRectMake(0, 0, self.window.width, self.window.height);
    [self.window setFrame:CGRectMake(0, -self.window.height, self.window.width, self.window.height)];
    
    UIWindow *keyWindow = [[UIApplication sharedApplication].delegate window];
    [self.window makeKeyAndVisible];
    [keyWindow makeKeyWindow];
    
    [UIView animateWithDuration:oneStatusBarDuration animations:^{
        self.window.frame = showFrame;
    }];
}

- (void)toucheUpInsideMe:(UIButton *)sender {
    if (self.didTouched) {
        self.didTouched();
    }
    [self hideWithIdentifier:self.identifier];
}

#pragma mark - Properyies

- (UIWindow *)window {
    if (!_window) {
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        _window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 20)];
        [_window setWindowLevel:oneStatusBarWindowLevel];
        [_window setBackgroundColor:kColorClear];
        [_window setHidden:YES];
        [_window setClipsToBounds:YES];
    }
    return _window;
}

- (UIButton *)button {
    if (!_button) {
        _button = [[UIButton alloc] initWithFrame:self.window.frame];
        [_button.titleLabel setFont:kFontSizeSmall];
        [_button setBackgroundColor:kColorGray];
        [_button setTitleColor:kColorWhite forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(toucheUpInsideMe:) forControlEvents:UIControlEventTouchDown];
    }
    return _button;
}

#pragma mark - Theme

+ (UIColor *)titleColorWithPriority:(ONEStatusBarPriority)priority {
    
    return kColorWhite;
}

+ (UIColor *)backgroundColorWithPriority:(ONEStatusBarPriority)priority {
    
    return [kColorOrange1 colorWithAlphaComponent:.98f];
    
//    应对主题需求
    /*
    switch (priority) {
        case ONEStatusBarPriorityDebug:
            return [UIColor greenColor];
            
        case ONEStatusBarPriorityDefault:
            return kColorBlue;
            
        case ONEStatusBarPriorityWarn:
            return kColorOrange;
            
        case ONEStatusBarPriorityError:
            return kColorRed_light;
            
        case ONEStatusBarPriorityFatal:
            return kColorRed;
        default:
            break;
    }
    
    return kColorWhite;
     */
}

@end
