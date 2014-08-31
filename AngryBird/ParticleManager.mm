//
//  ParticleManager.m
//  AngryBird
//
//  Created by zoom on 14-7-13.
//  Copyright (c) 2014年 Jiance Tong. All rights reserved.
//

#import "ParticleManager.h"

static ParticleManager *s;
@implementation ParticleManager
+ (id) sharedParticleManager {
    if (s == nil) {
        s = [[ParticleManager alloc] init];
    }
    return s;
}
- (CCParticleSystem *) particleWithType:(ParticleTypes)type {
    CCParticleSystem *system = nil;
    //useful exercise for using particle effect
    switch (type) {
        case ParticleTypeSnow:
        {
            system = [CCParticleSnow node];
            CCTexture2D *t = [[CCTextureCache sharedTextureCache] addImage:@"snow.png"];
            [system setTexture:t];
        }
            break;
        case ParticleTypeBirdExplosion:
        {
            system = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"bird-explosion.plist"];
            [system setPositionType:kCCPositionTypeFree];
            [system setAutoRemoveOnFinish:YES];
        }
            break;
        default:
            break;
    }
    return system;
}
@end
