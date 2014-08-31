//
//  LoadingScene.h
//  AngryBird
//
//  Created by zoom on 14-7-12.
//  Copyright (c) 2014年 Jiance Tong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface LoadingScene : CCLayer
{
    CCLabelBMFont *loadingTitle;
}

+ (id) scene;
@end
