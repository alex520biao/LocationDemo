//
//  UIControl+ONEExtends.h
//  Pods
//
//  Created by didi on 16/10/10.
//
//

#import <UIKit/UIKit.h>

typedef void (^UIControlActionBlock)(id weakSender);


@interface UIControlActionBlockWrapper : NSObject
@property (nonatomic, copy) UIControlActionBlock actionBlock;
@property (nonatomic, assign) UIControlEvents controlEvents;
- (void)invokeBlock:(id)sender;
@end



@interface UIControl (ActionBlocks)
- (void)one_handleControlEvents:(UIControlEvents)controlEvents withBlock:(UIControlActionBlock)actionBlock;
- (void)one_removeActionBlocksForControlEvents:(UIControlEvents)controlEvents;

@end
