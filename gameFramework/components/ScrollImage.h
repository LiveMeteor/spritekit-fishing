//
//  ScrollImage.h
//  fishing
//
//  Created by LiveMeteor on 2020/3/25.
//  Copyright © 2020 MMears. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameScene.h"

NS_ASSUME_NONNULL_BEGIN

@interface ScrollImage : SKNode <GameUpdateDelegate>

@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat speedPerSec;

-(instancetype) initWithImageNamed:(NSString*)name;
-(instancetype) initWithImageNamed:(NSString*)name speedPerSec:(CGFloat)speed size:(CGSize)size;

-(void) update:(CFTimeInterval)deltaTime;

@end

NS_ASSUME_NONNULL_END
