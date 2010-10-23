//
//  XenophobeGameController.h
//  Xenophobe
//
//  Created by Alexander on 10/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "Director.h"
#import "ResourceManager.h"
#import "SoundManager.h"
#import "Image.h"
#import "SpriteSheet.h"
#import "AbstractScene.h"
#import "MainMenuScene.h"

@class EAGLView;

@interface XenophobeGameController : NSObject <UIAccelerometerDelegate> {
	/* State to define if OGL has been initialised or not */
	BOOL glInitialised;
	
	// Grab the bounds of the screen
	CGRect screenBounds;
	
	// Accelerometer fata
	UIAccelerationValue _accelerometer[3];
	
	// Shared game state
	Director *_director;
	
	// Shared resource manager
	ResourceManager *_resourceManager;
	
	// Shared sound manager
	SoundManager *_soundManager;
}

- (id)init;
- (void)initOpenGL;
- (void)renderScene;
- (void)updateScene:(GLfloat)aDelta;
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView;
- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView;
- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView;

@end
