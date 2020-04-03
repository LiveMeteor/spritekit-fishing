//
//  GameFishingModel.h
//  fishing
//
//  Created by LiveMeteor on 2020/3/30.
//  Copyright © 2020 MMears. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameFishingIns.h"

NS_ASSUME_NONNULL_BEGIN

struct IWordData {
    NSString * imageUrl;
    NSString * audioUrl;
    BOOL trueOpt;
};

/**
 每条鱼的间隔时间
 */
static const NSUInteger constFishGapTime = 1500;

@interface GameFishingModel : NSObject

+ (instancetype)shareInstance;

- (GameFishingIns*) getFishFromPool;
- (BOOL) putFishToPool:(GameFishingIns*) fish;

@end

NS_ASSUME_NONNULL_END
