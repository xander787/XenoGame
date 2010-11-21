//
//  PlayerShip.m
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
//	- Attempting to be able to load information from the PLIST file for a ship

#import "PlayerShip.h"


@implementation PlayerShip

@synthesize shipHealth, shipAttack, shipStamina, shipSpeed, shipTemporaryWeaponUpgrade, shipTemporaryMiscUpgrade;

- (id) init {
	self = [super init];
	return self;
}

- (id)initWithShipID:(PlayerShipID)aShipID {
	if (self = [super init]) {
		shipID = aShipID;
		NSMutableDictionary *playerShipsDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:@"PlayerShips.plist"];
		NSMutableDictionary *shipDictionary;
		switch (shipID) {
			case kPlayerShip_Default:
				shipDictionary = [[NSMutableDictionary alloc] initWithDictionary:[playerShipsDictionary objectForKey:@"kPlayerShip_Default"]];
				break;
			case kPlayerShip_Dev:
				shipDictionary = [[NSMutableDictionary alloc] initWithDictionary:[playerShipsDictionary objectForKey:@"kPlayerShip_Dev"]];
				break;
			default:
				break;
		}
		[playerShipsDictionary release];
		
		shipHealth = 100;
		shipAttack  = [[playerShipsDictionary valueForKey:@"kShipAttack"] intValue];
		shipStamina = [[playerShipsDictionary valueForKey:@"kShipStamina"] intValue];
		shipSpeed = [[playerShipsDictionary valueForKey:@"kShipSpeed"] intValue];
		
		if ([[playerShipsDictionary valueForKey:@"kShipCategory"] stringValue] == @"kShipCategory_Attack") {
			shipCategory = kShipCategory_Attack;
		}
		else if ([[playerShipsDictionary valueForKey:@"kShipCategory"] stringValue] == @"kShipCategory_Stamina") {
			shipCategory = kShipCategory_Stamina;
		}
		else if ([[playerShipsDictionary valueForKey:@"kShipCategory"] stringValue] == @"kShipCategory_Speed") {
			shipCategory = kShipCategory_Speed;
		}
		
		if ([[playerShipsDictionary valueForKey:@"kWeaponType"] stringValue] == @"kWeapon_SingleShot") {
			shipWeaponType = kWeapon_SingleShot;
		}
		else if ([[playerShipsDictionary valueForKey:@"kWeaponType"] stringValue] == @"kWeapon_DoubleShot") {
			shipWeaponType = kWeapon_DoubleShot;
		}
		else if ([[playerShipsDictionary valueForKey:@"kWeaponType"] stringValue] == @"kWeapon_TripleShot") {
			shipWeaponType = kWeapon_TripleShot;
		}
		else if ([[playerShipsDictionary valueForKey:@"kWeaponType"] stringValue] == @"kWeapon_Missile") {
			shipWeaponType = kWeapon_Missile;
		}
		else if ([[playerShipsDictionary valueForKey:@"kWeaponType"] stringValue] == @"kWeapon_Wave") {
			shipWeaponType = kWeapon_Wave;
		}
		
		NSArray *turretArray = [playerShipsDictionary objectForKey:@"kTurretPoints"];
		turretPoints = malloc(sizeof(Vector2f) * [turretArray count]);
		bzero( turretPoints, sizeof(Vector2f) * [turretArray count]);
		
		for (int i = 0; i < [turretArray count]; i++) {
			NSArray *coords = [[[turretArray objectAtIndex:i] stringValue] componentsSeparatedByString:@","];
			@try {
				turretPoints[i] = Vector2fMake([[coords objectAtIndex:0] intValue], [[coords objectAtIndex:1] intValue]);
			}
			@catch (NSException * e) {
				NSLog(@"Exception thrown: %@", e);
			}
			@finally {
				NSLog(@"Finally");
			}
		}
		
		mainImage = [[Image alloc] initWithImage:[[playerShipsDictionary valueForKey:@"kMainImage"] stringValue] scale:(1.0/4.0)];
	}
	
	return self;
}

- (void)renderAtPoint:(CGPoint)aPoint centerOfShip:(BOOL)aCenter {
	[mainImage renderAtPoint:aPoint centerOfImage:aCenter];
}

- (void)fireWeapons {
	
}

@end
