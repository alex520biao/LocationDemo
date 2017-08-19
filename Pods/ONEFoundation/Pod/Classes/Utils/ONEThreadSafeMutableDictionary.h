//
//  ONEThreadSafeMutableDictionary.h
//  ONEThreadSafeDict
//
//  Created by Liushulong on 03/01/2017.
//  Copyright © 2017 Liushulong. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 线程安全的字典,用法和系统字典一样.set和removeObjectForkey方法加了非空保护.
 */
@interface ONEThreadSafeMutableDictionary<KeyType, ObjectType> : NSMutableDictionary

@end
