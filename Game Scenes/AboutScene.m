//
//  StoreScene.m
//  Xenophobe
//
//  Created by Alexander on 7/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AboutScene.h"

@interface AboutScene (Private)
- (void)initAboutScene;
@end

@implementation AboutScene

#pragma mark -
#pragma mark Initializations

- (id)init {
	if ((self = [super init])) {
		_sharedDirector = [Director sharedDirector];
		_sharedResourceManager = [ResourceManager sharedResourceManager];
		_sharedSoundManager = [SoundManager sharedSoundManager];
		
		_sceneFadeSpeed = 0.50f;
        //		sceneAlpha = 0.0f;
        //		_origin = CGPointMake(0, 0);
        //		[_sharedDirector setGlobalAlpha:sceneAlpha];
        //		
        //		[self setSceneState:kSceneState_TransitionIn];
        //		nextSceneKey = nil;
		
		[self initAboutScene];
	}
    
	return self;
}

- (void)initAboutScene {
    font = [[AngelCodeFont alloc] initWithFontImageNamed:@"xenophobefont.png" controlFile:@"xenophobefont" scale:0.300f filter:GL_LINEAR];
    backButton = [[Image alloc] initWithImage:[NSString stringWithString:@"backbutton.png"] scale:Scale2fOne];
    backgroundParticleEmitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
																				  position:Vector2fMake(160.0, 259.76)
																	sourcePositionVariance:Vector2fMake(373.5, 240.0)
																					 speed:0.1
																			 speedVariance:0.01
																		  particleLifeSpan:5.0
																  particleLifespanVariance:2.0
																					 angle:200.0
																			 angleVariance:0.0
																				   gravity:Vector2fMake(0.0, 0.0)
																				startColor:Color4fMake(1.0, 1.0, 1.0, 0.58)
																		startColorVariance:Color4fMake(0.0, 0.0, 0.0, 0.0)
																			   finishColor:Color4fMake(0.5, 0.5, 0.5, 0.34)
																	   finishColorVariance:Color4fMake(0.0, 0.0, 0.0, 0.0)
																			  maxParticles:2000
																			  particleSize:3.0
																		finishParticleSize:3.0
																	  particleSizeVariance:1.3
																				  duration:-1
																			 blendAdditive:NO];
}

#pragma mark -
#pragma mark Update Scene

- (void)updateWithDelta:(GLfloat)aDelta {
	switch (sceneState) {
		case kSceneState_Running:
            [backgroundParticleEmitter update:aDelta];
			break;
			
		case kSceneState_TransitionOut:
			sceneAlpha-= _sceneFadeSpeed * aDelta;
            [_sharedDirector setGlobalAlpha:sceneAlpha];
			if(sceneAlpha <= 0.0f)
                // If the scene being transitioned to does not exist then transition
                // this scene back in
				if(![_sharedDirector setCurrentSceneToSceneWithKey:nextSceneKey])
                    sceneState = kSceneState_TransitionIn;
			break;
			
		case kSceneState_TransitionIn:
			sceneAlpha += _sceneFadeSpeed * aDelta;
            [_sharedDirector setGlobalAlpha:sceneAlpha];
			if(sceneAlpha >= 1.0f) {
				sceneState = kSceneState_Running;
			}
			break;
		default:
			break;
	}
}

- (void)updateWithTouchLocationBegan:(NSSet *)touches withEvent:(UIEvent *)event view:(UIView *)aView {
	UITouch *touch = [[event touchesForView:aView] anyObject];
	CGPoint location;
	location = [touch locationInView:aView];
    
	// Flip the y location ready to check it against OpenGL coordinates
	location.y = 480-location.y;
    
    if(CGRectContainsPoint(CGRectMake(15, 440, backButton.imageWidth, backButton.imageHeight), location)){
        sceneState = kSceneState_TransitionOut;
        nextSceneKey = [_sharedDirector getLastSceneUsed];
    }
}

- (void)updateWithTouchLocationMoved:(NSSet *)touches withEvent:(UIEvent *)event view:(UIView *)aView {
    UITouch *touch = [[event touchesForView:aView] anyObject];
	CGPoint location;
	location = [touch locationInView:aView];
    
	// Flip the y location ready to check it against OpenGL coordinates
	location.y = 480-location.y;
}

#pragma mark -
#pragma mark Rendering

- (void)transitionToSceneWithKey:(NSString *)aKey {
	
}

- (void)render {
    [backgroundParticleEmitter renderParticles];
    [backButton renderAtPoint:CGPointMake(15.0f, 445.0f) centerOfImage:NO];
    
    [font drawStringAt:CGPointMake(60.0f, 455.0f) text:@"About"];

    [font setScale:0.30f];
    
    [font drawStringAt:CGPointMake(15.0f, 410.0f) text:@"Alexander Nabavi-Noori"];

    [font setScale:0.30f];
    [font drawStringAt:CGPointMake(25.0f, 380.0f) text:@"- Lead Software Engineer"];
    [font setScale:0.30f];
    
    
    [font setScale:0.30f];
    
    [font drawStringAt:CGPointMake(15.0f, 340.0f) text:@"James Linnell"];
    
    [font setScale:0.30f];
    [font drawStringAt:CGPointMake(25.0f, 310.0f) text:@"- Lead Software Engineer"];
    [font setScale:0.30f];

    
    [font setScale:0.30f];
    
    [font drawStringAt:CGPointMake(15.0f, 270.0f) text:@"Tyler Newcomb"];
    
    [font setScale:0.30f];
    [font drawStringAt:CGPointMake(25.0f, 230.0f) text:@"- Creative Designer"];
    [font setScale:0.30f];

    
    [font setScale:0.30f];
    
    [font drawStringAt:CGPointMake(15.0f, 190.0f) text:@"Sean Rafferty"];
    
    [font setScale:0.30f];
    [font drawStringAt:CGPointMake(25.0f, 160.0f) text:@"- Graphics"];
    [font setScale:0.30f];

    
    [font setScale:0.30f];
    [font drawStringAt:CGPointMake(10.0f, 40.0f) text:@"Contact:info@xenophobethegame.com"];
    [font drawStringAt:CGPointMake(10.0f, 20.0f) text:@"xenophobethegame.com"];
    
    
    [font setScale:0.75f];
}

@end
