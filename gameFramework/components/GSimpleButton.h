//
//  GSimpleButton.h
//  fishing
//
//  Created by LiveMeteor on 2020/3/30.
//  Copyright © 2020 MMears. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GSimpleButton : SKSpriteNode

@property (nonatomic, copy) void(^onTouch)(void);

+(instancetype) buttonWithImageNamed:(NSString *)name;

-(void) setTouchEndCallback:(SEL)func at:(id) funcSelf;

@end

NS_ASSUME_NONNULL_END
