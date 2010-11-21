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
//
//	Last Updated - 11/20/2010 @7PM - Alexander
//	- Changed problem loading main PLIST thanks to James
//	- Fixed problems with trying to get stringValue from strings
//	- Drawing will now work
//	- Working on fixing the turrets code

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
		NSBundle *bundle = [NSBundle mainBundle];
		NSString *path = [NSString stringWithString:[bundle pathForResource:@"PlayerShips" ofType:@"plist"]];
		NSMutableDictionary *playerShipsDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
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
		
		NSLog(@"%@", playerShipsDictionary);
		
		shipHealth = 100;
		shipAttack  = [[shipDictionary valueForKey:@"kShipAttack"] intValue];
		shipStamina = [[shipDictionary valueForKey:@"kShipStamina"] intValue];
		shipSpeed = [[shipDictionary valueForKey:@"kShipSpeed"] intValue];
		
		if ([shipDictionary valueForKey:@"kShipCategory"] == @"kShipCategory_Attack") {
			shipCategory = kShipCategory_Attack;
		}
		else if ([shipDictionary valueForKey:@"kShipCategory"] == @"kShipCategory_Stamina") {
			shipCategory = kShipCategory_Stamina;
		}
		else if ([shipDictionary valueForKey:@"kShipCategory"] == @"kShipCategory_Speed") {
			shipCategory = kShipCategory_Speed;
		}
		
		if ([shipDictionary valueForKey:@"kWeaponType"] == @"kWeapon_SingleShot") {
			shipWeaponType = kWeapon_SingleShot;
		}
		else if ([shipDictionary valueForKey:@"kWeaponType"] == @"kWeapon_DoubleShot") {
			shipWeaponType = kWeapon_DoubleShot;
		}
		else if ([shipDictionary valueForKey:@"kWeaponType"] == @"kWeapon_TripleShot") {
			shipWeaponType = kWeapon_TripleShot;
		}
		else if ([shipDictionary valueForKey:@"kWeaponType"] == @"kWeapon_Missile") {
			shipWeaponType = kWeapon_Missile;
		}
		else if ([shipDictionary valueForKey:@"kWeaponType"] == @"kWeapon_Wave") {
			shipWeaponType = kWeapon_Wave;
		}
		
		NSArray *turretArray = [shipDictionary objectForKey:@"kTurretPoints"];
		turretPoints = malloc(sizeof(Vector2f) * [turretArray count]);
		bzero( turretPoints, sizeof(Vector2f) * [turretArray count]);
		
		/*for (int i = 0; i < [turretArray count]; i++) {
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
		}*/
				
		mainImage = [[Image alloc] initWithImage:[shipDictionary valueForKey:@"kMainImage"] scale:(1.0/4.0)];
		
		[playerShipsDictionary release];
		[shipDictionary release];
	}
	
	return self;
}

- (void)renderAtPoint:(CGPoint)aPoint centerOfShip:(BOOL)aCenter {
	[mainImage renderAtPoint:aPoint centerOfImage:aCenter];
}

- (void)fireWeapons {
	
}

@end
