//
//  ParticleManager.h
//  AngryBird
//
//  Created by zoom on 14-7-13.
//  Copyright (c) 2014年 Jiance Tong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


typedef enum {
    ParticleTypeSnow,
    ParticleTypeBirdExplosion,
    ParticleTypeMax
} ParticleTypes;

@interface ParticleManager : NSObject
+ (id) sharedParticleManager;
// 取得单例对象
- (CCParticleSystem *) particleWithType:(ParticleTypes)type;
// 取得指定type的粒子对象


@end
