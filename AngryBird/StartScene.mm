//
//  StartScene.m
//  AngryBird
//
//  Created by zoom on 14-7-12.
//  Copyright (c) 2014年 Jiance Tong. All rights reserved.
//

#import "StartScene.h"
#import "ParticleManager.h"
#import "LevelScene.h"

@implementation StartScene

+ (id) scene {
    CCScene *sc = [CCScene node];
    StartScene *ss = [StartScene node];
    [sc addChild:ss];
    return sc;
}
+ (id) node {
    return [[[[self class] alloc] init] autorelease];
}
- (id) init {
    self = [super init];
    if (self) {
        // create menu
        CGSize s = [[CCDirector sharedDirector] winSize];
        CCSprite *bgSprite = [CCSprite spriteWithFile:@"startbg.png"];
        [bgSprite setPosition:ccp(s.width/2.0f, s.height/2.0f)];
        [self addChild:bgSprite];
        
        CCSprite *angryBirdSprite = [CCSprite spriteWithFile:@"angrybird.png"];
        [angryBirdSprite setPosition:ccp(240.0f, 250.0f)];
        [self addChild:angryBirdSprite];
        

        CCSprite *beginSprite = [CCSprite spriteWithFile:@"start.png"];
        CCMenuItemSprite *beginMenuItem = [CCMenuItemSprite itemFromNormalSprite:beginSprite selectedSprite:nil target:self selector:@selector(beginGame:)];
        // create a memu section, will call the function beginGame
        
        CCMenu *menu = [CCMenu menuWithItems:beginMenuItem, nil];
        [menu setPosition:ccp(240.0f, 130.0f)];
        [self addChild:menu];
        //add the menu to the scene
        
        //add a scheduler
        [self schedule:@selector(tick:) interval:1.0f];
        
        
        CCParticleSystem *snow = [[ParticleManager sharedParticleManager] particleWithType:ParticleTypeSnow];
        [self addChild:snow];
    }
    return self;
}

- (void) tick:(double) dt {
    [self createOneBird];
}

- (void) createOneBird {
    // create a bird
    CCSprite *bird = [[CCSprite alloc] initWithFile:@"bird1.png"];
    [bird setScale:(arc4random()%5)/10.0f];
    //random the size of the bird
    [bird setPosition:ccp(50.0f+arc4random()%50, 70.0f)];
    // arc4random() used for random number
    CGPoint endPoint = ccp(360.0f+arc4random()%50, 70.0f);
    // set the end point for jumpTo
    CGFloat height = arc4random()%100+50.0f;
    CGFloat time = 2.0f;
    id actionJump = [CCJumpTo actionWithDuration:time position:endPoint height:height jumps:1];
    // create a jumpTo action
    id actionFinish = [CCCallFuncN actionWithTarget:self selector:@selector(actionFinish:)];
    // an action function for finish
    CCSequence *allActions = [CCSequence actions:actionJump, actionFinish, nil];
    // combine the two actions into a CCSequence
    [bird runAction:allActions];
    //run the Action
    
    [self addChild:bird];
    [bird release];
}

- (void) actionFinish:(CCNode *)currentNode {

    CCParticleSystem *explosition = [[ParticleManager sharedParticleManager] particleWithType:ParticleTypeBirdExplosion];
    [explosition setPosition:[currentNode position]];
    [self addChild:explosition];
    
    // delete the currentNode which is the bird
    //[self removeChild:currentNode cleanup:YES]; we can also use this
    [currentNode removeFromParentAndCleanup:YES];
}

- (void) beginGame:(id)arg {
    //NSLog(@"Start");
    
    CCScene *level = [LevelScene scene];
    CCTransitionScene *trans = [[CCTransitionSplitRows alloc] initWithDuration:1.0f scene:level];
    //trans is a trans scene the replace process is like the normal scene
    [[CCDirector sharedDirector] replaceScene:trans];
    [trans release];
}
@end
