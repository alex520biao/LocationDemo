//
//  UIScrollView+ONEExtends.m
//  Pods
//
//  Created by didi on 16/10/10.
//
//

#import "UIScrollView+ONEExtends.h"

@implementation UIScrollView (Addition)
//frame
- (CGFloat)contentWidth {
    return self.contentSize.width;
}
- (void)setContentWidth:(CGFloat)width {
    self.contentSize = CGSizeMake(width, self.frame.size.height);
}
- (CGFloat)contentHeight {
    return self.contentSize.height;
}
- (void)setContentHeight:(CGFloat)height {
    self.contentSize = CGSizeMake(self.frame.size.width, height);
}
- (CGFloat)contentOffsetX {
    return self.contentOffset.x;
}
- (void)setContentOffsetX:(CGFloat)x {
    self.contentOffset = CGPointMake(x, self.contentOffset.y);
}
- (CGFloat)contentOffsetY {
    return self.contentOffset.y;
}
- (void)setContentOffsetY:(CGFloat)y {
    self.contentOffset = CGPointMake(self.contentOffset.x, y);
}
//


- (CGPoint)one_topContentOffset
{
    return CGPointMake(0.0f, -self.contentInset.top);
}
- (CGPoint)one_bottomContentOffset
{
    return CGPointMake(0.0f, self.contentSize.height + self.contentInset.bottom - self.bounds.size.height);
}
- (CGPoint)one_leftContentOffset
{
    return CGPointMake(-self.contentInset.left, 0.0f);
}
- (CGPoint)one_rightContentOffset
{
    return CGPointMake(self.contentSize.width + self.contentInset.right - self.bounds.size.width, 0.0f);
}
- (void)one_scrollToTopAnimated:(BOOL)animated
{
    [self setContentOffset:[self one_topContentOffset] animated:animated];
}
- (void)one_scrollToBottomAnimated:(BOOL)animated
{
    [self setContentOffset:[self one_bottomContentOffset] animated:animated];
}
- (void)one_scrollToLeftAnimated:(BOOL)animated
{
    [self setContentOffset:[self one_leftContentOffset] animated:animated];
}
- (void)one_scrollToRightAnimated:(BOOL)animated
{
    [self setContentOffset:[self one_rightContentOffset] animated:animated];
}

@end

