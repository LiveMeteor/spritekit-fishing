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
#import "AppDelegate.h"

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [AppDelegate appDelegate].mainSKView = (SKView *)self.view;

    GameEntrance *entrance = (GameEntrance*)[SKScene nodeWithFileNamed:@"GameEntrance"];
    entrance.scaleMode = SKSceneScaleModeResizeFill;
    [[AppDelegate appDelegate].mainSKView presentScene:entrance];
    
    ((SKView *)self.view).showsFPS = YES;
    ((SKView *)self.view).showsNodeCount = YES;
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
