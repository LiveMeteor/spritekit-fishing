//
//  DisplayUtils.h
//  fishing
//
//  Created by LiveMeteor on 2020/3/25.
//  Copyright © 2020 MMears. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DisplayUtils : NSObject

+(void) keepCenter:(SKSpriteNode*)target contentSize:(CGSize)contentSize aspectFit:(BOOL)aspectFit;
+(CGSize) adaptiveSize:(CGSize)tarSize contentSize:(CGSize)contentSize aspectFit:(BOOL)aspectFit;

@end

NS_ASSUME_NONNULL_END
