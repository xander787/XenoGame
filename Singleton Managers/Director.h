//
//  Director.h
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
#import <OpenGLES/ES1/gl.h>
#import "SynthesizeSingleton.h"
#import "Common.h"

@class AbstractScene;

@interface Director : NSObject {
	
	// Currently bound texture name
	GLuint currentlyBoundTexture;
	// Current game state
	GLuint currentGameState;
	// Current scene
	AbstractScene *currentScene;
	// Dictionary of scenes
	NSMutableDictionary *_scenes;
	// Global alpha
	GLfloat globalAlpha;
    // Frames Per Second
    float framesPerSecond;
	
}

@property (nonatomic, assign) GLuint currentlyBoundTexture;
@property (nonatomic, assign) GLuint currentGameState;
@property (nonatomic, retain) AbstractScene *currentScene;
@property (nonatomic, assign) GLfloat globalAlpha;
@property (nonatomic, assign) float framesPerSecond;

+ (Director*)sharedDirector;
- (void)addSceneWithKey:(NSString*)aSceneKey scene:(AbstractScene*)aScene;
- (BOOL)setCurrentSceneToSceneWithKey:(NSString*)aSceneKey;
- (BOOL)transitionToSceneWithKey:(NSString*)aSceneKey;

@end