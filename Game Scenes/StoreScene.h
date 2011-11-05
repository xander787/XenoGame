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
    ParticleEmitter     *backgroundParticleEmitter;
    NSUserDefaults      *settings;

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
    Image               *weaponsMenuWavesButtonDisabled;
    Image               *weaponsMenuMissilesButtonDisabled;
    Image               *weaponsMenuHeatseekingButtonDisabled;
    Image               *weaponsMenuBulletsButtonEquipped;
    Image               *weaponsMenuWavesButtonEquipped;
    Image               *weaponsMenuMissilesButtonEquipped;
    Image               *weaponsMenuHeatseekingButtonEquipped;
    
    Image               *nextButton;
    Image               *previousButton;
        
    
    Image               *equipButton;
    Image               *buyButton;
    Image               *equipButtonDisabled;
    Image               *buyButtonDisabled;
    Image               *equippedButton;
    Image               *boughtButton;
    
    
    // Weapons scene data
    
    BOOL                wavesWeaponsUnlocked;
    BOOL                missilesWeaponsUnlocked;
    BOOL                heatseekingWeaponsUnlocked;
    
    unsigned int        highestAchievedBulletLevel;
    unsigned int        highestAchievedWaveLevel;
    unsigned int        highestAchievedMissileLevel;
    unsigned int        highestAchievedHeatseekingLevel;
        
    unsigned int        currentBulletLevelSelection;
    unsigned int        currentWaveLevelSelection;
    unsigned int        currentMissileLevelSelection;
    unsigned int        currentHeatseekingLevelSelection;
    
    NSMutableString     *currentEquippedWeapon;
    unsigned int        currentEquippedWeaponLevel;
    NSMutableString     *currentSelectedWeaponType;
    
    
    //Ships data
    
    BOOL                speedShipsUnlocked;
    BOOL                attackShipsUnlocked;
    BOOL                defenseShipsUnlocked;
    
    unsigned int        currentBaseShipLevelSelection;
    unsigned int        currentAttackShipLevelSelection;
    unsigned int        currentSpeedShipLevelSelection;
    unsigned int        currentDefenseShipLevelSelection;
    
    unsigned int        highestAchievedBaseLevel;
    unsigned int        highestAchievedAttackLevel;
    unsigned int        highestAchievedSpeedLevel;
    unsigned int        highestAchievedDefenseLevel;
    
    NSMutableString     *currentEquippedShipType;
}

- (int)priceOfCurrentSelectedWeapon;
- (int)priceOfWeapon:(NSString *)weaponTypeName level:(int)level;
- (void)buyCurrentWeapon:(NSString *)weaponTypeName level:(int)level;
- (void)equipWeapon:(NSString *)weaponTypeName level:(int)level;
- (int)priceOfShip:(NSString *)shipType;
- (NSString *)shipTypeFromCategory:(NSString *)shipCat andLevel:(int)shipLevel;
- (int)shipLevelFromType:(NSString *)shipType;
- (NSString *)shipCategoryFromType:(NSString *)shipType;
- (void)buyShip:(NSString *)shipType;
- (void)equipShip:(NSString *)shipType;
- (NSString *)displayStringForShip:(NSString *)shipType;

@end
