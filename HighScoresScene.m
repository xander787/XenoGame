//
//  HighScoresScene.m
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
//	Last Updated - 10/26/2010 @ 12AM - Alexander
//	- Initial creation of the scene

#import "HighScoresScene.h"


@implementation HighScoresScene

- (id)init {
	if (self = [super init]) {
		_sharedDirector = [Director sharedDirector];
		_sharedResourceManager = [ResourceManager sharedResourceManager];
		_sharedSoundManager = [SoundManager sharedSoundManager];
		
		_sceneFadeSpeed = 0.5f;
		sceneAlpha = 0.0f;
		_origin = CGPointMake(0, 0);
		[_sharedDirector setGlobalAlpha:sceneAlpha];
		
		[self setSceneState:kSceneState_TransitionIn];
		nextSceneKey = nil;
	}
	
	return self;
}

- (void)initSettings {
	leaderboardsTitle = [[Image alloc] initWithImage:@"leaderboardstitle.png"];
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
	[leaderboardsTitle renderAtPoint:CGPointMake(160, 430) centerOfImage:YES];
}

@end
