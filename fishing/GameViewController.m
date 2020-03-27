//
//  GameViewController.m
//  fishing
//
//  Created by LiveMeteor on 2020/3/20.
//  Copyright © 2020 MMears. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"
#import "GameEntrance.h"
#import "TimerManager.h"

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Load the SKScene from 'GameScene.sks'
//    GameScene *scene = (GameScene *)[SKScene nodeWithFileNamed:@"GameScene"];
    // Set the scale mode to scale to fit the window
//    scene.scaleMode = SKSceneScaleModeAspectFill;
    // Present the scene
//    [skView presentScene:scene];
    
    GameEntrance *entrance = (GameEntrance*)[SKScene nodeWithFileNamed:@"GameEntrance"];
    entrance.scaleMode = SKSceneScaleModeAspectFill;
    
    
    SKView *skView = (SKView *)self.view;
    [skView presentScene:entrance];
    
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
}

- (void) registCallBack:(id)target onComplete:(void (^)(void))onComplete onProgress:(nullable void (^)(CGFloat progress))onProgress {
    
    
}
- (void)registerClass {
    [self registCallBack:self onComplete:^{
        
    } onProgress:^(CGFloat progress) {
        
    }];
    
}
- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
