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
		
		_sceneFadeSpeed = 1.5f;
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
    generalMenuShipsButton = [[Image alloc] initWithImage:@"Ships.png" scale:Scale2fOne];
    generalMenuWeaponsButton = [[Image alloc] initWithImage:@"Weapons.png" scale:Scale2fOne];

    shipsMenuBaseButton = [[Image alloc] initWithImage:@"Base.png" scale:Scale2fOne];
    shipsMenuAttackButton = [[Image alloc] initWithImage:@"Attack.png" scale:Scale2fOne];
    shipsMenuSpeedButton = [[Image alloc] initWithImage:@"Speed.png" scale:Scale2fOne];
    shipsMenuDefenseButton = [[Image alloc] initWithImage:@"Defense.png" scale:Scale2fOne];
    
    weaponsMenuBulletsButton = [[Image alloc] initWithImage:@"Bullet.png" scale:Scale2fOne];
    weaponsMenuWavesButton = [[Image alloc] initWithImage:@"Wave.png" scale:Scale2fOne];
    weaponsMenuMissilesButton = [[Image alloc] initWithImage:@"Missile.png" scale:Scale2fOne];
    weaponsMenuHeatseekingButton = [[Image alloc] initWithImage:@"Heatseeking.png" scale:Scale2fOne];
    
    weaponsMenuBulletsButtonEquipped = [[Image alloc] initWithImage:@"Bullet-Equipped.png" scale:Scale2fOne];
    weaponsMenuWavesButtonEquipped = [[Image alloc] initWithImage:@"Wave-Equipped.png" scale:Scale2fOne];
    weaponsMenuMissilesButtonEquipped = [[Image alloc] initWithImage:@"Missile-Equipped.png" scale:Scale2fOne];
    weaponsMenuHeatseekingButtonEquipped = [[Image alloc] initWithImage:@"Heatseeking-Equipped.png" scale:Scale2fOne];
    
    weaponsMenuWavesButtonDisabled = [[Image alloc] initWithImage:@"Wave-Disabled.png" scale:Scale2fOne];
    weaponsMenuMissilesButtonDisabled = [[Image alloc] initWithImage:@"Missile-Disabled.png" scale:Scale2fOne];
    weaponsMenuHeatseekingButtonDisabled = [[Image alloc] initWithImage:@"Heatseeking-Disabled.png" scale:Scale2fOne];
    shipsMenuBaseButtonDisabled = [[Image alloc] initWithImage:@"Base-Disabled.png" scale:Scale2fOne];
    shipsMenuAttackButtonDisabled = [[Image alloc] initWithImage:@"Attack-Disabled.png" scale:Scale2fOne];
    shipsMenuSpeedButtonDisabled = [[Image alloc] initWithImage:@"Speed-Disabled.png" scale:Scale2fOne];
    shipsMenuDefenseButtonDisabled = [[Image alloc] initWithImage:@"Defense-Disabled.png" scale:Scale2fOne];
            
    nextButton = [[Image alloc] initWithImage:@"nextbutton.png" scale:Scale2fOne];
    previousButton = [[Image alloc] initWithImage:@"previousbutton.png" scale:Scale2fOne];
    
    equipButton = [[Image alloc] initWithImage:@"Equip.png" scale:Scale2fOne];
    buyButton = [[Image alloc] initWithImage:@"Buy.png" scale:Scale2fOne];
    equipButtonDisabled = [[Image alloc] initWithImage:@"Equip-Disabled.png" scale:Scale2fOne];
    buyButtonDisabled = [[Image alloc] initWithImage:@"Buy-Disabled.png" scale:Scale2fOne];
    equippedButton = [[Image alloc] initWithImage:@"Equipped.png" scale:Scale2fOne];
    boughtButton = [[Image alloc] initWithImage:@"Buy-Bought.png" scale:Scale2fOne];
    
    currentBulletLevelSelection = 0;
    currentWaveLevelSelection = 0;
    currentMissileLevelSelection = 0;
    currentHeatseekingLevelSelection = 0;
    
    currentEquippedWeapon = [[NSMutableString alloc] init];
    currentSelectedWeaponType = [[NSMutableString alloc] initWithString:kWeaponTypeBullet];
    
    currentEquippedShipType = [[NSMutableString alloc] init];
    
    //Preview files:
    previewShipImages = [[NSMutableDictionary alloc] init];
    [previewShipImages setObject:[[[Image alloc] initWithImage:@"XP-750.png" scale:Scale2fOne] autorelease] forKey:kXP750];
    [previewShipImages setObject:[[[Image alloc] initWithImage:@"XP-751.png" scale:Scale2fOne] autorelease] forKey:kXP751];
    [previewShipImages setObject:[[[Image alloc] initWithImage:@"XPA-368.png" scale:Scale2fOne] autorelease] forKey:kXPA368];
    [previewShipImages setObject:[[[Image alloc] initWithImage:@"XPA-600.png" scale:Scale2fOne] autorelease] forKey:kXPA600];
    [previewShipImages setObject:[[[Image alloc] initWithImage:@"XPA-617.png" scale:Scale2fOne] autorelease] forKey:kXPA617];
    [previewShipImages setObject:[[[Image alloc] initWithImage:@"XPA-652.png" scale:Scale2fOne] autorelease] forKey:kXPA652];
    [previewShipImages setObject:[[[Image alloc] initWithImage:@"XPA-679.png" scale:Scale2fOne] autorelease] forKey:kXPA679];
    [previewShipImages setObject:[[[Image alloc] initWithImage:@"XPS-400.png" scale:Scale2fOne] autorelease] forKey:kXPS400];
    [previewShipImages setObject:[[[Image alloc] initWithImage:@"XPS-424.png" scale:Scale2fOne] autorelease] forKey:kXPS424];
    [previewShipImages setObject:[[[Image alloc] initWithImage:@"XPS-447.png" scale:Scale2fOne] autorelease] forKey:kXPS447];
    [previewShipImages setObject:[[[Image alloc] initWithImage:@"XPS-463.png" scale:Scale2fOne] autorelease] forKey:kXPS463];
    [previewShipImages setObject:[[[Image alloc] initWithImage:@"XPS-485.png" scale:Scale2fOne] autorelease] forKey:kXPS485];
    [previewShipImages setObject:[[[Image alloc] initWithImage:@"XPD-900.png" scale:Scale2fOne] autorelease] forKey:kXPD900];
    [previewShipImages setObject:[[[Image alloc] initWithImage:@"XPD-909.png" scale:Scale2fOne] autorelease] forKey:kXPD909];
    [previewShipImages setObject:[[[Image alloc] initWithImage:@"XPD-924.png" scale:Scale2fOne] autorelease] forKey:kXPD924];
    [previewShipImages setObject:[[[Image alloc] initWithImage:@"XPD-945.png" scale:Scale2fOne] autorelease] forKey:kXPD945];
    [previewShipImages setObject:[[[Image alloc] initWithImage:@"XPD-968.png" scale:Scale2fOne] autorelease] forKey:kXPD968];
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
    
    if([[settings objectForKey:kSetting_SaveGameUnlockedShips] containsObject:kXP751]){
        attackShipsUnlocked = YES;
        speedShipsUnlocked = YES;
        defenseShipsUnlocked = YES;
    }
    
    currentBulletLevelSelection = 1;
    currentWaveLevelSelection = 1;
    currentMissileLevelSelection = 1;
    currentHeatseekingLevelSelection = 1;
    
    currentBaseShipLevelSelection = 1;
    currentAttackShipLevelSelection = 1;
    currentSpeedShipLevelSelection = 1;
    currentDefenseShipLevelSelection = 1;
    
    
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
    
    //Base
    if([[settings objectForKey:kSetting_SaveGameUnlockedShips] containsObject:kXP750]){
        highestAchievedBaseLevel = 1;
        if([[settings objectForKey:kSetting_SaveGameEquippedShip] isEqualToString:kXP750]){
            currentBaseShipLevelSelection = 1;
            [currentEquippedShipType setString:kXP750];
        }
    }
    if([[settings objectForKey:kSetting_SaveGameUnlockedShips] containsObject:kXP751]){
        highestAchievedBaseLevel = 2;
        if([[settings objectForKey:kSetting_SaveGameEquippedShip] isEqualToString:kXP751]){
            currentBaseShipLevelSelection = 2;
            [currentEquippedShipType setString:kXP751];
        }
    }
    
    //Attack
    if([[settings objectForKey:kSetting_SaveGameUnlockedShips] containsObject:kXPA368]){
        highestAchievedAttackLevel = 1;
        if([[settings objectForKey:kSetting_SaveGameEquippedShip] isEqualToString:kXPA368]){
            currentBaseShipLevelSelection = 1;
            [currentEquippedShipType setString:kXPA368];
        }
    }
    if([[settings objectForKey:kSetting_SaveGameUnlockedShips] containsObject:kXPA600]){
        highestAchievedAttackLevel = 2;
        if([[settings objectForKey:kSetting_SaveGameEquippedShip] isEqualToString:kXPA600]){
            currentAttackShipLevelSelection = 2;
            [currentEquippedShipType setString:kXPA600];
        }
    }
    if([[settings objectForKey:kSetting_SaveGameUnlockedShips] containsObject:kXPA617]){
        highestAchievedAttackLevel = 3;
        if([[settings objectForKey:kSetting_SaveGameEquippedShip] isEqualToString:kXPA617]){
            currentAttackShipLevelSelection = 3;
            [currentEquippedShipType setString:kXPA617];
        }
    }
    if([[settings objectForKey:kSetting_SaveGameUnlockedShips] containsObject:kXPA652]){
        highestAchievedAttackLevel = 4;
        if([[settings objectForKey:kSetting_SaveGameEquippedShip] isEqualToString:kXPA652]){
            currentAttackShipLevelSelection = 4;
            [currentEquippedShipType setString:kXPA652];
        }
    }
    if([[settings objectForKey:kSetting_SaveGameUnlockedShips] containsObject:kXPA679]){
        highestAchievedAttackLevel = 5;
        if([[settings objectForKey:kSetting_SaveGameEquippedShip] isEqualToString:kXPA679]){
            currentAttackShipLevelSelection = 5;
            [currentEquippedShipType setString:kXPA679];
        }
    }
    
    //Speed
    if([[settings objectForKey:kSetting_SaveGameUnlockedShips] containsObject:kXPS400]){
        highestAchievedSpeedLevel = 1;
        if([[settings objectForKey:kSetting_SaveGameEquippedShip] isEqualToString:kXPS400]){
            currentSpeedShipLevelSelection = 1;
            [currentEquippedShipType setString:kXPS400];
        }
    }
    if([[settings objectForKey:kSetting_SaveGameUnlockedShips] containsObject:kXPS424]){
        highestAchievedSpeedLevel = 2;
        if([[settings objectForKey:kSetting_SaveGameEquippedShip] isEqualToString:kXPS424]){
            currentSpeedShipLevelSelection = 2;
            [currentEquippedShipType setString:kXPS424];
        }
    }
    if([[settings objectForKey:kSetting_SaveGameUnlockedShips] containsObject:kXPS447]){
        highestAchievedSpeedLevel = 3;
        if([[settings objectForKey:kSetting_SaveGameEquippedShip] isEqualToString:kXPS447]){
            currentSpeedShipLevelSelection = 3;
            [currentEquippedShipType setString:kXPS447];
        }
    }
    if([[settings objectForKey:kSetting_SaveGameUnlockedShips] containsObject:kXPS463]){
        highestAchievedSpeedLevel = 4;
        if([[settings objectForKey:kSetting_SaveGameEquippedShip] isEqualToString:kXPS463]){
            currentSpeedShipLevelSelection = 4;
            [currentEquippedShipType setString:kXPS463];
        }
    }
    if([[settings objectForKey:kSetting_SaveGameUnlockedShips] containsObject:kXPS485]){
        highestAchievedSpeedLevel = 5;
        if([[settings objectForKey:kSetting_SaveGameEquippedShip] isEqualToString:kXPS485]){
            currentSpeedShipLevelSelection = 5;
            [currentEquippedShipType setString:kXPS485];
        }
    }
    
    //Defense
    if([[settings objectForKey:kSetting_SaveGameUnlockedShips] containsObject:kXPD900]){
        highestAchievedDefenseLevel = 1;
        if([[settings objectForKey:kSetting_SaveGameEquippedShip] isEqualToString:kXPD900]){
            currentDefenseShipLevelSelection = 1;
            [currentEquippedShipType setString:kXPD900];
        }
    }
    if([[settings objectForKey:kSetting_SaveGameUnlockedShips] containsObject:kXPD909]){
        highestAchievedDefenseLevel = 2;
        if([[settings objectForKey:kSetting_SaveGameEquippedShip] isEqualToString:kXPD909]){
            currentDefenseShipLevelSelection = 2;
            [currentEquippedShipType setString:kXPD909];
        }
    }
    if([[settings objectForKey:kSetting_SaveGameUnlockedShips] containsObject:kXPD924]){
        highestAchievedDefenseLevel = 3;
        if([[settings objectForKey:kSetting_SaveGameEquippedShip] isEqualToString:kXPD924]){
            currentDefenseShipLevelSelection = 3;
            [currentEquippedShipType setString:kXPD924];
        }
    }
    if([[settings objectForKey:kSetting_SaveGameUnlockedShips] containsObject:kXPD945]){
        highestAchievedDefenseLevel = 4;
        if([[settings objectForKey:kSetting_SaveGameEquippedShip] isEqualToString:kXPD945]){
            currentDefenseShipLevelSelection = 4;
            [currentEquippedShipType setString:kXPD945];
        }
    }
    if([[settings objectForKey:kSetting_SaveGameUnlockedShips] containsObject:kXPD968]){
        highestAchievedDefenseLevel = 5;
        if([[settings objectForKey:kSetting_SaveGameEquippedShip] isEqualToString:kXPD968]){
            currentDefenseShipLevelSelection = 5;
            [currentEquippedShipType setString:kXPD968];
        }
    }
    
    NSLog(@"Current Equipped: %@ lvl %d", currentEquippedWeapon, currentEquippedWeaponLevel);
    NSLog(@"Current equipped ship: %@\nHighest ahcieved base, att, spd, def: %d %d %d %d", [self displayStringForShip:currentEquippedShipType], highestAchievedBaseLevel, highestAchievedAttackLevel, highestAchievedSpeedLevel, highestAchievedDefenseLevel);
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
            if (CGRectContainsPoint(CGRectMake(160.0f-(weaponsMenuBulletsButton.imageWidth/2), 360.0f-(weaponsMenuBulletsButton.imageHeight/2), weaponsMenuBulletsButton.imageWidth,weaponsMenuBulletsButton.imageHeight), location)) {
                [currentSelectedWeaponType setString:kWeaponTypeBullet];
            }
            if([currentSelectedWeaponType isEqualToString:kWeaponTypeBullet]){
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
                
                if(CGRectContainsPoint(CGRectMake(286.0f - (buyButton.imageWidth/2), 377.0f - (buyButton.imageHeight/2), buyButton.imageWidth, buyButton.imageHeight), location)){
                    //Try to buy
                    if([currentSelectedWeaponType isEqualToString:kWeaponTypeBullet]){
                        if((currentBulletLevelSelection - highestAchievedBulletLevel) == 1){
                            if([[settings objectForKey:kSetting_SaveGameCredits] intValue] >= [self priceOfCurrentSelectedWeapon]){
                                //To buy
                                if([self priceOfWeapon:kWeaponTypeBullet level:currentBulletLevelSelection] <= [[settings objectForKey:kSetting_SaveGameCredits] intValue]){
                                    NSLog(@"Preparing to buy...");
                                    [self buyCurrentWeapon:kWeaponTypeBullet level:currentBulletLevelSelection];
                                    NSLog(@"Bought! :D");
                                }
                            }
                        }
                    }
                }
                if(CGRectContainsPoint(CGRectMake(286.0f - (equipButton.imageWidth/2), 343.0f - (equipButton.imageHeight/2), equipButton.imageWidth, equipButton.imageHeight), location)){
                    if(currentBulletLevelSelection <= highestAchievedBulletLevel){
                        [self equipWeapon:currentSelectedWeaponType level:currentBulletLevelSelection];
                    }
                }
            }
            
            if (CGRectContainsPoint(CGRectMake(160.0f-(weaponsMenuWavesButton.imageWidth/2), 280.0f-(weaponsMenuWavesButton.imageHeight/2), weaponsMenuWavesButton.imageWidth, weaponsMenuWavesButton.imageHeight), location)) {
                [currentSelectedWeaponType setString:kWeaponTypeWave];
            }
            if (wavesWeaponsUnlocked && [currentSelectedWeaponType isEqualToString:kWeaponTypeWave]) {
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
                
                if(CGRectContainsPoint(CGRectMake(286.0f - (buyButton.imageWidth/2), 297.0f - (buyButton.imageHeight/2), buyButton.imageWidth, buyButton.imageHeight), location)){
                    //Try to buy
                    if([currentSelectedWeaponType isEqualToString:kWeaponTypeWave]){
                        if((currentWaveLevelSelection - highestAchievedWaveLevel) == 1){
                            if([[settings objectForKey:kSetting_SaveGameCredits] intValue] >= [self priceOfCurrentSelectedWeapon]){
                                //To buy
                                if([self priceOfWeapon:kWeaponTypeWave level:currentWaveLevelSelection] <= [[settings objectForKey:kSetting_SaveGameCredits] intValue]){
                                    [self buyCurrentWeapon:kWeaponTypeWave level:currentWaveLevelSelection];
                                }
                            }
                        }
                    }
                }
                if(CGRectContainsPoint(CGRectMake(286.0f - (equipButton.imageWidth/2), 263.0f - (equipButton.imageHeight/2), equipButton.imageWidth, equipButton.imageHeight), location)){
                    if(currentWaveLevelSelection <= highestAchievedWaveLevel){
                        [self equipWeapon:currentSelectedWeaponType level:currentWaveLevelSelection];
                    }
                }
            }
            
            if (CGRectContainsPoint(CGRectMake(160.0f-(weaponsMenuMissilesButton.imageWidth/2), 200.0f-(weaponsMenuMissilesButton.imageHeight/2), weaponsMenuMissilesButton.imageWidth, weaponsMenuMissilesButton.imageHeight), location)) {
                [currentSelectedWeaponType setString:kWeaponTypeMissile];
            }
            if (missilesWeaponsUnlocked && [currentSelectedWeaponType isEqualToString:kWeaponTypeMissile]) {
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
                
                if(CGRectContainsPoint(CGRectMake(286.0f - (buyButton.imageWidth/2), 217.0f - (buyButton.imageHeight/2), buyButton.imageWidth, buyButton.imageHeight), location)){
                    //Try to buy
                    if([currentSelectedWeaponType isEqualToString:kWeaponTypeMissile]){
                        if((currentMissileLevelSelection - highestAchievedMissileLevel) == 1){
                            if([[settings objectForKey:kSetting_SaveGameCredits] intValue] >= [self priceOfCurrentSelectedWeapon]){
                                //To buy
                                if([self priceOfWeapon:kWeaponTypeMissile level:currentMissileLevelSelection] <= [[settings objectForKey:kSetting_SaveGameCredits] intValue]){
                                    [self buyCurrentWeapon:kWeaponTypeMissile level:currentMissileLevelSelection];
                                }
                            }
                        }
                    }
                }
                if(CGRectContainsPoint(CGRectMake(286.0f - (equipButton.imageWidth/2), 183.0f - (equipButton.imageHeight/2), equipButton.imageWidth, equipButton.imageHeight), location)){
                    if(currentMissileLevelSelection <= highestAchievedMissileLevel){
                        [self equipWeapon:currentSelectedWeaponType level:currentMissileLevelSelection];
                    }
                }
            }            
             
            if (CGRectContainsPoint(CGRectMake(160.0f-(weaponsMenuHeatseekingButton.imageWidth/2), 120.0f-(weaponsMenuHeatseekingButton.imageHeight/2), weaponsMenuHeatseekingButton.imageWidth, weaponsMenuHeatseekingButton.imageHeight), location)) {
                [currentSelectedWeaponType setString:kWeaponTypeHeatseeking];
            }
            if (heatseekingWeaponsUnlocked && [currentSelectedWeaponType isEqualToString:kWeaponTypeHeatseeking]) {
                if (CGRectContainsPoint(CGRectMake(100.0f, 75.0f, 16, 16), location)) {
                    NSLog(@"Previous");
                    currentHeatseekingLevelSelection--;
                }
                else if (CGRectContainsPoint(CGRectMake(210.0f, 75.0f, 16, 16), location)) {
                    NSLog(@"Next");
                    currentHeatseekingLevelSelection++;
                }
                currentHeatseekingLevelSelection = MAX(1,currentHeatseekingLevelSelection);
                currentHeatseekingLevelSelection = MIN(currentHeatseekingLevelSelection, 1);
                
                if(CGRectContainsPoint(CGRectMake(286.0f - (buyButton.imageWidth/2), 137.0f - (buyButton.imageHeight/2), buyButton.imageWidth, buyButton.imageHeight), location)){
                    //Try to buy
                    if([currentSelectedWeaponType isEqualToString:kWeaponTypeHeatseeking]){
                        if((currentHeatseekingLevelSelection - highestAchievedHeatseekingLevel) == 1){
                            if([[settings objectForKey:kSetting_SaveGameCredits] intValue] >= [self priceOfCurrentSelectedWeapon]){
                                //To buy
                                if([self priceOfWeapon:kWeaponTypeHeatseeking level:currentHeatseekingLevelSelection] <= [[settings objectForKey:kSetting_SaveGameCredits] intValue]){
                                    [self buyCurrentWeapon:kWeaponTypeHeatseeking level:currentHeatseekingLevelSelection];
                                }
                            }
                        }
                    }
                }
                if(CGRectContainsPoint(CGRectMake(286.0f - (equipButton.imageWidth/2), 103.0f - (equipButton.imageHeight/2), equipButton.imageWidth, equipButton.imageHeight), location)){
                    if(currentHeatseekingLevelSelection <= highestAchievedHeatseekingLevel){
                        [self equipWeapon:currentSelectedWeaponType level:currentHeatseekingLevelSelection];
                    }
                }
            }
            
            break;    
            
        case kSceneState_ship_upgrades_base_chooser:
            
            if(CGRectContainsPoint(CGRectMake(15, 440, backButton.imageWidth, backButton.imageHeight), location)){
                currentSceneState = kSceneState_ship_upgrades;
            }
            
            if (CGRectContainsPoint(CGRectMake(87.0f, 279.0f, 16, 16), location)) {
                NSLog(@"Previous");
                currentBaseShipLevelSelection--;
            }
            else if (CGRectContainsPoint(CGRectMake(227.0f, 279.0f, 16, 16), location)) {
                NSLog(@"Next");
                currentBaseShipLevelSelection++;
            }
            currentBaseShipLevelSelection = MAX(1, currentBaseShipLevelSelection);
            currentBaseShipLevelSelection = MIN(currentBaseShipLevelSelection, 2);
            
            if(CGRectContainsPoint(CGRectMake(280.0f - (buyButton.imageWidth/2), 30.0f - (buyButton.imageHeight/2), buyButton.imageWidth, buyButton.imageHeight), location)){
                //Try to buy
                if((currentBaseShipLevelSelection - highestAchievedBaseLevel) == 1){
                    if([[settings objectForKey:kSetting_SaveGameCredits] intValue] >= [self priceOfShip:[self shipTypeFromCategory:kShipTypeBase andLevel:currentBaseShipLevelSelection]]){
                        //To buy
                        NSLog(@"Preparing to buy...");
                        [self buyShip:[self shipTypeFromCategory:kShipTypeBase andLevel:currentBaseShipLevelSelection]];
                        NSLog(@"Bought! :D");
                    }
                }
            }
            if(CGRectContainsPoint(CGRectMake(280.0f - (equipButton.imageWidth/2), 70.0f - (equipButton.imageHeight/2), equipButton.imageWidth, equipButton.imageHeight), location)){
                if(currentBaseShipLevelSelection <= highestAchievedBaseLevel){
                    //To equip
                    [self equipShip:[self shipTypeFromCategory:kShipTypeBase andLevel:currentBaseShipLevelSelection]];
                }
            }
            
            break;
            
        case kSceneState_ship_upgrades_attack_chooser:
            
            if(CGRectContainsPoint(CGRectMake(15, 440, backButton.imageWidth, backButton.imageHeight), location)){
                currentSceneState = kSceneState_ship_upgrades;
            }
            if (CGRectContainsPoint(CGRectMake(87.0f, 279.0f, 16, 16), location)) {
                NSLog(@"Previous");
                currentAttackShipLevelSelection--;
            }
            else if (CGRectContainsPoint(CGRectMake(227.0f, 279.0f, 16, 16), location)) {
                NSLog(@"Next");
                currentAttackShipLevelSelection++;
            }
            currentAttackShipLevelSelection = MAX(1, currentAttackShipLevelSelection);
            currentAttackShipLevelSelection = MIN(currentAttackShipLevelSelection, 5);
            
            if(CGRectContainsPoint(CGRectMake(280.0f - (buyButton.imageWidth/2), 30.0f - (buyButton.imageHeight/2), buyButton.imageWidth, buyButton.imageHeight), location)){
                //Try to buy
                if((currentAttackShipLevelSelection - highestAchievedAttackLevel) == 1){
                    if([[settings objectForKey:kSetting_SaveGameCredits] intValue] >= [self priceOfShip:[self shipTypeFromCategory:kShipTypeAttack andLevel:currentAttackShipLevelSelection]]){
                        //To buy
                        NSLog(@"Preparing to buy...");
                        [self buyShip:[self shipTypeFromCategory:kShipTypeAttack andLevel:currentAttackShipLevelSelection]];
                        NSLog(@"Bought! :D");
                    }
                }
            }
            if(CGRectContainsPoint(CGRectMake(280.0f - (equipButton.imageWidth/2), 70.0f - (equipButton.imageHeight/2), equipButton.imageWidth, equipButton.imageHeight), location)){
                if(currentAttackShipLevelSelection <= highestAchievedAttackLevel){
                    //To equip
                    [self equipShip:[self shipTypeFromCategory:kShipTypeAttack andLevel:currentAttackShipLevelSelection]];
                }
            }

            break;
            
        case kSceneState_ship_upgrades_speed_chooser:
            
            if(CGRectContainsPoint(CGRectMake(15, 440, backButton.imageWidth, backButton.imageHeight), location)){
                currentSceneState = kSceneState_ship_upgrades;
            }
            if (CGRectContainsPoint(CGRectMake(87.0f, 279.0f, 16, 16), location)) {
                NSLog(@"Previous");
                currentSpeedShipLevelSelection--;
            }
            else if (CGRectContainsPoint(CGRectMake(227.0f, 279.0f, 16, 16), location)) {
                NSLog(@"Next");
                currentSpeedShipLevelSelection++;
            }
            currentSpeedShipLevelSelection = MAX(1, currentSpeedShipLevelSelection);
            currentSpeedShipLevelSelection = MIN(currentSpeedShipLevelSelection, 5);
            
            if(CGRectContainsPoint(CGRectMake(280.0f - (buyButton.imageWidth/2), 30.0f - (buyButton.imageHeight/2), buyButton.imageWidth, buyButton.imageHeight), location)){
                //Try to buy
                if((currentSpeedShipLevelSelection - highestAchievedSpeedLevel) == 1){
                    if([[settings objectForKey:kSetting_SaveGameCredits] intValue] >= [self priceOfShip:[self shipTypeFromCategory:kShipTypeSpeed andLevel:currentSpeedShipLevelSelection]]){
                        //To buy
                        NSLog(@"Preparing to buy...");
                        [self buyShip:[self shipTypeFromCategory:kShipTypeSpeed andLevel:currentSpeedShipLevelSelection]];
                        NSLog(@"Bought! :D");
                    }
                }
            }
            if(CGRectContainsPoint(CGRectMake(280.0f - (equipButton.imageWidth/2), 70.0f - (equipButton.imageHeight/2), equipButton.imageWidth, equipButton.imageHeight), location)){
                if(currentSpeedShipLevelSelection <= highestAchievedSpeedLevel){
                    //To equip
                    [self equipShip:[self shipTypeFromCategory:kShipTypeSpeed andLevel:currentSpeedShipLevelSelection]];
                }
            }

            break;
            
        case kSceneState_ship_upgrades_defense_chooser:
            
            if(CGRectContainsPoint(CGRectMake(15, 440, backButton.imageWidth, backButton.imageHeight), location)){
                currentSceneState = kSceneState_ship_upgrades;
            }
            if (CGRectContainsPoint(CGRectMake(87.0f, 279.0f, 16, 16), location)) {
                NSLog(@"Previous");
                currentDefenseShipLevelSelection--;
            }
            else if (CGRectContainsPoint(CGRectMake(227.0f, 279.0f, 16, 16), location)) {
                NSLog(@"Next");
                currentDefenseShipLevelSelection++;
            }
            currentDefenseShipLevelSelection = MAX(1, currentDefenseShipLevelSelection);
            currentDefenseShipLevelSelection = MIN(currentDefenseShipLevelSelection, 5);
            
            if(CGRectContainsPoint(CGRectMake(280.0f - (buyButton.imageWidth/2), 30.0f - (buyButton.imageHeight/2), buyButton.imageWidth, buyButton.imageHeight), location)){
                //Try to buy
                if((currentDefenseShipLevelSelection - highestAchievedDefenseLevel) == 1){
                    if([[settings objectForKey:kSetting_SaveGameCredits] intValue] >= [self priceOfShip:[self shipTypeFromCategory:kShipTypeDefense andLevel:currentDefenseShipLevelSelection]]){
                        //To buy
                        NSLog(@"Preparing to buy...");
                        [self buyShip:[self shipTypeFromCategory:kShipTypeDefense andLevel:currentDefenseShipLevelSelection]];
                        NSLog(@"Bought! :D");
                    }
                }
            }
            if(CGRectContainsPoint(CGRectMake(280.0f - (equipButton.imageWidth/2), 70.0f - (equipButton.imageHeight/2), equipButton.imageWidth, equipButton.imageHeight), location)){
                if(currentDefenseShipLevelSelection <= highestAchievedDefenseLevel){
                    //To equip
                    [self equipShip:[self shipTypeFromCategory:kShipTypeDefense andLevel:currentDefenseShipLevelSelection]];
                }
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
        return [self priceOfWeapon:currentSelectedWeaponType level:currentBulletLevelSelection];
    }
    else if([currentSelectedWeaponType isEqualToString:kWeaponTypeWave]){
        return [self priceOfWeapon:currentSelectedWeaponType level:currentWaveLevelSelection];
    }
    
    else if([currentSelectedWeaponType isEqualToString:kWeaponTypeMissile]){
        return [self priceOfWeapon:currentSelectedWeaponType level:currentMissileLevelSelection];
    }
    
    else if([currentSelectedWeaponType isEqualToString:kWeaponTypeHeatseeking]){
        return [self priceOfWeapon:currentSelectedWeaponType level:currentHeatseekingLevelSelection];
    }
    
    return -1;
}

- (int)priceOfWeapon:(NSString *)weaponTypeName level:(int)level {
    if([weaponTypeName isEqualToString:kWeaponTypeBullet]){
        if(level == 1){
            return kBulletLevelOne_Price;
        }
        if(level == 2){
            return kBulletLevelTwo_Price;
        }
        if(level == 3){
            return kBulletLevelThree_Price;
        }
        if(level == 4){
            return kBulletLevelFour_Price;
        }
        if(level == 5){
            return kBulletLevelFive_Price;
        }
        if(level == 6){
            return kBulletLevelSix_Price;
        }
        if(level == 7){
            return kBulletLevelSeven_Price;
        }
        if(level == 8){
            return kBulletLevelEight_Price;
        }
        if(level == 9){
            return kBulletLevelNine_Price;
        }
        if(level == 10){
            return kBulletLevelTen_Price;
        }
    }
    else if([weaponTypeName isEqualToString:kWeaponTypeWave]){
        if(level == 1){
            return kWaveLevelOne_Price;
        }
        if(level == 2){
            return kWaveLevelTwo_Price;
        }
        if(level == 3){
            return kWaveLevelThree_Price;
        }
        if(level == 4){
            return kWaveLevelFour_Price;
        }
        if(level == 5){
            return kWaveLevelFive_Price;
        }
        if(level == 6){
            return kWaveLevelSix_Price;
        }
        if(level == 7){
            return kWaveLevelSeven_Price;
        }
        if(level == 8){
            return kWaveLevelEight_Price;
        }
        if(level == 9){
            return kWaveLevelNine_Price;
        }
        if(level == 10){
            return kWaveLevelTen_Price;
        }
    }
    
    else if([weaponTypeName isEqualToString:kWeaponTypeMissile]){
        if(level == 1){
            return kMissileLevelOne_Price;
        }
        if(level == 2){
            return kMissileLevelTwo_Price;
        }
        if(level == 3){
            return kMissileLevelThree_Price;
        }
        if(level == 4){
            return kMissileLevelFour_Price;
        }
        if(level == 5){
            return kMissileLevelFive_Price;
        }
        if(level == 6){
            return kMissileLevelSix_Price;
        }
        if(level == 7){
            return kMissileLevelSeven_Price;
        }
        if(level == 8){
            return kMissileLevelEight_Price;
        }
        if(level == 9){
            return kMissileLevelNine_Price;
        }
        if(level == 10){
            return kMissileLevelTen_Price;
        }
    }
    
    else if([weaponTypeName isEqualToString:kWeaponTypeHeatseeking]){
        if(level == 1){
            return kHeatseekerLevelOne_Price;
        }
    }
    
    return -1;
}

- (void)buyCurrentWeapon:(NSString *)weaponTypeName level:(int)level {
    NSMutableArray *unlockedWeaponsTempArray = [[NSMutableArray alloc] initWithArray:[settings objectForKey:kSetting_SaveGameUnlockedWeapons]];
    int playerCredits = [[settings objectForKey:kSetting_SaveGameCredits] intValue];
    
    if (weaponTypeName == kWeaponTypeBullet) {
        highestAchievedBulletLevel = level;
        switch (level) {
            case 2:
                [unlockedWeaponsTempArray addObject:kWeaponBulletLevelTwo];
                playerCredits -= [self priceOfWeapon:kWeaponTypeBullet level:2];
                break;
            case 3:
                [unlockedWeaponsTempArray addObject:kWeaponBulletLevelThree];
                playerCredits -= [self priceOfWeapon:kWeaponTypeBullet level:3];
                break;
            case 4:
                [unlockedWeaponsTempArray addObject:kWeaponBulletLevelFour];
                playerCredits -= [self priceOfWeapon:kWeaponTypeBullet level:4];
                break;
            case 5:
                [unlockedWeaponsTempArray addObject:kWeaponBulletLevelFive];
                playerCredits -= [self priceOfWeapon:kWeaponTypeBullet level:5];
                wavesWeaponsUnlocked = YES;
                break;
            case 6:
                [unlockedWeaponsTempArray addObject:kWeaponBulletLevelSix];
                playerCredits -= [self priceOfWeapon:kWeaponTypeBullet level:6];
                break;
            case 7:
                [unlockedWeaponsTempArray addObject:kWeaponBulletLevelSeven];
                playerCredits -= [self priceOfWeapon:kWeaponTypeBullet level:7];
                break;
            case 8:
                [unlockedWeaponsTempArray addObject:kWeaponBulletLevelEight];
                playerCredits -= [self priceOfWeapon:kWeaponTypeBullet level:8];
                break;
            case 9:
                [unlockedWeaponsTempArray addObject:kWeaponBulletLevelNine];
                playerCredits -= [self priceOfWeapon:kWeaponTypeBullet level:9];
                break;
            case 10:
                [unlockedWeaponsTempArray addObject:kWeaponBulletLevelTen];
                playerCredits -= [self priceOfWeapon:kWeaponTypeBullet level:10];
                break;
            default:
                break;
        }
    }
    if (weaponTypeName == kWeaponTypeWave) {
        highestAchievedWaveLevel = level;
        switch (level) {
            case 1:
                [unlockedWeaponsTempArray addObject:kWeaponWaveLevelOne];
                playerCredits -= [self priceOfWeapon:kWeaponTypeWave level:1];
                break;
            case 2:
                [unlockedWeaponsTempArray addObject:kWeaponWaveLevelTwo];
                playerCredits -= [self priceOfWeapon:kWeaponTypeWave level:2];
                break;
            case 3:
                [unlockedWeaponsTempArray addObject:kWeaponWaveLevelThree];
                playerCredits -= [self priceOfWeapon:kWeaponTypeWave level:3];
                break;
            case 4:
                [unlockedWeaponsTempArray addObject:kWeaponWaveLevelFour];
                playerCredits -= [self priceOfWeapon:kWeaponTypeWave level:4];
                break;
            case 5:
                [unlockedWeaponsTempArray addObject:kWeaponWaveLevelFive];
                playerCredits -= [self priceOfWeapon:kWeaponTypeWave level:5];
                missilesWeaponsUnlocked = YES;
                break;
            case 6:
                [unlockedWeaponsTempArray addObject:kWeaponWaveLevelSix];
                playerCredits -= [self priceOfWeapon:kWeaponTypeWave level:6];
                break;
            case 7:
                [unlockedWeaponsTempArray addObject:kWeaponWaveLevelSeven];
                playerCredits -= [self priceOfWeapon:kWeaponTypeWave level:7];
                break;
            case 8:
                [unlockedWeaponsTempArray addObject:kWeaponWaveLevelEight];
                playerCredits -= [self priceOfWeapon:kWeaponTypeWave level:8];
                break;
            case 9:
                [unlockedWeaponsTempArray addObject:kWeaponWaveLevelNine];
                playerCredits -= [self priceOfWeapon:kWeaponTypeWave level:9];
                break;
            case 10:
                [unlockedWeaponsTempArray addObject:kWeaponWaveLevelTen];
                playerCredits -= [self priceOfWeapon:kWeaponTypeWave level:10];
                break;
            default:
                break;
        }
    }
    if (weaponTypeName == kWeaponTypeMissile) {
        highestAchievedMissileLevel = level;
        switch (level) {
            case 1:
                [unlockedWeaponsTempArray addObject:kWeaponMissileLevelOne];
                playerCredits -= [self priceOfWeapon:kWeaponTypeMissile level:1];
                break;
            case 2:
                [unlockedWeaponsTempArray addObject:kWeaponMissileLevelTwo];
                playerCredits -= [self priceOfWeapon:kWeaponTypeMissile level:2];
                break;
            case 3:
                [unlockedWeaponsTempArray addObject:kWeaponMissileLevelThree];
                playerCredits -= [self priceOfWeapon:kWeaponTypeMissile level:3];
                break;
            case 4:
                [unlockedWeaponsTempArray addObject:kWeaponMissileLevelFour];
                playerCredits -= [self priceOfWeapon:kWeaponTypeMissile level:4];
                break;
            case 5:
                [unlockedWeaponsTempArray addObject:kWeaponMissileLevelFive];
                playerCredits -= [self priceOfWeapon:kWeaponTypeMissile level:5];
                break;
            case 6:
                [unlockedWeaponsTempArray addObject:kWeaponMissileLevelSix];
                playerCredits -= [self priceOfWeapon:kWeaponTypeMissile level:6];
                break;
            case 7:
                [unlockedWeaponsTempArray addObject:kWeaponMissileLevelSeven];
                playerCredits -= [self priceOfWeapon:kWeaponTypeMissile level:7];
                break;
            case 8:
                [unlockedWeaponsTempArray addObject:kWeaponMissileLevelEight];
                playerCredits -= [self priceOfWeapon:kWeaponTypeMissile level:8];
                break;
            case 9:
                [unlockedWeaponsTempArray addObject:kWeaponMissileLevelNine];
                playerCredits -= [self priceOfWeapon:kWeaponTypeMissile level:9];
                break;
            case 10:
                [unlockedWeaponsTempArray addObject:kWeaponMissileLevelTen];
                playerCredits -= [self priceOfWeapon:kWeaponTypeMissile level:10];
                heatseekingWeaponsUnlocked = YES;
                break;
            default:
                break;
        }
    }
    if (weaponTypeName == kWeaponTypeHeatseeking) {
        highestAchievedHeatseekingLevel = level;
        switch (level) {
            case 1:
                [unlockedWeaponsTempArray addObject:kWeaponHeatseekingLevelOne];
                playerCredits -= [self priceOfWeapon:kWeaponTypeMissile level:1];
                break;
            default:
                break;
        }
    }
    
    [settings setObject:unlockedWeaponsTempArray forKey:kSetting_SaveGameUnlockedWeapons];
    [settings setObject:[NSString stringWithFormat:@"%i", playerCredits] forKey:kSetting_SaveGameCredits];
    [settings synchronize];
    
    [unlockedWeaponsTempArray release];
}

- (void)equipWeapon:(NSString *)weaponTypeName level:(int)level {
    NSMutableString *equippedWeaponTemp = [[NSMutableString alloc] init];
    if([weaponTypeName isEqualToString:kWeaponTypeBullet]){
        [currentEquippedWeapon setString:kWeaponTypeBullet];
        currentEquippedWeaponLevel = level;
        switch (level) {
            case 1:
                [equippedWeaponTemp setString:kWeaponBulletLevelOne];
                break;
            case 2:
                [equippedWeaponTemp setString:kWeaponBulletLevelTwo];
                break;
            case 3:
                [equippedWeaponTemp setString:kWeaponBulletLevelThree];
                break;
            case 4:
                [equippedWeaponTemp setString:kWeaponBulletLevelFour];
                break;
            case 5:
                [equippedWeaponTemp setString:kWeaponBulletLevelFive];
                break;
            case 6:
                [equippedWeaponTemp setString:kWeaponBulletLevelSix];
                break;
            case 7:
                [equippedWeaponTemp setString:kWeaponBulletLevelSeven];
                break;
            case 8:
                [equippedWeaponTemp setString:kWeaponBulletLevelEight];
                break;
            case 9:
                [equippedWeaponTemp setString:kWeaponBulletLevelNine];
                break;
            case 10:
                [equippedWeaponTemp setString:kWeaponBulletLevelTen];
                break;
            default:
                break;
        }
    }
    if([weaponTypeName isEqualToString:kWeaponTypeWave]){
        [currentEquippedWeapon setString:kWeaponTypeWave];
        currentEquippedWeaponLevel = level;
        switch (level) {
            case 1:
                [equippedWeaponTemp setString:kWeaponWaveLevelOne];
                break;
            case 2:
                [equippedWeaponTemp setString:kWeaponWaveLevelTwo];
                break;
            case 3:
                [equippedWeaponTemp setString:kWeaponWaveLevelThree];
                break;
            case 4:
                [equippedWeaponTemp setString:kWeaponWaveLevelFour];
                break;
            case 5:
                [equippedWeaponTemp setString:kWeaponWaveLevelFive];
                break;
            case 6:
                [equippedWeaponTemp setString:kWeaponWaveLevelSix];
                break;
            case 7:
                [equippedWeaponTemp setString:kWeaponWaveLevelSeven];
                break;
            case 8:
                [equippedWeaponTemp setString:kWeaponWaveLevelEight];
                break;
            case 9:
                [equippedWeaponTemp setString:kWeaponWaveLevelNine];
                break;
            case 10:
                [equippedWeaponTemp setString:kWeaponWaveLevelTen];
                break;
            default:
                break;
        }
    }
    if([weaponTypeName isEqualToString:kWeaponTypeMissile]){
        [currentEquippedWeapon setString:kWeaponTypeMissile];
        currentEquippedWeaponLevel = level;
        switch (level) {
            case 1:
                [equippedWeaponTemp setString:kWeaponMissileLevelOne];
                break;
            case 2:
                [equippedWeaponTemp setString:kWeaponMissileLevelTwo];
                break;
            case 3:
                [equippedWeaponTemp setString:kWeaponMissileLevelThree];
                break;
            case 4:
                [equippedWeaponTemp setString:kWeaponMissileLevelFour];
                break;
            case 5:
                [equippedWeaponTemp setString:kWeaponMissileLevelFive];
                break;
            case 6:
                [equippedWeaponTemp setString:kWeaponMissileLevelSix];
                break;
            case 7:
                [equippedWeaponTemp setString:kWeaponMissileLevelSeven];
                break;
            case 8:
                [equippedWeaponTemp setString:kWeaponMissileLevelEight];
                break;
            case 9:
                [equippedWeaponTemp setString:kWeaponMissileLevelNine];
                break;
            case 10:
                [equippedWeaponTemp setString:kWeaponMissileLevelTen];
                break;
            default:
                break;
        }
    }
    if([weaponTypeName isEqualToString:kWeaponTypeHeatseeking]){
        [currentEquippedWeapon setString:kWeaponTypeHeatseeking];
        currentEquippedWeaponLevel = level;
        switch (level) {
            case 1:
                [equippedWeaponTemp setString:kWeaponHeatseekingLevelOne];
                break;
        }
    }
    
    [settings setObject:equippedWeaponTemp forKey:kSetting_SaveGameEquippedWeapon];
    [settings synchronize];
}

- (int)priceOfShip:(NSString *)shipType {
    if([shipType isEqualToString:kXP750]){
        return kXP750_Price;
    }
    else if([shipType isEqualToString:kXP751]){
        return kXP751_Price;
    }
    else if([shipType isEqualToString:kXPA368]){
        return kXPA368_Price;
    }
    else if([shipType isEqualToString:kXPA600]){
        return kXPA600_Price;
    }
    else if([shipType isEqualToString:kXPA617]){
        return kXPA617_Price;
    }
    else if([shipType isEqualToString:kXPA652]){
        return kXPA652_Price;
    }
    else if([shipType isEqualToString:kXPA679]){
        return kXPA679_Price;
    }
    else if([shipType isEqualToString:kXPS400]){
        return kXPS400_Price;
    }
    else if([shipType isEqualToString:kXPS424]){
        return kXPS424_Price;
    }
    else if([shipType isEqualToString:kXPS447]){
        return kXPS447_Price;
    }
    else if([shipType isEqualToString:kXPS463]){
        return kXPS463_Price;
    }
    else if([shipType isEqualToString:kXPS485]){
        return kXPS485_Price;
    }
    else if([shipType isEqualToString:kXPD900]){
        return kXPD900_Price;
    }
    else if([shipType isEqualToString:kXPD909]){
        return kXPD909_Price;
    }
    else if([shipType isEqualToString:kXPD924]){
        return kXPD924_Price;
    }
    else if([shipType isEqualToString:kXPD945]){
        return kXPD945_Price;
    }
    else if([shipType isEqualToString:kXPD968]){
        return kXPD968_Price;
    }
    
    return 100000;
}

- (NSString *)shipTypeFromCategory:(NSString *)shipCat andLevel:(int)shipLevel {
    if([shipCat isEqualToString:kShipTypeBase] && shipLevel == 1){
        return kXP750;
    }
    else if([shipCat isEqualToString:kShipTypeBase] && shipLevel == 2){
        return kXP751;
    }
    else if([shipCat isEqualToString:kShipTypeAttack] && shipLevel == 1){
        return kXPA368;
    }
    else if([shipCat isEqualToString:kShipTypeAttack] && shipLevel == 2){
        return kXPA600;
    }
    else if([shipCat isEqualToString:kShipTypeAttack] && shipLevel == 3){
        return kXPA617;
    }
    else if([shipCat isEqualToString:kShipTypeAttack] && shipLevel == 4){
        return kXPA652;
    }
    else if([shipCat isEqualToString:kShipTypeAttack] && shipLevel == 5){
        return kXPA679;
    }
    else if([shipCat isEqualToString:kShipTypeSpeed] && shipLevel == 1){
        return kXPS400;
    }
    else if([shipCat isEqualToString:kShipTypeSpeed] && shipLevel == 2){
        return kXPS424;
    }
    else if([shipCat isEqualToString:kShipTypeSpeed] && shipLevel == 3){
        return kXPS447;
    }
    else if([shipCat isEqualToString:kShipTypeSpeed] && shipLevel == 4){
        return kXPS463;
    }
    else if([shipCat isEqualToString:kShipTypeSpeed] && shipLevel == 5){
        return kXPS485;
    }
    else if([shipCat isEqualToString:kShipTypeDefense] && shipLevel == 1){
        return kXPD900;
    }
    else if([shipCat isEqualToString:kShipTypeDefense] && shipLevel == 2){
        return kXPD909;
    }
    else if([shipCat isEqualToString:kShipTypeDefense] && shipLevel == 3){
        return kXPD924;
    }
    else if([shipCat isEqualToString:kShipTypeDefense] && shipLevel == 4){
        return kXPD945;
    }
    else if([shipCat isEqualToString:kShipTypeDefense] && shipLevel == 5){
        return kXPD968;
    }
    
    return nil;
}

- (int)shipLevelFromType:(NSString *)shipType {
    if([shipType isEqualToString:kXP750]){
        return 1;
    }
    else if([shipType isEqualToString:kXP751]){
        return 2;
    }
    else if([shipType isEqualToString:kXPA368]){
        return 1;
    }
    else if([shipType isEqualToString:kXPA600]){
        return 2;
    }
    else if([shipType isEqualToString:kXPA617]){
        return 3;
    }
    else if([shipType isEqualToString:kXPA652]){
        return 4;
    }
    else if([shipType isEqualToString:kXPA679]){
        return 5;
    }
    else if([shipType isEqualToString:kXPS400]){
        return 1;
    }
    else if([shipType isEqualToString:kXPS424]){
        return 2;
    }
    else if([shipType isEqualToString:kXPS447]){
        return 3;
    }
    else if([shipType isEqualToString:kXPS463]){
        return 4;
    }
    else if([shipType isEqualToString:kXPS485]){
        return 5;
    }
    else if([shipType isEqualToString:kXPD900]){
        return 1;
    }
    else if([shipType isEqualToString:kXPD909]){
        return 2;
    }
    else if([shipType isEqualToString:kXPD924]){
        return 3;
    }
    else if([shipType isEqualToString:kXPD945]){
        return 4;
    }
    else if([shipType isEqualToString:kXPD968]){
        return 5;
    }
    
    return 100000;
}

- (NSString *)shipCategoryFromType:(NSString *)shipType {
    if([shipType isEqualToString:kXP750] || [shipType isEqualToString:kXP751]){
        return kShipTypeBase;
    }
    else if([shipType isEqualToString:kXPA368] || [shipType isEqualToString:kXPA600] || [shipType isEqualToString:kXPA617] || [shipType isEqualToString:kXPA652] || [shipType isEqualToString:kXPA679]){
        return kShipTypeAttack;
    }
    else if([shipType isEqualToString:kXPS400] || [shipType isEqualToString:kXPS424] || [shipType isEqualToString:kXPS447] || [shipType isEqualToString:kXPS463] || [shipType isEqualToString:kXPS485]){
        return kShipTypeSpeed;
    }
    else if([shipType isEqualToString:kXPD900] || [shipType isEqualToString:kXPD909] || [shipType isEqualToString:kXPD924] || [shipType isEqualToString:kXPD945] || [shipType isEqualToString:kXPD968]){
        return kShipTypeDefense;
    }
    
    return nil;
}

- (void)buyShip:(NSString *)shipType {
    NSMutableArray *settingsArray = [[NSMutableArray alloc] initWithArray:[settings objectForKey:kSetting_SaveGameUnlockedShips]];
    int tempCredits = [[settings objectForKey:kSetting_SaveGameCredits] intValue];
    
    if([settingsArray containsObject:shipType] == NO){
        [settingsArray addObject:shipType];
        if([[self shipCategoryFromType:shipType] isEqualToString:kShipTypeBase]){
            highestAchievedBaseLevel = [self shipLevelFromType:shipType];
            tempCredits -= [self priceOfShip:shipType];
            if([self shipLevelFromType:shipType] == 2){
                attackShipsUnlocked = YES;
                speedShipsUnlocked = YES;
                defenseShipsUnlocked = YES;
            }
        }
        else if([[self shipCategoryFromType:shipType] isEqualToString:kShipTypeAttack]){
            highestAchievedAttackLevel = [self shipLevelFromType:shipType];
            tempCredits -= [self priceOfShip:shipType];
        }
        else if([[self shipCategoryFromType:shipType] isEqualToString:kShipTypeSpeed]){
            highestAchievedSpeedLevel = [self shipLevelFromType:shipType];
            tempCredits -= [self priceOfShip:shipType];
        }
        else if([[self shipCategoryFromType:shipType] isEqualToString:kShipTypeDefense]){
            highestAchievedDefenseLevel = [self shipLevelFromType:shipType];
            tempCredits -= [self priceOfShip:shipType];
        }
        
        [settings setObject:settingsArray forKey:kSetting_SaveGameUnlockedShips];
        [settings setObject:[NSNumber numberWithInt:tempCredits] forKey:kSetting_SaveGameCredits];
        [settings synchronize];
    }
    [settingsArray release];
}

- (void)equipShip:(NSString *)shipType {
    NSMutableString *tempEquipString = [[NSMutableString alloc] initWithString:[settings objectForKey:kSetting_SaveGameEquippedShip]];
    
    [currentEquippedShipType setString:shipType];
    [tempEquipString setString:shipType];
    
    [settings setObject:tempEquipString forKey:kSetting_SaveGameEquippedShip];
    [settings synchronize];
    
    [tempEquipString release];
}

- (NSString *)displayStringForShip:(NSString *)shipType {
    if([shipType isEqualToString:kXP750]) return @"XP-750";
    if([shipType isEqualToString:kXP751]) return @"XP-751";
    
    if([shipType isEqualToString:kXPA368]) return @"XPA-368";
    if([shipType isEqualToString:kXPA600]) return @"XPA-600";
    if([shipType isEqualToString:kXPA617]) return @"XPA-617";
    if([shipType isEqualToString:kXPA652]) return @"XPA-652";
    if([shipType isEqualToString:kXPA679]) return @"XPA-679";
    
    if([shipType isEqualToString:kXPS400]) return @"XPS-400";
    if([shipType isEqualToString:kXPS424]) return @"XPS-424";
    if([shipType isEqualToString:kXPS447]) return @"XPS-447";
    if([shipType isEqualToString:kXPS463]) return @"XPS-463";
    if([shipType isEqualToString:kXPS485]) return @"XPS-485";
    
    if([shipType isEqualToString:kXPD900]) return @"XPD-900";
    if([shipType isEqualToString:kXPD909]) return @"XPD-909";
    if([shipType isEqualToString:kXPD924]) return @"XPD-924";
    if([shipType isEqualToString:kXPD945]) return @"XPD-945";
    if([shipType isEqualToString:kXPD968]) return @"XPD-968";
    
    return @"ERROR";
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
            [font drawStringAt:CGPointMake(75.0f, 210.0f) text:@"Shield: XXXc"];
            [font drawStringAt:CGPointMake(75.0f, 170.0f) text:[NSString stringWithFormat:@"Ship: %@", [self displayStringForShip:currentEquippedShipType]]];
            if([[currentEquippedWeapon substringFromIndex:11] isEqualToString:@"Heatseeking"]){
                [font drawStringAt:CGPointMake(75.0f, 130.0f) text:@"Wpn: Heat"];
            }
            else [font drawStringAt:CGPointMake(75.0f, 130.0f) text:[NSString stringWithFormat:@"Wpn: %@", [currentEquippedWeapon substringFromIndex:11]]];
            [font drawStringAt:CGPointMake(75.0f, 90.0f) text:[NSString stringWithFormat:@"Lvl: %d", currentEquippedWeaponLevel]];
            [font setScale:0.7];
            
            break;
            
        case kSceneState_ship_upgrades:
            [font drawStringAt:CGPointMake(110.0f, 460.0) text:@"Ships"];
            [shipsMenuBaseButton renderAtPoint:CGPointMake(160.0f, 360.0f) centerOfImage:YES];
            if(attackShipsUnlocked){
                [shipsMenuAttackButton renderAtPoint:CGPointMake(160.0f, 280.0f) centerOfImage:YES];
                [shipsMenuSpeedButton renderAtPoint:CGPointMake(160.0f, 200.0f) centerOfImage:YES];
                [shipsMenuDefenseButton renderAtPoint:CGPointMake(160.0f, 120.0f) centerOfImage:YES];
            }
            else {
                [shipsMenuAttackButtonDisabled renderAtPoint:CGPointMake(160.0f, 280.0f) centerOfImage:YES];
                [shipsMenuSpeedButtonDisabled renderAtPoint:CGPointMake(160.0f, 200.0f) centerOfImage:YES];
                [shipsMenuDefenseButtonDisabled renderAtPoint:CGPointMake(160.0f, 120.0f) centerOfImage:YES];
            }
            
            break;
            
        case kSceneState_ship_upgrades_base_chooser:
            [font drawStringAt:CGPointMake(115.0f, 460.0f) text:@"Base"];
            [font setScale:0.5];
            if(currentBaseShipLevelSelection != 1) [previousButton renderAtPoint:CGPointMake(95.0f, 287.0f) centerOfImage:YES];
            [font drawStringAt:CGPointMake(110.0f, 300.0f) text:[self displayStringForShip:[self shipTypeFromCategory:kShipTypeBase andLevel:currentBaseShipLevelSelection]]];
            if(currentBaseShipLevelSelection != 2) [nextButton renderAtPoint:CGPointMake(235.0f, 287.0f) centerOfImage:YES];
            
            [font drawStringAt:CGPointMake(120.0f, 230.0f) text:@"Stats"];
            
            [font setScale:0.4];
            [font drawStringAt:CGPointMake(20.0f, 180.0f) text:@"ATK:"];
            [font drawStringAt:CGPointMake(20.0f, 150.0f) text:@"SPD:"];
            [font drawStringAt:CGPointMake(20.0f, 120.0f) text:@"DEF:"];
            if(currentBaseShipLevelSelection > highestAchievedBaseLevel){
                [font drawStringAt:CGPointMake(20.0f, 90.0f) text:[NSString stringWithFormat:@"Cost: %dc", [self priceOfShip:[self shipTypeFromCategory:kShipTypeBase andLevel:currentBaseShipLevelSelection]]]];
            }
            else {
                [font drawStringAt:CGPointMake(20.0f, 90.0f) text:@"Cost: Bought"];
            }
            
            [font setScale:0.7];
            
            [[previewShipImages objectForKey:[self shipTypeFromCategory:kShipTypeBase andLevel:currentBaseShipLevelSelection]] renderAtPoint:CGPointMake(160.0f, 370.0f) centerOfImage:YES];
            
//            [equipButton renderAtPoint:CGPointMake(280.0f, 70.0f) centerOfImage:YES];
//            [buyButton renderAtPoint:CGPointMake(280.0f, 30.0f) centerOfImage:YES];
            
            if((currentBaseShipLevelSelection - highestAchievedBaseLevel) == 1){
                if([[settings objectForKey:kSetting_SaveGameCredits] intValue] >= [self priceOfShip:[self shipTypeFromCategory:kShipTypeBase andLevel:currentBaseShipLevelSelection]]){
                    //To buy
                    [buyButton renderAtPoint:CGPointMake(280.0f, 30.0f) centerOfImage:YES];
                }
                else {
                    //Unable to buy
                    [buyButtonDisabled renderAtPoint:CGPointMake(280.0f, 30.0f) centerOfImage:YES];
                }
            }
            if(currentBaseShipLevelSelection <= highestAchievedBaseLevel){
                //Bought
                [boughtButton renderAtPoint:CGPointMake(280.0f, 30.0f) centerOfImage:YES];
            }

            if([[settings objectForKey:kSetting_SaveGameUnlockedShips] containsObject:[self shipTypeFromCategory:kShipTypeBase andLevel:currentBaseShipLevelSelection]]){
                if([self shipLevelFromType:currentEquippedShipType] == currentBaseShipLevelSelection && [[self shipCategoryFromType:currentEquippedShipType] isEqualToString:kShipTypeBase]){
                    //Equipped
                    [equippedButton renderAtPoint:CGPointMake(280.0f, 70.0f) centerOfImage:YES];
                }
                else {
                    //To Equip
                    [equipButton renderAtPoint:CGPointMake(280.0f, 70.0f) centerOfImage:YES];
                }
            }
            else {
                //Unable to equip
                [equipButtonDisabled renderAtPoint:CGPointMake(280.0f, 70.0f) centerOfImage:YES];
            }
            
            break;
            
        case kSceneState_ship_upgrades_attack_chooser:
            [font drawStringAt:CGPointMake(105.0f, 460.0f) text:@"Attack"];
            [font setScale:0.5];
            if(currentAttackShipLevelSelection != 1) [previousButton renderAtPoint:CGPointMake(95.0f, 287.0f) centerOfImage:YES];
            [font drawStringAt:CGPointMake(110.0f, 300.0f) text:[self displayStringForShip:[self shipTypeFromCategory:kShipTypeAttack andLevel:currentAttackShipLevelSelection]]];
            if(currentAttackShipLevelSelection != 5) [nextButton renderAtPoint:CGPointMake(235.0f, 287.0f) centerOfImage:YES];
            
            [font drawStringAt:CGPointMake(120.0f, 230.0f) text:@"Stats"];
            
            [font setScale:0.4];
            [font drawStringAt:CGPointMake(20.0f, 180.0f) text:@"ATK:"];
            [font drawStringAt:CGPointMake(20.0f, 150.0f) text:@"SPD:"];
            [font drawStringAt:CGPointMake(20.0f, 120.0f) text:@"DEF:"];
            if(currentAttackShipLevelSelection > highestAchievedAttackLevel){
                [font drawStringAt:CGPointMake(20.0f, 90.0f) text:[NSString stringWithFormat:@"Cost: %dc", [self priceOfShip:[self shipTypeFromCategory:kShipTypeAttack andLevel:currentAttackShipLevelSelection]]]];
            }
            else {
                [font drawStringAt:CGPointMake(20.0f, 90.0f) text:@"Cost: Bought"];
            }

            [[previewShipImages objectForKey:[self shipTypeFromCategory:kShipTypeAttack andLevel:currentAttackShipLevelSelection]] renderAtPoint:CGPointMake(160.0f, 370.0f) centerOfImage:YES];
            
            [font setScale:0.7];
            
//            [equipButton renderAtPoint:CGPointMake(280.0f, 70.0f) centerOfImage:YES];
//            [buyButton renderAtPoint:CGPointMake(280.0f, 30.0f) centerOfImage:YES];
            
            if((currentAttackShipLevelSelection - highestAchievedAttackLevel) == 1){
                if([[settings objectForKey:kSetting_SaveGameCredits] intValue] >= [self priceOfShip:[self shipTypeFromCategory:kShipTypeAttack andLevel:currentAttackShipLevelSelection]]){
                    //To buy
                    [buyButton renderAtPoint:CGPointMake(280.0f, 30.0f) centerOfImage:YES];
                }
                else {
                    //Unable to buy
                    [buyButtonDisabled renderAtPoint:CGPointMake(280.0f, 30.0f) centerOfImage:YES];
                }
            }
            if(currentAttackShipLevelSelection <= highestAchievedAttackLevel){
                //Bought
                [boughtButton renderAtPoint:CGPointMake(280.0f, 30.0f) centerOfImage:YES];
            }
            
            if([[settings objectForKey:kSetting_SaveGameUnlockedShips] containsObject:[self shipTypeFromCategory:kShipTypeAttack andLevel:currentAttackShipLevelSelection]]){
                if([self shipLevelFromType:currentEquippedShipType] == currentAttackShipLevelSelection && [[self shipCategoryFromType:currentEquippedShipType] isEqualToString:kShipTypeAttack]){
                    //Equipped
                    [equippedButton renderAtPoint:CGPointMake(280.0f, 70.0f) centerOfImage:YES];
                }
                else {
                    //To Equip
                    [equipButton renderAtPoint:CGPointMake(280.0f, 70.0f) centerOfImage:YES];
                }
            }
            else {
                //Unable to equip
                [equipButtonDisabled renderAtPoint:CGPointMake(280.0f, 70.0f) centerOfImage:YES];
            }
            
            break;
            
        case kSceneState_ship_upgrades_speed_chooser:
            [font drawStringAt:CGPointMake(115.0f, 460.0f) text:@"Speed"];
            [font setScale:0.5];
            if(currentSpeedShipLevelSelection != 1) [previousButton renderAtPoint:CGPointMake(95.0f, 287.0f) centerOfImage:YES];
            [font drawStringAt:CGPointMake(110.0f, 300.0f) text:[self displayStringForShip:[self shipTypeFromCategory:kShipTypeSpeed andLevel:currentSpeedShipLevelSelection]]];
            if(currentSpeedShipLevelSelection != 5) [nextButton renderAtPoint:CGPointMake(235.0f, 287.0f) centerOfImage:YES];
            
            [font drawStringAt:CGPointMake(120.0f, 230.0f) text:@"Stats"];
            
            [font setScale:0.4];
            [font drawStringAt:CGPointMake(20.0f, 180.0f) text:@"ATK:"];
            [font drawStringAt:CGPointMake(20.0f, 150.0f) text:@"SPD:"];
            [font drawStringAt:CGPointMake(20.0f, 120.0f) text:@"DEF:"];
            if(currentSpeedShipLevelSelection > highestAchievedSpeedLevel){
                [font drawStringAt:CGPointMake(20.0f, 90.0f) text:[NSString stringWithFormat:@"Cost: %dc", [self priceOfShip:[self shipTypeFromCategory:kShipTypeSpeed andLevel:currentSpeedShipLevelSelection]]]];
            }
            else {
                [font drawStringAt:CGPointMake(20.0f, 90.0f) text:@"Cost: Bought"];
            }
            
            [[previewShipImages objectForKey:[self shipTypeFromCategory:kShipTypeSpeed andLevel:currentSpeedShipLevelSelection]] renderAtPoint:CGPointMake(160.0f, 370.0f) centerOfImage:YES];
            
            [font setScale:0.7];
            
//            [equipButton renderAtPoint:CGPointMake(280.0f, 70.0f) centerOfImage:YES];
//            [buyButton renderAtPoint:CGPointMake(280.0f, 30.0f) centerOfImage:YES];
            
            if((currentSpeedShipLevelSelection - highestAchievedSpeedLevel) == 1){
                if([[settings objectForKey:kSetting_SaveGameCredits] intValue] >= [self priceOfShip:[self shipTypeFromCategory:kShipTypeSpeed andLevel:currentSpeedShipLevelSelection]]){
                    //To buy
                    [buyButton renderAtPoint:CGPointMake(280.0f, 30.0f) centerOfImage:YES];
                }
                else {
                    //Unable to buy
                    [buyButtonDisabled renderAtPoint:CGPointMake(280.0f, 30.0f) centerOfImage:YES];
                }
            }
            if(currentSpeedShipLevelSelection <= highestAchievedSpeedLevel){
                //Bought
                [boughtButton renderAtPoint:CGPointMake(280.0f, 30.0f) centerOfImage:YES];
            }
            
            
            if([[settings objectForKey:kSetting_SaveGameUnlockedShips] containsObject:[self shipTypeFromCategory:kShipTypeSpeed andLevel:currentSpeedShipLevelSelection]]){
                if([self shipLevelFromType:currentEquippedShipType] == currentSpeedShipLevelSelection && [[self shipCategoryFromType:currentEquippedShipType] isEqualToString:kShipTypeSpeed]){
                    //Equipped
                    [equippedButton renderAtPoint:CGPointMake(280.0f, 70.0f) centerOfImage:YES];
                }
                else {
                    //To Equip
                    [equipButton renderAtPoint:CGPointMake(280.0f, 70.0f) centerOfImage:YES];
                }
            }
            else {
                //Unable to equip
                [equipButtonDisabled renderAtPoint:CGPointMake(280.0f, 70.0f) centerOfImage:YES];
            }

            break;
            
        case kSceneState_ship_upgrades_defense_chooser:
            [font drawStringAt:CGPointMake(95.0f, 460.0f) text:@"Defense"];
            [font setScale:0.5];
            if(currentDefenseShipLevelSelection != 1) [previousButton renderAtPoint:CGPointMake(95.0f, 287.0f) centerOfImage:YES];
            [font drawStringAt:CGPointMake(110.0f, 300.0f) text:[self displayStringForShip:[self shipTypeFromCategory:kShipTypeDefense andLevel:currentDefenseShipLevelSelection]]];
            if(currentDefenseShipLevelSelection != 5) [nextButton renderAtPoint:CGPointMake(235.0f, 287.0f) centerOfImage:YES];
            
            [font drawStringAt:CGPointMake(120.0f, 230.0f) text:@"Stats"];
            
            [font setScale:0.4];
            [font drawStringAt:CGPointMake(20.0f, 180.0f) text:@"ATK:"];
            [font drawStringAt:CGPointMake(20.0f, 150.0f) text:@"SPD:"];
            [font drawStringAt:CGPointMake(20.0f, 120.0f) text:@"DEF:"];
            if(currentDefenseShipLevelSelection > highestAchievedDefenseLevel){
                [font drawStringAt:CGPointMake(20.0f, 90.0f) text:[NSString stringWithFormat:@"Cost: %dc", [self priceOfShip:[self shipTypeFromCategory:kShipTypeDefense andLevel:currentDefenseShipLevelSelection]]]];
            }
            else {
                [font drawStringAt:CGPointMake(20.0f, 90.0f) text:@"Cost: Bought"];
            }
            
            [[previewShipImages objectForKey:[self shipTypeFromCategory:kShipTypeDefense andLevel:currentDefenseShipLevelSelection]] renderAtPoint:CGPointMake(160.0f, 370.0f) centerOfImage:YES];
            
            [font setScale:0.7];
            
//            [equipButton renderAtPoint:CGPointMake(280.0f, 70.0f) centerOfImage:YES];
//            [buyButton renderAtPoint:CGPointMake(280.0f, 30.0f) centerOfImage:YES];
            
            if((currentDefenseShipLevelSelection - highestAchievedDefenseLevel) == 1){
                if([[settings objectForKey:kSetting_SaveGameCredits] intValue] >= [self priceOfShip:[self shipTypeFromCategory:kShipTypeDefense andLevel:currentDefenseShipLevelSelection]]){
                    //To buy
                    [buyButton renderAtPoint:CGPointMake(280.0f, 30.0f) centerOfImage:YES];
                }
                else {
                    //Unable to buy
                    [buyButtonDisabled renderAtPoint:CGPointMake(280.0f, 30.0f) centerOfImage:YES];
                }
            }
            if(currentDefenseShipLevelSelection <= highestAchievedDefenseLevel){
                //Bought
                [boughtButton renderAtPoint:CGPointMake(280.0f, 30.0f) centerOfImage:YES];
            }
            
            
            if([[settings objectForKey:kSetting_SaveGameUnlockedShips] containsObject:[self shipTypeFromCategory:kShipTypeDefense andLevel:currentDefenseShipLevelSelection]]){
                if([self shipLevelFromType:currentEquippedShipType] == currentDefenseShipLevelSelection && [[self shipCategoryFromType:currentEquippedShipType] isEqualToString:kShipTypeDefense]){
                    //Equipped
                    [equippedButton renderAtPoint:CGPointMake(280.0f, 70.0f) centerOfImage:YES];
                }
                else {
                    //To Equip
                    [equipButton renderAtPoint:CGPointMake(280.0f, 70.0f) centerOfImage:YES];
                }
            }
            else {
                //Unable to equip
                [equipButtonDisabled renderAtPoint:CGPointMake(280.0f, 70.0f) centerOfImage:YES];
            }

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
            if(currentBulletLevelSelection > 1 && [currentSelectedWeaponType isEqualToString:kWeaponTypeBullet]){
                [previousButton renderAtPoint:CGPointMake(105.0f, 325.0f) centerOfImage:YES];
            }
            [font drawStringAt:CGPointMake(120.0, 340.0f) text:[NSString stringWithFormat:@"Level: %d", currentBulletLevelSelection]];
            if(currentBulletLevelSelection < 10 && [currentSelectedWeaponType isEqualToString:kWeaponTypeBullet]){
                [nextButton renderAtPoint:CGPointMake(220.0f, 325.0f) centerOfImage:YES];
            }
            
            if (wavesWeaponsUnlocked) {
                if ([currentEquippedWeapon isEqualToString:kWeaponTypeWave] && currentEquippedWeaponLevel == currentWaveLevelSelection) {
                    [weaponsMenuWavesButtonEquipped renderAtPoint:CGPointMake(160.0f, 280.0f) centerOfImage:YES];
                }
                else {
                    [weaponsMenuWavesButton renderAtPoint:CGPointMake(160.0f, 280.0f) centerOfImage:YES];
                }
                
                if(currentWaveLevelSelection > 1 && [currentSelectedWeaponType isEqualToString:kWeaponTypeWave]){
                    [previousButton renderAtPoint:CGPointMake(105.0f, 245.0f) centerOfImage:YES];
                }
                [font drawStringAt:CGPointMake(120.0, 260.0f) text:[NSString stringWithFormat:@"Level: %d", currentWaveLevelSelection]];
                if(currentWaveLevelSelection < 10 && [currentSelectedWeaponType isEqualToString:kWeaponTypeWave]){
                    [nextButton renderAtPoint:CGPointMake(220.0f, 245.0f) centerOfImage:YES];
                }
            } else {
                [weaponsMenuWavesButtonDisabled renderAtPoint:CGPointMake(160.0f, 280.0f) centerOfImage:YES];
            }
                        
            if (missilesWeaponsUnlocked) {
                if ([currentEquippedWeapon isEqualToString:kWeaponTypeMissile] && currentEquippedWeaponLevel == currentMissileLevelSelection) {
                    [weaponsMenuMissilesButtonEquipped renderAtPoint:CGPointMake(160.0f, 200.0f) centerOfImage:YES];
                }
                else {
                    [weaponsMenuMissilesButton renderAtPoint:CGPointMake(160.0f, 200.0f) centerOfImage:YES];
                }
                
                if(currentMissileLevelSelection > 1 && [currentSelectedWeaponType isEqualToString:kWeaponTypeMissile]){
                    [previousButton renderAtPoint:CGPointMake(105.0f, 165.0f) centerOfImage:YES];
                }
                [font drawStringAt:CGPointMake(120.0, 180.0f) text:[NSString stringWithFormat:@"Level: %d", currentMissileLevelSelection]];
                if(currentMissileLevelSelection < 10 && [currentSelectedWeaponType isEqualToString:kWeaponTypeMissile]){
                    [nextButton renderAtPoint:CGPointMake(220.0f, 165.0f) centerOfImage:YES];
                }
            } else {
                [weaponsMenuMissilesButtonDisabled renderAtPoint:CGPointMake(160.0f, 200.0f) centerOfImage:YES];
            }
            
            if (heatseekingWeaponsUnlocked) {
                
                if ([currentEquippedWeapon isEqualToString:kWeaponTypeHeatseeking] && currentEquippedWeaponLevel == currentHeatseekingLevelSelection) {
                    [weaponsMenuHeatseekingButtonEquipped renderAtPoint:CGPointMake(160.0f, 120.0f) centerOfImage:YES];
                }
                else {
                    [weaponsMenuHeatseekingButton renderAtPoint:CGPointMake(160.0f, 120.0f) centerOfImage:YES];
                }
                
                if(currentHeatseekingLevelSelection > 1 && [currentSelectedWeaponType isEqualToString:kWeaponTypeHeatseeking]){
                    [previousButton renderAtPoint:CGPointMake(105.0f, 85.0f) centerOfImage:YES];
                }
                [font drawStringAt:CGPointMake(120.0, 100.0f) text:[NSString stringWithFormat:@"Level: %d", currentHeatseekingLevelSelection]];
                if(currentHeatseekingLevelSelection < 10 && [currentSelectedWeaponType isEqualToString:kWeaponTypeHeatseeking]){
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
                        [buyButton renderAtPoint:CGPointMake(286.0f, 377.0f) centerOfImage:YES];
                    }
                    else {
                        //Unable to buy
                        [buyButtonDisabled renderAtPoint:CGPointMake(286.0f, 377.0f) centerOfImage:YES];
                    }
                }
                if(currentBulletLevelSelection <= highestAchievedBulletLevel){
                    //Bought
                    [boughtButton renderAtPoint:CGPointMake(286.0f, 377.0f) centerOfImage:YES];
                }
                
                
                if(currentBulletLevelSelection <= highestAchievedBulletLevel){
                    if(currentEquippedWeaponLevel == currentBulletLevelSelection && [currentEquippedWeapon isEqualToString:kWeaponTypeBullet]){
                        //Equipped
                        [equippedButton renderAtPoint:CGPointMake(286.0f, 343.0f) centerOfImage:YES];
                    }
                    else {
                        //To Equip
                        [equipButton renderAtPoint:CGPointMake(286.0f, 343.0f) centerOfImage:YES];
                    }
                }
                else {
                    //Unable to equip
                    [equipButtonDisabled renderAtPoint:CGPointMake(286.0f, 343.0f) centerOfImage:YES];
                }
            }
            else if([currentSelectedWeaponType isEqualToString:kWeaponTypeWave]){
                if((currentWaveLevelSelection - highestAchievedWaveLevel) == 1){
                    if([[settings objectForKey:kSetting_SaveGameCredits] intValue] >= [self priceOfCurrentSelectedWeapon]){
                        //To buy
                        [buyButton renderAtPoint:CGPointMake(286.0f, 297.0f) centerOfImage:YES];
                    }
                    else {
                        //Unable to buy
                        [buyButtonDisabled renderAtPoint:CGPointMake(286.0f, 297.0f) centerOfImage:YES];
                    }
                }
                if(currentWaveLevelSelection <= highestAchievedWaveLevel){
                    //Bought
                    [boughtButton renderAtPoint:CGPointMake(286.0f, 297.0f) centerOfImage:YES];
                }
                
                if(currentWaveLevelSelection <= highestAchievedWaveLevel){
                    if(currentEquippedWeaponLevel == currentWaveLevelSelection && [currentEquippedWeapon isEqualToString:kWeaponTypeWave]){
                        //Equipped
                        [equippedButton renderAtPoint:CGPointMake(286.0f, 263.0f) centerOfImage:YES];
                    }
                    else {
                        //To Equip
                        [equipButton renderAtPoint:CGPointMake(286.0f, 263.0f) centerOfImage:YES];
                    }
                }
                else {
                    //Unable to equip
                    [equipButtonDisabled renderAtPoint:CGPointMake(286.0f, 263.0f) centerOfImage:YES];
                }
            }
            else if([currentSelectedWeaponType isEqualToString:kWeaponTypeMissile]){
                if((currentMissileLevelSelection - highestAchievedMissileLevel) == 1){
                    if([[settings objectForKey:kSetting_SaveGameCredits] intValue] >= [self priceOfCurrentSelectedWeapon]){
                        //To buy
                        [buyButton renderAtPoint:CGPointMake(286.0f, 217.0f) centerOfImage:YES];
                    }
                    else {
                        //Unable to buy
                        [buyButtonDisabled renderAtPoint:CGPointMake(286.0f, 217.0f) centerOfImage:YES];
                    }
                }
                if(currentMissileLevelSelection <= highestAchievedMissileLevel){
                    //Bought
                    [boughtButton renderAtPoint:CGPointMake(286.0f, 217.0f) centerOfImage:YES];
                }
                
                if(currentMissileLevelSelection <= highestAchievedMissileLevel){
                    if(currentEquippedWeaponLevel == currentMissileLevelSelection && [currentEquippedWeapon isEqualToString:kWeaponTypeMissile]){
                        //Equipped
                        [equippedButton renderAtPoint:CGPointMake(286.0f, 183.0f) centerOfImage:YES];
                    }
                    else {
                        //To Equip
                        [equipButton renderAtPoint:CGPointMake(286.0f, 183.0f) centerOfImage:YES];
                    }
                }
                else {
                    //Unable to equip
                    [equipButtonDisabled renderAtPoint:CGPointMake(286.0f, 183.0f) centerOfImage:YES];
                }
            }
            else if([currentSelectedWeaponType isEqualToString:kWeaponTypeHeatseeking]){
                if((currentHeatseekingLevelSelection - highestAchievedHeatseekingLevel) == 1){
                    if([[settings objectForKey:kSetting_SaveGameCredits] intValue] >= [self priceOfCurrentSelectedWeapon]){
                        //To buy
                        [buyButton renderAtPoint:CGPointMake(286.0f, 137.0f) centerOfImage:YES];
                    }
                    else {
                        //Unable to buy
                        [buyButtonDisabled renderAtPoint:CGPointMake(286.0f, 137.0f) centerOfImage:YES];
                    }
                }
                if(currentHeatseekingLevelSelection <= highestAchievedHeatseekingLevel){
                    //Bought
                    [boughtButton renderAtPoint:CGPointMake(286.0f, 137.0f) centerOfImage:YES];
                }
                
                if(currentHeatseekingLevelSelection <= highestAchievedHeatseekingLevel){
                    if(currentEquippedWeaponLevel == currentHeatseekingLevelSelection && [currentEquippedWeapon isEqualToString:kWeaponTypeHeatseeking]){
                        //Equipped
                        [equippedButton renderAtPoint:CGPointMake(286.0f, 103.0f) centerOfImage:YES];
                    }
                    else {
                        //To Equip
                        [equipButton renderAtPoint:CGPointMake(286.0f, 103.0f) centerOfImage:YES];
                    }
                }
                else {
                    //Unable to equip
                    [equipButtonDisabled renderAtPoint:CGPointMake(286.0f, 103.0f) centerOfImage:YES];
                }
            }
            break;    
            
        default:
            
            break;
    }
    [creditsIcon renderAtPoint:CGPointMake(0, 0) centerOfImage:NO];
    [font setScale:0.4];
    [font drawStringAt:CGPointMake(42, 38) text:[NSString stringWithFormat:@"%d", [[settings objectForKey:kSetting_SaveGameCredits] intValue]]];
    [font setScale:0.7];
    [backButton renderAtPoint:CGPointMake(15, 440) centerOfImage:NO];
}

- (void)dealloc {
    [super dealloc];
    [font release];
}

@end
