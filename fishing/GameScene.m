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

@implementation GameScene {
    SKShapeNode* _spinnyNode;
    SKLabelNode* _label;
    
    NSMutableArray* _updateArr;
    CFTimeInterval _lastUpdate;
    
    ScrollImage* _water;
}

- (void)didMoveToView:(SKView *)view {
    _lastUpdate = 0;
    self.timerMng = [TimerManager shareInstance];
    [_timerMng start];
    self.updateDelegate = (id)[TimerManager shareInstance];
    
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
    
    SKTexture* bgTexture = [SKTexture textureWithImageNamed:@"fishing_bg"];
    SKSpriteNode *bgSprite = [[SKSpriteNode alloc] initWithTexture:bgTexture];
    [DisplayUtils keepCenter:bgSprite contentSize:self.size aspectFit:YES];
    bgSprite.userInteractionEnabled = YES;
    [self addChild:bgSprite];
    
    _updateArr = [NSMutableArray array];
    
    SKTexture* waterTexture = [SKTexture textureWithImageNamed:@"fishing_foreground"];
    CGSize realWaterSize = [DisplayUtils adaptiveSize:waterTexture.size contentSize:self.size aspectFit:YES];
    _water = [[ScrollImage alloc] initWithImageNamed:@"fishing_foreground" speedPerSec:-30 size:realWaterSize];
    _water.position = CGPointMake(0, (realWaterSize.height - self.size.height) / 2);
    [self addChild:_water];
    
    [_updateArr addObject:_water];
    
    TimerClock *clock = [[TimerManager shareInstance] addClock:@"Test1" seconds:20];
    [clock registCallBack:self onComplete:^{
        NSLog(@"timer complete");
    } onProgress:^(CGFloat progress){
        NSLog(@"progress: %ld", [clock leftTime]);
    }];
    
    NSLog(@"%@", NSStringFromCGSize([UIScreen mainScreen].bounds.size));
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
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {[self touchUpAtPoint:[t locationInNode:self]];}
}


-(void)update:(CFTimeInterval)currentTime {
    [super update:currentTime];
    !_lastUpdate && (_lastUpdate = currentTime);
    if ([self.updateDelegate respondsToSelector:@selector(update:)])
        [self.updateDelegate update:currentTime - _lastUpdate];
    
    if (_updateArr) {
        for (id ele in _updateArr) {
            [ele update:currentTime - _lastUpdate];
        }
    }
    _lastUpdate = currentTime;
    
    if (AppDelegate.appDelegate) {
        AppDelegate.appDelegate.currentTime = currentTime;
    }
}

@end
