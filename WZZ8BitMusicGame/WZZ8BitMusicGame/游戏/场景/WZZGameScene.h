//
//  WZZGameScene.h
//  WZZ8BitMusicGame
//
//  Created by 舞蹈圈 on 17/2/28.
//  Copyright © 2017年 wzz. All rights reserved.
//

#import <UIKit/UIKit.h>
@import SpriteKit;

@interface WZZGameScene : SKScene

@property (assign, nonatomic) BOOL showTest;

@property (strong, nonatomic) NSString * bit8ImageText;

/**
 游戏结束回调
 */
- (void)gameOverBlock:(void(^)())aBlock;

@end
