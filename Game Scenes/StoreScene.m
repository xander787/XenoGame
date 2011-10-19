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
    
    settings = [NSUserDefaults standardUserDefaults];
    
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
    
    weaponsMenuBulletsButtonEquipped = [[Image alloc] initWithImage:@"Bullets-Store-Button-Green.png" scale:Scale2fOne];
    weaponsMenuWavesButtonEquipped = [[Image alloc] initWithImage:@"Waves-Store-Button-Green.png" scale:Scale2fOne];
    weaponsMenuMissilesButtonEquipped = [[Image alloc] initWithImage:@"Missiles-Store-Button-Green.png" scale:Scale2fOne];
    weaponsMenuHeatseekingButtonEquipped = [[Image alloc] initWithImage:@"Heatseeking-Store-Button-Green.png" scale:Scale2fOne];
    
    weaponsMenuWavesButtonDisabled = [[Image alloc] initWithImage:@"Waves-Store-Button-Gray.png" scale:Scale2fOne];
    weaponsMenuMissilesButtonDisabled = [[Image alloc] initWithImage:@"Missiles-Store-Button-Gray.png" scale:Scale2fOne];
    weaponsMenuHeatseekingButtonDisabled = [[Image alloc] initWithImage:@"Heatseeking-Store-Button-Gray.png" scale:Scale2fOne];
            
    nextButton = [[Image alloc] initWithImage:@"nextbutton.png" scale:Scale2fOne];
    previousButton = [[Image alloc] initWithImage:@"previousbutton.png" scale:Scale2fOne];
    
    equipButton = [[Image alloc] initWithImage:@"Equip.png" scale:Scale2fOne];
    buyButton = [[Image alloc] initWithImage:@"Buy.png" scale:Scale2fOne];
    equipButtonDisabled = [[Image alloc] initWithImage:@"Equip-Disabled.png" scale:Scale2fOne];
    buyButtonDisabled = [[Image alloc] initWithImage:@"Buy-Disabled.png" scale:Scale2fOne];
    equippedButton = [[Image alloc] initWithImage:@"Equipped.png" scale:Scale2fOne];
    boughtButton = [[Image alloc] initWithImage:@"Bought.png" scale:Scale2fOne];
    
    currentBulletLevelSelection = 0;
    currentWaveLevelSelection = 0;
    currentMissileLevelSelection = 0;
    currentHeatseekingLevelSelection = 0;
    
    currentEquippedWeapon = [[NSMutableString alloc] init];
    currentSelectedWeaponType = [[NSMutableString alloc] initWithString:kWeaponTypeBullet];
}

- (void)sceneIsBecomingActive {    
    if ([[settings objectForKey:kSetting_SaveGameUnlockedWeapons] containsObject:kWeaponBulletLevelFive]) {
        wavesWeaponsUnlocked = YES;
    }
    
    if ([[settings objectForKey:kSetting_SaveGameUnlockedWeapons] containsObject:kWeaponWaveLevelFive]) {
        missilesWeaponsUnlocked = YES;
    }
    
    if ([[settings objectForKey:kSetting_SaveGameUnlockedWeapons] containsObject:kWeaponMissileLevelTen]) {
        heatseekingWeaponsUnlocked = YES;
    }
    
    currentBulletLevelSelection = 1;
    currentWaveLevelSelection = 1;
    currentMissileLevelSelection = 1;
    currentHeatseekingLevelSelection = 1;
    
    
    if ([[settings objectForKey:kSetting_SaveGameUnlockedWeapons] containsObject:kWeaponBulletLevelOne]) {
        highestAchievedBulletLevel = 1;
        if ([[settings objectForKey:kSetting_SaveGameEquippedWeapon] isEqualToString:kWeaponBulletLevelOne]) {
            currentBulletLevelSelection = 1;
            [currentEquippedWeapon setString:kWeaponTypeBullet];
            currentEquippedWeaponLevel = 1;
        }
    }
    if ([[settings objectForKey:kSetting_SaveGameUnlockedWeapons] containsObject:kWeaponBulletLevelTwo]) {
        highestAchievedBulletLevel = 2;
        if ([[settings objectForKey:kSetting_SaveGameEquippedWeapon] isEqualToString:kWeaponBulletLevelTwo]) {
            currentBulletLevelSelection = 2;
            [currentEquippedWeapon setString:kWeaponTypeBullet];
            currentEquippedWeaponLevel = 2;
        }
    }
    if ([[settings objectForKey:kSetting_SaveGameUnlockedWeapons] containsObject:kWeaponBulletLevelThree]) {
        highestAchievedBulletLevel = 3;
        if ([[settings objectForKey:kSetting_SaveGameEquippedWeapon] isEqualToString:kWeaponBulletLevelThree]) {
            currentBulletLevelSelection = 3;
            [currentEquippedWeapon setString:kWeaponTypeBullet];
            currentEquippedWeaponLevel = 3;
        }
    }
    if ([[settings objectForKey:kSetting_SaveGameUnlockedWeapons] containsObject:kWeaponBulletLevelFour]) {
        highestAchievedBulletLevel = 4;
        if ([[settings objectForKey:kSetting_SaveGameEquippedWeapon] isEqualToString:kWeaponBulletLevelFour]) {
            currentBulletLevelSelection = 4;
            [currentEquippedWeapon setString:kWeaponTypeBullet];
            currentEquippedWeaponLevel = 4;
        }
    }
    if ([[settings objectForKey:kSetting_SaveGameUnlockedWeapons] containsObject:kWeaponBulletLevelFive]) {
        highestAchievedBulletLevel = 5;
        if ([[settings objectForKey:kSetting_SaveGameEquippedWeapon] isEqualToString:kWeaponBulletLevelFive]) {
            currentBulletLevelSelection = 5;
            [currentEquippedWeapon setString:kWeaponTypeBullet];
            currentEquippedWeaponLevel = 5;
        }
    }
    if ([[settings objectForKey:kSetting_SaveGameUnlockedWeapons] containsObject:kWeaponBulletLevelSix]) {
        highestAchievedBulletLevel = 6;
        if ([[settings objectForKey:kSetting_SaveGameEquippedWeapon] isEqualToString:kWeaponBulletLevelSix]) {
            currentBulletLevelSelection = 6;
            [currentEquippedWeapon setString:kWeaponTypeBullet];
            currentEquippedWeaponLevel = 6;
        }
    }
    if ([[settings objectForKey:kSetting_SaveGameUnlockedWeapons] containsObject:kWeaponBulletLevelSeven]) {
        highestAchievedBulletLevel = 7;
        if ([[settings objectForKey:kSetting_SaveGameEquippedWeapon] isEqualToString:kWeaponBulletLevelSeven]) {
            currentBulletLevelSelection = 7;
            [currentEquippedWeapon setString:kWeaponTypeBullet];
            currentEquippedWeaponLevel = 7;
        }
    }
    if ([[settings objectForKey:kSetting_SaveGameUnlockedWeapons] containsObject:kWeaponBulletLevelEight]) {
        highestAchievedBulletLevel = 8;
        if ([[settings objectForKey:kSetting_SaveGameEquippedWeapon] isEqualToString:kWeaponBulletLevelEight]) {
            currentBulletLevelSelection = 8;
            [currentEquippedWeapon setString:kWeaponTypeBullet];
            currentEquippedWeaponLevel = 8;
        }
    }
    if ([[settings objectForKey:kSetting_SaveGameUnlockedWeapons] containsObject:kWeaponBulletLevelNine]) {
        highestAchievedBulletLevel = 9;
        if ([[settings objectForKey:kSetting_SaveGameEquippedWeapon] isEqualToString:kWeaponBulletLevelNine]) {
            currentBulletLevelSelection = 9;
            [currentEquippedWeapon setString:kWeaponTypeBullet];
            currentEquippedWeaponLevel = 9;
        }
    }
    if ([[settings objectForKey:kSetting_SaveGameUnlockedWeapons] containsObject:kWeaponBulletLevelTen]) {
        highestAchievedBulletLevel = 10;
        if ([[settings objectForKey:kSetting_SaveGameEquippedWeapon] isEqualToString:kWeaponBulletLevelTen]) {
            currentBulletLevelSelection = 10;
            [currentEquippedWeapon setString:kWeaponTypeBullet];
            currentEquippedWeaponLevel = 10;
        }
    }
    
    if ([[settings objectForKey:kSetting_SaveGameUnlockedWeapons] containsObject:kWeaponWaveLevelOne]) {
        highestAchievedWaveLevel = 1;
        if ([[settings objectForKey:kSetting_SaveGameEquippedWeapon] isEqualToString:kWeaponWaveLevelOne]) {
            currentWaveLevelSelection = 1;
            [currentEquippedWeapon setString:kWeaponTypeWave];
            currentEquippedWeaponLevel = 1;
        }
    }
    if ([[settings objectForKey:kSetting_SaveGameUnlockedWeapons] containsObject:kWeaponWaveLevelTwo]) {
        highestAchievedWaveLevel = 2;
        if ([[settings objectForKey:kSetting_SaveGameEquippedWeapon] isEqualToString:kWeaponWaveLevelTwo]) {
            currentWaveLevelSelection = 2;
            [currentEquippedWeapon setString:kWeaponTypeWave];
            currentEquippedWeaponLevel = 2;
        }
    }
    if ([[settings objectForKey:kSetting_SaveGameUnlockedWeapons] containsObject:kWeaponWaveLevelThree]) {
        highestAchievedWaveLevel = 3;
        if ([[settings objectForKey:kSetting_SaveGameEquippedWeapon] isEqualToString:kWeaponWaveLevelThree]) {
            currentWaveLevelSelection = 3;
            [currentEquippedWeapon setString:kWeaponTypeWave];
            currentEquippedWeaponLevel = 3;
        }
    }
    if ([[settings objectForKey:kSetting_SaveGameUnlockedWeapons] containsObject:kWeaponWaveLevelFour]) {
        highestAchievedWaveLevel = 4;
        if ([[settings objectForKey:kSetting_SaveGameEquippedWeapon] isEqualToString:kWeaponWaveLevelFour]) {
            currentWaveLevelSelection = 4;
            [currentEquippedWeapon setString:kWeaponTypeWave];
            currentEquippedWeaponLevel = 4;
        }
    }
    if ([[settings objectForKey:kSetting_SaveGameUnlockedWeapons] containsObject:kWeaponWaveLevelFive]) {
        highestAchievedWaveLevel = 5;
        if ([[settings objectForKey:kSetting_SaveGameEquippedWeapon] isEqualToString:kWeaponWaveLevelFive]) {
            currentWaveLevelSelection = 5;
            [currentEquippedWeapon setString:kWeaponTypeWave];
            currentEquippedWeaponLevel = 5;
        }
    }
    if ([[settings objectForKey:kSetting_SaveGameUnlockedWeapons] containsObject:kWeaponWaveLevelSix]) {
        highestAchievedWaveLevel = 6;
        if ([[settings objectForKey:kSetting_SaveGameEquippedWeapon] isEqualToString:kWeaponWaveLevelSix]) {
            currentWaveLevelSelection = 6;
            [currentEquippedWeapon setString:kWeaponTypeWave];
            currentEquippedWeaponLevel = 6;
        }
    }
    if ([[settings objectForKey:kSetting_SaveGameUnlockedWeapons] containsObject:kWeaponWaveLevelSeven]) {
        highestAchievedWaveLevel = 7;
        if ([[settings objectForKey:kSetting_SaveGameEquippedWeapon] isEqualToString:kWeaponWaveLevelSeven]) {
            currentWaveLevelSelection = 7;
            [currentEquippedWeapon setString:kWeaponTypeWave];
            currentEquippedWeaponLevel = 7;
        }
    }
    if ([[settings objectForKey:kSetting_SaveGameUnlockedWeapons] containsObject:kWeaponWaveLevelEight]) {
        highestAchievedWaveLevel = 8;
        if ([[settings objectForKey:kSetting_SaveGameEquippedWeapon] isEqualToString:kWeaponWaveLevelEight]) {
            currentWaveLevelSelection = 8;
            [currentEquippedWeapon setString:kWeaponTypeWave];
            currentEquippedWeaponLevel = 8;
        }
    }
    if ([[settings objectForKey:kSetting_SaveGameUnlockedWeapons] containsObject:kWeaponWaveLevelNine]) {
        highestAchievedWaveLevel = 9;
        if ([[settings objectForKey:kSetting_SaveGameEquippedWeapon] isEqualToString:kWeaponWaveLevelNine]) {
            currentWaveLevelSelection = 9;
            [currentEquippedWeapon setString:kWeaponTypeWave];
            currentEquippedWeaponLevel = 9;
        }
    }
    if ([[settings objectForKey:kSetting_SaveGameUnlockedWeapons] containsObject:kWeaponWaveLevelTen]) {
        highestAchievedWaveLevel = 10;
        if ([[settings objectForKey:kSetting_SaveGameEquippedWeapon] isEqualToString:kWeaponWaveLevelTen]) {
            currentWaveLevelSelection = 10;
            [currentEquippedWeapon setString:kWeaponTypeWave];
            currentEquippedWeaponLevel = 10;
        }
    }
    
    if ([[settings objectForKey:kSetting_SaveGameUnlockedWeapons] containsObject:kWeaponMissileLevelOne]) {
        highestAchievedMissileLevel = 1;
        if ([[settings objectForKey:kSetting_SaveGameEquippedWeapon] isEqualToString:kWeaponMissileLevelOne]) {
            currentMissileLevelSelection = 1;
            [currentEquippedWeapon setString:kWeaponTypeMissile];
            currentEquippedWeaponLevel = 1;
        }
    }
    if ([[settings objectForKey:kSetting_SaveGameUnlockedWeapons] containsObject:kWeaponMissileLevelTwo]) {
        highestAchievedMissileLevel = 2;
        if ([[settings objectForKey:kSetting_SaveGameEquippedWeapon] isEqualToString:kWeaponMissileLevelTwo]) {
            currentMissileLevelSelection = 2;
            [currentEquippedWeapon setString:kWeaponTypeMissile];
            currentEquippedWeaponLevel = 2;
        }
    }
    if ([[settings objectForKey:kSetting_SaveGameUnlockedWeapons] containsObject:kWeaponMissileLevelThree]) {
        highestAchievedMissileLevel = 3;
        if ([[settings objectForKey:kSetting_SaveGameEquippedWeapon] isEqualToString:kWeaponMissileLevelThree]) {
            currentMissileLevelSelection = 3;
            [currentEquippedWeapon setString:kWeaponTypeMissile];
            currentEquippedWeaponLevel = 3;
        }
    }
    if ([[settings objectForKey:kSetting_SaveGameUnlockedWeapons] containsObject:kWeaponMissileLevelFour]) {
        highestAchievedMissileLevel = 4;
        if ([[settings objectForKey:kSetting_SaveGameEquippedWeapon] isEqualToString:kWeaponMissileLevelFour]) {
            currentMissileLevelSelection = 4;
            [currentEquippedWeapon setString:kWeaponTypeMissile];
            currentEquippedWeaponLevel = 4;
        }
    }
    if ([[settings objectForKey:kSetting_SaveGameUnlockedWeapons] containsObject:kWeaponMissileLevelFive]) {
        highestAchievedMissileLevel = 5;
        if ([[settings objectForKey:kSetting_SaveGameEquippedWeapon] isEqualToString:kWeaponMissileLevelFive]) {
            currentMissileLevelSelection = 5;
            [currentEquippedWeapon setString:kWeaponTypeMissile];
            currentEquippedWeaponLevel = 5;
        }
    }
    if ([[settings objectForKey:kSetting_SaveGameUnlockedWeapons] containsObject:kWeaponMissileLevelSix]) {
        highestAchievedMissileLevel = 6;
        if ([[settings objectForKey:kSetting_SaveGameEquippedWeapon] isEqualToString:kWeaponMissileLevelSix]) {
            currentMissileLevelSelection = 6;
            [currentEquippedWeapon setString:kWeaponTypeMissile];
            currentEquippedWeaponLevel = 6;
        }
    }
    if ([[settings objectForKey:kSetting_SaveGameUnlockedWeapons] containsObject:kWeaponMissileLevelSeven]) {
        highestAchievedMissileLevel = 7;
        if ([[settings objectForKey:kSetting_SaveGameEquippedWeapon] isEqualToString:kWeaponMissileLevelSeven]) {
            currentMissileLevelSelection = 7;
            [currentEquippedWeapon setString:kWeaponTypeMissile];
            currentEquippedWeaponLevel = 7;
        }
    }
    if ([[settings objectForKey:kSetting_SaveGameUnlockedWeapons] containsObject:kWeaponMissileLevelEight]) {
        highestAchievedMissileLevel = 8;
        if ([[settings objectForKey:kSetting_SaveGameEquippedWeapon] isEqualToString:kWeaponMissileLevelEight]) {
            currentMissileLevelSelection = 8;
            [currentEquippedWeapon setString:kWeaponTypeMissile];
            currentEquippedWeaponLevel = 8;
        }
    }
    if ([[settings objectForKey:kSetting_SaveGameUnlockedWeapons] containsObject:kWeaponMissileLevelNine]) {
        highestAchievedMissileLevel = 9;
        if ([[settings objectForKey:kSetting_SaveGameEquippedWeapon] isEqualToString:kWeaponMissileLevelNine]) {
            currentMissileLevelSelection = 9;
            [currentEquippedWeapon setString:kWeaponTypeMissile];
            currentEquippedWeaponLevel = 9;
        }
    }
    if ([[settings objectForKey:kSetting_SaveGameUnlockedWeapons] containsObject:kWeaponMissileLevelTen]) {
        highestAchievedMissileLevel = 10;
        if ([[settings objectForKey:kSetting_SaveGameEquippedWeapon] isEqualToString:kWeaponMissileLevelTen]) {
            currentMissileLevelSelection = 10;
            [currentEquippedWeapon setString:kWeaponTypeMissile];
            currentEquippedWeaponLevel = 10;
        }
    }
    
    if ([[settings objectForKey:kSetting_SaveGameUnlockedWeapons] containsObject:kWeaponHeatseekingLevelOne]) {
        highestAchievedHeatseekingLevel = 1;
        [currentEquippedWeapon setString:kWeaponTypeHeatseeking];
        currentEquippedWeaponLevel = 10;
    }
    
    NSLog(@"Current Equipped: %@ lvl %d", currentEquippedWeapon, currentEquippedWeaponLevel);
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
                currentSceneState = kSceneState_ship_upgrades_base_chooser;
            }
            else if (CGRectContainsPoint(CGRectMake(80.0f, 262.0f, 180, 34), location)) {
                currentSceneState = kSceneState_ship_upgrades_attack_chooser;
            }
            else if (CGRectContainsPoint(CGRectMake(80.0f, 182.0f, 180, 34), location)) {
                currentSceneState = kSceneState_ship_upgrades_speed_chooser;
            }
            else if (CGRectContainsPoint(CGRectMake(80.0f, 102.0f, 180, 34), location)) {
                currentSceneState = kSceneState_ship_upgrades_defense_chooser;
            }
            
            if(CGRectContainsPoint(CGRectMake(15, 440, backButton.imageWidth, backButton.imageHeight), location)){
                currentSceneState = kSceneState_general_menu;
            }
            
            break;
            
        case kSceneState_weapons_upgrades:
            
            if(CGRectContainsPoint(CGRectMake(15, 440, backButton.imageWidth, backButton.imageHeight), location)){
                currentSceneState = kSceneState_general_menu;
            }
            
            //Bullet
            if (CGRectContainsPoint(CGRectMake(160.0f-(weaponsMenuBulletsButton.imageWidth/2), 360.0f-(weaponsMenuBulletsButton.imageHeight/2), weaponsMenuBulletsButton.imageWidth, weaponsMenuBulletsButton.imageHeight), location)) {
                [currentSelectedWeaponType setString:kWeaponTypeBullet];
            }
            if (CGRectContainsPoint(CGRectMake(100.0f, 320.0f, 16, 16), location)) {
                NSLog(@"Previous");
                currentBulletLevelSelection--;
            }
            else if (CGRectContainsPoint(CGRectMake(210.0f, 320.0f, 16, 16), location)) {
                NSLog(@"Next");
                currentBulletLevelSelection++;
            }
            currentBulletLevelSelection = MAX(1,currentBulletLevelSelection);
            currentBulletLevelSelection = MIN(currentBulletLevelSelection, 10);
            
            if (wavesWeaponsUnlocked) {
                if (CGRectContainsPoint(CGRectMake(160.0f-(weaponsMenuWavesButton.imageWidth/2), 280.0f-(weaponsMenuWavesButton.imageHeight/2), weaponsMenuWavesButton.imageWidth, weaponsMenuWavesButton.imageHeight), location)) {
                    [currentSelectedWeaponType setString:kWeaponTypeWave];
                }
                if (CGRectContainsPoint(CGRectMake(100.0f, 240.0f, 16, 16), location)) {
                    NSLog(@"Previous");
                    currentWaveLevelSelection--;
                }
                else if (CGRectContainsPoint(CGRectMake(210.0f, 240.0f, 16, 16), location)) {
                    NSLog(@"Next");
                    currentWaveLevelSelection++;
                }
                currentWaveLevelSelection = MAX(1,currentWaveLevelSelection);
                currentWaveLevelSelection = MIN(currentWaveLevelSelection, 10);
            }
            
            if (missilesWeaponsUnlocked) {
                if (CGRectContainsPoint(CGRectMake(160.0f-(weaponsMenuMissilesButton.imageWidth/2), 200.0f-(weaponsMenuMissilesButton.imageHeight/2), weaponsMenuMissilesButton.imageWidth, weaponsMenuMissilesButton.imageHeight), location)) {
                    [currentSelectedWeaponType setString:kWeaponTypeMissile];
                }
                if (CGRectContainsPoint(CGRectMake(100.0f, 155.0f, 16, 16), location)) {
                    NSLog(@"Previous");
                    currentMissileLevelSelection--;
                }
                else if (CGRectContainsPoint(CGRectMake(210.0f, 155.0f, 16, 16), location)) {
                    NSLog(@"Next");
                    currentMissileLevelSelection++;
                }
                currentMissileLevelSelection = MAX(1,currentMissileLevelSelection);
                currentMissileLevelSelection = MIN(currentMissileLevelSelection, 10);
            }
            
            if (heatseekingWeaponsUnlocked) {
                if (CGRectContainsPoint(CGRectMake(160.0f-(weaponsMenuHeatseekingButton.imageWidth/2), 120.0f-(weaponsMenuHeatseekingButton.imageHeight/2), weaponsMenuHeatseekingButton.imageWidth, weaponsMenuHeatseekingButton.imageHeight), location)) {
                    [currentSelectedWeaponType setString:kWeaponTypeHeatseeking];
                }
                if (CGRectContainsPoint(CGRectMake(100.0f, 75.0f, 16, 16), location)) {
                    NSLog(@"Previous");
                    currentHeatseekingLevelSelection--;
                }
                else if (CGRectContainsPoint(CGRectMake(210.0f, 75.0f, 16, 16), location)) {
                    NSLog(@"Next");
                    currentHeatseekingLevelSelection++;
                }
                currentHeatseekingLevelSelection = MAX(1,currentHeatseekingLevelSelection);
                currentHeatseekingLevelSelection = MIN(currentHeatseekingLevelSelection, 10);
            }
            
            break;    
            
        case kSceneState_ship_upgrades_base_chooser:
            
            if(CGRectContainsPoint(CGRectMake(15, 440, backButton.imageWidth, backButton.imageHeight), location)){
                currentSceneState = kSceneState_ship_upgrades;
            }
            
            break;
            
        case kSceneState_ship_upgrades_attack_chooser:
            
            if(CGRectContainsPoint(CGRectMake(15, 440, backButton.imageWidth, backButton.imageHeight), location)){
                currentSceneState = kSceneState_ship_upgrades;
            }

            break;
            
        case kSceneState_ship_upgrades_speed_chooser:
            
            if(CGRectContainsPoint(CGRectMake(15, 440, backButton.imageWidth, backButton.imageHeight), location)){
                currentSceneState = kSceneState_ship_upgrades;
            }

            break;
            
        case kSceneState_ship_upgrades_defense_chooser:
            
            if(CGRectContainsPoint(CGRectMake(15, 440, backButton.imageWidth, backButton.imageHeight), location)){
                currentSceneState = kSceneState_ship_upgrades;
            }

            break;

        default:
            
            break;
    }
    
    NSLog(@"X:%f Y:%f", location.x, location.y);
}

- (void)updateWithTouchLocationMoved:(NSSet *)touches withEvent:(UIEvent *)event view:(UIView *)aView {
    UITouch *touch = [[event touchesForView:aView] anyObject];
	CGPoint location;
	location = [touch locationInView:aView];
    
	// Flip the y location ready to check it against OpenGL coordinates
	location.y = 480-location.y;
}

- (int)priceOfCurrentSelectedWeapon {
    if([currentSelectedWeaponType isEqualToString:kWeaponTypeBullet]){
        if(currentBulletLevelSelection == 1){
            return kBulletLevelOne_Price;
        }
        if(currentBulletLevelSelection == 2){
            return kBulletLevelTwo_Price;
        }
        if(currentBulletLevelSelection == 3){
            return kBulletLevelThree_Price;
        }
        if(currentBulletLevelSelection == 4){
            return kBulletLevelFour_Price;
        }
        if(currentBulletLevelSelection == 5){
            return kBulletLevelFive_Price;
        }
        if(currentBulletLevelSelection == 6){
            return kBulletLevelSix_Price;
        }
        if(currentBulletLevelSelection == 7){
            return kBulletLevelSeven_Price;
        }
        if(currentBulletLevelSelection == 8){
            return kBulletLevelEight_Price;
        }
        if(currentBulletLevelSelection == 9){
            return kBulletLevelNine_Price;
        }
        if(currentBulletLevelSelection == 10){
            return kBulletLevelTen_Price;
        }
    }
    else if([currentSelectedWeaponType isEqualToString:kWeaponTypeWave]){
        if(currentWaveLevelSelection == 1){
            return kWaveLevelOne_Price;
        }
        if(currentWaveLevelSelection == 2){
            return kWaveLevelTwo_Price;
        }
        if(currentWaveLevelSelection == 3){
            return kWaveLevelThree_Price;
        }
        if(currentWaveLevelSelection == 4){
            return kWaveLevelFour_Price;
        }
        if(currentWaveLevelSelection == 5){
            return kWaveLevelFive_Price;
        }
        if(currentWaveLevelSelection == 6){
            return kWaveLevelSix_Price;
        }
        if(currentWaveLevelSelection == 7){
            return kWaveLevelSeven_Price;
        }
        if(currentWaveLevelSelection == 8){
            return kWaveLevelEight_Price;
        }
        if(currentWaveLevelSelection == 9){
            return kWaveLevelNine_Price;
        }
        if(currentWaveLevelSelection == 10){
            return kWaveLevelTen_Price;
        }
    }
    
    else if([currentSelectedWeaponType isEqualToString:kWeaponTypeMissile]){
        if(currentMissileLevelSelection == 1){
            return kMissileLevelOne_Price;
        }
        if(currentMissileLevelSelection == 2){
            return kMissileLevelTwo_Price;
        }
        if(currentMissileLevelSelection == 3){
            return kMissileLevelThree_Price;
        }
        if(currentMissileLevelSelection == 4){
            return kMissileLevelFour_Price;
        }
        if(currentMissileLevelSelection == 5){
            return kMissileLevelFive_Price;
        }
        if(currentMissileLevelSelection == 6){
            return kMissileLevelSix_Price;
        }
        if(currentMissileLevelSelection == 7){
            return kMissileLevelSeven_Price;
        }
        if(currentMissileLevelSelection == 8){
            return kMissileLevelEight_Price;
        }
        if(currentMissileLevelSelection == 9){
            return kMissileLevelNine_Price;
        }
        if(currentMissileLevelSelection == 10){
            return kMissileLevelTen_Price;
        }
    }
    
    else if([currentSelectedWeaponType isEqualToString:kWeaponTypeHeatseeking]){
        if(currentHeatseekingLevelSelection == 1){
            return kHeatseekerLevelOne_Price;
        }
    }
    else {
        return -1;
    }
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
            [font drawStringAt:CGPointMake(115.0f, 460.0f) text:@"Base"];
            [font setScale:0.5];
            [previousButton renderAtPoint:CGPointMake(95.0f, 287.0f) centerOfImage:YES];
            [font drawStringAt:CGPointMake(110.0f, 300.0f) text:@"XPX-XXX"];
            [nextButton renderAtPoint:CGPointMake(235.0f, 287.0f) centerOfImage:YES];
            
            [font drawStringAt:CGPointMake(120.0f, 230.0f) text:@"Stats"];
            
            [font setScale:0.4];
            [font drawStringAt:CGPointMake(20.0f, 180.0f) text:@"ATK:"];
            [font drawStringAt:CGPointMake(20.0f, 150.0f) text:@"SPD:"];
            [font drawStringAt:CGPointMake(20.0f, 120.0f) text:@"DEF:"];
            
            [font setScale:0.7];
            
            [equipButton renderAtPoint:CGPointMake(280.0f, 70.0f) centerOfImage:YES];
            [buyButton renderAtPoint:CGPointMake(280.0f, 30.0f) centerOfImage:YES];
            
            break;
            
        case kSceneState_ship_upgrades_attack_chooser:
            [font drawStringAt:CGPointMake(105.0f, 460.0f) text:@"Attack"];
            [font setScale:0.5];
            [previousButton renderAtPoint:CGPointMake(95.0f, 287.0f) centerOfImage:YES];
            [font drawStringAt:CGPointMake(110.0f, 300.0f) text:@"XPX-XXX"];
            [nextButton renderAtPoint:CGPointMake(235.0f, 287.0f) centerOfImage:YES];
            
            [font drawStringAt:CGPointMake(120.0f, 230.0f) text:@"Stats"];
            
            [font setScale:0.4];
            [font drawStringAt:CGPointMake(20.0f, 180.0f) text:@"ATK:"];
            [font drawStringAt:CGPointMake(20.0f, 150.0f) text:@"SPD:"];
            [font drawStringAt:CGPointMake(20.0f, 120.0f) text:@"DEF:"];
            
            [font setScale:0.7];
            
            [equipButton renderAtPoint:CGPointMake(280.0f, 70.0f) centerOfImage:YES];
            [buyButton renderAtPoint:CGPointMake(280.0f, 30.0f) centerOfImage:YES];

            break;
            
        case kSceneState_ship_upgrades_speed_chooser:
            [font drawStringAt:CGPointMake(115.0f, 460.0f) text:@"Speed"];
            [font setScale:0.5];
            [previousButton renderAtPoint:CGPointMake(95.0f, 287.0f) centerOfImage:YES];
            [font drawStringAt:CGPointMake(110.0f, 300.0f) text:@"XPX-XXX"];
            [nextButton renderAtPoint:CGPointMake(235.0f, 287.0f) centerOfImage:YES];
            
            [font drawStringAt:CGPointMake(120.0f, 230.0f) text:@"Stats"];
            
            [font setScale:0.4];
            [font drawStringAt:CGPointMake(20.0f, 180.0f) text:@"ATK:"];
            [font drawStringAt:CGPointMake(20.0f, 150.0f) text:@"SPD:"];
            [font drawStringAt:CGPointMake(20.0f, 120.0f) text:@"DEF:"];
            
            [font setScale:0.7];
            
            [equipButton renderAtPoint:CGPointMake(280.0f, 70.0f) centerOfImage:YES];
            [buyButton renderAtPoint:CGPointMake(280.0f, 30.0f) centerOfImage:YES];

            break;
            
        case kSceneState_ship_upgrades_defense_chooser:
            [font drawStringAt:CGPointMake(95.0f, 460.0f) text:@"Defense"];
            [font setScale:0.5];
            [previousButton renderAtPoint:CGPointMake(95.0f, 287.0f) centerOfImage:YES];
            [font drawStringAt:CGPointMake(110.0f, 300.0f) text:@"XPX-XXX"];
            [nextButton renderAtPoint:CGPointMake(235.0f, 287.0f) centerOfImage:YES];
            
            [font drawStringAt:CGPointMake(120.0f, 230.0f) text:@"Stats"];
            
            [font setScale:0.4];
            [font drawStringAt:CGPointMake(20.0f, 180.0f) text:@"ATK:"];
            [font drawStringAt:CGPointMake(20.0f, 150.0f) text:@"SPD:"];
            [font drawStringAt:CGPointMake(20.0f, 120.0f) text:@"DEF:"];
            
            [font setScale:0.7];
            
            [equipButton renderAtPoint:CGPointMake(280.0f, 70.0f) centerOfImage:YES];
            [buyButton renderAtPoint:CGPointMake(280.0f, 30.0f) centerOfImage:YES];

            break;
            
        case kSceneState_weapons_upgrades:
            [font drawStringAt:CGPointMake(90.0f, 460.0) text:@"Weapons"];

            [font setScale:0.35];
            
            if([currentEquippedWeapon isEqualToString:kWeaponTypeBullet] && currentEquippedWeaponLevel == currentBulletLevelSelection){
                [weaponsMenuBulletsButtonEquipped renderAtPoint:CGPointMake(160.0f, 360.0f) centerOfImage:YES];
            }
            else {
                [weaponsMenuBulletsButton renderAtPoint:CGPointMake(160.0f, 360.0f) centerOfImage:YES];
            }
            if(currentBulletLevelSelection > 1){
                [previousButton renderAtPoint:CGPointMake(105.0f, 325.0f) centerOfImage:YES];
            }
            [font drawStringAt:CGPointMake(120.0, 340.0f) text:[NSString stringWithFormat:@"Level: %d", currentBulletLevelSelection]];
            if(currentBulletLevelSelection < 10){
                [nextButton renderAtPoint:CGPointMake(220.0f, 325.0f) centerOfImage:YES];
            }
            
            if (wavesWeaponsUnlocked) {
                if ([currentEquippedWeapon isEqualToString:kWeaponTypeWave] && currentEquippedWeaponLevel == currentWaveLevelSelection) {
                    [weaponsMenuWavesButtonEquipped renderAtPoint:CGPointMake(160.0f, 280.0f) centerOfImage:YES];
                }
                else {
                    [weaponsMenuWavesButton renderAtPoint:CGPointMake(160.0f, 280.0f) centerOfImage:YES];
                }
                
                if(currentWaveLevelSelection > 1){
                    [previousButton renderAtPoint:CGPointMake(105.0f, 245.0f) centerOfImage:YES];
                }
                [font drawStringAt:CGPointMake(120.0, 260.0f) text:[NSString stringWithFormat:@"Level: %d", currentWaveLevelSelection]];
                if(currentWaveLevelSelection < 10){
                    [nextButton renderAtPoint:CGPointMake(220.0f, 245.0f) centerOfImage:YES];
                }
            } else {
                [weaponsMenuWavesButtonDisabled renderAtPoint:CGPointMake(160.0f, 280.0f) centerOfImage:YES];
            }
                        
            if (missilesWeaponsUnlocked) {
                if ([currentEquippedWeapon isEqualToString:kWeaponTypeMissile] && currentEquippedWeaponLevel == currentMissileLevelSelection) {
                    [weaponsMenuMissilesButton renderAtPoint:CGPointMake(160.0f, 200.0f) centerOfImage:YES];
                }
                else {
                    [weaponsMenuMissilesButton renderAtPoint:CGPointMake(160.0f, 200.0f) centerOfImage:YES];
                }
                
                if(currentMissileLevelSelection > 1){
                    [previousButton renderAtPoint:CGPointMake(105.0f, 165.0f) centerOfImage:YES];
                }
                [font drawStringAt:CGPointMake(120.0, 180.0f) text:[NSString stringWithFormat:@"Level: %d", currentMissileLevelSelection]];
                if(currentMissileLevelSelection < 10){
                    [nextButton renderAtPoint:CGPointMake(220.0f, 165.0f) centerOfImage:YES];
                }
            } else {
                [weaponsMenuMissilesButtonDisabled renderAtPoint:CGPointMake(160.0f, 200.0f) centerOfImage:YES];
            }
            
            if (heatseekingWeaponsUnlocked) {
                
                if ([currentEquippedWeapon isEqualToString:kWeaponTypeHeatseeking] && currentEquippedWeaponLevel == currentHeatseekingLevelSelection) {
                    [weaponsMenuHeatseekingButton renderAtPoint:CGPointMake(160.0f, 120.0f) centerOfImage:YES];
                }
                else {
                    [weaponsMenuHeatseekingButton renderAtPoint:CGPointMake(160.0f, 120.0f) centerOfImage:YES];
                }
                
                if(currentHeatseekingLevelSelection > 1){
                    [previousButton renderAtPoint:CGPointMake(105.0f, 85.0f) centerOfImage:YES];
                }
                [font drawStringAt:CGPointMake(120.0, 100.0f) text:[NSString stringWithFormat:@"Level: %d", currentHeatseekingLevelSelection]];
                if(currentHeatseekingLevelSelection < 10){
                    [nextButton renderAtPoint:CGPointMake(220.0f, 85.0f) centerOfImage:YES];
                }
            } else {
                [weaponsMenuHeatseekingButtonDisabled renderAtPoint:CGPointMake(160.0f, 120.0f) centerOfImage:YES];
            }
            
            [font setScale:0.7];
            
            
            if([currentSelectedWeaponType isEqualToString:kWeaponTypeBullet]){
                if((currentBulletLevelSelection - highestAchievedBulletLevel) == 1){
                    if([[settings objectForKey:kSetting_SaveGameCredits] intValue] >= [self priceOfCurrentSelectedWeapon]){
                        //To buy
                        [buyButton renderAtPoint:CGPointMake(270.0f, 377.0f) centerOfImage:YES];
                    }
                    else {
                        //Unable to buy
                        [buyButtonDisabled renderAtPoint:CGPointMake(270.0f, 377.0f) centerOfImage:YES];
                    }
                }
                if(currentBulletLevelSelection <= highestAchievedBulletLevel){
                    //Bought
                    [boughtButton renderAtPoint:CGPointMake(270.0f, 377.0f) centerOfImage:YES];
                }
                
                
                if([currentEquippedWeapon isEqualToString:kWeaponTypeBullet]){
                    if(currentEquippedWeaponLevel == currentBulletLevelSelection){
                        //Equipped
                        [equippedButton renderAtPoint:CGPointMake(270.0f, 343.0f) centerOfImage:YES];
                    }
                    if(currentBulletLevelSelection != currentEquippedWeaponLevel && currentBulletLevelSelection <= highestAchievedBulletLevel){
                        //To equip
                        [equipButton renderAtPoint:CGPointMake(270.0f, 343.0f) centerOfImage:YES];
                    }
                    else {
                        //Unable to equip
                        [equipButtonDisabled renderAtPoint:CGPointMake(270.0f, 343.0f) centerOfImage:YES];
                    }
                }
            }
            else if([currentSelectedWeaponType isEqualToString:kWeaponTypeWave]){
                if((currentWaveLevelSelection - highestAchievedWaveLevel) == 1){
                    if([[settings objectForKey:kSetting_SaveGameCredits] intValue] >= [self priceOfCurrentSelectedWeapon]){
                        //To buy
                        [buyButton renderAtPoint:CGPointMake(270.0f, 297.0f) centerOfImage:YES];
                    }
                    else {
                        //Unable to buy
                        [buyButtonDisabled renderAtPoint:CGPointMake(270.0f, 297.0f) centerOfImage:YES];
                    }
                }
                if(currentWaveLevelSelection <= highestAchievedWaveLevel){
                    //Bought
                    [boughtButton renderAtPoint:CGPointMake(270.0f, 297.0f) centerOfImage:YES];
                }
                
                
                if([currentEquippedWeapon isEqualToString:kWeaponTypeWave]){
                    if(currentEquippedWeaponLevel == currentWaveLevelSelection){
                        //Equipped
                        [equippedButton renderAtPoint:CGPointMake(270.0f, 263.0f) centerOfImage:YES];
                    }
                    if(currentWaveLevelSelection != currentEquippedWeaponLevel && currentWaveLevelSelection <= highestAchievedWaveLevel){
                        //To equip
                        [equipButton renderAtPoint:CGPointMake(270.0f, 263.0f) centerOfImage:YES];
                    }
                    else {
                        //Unable to equip
                        [equipButtonDisabled renderAtPoint:CGPointMake(270.0f, 263.0f) centerOfImage:YES];
                    }
                }
            }
            else if([currentSelectedWeaponType isEqualToString:kWeaponTypeMissile]){
                if((currentMissileLevelSelection - highestAchievedMissileLevel) == 1){
                    if([[settings objectForKey:kSetting_SaveGameCredits] intValue] >= [self priceOfCurrentSelectedWeapon]){
                        //To buy
                        [buyButton renderAtPoint:CGPointMake(270.0f, 217.0f) centerOfImage:YES];
                    }
                    else {
                        //Unable to buy
                        [buyButtonDisabled renderAtPoint:CGPointMake(270.0f, 217.0f) centerOfImage:YES];
                    }
                }
                if(currentMissileLevelSelection <= highestAchievedMissileLevel){
                    //Bought
                    [boughtButton renderAtPoint:CGPointMake(270.0f, 217.0f) centerOfImage:YES];
                }
                
                
                if([currentEquippedWeapon isEqualToString:kWeaponTypeMissile]){
                    if(currentEquippedWeaponLevel == currentMissileLevelSelection){
                        //Equipped
                        [equippedButton renderAtPoint:CGPointMake(270.0f, 183.0f) centerOfImage:YES];
                    }
                    if(currentMissileLevelSelection != currentEquippedWeaponLevel && currentMissileLevelSelection <= highestAchievedMissileLevel){
                        //To equip
                        [equipButton renderAtPoint:CGPointMake(270.0f, 183.0f) centerOfImage:YES];
                    }
                    else {
                        //Unable to equip
                        [equipButtonDisabled renderAtPoint:CGPointMake(270.0f, 183.0f) centerOfImage:YES];
                    }
                }
            }
            else if([currentSelectedWeaponType isEqualToString:kWeaponTypeHeatseeking]){
                if((currentHeatseekingLevelSelection - highestAchievedHeatseekingLevel) == 1){
                    if([[settings objectForKey:kSetting_SaveGameCredits] intValue] >= [self priceOfCurrentSelectedWeapon]){
                        //To buy
                        [buyButton renderAtPoint:CGPointMake(270.0f, 137.0f) centerOfImage:YES];
                    }
                    else {
                        //Unable to buy
                        [buyButtonDisabled renderAtPoint:CGPointMake(270.0f, 137.0f) centerOfImage:YES];
                    }
                }
                if(currentHeatseekingLevelSelection <= highestAchievedHeatseekingLevel){
                    //Bought
                    [boughtButton renderAtPoint:CGPointMake(270.0f, 137.0f) centerOfImage:YES];
                }
                
                
                if([currentEquippedWeapon isEqualToString:kWeaponTypeHeatseeking]){
                    if(currentEquippedWeaponLevel == currentHeatseekingLevelSelection){
                        //Equipped
                        [equippedButton renderAtPoint:CGPointMake(270.0f, 103.0f) centerOfImage:YES];
                    }
                    if(currentHeatseekingLevelSelection != currentEquippedWeaponLevel && currentHeatseekingLevelSelection <= highestAchievedHeatseekingLevel){
                        //To equip
                        [equipButton renderAtPoint:CGPointMake(270.0f, 103.0f) centerOfImage:YES];
                    }
                    else {
                        //Unable to equip
                        [equipButtonDisabled renderAtPoint:CGPointMake(270.0f, 103.0f) centerOfImage:YES];
                    }
                }
            }
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
