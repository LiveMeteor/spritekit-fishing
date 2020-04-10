//
//  NetUtils.m
//  fishing
//
//  Created by LiveMeteor on 2020/4/10.
//  Copyright © 2020 MMears. All rights reserved.
//

#import "NetUtils.h"

@implementation NetUtils

+(void) getDataFromURL:(NSString*)urlString onData:(void(^)(NSDate * _Nullable data)) onData {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSURL *url = [NSURL URLWithString:urlString];
        id urlData = [NSData dataWithContentsOfURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            onData(urlData);
        });
    });
}

+(void) getDataFromURLOpration:(NSString*)urlString onData:(void(^)(NSDate * _Nullable data)) onData {
    NSBlockOperation *netTask = [NSBlockOperation blockOperationWithBlock:^{
        NSURL *url = [NSURL URLWithString:urlString];
        id urlData = [NSData dataWithContentsOfURL:url];
        
        NSOperationQueue * mainQueue = [NSOperationQueue mainQueue];
        [mainQueue addOperationWithBlock:^{
            onData(urlData);
        }];
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:netTask];
}

@end
