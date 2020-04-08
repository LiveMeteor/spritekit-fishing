//
//  GSimpleButton.m
//  fishing
//
//  Created by LiveMeteor on 2020/3/30.
//  Copyright © 2020 MMears. All rights reserved.
//

#import "GSimpleButton.h"

@implementation GSimpleButton {
    IMP _impOnTouchHandler;
}

+ (instancetype)buttonWithImageNamed:(NSString *)name {
    GSimpleButton * ins = [self spriteNodeWithImageNamed:name];
    ins.userInteractionEnabled = YES;
    return ins;
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)setTouchEndCallback:(SEL)func at:(id) funcSelf {
    _impOnTouchHandler = [funcSelf methodForSelector:func];
}

- (void)touchAtPoint:(UITouch*)touch point:(CGPoint)pos {
    switch (touch.phase) {
        case UITouchPhaseBegan:
            self.colorBlendFactor = 0.1;
            break;
        case UITouchPhaseMoved:
        
            break;
        case UITouchPhaseStationary:
            //NOTHING
            break;
        case UITouchPhaseEnded:
        case UITouchPhaseCancelled:
            self.colorBlendFactor = 0;
            break;
        default:
            break;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {
        [self touchAtPoint:t point:[t locationInNode:self]];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *t in touches) {
        [self touchAtPoint:t point:[t locationInNode:self]];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {
        [self touchAtPoint:t point:[t locationInNode:self]];
        if (_impOnTouchHandler) {
            _impOnTouchHandler();
        }
        if (_onTouch) {
            _onTouch();
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {
        [self touchAtPoint:t point:[t locationInNode:self]];
    }
}

- (void) dealloc {
    _impOnTouchHandler = nil;
}

@end
