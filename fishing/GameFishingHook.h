//
//  GameFishingHook.h
//  fishing
//
//  Created by LiveMeteor on 2020/4/2.
//  Copyright © 2020 MMears. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameScene.h"

NS_ASSUME_NONNULL_BEGIN

@interface GameFishingHook : SKNode <GameUpdateDelegate>

@property (nonatomic, assign) NSUInteger hookLength;
@property (nonatomic, assign) NSUInteger actionHookLength;

-(void)update:(CFTimeInterval)deltaTime;

@end

NS_ASSUME_NONNULL_END
