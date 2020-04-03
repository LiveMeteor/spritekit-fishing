//
//  GameFishingHook.m
//  fishing
//
//  Created by LiveMeteor on 2020/4/2.
//  Copyright © 2020 MMears. All rights reserved.
//

#import "GameFishingHook.h"
#import "GameMacro.h"

static NSUInteger oriCableLength = 100;
static NSUInteger imgHookLength = 32;

@interface GameFishingHook()

@end

@implementation GameFishingHook {
    SKShapeNode * _cable;
    SKSpriteNode * _imgHook;
    
    BOOL _actionLengthRunning;
    
    BOOL _actionMissFishRunning;
    CGFloat _actionMissFishStartLength;
    CFTimeInterval _actionMissFishStart;
    void(^_actionMissFishCallback)(void);
}

-(instancetype) init {
    if (self = [super init]) {
        _actionHookLength = _hookLength = oriCableLength + imgHookLength;
        _cable = [SKShapeNode shapeNodeWithRect:CGRectMake(0, 0, oriCableLength, 3)];
        _cable.lineWidth = 0;
        _cable.fillColor = HexRGB(0x33334c);
        [self addChild:_cable];
        _imgHook = [[SKSpriteNode alloc] initWithImageNamed:@"fishing_hock"];
        _imgHook.anchorPoint = CGPointMake(0, 1);
        _imgHook.size = CGSizeMake(21, imgHookLength);
        _imgHook.zRotation = PI / 2;
        _imgHook.position = CGPointMake(oriCableLength, -3);
        [self addChild:_imgHook];
    }
    return self;
}

-(void) resetHook {
    self.zRotation = -PI / 2;
    self.hookLength = 80;
}

-(void) setHookLength:(NSUInteger)hookLength {
    _actionLengthRunning && (_actionLengthRunning = NO);
    [self updateHookLength:hookLength];
    _actionHookLength = _hookLength;
}

-(void) updateHookLength:(NSUInteger)hookLength {
    _hookLength = MAX(hookLength, imgHookLength);
    _cable.xScale = ((CGFloat)_hookLength - imgHookLength) / oriCableLength;
    _imgHook.position = CGPointMake(_hookLength - imgHookLength, -3);
    if (_hangingFish) {
        CGFloat posX = self.position.x + _hookLength * cosf(-self.zRotation);
        CGFloat posY = self.position.y - _hookLength * sinf(-self.zRotation);
        _hangingFish.position = CGPointMake(posX, posY);
    }
}

-(void) setActionHookLength:(NSUInteger)actionHookLength {
    if (_actionHookLength == actionHookLength)
        return;
    _actionHookLength = MAX(actionHookLength, imgHookLength);
    _actionLengthRunning = YES;
}

-(void) actionMissFish:(CGFloat)startLength onComplete:(void (^)(void))onComplete {
    _actionMissFishStartLength = startLength;
    _actionMissFishStart = [AppDelegate appDelegate].currentTime;
    _actionMissFishRunning = YES;
    _actionMissFishCallback = onComplete;
}

-(void) actionCatchFish:(CGFloat)startLength onComplete:(void (^)(void))onComplete {
    
    onComplete();
}

#pragma - GameUpdateDelegate
-(void)update:(CFTimeInterval)deltaTime {
#pragma mark 普通长度动画
    if (_actionLengthRunning) {
        NSUInteger step;
        if (_actionHookLength < _hookLength) {
            step = MAX(-1, _actionHookLength - _hookLength);
            [self updateHookLength:_hookLength + step];
        }
        else if (_actionHookLength > _hookLength) {
            step = MIN(1, _actionHookLength - _hookLength);
            [self updateHookLength:_hookLength + step];
        }
        else {
            _actionLengthRunning = NO;
        }
    }
#pragma mark 抓错的动画
    if (_actionMissFishRunning) {
        CFTimeInterval passTime = [AppDelegate appDelegate].currentTime - _actionMissFishStart;
        if (passTime < 0.1) {
            [self updateHookLength:_actionMissFishStartLength + 30 * passTime * 10];
        }
        else if (passTime >= 0.1 && passTime < 0.2) {
            passTime -= 0.1;
            [self updateHookLength:_actionMissFishStartLength + 30 * (1 - passTime * 10)];
        }
        else if (passTime >= 0.2 && passTime < 0.3) {
            passTime -= 0.2;
            [self updateHookLength:_actionMissFishStartLength + 30 * passTime * 10];
        }
        else {
            _actionMissFishStart = 0;
            _actionMissFishRunning = NO;
            if (_actionMissFishCallback) {
                _actionMissFishCallback();
                _actionMissFishCallback = nil;
            }
        }
    }
}

@end
