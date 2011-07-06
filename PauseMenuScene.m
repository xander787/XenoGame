//
//  PauseMenuScene.m
//  Xenophobe
//
//  Created by James Linnell on 7/4/11.
//  Copyright 2011 PDHS. All rights reserved.
//

#import "PauseMenuScene.h"


@implementation PauseMenuScene

@synthesize returnToGame;

- (id)init {
    if((self = [super init])){
        _sharedDirector = [Director sharedDirector];
		_sharedResourceManager = [ResourceManager sharedResourceManager];
		_sharedSoundManager = [SoundManager sharedSoundManager];
		
		_sceneFadeSpeed = 0.5f;
        
        sceneState = kSceneState_Running;
        
        //Buttons
        mainMenuButton = [[MenuControl alloc] initWithImageNamed:@"mainmenu.png" location:Vector2fMake(160, 200) centerOfImage:YES type:kControlType_MainMenu];
        returnToGameButton = [[MenuControl alloc] initWithImageNamed:@"return.png" location:Vector2fMake(160, 245) centerOfImage:YES type:kControlType_ReturnToGame];
        settingsMenuButton = [[MenuControl alloc] initWithImageNamed:@"settings.png" location:Vector2fMake(160, 155) centerOfImage:YES type:kControlType_Settings];
    }
    
    return self;
}

- (void)updateWithDelta:(GLfloat)aDelta {
	[mainMenuButton updateWithDelta:[NSNumber numberWithFloat:aDelta]];
    [returnToGameButton updateWithDelta:[NSNumber numberWithFloat:aDelta]];
    [settingsMenuButton updateWithDelta:[NSNumber numberWithFloat:aDelta]];
    
    if([mainMenuButton state] == kControl_Selected){
        [mainMenuButton setState:kControl_Idle];
        nextSceneKey = @"menu";
        if(![_sharedDirector setCurrentSceneToSceneWithKey:nextSceneKey])
            sceneState = kSceneState_TransitionOut;
    }
    else if([returnToGameButton state] == kControl_Selected){
        [returnToGameButton setState:kControl_Idle];
        returnToGame = TRUE;
    }
    else if([settingsMenuButton state] == kControl_Selected){
        [settingsMenuButton setState:kControl_Idle];
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
    [returnToGameButton updateWithLocation:NSStringFromCGPoint(location)];
    [settingsMenuButton updateWithLocation:NSStringFromCGPoint(location)];
	NSLog(@"%f %f", location.x, location.y);
}

- (void)updateWithMovedLocation:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView {
	UITouch *touch = [[event touchesForView:aView] anyObject];
	CGPoint location;
	location = [touch locationInView:aView];
    
	// Flip the y location ready to check it against OpenGL coordinates
	location.y = 480-location.y;
    [mainMenuButton updateWithLocation:NSStringFromCGPoint(location)];
    [returnToGameButton updateWithLocation:NSStringFromCGPoint(location)];
    [settingsMenuButton updateWithLocation:NSStringFromCGPoint(location)];
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
    [returnToGameButton render];
    [settingsMenuButton render];
}

- (void)dealloc {
    [super dealloc];
    [mainMenuButton release];
    [settingsMenuButton release];
    [returnToGameButton release];
}

@end
