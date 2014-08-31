//
//  GameUtil.h
//  AngryBird
//
//  Created by zoom on 14-7-15.
//  Copyright (c) 2014年 Jiance Tong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameUtil : NSObject

+ (int) readLevelFromFile;
+ (void) writeLevelToFile:(int)level;
@end
