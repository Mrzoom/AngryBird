//
//  LoadingScene.m
//  AngryBird
//
//  Created by zoom on 14-7-12.
//  Copyright (c) 2014年 Jiance Tong. All rights reserved.
//

#import "LoadingScene.h"
#import "StartScene.h"

@implementation LoadingScene
+ (id) scene {
    CCScene *sc = [CCScene node];
    // create a new scene
    LoadingScene *ls = [LoadingScene node];
    // create a loading scene
    [sc addChild:ls];
    // add the loading scene to the base scene
    return sc;
}
+ (id) node {
    return [[[[self class] alloc] init] autorelease];
}
- (id) init {
    self = [super init];
    if (self) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        // get the size;
        // create a sprite with pic
        //CGRect constraint = CGRectMake(0,0,480, 320);
        CCSprite *sp = [CCSprite spriteWithFile:@"bj3.png"];
        //CGRect bounds=[sp textureRect];
        //NSLog(@"mainScreen bounds: %.0f, %.0f, %3.0f, %3.0f",bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height);
        [sp setPosition:ccp(winSize.width/2.0f, winSize.height/2.0f)];
        // set the middle point
        [self addChild:sp];
        
        loadingTitle = [[CCLabelBMFont alloc] initWithString:@"Loading" fntFile:@"arial16.fnt"];
        // using string arial16.fnt for @"Loading"
        [loadingTitle setAnchorPoint:ccp(0.0f, 0.0f)];
        //set the anchor point for loadingTitle
        [loadingTitle setPosition:ccp(winSize.width-80.0f, 10.0f)];
        // set position
        [self addChild:loadingTitle];
        // animatioon every 1s
        [self schedule:@selector(loadTick:) interval:2.0f];
        // every 2.0s call selector
    }
    return self;
}

- (void) loadTick:(double)dt {
    static int count;
    count++;
    NSString *s = [NSString stringWithFormat:
                   @"%@%@", [loadingTitle string], @"."];
    [loadingTitle setString:s];
    if (count >= 4) {
        [self unscheduleAllSelectors];
        // go to the next scene
        CCScene *sc = [StartScene scene];
        [[CCDirector sharedDirector] replaceScene:sc];
    }
}

- (void) dealloc {
    [loadingTitle release], loadingTitle = nil;
    [super dealloc];
}
@end
