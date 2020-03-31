//
//  MathsUtils.m
//  fishing
//
//  Created by LiveMeteor on 2020/3/31.
//  Copyright © 2020 MMears. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import "MathsUtils.h"

@implementation MathsUtils

+(CGFloat) randomNum {
    return (CGFloat)arc4random() / 0x100000000;
}

+(CGFloat) randomNumFrom:(CGFloat)fromNum to:(CGFloat)toNum {
    return (CGFloat)arc4random() / 0x100000000 * (toNum - fromNum) + fromNum;
}

@end
