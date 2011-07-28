//
//  GameStatsScene.m
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
//	Last Updated - 7/26/2011 @ 11PM - Alexander
//  - Stats are now displayed
//
//  Last Updated - 7/26/11 @11:30PM - James
//  - Fixed bug with displaying time

#import "GameStatsScene.h"

@implementation GameStatsScene

@synthesize continueGame, statsDictionary;

- (id)init
{
    self = [super init];
    if (self) {
        _sharedDirector = [Director sharedDirector];
		_sharedResourceManager = [ResourceManager sharedResourceManager];
		_sharedSoundManager = [SoundManager sharedSoundManager];
		
        // Grab the bounds of the screen
		_screenBounds = [[UIScreen mainScreen] bounds];
        
        _sceneFadeSpeed = 1.0f;
        
        storeButton = [[MenuControl alloc] initWithImageNamed:@"store.png" location:Vector2fMake(160, 100) centerOfImage:YES type:kControlType_Shop];
        continueGameButton = [[MenuControl alloc] initWithImageNamed:@"continue.png" location:Vector2fMake(160, 145) centerOfImage:YES type:kControlType_ReturnToGame];
        optionsButton = [[MenuControl alloc] initWithImageNamed:@"settings.png" location:Vector2fMake(160, 55) centerOfImage:YES type:kControlType_Settings];
        
        font = [[AngelCodeFont alloc] initWithFontImageNamed:@"xenophobefont.png" controlFile:@"xenophobefont" scale:0.75f filter:GL_LINEAR];
    }
    
    return self;
}

- (void)updateWithDelta:(GLfloat)aDelta {
    switch (sceneState) {
        case kSceneState_Running:
            break;
        case kSceneState_TransitionIn:
            sceneAlpha += _sceneFadeSpeed * aDelta;
            [_sharedDirector setGlobalAlpha:sceneAlpha];
            if(sceneAlpha >= 1.0f) {
                sceneAlpha = 1.0f;
                sceneState = kSceneState_Running;
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
        default:
            break;
    }
    
    [storeButton updateWithDelta:[NSNumber numberWithFloat:aDelta]];
    [continueGameButton updateWithDelta:[NSNumber numberWithFloat:aDelta]];
    [optionsButton updateWithDelta:[NSNumber numberWithFloat:aDelta]];
    
    if([storeButton state] == kControl_Selected){
        [storeButton setState:kControl_Idle];
        nextSceneKey = @"store";
        if(![_sharedDirector setCurrentSceneToSceneWithKey:nextSceneKey])
            sceneState = kSceneState_TransitionOut;
    }
    else if([continueGameButton state] == kControl_Selected){
        [continueGameButton setState:kControl_Idle];
        continueGame = YES;
    }
    else if([optionsButton state] == kControl_Selected){
        [optionsButton setState:kControl_Idle];
        nextSceneKey = @"settings";
        if(![_sharedDirector setCurrentSceneToSceneWithKey:nextSceneKey])
            sceneState = kSceneState_TransitionOut;
    }
}

- (void)updateWithTouchLocationBegan:(NSSet *)touches withEvent:(UIEvent *)event view:(UIView *)aView {
	UITouch *touch = [[event touchesForView:aView] anyObject];
	CGPoint location;
	location = [touch locationInView:aView];
    
	// Flip the y location ready to check it against OpenGL coordinates
	//NSLog(@"%f %f", location.x, location.y);
	location.y = 480-location.y;
    [storeButton updateWithLocation:NSStringFromCGPoint(location)];
    [continueGameButton updateWithLocation:NSStringFromCGPoint(location)];
    [optionsButton updateWithLocation:NSStringFromCGPoint(location)];
	NSLog(@"%f %f", location.x, location.y);
}

- (void)updateWithMovedLocation:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView {
	UITouch *touch = [[event touchesForView:aView] anyObject];
	CGPoint location;
	location = [touch locationInView:aView];
    
	// Flip the y location ready to check it against OpenGL coordinates
	location.y = 480-location.y;
    [storeButton updateWithLocation:NSStringFromCGPoint(location)];
    [continueGameButton updateWithLocation:NSStringFromCGPoint(location)];
    [optionsButton updateWithLocation:NSStringFromCGPoint(location)];
}

- (void)setSceneState:(uint)theState {
	sceneState = theState;
	if(sceneState == kSceneState_TransitionOut)
		sceneAlpha = 1.0f;
	if(sceneState == kSceneState_TransitionIn)
		sceneAlpha = 0.0f;
}

- (void)render {
    [storeButton render];
    [optionsButton render];
    [continueGameButton render];
    
    [font drawStringAt:CGPointMake(25.0f, 455.0f) text:@"Stats"];
    
    [font setScale:0.45f];
    
    [font drawStringAt:CGPointMake(25.0f, 390.0f) text:[NSString stringWithFormat:@"Enemies killed: %@", [statsDictionary valueForKey:@"ENEMIES"]]];
    [font drawStringAt:CGPointMake(25.0f, 360.0f) text:[NSString stringWithFormat:@"Drops collected: %@", [statsDictionary valueForKey:@"DROPS"]]];
    [font drawStringAt:CGPointMake(25.0f, 330.0f) text:[NSString stringWithFormat:@"Score earned: %@", [statsDictionary valueForKey:@"SCORE"]]]; 
    float time = [[statsDictionary valueForKey:@"TIME"] floatValue];
    [font drawStringAt:CGPointMake(25.0f, 300.0f) text:[NSString stringWithFormat:@"Time taken: %dm %ds", ((int)floor(time / 60)), ((int)floor(time - (floor(time / 60) * 60)))]];
    
    [font setScale:0.75f];
}

- (void)dealloc {
    [super dealloc];
    
    [continueGameButton release];
    [storeButton release];
    [optionsButton release];
}

@end
