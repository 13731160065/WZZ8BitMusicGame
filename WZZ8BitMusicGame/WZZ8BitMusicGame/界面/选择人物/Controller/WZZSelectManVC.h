//
//  WZZSelectManVC.h
//  WZZ8BitMusicGame
//
//  Created by 舞蹈圈 on 17/3/2.
//  Copyright © 2017年 wzz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZZSelectManVC : UIViewController

/**
 选择了一个图片
 */
- (void)selectAImage:(void(^)(NSString * imageName))aBlock;

@end
