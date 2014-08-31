//
//  LevelScene.m
//  AngryBird
//
//  Created by zoom on 14-7-15.
//  Copyright (c) 2014年 Jiance Tong. All rights reserved.
//

#import "LevelScene.h"
#import "StartScene.h"
#import "GameUtil.h"
#import "GameScene.h"

@implementation LevelScene

+ (id) scene {
    CCScene *sc = [CCScene node];
    LevelScene *ls = [[LevelScene alloc] init];
    [sc addChild:ls];
    [ls release];
    return sc;
}

- (id) init {
    self = [super init];
    if (self) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        CCSprite *sp = [CCSprite spriteWithFile:@"selectlevel.png"];
        sp.position = ccp(winSize.width/2.0f, winSize.height/2.0f);
        [self addChild:sp];
        
        CCSprite *backsp = [CCSprite spriteWithFile:@"backarrow.png"];
        backsp.position = ccp(40.0f, 40.0f);
        backsp.scale = 0.5f;
        backsp.tag = 100;
        [self addChild:backsp];
        
        [self setIsTouchEnabled:YES];
        //enable the touch
        
        //[GameUtil writeLevelToFile:1];
        successLevel = [GameUtil readLevelFromFile];
        NSString *imgPath = nil;
        for (int i = 0; i < 14; i++) {
            if (i < successLevel) {
                imgPath = @"level.png";
                NSString *str = [NSString stringWithFormat: @"%d", i+1];
                CCLabelTTF *numLabel = [CCLabelTTF labelWithString:str dimensions:CGSizeMake(60.0f, 60.0f) alignment:UITextAlignmentCenter fontName:@"Marker Felt" fontSize:30.0f];
                float x = 60+i%7*60;
                float y = 320-75-i/7*80;
                numLabel.position = ccp(x, y);
                [self addChild:numLabel z:2];
            } else {
                imgPath = @"clock.png";
            }
            CCSprite *levelSprite = [CCSprite spriteWithFile:imgPath];
            levelSprite.tag = i+1;
            float x = 60+i%7*60;
            float y = 320-60-i/7*80;
            levelSprite.position = ccp(x, y);
            levelSprite.scale = 0.6f;
            [self addChild:levelSprite z:1];
       }
        
    }
    return self;
}

//add the touch action
- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //get the touch point
    UITouch *oneTouch = [touches anyObject];
    UIView *touchView = [oneTouch view];
    // touchView is the glView
    CGPoint location = [oneTouch locationInView:touchView];
    CGPoint worldGlPoint = [[CCDirector sharedDirector] convertToGL:location];
    // change the ui point to world point
    CGPoint nodePoint = [self convertToNodeSpace:worldGlPoint];
    // change the world point to node point
    for (int i = 0; i < self.children.count; i++) {
        CCSprite *oneSprite = [self.children objectAtIndex:i];
        if (CGRectContainsPoint(oneSprite.boundingBox, nodePoint) && oneSprite.tag == 100) {
            //uing the tag vlaue and bounding check to decide call which scene
            //tag100==backspace
            CCScene *sc = [StartScene scene];
            CCTransitionScene *trans = [[CCTransitionSplitRows alloc] initWithDuration:1.0f scene:sc];
            [[CCDirector sharedDirector] replaceScene:trans];
            [trans release];
        } else if (CGRectContainsPoint(oneSprite.boundingBox, nodePoint) && (oneSprite.tag < successLevel+1) && oneSprite.tag >0) {
            //NSLog(@"choose level %d", oneSprite.tag);
            CCScene *sc = [GameScene sceneWithLevel:oneSprite.tag];
            [[CCDirector sharedDirector] replaceScene:sc];
        }
    }
}
@end
