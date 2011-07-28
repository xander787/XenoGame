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
	}
    
    settingsTitleString = @"Settings";
    controlsSettingString = @"Controls";
    soundSettingString = @"Sound";
    musicSettingString = @"Music";

    	
	return self;
}

- (void)initSettings {
    font = [[AngelCodeFont alloc] initWithFontImageNamed:@"xenophobefont.png" controlFile:@"xenophobefont" scale:0.50f filter:GL_LINEAR];
    backButton = [[Image alloc] initWithImage:[NSString stringWithString:@"backbutton.png"] scale:Scale2fMake(0.5f, 0.5f)];
    settingsDB = [NSUserDefaults standardUserDefaults];
    
    sliderImage = [[Image alloc] initWithImage:@"Slider.png" scale:Scale2fOne];
    sliderBarImage = [[Image alloc] initWithImage:@"SliderBar.png" scale:Scale2fOne];
    volumeLowImage = [[Image alloc] initWithImage:@"Volume_low.png" scale:Scale2fMake(0.75, 0.75)];
    volumeHighImage = [[Image alloc] initWithImage:@"Volume_high.png" scale:Scale2fMake(0.75, 0.75)];
    
    soundVolume = [settingsDB floatForKey:kSetting_SoundVolume] * 100;
    musicVolume = [settingsDB floatForKey:kSetting_MusicVolume] * 100;
    
    controlTypeTouchImage = [[Image alloc] initWithImage:@"TouchOff.png" scale:Scale2fOne];
    controlTypeAccelerometerImage = [[Image alloc] initWithImage:@"AccelerometerOff.png" scale:Scale2fOne];
    controlTypeTouchImageGlow = [[Image alloc] initWithImage:@"TouchOn.png" scale:Scale2fOne];
    controlTypeAccelerometerImageGlow = [[Image alloc] initWithImage:@"AccelerometerOn.png" scale:Scale2fOne];
}

#pragma mark -
#pragma mark Update Scene

- (void)updateWithDelta:(GLfloat)aDelta {
	switch (sceneState) {
		case kSceneState_Running:
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
    }
    if(CGRectContainsPoint(CGRectMake(90, 328, 29, 26), location)){
        //Music volume low pushed
        musicVolume -= 10;
        musicVolume = MAX(0, musicVolume);
        musicVolume = MIN(musicVolume, 100);
    }
    if(CGRectContainsPoint(CGRectMake(280, 398, 39, 26), location)){
        //Sound volume high pushed
        soundVolume += 10;
        soundVolume = MAX(0, soundVolume);
        soundVolume = MIN(soundVolume, 100);
    }
    if(CGRectContainsPoint(CGRectMake(280, 328, 39, 26), location)){
        //Music volume high pushed
        musicVolume += 10;
        musicVolume = MAX(0, musicVolume);
        musicVolume = MIN(musicVolume, 100);
    }
    
    if (CGRectContainsPoint(CGRectMake(20.0f, 220.0f, 105.0f, 48.0f), location)) {
        NSLog(@"Touch");
        [settingsDB setValue:kSettingValue_ControlType_Touch forKey:kSetting_ControlType];
    }
    if (CGRectContainsPoint(CGRectMake(130.0f, 220.0f, 180.0f, 48.0f), location)) {
        NSLog(@"Accel");
        [settingsDB setValue:kSettingValue_ControlType_Accelerometer forKey:kSetting_ControlType];
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
}

@end
