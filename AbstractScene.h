//
//  AbstractScene.h
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

#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "Director.h"
#import "ResourceManager.h"
#import "SoundManager.h"
#import "Image.h"
#import "SpriteSheet.h"
#import "Animation.h"
#import "AngelCodeFont.h"
#import "TiledMap.h"
#import "ParticleEmitter.h"
//#import "MenuControl.h"

// This is an abstract class which contains the basis for any game scene which is going
// to be used.  A game scene is a self contained class which is responsible for updating 
// the logic and rendering the screen for the current scene.  It is simply a way to 
// encapsulate a specific scenes code in a single class.
//
// The Director class controls which scene is the current scene and it is this scene which
// is updated and rendered during the game loop.
//
@interface AbstractScene : NSObject {
	Director        *_sharedDirector;
	ResourceManager *_sharedResourceManager;
	SoundManager    *_sharedSoundManager;
	CGRect          _screenBounds;
	uint            sceneState;
	float           sceneAlpha;
	NSString        *nextSceneKey;
    float           _sceneFadeSpeed;
}

#pragma mark -
#pragma mark Properties

// This property allows for the scenes state to be altered
@property (nonatomic, assign) uint sceneState;

// This property allows for the scenes alpha to be changed.  Any image which is being rendered
// uses the Director to get the current scene and from this it will take the current scenes
// alpha and use this when calculating its own alpha.  This allows you to fade an entire scene
// just by changing the scenes alpha and not the individual alpha of each image
@property (nonatomic, assign) GLfloat sceneAlpha;

#pragma mark -
#pragma mark Selectors

// Selector to update the scenes logic using |aDelta| which is passe in from the game loop
- (void)updateWithDelta:(GLfloat)aDelta;

// Selector that enables a touchesBegan events location to be passed into a scene.  |aTouchLocation| is 
// a CGPoint which has been encoded into an NSString
- (void)updateWithTouchLocationBegan:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView;
- (void)updateWithTouchLocationMoved:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView;
- (void)updateWithTouchLocationEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView;

// Selector which enables accelerometer data to be passed into the scene.
- (void)updateWithAccelerometer:(UIAcceleration*)aAcceleration;

// Selector that transitions from this scene to the scene with the key specified.  This allows the current
// scene to perform a transition action before the current scene within the Director is changed.
- (void)transitionToSceneWithKey:(NSString*)aKey;

// Selector which renders the scene
- (void)render;
@end
