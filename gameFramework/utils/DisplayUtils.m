//
//  DisplayUtils.m
//  fishing
//
//  Created by LiveMeteor on 2020/3/25.
//  Copyright © 2020 MMears. All rights reserved.
//

#import "DisplayUtils.h"

@implementation DisplayUtils

/** 锚点居中，且相对于容器居中
@param target 需要居中的对象
@param contentSize 容器尺寸
@param aspectFit 适配规则 YES 留空 NO 裁剪
*/
+(void) keepCenter:(SKSpriteNode*)target contentSize:(CGSize)contentSize aspectFit:(BOOL)aspectFit {
    CGSize tarSize = target.size;
    tarSize = [self adaptiveSize:tarSize contentSize:contentSize aspectFit:aspectFit];
    target.size = tarSize;
    //中心对齐不需要下面三行
//    CGFloat posX =((int)contentSize.width - (int)tarSize.width) >> 1;
//    CGFloat posY =((int)contentSize.height - (int)tarSize.height) >> 1;
//    target.position = CGPointMake(posX, posY);
}

/** 计算目标尺寸适配到容器尺寸时，应该有的不变形尺寸
 @param tarSize 目标尺寸
 @param contentSize 容器尺寸
 @param aspectFit 适配规则 YES 留空 NO 裁剪
 */
+(CGSize) adaptiveSize:(CGSize)tarSize contentSize:(CGSize)contentSize aspectFit:(BOOL)aspectFit {
    CGFloat widthRatio = contentSize.width / tarSize.width;
    CGFloat heightRatio = contentSize.height / tarSize.height;
    CGFloat scale = aspectFit ? MIN(widthRatio, heightRatio) : MAX(widthRatio, heightRatio);
    return CGSizeMake(tarSize.width * scale, tarSize.height * scale);
}



@end
