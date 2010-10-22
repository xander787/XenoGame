//
//  XenophobeAppDelegate.m
//  Xenophobe
//
//  Created by Alexander on 10/20/10.
//  Copyright 2010 Alexander Nabavi-Noori, XanderNet Inc. All rights reserved.
//  
//  Team:
//  Alexander Nabavi-Noori - Software Engineer, Game Architect
//	James Linnell - Software Engineer, Creative Design, Art Producer
//	Tyler Newcomb - Creative Design, Art Producer
//
//	Last Updated - 10/20/2010 @ 6PM - Alexander
//	- Initial Project Creation

#import "XenophobeAppDelegate.h"

@implementation XenophobeAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// Not using any NIB files anymore, we are creating the window and the
    // EAGLView manually.
    window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	[window setUserInteractionEnabled:YES];
	[window setMultipleTouchEnabled:YES];
	
	glView = [[EAGLView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	
    // Add the glView to the window which has been defined
	[window addSubview:glView];
	[window makeKeyAndVisible];
    
    [glView performSelectorOnMainThread:@selector(mainGameLoop) withObject:nil waitUntilDone:NO];
	
	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{

}

- (void)applicationWillTerminate:(UIApplication *)application
{

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Handle any background procedures not related to animation here.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Handle any foreground procedures not related to animation here.
}

- (void)dealloc
{
    [glView release];
    [window release];
    
    [super dealloc];
}

@end
