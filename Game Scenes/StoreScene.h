//
//  StoreScene.h
//  Xenophobe
//
//  Created by Alexander on 7/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractScene.h"
#import "AngelCodeFont.h"

#define kXP750_Price 0
#define kXP751_Price 100
#define kXPA368_Price 300
#define kXPA600_Price 1000
#define kXPA617_Price 1800
#define kXPA652_Price 2700
#define kXPA679_Price 3750
#define kXPD900_Price 300
#define kXPD909_Price 1000
#define kXPD924_Price 1800
#define kXPD945_Price 2700
#define kXPD968_Price 3750
#define kXPS400_Price 200
#define kXPS424_Price 1000
#define kXPS447_Price 1800
#define kXPS463_Price 2700
#define kXPS485_Price 3750
 
#define kBulletLevelOne_Price 0
#define kBulletLevelTwo_Price 50
#define kBulletLevelThree_Price 300
#define kBulletLevelFour_Price 700
#define kBulletLevelFive_Price 1000
#define kBulletLevelSix_Price 1400
#define kBulletLevelSeven_Price 1800
#define kBulletLevelEight_Price 2300
#define kBulletLevelNine_Price 2800
#define kBulletLevelTen_Price 3450
 
#define kWaveLevelOne_Price 100
#define kWaveLevelTwo_Price 300
#define kWaveLevelThree_Price 600
#define kWaveLevelFour_Price 950
#define kWaveLevelFive_Price 1100
#define kWaveLevelSix_Price 1300
#define kWaveLevelSeven_Price 1700
#define kWaveLevelEight_Price 2100
#define kWaveLevelNine_Price 2400
#define kWaveLevelTen_Price 2700
 
#define kMissilesLevelOne_Price 250
#define kMissileLevelTwo_Price 500
#define kMissileLevelThree_Price 750
#define kMissileLevelFour_Price 1000
#define kMissileLevelFive_Price 1200
#define kMissileLevelSix_Price 1500
#define kMissileLevelSeven_Price 1900
#define kMissileLevelEight_Price 2500
#define kMissileLevelNine_Price 3000
#define kMissileLevelTen_Price 3600

#define kHeatseekerLevelOne_Price 2000

typedef enum _SceneState {
    kSceneState_general_menu = 0,
    kSceneState_ship_upgrades,
    kSceneState_ship_upgrades_base_chooser,
    kSceneState_ship_upgrades_attack_chooser,
    kSceneState_ship_upgrades_speed_chooser,
    kSceneState_ship_upgrades_defense_chooser,
    kSceneState_weapons_upgrades
} SceneState;

@interface StoreScene : AbstractScene {
    AngelCodeFont       *font;
    SceneState          currentSceneState;
    Image               *backButton;
    
    Image               *generalMenuShipsButton;
    Image               *generalMenuWeaponsButton;
    Image               *creditsIcon;
    
    Image               *shipsMenuBaseButton;
    Image               *shipsMenuAttackButton;
    Image               *shipsMenuSpeedButton;
    Image               *shipsMenuDefenseButton;
    
    Image               *weaponsMenuBulletsButton;
    Image               *weaponsMenuWavesButton;
    Image               *weaponsMenuMissilesButton;
    Image               *weaponsMenuHeatseekingButton;
    Image               *weaponsMenuBulletsNextButton;
    Image               *weaponsMenuBulletsPreviousButton;
    Image               *weaponsMenuWavesNextButton;
    Image               *weaponsMenuWavesPreviousButton;
    Image               *weaponsMenuMissilesNextButton;
    Image               *weaponsMenuMissilesPreviousButton;
    Image               *weaponsMenuHeatseekingNextButton;
    Image               *weaponsMenuHeatseekingPreviousButton;
    
    Image               *shipsUpgradeMenuNextButton;
    Image               *shipsUpgradeMenuPreviousButton;
    
    
    Image               *equipButton;
    Image               *buyButton;

    
    ParticleEmitter     *backgroundParticleEmitter;
}

@end
