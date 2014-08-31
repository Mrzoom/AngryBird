//
//  AppDelegate.m
//  AngryBird
//
//  Created by zoom on 14-7-12.
//  Copyright (c) 2014年 Jiance Tong. All rights reserved.
//

#import "AppDelegate.h"
#import "cocos2d.h"
#import "RootViewController.h"
#import "LoadingScene.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    if (![CCDirector setDirectorType:kCCDirectorTypeDisplayLink]) {
        [CCDirector setDirectorType:kCCDirectorTypeDefault];
    }
    
    CCDirector *director = [CCDirector sharedDirector];
    EAGLView *glView = [EAGLView viewWithFrame:[self.window bounds] pixelFormat:kEAGLColorFormatRGB565 depthFormat:0];
    // create a UIView OpenGL ES
    [director setOpenGLView:glView];
    // link director and glView
    //[director setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];

    [director setAnimationInterval:1.0f/60.0f];
    // set FPS
    //[director setDisplayFPS:YES];

    
    RootViewController *rvc = [[RootViewController alloc] init];
    [rvc setView:glView];
    [self.window setRootViewController:rvc];
    [rvc release];
    // set the root view
    
    [self.window makeKeyAndVisible];
    // show the first scene
    CCScene *sc = [LoadingScene scene];
    [[CCDirector sharedDirector] runWithScene:sc];
    //run the scene
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [[CCDirector sharedDirector] pause];
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[CCDirector sharedDirector] stopAnimation];
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[CCDirector sharedDirector] startAnimation];
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[CCDirector sharedDirector] resume];
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    CCDirector *director = [CCDirector sharedDirector];
    [[director openGLView] removeFromSuperview];
    [self.window release];
    [director end];    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}
- (void) applicationSignificantTimeChange:(UIApplication *)application {
    [[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}
@end
