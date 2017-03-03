//
//  ViewController.m
//  WZZ8BitMusicGame
//
//  Created by 舞蹈圈 on 17/2/28.
//  Copyright © 2017年 wzz. All rights reserved.
//

#import "ViewController.h"
#import "WZZGameScene.h"
#import "WZZSelectManVC.h"
@import SpriteKit;

#define TRUEPASS @"^^vv<><>ba"

@interface ViewController ()
{
    SKView * gameView;
    NSString * gotoTestModePass;
    NSString * manImageName;
}
@property (weak, nonatomic) IBOutlet UIButton *manButton;
@property (weak, nonatomic) IBOutlet UIButton *startButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    gotoTestModePass = @"";
}

- (IBAction)selectManClick:(id)sender {
    WZZSelectManVC * vc = [[WZZSelectManVC alloc] init];
    [vc selectAImage:^(NSString *imageName) {
        manImageName = imageName;
        [_manButton setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }];
    [self presentViewController:vc animated:YES completion:nil];
}
    
- (IBAction)startGame:(id)sender {
    [self resetGame];
}

- (void)resetGame {
    BOOL isTestMode = [gotoTestModePass isEqualToString:TRUEPASS];
    gameView = [[SKView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:gameView];
    WZZGameScene * scene = [[WZZGameScene alloc] initWithSize:gameView.frame.size manImage:manImageName];
    scene.showTest = isTestMode;
    [scene gameOverBlock:^{
        [gameView removeFromSuperview];
        gameView = nil;
    }];
    [gameView presentScene:scene];
}

#pragma mark - 测试模式
- (IBAction)u:(id)sender {
    [self checkStringWithChar:'^'];
}
- (IBAction)d:(id)sender {
    [self checkStringWithChar:'v'];
}
- (IBAction)l:(id)sender {
    [self checkStringWithChar:'<'];
}
- (IBAction)r:(id)sender {
    [self checkStringWithChar:'>'];
}
- (IBAction)b:(id)sender {
    [self checkStringWithChar:'b'];
}
- (IBAction)a:(id)sender {
    [self checkStringWithChar:'a'];
}
- (IBAction)c:(id)sender {
    gotoTestModePass = @"";
}
- (void)checkStringWithChar:(char)aChar {
    gotoTestModePass = [gotoTestModePass stringByAppendingFormat:@"%c", aChar];
    if ([TRUEPASS rangeOfString:gotoTestModePass].location == NSNotFound) {
        gotoTestModePass = @"";
    }
    NSLog(@"%@", gotoTestModePass);
    BOOL isTestMode = [gotoTestModePass isEqualToString:TRUEPASS];
    if (isTestMode) {
        [_startButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    } else {
        [_startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

@end
