//
//  JsonParser.h
//  AngryBird
//
//  Created by zoom on 14-7-17.
//  Copyright (c) 2014年 Jiance Tong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpriteModel : NSObject {
    int tag;
    float x;
    float y;
    float angle;
}
@property (nonatomic, assign) int tag;
@property (nonatomic, assign) float x;
@property (nonatomic, assign) float y;
@property (nonatomic, assign) float angle;

@end

@interface JsonParser : NSObject

+ (id) getAllSprite:(NSString *)file;

@end
