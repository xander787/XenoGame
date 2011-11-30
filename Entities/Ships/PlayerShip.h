//
//  PlayerShip.h
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
//	Last Updated - 11/20/2010 @6PM - Alexander
//	- Wrote in all needed attributes for the ship as aggreed
//	upon by xander and james.
//
//	Last Updated - 11/21/2010 @11AM - Alexander
//	- Replaced thruster and turret arrays with C arrays
//  so that they can hold Vector2f structs
//
//	Last Updated - 11/22/2010 @12AM - Alexander
//	- Added in first test code for moving the ship
//  using the updateWithDelta approach and coords
//  passed in from the scene class the ship is in
//
// Last Updated - 11/22/2010 @11:40AM - James
//  -Corrected movement bug when movign the PlayerShip
//  It now moves smoothly and in it's selected slope
//
//  Last Updated - 12/29/10 @12AM - Alexander
//  - Added array for collision bounding points
//
//  Last Updated - 12/29/2010 @11:50PM - James
//  - Changed the collision array to be readonly and public
//
//  Last Updated - 1/1/11 @9:30PM - Alexander
//  - Added shipWidth and shipHeight properties
//
//  Last Updated - 1/26/2011 @5:20PM - Alexander
//  - Added NSMutableArray for storing our projectiles
//
//  Last Updated - 6/15/2011 @1:10PM - James
//  - Removed some redundant variables, moved in AbstractShip class

#import <Foundation/Foundation.h>
#import "AbstractShip.h"
#import "Image.h"
#import "Animation.h"
#import "Polygon.h"
#import "AbstractProjectile.h"
#import "BulletProjectile.h"
#import "MissileProjectile.h"
#import "WaveProjectile.h"

#define kXP750 @"kShipXP750"
#define kXP751 @"kShipXP751"
#define kXPA368 @"kShipXPA368"
#define kXPA600 @"kShipXPA600"
#define kXPA617 @"kShipXPA617"
#define kXPA652 @"kShipXPA652"
#define kXPA679 @"kShipXPA679"
#define kXPD900 @"kShipXPD900"
#define kXPD909 @"kShipXPD909"
#define kXPD924 @"kShipXPD924"
#define kXPD945 @"kShipXPD945"
#define kXPD968 @"kShipXPD968"
#define kXPS400 @"kShipXPS400"
#define kXPS424 @"kShipXPS424"
#define kXPS447 @"kShipXPS447"
#define kXPS463 @"kShipXPS463"
#define kXPS485 @"kShipXPS485"

typedef enum _PlayerShipID {
	kPlayerShip_Dev = 0,
	kPlayerShip_XP750,
    kPlayerShip_XP751,
    kPlayerShip_XPA368,
    kPlayerShip_XPA600,
    kPlayerShip_XPA617,
    kPlayerShip_XPA652,
    kPlayerShip_XPA679,
    kPlayerShip_XPD900,
    kPlayerShip_XPD909,
    kPlayerShip_XPD924,
    kPlayerShip_XPD945,
    kPlayerShip_XPD968,
    kPlayerShip_XPS400,
    kPlayerShip_XPS424,
    kPlayerShip_XPS447,
    kPlayerShip_XPS463,
    kPlayerShip_XPS485
} PlayerShipID;

typedef enum _PlayerShipCategory {
	kShipCategory_Attack = 0,
	kShipCategory_Stamina,
	kShipCategory_Speed
} PlayerShipCategory;

typedef enum _PlayerShipWeaponType {
    kPlayerWeapon_Wave = 0,
	kPlayerWeapon_Missile,
    kPlayerWeapon_Heatseeker
} PlayerShipWeaponType;

typedef enum _PlayerShipTemporaryWeaponUpgrade {
	kTemporaryWeaponUpgrade_None = 0,
	kTemporaryWeaponUpgrade_Bomb,
	kTemporaryWeaponUpgrade_TripleShot,
	kTemporaryWeaponUpgrade_Wave
} PlayerShipTemporaryWeaponUpgrade;

typedef enum _PlayerShipTemporaryMiscUpgrade {
	kTemporaryMiscUpgrade_None = 0,
	kTemporaryMiscUpgrade_Repel
} PlayerShipTemporaryMiscUpgrade;


@interface PlayerShip : AbstractShip {
	
	PlayerShipTemporaryWeaponUpgrade	shipTemporaryWeaponUpgrade;
	PlayerShipTemporaryMiscUpgrade		shipTemporaryMiscUpgrade;

    CGPoint                             desiredPosition;
    
	PlayerShipID						shipID;
	PlayerShipCategory					shipCategory;
	PlayerShipWeaponType				shipWeaponType;
	
@private
	Image								*mainImage;
	
}

@property (readonly) PlayerShipCategory shipCategory;
@property (readonly) PlayerShipWeaponType shipWeaponType;

- (id)initWithShipID:(PlayerShipID)aShipID andInitialLocation:(CGPoint)aPoint;
- (void)setDesiredLocation:(CGPoint)aPoint;
- (void)shipWasHitWithProjectile:(AbstractProjectile *)projectile;
- (void)fireWeapons;
- (void)destroyShip;
- (void)stopAllProjectiles;
- (void)pauseAllProjectiles;
- (void)playAllProjectiles;


@property PlayerShipTemporaryWeaponUpgrade	shipTemporaryWeaponUpgrade;
@property PlayerShipTemporaryMiscUpgrade	shipTemporaryMiscUpgrade;
@property (readwrite) CGPoint desiredPosition;

@end
