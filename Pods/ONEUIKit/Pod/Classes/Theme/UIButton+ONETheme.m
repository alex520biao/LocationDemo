//
//  UIButton+ONETheme.m
//  Pods
//
//  Created by 张华威 on 2017/5/18.
//
//

#import "UIButton+ONETheme.h"
#import <ONEUIKit/UIButton+ONEExtends.h>

@implementation UIButton (ONETheme)

#pragma mark - BackgroundColor

- (void)setOne_normalControlStateBackgroundColor:(UIColor *)color {
    [self one_setBackgroundColor:color forState:UIControlStateNormal];
}
- (void)setOne_highlightedControlStateBackgroundColor:(UIColor *)color {
    [self one_setBackgroundColor:color forState:UIControlStateHighlighted];
}
- (void)setOne_disabledControlStateBackgroundColor:(UIColor *)color {
    [self one_setBackgroundColor:color forState:UIControlStateDisabled];
}
- (void)setOne_selectedControlStateBackgroundColor:(UIColor *)color {
    [self one_setBackgroundColor:color forState:UIControlStateSelected];
}

#pragma mark - TitleColor

- (void)setOne_normalControlStateTitleColor:(UIColor *)color {
    [self setTitleColor:color forState:UIControlStateNormal];
}
- (void)setOne_highlightedControlStateTitleColor:(UIColor *)color {
    [self setTitleColor:color forState:UIControlStateHighlighted];
}
- (void)setOne_disabledControlStateTitleColor:(UIColor *)color {
    [self setTitleColor:color forState:UIControlStateDisabled];
}
- (void)setOne_selectedControlStateTitleColor:(UIColor *)color {
    [self setTitleColor:color forState:UIControlStateSelected];
}

#pragma mark - BackgroundImage

- (void)setOne_normalControlStateBackgroundImage:(UIImage *)image {
    [self setBackgroundImage:image forState:UIControlStateNormal];
}
- (void)setOne_highlightedControlStateBackgroundImage:(UIImage *)image {
    [self setBackgroundImage:image forState:UIControlStateHighlighted];
}
- (void)setOne_disabledControlStateBackgroundImage:(UIImage *)image {
    [self setBackgroundImage:image forState:UIControlStateDisabled];
}
- (void)setOne_selectedControlStateBackgroundImage:(UIImage *)image {
    [self setBackgroundImage:image forState:UIControlStateSelected];
}

#pragma mark - Image

- (void)setOne_normalControlStateImage:(UIImage *)image {
    [self setImage:image forState:UIControlStateNormal];
}
- (void)setOne_highlightedControlStateImage:(UIImage *)image {
    [self setImage:image forState:UIControlStateHighlighted];
}
- (void)setOne_disabledControlStateImage:(UIImage *)image {
    [self setImage:image forState:UIControlStateDisabled];
}
- (void)setOne_selectedControlStateImage:(UIImage *)image {
    [self setImage:image forState:UIControlStateSelected];
}

@end
