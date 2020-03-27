//
//  GameScene.h
//  fishing
//
//  Created by LiveMeteor on 2020/3/20.
//  Copyright © 2020 MMears. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "TimerManager.h"

@protocol GameUpdateDelegate <NSObject>

-(void)update:(CFTimeInterval)deltaTime;

@end

@interface GameScene : SKScene

@property (nonatomic, weak) id<GameUpdateDelegate> updateDelegate;
@property (nonatomic, strong) TimerManager* timerMng;

@end
