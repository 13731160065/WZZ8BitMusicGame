//
//  WZZListenManager.h
//  WZZListenerDemo
//
//  Created by 舞蹈圈 on 17/2/24.
//  Copyright © 2017年 wzz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WZZListenManager : NSObject

+ (instancetype)shareManager;

/**
 使用最大音量(或是平均音量)
 */
@property (assign, nonatomic) BOOL useMaxVal;

/**
 开始监听
 */
- (void)startListenWithBlock:(void(^)(Float32 level))aBlock;

/**
 结束监听
 */
- (void)stopListen;

@end
