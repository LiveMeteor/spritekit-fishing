//
//  ScrollImage.m
//  fishing
//
//  Created by LiveMeteor on 2020/3/25.
//  Copyright © 2020 MMears. All rights reserved.
//

#import "ScrollImage.h"
#import "DisplayUtils.h"

@interface ScrollImage()

@property (nonatomic, copy) NSString* imageName;
@property (nonatomic, strong) SKTexture* texture;
@property (nonatomic, strong) SKSpriteNode* sprite1;
@property (nonatomic, strong) SKSpriteNode* sprite2;

@end

@implementation ScrollImage {
    
}

-(instancetype) initWithImageNamed:(NSString*)name
{
    self = [super init];
    if (self)
    {
        _imageName = name;
        [self initialize];
    }
    return self;
}

-(instancetype) initWithImageNamed:(NSString*)name speedPerSec:(CGFloat)speed size:(CGSize)size
{
    self = [self initWithImageNamed:name];
    if (self) {
        self.speedPerSec = speed;
        self.size = size;
    }
    return self;
}

-(void) initialize
{
    _texture = [SKTexture textureWithImageNamed:_imageName];
    
    _sprite1 = [[SKSpriteNode alloc] initWithTexture:_texture];
    _sprite1.position = CGPointMake(0, 0);
    [self addChild:_sprite1];
    _sprite2 = [[SKSpriteNode alloc] initWithTexture:_texture];
    _sprite2.position = CGPointMake(_sprite1.position.x + _texture.size.width, 0);
    [self addChild:_sprite2];
    
    
}

-(void) setSize:(CGSize)size
{
    _size = size;
    [DisplayUtils keepCenter:_sprite1 contentSize:size aspectFit:YES];
    [DisplayUtils keepCenter:_sprite2 contentSize:size aspectFit:YES];
    _sprite1.position = CGPointMake(0, 0);
    _sprite2.position = CGPointMake(_sprite1.position.x + size.width, 0);
//    _sprite1.size = CGSizeMake(size.width, size.height);
//    _sprite2.size = CGSizeMake(size.width, size.height);
}

-(void) update:(CFTimeInterval)deltaTime
{
    CGFloat distance = _speedPerSec / (1 / deltaTime);
    [self moveSprite:_sprite1 distance:distance];
    [self moveSprite:_sprite2 distance:distance];
}

-(void) moveSprite:(SKSpriteNode*)sprite distance:(CGFloat)distance
{
    CGFloat posX = sprite.position.x + distance;
    if (posX < -sprite.size.width)
        posX += sprite.size.width * 2;
    else if (posX > sprite.size.width)
        posX -= sprite.size.width * 2;
    sprite.position = CGPointMake(posX, sprite.position.y);
}

-(void) dealloc
{
    [_sprite1 removeFromParent];
    _sprite1 = nil;
    [_sprite2 removeFromParent];
    _sprite2 = nil;
    _texture = nil;
    _imageName = nil;
}

@end
