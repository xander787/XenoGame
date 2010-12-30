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

#import <Foundation/Foundation.h>
#import "AbstractShip.h"
#import "Image.h"
#import "Animation.h"

typedef enum _PlayerShipID {
	kPlayerShip_Dev = 0,
	kPlayerShip_Default
} PlayerShipID;

typedef enum _PlayerShipCategory {
	kShipCategory_Attack = 0,
	kShipCategory_Stamina,
	kShipCategory_Speed
} PlayerShipCategory;

typedef enum _PlayerShipWeaponType {
	kPlayerWeapon_SingleShot = 0,
	kPlayerWeapon_DoubleShot,
	kPlayerWeapon_TripleShot,
	kPlayerWeapon_Missile,
	kPlayerWeapon_Wave
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
	int									shipHealth;
	int									shipAttack;
	int									shipStamina;
	int									shipSpeed;
	PlayerShipTemporaryWeaponUpgrade	shipTemporaryWeaponUpgrade;
	PlayerShipTemporaryMiscUpgrade		shipTemporaryMiscUpgrade;
    CGPoint                             currentLocation;
    Vector2f                            *collisionDetectionBoundingPoints;

	
@private
	PlayerShipID						shipID;
	PlayerShipCategory					shipCategory;
	PlayerShipWeaponType				shipWeaponType;
	Image								*mainImage;
	Vector2f							*turretPoints;
	Vector2f                            *thrusterPoints;
    CGPoint                             desiredPosition;
}

- (id)initWithShipID:(PlayerShipID)aShipID andInitialLocation:(CGPoint)aPoint;
- (void)setDesiredLocation:(CGPoint)aPoint;
- (void)fireWeapons;

@property (readonly) int shipHealth;
@property (readonly) int shipAttack;
@property (readonly) int shipStamina;
@property (readonly) int shipSpeed;
@property PlayerShipTemporaryWeaponUpgrade	shipTemporaryWeaponUpgrade;
@property PlayerShipTemporaryMiscUpgrade	shipTemporaryMiscUpgrade;
@property (readonly) CGPoint currentLocation;
@property (readonly) Vector2f *collisionDetectionBoundingPoints;

@end
