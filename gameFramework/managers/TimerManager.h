//
//  TimerManager.h
//  fishing
//
//  Created by LiveMeteor on 2020/3/26.
//  Copyright © 2020 MMears. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class TimerClock;
@interface TimerManager : NSObject

@property (nonatomic,assign) BOOL running;

+(instancetype) shareInstance;

/** 添加时钟
@param clockID 时钟ID
@param seconds 剩余秒数
@return TimerClock*
*/
-(TimerClock*) addClock:(NSString*)clockID seconds:(NSUInteger)seconds;
-(TimerClock*) addClock:(NSString*)clockID seconds:(NSUInteger)seconds updateDelay:(NSUInteger)updateDelay;

/** 添加时钟
 @param clockID 时钟ID
 @param seconds 剩余秒数
 @param updateDelay 更新频率【毫秒】
 @param repeatCount 重复次数
 @param totalSeconds 总秒数【当倒数到负数时使用】
 @param speedFactor 加速度系数【加减速运动】
 @return TimerClock*
 */
-(TimerClock*) addClock:(NSString*)clockID seconds:(NSUInteger)seconds updateDelay:(NSInteger)updateDelay repeatCount:(NSInteger)repeatCount totalSeconds:(NSInteger)totalSeconds speedFactor:(CGFloat)speedFactor;
-(void) removeClock:(NSString*)clockID;
-(TimerClock*) getClock:(NSString*)clockID;
-(TimerClock*) getClock:(NSString*)clockID autoCreate:(BOOL)autoCreate;
-(void) start;
-(void) stop:(NSString*)clockID;
-(void) pause:(nullable NSString*)clockID;
-(void) resume:(nullable NSString*)clockID;
-(void) update:(CFTimeInterval)deltaTime;

@end

#pragma mark - TimerClock
@interface TimerClock : NSObject
#pragma mark 是否正在运行
@property (nonatomic, assign) BOOL running;

-(instancetype) initWithId:timerId updateDelay:(NSInteger)updateDelay;
-(void) startRemaining:(NSUInteger)seconds;
-(void) startRemaining:(NSUInteger)seconds repeatCount:(NSInteger)repeatCount totalSeconds:(NSInteger)totalSeconds speedFactor:(CGFloat)speedFactor;
-(void) pause;
-(void) resume;
-(void) stop;
-(void) registCallBack:(id)target onComplete:(void (^)(void))onComplete onProgress:(nullable void (^)(CGFloat progress))onProgress;
-(void) removeCallBack:(id)target;
-(NSInteger) leftTime;
-(NSString *) leftTimeString;

-(void) update:(CGFloat)deltaTime onComplete:(void (^)(void))onComplete;
@end

NS_ASSUME_NONNULL_END
