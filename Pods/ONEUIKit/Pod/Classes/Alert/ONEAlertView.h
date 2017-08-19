//
//  ONEAlertView.h
//  ONEAlertViewDemo
//
//  Created by Alex Jarvis on 25/09/2013.
//  Copyright (c) 2013 Panaxiom Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ONEAlertViewCompletionBlock)(BOOL closed,BOOL checked, NSInteger buttonIndex);

@interface ONEAlertView : UIViewController

@property (nonatomic, getter = isVisible) BOOL visible;

@property (nonatomic, assign) BOOL autoDismiss;

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
messageOfAttributed:(NSAttributedString *)messageOfAttributed
      checkMessaage:(NSString *)checkMessaage
      detialMessage:(NSString *)detialMessage
       buttonTitles:(NSArray *)buttonTitles
           canClose:(BOOL)canClose
        contentView:(UIView *)contentView
           isCustom:(BOOL)isCustom
         completion:(ONEAlertViewCompletionBlock)completion;

- (void)show;

- (void)dismissWithAnimated:(BOOL)animated;

- (id)initWithCustomView:(UIView *)customView buttonsTitle:(NSArray <NSString *> *)titles canClose:(BOOL)canClose completion:(ONEAlertViewCompletionBlock)completion;

/**
 * Dismisses the receiver, optionally with animation.
 */
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;

+ (NSArray <ONEAlertView*>*)alertViews;

@end
