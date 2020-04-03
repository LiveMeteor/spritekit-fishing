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
    
    CGFloat _actionMissFishStartLength;
    CFTimeInterval _actionMissFishStart;
    BOOL _actionMissFishRunning;
    void(^_actionMissFishCallback)(void);
    
    CGFloat _actionThrewHookStartLength;
    CGFloat _actionThrewHookEndLength;
    CFTimeInterval _actionThrewHookStart;
    BOOL _actionThrewHookRunning;
    void(^_actionThrewHookCallback)(void);
    
    CGFloat _actionCatchFishStartLength;
    CGFloat _actionCatchFishEndLength;
    CFTimeInterval _actionCatchFishStart;
    BOOL _actionCatchFishRunning;
    void(^_actionCatchFishCallback)(void);
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

-(void) actionMissFishStartLength:(CGFloat)startLength onComplete:(void (^)(void))onComplete {
    _actionMissFishStartLength = startLength;
    _actionMissFishStart = [AppDelegate appDelegate].currentTime;
    _actionMissFishRunning = YES;
    _actionMissFishCallback = onComplete;
}

-(void) actionThrewHook:(NSUInteger)endLength onComplete:(void (^)(void))onComplete {
    _actionThrewHookStartLength = _hookLength;
    _actionThrewHookEndLength = endLength;
    _actionThrewHookStart = [AppDelegate appDelegate].currentTime;
    _actionThrewHookRunning = YES;
    _actionThrewHookCallback = onComplete;
}

-(void) actionCatchFishOnComplete:(void (^)(void))onComplete {
    _actionCatchFishStartLength = _hookLength;
    _actionCatchFishEndLength = imgHookLength;
    _actionCatchFishStart = [AppDelegate appDelegate].currentTime;
    _actionCatchFishRunning = YES;
    _actionCatchFishCallback = onComplete;
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
            _actionMissFishStartLength = 0;
            _actionMissFishStart = 0;
            _actionMissFishRunning = NO;
            if (_actionMissFishCallback) {
                _actionMissFishCallback();
                _actionMissFishCallback = nil;
            }
        }
    }
#pragma mark 抛杆的动画
    if (_actionThrewHookRunning) {
        CFTimeInterval passTime = [AppDelegate appDelegate].currentTime - _actionThrewHookStart;
        if (passTime < 0.2) {
            [self updateHookLength:_actionThrewHookStartLength + (_actionThrewHookEndLength - _actionThrewHookStartLength) * passTime * 5];
        }
        else {
            _actionThrewHookStartLength = 0;
            _actionThrewHookEndLength = 0;
            _actionThrewHookStart = 0;
            _actionThrewHookRunning = NO;
            if (_actionThrewHookCallback) {
                _actionThrewHookCallback();
                _actionThrewHookCallback = nil;
            }
        }
    }
#pragma mark 抓到鱼的动画
    if (_actionCatchFishRunning) {
        CFTimeInterval passTime = [AppDelegate appDelegate].currentTime - _actionCatchFishStart;
        if (passTime < 1) {
            [self updateHookLength:_actionCatchFishStartLength + (_actionCatchFishEndLength - _actionCatchFishStartLength) * passTime];
        }
        else {
            _actionCatchFishStartLength = 0;
            _actionCatchFishEndLength = 0;
            _actionCatchFishStart = 0;
            _actionCatchFishRunning = NO;
            if (_actionCatchFishCallback) {
                _actionCatchFishCallback();
                _actionCatchFishCallback = nil;
            }
        }
    }
}

@end
