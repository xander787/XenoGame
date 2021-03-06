//
//  XenophobeAppDelegate.h
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

#import <UIKit/UIKit.h>
#import "EAGLView.h"

@class XenophobeViewController, Director;

@interface XenophobeAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow *window;
    EAGLView *glView;
    Director *_sharedDirector;
}

@end

