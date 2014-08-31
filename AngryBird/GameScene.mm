//
//  GameScene.m
//  AngryBird
//
//  Created by zoom on 14-7-17.
//  Copyright (c) 2014年 Jiance Tong. All rights reserved.
//

#import "GameScene.h"
#define SLINGSHOT_POS CGPointMake(85, 125)
@implementation GameScene

+ (id) sceneWithLevel:(int)level {
    CCScene *sc = [CCScene node];
    GameScene *gs = [GameScene nodeWithLevel:level];
    [sc addChild:gs];
    return  sc;
}
+ (id) nodeWithLevel:(int)level {
    return [[[[self class] alloc] initWithLevel:level] autorelease];
}

- (id) initWithLevel:(int)level {
    self = [super init];
    if (self) {
        currentLevel = level;
        
        CCSprite *bgSprite = [CCSprite spriteWithFile:@"bg.png"];
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        bgSprite.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:bgSprite];
        
        NSString *scoreStr = [NSString stringWithFormat:@"Score:%d", score];
        scoreLable = [[CCLabelTTF alloc] initWithString:scoreStr dimensions:CGSizeMake(300, 300) alignment:UITextAlignmentLeft fontName:@"Marker Felt" fontSize:30];
        scoreLable.position = ccp(450, 170);
        [self addChild:scoreLable];
        
        
        CCSprite *leftShot = [CCSprite spriteWithFile:@"leftshot.png"];
        leftShot.position = ccp(85, 110);
        [self addChild:leftShot];
        
        CCSprite *rightShot = [CCSprite spriteWithFile:@"rightshot.png"];
        rightShot.position = ccp(85, 110);
        [self addChild:rightShot];
        
        slingShot = [[SlingShot alloc] init];
        slingShot.startPoint1 = ccp(82, 130);
        slingShot.startPoint2 = ccp(92, 128);
        slingShot.endPoint = SLINGSHOT_POS;
        slingShot.contentSize = CGSizeMake(480, 320);
        slingShot.position = ccp(240, 160);
        [self addChild:slingShot];
        
        // enable the touch
        self.isTouchEnabled = YES;
        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
        
        [self createWorld];
        [self createLevel];
    }
    return self;
}

- (void) createWorld {
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    b2Vec2 gravity;
    gravity.Set(0.0f, -5.0f);
    
    bool doSleep = true;
    world = new b2World(gravity, doSleep);
    
    contactListener = new MyContactListener(world, self);
    world->SetContactListener(contactListener);
    // set the collision listener
    
    //set a static b2dody- ground
    b2BodyDef groundBodyDef;
    groundBodyDef.position.Set(0, 0);
    
    b2Body* groundBody = world->CreateBody(&groundBodyDef);
    
    b2PolygonShape groundBox;
    // bottom
    groundBox.SetAsEdge(b2Vec2(0,(float)87/PTM_RATIO), b2Vec2(screenSize.width/PTM_RATIO,(float)87/PTM_RATIO));
    groundBody->CreateFixture(&groundBox,0);
    [self schedule:@selector(tick:)];
}

-(void) tick: (ccTime) dt
{
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	
	world->Step(dt, velocityIterations, positionIterations);
    
    int birdCount = 0;
    int pigCount = 0;
	for (b2Body *b = world->GetBodyList(); b; b = b->GetNext())
	{
		if (b->GetUserData() != NULL) {
			SpriteBase *oneSprite = (SpriteBase *)b->GetUserData();
            
            switch (oneSprite.tag) {
                case BIRD_ID:
                    birdCount++;
                    break;
                case PIG_ID:
                    pigCount++;
                    break;
            }
            
			oneSprite.position = CGPointMake( b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
			oneSprite.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
            
            //if the b2dody stops&& it is a bird, delete it
            if (oneSprite.tag == BIRD_ID) {
                if (!b->IsAwake()) {
                    world->DestroyBody(b);
                    [oneSprite destory];
                }
            }
            //delete all body which is out position or without enough hp
            if (oneSprite.HP <= 0 || oneSprite.position.x > 480 || oneSprite.position.y < 84) {
                world->DestroyBody(b);
                [oneSprite destory];
            }
		}
	}
    
        if (pigCount == 0 && !gameFinish && gameStart) {
            gameFinish = YES;
            isWin = YES;
            [self calculatePoint];
        }else if(birdCount == 0 && [birds count] == 0 && !gameFinish){
            gameFinish = YES;
            isWin= NO;
            [self calculatePoint];
        }
    
}

// calculate the point and turn to next level or redo the same level
- (void) calculatePoint{
    if (isWin) {
        //to calculate the score remain in the birds
        for (Bird *b in birds) {
                CCLabelTTF *label = [CCLabelTTF labelWithString:@"" fontName:@"Marker Felt" fontSize:32];
                [label setString:@"100"];
                [label setColor:ccc3(100, 0, 0)];
                label.position = b.position;
                id action1 = [CCScaleTo actionWithDuration:0.5f scale:0.4];
                id action2 = [CCScaleBy actionWithDuration:0.5f scale:0];
                [b destory];
                //id actionMoveEnd = [CCCallFuncN actionWithTarget:b selector:@selector(runTick:)];
                [label runAction:[CCSequence actions:action1,action2, nil]];
                [self addChild:label];
                score+=100;
                NSString *scoreStr = [NSString stringWithFormat:@"Score:%d", score];
                [scoreLable setString:scoreStr];
        }
        [self schedule:@selector(calculateTick:) interval:2.0f];
        
    }
    else{
        CCScene *sc = [LevelScene scene];
        [[CCDirector sharedDirector] replaceScene:sc];
    }
}


- (void) calculateTick:(double)dt{
    [GameUtil writeLevelToFile:currentLevel+1];
    CCScene *sc = [GameScene sceneWithLevel:currentLevel+1];
    [[CCDirector sharedDirector] replaceScene:sc];
}


- (void) createLevel {
    // 1, 2
    NSString *s = [NSString stringWithFormat:@"%d", currentLevel];
    NSString *path = [[NSBundle mainBundle] pathForResource:s ofType:@"data"];
    NSLog(@"path is %@", path);
    NSArray *spriteArray = [JsonParser getAllSprite:path];
    NSLog(@"array is %@",spriteArray);
    for (SpriteModel *sm in spriteArray) {
        switch (sm.tag) {
            case PIG_ID:
            {
                gameStart =YES;
                CCSprite *pig = [[Pig alloc] initWithX:sm.x andY:sm.y andWorld:world  andLayer:self];
                [self addChild:pig];
                [pig release];
                break;
            }
            case ICE_ID:
            {
                CCSprite *ice = [[Ice alloc] initWithX:sm.x andY:sm.y andWorld:world  andLayer:self];
                [self addChild:ice];
                [ice release];
                break;
            }
            default:
                break;
        }
    }
    
    birds = [[NSMutableArray alloc] init];
    Bird *bird = [[Bird alloc] initWithX:160 andY:93 andWorld:world andLayer:self];
    Bird *bird2 = [[Bird alloc] initWithX:140 andY:93 andWorld:world andLayer:self];
    Bird *bird3 = [[Bird alloc] initWithX:120 andY:93 andWorld:world andLayer:self];
    
    [self addChild:bird];
    [self addChild:bird2];
    [self addChild:bird3];
    [birds addObject:bird];
    [birds addObject:bird2];
    [birds addObject:bird3];
    
    [bird release];
    [bird2 release];
    [bird3 release];
    
    [self jump];
}

- (void) jump {
    if (birds.count > 0 && !gameFinish) {
        currentBird = [birds objectAtIndex:0];
        CCJumpTo *action = [[CCJumpTo alloc] initWithDuration:1 position:SLINGSHOT_POS height:50 jumps:1];
        CCCallBlockN *jumpFinish = [[CCCallBlockN alloc] initWithBlock:^(CCNode *node) {
            //gameStart = YES;
            currentBird.isReady = YES;
        }];
        CCSequence *allActions = [CCSequence actions:action, jumpFinish, nil];
        [action release];
        [jumpFinish release];
        [currentBird runAction:allActions];
    }
}

//when using ccTargetedTouch, we must define ccTouchBegan method
#define TOUCH_UNKNOW 0
#define TOUCH_SHOTBIRD 1
- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    // using touchStatus to makesure we selected currentBird
    touchStatus = TOUCH_UNKNOW;
    CGPoint location = [self convertTouchToNodeSpace:touch];
    if (currentBird == nil) {
        return NO;
    }
    CGRect birdRect = currentBird.boundingBox;
    if (CGRectContainsPoint(birdRect, location)) {
        // recognise whether the touch point is in the birdRect
        touchStatus = TOUCH_SHOTBIRD;
        return YES;
    }
    return NO;
}

// when moved
- (void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    if (touchStatus == TOUCH_SHOTBIRD) {
        //move the slingEndPoint & currentBird Position
        CGPoint location = [self convertTouchToNodeSpace:touch];
        slingShot.endPoint = location;
        currentBird.position = location;
    }
}

- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    if (touchStatus == TOUCH_SHOTBIRD) {
        CGPoint location = [self convertTouchToNodeSpace:touch];
        slingShot.endPoint = SLINGSHOT_POS;
        // return the sling position to default position
        //CGFloat r = [self getRatioFromPoint:location toPoint:SLINGSHOT_POS];
        //CGFloat endx = 300;
        //CGFloat endy = endx*r +location.y;
        //CGPoint destPoint = ccp(endx, endy);
        //CCMoveTo *move=[[CCMoveTo alloc] initWithDuration:1.0f position:destPoint];
        //[currentBird runAction:move];
        //[move release];
        
        float x =(85.0f-location.x)*50.0f/70.0f;
        float y =(125.0f-location.y)*50.0f/70.0f;
        [currentBird setSpeedX:x andY:y andWorld:world];
        
        [birds removeObject:currentBird];
        currentBird = nil;
        [self performSelector:@selector(jump) withObject:nil afterDelay:2.0f];
        //jump the next bird to be currentBird
    }
}

//- (CGFloat) getRatioFromPoint:(CGPoint )p1 toPoint:(CGPoint) p2 {
//    return (p2.y-p1.y)/(p2.x-p1.x);
//}

- (void) dealloc {
    [birds release];
    [scoreLable release];
    [super dealloc];
}

//score function to renew the score board
- (void) sprite:(SpriteBase *)sprite withScore:(int)_score {
    score+=_score;
    NSString *scoreStr = [NSString stringWithFormat:@"Score:%d", score];
    [scoreLable setString:scoreStr];
}

@end
