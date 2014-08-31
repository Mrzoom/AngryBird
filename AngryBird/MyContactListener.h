//
//  MyContactListener.h
//  AngryBird
//
//  Created by zoom on 14-7-26.
//  Copyright (c) 2014年 Jiance Tong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Box2D.h"
#import "cocos2d.h"
#import "SpriteBase.h"
#import "Bird.h"


class MyContactListener : public b2ContactListener {
    
public:
    b2World *_world;
    CCLayer *_layer;
    MyContactListener();
    MyContactListener(b2World *w, CCLayer *c);
    ~MyContactListener();
    
    virtual void BeginContact(b2Contact* contact);
    virtual void EndContact(b2Contact* contact);
    virtual void PreSolve(b2Contact* contact, const b2Manifold* oldManifold);
    virtual void PostSolve(b2Contact* contact, const b2ContactImpulse* impulse);
};
