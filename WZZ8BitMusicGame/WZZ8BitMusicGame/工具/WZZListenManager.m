//
//  WZZListenManager.m
//  WZZListenerDemo
//
//  Created by 舞蹈圈 on 17/2/24.
//  Copyright © 2017年 wzz. All rights reserved.
//

#import "WZZListenManager.h"
#import "SCListener.h"

static WZZListenManager * sss;

@interface WZZListenManager ()
{
    void(^_levelBlock)(Float32);
}

@property (strong, nonatomic) NSTimer * timer;
@property (strong, nonatomic) SCListener * listener;

@end

@implementation WZZListenManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _listener = [SCListener sharedListener];
    }
    return self;
}

+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sss = [[WZZListenManager alloc] init];
    });
    return sss;
}

- (void)startListenWithBlock:(void(^)(Float32))aBlock {
    if (_levelBlock != aBlock) {
        _levelBlock = aBlock;
    }
    [_listener listen];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(getPower) userInfo:nil repeats:YES];
}

- (void)stopListen {
    //停止
    [_listener stop];
    [_timer invalidate];
    _timer = nil;
}

- (void)getPower {
    AudioQueueLevelMeterState * levels = [_listener levels];
    
    if (levels) {
        Float32 peak = 0;
        if (_useMaxVal) {
            //最大音量
            peak = levels->mPeakPower;
        } else {
            //平均音量
            peak = levels->mAveragePower;
        }
        
        if (levels) {
            if (_levelBlock) {
                _levelBlock(peak);
            }
        }
    }
    
}

@end
