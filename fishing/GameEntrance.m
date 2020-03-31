//
//  GameEntrance.m
//  fishing
//
//  Created by LiveMeteor on 2020/3/27.
//  Copyright © 2020 MMears. All rights reserved.
//

#import "GameEntrance.h"
#import "GSimpleButton.h"
#import "GameScene.h"
#import "AppDelegate.h"

@implementation GameEntrance {
    GSimpleButton* _btnStart;
}

- (void)didMoveToView:(SKView *)view {
    _btnStart = (GSimpleButton*)[self childNodeWithName:@"//btnStart"];
//    _btnStart.onTouchHandler = @selector(onTouchStart);
    
    __weak typeof(self)weakself = self;
    _btnStart.onTouch = ^{
        [weakself onTouchStart];
    };
}

//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    for (UITouch *touch in touches) {
//        CGPoint pos = [touch locationInNode:self];
//        SKNode * node = [self nodeAtPoint:pos];
//        NSLog(@"%@", node.name);
//    }
//}

- (void) onTouchStart {
    NSLog(@"onTouchStart");
    
    // Load the SKScene from 'GameScene.sks'
    GameScene *scene = (GameScene *)[SKScene nodeWithFileNamed:@"GameScene"];
    // Set the scale mode to scale to fit the window
    scene.scaleMode = SKSceneScaleModeAspectFit;
    // Present the scene
    [[AppDelegate appDelegate].mainSKView presentScene:scene];
}

-(void)update:(CFTimeInterval)currentTime {
    [super update:currentTime];
}

@end
