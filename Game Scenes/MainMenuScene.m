//
//  MainMenuScene.m
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
//	Last Updated - 10/25/2010 @ 12AM - Alexander
//	- Added in initial menu buttons and also wrote initial particle
//	emmitter for the background stars in space view. Currently needs a bit of work

#import "MainMenuScene.h"
#import "Image.h"
#import "ParticleEmitter.h"

@interface MainMenuScene (Private)
- (void)initMenu;
@end


@implementation MainMenuScene

- (id) init {
	if (self = [super init]) {
		_sharedDirector = [Director sharedDirector];
		_sharedResourceManager = [ResourceManager sharedResourceManager];
		_sharedSoundManager = [SoundManager sharedSoundManager];
		
		_sceneFadeSpeed = 0.5f;
		sceneAlpha = 0.0f;
		_origin = CGPointMake(0, 0);
		[_sharedDirector setGlobalAlpha:sceneAlpha];
		
		menuItems = [[NSMutableArray alloc] init];
		[self setSceneState:kSceneState_TransitionIn];
		nextSceneKey = nil;
		[self initMenu];
	}
	
	return self;
}

- (void)initMenu {
	MenuControl *menuControl = [[MenuControl alloc] initWithImageNamed:@"newgame.png" location:Vector2fMake(165, 225) centerOfImage:YES type:kControlType_NewGame];
	[menuItems addObject:menuControl];
	[menuControl release];
	
	menuControl = [[MenuControl alloc] initWithImageNamed:@"highscores.png" location:Vector2fMake(165, 175) centerOfImage:YES type:kControlType_HighScores];
	[menuItems addObject:menuControl];
	[menuControl release];
	
	menuControl = [[MenuControl alloc] initWithImageNamed:@"settings.png" location:Vector2fMake(165, 125) centerOfImage:YES type:kControlType_Settings];
	[menuItems addObject:menuControl];
	[menuControl release];
	
	logoImage = [[Image alloc] initWithImage:@"xenophobe.png"];
	backgroundParticleEmitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
																				  position:Vector2fMake(160.0, 259.76)
																	sourcePositionVariance:Vector2fMake(373.5, 240.0)
																					 speed:0.0
																			 speedVariance:0.74
																		  particleLifeSpan:10.0
																  particleLifespanVariance:0.0
																					 angle:185
																			 angleVariance:96.16
																				   gravity:Vector2fMake(0.0, 0.0)
																				startColor:Color4fMake(1.0, 1.0, 1.0, 0.58)
																		startColorVariance:Color4fMake(0.0, 0.0, 0.0, 0.0)
																			   finishColor:Color4fMake(0.5, 0.5, 0.5, 0.34)
																	   finishColorVariance:Color4fMake(0.0, 0.0, 0.0, 0.0)
																			  maxParticles:1500
																			  particleSize:2.0
																	  particleSizeVariance:5.0
																				  duration:-1
																			 blendAdditive:NO];
}

- (void)updateWithDelta:(GLfloat)aDelta {

	switch (sceneState) {
		case kSceneState_Running:
			[menuItems makeObjectsPerformSelector:@selector(updateWithDelta:) withObject:[NSNumber numberWithFloat:aDelta]];
			
			for (MenuControl *control in menuItems) {
				if([control state] == kControl_Selected) {
					[control setState:kControl_Idle];
					sceneState = kSceneState_TransitionOut;
					switch ([control type]) {
						case kControlType_NewGame:
							nextSceneKey = @"game";
							break;
                        case kControlType_Settings:
                            nextSceneKey = @"settings";
                            break;
						default:
							break;
					}
				}
			}
			break;
			
		case kSceneState_TransitionOut:
			sceneAlpha -= _sceneFadeSpeed * aDelta;
            [_sharedDirector setGlobalAlpha:sceneAlpha];
			if(sceneAlpha < 0)
                // If the scene being transitioned to does not exist then transition
                // this scene back in
				if(![_sharedDirector setCurrentSceneToSceneWithKey:nextSceneKey])
                    sceneState = kSceneState_TransitionIn;
			break;
			
		case kSceneState_TransitionIn:
			
			// I'm not using the delta value here as the large map being loaded causes
            // the first delta to be passed in to be very big which takes the alpha
            // to over 1.0 immediately, so I've got a fixed delta for the fade in.
            sceneAlpha += _sceneFadeSpeed * 0.1f;
            [_sharedDirector setGlobalAlpha:sceneAlpha];
			if(sceneAlpha >= 1.0f) {
				sceneState = kSceneState_Running;
			}
			break;
		default:
			break;
	}
	
	[backgroundParticleEmitter update:aDelta];
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
	[menuItems makeObjectsPerformSelector:@selector(updateWithLocation:) withObject:NSStringFromCGPoint(location)];
	NSLog(@"%f %f", location.x, location.y);
}

- (void)updateWithMovedLocation:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView {
	UITouch *touch = [[event touchesForView:aView] anyObject];
	CGPoint location;
	location = [touch locationInView:aView];
    
	// Flip the y location ready to check it against OpenGL coordinates
	location.y = 480-location.y;
	[menuItems makeObjectsPerformSelector:@selector(updateWithLocation:) withObject:NSStringFromCGPoint(location)];		
}

- (void)transitionToSceneWithKey:(NSString *)aKey {
	sceneState = kSceneState_TransitionOut;
	sceneAlpha = 1.0f;
}

- (void)render {
	[logoImage renderAtPoint:CGPointMake(0, 300) centerOfImage:NO];
	[menuItems makeObjectsPerformSelector:@selector(render)];
	[backgroundParticleEmitter renderParticles];
}

@end
