//
//  GameFishingHook.h
//  fishing
//
//  Created by LiveMeteor on 2020/4/2.
//  Copyright © 2020 MMears. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameScene.h"
#import "GameFishingIns.h"

NS_ASSUME_NONNULL_BEGIN

@interface GameFishingHook : SKNode <GameUpdateDelegate>

@property (nonatomic, assign) NSUInteger hookLength;
@property (nonatomic, assign) NSUInteger actionHookLength;
@property (nonatomic, weak, nullable) GameFishingIns* hangingFish;

/**
 鱼勾复位
 */
-(void) resetHook;
/**
 抓错鱼的勾子动画
 */
-(void) actionMissFishStartLength:(CGFloat)startLength onComplete:(void (^)(void))onComplete;

/**
 抛勾子动画
 */
-(void) actionThrewHook:(NSUInteger)endLength onComplete:(void (^)(void))onComplete;
/**
 抓对鱼的勾子动画
 */
-(void) actionCatchFishOnComplete:(void (^)(void))onComplete;

#pragma - GameUpdateDelegate
-(void) update:(CFTimeInterval)deltaTime;

@end

NS_ASSUME_NONNULL_END
