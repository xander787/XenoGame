//
//  EnemyShip.h
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
//	Last Updated - 11/22/2010 @8:20PM - Alexander
//	- Added in first draft code for the enemy ship class

#import <Foundation/Foundation.h>
#import "PlayerShip.h"
#import "Image.h"
#import "Animation.h"
#import "SpriteSheet.h"
#import "AbstractShip.h"

typedef enum _EnemyShipID {
    kEnemyShip_OneShotLevelOne = 0,
    kEnemyShip_OneShotLevelTwo,
    kEnemyShip_OneShotLevelThree,
    kEnemyShip_OneShotLevelFour,
    kEnemyShip_OneShotLevelFive,
    kEnemyShip_OneShotLevelSix,
    kEnemyShip_OneShotBossAssistLevelOne,
    kEnemyShip_TwoShotLevelOne,
    kEnemyShip_TwoShotLevelTwo,
    kEnemyShip_TwoShotLevelThree,
    kEnemyShip_TwoShotLevelFour,
    kEnemyShip_TwoShotLevelFive,
    kEnemyShip_TwoShotLevelSix,
    kEnemyShip_TwoShotLevelSeven,
    kEnemyShip_TwoShotBossAssistLevelOne,
    kEnemyShip_TwoShotBossAssistLevelTwo,
    kEnemyShip_TwoShotBossAssistLevelThree,
    kEnemyShip_ThreeShotLevelOne,
    kEnemyShip_ThreeShotLevelTwo,
    kEnemyShip_ThreeShotLevelThree,
    kEnemyShip_ThreeShotLevelFour,
    kEnemyShip_ThreeShotLevelFive,
    kEnemyShip_ThreeShotBossAssistLevelOne,
    kEnemyShip_WaveShotLevelOne,
    kEnemyShip_WaveShotLevelTwo,
    kEnemyShip_WaveShotLevelThree,
    kEnemyShip_WaveShotLevelFour,
    kEnemyShip_WaveShotLevelFive,
    kEnemyShip_WaveShotBossAssistLevelOne,
    kEnemyShip_MissileBombShotLevelOne,
    kEnemyShip_MissileBombShotLevelTwo,
    kEnemyShip_MissileBombShotLevelThree,
    kEnemyShip_MissileBombShotLevelFour,
    kEnemyShip_MissileBombShotLevelFive,
    kEnemyShip_MissileBombShotBossAssistLevelOne,
    kEnemyShip_MissileBombShotBossAssistLevelTwo,
    kEnemyShip_MissileBombShotBossAssistLevelThree,
    kEnemyShip_KamikazeLevelOne,
    kEnemyShip_KamikazeLevelTwo,
    kEnemyShip_KamikazeLevelThree,
    kEnemyShip_KamikazeLevelFour,
    kEnemyShip_KamikazeBossAssistLevelOne,
    kEnemyShip_KamikazeBossAssistLevelTwo,
    kEnemyShip_KamikazeBossAssistLevelThree,
    kEnemyShip_KamikazeBossAssistLevelFour,
    kEnemyShip_KamikazeBossAssistLevelFive,
    kEnemyShip_KamikazeBossAssistLevelSix
} EnemyShipID;

typedef enum _EnemyShipCategory {
    kEnemyCategory_OneShot = 0,
    kEnemyCategory_TwoShot,
    kEnemyCategory_ThreeShot,
    kEnemyCategory_WaveShot,
    kEnemyCategory_MissileBombShot,
    kEnemyCategory_Kamikaze
} EnemyShipCategory;

@interface EnemyShip : AbstractShip {
	int						enemyHealth;
	int						enemyAttack;
	int						enemyStamina;
	int						enemySpeed;
    CGPoint                 currentLocation;
    
    @private
    EnemyShipID             enemyID;
    EnemyShipCategory       enemyCategroy;
    Vector2f                *weaponPoints;
    SpriteSheet             *enemySpriteSheet;
    Animation               *enemyAnimation;
    PlayerShip              **playerShipRef;
}

- (id)initWithShipID:(EnemyShipID)aEnemyID initialLocation:(CGPoint)aPoint andPlayerShipRef:(PlayerShip **)aPlayership;

@end
