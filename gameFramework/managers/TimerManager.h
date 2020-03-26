//
//  TimerManager.h
//  fishing
//
//  Created by LiveMeteor on 2020/3/26.
//  Copyright © 2020 MMears. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface TimerClock : NSObject

-(void) pause;
-(void) resume;
-(void) stop;
-(void) registCallBack:(id)target onComplete:(void (^)(void))onComplete onProgress:(nullable void (^)(CGFloat progress))onProgress;
-(void) removeCallBack:(id)target;

@end

@interface TimerManager : NSObject

@property (nonatomic,strong,readonly) TimerClock *timeClock;
@property (nonatomic,assign) BOOL *running;

+(instancetype) shareInstance;

-(TimerClock*) addClock:(NSString*)clockID seconds:(NSInteger)seconds;
-(TimerClock*) addClock:(NSString*)clockID seconds:(NSInteger)seconds updateDelay:(NSInteger)updateDelay repeatCount:(NSInteger)repeatCount totalSeconds:(NSInteger)totalSeconds speedFactor:(CGFloat)speedFactor;
-(void) removeClock:(NSString*)clockID;
-(TimerClock*) getClock:(NSString*)clockID;
-(TimerClock*) getClock:(NSString*)clockID autoCreate:(BOOL)autoCreate;
-(void) start;
-(void) stop:(NSString*)clockID;
-(void) pause:(NSString*)clockID;
-(void) resume:(NSString*)clockID;
-(void) tick:(CFTimeInterval)frameDelta;



@end

NS_ASSUME_NONNULL_END
