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

@property (nonatomic, strong) void(^onTouch)(void);

@property (nonatomic, assign) SEL onTouchHandler;

+ (instancetype)buttonWithImageNamed:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
