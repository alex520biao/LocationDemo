//
//  ONEBaseComponent.m
//  Pods
//
//  Created by Liushulong on 27/04/2017.
//
//

#import "ONEBaseComponent.h"

@interface ONEBaseComponent ()

@property (nonatomic, weak) id<ONEBaseComProtocol> delegate;

@end

@implementation ONEBaseComponent

-(void)bind:(id<ONEBaseComProtocol>)delegate{
    if(delegate) {
        self.delegate = delegate;
    }
}

-(void)unbind {
    self.delegate = nil;
}

-(void)dealloc{
    [self unbind];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



/*!
 *  @brief 组件触发事件，处理组件关心的外部事件，子类可继承进行处理
 */
- (void)triggerEvent:(NSUInteger)event params:(NSDictionary *)params
{
    
}

@end
