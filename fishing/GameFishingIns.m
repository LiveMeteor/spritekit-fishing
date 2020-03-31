//
//  GameFishingIns.m
//  fishing
//
//  Created by LiveMeteor on 2020/3/30.
//  Copyright © 2020 MMears. All rights reserved.
//

#import "GameFishingIns.h"
#import "GameFishingModel.h"
#import "TimerManager.h"
#import "GameMacro.h"

typedef enum: NSInteger {
    Normal = 0,
    Correct = 1,
    Wrong = 2,
    GoHome = 3,
    Release = 4
} FishStatus;

@implementation GameFishingIns {
    SKSpriteNode * _fishImg;
    SKSpriteNode * _wordImg;
    
    NSUInteger _fishId;
    FishStatus _status;
    NSUInteger _leftTime;
    NSUInteger _swingCycle;
    NSInteger _posY;
    TimerClock *_clock;
    
}

+ (instancetype)create:(SKNode*)parent fishId:(NSUInteger)fishId posY:(NSInteger)posY {
    GameFishingIns * fish = [[GameFishingModel shareInstance] getFishFromPool];
    [fish activate:fishId leftTime:(NSInteger)(SCREEN_WITDH + randomNum * 1000) posY:posY];
    NSLog(@"create fish fishId=%lu posY=%ld", fishId, posY);
    return fish;
}

-(instancetype) init {
    if (self = [super init]) {
        self.userInteractionEnabled = YES;
        _fishImg = [[SKSpriteNode alloc] init];
        [self addChild:_fishImg];
        _wordImg = [[SKSpriteNode alloc] init];
        [self addChild:_wordImg];
    }
    return self;
}

-(void) activate:(NSUInteger)fishId leftTime:(NSUInteger)leftTime posY:(NSInteger)posY {
    _fishId = fishId;
    _status = Normal;
    NSUInteger fishModelId = floorf((float)fishId / 100);
    SKTexture *fishTexture = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"fishing_fish%lu.png", fishModelId]];
    _fishImg.texture = fishTexture;
    _fishImg.size = CGSizeMake(fishTexture.size.width, fishTexture.size.height);
    _fishImg.xScale = _fishImg.yScale = 0.5;
//    NSLog(@"%@", NSStringFromCGRect(self.frame));
    
    _leftTime = leftTime;
    _swingCycle = SCREEN_WITDH * (0.8 + randomNum + 0.5);
    _posY = posY;
    _fishImg.position = CGPointMake(200, _posY);
    
//    _clock = [[TimerManager shareInstance] addClock:[NSString stringWithFormat:@"fish%lu", _fishId] seconds:(CGFloat)_leftTime / 1000  updateDelay: 10];
//    __weak typeof(self) weakself = self;
//    [_clock registCallBack:self onComplete:^{
//        [weakself willDie];
//    } onProgress:^(CGFloat progress) {
//        [weakself update:progress];
//    }];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    for (UITouch *t in touches) {
        NSLog(@"touch end");
//    }
}

- (void) setData:(struct IWordData)data {
    _data = data;
}

- (void) update:(CGFloat) progress {
    if (_status != Normal)
        return;
    
    CGFloat x = (SCREEN_WITDH + 100) * (1 - progress) - 100;
    CGFloat y = _posY + sinf(SCREEN_WITDH * 2 * progress * (2 * 3.1415927 / _swingCycle)) * 60;
    self.position = CGPointMake(x, y);
}

- (void) willDie {
    if (_status == Correct || _status == Release)
        return;
    [self releaseFish];
}

- (void) releaseFish {
    if (_status == Release)
        return;
    if (_clock) {
        [_clock removeCallBack:self];
        [[TimerManager shareInstance] removeClock:[NSString stringWithFormat:@"fish%lu", _fishId]];
        _clock = nil;
    }
    _fishImg.texture = nil;
    _wordImg.texture = nil;
    
    [self removeFromParent];
    [[GameFishingModel shareInstance] putFishToPool:self];
}



@end
