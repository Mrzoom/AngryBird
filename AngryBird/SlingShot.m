//
//  SlingShot.m
//  AngryBird
//
//  Created by zoom on 14-7-18.
//  Copyright (c) 2014年 Jiance Tong. All rights reserved.
//

#import "SlingShot.h"

@implementation SlingShot
- (void) draw {
    // The good example for drawing using OpenGL
    glLineWidth(2.0f); //set the line width
    glColor4f(1.0f, 0.0f, 0.0f, 1.0f); // set the line color
    glEnable(GL_LINE_SMOOTH); //smooth the line
    //before we using vertices array, we should disable following things
    glDisable(GL_TEXTURE_2D);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    glDisableClientState(GL_COLOR_ARRAY);
    
    GLfloat ver[4] = {_startPoint1.x, _startPoint1.y,
        _endPoint.x, _endPoint.y};
    glVertexPointer(2, GL_FLOAT, 0, ver);
    glDrawArrays(GL_LINES, 0, 2);
    
    GLfloat ver2[4] = {_startPoint2.x, _startPoint2.y,
        _endPoint.x, _endPoint.y};
    glVertexPointer(2, GL_FLOAT, 0, ver2);//2 means it is 2-dimensions point
    glDrawArrays(GL_LINES, 0, 2);
    
    glEnableClientState(GL_COLOR_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    glEnable(GL_TEXTURE_2D);
    glDisable(GL_LINE_SMOOTH);
}
@end
