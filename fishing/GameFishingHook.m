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
    BOOL _actionRunning;
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

-(void) setHookLength:(NSUInteger)hookLength {
    _actionRunning && (_actionRunning = NO);
    [self updateHookLength:hookLength];
    _actionHookLength = _hookLength;
}

-(void) updateHookLength:(NSUInteger)hookLength {
    _hookLength = MAX(hookLength, imgHookLength);
    _cable.xScale = ((CGFloat)_hookLength - imgHookLength) / oriCableLength;
    _imgHook.position = CGPointMake(_hookLength - imgHookLength, -3);
}

-(void) setActionHookLength:(NSUInteger)actionHookLength {
    if (_actionHookLength == actionHookLength)
        return;
    _actionHookLength = MAX(actionHookLength, imgHookLength);
    _actionRunning = YES;
}

-(void)update:(CFTimeInterval)deltaTime {
    if (_actionRunning) {
        NSUInteger step;
        if (_actionHookLength < _hookLength) {
            step = MAX(-1, _actionHookLength - _hookLength);
            [self updateHookLength:(_hookLength + step)];
        }
        else if (_actionHookLength > _hookLength) {
            step = MIN(1, _actionHookLength - _hookLength);
            [self updateHookLength:(_hookLength + step)];
        }
        else {
            _actionRunning = NO;
        }
    }
}



@end
