//
//  GameScene.h
//  AngryBird
//
//  Created by zoom on 14-7-17.
//  Copyright (c) 2014年 Jiance Tong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "JsonParser.h"
#import "SpriteBase.h"
#import "Bird.h"
#import "Pig.h"
#import "Ice.h"
#import "SlingShot.h"
#import "MyContactListener.h"
#import "LevelScene.h"
#import "GameUtil.h"

@interface GameScene : CCLayer
<SpriteDelegate, CCTargetedTouchDelegate>
{
    int currentLevel;
    CCLabelTTF *scoreLable;
    int score;
    NSMutableArray *birds;
    
    Bird *currentBird;
    BOOL gameStart;
    BOOL gameFinish;
    BOOL isWin;
    
    SlingShot *slingShot;
    int touchStatus;
    
    /* world */
    b2World* world;
    
    // collision listener
    MyContactListener *contactListener;
}


+ (id) sceneWithLevel:(int)level;
- (id) initWithLevel:(int)level;

@end
