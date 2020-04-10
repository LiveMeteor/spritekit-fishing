//
//  NetUtils.h
//  fishing
//
//  Created by LiveMeteor on 2020/4/10.
//  Copyright © 2020 MMears. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetUtils : NSObject

+(void) getDataFromURL:(NSString*)urlString onData:(void(^)(NSDate * _Nullable data)) onData;

+(void) getDataFromURLOpration:(NSString*)urlString onData:(void(^)(NSDate * _Nullable data)) onData;

@end

NS_ASSUME_NONNULL_END
