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
//	Last Updated - 11/20/2010 @7PM - Alexander
//	- Changed problem loading main PLIST thanks to James
//	- Fixed problems with trying to get stringValue from strings
//	- Drawing will now work
//	- Working on fixing the turrets code
//
//	Last Updated - 11/21/2010 @11AM - Alexander
//	- Added in some commenting and fixed a memory leak
//  - Added in code to load the thruster points as well
//
//	Last Updated - 11/22/2010 @12AM - Alexander
//	- Added in first test code for moving the ship
//  using the updateWithDelta approach and coords
//  passed in from the scene class the ship is in
//
//  Last Updated - 11/23/2010 @10:30PM - Alexander
//  - Think I've got the speed variance for the ship
//  down, or at least pretty close now.
//
//  Last Updated - 11/26/2010 @6PM - Alexander
//  - Fixed a bug where the playership would move to the
//  corner of the screen upon initialization
//
//  Last Updated - 12/17/10 @6PM - James
//  - Assigned correct width and height measurements
//  to the boundingBox variable, derived from
//  the GameObject class.
//
//  Last Updated - 12/29/10 @12AM - Alexander
//  - Added in code to load collision bounding points 
//  from PLIST file. Also fixed a bug in thruster points 
//  loading
//
//  Last Updated - 12/29/2010 @ 1AM - James
//  - Started using new NSArray->C Array function in Common.h
//  (Expiremental too), and full backup of old
//  code available on git & local copy on James's comp
//  if anything were to go awry.

#import "PlayerShip.h"


@implementation PlayerShip

@synthesize shipHealth, shipAttack, shipStamina, shipSpeed, shipTemporaryWeaponUpgrade, shipTemporaryMiscUpgrade, currentLocation;

- (id) init {
	self = [super init];
	return self;
}

- (id)initWithShipID:(PlayerShipID)aShipID andInitialLocation:(CGPoint)aPoint {
	if (self = [super init]) {
		shipID = aShipID;
        currentLocation = aPoint;
        desiredPosition = aPoint;
        
        self.position = Vector2fMake(currentLocation.x, currentLocation.y); // Sets position for use of DidCollide
		
		//Load the PLIST with all player ship definitions in them
		NSBundle *bundle = [NSBundle mainBundle];
		NSString *path = [[NSString alloc] initWithString:[bundle pathForResource:@"PlayerShips" ofType:@"plist"]];
		NSMutableDictionary *playerShipsDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
		NSMutableDictionary *shipDictionary;
		[bundle release];
		[path release];
		
		//Extract our specific ship's dictionary from the PLIST and then release it to reduce memory use
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
		
		//Set the values from the dictionary for our ship
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
		
		if ([shipDictionary valueForKey:@"kPlayerWeaponType"] == @"kWeapon_SingleShot") {
			shipWeaponType = kPlayerWeapon_SingleShot;
		}
		else if ([shipDictionary valueForKey:@"kPlayerWeaponType"] == @"kWeapon_DoubleShot") {
			shipWeaponType = kPlayerWeapon_DoubleShot;
		}
		else if ([shipDictionary valueForKey:@"kPlayerWeaponType"] == @"kWeapon_TripleShot") {
			shipWeaponType = kPlayerWeapon_TripleShot;
		}
		else if ([shipDictionary valueForKey:@"kPlayerWeaponType"] == @"kWeapon_Missile") {
			shipWeaponType = kPlayerWeapon_Missile;
		}
		else if ([shipDictionary valueForKey:@"kPlayerWeaponType"] == @"kWeapon_Wave") {
			shipWeaponType = kPlayerWeapon_Wave;
		}
		/***
         OLD CODE STILL BACKED UP ON GIT & PRIVATE COPY ON JAMES'S COMP, NO WORRIES.
        ***/
		//Fill a C array with Vector2f's for our ship's turret points
		NSArray *turretArray = [[NSArray alloc] initWithArray:[shipDictionary objectForKey:@"kTurretPoints"]];
		turretPoints = transferFromNSArrayToCArray(turretArray);
        [turretArray release];
        
        //Fill a C array with Vector2f's of our ship's thruster points
        NSArray *thrusterArray = [[NSArray alloc] initWithArray:[shipDictionary objectForKey:@"kThrusterPoints"]];
        thrusterPoints = transferFromNSArrayToCArray(thrusterArray);
        [thrusterArray release];
        
        //Fill a C array with Vector2f's of our ship's collision detection bounding points
        NSArray *collisionArray = [[NSArray alloc] initWithArray:[shipDictionary objectForKey:@"kCollisionBoundingPoints"]];
        collisionDetectionBoundingPoints = transferFromNSArrayToCArray(collisionArray);
        [collisionArray release];
        
		mainImage = [[Image alloc] initWithImage:[shipDictionary valueForKey:@"kMainImage"] scale:1.0f];
        //Sets the boundingBox for use with DidCollide
        self.boundingBox = Vector2fMake(mainImage.imageWidth, mainImage.imageHeight);
        NSLog(@"Player: %f, %f", self.boundingBox.x, self.boundingBox.y);
		
		[shipDictionary release];
	}
	
	return self;
}

- (void)setDesiredLocation:(CGPoint)aPoint {
    desiredPosition = aPoint;
}

- (void)update:(GLfloat)delta {
    currentLocation.x += ((desiredPosition.x - currentLocation.x) / shipSpeed) * (pow(1.584893192, shipSpeed)) * delta;
    currentLocation.y += ((desiredPosition.y - currentLocation.y) / shipSpeed) * (pow(1.584893192, shipSpeed)) * delta;
    
    self.position = Vector2fMake(currentLocation.x, currentLocation.y); // Sets position for use of DidCollide
}

- (void)render {    
    [mainImage renderAtPoint:currentLocation centerOfImage:YES];
}

- (void)fireWeapons {
    
}

- (void)dealloc {
    [mainImage release];
    [super dealloc];
}

@end
