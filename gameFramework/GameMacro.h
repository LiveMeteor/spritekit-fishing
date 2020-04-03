//
//  GameMacro.h
//  fishing
//
//  Created by LiveMeteor on 2020/3/25.
//  Copyright © 2020 MMears. All rights reserved.
//

#import "MathsUtils.h"
#import "AppDelegate.h"

#ifndef GameMacro_h
#define GameMacro_h

//MARK: 屏幕宽
#define SCREEN_WITDH [UIScreen mainScreen].bounds.size.width
//MARK: 屏幕高
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
//MARK: 当前场景宽
#define SCENE_WIDTH [AppDelegate appDelegate].mainSKView.scene.size.width
//MARK: 当前场景高
#define SCENE_HEIGHT [AppDelegate appDelegate].mainSKView.scene.size.height
//MARK: π
#define PI 3.1415927
//MARK: 角度转弧度
#define DEG2RAD(value) value / (180 / PI)
//MARK: 弧度转角度
#define RAD2DEG(value) 180 / PI * value

//MARK: 0-1之间的浮点随机数
#define randomNum [MathsUtils randomNum]
//MARK: 3位16进度数字颜色转 UIColor
#define HexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
//MARK: 4位16进度数字颜色转 UIColor
#define HexRGBAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]


#endif /* GameMacro_h */
