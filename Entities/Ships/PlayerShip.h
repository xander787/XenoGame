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
	kWeapon_SingleShot = 0,
	kWeapon_DoubleShot,
	kWeapon_TripleShot,
	kWeapon_Missile,
	kWeapon_Wave
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
	
@private
	PlayerShipID						shipID;
	PlayerShipCategory					shipCategory;
	PlayerShipWeaponType				shipWeaponType;
	Image								*mainImage;
	Vector2f							*turretPoints;
	Vector2f						*thrusterPoints;
}

- (id)initWithShipID:(PlayerShipID)aShipID;
- (void)renderAtPoint:(CGPoint)aPoint centerOfShip:(BOOL)aCenter;
- (void)fireWeapons;

@property (readonly) int shipHealth;
@property (readonly) int shipAttack;
@property (readonly) int shipStamina;
@property (readonly) int shipSpeed;
@property PlayerShipTemporaryWeaponUpgrade	shipTemporaryWeaponUpgrade;
@property PlayerShipTemporaryMiscUpgrade	shipTemporaryMiscUpgrade;

@end
