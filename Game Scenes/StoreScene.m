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
    
    currentEquippedShipType = [[NSMutableString alloc] init];
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
    
    
    if([[settings objectForKey:kSetting_SaveGameUnlockedShips] containsObject:kXP750]){
        highestAchievedBaseLevel = 1;
        if([[settings objectForKey:kSetting_SaveGameEquippedShip] containsObject:kXP750]){
            currentBaseShipLevelSelection = 1;
            [currentEquippedShipType setString:kXP750];
        }
    }
    if([[settings objectForKey:kSetting_SaveGameUnlockedShips] containsObject:kXP751]){
        highestAchievedBaseLevel = 2;
        if([[settings objectForKey:kSetting_SaveGameEquippedShip] containsObject:kXP751]){
            currentBaseShipLevelSelection = 2;
            [currentEquippedShipType setString:kXP751];
        }
    }
    
    //Attack
    if([[settings objectForKey:kSetting_SaveGameUnlockedShips] containsObject:kXPA368]){
        highestAchievedAttackLevel = 1;
        if([[settings objectForKey:kSetting_SaveGameEquippedShip] containsObject:kXPA368]){
            currentBaseShipLevelSelection = 1;
            [currentEquippedShipType setString:kXPA368];
        }
    }
    if([[settings objectForKey:kSetting_SaveGameUnlockedShips] containsObject:kXPA600]){
        highestAchievedAttackLevel = 2;
        if([[settings objectForKey:kSetting_SaveGameEquippedShip] containsObject:kXPA600]){
            currentAttackShipLevelSelection = 2;
            [currentEquippedShipType setString:kXPA600];
        }
    }
    if([[settings objectForKey:kSetting_SaveGameUnlockedShips] containsObject:kXPA617]){
        highestAchievedAttackLevel = 3;
        if([[settings objectForKey:kSetting_SaveGameEquippedShip] containsObject:kXPA617]){
            currentAttackShipLevelSelection = 3;
            [currentEquippedShipType setString:kXPA617];
        }
    }
    if([[settings objectForKey:kSetting_SaveGameUnlockedShips] containsObject:kXPA652]){
        highestAchievedAttackLevel = 4;
        if([[settings objectForKey:kSetting_SaveGameEquippedShip] containsObject:kXPA652]){
            currentAttackShipLevelSelection = 4;
            [currentEquippedShipType setString:kXPA652];
        }
    }
    if([[settings objectForKey:kSetting_SaveGameUnlockedShips] containsObject:kXPA679]){
        highestAchievedAttackLevel = 5;
        if([[settings objectForKey:kSetting_SaveGameEquippedShip] containsObject:kXPA679]){
            currentAttackShipLevelSelection = 5;
            [currentEquippedShipType setString:kXPA679];
        }
    }
    
    //Speed
    if([[settings objectForKey:kSetting_SaveGameUnlockedShips] containsObject:kXPS400]){
        highestAchievedSpeedLevel = 1;
        if([[settings objectForKey:kSetting_SaveGameEquippedShip] containsObject:kXPS400]){
            currentSpeedShipLevelSelection = 1;
            [currentEquippedShipType setString:kXPS400];
        }
    }
    if([[settings objectForKey:kSetting_SaveGameUnlockedShips] containsObject:kXPS424]){
        highestAchievedSpeedLevel = 2;
        if([[settings objectForKey:kSetting_SaveGameEquippedShip] containsObject:kXPS424]){
            currentSpeedShipLevelSelection = 2;
            [currentEquippedShipType setString:kXPS424];
        }
    }
    if([[settings objectForKey:kSetting_SaveGameUnlockedShips] containsObject:kXPS447]){
        highestAchievedSpeedLevel = 3;
        if([[settings objectForKey:kSetting_SaveGameEquippedShip] containsObject:kXPS447]){
            currentSpeedShipLevelSelection = 3;
            [currentEquippedShipType setString:kXPS447];
        }
    }
    if([[settings objectForKey:kSetting_SaveGameUnlockedShips] containsObject:kXPS463]){
        highestAchievedSpeedLevel = 4;
        if([[settings objectForKey:kSetting_SaveGameEquippedShip] containsObject:kXPS463]){
            currentSpeedShipLevelSelection = 4;
            [currentEquippedShipType setString:kXPS463];
        }
    }
    if([[settings objectForKey:kSetting_SaveGameUnlockedShips] containsObject:kXPS485]){
        highestAchievedSpeedLevel = 5;
        if([[settings objectForKey:kSetting_SaveGameEquippedShip] containsObject:kXPS485]){
            currentSpeedShipLevelSelection = 5;
            [currentEquippedShipType setString:kXPS485];
        }
    }
    
    //Defense
    if([[settings objectForKey:kSetting_SaveGameUnlockedShips] containsObject:kXPD900]){
        highestAchievedDefenseLevel = 1;
        if([[settings objectForKey:kSetting_SaveGameEquippedShip] containsObject:kXPD900]){
            currentDefenseShipLevelSelection = 1;
            [currentEquippedShipType setString:kXPD900];
        }
    }
    if([[settings objectForKey:kSetting_SaveGameUnlockedShips] containsObject:kXPD909]){
        highestAchievedDefenseLevel = 2;
        if([[settings objectForKey:kSetting_SaveGameEquippedShip] containsObject:kXPD909]){
            currentDefenseShipLevelSelection = 2;
            [currentEquippedShipType setString:kXPD909];
        }
    }
    if([[settings objectForKey:kSetting_SaveGameUnlockedShips] containsObject:kXPD924]){
        highestAchievedDefenseLevel = 3;
        if([[settings objectForKey:kSetting_SaveGameEquippedShip] containsObject:kXPD924]){
            currentDefenseShipLevelSelection = 3;
            [currentEquippedShipType setString:kXPD924];
        }
    }
    if([[settings objectForKey:kSetting_SaveGameUnlockedShips] containsObject:kXPD945]){
        highestAchievedDefenseLevel = 4;
        if([[settings objectForKey:kSetting_SaveGameEquippedShip] containsObject:kXPD945]){
            currentDefenseShipLevelSelection = 4;
            [currentEquippedShipType setString:kXPD945];
        }
    }
    if([[settings objectForKey:kSetting_SaveGameUnlockedShips] containsObject:kXPD968]){
        highestAchievedDefenseLevel = 5;
        if([[settings objectForKey:kSetting_SaveGameEquippedShip] containsObject:kXPD968]){
            currentDefenseShipLevelSelection = 5;
            [currentEquippedShipType setString:kXPD968];
        }
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
            
            if(CGRectContainsPoint(CGRectMake(270.0f - (buyButton.imageWidth/2), 377.0f - (buyButton.imageHeight/2), buyButton.imageWidth, buyButton.imageHeight), location)){
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
            if(CGRectContainsPoint(CGRectMake(270.0f - (equipButton.imageWidth/2), 343.0f - (equipButton.imageHeight/2), equipButton.imageWidth, equipButton.imageHeight), location)){
                if([currentEquippedWeapon isEqualToString:kWeaponTypeBullet]){
                    if(currentBulletLevelSelection != currentEquippedWeaponLevel && currentBulletLevelSelection <= highestAchievedBulletLevel){
                        //To equip
                        [self equipWeapon:currentSelectedWeaponType level:currentBulletLevelSelection];
                    }
                }
            }
            
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
                
                if(CGRectContainsPoint(CGRectMake(270.0f - (buyButton.imageWidth/2), 297.0f - (buyButton.imageHeight/2), buyButton.imageWidth, buyButton.imageHeight), location)){
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
                if(CGRectContainsPoint(CGRectMake(270.0f - (equipButton.imageWidth/2), 263.0f - (equipButton.imageHeight/2), equipButton.imageWidth, equipButton.imageHeight), location)){
                    if([currentEquippedWeapon isEqualToString:kWeaponTypeWave]){
                        if(currentWaveLevelSelection != currentEquippedWeaponLevel && currentWaveLevelSelection <= highestAchievedWaveLevel){
                            //To equip
                            [self equipWeapon:currentSelectedWeaponType level:currentWaveLevelSelection];
                        }
                    }
                }
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
                
                if(CGRectContainsPoint(CGRectMake(270.0f - (buyButton.imageWidth/2), 217.0f - (buyButton.imageHeight/2), buyButton.imageWidth, buyButton.imageHeight), location)){
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
                if(CGRectContainsPoint(CGRectMake(270.0f - (equipButton.imageWidth/2), 183.0f - (equipButton.imageHeight/2), equipButton.imageWidth, equipButton.imageHeight), location)){
                    if([currentEquippedWeapon isEqualToString:kWeaponTypeMissile]){
                        if(currentMissileLevelSelection != currentEquippedWeaponLevel && currentMissileLevelSelection <= highestAchievedMissileLevel){
                            //To equip
                            [self equipWeapon:currentSelectedWeaponType level:currentMissileLevelSelection];
                        }
                    }
                }
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
                
                if(CGRectContainsPoint(CGRectMake(270.0f - (buyButton.imageWidth/2), 137.0f - (buyButton.imageHeight/2), buyButton.imageWidth, buyButton.imageHeight), location)){
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
                if(CGRectContainsPoint(CGRectMake(270.0f - (equipButton.imageWidth/2), 103.0f - (equipButton.imageHeight/2), equipButton.imageWidth, equipButton.imageHeight), location)){
                    if([currentEquippedWeapon isEqualToString:kWeaponTypeHeatseeking]){
                        if(currentHeatseekingLevelSelection != currentEquippedWeaponLevel && currentHeatseekingLevelSelection <= highestAchievedHeatseekingLevel){
                            //To equip
                            [self equipWeapon:currentSelectedWeaponType level:currentHeatseekingLevelSelection];
                        }
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
            
            if(CGRectContainsPoint(CGRectMake(280.0f - (buyButton.imageWidth/2), 70.0f - (buyButton.imageHeight/2), buyButton.imageWidth, buyButton.imageHeight), location)){
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
            if(CGRectContainsPoint(CGRectMake(280.0f - (equipButton.imageWidth/2), 30.0f - (equipButton.imageHeight/2), equipButton.imageWidth, equipButton.imageHeight), location)){
                if(currentBaseShipLevelSelection != [self shipLevelFromType:currentEquippedShipType] && currentBaseShipLevelSelection <= highestAchievedBaseLevel){
                    //To equip
                    [self equipWeapon:currentSelectedWeaponType level:currentBulletLevelSelection];
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
                heatseekingWeaponsUnlocked = YES;
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
    
    return @"nil";
}

- (int)shipLevelFromType:(NSString *)shipType {
    
}

- (void)buyShip:(NSString *)shipType {
    
}

- (void)equipShip:(NSString *)shipType {
    
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
