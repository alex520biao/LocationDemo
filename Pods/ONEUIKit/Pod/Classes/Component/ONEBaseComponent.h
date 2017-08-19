//
//  ONEBaseComponent.h
//  Pods
//
//  Created by Liushulong on 27/04/2017.
//
//

#import <Foundation/Foundation.h>
#import <ONEUIKit/ONEUIKit.h>

@class ONEBaseComponent;

//基础协议,子类可以继承 http://stackoverflow.com/questions/732701/how-to-extend-protocols-delegates-in-objective-c
@protocol ONEBaseComProtocol <NSObject>

@optional
/*!
 *  @brief UI组件的容器
 *  @param component 组件本身
 *  @return 返回容器
 */
- (UIView *)viewContainerForComponent:(ONEBaseComponent *)component;

/*!
 *  @brief 返回组件view的frame
 *
 *  @param component 组件
 *
 *  @return frame
 */
- (CGRect)viewFrameForComponent:(ONEBaseComponent *)component;


@end

@interface ONEBaseComponent : NSObject

/*!
 *  @brief 遵循SBaseComProtocol，delegate
 */
@property (nonatomic, weak,readonly) id<ONEBaseComProtocol> delegate;

/*!
 *  @brief 注册事件的业务处理对象
 *  @param delegate
 */
- (void)bind:(id<ONEBaseComProtocol>)delegate;

/*!
 *  @brief 注销发单事件的业务处理对象
 */
- (void)unbind;

/*!
 *  @brief 组件触发事件，处理组件关心的外部事件，子类可继承进行处理
 */
- (void)triggerEvent:(NSUInteger)event params:(NSDictionary *)params;


@end
