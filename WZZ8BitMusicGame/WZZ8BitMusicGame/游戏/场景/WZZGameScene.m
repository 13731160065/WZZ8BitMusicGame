//
//  WZZGameScene.m
//  WZZ8BitMusicGame
//
//  Created by 舞蹈圈 on 17/2/28.
//  Copyright © 2017年 wzz. All rights reserved.
//

#import "WZZGameScene.h"
#import "WZZListenManager.h"
#define MOVEVECTOR 50
#define LOADSPACE 60
#define LOADHEIGHT 100

static int32_t bit8Mask = 0x1 << 0;
static int32_t loadMask = 0x1 << 1;

@interface WZZGameScene ()<SKPhysicsContactDelegate>
{
    SKSpriteNode * bit8;
    NSMutableArray <SKSpriteNode *>* loadsArr;
    WZZListenManager * manager;
    BOOL canJump;
    void(^_gameOverBlock)();
    CGFloat currentVector;
}

@end

@implementation WZZGameScene
{
    NSArray * testArr;
}

- (instancetype)initWithSize:(CGSize)size manImage:(NSString *)image
{
    self = [super initWithSize:size];
    if (self) {
        _bit8ImageText = image;
        manager = [WZZListenManager shareManager];
//        [manager setUseMaxVal:YES];
        [self creatAll];
        [manager startListenWithBlock:^(Float32 level) {
            [self checkGameOver];
            [self handleActionWithVoiceLevel:level];
            if (_showTest) {
                [self testLevel:level];
            }
        }];
    }
    return self;
}

#pragma mark - 初始化
- (void)creatAll {
    [self setup];
    
    //创建一开始的路
    [self creatLoadWithRect:CGRectMake(0, 0, self.size.width, LOADHEIGHT)];
    
    //创建小人
    [self creat8BitNode];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (_showTest) {
            //测试
            [self creatTestButton];
        }
    });
}

- (void)setup {
    self.physicsWorld.gravity = CGVectorMake(0, -9.8);
    self.physicsWorld.contactDelegate = self;
    self.backgroundColor = [UIColor whiteColor];
    loadsArr = [NSMutableArray array];
    
    manager = [WZZListenManager shareManager];
    [manager startListenWithBlock:^(Float32 level) {}];//没用，但必须加这个，不然init里的监听不起作用
    canJump = YES;
    currentVector = 1000;
}

#pragma mark - 测试方法
- (void)testLevel:(Float32)level {
    CGPoint point = CGPointMake(202.5, self.size.height-50);
    SKSpriteNode * testNode = testArr[2];
    testNode.position = CGPointMake(point.x, point.y+level*testNode.size.height);
}

//测试
- (void)creatTestButton {
    //跳
    SKSpriteNode * jump = [SKSpriteNode spriteNodeWithColor:[UIColor orangeColor] size:CGSizeMake(50, 50)];
    [self addChild:jump];
    [jump setPosition:CGPointMake(50, self.size.height-50)];
    
    //移动
    SKSpriteNode * move = [SKSpriteNode spriteNodeWithColor:[UIColor purpleColor] size:CGSizeMake(50, 50)];
    [self addChild:move];
    [move setPosition:CGPointMake(150, self.size.height-50)];
    
    //级别显示
    SKSpriteNode * level = [SKSpriteNode spriteNodeWithColor:[UIColor greenColor] size:CGSizeMake(20, 50)];
    [self addChild:level];
    [level setPosition:CGPointMake(200, self.size.height-50)];
    //级别遮盖
    SKSpriteNode * level2 = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(25, 50)];
    [self addChild:level2];
    [level2 setPosition:CGPointMake(202.5, self.size.height-50)];
    
    //动力+
    SKSpriteNode * vectorA = [SKSpriteNode spriteNodeWithColor:[UIColor purpleColor] size:CGSizeMake(25, 25)];
    [self addChild:vectorA];
    [vectorA setPosition:CGPointMake(250, self.size.height-50-25)];
    //动力显示
    SKLabelNode * vectorShow = [SKLabelNode labelNodeWithText:[NSString stringWithFormat:@"%.0lf", currentVector]];
    vectorShow.fontName = [UIFont systemFontOfSize:15].fontName;
    vectorShow.fontSize = 13;
    vectorShow.fontColor = [UIColor blackColor];
    [self addChild:vectorShow];
    [vectorShow setPosition:CGPointMake(250+25+50/2, self.size.height-50-25-25/2)];
    //动力-
    SKSpriteNode * vectorR = [SKSpriteNode spriteNodeWithColor:[UIColor purpleColor] size:CGSizeMake(25, 25)];
    [self addChild:vectorR];
    [vectorR setPosition:CGPointMake(250+25+50+25/2, self.size.height-50-25)];
    
    testArr = @[jump, move, level2, @[vectorA, vectorR, vectorShow]];
}

//测试按钮点击事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch * tou = [touches anyObject];
    CGPoint po = [tou locationInNode:self];
    SKSpriteNode * node = testArr[0];
    SKSpriteNode * node2 = testArr[1];
    SKSpriteNode * vA = testArr[3][0];
    SKSpriteNode * vR = testArr[3][1];
    SKLabelNode * vS = testArr[3][2];
    
    if ([node containsPoint:po]) {
        [self jump8Bit];
    } else if ([node2 containsPoint:po]) {
        [self moveLoad];
    } else if ([vA containsPoint:po]) {
        currentVector += 10;
        vS.text = [NSString stringWithFormat:@"%.0lf", currentVector];
    } else if ([vR containsPoint:po]) {
        currentVector -= 10;
        vS.text = [NSString stringWithFormat:@"%.0lf", currentVector];
    }
}

#pragma mark - 方法
#pragma mark 创建
//创建小人
- (void)creat8BitNode {
    bit8 = [SKSpriteNode spriteNodeWithImageNamed:_bit8ImageText?_bit8ImageText:@"bit8"];
    [bit8 setSize:CGSizeMake(30, 30)];
//    bit8 = [SKSpriteNode spriteNodeWithColor:[UIColor blackColor] size:CGSizeMake(30, 30)];
    [bit8 setPosition:CGPointMake(self.size.width/3, self.size.height-25)];
    [self addChild:bit8];
    bit8.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:bit8.size];
    bit8.physicsBody.mass = 10;
    bit8.physicsBody.categoryBitMask = bit8Mask;
    bit8.physicsBody.contactTestBitMask = loadMask;
}

//创建路
- (void)creatLoadWithRect:(CGRect)rect {
    SKSpriteNode * load = [SKSpriteNode spriteNodeWithColor:[UIColor lightGrayColor] size:rect.size];
    [self addChild:load];
    load.position = CGPointMake(rect.origin.x+rect.size.width/2, rect.origin.y+rect.size.height/2);
    load.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rect.size];
    load.physicsBody.dynamic = NO;
    load.physicsBody.categoryBitMask = loadMask;
    load.physicsBody.contactTestBitMask = bit8Mask;
    [loadsArr addObject:load];
}

#pragma mark 方法
//根据精灵的长度计算需要的时间(速度固定)
- (NSTimeInterval)timeWithHowLong:(CGFloat)howLong {
    return [self timeWithHowLong:howLong vector:MOVEVECTOR];
}

//根据长度和速度计算时间
- (NSTimeInterval)timeWithHowLong:(CGFloat)howLong vector:(CGFloat)vector {
    return howLong/vector;
}

#pragma mark 动作
//根据音量处理动作
- (void)handleActionWithVoiceLevel:(Float32)level {
    const Float32 runLevel = 0.1f;//开跑的level
    const Float32 jumpLevel = 0.5f;//开跳的level
    if (level > runLevel) {
        //如果超过跑的level了就跳加跑
        if (level > jumpLevel) {
            [self jump8Bit:level];
            //往前跑
            CGFloat jumpLong = (LOADSPACE+bit8.size.width)*level;
            [self moveLoadWithLong:jumpLong vector:jumpLong/10*MOVEVECTOR];
        } else {
            //往前跑
            [self moveLoad];
        }
    }
    
}

//移动陆地(默认速度和距离)
- (void)moveLoad {
    [self moveLoadWithLong:10];
}

//移动陆地(默认速度)
- (void)moveLoadWithLong:(CGFloat)loadLong {
    [self moveLoadWithLong:loadLong vector:MOVEVECTOR];
}

//移动陆地(默认距离)
- (void)moveLoadWithVector:(CGFloat)vector {
    [self moveLoadWithLong:10 vector:vector];
}

//移动陆地
- (void)moveLoadWithLong:(CGFloat)loadLong vector:(CGFloat)vector {
    //如果最后一块陆地超出了陆地间隙，那么就在后边再创建一块路堵
    SKSpriteNode * lastLoad = [loadsArr lastObject];
    if (self.size.width-(lastLoad.position.x+lastLoad.size.width/2) > LOADSPACE) {
        [self creatLoadWithRect:CGRectMake(lastLoad.position.x+lastLoad.size.width/2+LOADSPACE, 0, arc4random()%200+50, LOADHEIGHT)];
    }
    
    //如果第一块陆地走出了屏幕，那就把它移除
    SKSpriteNode * firstLoad = [loadsArr firstObject];
    if (firstLoad.position.x+firstLoad.size.width/2 < 0) {
        [firstLoad removeFromParent];
        [loadsArr removeObjectAtIndex:0];
    }
    
    //循环移动陆地
    [loadsArr enumerateObjectsUsingBlock:^(SKSpriteNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj runAction:[SKAction moveToX:obj.position.x-loadLong duration:[self timeWithHowLong:loadLong vector:vector]]];
    }];
}

//小人跳最大1.0f
- (void)jump8Bit {
    [self jump8Bit:1.0f];
}

//小人跳有等级
- (void)jump8Bit:(Float32)level {
    if (canJump) {
        bit8.physicsBody.velocity = CGVectorMake(0, currentVector*level);
        canJump = NO;
    }
}

#pragma mark 游戏
- (void)checkGameOver {
    if (bit8.position.y < -bit8.size.height) {
        [[WZZListenManager shareManager] stopListen];
        //gameover
        if (_gameOverBlock) {
            _gameOverBlock();
        }
    }
}

#pragma mark - block赋值
- (void)gameOverBlock:(void (^)())aBlock {
    if (_gameOverBlock != aBlock) {
        _gameOverBlock = aBlock;
    }
}

#pragma mark - 物理世界代理
- (void)didBeginContact:(SKPhysicsContact *)contact {
    if (((contact.bodyA.categoryBitMask == bit8Mask)&&(contact.bodyB.categoryBitMask == loadMask)) || ((contact.bodyB.categoryBitMask == bit8Mask)&&(contact.bodyA.categoryBitMask == loadMask))) {
        //是小人撞到陆地了
        if (bit8.position.y > bit8.size.height/2+LOADHEIGHT) {
            //可以跳了
            canJump = YES;
        }
    }
}

@end
