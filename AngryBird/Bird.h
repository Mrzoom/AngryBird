//
//  Bird.h
//  AngryBird
//
//  Created by zoom on 14-7-18.
//  Copyright (c) 2014年 Jiance Tong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Box2D.h"

#import "SpriteBase.h"

@interface Bird : SpriteBase
{
    BOOL _isFly;
    BOOL _isReady;
}
@property (nonatomic, assign) BOOL isFly;
@property (nonatomic, assign) BOOL isReady;

-(void)setSpeedX:(float)x andY:(int)y andWorld:(b2World*)world;
-(void)hitAnimationX:(float)x andY:(float)y;


@end
