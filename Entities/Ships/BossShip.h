//
//  BossShip.h
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
//	Last Updated - 11/25/2010 @8PM - Alexander
//	- Wrote initial structure for the Boss class and created
//  a few structs for the modular objects and weapons
//
//	Last Updated - 11/26/2010 @6PM - Alexander
//	- Added variables (num weapons, num thrusters) for
//  rendering purposes
//
//  Last Updated - 1/31/20101 @8PM - Alexander
//  - Added rotation property to modules
//
//  Last Updated - 6/15/2011 @1:10PM - James
//  - Removed some redundant variables, moved in AbstractShip class
//
//  Last Updated - 6/22/11 @5PM - Alexander & James
//  - Changed enums to reflect new bosses
//
//  Last Updated - 7/19/11 @5PM - Alexander
//  - Modules now have default and current location

#import <Foundation/Foundation.h>
#import "Common.h"
#import "AbstractShip.h"
#import "Image.h"
#import "Animation.h"
#import "SpriteSheet.h"
#import "PlayerShip.h"
#import "Polygon.h"

typedef enum _BossType {
    kBossType_Mini = 0,
    kBossType_Full
} BossType;

typedef enum _BossShipID {
    kBoss_Themis = 0,
    kBoss_Eos,
    kBoss_Astraeus,
    kBoss_Helios,
    kBoss_Oceanus,
    kBoss_Atlas,
    kBoss_Hyperion,
    kBoss_Kronos,
    kBoss_AlphaWeapon,
    kMiniBoss_OneOne,
    kMiniBoss_OneTwo,
    kMiniBoss_OneThree,
    kMiniBoss_TwoOne,
    kMiniBoss_TwoTwo,
    kMiniBoss_TwoThree,
    kMiniBoss_ThreeOne,
    kMiniBoss_ThreeTwo,
    kMiniBoss_ThreeThree,
    kMiniBoss_FourOne,
    kMiniBoss_FourTwo,
    kMiniBoss_FiveOne,
    kMiniBoss_FiveTwo,
    kMiniBoss_FiveThree,
    kMiniBoss_SixOne,
    kMiniBoss_SixTwo,
    kMiniBoss_SixThree,
    kMiniBoss_SevenOne,
    kMiniBoss_SevenTwo,
    kMiniBoss_SevenThree
} BossShipID;

typedef enum _WeaponType {
    kBossWeapon_Default = 0,
    kBossWeapon_Turret,
    kBossWeapon_Cannon,
    kBossWeapon_Wave,
    kBossWeapon_Laser
} WeaponType;

typedef struct _WeaponObject {
    WeaponType  weaponType;
    Vector2f    weaponCoord;
} WeaponObject;

typedef struct _ModularObject {
    int             numberOfWeapons;
    int             numberOfThrusters;
    WeaponObject    *weapons;
    BOOL            floating;
    int             positionFloatVariance;
    Vector2f        *thrusterPoints;
    int             destructionOrder;
    int             drawingOrder;
    Vector2f        location;
    Vector2f        defaultLocation;
    Image           *moduleImage;
    
    Vector2f        *collisionDetectionBoundingPoints;
    Polygon         *collisionPolygon;
    int             collisionPointsCount;
    float           rotation;
    
    float           moduleMaxHealth;
    float           moduleHealth;
    BOOL            isDead;
} ModularObject;


@interface BossShip : AbstractShip {
    int             bossHealth;
    int             bossAttack;
    int             bossStamina;
    int             bossSpeed;
    CGPoint         desiredLocation;
    ModularObject   *modularObjects;

    
    PlayerShip      *playerShipRef;
    
    int             numberOfModules;
    BossShipID      bossID;
    BossType        bossType;
}

@property(nonatomic, readonly) int bossHealth;
@property(nonatomic, readonly) int bossAttack;
@property(nonatomic, readonly) int bossStamina;
@property(nonatomic, readonly) int bossSpeed;
@property(readonly) ModularObject   *modularObjects;

- (id)initWithBossID:(BossShipID)aBossID initialLocation:(CGPoint)aPoint andPlayerShipRef:(PlayerShip *)aPlayerShip;
- (void)setDesiredLocation:(CGPoint)aPoint;

@end
