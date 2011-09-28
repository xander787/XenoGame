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

/*#define kXP750_Price
 #define kXP751_Price
 #define kXPA368_Price
 #define kXPA600_Price
 #define kXPA617_Price
 #define kXPA652_Price
 #define kXPA679_Price
 #define kXPD900_Price
 #define kXPD909_Price
 #define kXPD924_Price
 #define kXPD945_Price
 #define kXPD968_Price
 #define kXPS400_Price
 #define kXPS424_Price
 #define kXPS447_Price
 #define kXPS463_Price
 #define kXPS485_Price
 
 #define kBulletLevelOne_Price
 #define kBulletLevelTwo_Price
 #define kBulletLevelThree_Price
 #define kBulletLevelFour_Price
 #define kBulletLevelFive_Price
 #define kBulletLevelSix_Price
 #define kBulletLevelSeven_Price
 #define kBulletLevelEight_Price
 #define kBulletLevelNine_Price
 #define kBulletLevelTen_Price
 
 #define kWaveLevelOne_Price
 #define kWaveLevelTwo_Price
 #define kWaveLevelThree_Price
 #define kWaveLevelFour_Price
 #define kWaveLevelFive_Price
 #define kWaveLevelSix_Price
 #define kWaveLevelSeven_Price
 #define kWaveLevelEight_Price
 #define kWaveLevelNine_Price
 #define kWaveLevelTen_Price
 
 #define kMissilesLevelOne_Price
 #define kMissileLevelTwo_Price
 #define kMissileLevelThree_Price
 #define kMissileLevelFour_Price
 #define kMissileLevelFive_Price
 #define kMissileLevelSix_Price
 #define kMissileLevelSeven_Price
 #define kMissileLevelEight_Price
 #define kMissileLevelNine_Price
 #define kMissileLevelTen_Price
 
 #define kHeatseekerLevelOne_Price*/

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
