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

+(instancetype) create:(SKNode*)parent fishId:(NSUInteger)fishId posY:(NSInteger)posY;

@end

NS_ASSUME_NONNULL_END
