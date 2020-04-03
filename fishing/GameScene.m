//
//  GameScene.m
//  fishing
//
//  Created by LiveMeteor on 2020/3/20.
//  Copyright © 2020 MMears. All rights reserved.
//

#import "GameScene.h"
#import "ScrollImage.h"
#import "DisplayUtils.h"
#import "AppDelegate.h"
#import "TimerManager.h"
#import "GameFishingModel.h"
#import "GameMacro.h"
#import "GameRabbit.h"
#import "GameFishingHook.h"

@implementation GameScene {
    SKShapeNode* _spinnyNode;
    SKLabelNode* _label;
    
    NSMutableArray<GameUpdateDelegate>* _updateArr;
    CFTimeInterval _lastUpdate;
    CFTimeInterval _fishLastTimes;
    NSUInteger _fishCounter;
    
    ScrollImage* _water;
    SKNode* _fishPool;
    GameRabbit* _rabbit;
    GameFishingHook* _hook;
}

- (void)didMoveToView:(SKView *)view {
    // Setup your scene here
    
    // Get label node from scene and store it for use later
    _label = (SKLabelNode *)[self childNodeWithName:@"//helloLabel"];
    _label.alpha = 0.0;
    [_label runAction:[SKAction fadeInWithDuration:2.0]];
    
    CGFloat w = (self.size.width + self.size.height) * 0.05;
    // Create shape node to use during mouse interaction
    _spinnyNode = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(w, w) cornerRadius:w * 0.3];
    _spinnyNode.lineWidth = 2.5;
    
    [_spinnyNode runAction:[SKAction repeatActionForever:[SKAction rotateByAngle:M_PI duration:1]]];
    [_spinnyNode runAction:[SKAction sequence:@[
                                                [SKAction waitForDuration:0.5],
                                                [SKAction fadeOutWithDuration:0.5],
                                                [SKAction removeFromParent],
                                                ]]];
    
#pragma Game Logic
    _lastUpdate = 0;
    _fishCounter = 0;
    [[TimerManager shareInstance] start];
    self.updateDelegate = (id)[TimerManager shareInstance];
    _updateArr = [NSMutableArray<GameUpdateDelegate> array];
    
    SKTexture* bgTexture = [SKTexture textureWithImageNamed:@"fishing_bg"];
    SKSpriteNode *bgSprite = [[SKSpriteNode alloc] initWithTexture:bgTexture];
    [DisplayUtils keepCenter:bgSprite contentSize:self.size aspectFit:YES];
    bgSprite.userInteractionEnabled = YES;
    [self addChild:bgSprite];
    
    SKTexture* waterTexture = [SKTexture textureWithImageNamed:@"fishing_foreground"];
    CGSize realWaterSize = [DisplayUtils adaptiveSize:waterTexture.size contentSize:self.size aspectFit:YES];
    _water = [[ScrollImage alloc] initWithImageNamed:@"fishing_foreground" speedPerSec:-30 size:realWaterSize];
    _water.position = CGPointMake(0, (realWaterSize.height - self.size.height) / 2);
    [self addChild:_water];
    [_updateArr addObject:_water];
    
    _fishPool = [[SKNode alloc] init];
    [self addChild:_fishPool];
    
    _rabbit = [[GameRabbit alloc] initWithImageNamed:@"fishing_rabbit_img"];
    _rabbit.size = CGSizeMake(248, 124);
    _rabbit.position = CGPointMake(0, 120);
    [self addChild:_rabbit];
    
    _hook = [[GameFishingHook alloc] init];
    _hook.zRotation = -PI / 2;
    _hook.position = CGPointMake(16, 148);
    _hook.hookLength = 80;
    [_updateArr addObject:_hook];
    [self addChild:_hook];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCatchHandler:) name:@"bomb" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMissHandler:) name:@"bomb" object:nil];
    
    NSLog(@"%@ %@", NSStringFromCGSize([UIScreen mainScreen].bounds.size), NSStringFromCGSize([AppDelegate appDelegate].mainSKView.scene.size));
}

-(void) onCatchHandler:(NSNotification*)notify {
    NSLog(@"notify");
//    notify.object;
}

-(void) onMissHandler:(NSNotification*)notify {
    
}


- (void)touchDownAtPoint:(CGPoint)pos {
    SKShapeNode *n = [_spinnyNode copy];
    n.position = pos;
    n.strokeColor = [SKColor greenColor];
    [self addChild:n];
}

- (void)touchMovedToPoint:(CGPoint)pos {
    SKShapeNode *n = [_spinnyNode copy];
    n.position = pos;
    n.strokeColor = [SKColor blueColor];
    [self addChild:n];
}

- (void)touchUpAtPoint:(CGPoint)pos {
    SKShapeNode *n = [_spinnyNode copy];
    n.position = pos;
    n.strokeColor = [SKColor redColor];
    [self addChild:n];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // Run 'Pulse' action from 'Actions.sks'
    [_label runAction:[SKAction actionNamed:@"Pulse"] withKey:@"fadeInOut"];
    
    for (UITouch *t in touches) {[self touchDownAtPoint:[t locationInNode:self]];}
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *t in touches) {[self touchMovedToPoint:[t locationInNode:self]];}
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {[self touchUpAtPoint:[t locationInNode:self]];}
    
//    _hook.hookLength += 10;
    _hook.actionHookLength += 10;
    
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {[self touchUpAtPoint:[t locationInNode:self]];}
}


-(void) update:(CFTimeInterval)currTime {
    [super update:currTime];
    !_lastUpdate && (_lastUpdate = currTime);
    if ([self.updateDelegate respondsToSelector:@selector(update:)])
        [self.updateDelegate update:currTime - _lastUpdate];
    
    if (_updateArr) {
        for (id<GameUpdateDelegate> ele in _updateArr) {
            [ele update:currTime - _lastUpdate];
        }
    }
    _lastUpdate = currTime;
    CFTimeInterval currTimeMS = currTime * 1000;
//    NSLog(@"%f", currTimeMS);
    
    if (AppDelegate.appDelegate) {
        AppDelegate.appDelegate.currentTime = currTime;
    }
    
    if (!_fishLastTimes || currTimeMS - _fishLastTimes > constFishGapTime) {
        _fishLastTimes = currTimeMS;
        NSUInteger modelId = 1 + (NSUInteger)(randomNum * 6);
        
        GameFishingIns * newFish = [GameFishingIns create:self fishId:modelId * 100 + _fishCounter posY:-SCENE_HEIGHT / 2 * randomNum];
        
        struct IWordData wordData = {@"", @"", _fishCounter % 2 == 0};
        newFish.data = wordData;
        [_fishPool addChild:newFish];
        _fishCounter++;
    }
}


@end
