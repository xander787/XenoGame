//
//  SettingsScene.m
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
//	Last Updated - 11/5/2010 @ 9:20PM - Alexander
//	- Fixed problem causing the alpha for the scene to
//	be set to 0 causing nothing to appear to render to the screen
//
//	Last Updated - 11/21/2010 @ 11AM - Alexander
//	- Added in testing code for the player ship in here
//
//	Last Updated - 11/22/2010 @12AM - Alexander
//	- Added in first test code for moving the ship
//  by passing it coords from the touches received on this
//  scene
//
//  Last Updated - 11/23/2010 @2:15PM - James
//  - Fixed small bug with change from changing the player
//  ship reference in Enemy to a single pointer, initialization
//  was still using &testShip.
//
//  Last Updated - 12/17/10 @6PM - James
//  - Added restriction of only being able to move the
//  Player ship if the user touched in the bounds of
//  the Player ship initially.
//
//  Last Updated - 12/23/10 @ 9:15PM - James
//  - Added an NSSet for enemies loaded into memory,
//  started basic use of DidCollide (form Common.h)
//  to detect player vs. enemy collision
//
//  Last Updated - 12/29/10 @ 12PM - Alexander
//  - Removed all testing code for the ships etc.
//  to the GameScene class. Also moving the above commit
//  comments to that file as well for reference.
//
//	Last Updated - 7/28/11 @ 3:30PM - Alexander
//	- Control type setting now works
//
//	Last Updated - 7/28/11 @ 6:30PM - Alexander
//	- Sound actually saves to preferences file now
//
//	Last Updated - 7/28/11 @ 6:30PM - Alexander
//	- Sound is updated in real time based on the sound sliders

#import "SettingsScene.h"

@interface SettingsScene (Private)
- (void)initSettings;
@end

@implementation SettingsScene

#pragma mark -
#pragma mark Initializations

- (id)init {
	if ((self = [super init])) {
		_sharedDirector = [Director sharedDirector];
		_sharedResourceManager = [ResourceManager sharedResourceManager];
		_sharedSoundManager = [SoundManager sharedSoundManager];
		
		_sceneFadeSpeed = 0.5f;
//		sceneAlpha = 0.0f;
//		_origin = CGPointMake(0, 0);
//		[_sharedDirector setGlobalAlpha:sceneAlpha];
//		
//		[self setSceneState:kSceneState_TransitionIn];
//		nextSceneKey = nil;
		
		[self initSettings];
        
        settingsTitleString = @"Settings";
        controlsSettingString = @"Controls";
        soundSettingString = @"Sound";
        musicSettingString = @"Music";

	}
    	
	return self;
}

- (void)initSettings {
    font = [[AngelCodeFont alloc] initWithFontImageNamed:@"xenophobefont.png" controlFile:@"xenophobefont" scale:0.50f filter:GL_LINEAR];
    backButton = [[Image alloc] initWithImage:[NSString stringWithString:@"backbutton.png"] scale:Scale2fOne];
    settingsDB = [NSUserDefaults standardUserDefaults];
    
    sliderImage = [[Image alloc] initWithImage:@"Slider.png" scale:Scale2fOne];
    sliderBarImage = [[Image alloc] initWithImage:@"SliderBar.png" scale:Scale2fOne];
    volumeLowImage = [[Image alloc] initWithImage:@"Volume_low.png" scale:Scale2fMake(0.75, 0.75)];
    volumeHighImage = [[Image alloc] initWithImage:@"Volume_high.png" scale:Scale2fMake(0.75, 0.75)];
    
    soundVolume = [settingsDB floatForKey:kSetting_SoundVolume] * 100;
    musicVolume = [settingsDB floatForKey:kSetting_MusicVolume] * 100;
    
    soundManager = [SoundManager sharedSoundManager];
    
    controlTypeTouchImage = [[Image alloc] initWithImage:@"TouchOff.png" scale:Scale2fOne];
    controlTypeAccelerometerImage = [[Image alloc] initWithImage:@"AccelerometerOff.png" scale:Scale2fOne];
    controlTypeTouchImageGlow = [[Image alloc] initWithImage:@"TouchOn.png" scale:Scale2fOne];
    controlTypeAccelerometerImageGlow = [[Image alloc] initWithImage:@"AccelerometerOn.png" scale:Scale2fOne];
    
    controlTypeClearAllSavedDataImage = [[Image alloc] initWithImage:@"ClearAllSavedDataButton.png" scale:Scale2fOne];
    controlTypeYesButtonImage = [[Image alloc] initWithImage:@"YesButton.png" scale:Scale2fOne];
    controlTypeNoButtonImage = [[Image alloc] initWithImage:@"NoButton.png" scale:Scale2fOne];
    
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
    if(CGRectContainsPoint(CGRectMake(90, 398, 29, 26), location)){
        //Sound volume low pushed
        soundVolume -= 10;
        soundVolume = MAX(0, soundVolume);
        soundVolume = MIN(soundVolume, 100);
        [settingsDB setFloat:(soundVolume/100) forKey:kSetting_SoundVolume];
        soundManager.fxVolume = soundVolume / 100;
    }
    if(CGRectContainsPoint(CGRectMake(90, 328, 29, 26), location)){
        //Music volume low pushed
        musicVolume -= 10;
        musicVolume = MAX(0, musicVolume);
        musicVolume = MIN(musicVolume, 100);
        [settingsDB setFloat:(musicVolume/100) forKey:kSetting_MusicVolume];
        soundManager.musicVolume = musicVolume / 100;
    }
    if(CGRectContainsPoint(CGRectMake(280, 398, 39, 26), location)){
        //Sound volume high pushed
        soundVolume += 10;
        soundVolume = MAX(0, soundVolume);
        soundVolume = MIN(soundVolume, 100);
        [settingsDB setFloat:(soundVolume/100) forKey:kSetting_SoundVolume];
        soundManager.fxVolume = soundVolume / 100;
    }
    if(CGRectContainsPoint(CGRectMake(280, 328, 39, 26), location)){
        //Music volume high pushed
        musicVolume += 10;
        musicVolume = MAX(0, musicVolume);
        musicVolume = MIN(musicVolume, 100);
        [settingsDB setFloat:(musicVolume/100) forKey:kSetting_MusicVolume];
        soundManager.musicVolume = musicVolume / 100;
    }
    
    if (CGRectContainsPoint(CGRectMake(20.0f, 220.0f, 105.0f, 48.0f), location)) {
        NSLog(@"Touch");
        [settingsDB setValue:kSettingValue_ControlType_Touch forKey:kSetting_ControlType];
    }
    if (CGRectContainsPoint(CGRectMake(130.0f, 220.0f, 180.0f, 48.0f), location)) {
        NSLog(@"Accel");
        [settingsDB setValue:kSettingValue_ControlType_Accelerometer forKey:kSetting_ControlType];
    }
    if(CGRectContainsPoint(CGRectMake(0, 0, 320, 64), location)){
        NSLog(@"Clear All");
        clearAllDataButtonPushed = YES;
    }
    if(clearAllDataButtonPushed){
        if(CGRectContainsPoint(CGRectMake(30, 80, 100, 32), location)){
            NSLog(@"Yes");
            clearAllDataButtonPushed = NO;
            [settingsDB setValue:@"" forKey:kSetting_TwitterCredentials];
            [settingsDB setBool:YES forKey:kSetting_TactileFeedback];
            [settingsDB setFloat:0.75 forKey:kSetting_SoundVolume];
            [settingsDB setFloat:0.50 forKey:kSetting_MusicVolume];
            [settingsDB setValue:kSettingValue_ControlType_Touch forKey:kSetting_ControlType];
            [settingsDB setValue:@"" forKey:kSetting_SaveGameLevelProgress];
        }
        if(CGRectContainsPoint(CGRectMake(190, 80, 100, 32), location)){
            NSLog(@"No");
            clearAllDataButtonPushed = NO;
        }
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
    
    [backButton renderAtPoint:CGPointMake(15, 440) centerOfImage:NO];
    [font drawStringAt:CGPointMake(15.0f, 420.0f) text:soundSettingString];
    [font drawStringAt:CGPointMake(15.0f, 350.0f) text:musicSettingString];
    [font drawStringAt:CGPointMake(15.0f, 280.0f) text:controlsSettingString];
    
    [volumeLowImage renderAtPoint:CGPointMake(110, 412) centerOfImage:YES];
    [volumeLowImage renderAtPoint:CGPointMake(110, 342) centerOfImage:YES];
    [volumeHighImage renderAtPoint:CGPointMake(300, 412) centerOfImage:YES];
    [volumeHighImage renderAtPoint:CGPointMake(300, 342) centerOfImage:YES];
    
    [sliderImage renderAtPoint:CGPointMake(200, 412) centerOfImage:YES];
    [sliderImage renderAtPoint:CGPointMake(200, 342) centerOfImage:YES];
    [sliderBarImage setScale:Scale2fMake(soundVolume / 100, 1.0)];
    [sliderBarImage renderAtPoint:CGPointMake(125 + (6 - (sliderBarImage.scale.x * 6)), 402) centerOfImage:NO];
    [sliderBarImage setScale:Scale2fMake(musicVolume / 100, 1.0)];
    [sliderBarImage renderAtPoint:CGPointMake(125 + (6 - (sliderBarImage.scale.x * 6)), 332) centerOfImage:NO];
    
    if ([settingsDB valueForKey:kSetting_ControlType] == kSettingValue_ControlType_Touch) {
        [controlTypeTouchImageGlow renderAtPoint:CGPointMake(70.0f, 240.0f) centerOfImage:YES];
        [controlTypeAccelerometerImage renderAtPoint:CGPointMake(210.0f, 240.0f) centerOfImage:YES];
    }
    else {
        [controlTypeTouchImage renderAtPoint:CGPointMake(70.0f, 240.0f) centerOfImage:YES];
        [controlTypeAccelerometerImageGlow renderAtPoint:CGPointMake(210.0f, 240.0f) centerOfImage:YES];
    }
    
    [controlTypeClearAllSavedDataImage renderAtPoint:CGPointMake(0, 0) centerOfImage:NO];
    if(clearAllDataButtonPushed){
        [controlTypeYesButtonImage renderAtPoint:CGPointMake(80, 96) centerOfImage:YES];
        [controlTypeNoButtonImage renderAtPoint:CGPointMake(240, 96) centerOfImage:YES];
    }
}

- (void)dealloc {
    [super dealloc];
    [font release];
    [backButton release];
    [sliderImage release];
    [sliderBarImage release];
    [volumeLowImage release];
    [volumeHighImage release];
    [controlTypeTouchImage release];
    [controlTypeAccelerometerImage release];
    [controlTypeTouchImageGlow release];
    [controlTypeAccelerometerImageGlow release];
    [controlTypeClearAllSavedDataImage release];
    [controlTypeYesButtonImage release];
    [controlTypeNoButtonImage release];
    [backgroundParticleEmitter release];
}

@end
