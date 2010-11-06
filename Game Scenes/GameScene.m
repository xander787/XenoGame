//
//  GameScene.m
//  Xenophobe
//
//  Created by Alexander on 11/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"

@interface GameScene(Private)
- (void)initGameScene;
@end

@implementation GameScene

- (id)init {
	if (self = [super init]) {
		_sharedDirector = [Director sharedDirector];
		_sharedResourceManager = [ResourceManager sharedResourceManager];
		_sharedSoundManager = [SoundManager sharedSoundManager];
		
		_sceneFadeSpeed = 1.5f;
		sceneAlpha = 0.0f;
		_origin = CGPointMake(0, 0);
		[_sharedDirector setGlobalAlpha:sceneAlpha];
		
		[self setSceneState:kSceneState_TransitionIn];
		nextSceneKey = nil;
		
		[self initGameScene];
	}
	
	return self;
}

- (void)initGameScene {
	image = [[Image alloc] initWithImage:@"playership.png" scale:(1/8.0f)];
	NSLog(@"Should have loaded image");
}

- (void)updateWithDelta:(GLfloat)aDelta {
	
}

- (void)setSceneState:(uint)theState {
	sceneState = theState;
	if(sceneState == kSceneState_TransitionOut)
		sceneAlpha = 1.0f;
	if(sceneState == kSceneState_TransitionIn)
		sceneAlpha = 0.0f;
}

- (void)updateWithTouchLocationBegan:(NSSet *)touches withEvent:(UIEvent *)event view:(UIView *)aView {
	UITouch *touch = [[event touchesForView:aView] anyObject];
	CGPoint location;
	location = [touch locationInView:aView];
    
	// Flip the y location ready to check it against OpenGL coordinates
	NSLog(@"%f %f", location.x, location.y);
	location.y = 480-location.y;
	NSLog(@"%f %f", location.x, location.y);
}

- (void)updateWithMovedLocation:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView {
	UITouch *touch = [[event touchesForView:aView] anyObject];
	CGPoint location;
	location = [touch locationInView:aView];
    
	// Flip the y location ready to check it against OpenGL coordinates
	location.y = 480-location.y;
}

- (void)transitionToSceneWithKey:(NSString *)aKey {
	sceneState = kSceneState_TransitionOut;
	sceneAlpha = 1.0f;
}

- (void)render {
	[image renderAtPoint:CGPointMake(165, 225) centerOfImage:NO];
}

@end
