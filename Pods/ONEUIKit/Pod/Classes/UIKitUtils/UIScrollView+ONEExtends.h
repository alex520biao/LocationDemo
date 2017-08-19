//
//  UIScrollView+ONEExtends.h
//  Pods
//
//  Created by didi on 16/10/10.
//
//

#import <UIKit/UIKit.h>

@interface UIScrollView (Addition)
@property(nonatomic) CGFloat contentWidth;
@property(nonatomic) CGFloat contentHeight;
@property(nonatomic) CGFloat contentOffsetX;
@property(nonatomic) CGFloat contentOffsetY;

- (CGPoint)one_topContentOffset;
- (CGPoint)one_bottomContentOffset;
- (CGPoint)one_leftContentOffset;
- (CGPoint)one_rightContentOffset;

- (void)one_scrollToTopAnimated:(BOOL)animated;
- (void)one_scrollToBottomAnimated:(BOOL)animated;
- (void)one_scrollToLeftAnimated:(BOOL)animated;
- (void)one_scrollToRightAnimated:(BOOL)animated;

@end

