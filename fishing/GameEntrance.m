//
//  GameEntrance.m
//  fishing
//
//  Created by LiveMeteor on 2020/3/27.
//  Copyright © 2020 MMears. All rights reserved.
//

#import "GameEntrance.h"

@implementation GameEntrance {
    SKSpriteNode* _btnStart;
}

- (void)didMoveToView:(SKView *)view {
    _btnStart = (SKSpriteNode*)[self childNodeWithName:@"//btnStart"];
//    _btnStart.userInteractionEnabled = YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint pos = [touch locationInNode:self];
        SKNode * node = [self nodeAtPoint:pos];
        
        NSLog(@"%@", node.name);
        
    }
}

-(void)update:(CFTimeInterval)currentTime {
    [super update:currentTime];
}

@end
