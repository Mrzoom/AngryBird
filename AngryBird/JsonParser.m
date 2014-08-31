//
//  JsonParser.m
//  AngryBird
//
//  Created by zoom on 14-7-17.
//  Copyright (c) 2014年 Jiance Tong. All rights reserved.
//
#import "JsonParser.h"

#import "SBJson.h"

@implementation SpriteModel

@end

@implementation JsonParser

+ (id) getAllSprite:(NSString *)file {
    NSString *levelContent = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
    //using SBJson to get the Json data
    NSArray *spriteArray = [[[levelContent JSONValue] objectForKey:@"sprites"] objectForKey:@"sprite"];
    NSMutableArray *a = [NSMutableArray array];
    for (NSDictionary *dict in spriteArray) {
        SpriteModel *sm = [[SpriteModel alloc] init];
        sm.tag = [[dict objectForKey:@"tag"] intValue];
        sm.x = [[dict objectForKey:@"x"] floatValue];
        sm.y = [[dict objectForKey:@"y"] floatValue];
        sm.angle = [[dict objectForKey:@"angle"] floatValue];
        
        [a addObject:sm];
        [sm release];
    }

    return a;
}
@end
