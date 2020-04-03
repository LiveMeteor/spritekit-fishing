//
//  GameFishingIns.h
//  fishing
//
//  Created by LiveMeteor on 2020/3/30.
//  Copyright © 2020 MMears. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GameFishingIns : SKNode

@property (nonatomic, assign) struct IWordData data;

/**
 正成新鱼
 */
+(instancetype) create:(SKNode*)parent fishId:(NSUInteger)fishId posY:(NSInteger)posY;

/**
 点击正确结束
 */
-(void) playCorrectComplete;
/**
 点击错误结束
 */
-(void) playWrongComplete;

@end

NS_ASSUME_NONNULL_END
