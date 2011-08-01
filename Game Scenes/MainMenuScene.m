//
//	MainMenuScene.m
//	Xenophobe
//
//	Created by Alexander on 10/20/10.
//	Copyright 2010 Alexander Nabavi-Noori, XanderNet Inc. All rights reserved.
//  
//	Team:
//	Alexander Nabavi-Noori - Software Engineer, Game Architect
//	James Linnell - Software Engineer, Creative Design, Art Producer
//	Tyler Newcomb - Creative Design, Art Producer
//
//	10/30/2010 @ 8:40PM - Alexander
//	- Made some changes to the background star emitter
//
//	11/5/2010 @ 5:40PM - Alexander
//	- Added scene key strings in updateWithDelta: so that 
//	the class recognizes and properly switches to scenes
//	correctly (effected highscores scene & about scene
//	which weren't showing up before because of this).
//
//  11/23/2010 @ 12AM - James
//  - Fixed annoying bug todo with initializing the logoImage
//  by adding a [NSString stringW/String wrap around
//
//	7/28/11 @ 6:30PM - Alexander
//	- Fixed a bug where the settings were being overwritten during
//  each launch because I forgot to change the value for the firstTimeLaunch setting
//
//	7/28/11 @ 9:40PM - Alexander
//	- Supposed to be able to switch out "new game" for continue. Not quite done yet

#import "MainMenuScene.h"
#import "Image.h"
#import "ParticleEmitter.h"
#import <stdlib.h>

@interface MainMenuScene (Private)
- (void)initMenu;
@end


@implementation MainMenuScene

#pragma mark -
#pragma mark Initialization

- (id) init {
	if (self = [super init]) {
		_sharedDirector = [Director sharedDirector];
		_sharedResourceManager = [ResourceManager sharedResourceManager];
		_sharedSoundManager = [SoundManager sharedSoundManager];
		
		_sceneFadeSpeed = 1.5f;
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
    settingsDB = [NSUserDefaults standardUserDefaults];
    
    MenuControl *menuControl;
    if([[settingsDB stringForKey:kSetting_SaveGameLevelProgress] isEqualToString:@""]){
        newGameContinueControl = [[MenuControl alloc] initWithImageNamed:@"newgame.png" location:Vector2fMake(165, 225) centerOfImage:YES type:kControlType_NewGame];
    }
    else {
        newGameContinueControl = [[MenuControl alloc] initWithImageNamed:@"continue.png" location:Vector2fMake(165, 225) centerOfImage:YES type:kControlType_NewGame];

    }
	[menuItems addObject:newGameContinueControl];
    
	menuControl = [[MenuControl alloc] initWithImageNamed:@"highscores.png" location:Vector2fMake(165, 175) centerOfImage:YES type:kControlType_HighScores];
	[menuItems addObject:menuControl];
	[menuControl release];
	
	menuControl = [[MenuControl alloc] initWithImageNamed:@"settings.png" location:Vector2fMake(165, 125) centerOfImage:YES type:kControlType_Settings];
	[menuItems addObject:menuControl];
	[menuControl release];
	
	menuControl = [[MenuControl alloc] initWithImageNamed:@"about.png" location:Vector2fMake(165, 75) centerOfImage:YES type:kControlType_About];
	[menuItems addObject:menuControl];
	[menuControl release];
	
	logoImage = [[Image alloc] initWithImage:[NSString stringWithString:@"xenophobe.png"]];
    
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
		
	cometParticleEmitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
																			 position:Vector2fMake(160, 80)
															   sourcePositionVariance:Vector2fMake(10, 15)
																				speed:2.0
																		speedVariance:0.0
																	 particleLifeSpan:0.75
															 particleLifespanVariance:0.5
																				angle:180.0
																		angleVariance:0.0
																			  gravity:Vector2fMake(0.0, 0.0)
																		   startColor:Color4fMake(0.38, 0.58, 0.94, 1)
																   startColorVariance:Color4fMake(0, 0, 0, 0)
																		  finishColor:Color4fMake(0.5, 0.1, 0.1, 1)
																  finishColorVariance:Color4fMake(0.3, 0, 0.05, 0.05)
																		 maxParticles:300
																		 particleSize:60
																   finishParticleSize:10
																 particleSizeVariance:10.0
																			 duration:-1
																		blendAdditive:YES];
    
    if (![[settingsDB stringForKey:kSetting_FirstTimeRun] isEqualToString:@"NO"]) {
        [settingsDB setValue:@"" forKey:kSetting_TwitterCredentials];
        [settingsDB setBool:YES forKey:kSetting_TactileFeedback];
        [settingsDB setFloat:0.75 forKey:kSetting_SoundVolume];
        [settingsDB setFloat:0.50 forKey:kSetting_MusicVolume];
        [settingsDB setValue:kSettingValue_ControlType_Touch forKey:kSetting_ControlType];
        [settingsDB setValue:@"NO" forKey:kSetting_FirstTimeRun];
        [settingsDB synchronize];
    }
    
    soundManager = [SoundManager sharedSoundManager];
    [soundManager setFxVolume:[settingsDB floatForKey:kSetting_SoundVolume]];
    [soundManager setMusicVolume:[settingsDB floatForKey:kSetting_MusicVolume]];
    [soundManager loadMusicWithKey:@"menu_theme" musicFile:@"menu_theme.mp3"];
    [soundManager loadMusicWithKey:@"game_theme" musicFile:@"game_theme.mp3"];
    [soundManager playMusicWithKey:@"menu_theme" timesToRepeat:1000];
    //[soundManager setFxVolume:[settingsDB floatForKey:kSetting_SoundVolume]];
    //[soundManager setMusicVolume:[settingsDB floatForKey:kSetting_MusicVolume]];
}

#pragma mark -
#pragma mark Update Scene

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
						case kControlType_HighScores:
							nextSceneKey = @"highscores";
							break;
						case kControlType_About:
							nextSceneKey = @"about";
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
            if ([[settingsDB stringForKey:kSetting_SaveGameLevelProgress] isEqualToString:@""]) {
                [menuItems removeObject:newGameContinueControl];
                newGameContinueControl = [[MenuControl alloc] initWithImageNamed:@"newgame.png" location:Vector2fMake(165, 225) centerOfImage:YES type:kControlType_NewGame];
                [menuItems addObject:newGameContinueControl];
            }
            else {
                [menuItems removeObject:newGameContinueControl];
                newGameContinueControl = [[MenuControl alloc] initWithImageNamed:@"continue.png" location:Vector2fMake(165, 225) centerOfImage:YES type:kControlType_NewGame];
                [menuItems addObject:newGameContinueControl];
            }
			// I'm not using the delta value here as the large map being loaded causes
            // the first delta to be passed in to be very big which takes the alpha
            // to over 1.0 immediately, so I've got a fixed delta for the fade in.
			sceneAlpha += _sceneFadeSpeed * aDelta;
            [_sharedDirector setGlobalAlpha:sceneAlpha];
			if(sceneAlpha >= 1.0f) {
				sceneState = kSceneState_Running;
			}
			break;
		default:
			break;
	};
	
	/*float x = cometParticleEmitter.sourcePosition.x;
	float y = cometParticleEmitter.sourcePosition.y;
	float newAngle;
	if(CGRectContainsPoint(CGRectMake(-320, 0, 640, 960), CGPointMake(x, y))){
		NSLog(@"YES");
		x = x + (150 * aDelta);
		y = y + (150 * aDelta);
	}
	else {
		int rnd = (arc4random() % 1000) + (arc4random() % 50);
		int rndM = arc4random() % 100;
		NSLog(@"%d", rnd);
		if(rnd > 42){
			x = -(arc4random() % -320 + 0);
			y = -(arc4random() % 1 + 480);
			float lineSlopHigh = (480 - y) / (0 - x);
			float lineSlopLow = (0 - y) / (0 - x);
			
			float lineAngleHigh = (59.6 * lineSlopHigh) + 184.47;
			float lineAngleLow = (59.6 * lineSlopLow) + 184.47;
			
			newAngle = arc4random() % (int)MAX(lineAngleLow, lineAngleHigh) + (int)MIN(lineAngleLow, lineAngleHigh);
		}
	}
	
	[cometParticleEmitter setSourcePosition:Vector2fMake(x, y)];	
	[cometParticleEmitter setAngle:newAngle];
	 [cometParticleEmitter update:aDelta];*/
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
	//NSLog(@"%f %f", location.x, location.y);
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

#pragma mark -
#pragma mark Rendering

- (void)transitionToSceneWithKey:(NSString *)aKey {
	sceneState = kSceneState_TransitionOut;
	sceneAlpha = 1.0f;
}

- (void)render {
	//[cometParticleEmitter renderParticles];
	[backgroundParticleEmitter renderParticles];
	[logoImage renderAtPoint:CGPointMake(0, 300) centerOfImage:NO];
	[menuItems makeObjectsPerformSelector:@selector(render)];
}

- (void)dealloc {
    [super dealloc];
    [menuItems release];
    [logoImage release];
    [backgroundParticleEmitter release];
}

@end
