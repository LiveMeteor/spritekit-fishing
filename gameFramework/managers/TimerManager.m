//
//  TimerManager.m
//  fishing
//
//  Created by LiveMeteor on 2020/3/26.
//  Copyright © 2020 MMears. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimerManager.h"
#import "AppDelegate.h"
#import "GameScene.h"

#pragma mark - TimerManager
@interface TimerManager () <GameUpdateDelegate>

@end

@implementation TimerManager {
    NSMutableDictionary *_clockMap;
    CFTimeInterval _lastTime;
    NSMutableArray *_preRemoveKeys;
}
+ (instancetype)shareInstance {
    static TimerManager *timerMng = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        timerMng = [[TimerManager alloc] init];
    });
    return timerMng;
}

-(instancetype) init {
    self = [super init];
    if (self) {
        _clockMap = [NSMutableDictionary dictionary];
        _lastTime = 0;
    }
    return self;
}

-(TimerClock*) addClock:(NSString*)clockID seconds:(NSUInteger)seconds {
    return [self addClock:clockID seconds:seconds updateDelay:1000 repeatCount:1 totalSeconds:-1 speedFactor:1];
}

-(TimerClock*) addClock:(NSString*)clockID seconds:(NSUInteger)seconds updateDelay:(NSUInteger)updateDelay {
    return [self addClock:clockID seconds:seconds updateDelay:updateDelay repeatCount:1 totalSeconds:-1 speedFactor:1];
}

-(TimerClock*) addClock:(NSString*)clockID seconds:(NSUInteger)seconds updateDelay:(NSInteger)updateDelay repeatCount:(NSInteger)repeatCount totalSeconds:(NSInteger)totalSeconds speedFactor:(CGFloat)speedFactor {
    TimerClock * clock = [_clockMap valueForKey:clockID];
    if (!clock) {
        clock  = [[TimerClock alloc] initWithId:clockID updateDelay:updateDelay];
        [_clockMap setValue:clock forKey:clockID];
    }
    [self start];
    [clock startRemaining:seconds repeatCount:repeatCount totalSeconds:totalSeconds speedFactor:speedFactor];
    return clock;
}

-(void) removeClock:(NSString*)clockID {
    TimerClock * clock = [_clockMap valueForKey:clockID];
    if (clock) {
        [clock stop];
        !_preRemoveKeys && (_preRemoveKeys = [NSMutableArray array]);
        [_preRemoveKeys addObject:clockID];
    }
}

-(TimerClock*) getClock:(NSString*)clockID {
    return [self getClock:clockID autoCreate:NO];
}

-(TimerClock*) getClock:(NSString*)clockID autoCreate:(BOOL)autoCreate {
    TimerClock * clock = [_clockMap valueForKey:clockID];
    if (autoCreate && !clock) {
        clock = [[TimerClock alloc] initWithId:clockID updateDelay:1000];
        [_clockMap setValue:clock forKey:clockID];
    }
    return clock;
}

-(void) start {
    if (self.running)
        return;
    
    _lastTime = AppDelegate.appDelegate.currentTime;
    self.running = true;
}

-(void) stop:(NSString*)clockID {
    if (!clockID) {
        if (!self.running)
            return;
        self.running = NO;
    }
    else {
        if ([_clockMap valueForKey:clockID]) {
            [[self getClock:clockID] stop];
        }
    }
}

-(void) pause:(nullable NSString*)clockID {
    if (!clockID) {
        if (!self.running)
            return;
        self.running = NO;
    }
    else {
        if ([_clockMap valueForKey:clockID]) {
            [[self getClock:clockID] pause];
        }
    }
}

-(void) resume:(nullable NSString*)clockID {
    if (!clockID) {
        if (self.running)
            return;
        self.running = YES;
        _lastTime = AppDelegate.appDelegate.currentTime;
    }
    else {
        if ([_clockMap valueForKey:clockID]) {
            [[self getClock:clockID] resume];
        }
    }
    
}

#pragma mark GameUpdateDelegate
-(void) update:(CFTimeInterval)deltaTime {
    if (!self.running)
        return;
    
//    CFTimeInterval currentTime = AppDelegate.appDelegate.currentTime;
//    CFTimeInterval passedTime = currentTime - _lastTime;
//    _lastTime = currentTime;
    
    for (NSString* key in _clockMap) {
        TimerClock * clock = [_clockMap valueForKey:key];
        if (clock.running) {
            [clock update:deltaTime * 1000 onComplete:^{
                [self checkActive];
            }];
        }
    }
    
    if (_preRemoveKeys && _preRemoveKeys.count > 0) {
        [_clockMap removeObjectsForKeys:_preRemoveKeys];
        _preRemoveKeys = nil;
    }
}

-(void) checkActive {
    NSInteger activeCount = 0;
    for (NSString* key in _clockMap) {
        activeCount += (((TimerClock*)[_clockMap valueForKey:key]).running ? 1 : 0);
    }
    
    if (activeCount == 0) {
        [self pause:nil];
    }
    else {
        [self resume:nil];
    }
}

@end

#pragma mark - TimerClock
@interface TimerClock ()

#pragma mark TimerID
@property (nonatomic, strong) id timerId;
#pragma mark 单次总时间[毫秒单位]
@property (nonatomic, assign) CGFloat totalTime;
#pragma mark 速度系数
@property (nonatomic, assign) CGFloat speedFactor;
#pragma mark 重复次数
@property (nonatomic, assign) NSInteger repeatCount;
#pragma mark 当前次数
@property (nonatomic, assign) NSInteger currentCount;
#pragma mark 单次经历时间[毫秒单位]
@property (nonatomic, assign) CGFloat passedTime;

@end

@implementation TimerClock {
    NSInteger _updateDelay;
    NSInteger _currentUpdateDelay;
    CGFloat _passedUpdateTime;
    NSMutableDictionary* _callBackMap;
}

-(instancetype) initWithId:timerId updateDelay:(NSInteger)updateDelay {
    self = [super init];
    if (self) {
        _totalTime = -1000;
        _speedFactor = 1;
        _callBackMap = [NSMutableDictionary dictionary];
        
        _running = NO;
        _timerId = timerId;
        _updateDelay = updateDelay;
    }
    return self;
}

-(void) update:(CGFloat)deltaTime onComplete:(void (^)(void))onComplete {
    if (!self.running)
        return;
    CGFloat time = deltaTime * _speedFactor;
    _passedTime += time;
    _passedUpdateTime += time;
    while (_passedUpdateTime > _currentUpdateDelay) {
        _passedUpdateTime -= _currentUpdateDelay;
        if (self.leftTime > 0) {
            _currentUpdateDelay = MIN(_currentUpdateDelay, self.leftTime);
        }
        for (NSString* key in _callBackMap) {
            [self postProgress:(NSArray*)[_callBackMap valueForKey:key]];
        }
        if (_passedTime >= _totalTime) {
            _currentCount++;
            if (_currentCount > _repeatCount) {
                self.running = NO;
                for (NSString* key in _callBackMap) {
                    [self postComplete:(NSArray*)[_callBackMap valueForKey:key]];
                }
                onComplete();
            }
            else {
                _passedTime -= _totalTime;
            }
        }
    }
}

-(void) startRemaining:(NSUInteger)seconds {
    [self startRemaining:seconds repeatCount:1 totalSeconds:-1 speedFactor:1.0];
}

-(void) startRemaining:(NSUInteger)seconds repeatCount:(NSInteger)repeatCount totalSeconds:(NSInteger)totalSeconds speedFactor:(CGFloat)speedFactor {
    if (self.running)
        [self stop];
    
    NSInteger _totalSeconds = (totalSeconds > 0) ? totalSeconds : seconds;
    _totalTime = _totalSeconds * 1000;
    _passedTime = (_totalSeconds - seconds) * 1000;
    _speedFactor = speedFactor;
    _currentCount = 1;
    _repeatCount = repeatCount;
    _currentUpdateDelay = MIN(_updateDelay, _totalTime);
    if (_totalTime > 0) {
        self.running = YES;
    }
    else {
        for (NSString* key in _callBackMap) {
            [self postComplete:(NSArray*)[_callBackMap valueForKey:key]];
        }
    }
}

-(void) pause {
    self.running = NO;
}

-(void) resume {
    self.running = YES;
}

-(void) stop {
    self.running = NO;
    _passedUpdateTime = 0;
    _passedTime = 0;
    _currentCount = 1;
}

#pragma mark 注册回调
-(void) registCallBack:(id)target onComplete:(void (^)(void))onComplete onProgress:(nullable void (^)(CGFloat progress))onProgress {
    NSString * tarHash = [NSString stringWithFormat:@"%lu", [target hash]];
    
    [_callBackMap setValue:@[onComplete, onProgress] forKey:tarHash];
    
    if (onProgress) {
        onProgress(self.progress);
    }
    if (onComplete && self.progress >= 1) {
        onComplete();
    }
}

-(CGFloat) progress {
    return _passedTime ? (CGFloat)_passedTime / _totalTime : 0;
}

#pragma mark 反注册回调
-(void) removeCallBack:(id)target {
    NSString * tarHash = [NSString stringWithFormat:@"%lu", [target hash]];
    [_callBackMap removeObjectForKey:tarHash];
}

#pragma mark 剩余时间[毫秒单位]
-(NSInteger) leftTime {
    return _totalTime - _passedTime;
}

#pragma mark 剩余时间格式化字符[毫秒单位]
-(NSString *) leftTimeString {
    return [NSString stringWithFormat:@"%f", _totalTime - _passedTime];
}


-(void) setPassedTime:(CGFloat)passedTime {
    _passedTime = MIN(passedTime, _totalTime);
}

-(void) postComplete:(NSArray*)value {
    void (^func)(void) = value[0];
    if (func) {
        func();
    }
}

-(void) postProgress:(NSArray*)value {
    void (^func)(CGFloat) = value[1];
    if (func) {
        func(self.progress);
    }
}

-(void) dealloc {
    [self stop];
    [_callBackMap removeAllObjects];
}

@end
