//
//  ViewController.m
//  WZZ8BitMusicGame
//
//  Created by 舞蹈圈 on 17/2/28.
//  Copyright © 2017年 wzz. All rights reserved.
//

#import "ViewController.h"
#import "WZZGameScene.h"
@import SpriteKit;

@interface ViewController ()
{
    SKView * gameView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}
    
- (IBAction)startGame:(id)sender {
    gameView = [[SKView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:gameView];
    WZZGameScene * scene = [[WZZGameScene alloc] initWithSize:gameView.frame.size];
    [gameView presentScene:scene];
}

@end
