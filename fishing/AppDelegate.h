//
//  AppDelegate.h
//  fishing
//
//  Created by LiveMeteor on 2020/3/20.
//  Copyright © 2020 MMears. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, assign) CFTimeInterval currentTime;
@property (nonatomic, strong) SKView *mainSKView;

+(instancetype) appDelegate;

@end

