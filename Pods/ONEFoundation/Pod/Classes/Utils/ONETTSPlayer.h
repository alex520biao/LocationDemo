//
//  ONETTSPlayer.h
//  Pods
//
//  Created by Liushulong on 13/02/2017.
//
//

#import <Foundation/Foundation.h>
#import "ONEMacros.h"

//TTS播放组件,拷贝自顺风车IM组件
@interface ONETTSPlayer : NSObject

ARC_SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(ONETTSPlayer);

+ (void)playTTS:(NSString *)aSoundText;
/*isplay 是否支持后台播放*/
+ (void)playTTS:(NSString *)aSoundText inBackground:(BOOL)isplay;
+ (void)stop;


@end
