//
//  StoreScene.m
//  Xenophobe
//
//  Created by Alexander on 7/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StoreScene.h"

@interface StoreScene (Private)
- (void)initStore;
@end

@implementation StoreScene

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
		
		[self initStore];
	}
    
	return self;
}

- (void)initStore {
    font = [[AngelCodeFont alloc] initWithFontImageNamed:@"xenophobefont.png" controlFile:@"xenophobefont" scale:0.70f filter:GL_LINEAR];
    
    backgroundParticleEmitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
																				  position:Vector2fMake(160.0, 259.76)
																	sourcePositionVariance:Vector2fMake(373.5, 240.0)
																					 speed:0.05
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
																			  maxParticles:1000
																			  particleSize:6.0
																		finishParticleSize:6.0
																	  particleSizeVariance:1.3
																				  duration:-1
																			 blendAdditive:NO];
    
    creditsIcon = [[Image alloc] initWithImage:@"Credit.png" scale:Scale2fOne];
    backButton = [[Image alloc] initWithImage:@"backbutton.png" scale:Scale2fOne];
    generalMenuShipsButton = [[Image alloc] initWithImage:@"Ships-Store-Button.png" scale:Scale2fOne];
    generalMenuWeaponsButton = [[Image alloc] initWithImage:@"Weapons-Store-Button.png" scale:Scale2fOne];

    shipsMenuBaseButton = [[Image alloc] initWithImage:@"Base-Ships-Store-Button.png" scale:Scale2fOne];
    shipsMenuAttackButton = [[Image alloc] initWithImage:@"Attack-Ships-Store-Button.png" scale:Scale2fOne];
    shipsMenuSpeedButton = [[Image alloc] initWithImage:@"Speed-Ships-Store-Button.png" scale:Scale2fOne];
    shipsMenuDefenseButton = [[Image alloc] initWithImage:@"Defense-Ships-Store-Button.png" scale:Scale2fOne];
    
    weaponsMenuBulletsButton = [[Image alloc] initWithImage:@"Bullets-Store-Button.png" scale:Scale2fOne];
    weaponsMenuWavesButton = [[Image alloc] initWithImage:@"Waves-Store-Button.png" scale:Scale2fOne];
    weaponsMenuMissilesButton = [[Image alloc] initWithImage:@"Missiles-Store-Button.png" scale:Scale2fOne];
    weaponsMenuHeatseekingButton = [[Image alloc] initWithImage:@"Heatseeking-Store-Button.png" scale:Scale2fOne];
    weaponsMenuBulletsNextButton = [[Image alloc] initWithImage:@"nextbutton.png" scale:Scale2fOne];
    weaponsMenuBulletsPreviousButton = [[Image alloc] initWithImage:@"previousbutton.png" scale:Scale2fOne];
    weaponsMenuWavesNextButton = [[Image alloc] initWithImage:@"nextbutton.png" scale:Scale2fOne];
    weaponsMenuWavesPreviousButton = [[Image alloc] initWithImage:@"previousbutton.png" scale:Scale2fOne];
    weaponsMenuMissilesNextButton = [[Image alloc] initWithImage:@"nextbutton.png" scale:Scale2fOne];
    weaponsMenuMissilesPreviousButton = [[Image alloc] initWithImage:@"previousbutton.png" scale:Scale2fOne];
    weaponsMenuHeatseekingNextButton = [[Image alloc] initWithImage:@"nextbutton.png" scale:Scale2fOne];
    weaponsMenuHeatseekingPreviousButton = [[Image alloc] initWithImage:@"previousbutton.png" scale:Scale2fOne];

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
            currentSceneState = kSceneState_general_menu;
			sceneAlpha += _sceneFadeSpeed * aDelta;
            [_sharedDirector setGlobalAlpha:sceneAlpha];
			if(sceneAlpha >= 1.0f) {
				sceneState = kSceneState_Running;
			}
			break;
            
		default:
            [NSException raise:NSInternalInconsistencyException format:@"Impossible settings scene state"];
			break;
	}
    
    switch (currentSceneState) {
        case kSceneState_general_menu:
            
            break;
            
        case kSceneState_ship_upgrades:
            
            break;
            
        case kSceneState_weapons_upgrades:
            
            break;
            
        case kSceneState_ship_upgrades_base_chooser:
            
            break;
            
        case kSceneState_ship_upgrades_attack_chooser:
            
            break;
            
        case kSceneState_ship_upgrades_speed_chooser:
            
            break;
            
        case kSceneState_ship_upgrades_defense_chooser:
            
            break;
            
        default:
            
            break;
    }
    
    [backgroundParticleEmitter update:aDelta];
}

- (void)updateWithTouchLocationBegan:(NSSet *)touches withEvent:(UIEvent *)event view:(UIView *)aView {
	UITouch *touch = [[event touchesForView:aView] anyObject];
	CGPoint location;
	location = [touch locationInView:aView];
    
	// Flip the y location ready to check it against OpenGL coordinates
	location.y = 480-location.y;
    
    switch (currentSceneState) {
        case kSceneState_general_menu:
            if (CGRectContainsPoint(CGRectMake(80.0f, 362.0f, 180, 34), location)) {
                currentSceneState = kSceneState_ship_upgrades;
            }
            else if (CGRectContainsPoint(CGRectMake(80.0f, 282.0f, 180, 34), location)) {
                currentSceneState = kSceneState_weapons_upgrades;
            }
            
            if(CGRectContainsPoint(CGRectMake(15, 440, backButton.imageWidth, backButton.imageHeight), location)){
                sceneState = kSceneState_TransitionOut;
                nextSceneKey = [_sharedDirector getLastSceneUsed];
            }
            
            break;
            
        case kSceneState_ship_upgrades:
            if (CGRectContainsPoint(CGRectMake(80.0f, 342.0f, 180, 34), location)) {
                NSLog(@"Base");
            }
            else if (CGRectContainsPoint(CGRectMake(80.0f, 262.0f, 180, 34), location)) {
                NSLog(@"Attack");
            }
            else if (CGRectContainsPoint(CGRectMake(80.0f, 182.0f, 180, 34), location)) {
                NSLog(@"Speed");
            }
            else if (CGRectContainsPoint(CGRectMake(80.0f, 102.0f, 180, 34), location)) {
                NSLog(@"Defense");
            }
            
            if(CGRectContainsPoint(CGRectMake(15, 440, backButton.imageWidth, backButton.imageHeight), location)){
                currentSceneState = kSceneState_general_menu;
            }
            
            break;
            
        case kSceneState_weapons_upgrades:
            
            if(CGRectContainsPoint(CGRectMake(15, 440, backButton.imageWidth, backButton.imageHeight), location)){
                currentSceneState = kSceneState_general_menu;
            }
            break;    
            
        case kSceneState_ship_upgrades_base_chooser:
            
            break;
            
        case kSceneState_ship_upgrades_attack_chooser:
            
            break;
            
        case kSceneState_ship_upgrades_speed_chooser:
            
            break;
            
        case kSceneState_ship_upgrades_defense_chooser:
            
            break;

        default:
            
            break;
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

    switch (currentSceneState) {
        case kSceneState_general_menu:
            [font drawStringAt:CGPointMake(110.0f, 460.0) text:@"Store"];
            [generalMenuShipsButton renderAtPoint:CGPointMake(160.0f, 380.0f) centerOfImage:YES];
            [generalMenuWeaponsButton renderAtPoint:CGPointMake(160.0f, 300.0f) centerOfImage:YES];
            [font setScale:0.5];
            [font drawStringAt:CGPointMake(75.0f, 250.0f) text:@"Health: XXXc"];
            [font drawStringAt:CGPointMake(75.0f, 200.0f) text:@"Shield: XXXc"];
            [font setScale:0.7];
            break;
            
        case kSceneState_ship_upgrades:
            [font drawStringAt:CGPointMake(110.0f, 460.0) text:@"Ships"];
            [shipsMenuBaseButton renderAtPoint:CGPointMake(160.0f, 360.0f) centerOfImage:YES];
            [shipsMenuAttackButton renderAtPoint:CGPointMake(160.0f, 280.0f) centerOfImage:YES];
            [shipsMenuSpeedButton renderAtPoint:CGPointMake(160.0f, 200.0f) centerOfImage:YES];
            [shipsMenuDefenseButton renderAtPoint:CGPointMake(160.0f, 120.0f) centerOfImage:YES];
            break;
            
        case kSceneState_ship_upgrades_base_chooser:
            
            break;
            
        case kSceneState_ship_upgrades_attack_chooser:
            
            break;
            
        case kSceneState_ship_upgrades_speed_chooser:
            
            break;
            
        case kSceneState_ship_upgrades_defense_chooser:
            
            break;
            
        case kSceneState_weapons_upgrades:
            [font drawStringAt:CGPointMake(90.0f, 460.0) text:@"Weapons"];

            [font setScale:0.35];
            
            [weaponsMenuBulletsButton renderAtPoint:CGPointMake(160.0f, 360.0f) centerOfImage:YES];
            [weaponsMenuBulletsPreviousButton renderAtPoint:CGPointMake(105.0f, 325.0f) centerOfImage:YES];
            [font drawStringAt:CGPointMake(120.0, 340.0f) text:@"Level: X"];
            [weaponsMenuBulletsNextButton renderAtPoint:CGPointMake(220.0f, 325.0f) centerOfImage:YES];
            
            [weaponsMenuWavesButton renderAtPoint:CGPointMake(160.0f, 280.0f) centerOfImage:YES];
            [weaponsMenuWavesPreviousButton renderAtPoint:CGPointMake(105.0f, 245.0f) centerOfImage:YES];
            [font drawStringAt:CGPointMake(120.0, 260.0f) text:@"Level: X"];
            [weaponsMenuWavesNextButton renderAtPoint:CGPointMake(220.0f, 245.0f) centerOfImage:YES];
            
            [weaponsMenuMissilesButton renderAtPoint:CGPointMake(160.0f, 200.0f) centerOfImage:YES];
            [weaponsMenuMissilesPreviousButton renderAtPoint:CGPointMake(105.0f, 165.0f) centerOfImage:YES];
            [font drawStringAt:CGPointMake(120.0, 180.0f) text:@"Level: X"];
            [weaponsMenuMissilesNextButton renderAtPoint:CGPointMake(220.0f, 165.0f) centerOfImage:YES];
            
            [weaponsMenuHeatseekingButton renderAtPoint:CGPointMake(160.0f, 120.0f) centerOfImage:YES];
            [weaponsMenuHeatseekingPreviousButton renderAtPoint:CGPointMake(105.0f, 85.0f) centerOfImage:YES];
            [font drawStringAt:CGPointMake(120.0, 100.0f) text:@"Level: X"];
            [weaponsMenuHeatseekingNextButton renderAtPoint:CGPointMake(220.0f, 85.0f) centerOfImage:YES];
            
            [font setScale:0.7];
            break;    
            
        default:
            
            break;
    }
    [creditsIcon renderAtPoint:CGPointMake(0, 0) centerOfImage:NO];
    [font setScale:0.4];
    [font drawStringAt:CGPointMake(42, 38) text:@"100"];
    [font setScale:0.7];
    [backButton renderAtPoint:CGPointMake(15, 440) centerOfImage:NO];
}

- (void)dealloc {
    [super dealloc];
    [font release];
}

@end
