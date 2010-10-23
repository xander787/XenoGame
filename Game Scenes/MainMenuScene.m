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
//	Last Updated - 10/20/2010 @ 6PM - Alexander
//	- Initial Project Creation

#import "MainMenuScene.h"
#import "Image.h"

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
	MenuControl *menuControl = [[MenuControl alloc] initWithImageNamed:@"newgame.png" location:Vector2fMake(50, 50) centerOfImage:YES type:kControlType_NewGame];
	[menuItems addObject:menuControl];
	[menuControl release];
	
//	menuControl = [[MenuControl alloc] initWithImageNamed:@"settings.png" location:Vector2fMake(145, 183) centerOfImage:YES type:kControlType_Settings];
//	[menuItems addObject:menuControl];
//	[menuControl release];
//	
//	menuControl = [[MenuControl alloc] initWithImageNamed:@"highscores.png" location:Vector2fMake(145, 226) centerOfImage:YES type:kControlType_HighScores];
//	[menuItems addObject:menuControl];
//	[menuControl release];
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
            sceneAlpha += _sceneFadeSpeed * 0.02f;
            [_sharedDirector setGlobalAlpha:sceneAlpha];
			if(sceneAlpha >= 1.0f) {
				sceneState = kSceneState_Running;
			}
			break;
		default:
			break;
	}
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
	[menuItems makeObjectsPerformSelector:@selector(render)];
}

@end
