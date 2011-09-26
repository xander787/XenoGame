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

    
    ParticleEmitter     *backgroundParticleEmitter;
}

@end
