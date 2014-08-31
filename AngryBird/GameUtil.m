//
//  GameUtil.m
//  AngryBird
//
//  Created by zoom on 14-7-15.
//  Copyright (c) 2014年 Jiance Tong. All rights reserved.
//

#import "GameUtil.h"

@implementation GameUtil

+ (NSString *) getLevelFilePath {
    // get the file which store the level information
    return [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"SuccessLevel"];
    // path: Documents/SuccessLevel;
}
+ (int) readLevelFromFile {
    NSString *file = [[self class] getLevelFilePath];
    //NSLog(@"the file path is %@",file);
    // get the file
    // get the level information
    NSString *s = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
    if (s) {
        //NSLog(@"the level is %@",s);
        return [s intValue];
    }
    return 1; // default level
}
+ (void) writeLevelToFile:(int)level {
    NSString *s = [NSString stringWithFormat:
                   @"%d", level];
    NSString *file = [[self class] getLevelFilePath];
    [s writeToFile:file atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

@end
