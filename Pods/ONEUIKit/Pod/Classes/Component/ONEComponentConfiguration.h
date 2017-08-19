//
//  ONEComponentConfiguration.h
//  Pods
//
//  Created by Liushulong on 27/04/2017.
//
//

#import <Foundation/Foundation.h>

@interface ONEComponentConfiguration : NSObject

/*!
 *  @brief 组件类名
 */
@property(nonatomic,copy) NSString  *componentName;

/*!
 *  @brief 组件是否打开
 */
@property(nonatomic,assign) BOOL openFlag;

@end
