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
    [_btnStart setTouchEndCallback:@selector(onTouchStart) at:self];
    
//    __weak typeof(self)weakself = self;
//    _btnStart.onTouch = ^{
//        [weakself onTouchStart];
//    };
}

- (void) onTouchStart {
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
