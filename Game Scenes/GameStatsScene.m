//
//  GameStatsScene.m
//  Xenophobe
//
//  Created by James Linnell on 7/26/11.
//  Copyright 2011 PDHS. All rights reserved.
//

#import "GameStatsScene.h"

@implementation GameStatsScene

@synthesize continueGame;

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
        
        mainMenuButton = [[MenuControl alloc] initWithImageNamed:@"mainmenu.png" location:Vector2fMake(160, 100) centerOfImage:YES type:kControlType_MainMenu];
        continueGameButton = [[MenuControl alloc] initWithImageNamed:@"continue.png" location:Vector2fMake(160, 145) centerOfImage:YES type:kControlType_ReturnToGame];
        optionsButton = [[MenuControl alloc] initWithImageNamed:@"settings.png" location:Vector2fMake(160, 55) centerOfImage:YES type:kControlType_Settings];
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
    
    [mainMenuButton updateWithDelta:[NSNumber numberWithFloat:aDelta]];
    [continueGameButton updateWithDelta:[NSNumber numberWithFloat:aDelta]];
    [optionsButton updateWithDelta:[NSNumber numberWithFloat:aDelta]];
    
    if([mainMenuButton state] == kControl_Selected){
        [mainMenuButton setState:kControl_Idle];
        nextSceneKey = @"menu";
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
    [mainMenuButton updateWithLocation:NSStringFromCGPoint(location)];
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
    [mainMenuButton updateWithLocation:NSStringFromCGPoint(location)];
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
    [mainMenuButton render];
    [optionsButton render];
    [continueGameButton render];
}

- (void)dealloc {
    [super dealloc];
    
    [continueGameButton release];
    [mainMenuButton release];
    [optionsButton release];
}

@end
