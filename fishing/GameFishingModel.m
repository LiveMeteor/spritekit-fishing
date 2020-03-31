//
//  GameFishingModel.m
//  fishing
//
//  Created by LiveMeteor on 2020/3/30.
//  Copyright © 2020 MMears. All rights reserved.
//

#import "GameFishingModel.h"

@implementation GameFishingModel {
    NSMutableArray<GameFishingIns *> * _inUseFishList;
    NSMutableArray<GameFishingIns *> * _availableFishList;
}

+ (instancetype)shareInstance {
    static GameFishingModel *model = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[GameFishingModel alloc] init];
    });
    return model;
}

-(instancetype) init {
    if (self == [super init]) {
        _inUseFishList = [NSMutableArray array];
        _availableFishList = [NSMutableArray array];
    }
    return self;
}

- (GameFishingIns*) getFishFromPool {
    GameFishingIns * fish;
    if (_availableFishList.count > 0) {
        fish = _availableFishList[0];
        [_availableFishList removeObject:fish];
    }
    else {
        fish = [[GameFishingIns alloc] init];
    }
    [_inUseFishList addObject:fish];
    return fish;
}

- (BOOL) putFishToPool:(GameFishingIns*) fish {
    if ([_inUseFishList containsObject:fish]) {
        [_inUseFishList removeObject:fish];
        if (fish.parent)
            [fish removeFromParent];
        [_availableFishList addObject:fish];
        return YES;
    }
    return NO;
}



@end
