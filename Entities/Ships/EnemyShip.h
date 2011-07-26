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
//
//  Last Updated - 11/24/2010 @1:15PM - James
//  - Fixed warning todo with confliction types for playerShipRef,
//  it was supposed to be a single pointer, and it was still a
//  double pointer, thoguh both worked, this is correct and no warnings.
//
//  Last Updated - 11/25/10 @8PM - Alexander
//  - Forgot to add properties for the public items
//
//  Last Updated - 11/29/10 @8PM - Alexander
//  - Made some minor changes to the enemy ship ID enum
//  regarding the IDs of enemies that support other bosses
//
//  Last Updated - 12/29/10 @12AM - Alexander
//  - Added array for collision bounding points
//
//  Last Updated - 1/1/11 @9:30PM - Alexander
//  - Added shipWidth and shipHeight properties
//
//  Last Updated - 1/3/11 @4PM - Alexander
//  - Adding in code to support the Polygon Collision system
//
//  Last Updated - 6/15/2011 @1:10PM - James
//  - Removed some redundant variables, moved in AbstractShip class
//
//  Last Updated - 6/23/11 @8PM - Alexander
//  - Added some variables for the temporary red filter over ships when hit
//
//  Last Updated - 6/29/11 @5PM - James
//  - Setup paths for the ships when they come in

#import <Foundation/Foundation.h>
#import "PlayerShip.h"
#import "Image.h"
#import "Animation.h"
#import "SpriteSheet.h"
#import "AbstractShip.h"
#import "Polygon.h"
#import "BezierCurve.h"

typedef enum _EnemyShipID {
    kEnemyShip_OneShotLevelOne = 0,
    kEnemyShip_OneShotLevelTwo,
    kEnemyShip_OneShotLevelThree,
    kEnemyShip_OneShotLevelFour,
    kEnemyShip_OneShotLevelFive,
    kEnemyShip_OneShotLevelSix,
    kEnemyShip_OneShotkBossAfricaAssist,
    kEnemyShip_TwoShotLevelOne,
    kEnemyShip_TwoShotLevelTwo,
    kEnemyShip_TwoShotLevelThree,
    kEnemyShip_TwoShotLevelFour,
    kEnemyShip_TwoShotLevelFive,
    kEnemyShip_TwoShotLevelSix,
    kEnemyShip_TwoShotLevelSeven,
    kEnemyShip_TwoShotkBossAfricaAssistOne,
    kEnemyShip_TwoShotkBossAfricaAssistTwo,
    kEnemyShip_TwoShotkBossAsiaAssist,
    kEnemyShip_ThreeShotLevelOne,
    kEnemyShip_ThreeShotLevelTwo,
    kEnemyShip_ThreeShotLevelThree,
    kEnemyShip_ThreeShotLevelFour,
    kEnemyShip_ThreeShotLevelFive,
    kEnemyShip_ThreeShotkBossAsiaAssist,
    kEnemyShip_WaveShotLevelOne,
    kEnemyShip_WaveShotLevelTwo,
    kEnemyShip_WaveShotLevelThree,
    kEnemyShip_WaveShotLevelFour,
    kEnemyShip_WaveShotLevelFive,
    kEnemyShip_WaveShotkBossAntarcticaAssist,
    kEnemyShip_MissileBombShotLevelOne,
    kEnemyShip_MissileBombShotLevelTwo,
    kEnemyShip_MissileBombShotLevelThree,
    kEnemyShip_MissileBombShotLevelFour,
    kEnemyShip_MissileBombShotLevelFive,
    kEnemyShip_MissileBombShotkBossSouthAmericaAssist,
    kEnemyShip_MissileBombShotkBossEuropeAssist,
    kEnemyShip_MissileBombShotkBossAustraliaAssist,
    kEnemyShip_KamikazeLevelOne,
    kEnemyShip_KamikazeLevelTwo,
    kEnemyShip_KamikazeLevelThree,
    kEnemyShip_KamikazeLevelFour,
    kEnemyShip_KamikazekBossNorthAmericaAssistOne,
    kEnemyShip_KamikazekBossNorthAmericaAssistTwo,
    kEnemyShip_KamikazekBossSouthAmericaAssist,
    kEnemyShip_KamikazekBossEuropeAssist,
    kEnemyShip_KamikazekBossAustraliaAssist,
    kEnemyShip_KamikazekBossAntarcticaAssist
} EnemyShipID;

typedef enum _EnemyShipCategory {
    kEnemyCategory_OneShot = 0,
    kEnemyCategory_TwoShot,
    kEnemyCategory_ThreeShot,
    kEnemyCategory_WaveShot,
    kEnemyCategory_MissileBombShot,
    kEnemyCategory_Kamikaze
} EnemyShipCategory;

typedef enum _PathType {
    kPathType_Initial = 0,
    kPathType_ToHolding,
    kPathType_Holding, 
    kPathType_Attacking
} PathType;

@interface EnemyShip : AbstractShip {
    CGPoint                 holdingPositionPoint;
    
@private
    EnemyShipID             enemyID;
    EnemyShipCategory       enemyCategory;
    SpriteSheet             *enemySpriteSheet;
    Animation               *enemyAnimation;
    PlayerShip              *playerShipRef;
    
    float                   hitFilterEffectTime;
    BOOL                    hitFilter;
    
    BezierCurve             *currentPath;
    GLfloat                 pathTime;
    
    PathType                currentPathType;
    
    CGPoint                 desiredPosition;
    
    CGPoint                 holdingDirection;
    GLfloat                 holdingTimer;
    
    BOOL                    powerUpDropped;
}
@property(nonatomic, retain) BezierCurve *currentPath;
@property(readwrite) PathType currentPathType;
@property(readwrite) GLfloat pathTime;
@property(readwrite) CGPoint desiredPosition;
@property(readwrite) CGPoint holdingPositionPoint;
@property(readwrite) BOOL powerUpDropped;
@property(readonly) EnemyShipID enemyID;

- (id)initWithShipID:(EnemyShipID)aEnemyID initialLocation:(CGPoint)aPoint andPlayerShipRef:(PlayerShip *)aPlayership;
- (BOOL)isKamikazeShip;
- (void)stopAllProjectiles;
- (void)pauseAllProjectiles;
- (void)playAllProjectiles;


@end
