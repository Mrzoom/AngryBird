//
//  Pig.m
//  AngryBird
//
//  Created by zoom on 14-7-18.
//  Copyright (c) 2014年 Jiance Tong. All rights reserved.
//

#import "Pig.h"

@implementation Pig
-(id)initWithX:(float)x andY:(float)y andWorld:(b2World*)world andLayer:(CCLayer <SpriteDelegate> *)layer{
    myWorld = world;
    imageUrl = @"pig1";
    myLayer = layer;
    self = [super initWithFile:[NSString stringWithFormat:@"%@.png",imageUrl]];
    self.position = ccp(x, y);
    self.tag = PIG_ID;
    HP = 1;
    float scale = 2;
    
    self.scale = scale/10;
    
    
    b2BodyDef ballBodyDef;
    ballBodyDef.type = b2_dynamicBody;
    ballBodyDef.position.Set(x/PTM_RATIO, y/PTM_RATIO);
    ballBodyDef.userData = self;
    b2Body * ballBody = world->CreateBody(&ballBodyDef);    
    myBody = ballBody;
    
    float size = 0.12f;
    //set the pig's b2body to be polygon
    b2PolygonShape blockShape;
    b2Vec2 vertices[] = {
        b2Vec2(size ,-2*size),
        b2Vec2(2*size,-size),
        b2Vec2(2*size,size),
        
        b2Vec2(size,2*size),
        b2Vec2(-size,2*size),
        b2Vec2(-2*size,size),
        b2Vec2(-2*size,-size),
        b2Vec2(-size,-2*size)
    };
    blockShape.Set(vertices, 8);
    
    // Create shape definition and add to body
    b2FixtureDef ballShapeDef;
    ballShapeDef.shape = &blockShape;
    ballShapeDef.density = 80.0f;
    ballShapeDef.friction = 80.0f;
    ballShapeDef.restitution = 0.15f;
    ballBody->CreateFixture(&ballShapeDef);

    
    return self;
}
@end
