//
//  TimerManager.m
//  fishing
//
//  Created by LiveMeteor on 2020/3/26.
//  Copyright © 2020 MMears. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TimerManager.h"
@class TimerClock;

#pragma mark - TimerManager
@interface TimerManager ()

@end

@implementation TimerManager
+ (instancetype)shareInstance {
    static TimerManager *timeMan = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        timeMan = [[TimerManager alloc] init];
    });
    return timeMan;
}

-(TimerClock*) addClock:(NSString*)clockID seconds:(NSInteger)seconds {
    
}

-(TimerClock*) addClock:(NSString*)clockID seconds:(NSInteger)seconds updateDelay:(NSInteger)updateDelay repeatCount:(NSInteger)repeatCount totalSeconds:(NSInteger)totalSeconds speedFactor:(CGFloat)speedFactor {
    
}

-(void) removeClock:(NSString*)clockID {
    
}

-(TimerClock*) getClock:(NSString*)clockID {
    
}

-(TimerClock*) getClock:(NSString*)clockID autoCreate:(BOOL)autoCreate {
    
}

-(void) start {
    
}

-(void) stop:(NSString*)clockID {
    
}

-(void) pause:(NSString*)clockID {
    
}

-(void) resume:(NSString*)clockID {
    
}

-(void) tick:(CFTimeInterval)frameDelta {
    
}

-(void) checkActive {
    
}

@end

#pragma mark - TimerClock
@interface TimerClock ()

#pragma mark 是否正在运行
@property (nonatomic, assign) BOOL running;
#pragma mark TimerID
@property (nonatomic, strong) id timerId;
#pragma mark 单次总时间[毫秒单位]
@property (nonatomic, assign) NSInteger totalTime;
#pragma mark 速度系数
@property (nonatomic, assign) CGFloat speedFactor;
#pragma mark 重复次数
@property (nonatomic, assign) NSInteger repeatCount;
#pragma mark 当前次数
@property (nonatomic, assign) NSInteger currentCount;
#pragma mark 单次经历时间[毫秒单位]
@property (nonatomic, assign) NSInteger passedTime;

@end

@implementation TimerClock {
    NSInteger _updateDelay;
    NSInteger _currentUpdateDelay;
    NSInteger _passedUpdateTime;
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
        for (NSArray *cb in _callBackMap) {
            [self postProgress:cb];
        }
        if (_passedTime >= _totalTime) {
            _currentCount++;
            if (_currentCount > _repeatCount) {
                self.running = NO;
                for (NSArray *cb in _callBackMap) {
                    [self postComplete:cb];
                }
                onComplete();
            }
            else {
                _passedTime -= _totalTime;
            }
        }
    }
}

-(void) startRemaining:(NSInteger)seconds {
    [self startRemaining:seconds repeatCount:1 totalSeconds:-1 speedFactor:1.0];
}

-(void) startRemaining:(NSInteger)seconds repeatCount:(NSInteger)repeatCount totalSeconds:(NSInteger)totalSeconds speedFactor:(CGFloat)speedFactor {
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
        for (NSArray *cb in _callBackMap) {
            [self postComplete:cb];
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
    return [NSString stringWithFormat:@"%ld", _totalTime - _passedTime];
}


-(void) setPassedTime:(NSInteger)passedTime {
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
