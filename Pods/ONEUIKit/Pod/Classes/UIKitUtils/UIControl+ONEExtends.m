//
//  UIControl+ONEExtends.m
//  Pods
//
//  Created by didi on 16/10/10.
//
//

#import "UIControl+ONEExtends.h"

#import <objc/runtime.h>

#define UICONTROL_EVENT(methodName, eventName)                                \
-(void)methodName : (void (^)(void))eventBlock {                              \
objc_setAssociatedObject(self, @selector(methodName:), eventBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);\
[self addTarget:self                                                        \
action:@selector(methodName##Action:)                                       \
forControlEvents:UIControlEvent##eventName];                                \
}                                                                               \
-(void)methodName##Action:(id)sender {                                        \
void (^block)() = objc_getAssociatedObject(self, @selector(methodName:));  \
if (block) {                                                                \
block();                                                                \
}                                                                           \
}



static const void *UIControlActionBlockArray = &UIControlActionBlockArray;

@implementation UIControlActionBlockWrapper

- (void)invokeBlock:(id)sender {
    if (self.actionBlock) {
        self.actionBlock(sender);
    }
}
@end


@implementation UIControl (ActionBlocks)

UICONTROL_EVENT(touchDown, TouchDown)
UICONTROL_EVENT(touchDownRepeat, TouchDownRepeat)
UICONTROL_EVENT(touchDragInside, TouchDragInside)
UICONTROL_EVENT(touchDragOutside, TouchDragOutside)
UICONTROL_EVENT(touchDragEnter, TouchDragEnter)
UICONTROL_EVENT(touchDragExit, TouchDragExit)
UICONTROL_EVENT(touchUpInside, TouchUpInside)
UICONTROL_EVENT(touchUpOutside, TouchUpOutside)
UICONTROL_EVENT(touchCancel, TouchCancel)
UICONTROL_EVENT(valueChanged, ValueChanged)
UICONTROL_EVENT(editingDidBegin, EditingDidBegin)
UICONTROL_EVENT(editingChanged, EditingChanged)
UICONTROL_EVENT(editingDidEnd, EditingDidEnd)
UICONTROL_EVENT(editingDidEndOnExit, EditingDidEndOnExit)



-(void)one_handleControlEvents:(UIControlEvents)controlEvents withBlock:(UIControlActionBlock)actionBlock {
    NSMutableArray *actionBlocksArray = [self actionBlocksArray];
    
    UIControlActionBlockWrapper *blockActionWrapper = [[UIControlActionBlockWrapper alloc] init];
    blockActionWrapper.actionBlock = actionBlock;
    blockActionWrapper.controlEvents = controlEvents;
    [actionBlocksArray addObject:blockActionWrapper];
    
    [self addTarget:blockActionWrapper action:@selector(invokeBlock:) forControlEvents:controlEvents];
}


- (void)one_removeActionBlocksForControlEvents:(UIControlEvents)controlEvents {
    NSMutableArray *actionBlocksArray = [self actionBlocksArray];
    NSMutableArray *wrappersToRemove = [NSMutableArray arrayWithCapacity:[actionBlocksArray count]];
    
    [actionBlocksArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIControlActionBlockWrapper *wrapperTmp = obj;
        if (wrapperTmp.controlEvents == controlEvents) {
            [wrappersToRemove addObject:wrapperTmp];
            [self removeTarget:wrapperTmp action:@selector(invokeBlock:) forControlEvents:controlEvents];
        }
    }];
    
    [actionBlocksArray removeObjectsInArray:wrappersToRemove];
}


- (NSMutableArray *)actionBlocksArray {
    NSMutableArray *actionBlocksArray = objc_getAssociatedObject(self, UIControlActionBlockArray);
    if (!actionBlocksArray) {
        actionBlocksArray = [NSMutableArray array];
        objc_setAssociatedObject(self, UIControlActionBlockArray, actionBlocksArray, OBJC_ASSOCIATION_RETAIN);
    }
    return actionBlocksArray;
}
@end

