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
//  Last Updated - 12/29/2010 @ 1AM - James
//  - Started using new NSArray->C Array function in Common.h
//  (Expiremental too), and full backup of old
//  code available on git & local copy on James's comp
//  if anything were to go awry.
//
//  Last Updated - 12/29/2012 @ 12:30PM - Alexander
//  - Reverted the change to the loading code that utilized the
//  newly created function by James. Was sort of confusing me
//  so I'll add it back later.
//
//  Last Updated - 12/31/2010 @11:30AM - Alexander
//  - Made it so that if DEBUG is one, it will draw lines
//  around the collision polys. Also moved the polys to be
//  a member of this class.
//
//  Last Updated - 12/31/2010 @7:30PM - Alexander
//  - Memory management: deallocate objects in dealloc method
//
//  Last Updated - 1/1/11 @9:30PM - Alexander
//  - Added shipWidth and shipHeight properties
//
//  Last Updated - 1/3/11 @4PM - Alexander
//  - Moved the polygon init code from the game scene and internalized it
//  into this [PlayerShip] class.
//
//  Last Updated - 1/3/11 @4:15PM - Alexander
//  - Removed unecessary key from PLIST "collisionPointsCount"
//  because we have all the points in an array, and thus obviously
//  know how many we have. Not needed and takes up more file space.
//
//  Last Updated - 1/26/2011 @5:20PM - Alexander
//  - Added NSMutableArray for storing our projectiles
//
//  Last Updated - 1/28/2011 *10PM - Alexander
//  - Added code for the ship to fire projectiles
//
//  Last Updated - 2/15/2011 @8:45PM - Alexander
//  - Rewrote the init method to make it just a bit more organized

#import "PlayerShip.h"


@implementation PlayerShip

@synthesize shipHealth, shipAttack, shipStamina, shipSpeed, shipTemporaryWeaponUpgrade, shipTemporaryMiscUpgrade, currentLocation, collisionDetectionBoundingPoints, collisionPointsCount, desiredPosition, collisionPolygon, shipWidth, shipHeight;

- (id) init {
	self = [super init];
	return self;
}

- (id)initWithShipID:(PlayerShipID)aShipID andInitialLocation:(CGPoint)aPoint {
	if ((self = [super init])) {
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
        mainImage = [[Image alloc] initWithImage:[shipDictionary valueForKey:@"kMainImage"] scale:1.0f];
        shipWidth = [mainImage imageWidth];
        shipHeight = [mainImage imageHeight];
        
        
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
        
        NSArray *shipTurretArray = [[NSArray alloc] initWithArray:[shipDictionary objectForKey:@"kTurretPoints"]];
        NSArray *shipThrusterArray = [[NSArray alloc] initWithArray:[shipDictionary objectForKey:@"kThrusterPoints"]];
        NSArray *shipCollisionArray = [[NSArray alloc] initWithArray:[shipDictionary objectForKey:@"kCollisionBoundingPoints"]];
        
        
		//Fill a C array with Vector2f's for our ship's turret points
        numTurrets = [shipTurretArray count];
		turretPoints = malloc(sizeof(Vector2f) * [shipTurretArray count]);
		bzero( turretPoints, sizeof(Vector2f) * [shipTurretArray count]);
        
		for (int i = 0; i < [shipTurretArray count]; i++) {
			NSArray *coords = [[shipTurretArray objectAtIndex:i] componentsSeparatedByString:@","];
			@try {
				turretPoints[i] = Vector2fMake([[coords objectAtIndex:0] intValue], [[coords objectAtIndex:1] intValue]);
			}
			@catch (NSException * e) {
				NSLog(@"Exception thrown: %@", e);
			}
			@finally {
				Vector2f vector = turretPoints[i];
				NSLog(@"Turret: %f %f", vector.x, vector.y);
			}
		}        
        
        
        //Fill a C array with Vector2f's of our ship's thruster points
        numThrusters = [shipThrusterArray count];
        thrusterPoints = malloc(sizeof(Vector2f) * [shipThrusterArray count]);
        bzero(thrusterPoints, sizeof(Vector2f) * [shipThrusterArray count]);
        
        for(int i = 0; i < [shipThrusterArray count]; i++) {
            NSArray *coords = [[NSArray alloc] initWithArray:[[shipThrusterArray objectAtIndex:i] componentsSeparatedByString:@","]];
            @try {
                thrusterPoints[i] = Vector2fMake([[coords objectAtIndex:0] intValue], [[coords objectAtIndex:1] intValue]);
            }
            @catch (NSException * e) {
                NSLog(@"Exception thrown: %@", e);
            }
            @finally {
                Vector2f vector = thrusterPoints[i];
				NSLog(@"Thruster: %f %f", vector.x, vector.y);
            }
            [coords release];
        }        
        
        
        //Fill a C array with Vector2f's of our ship's collision detection bounding points
        collisionPointsCount = [shipCollisionArray count];
        collisionDetectionBoundingPoints = malloc(sizeof(Vector2f) * [shipCollisionArray count]);
        bzero(collisionDetectionBoundingPoints, sizeof(Vector2f) * [shipCollisionArray count]);
        
        for(int i = 0; i < [shipCollisionArray count]; i++) {
            NSArray *coords = [[NSArray alloc] initWithArray:[[shipCollisionArray objectAtIndex:i] componentsSeparatedByString:@","]];
            @try {
                collisionDetectionBoundingPoints[i] = Vector2fMake([[coords objectAtIndex:0] intValue], [[coords objectAtIndex:1] intValue]);
            }
            @catch (NSException * e) {
                NSLog(@"Exception thrown: %@", e);
            }
            @finally {
                Vector2f vector = collisionDetectionBoundingPoints[i];
                NSLog(@"Collision Point: %f %f", vector.x, vector.y);
            }
            [coords release];
        }        
        
        
        //Allocate our polygon, for use in collision detection.
        collisionPolygon = [[Polygon alloc] initWithPoints:collisionDetectionBoundingPoints andCount:collisionPointsCount andShipPos:currentLocation];        
        
        // Add projectiles to our local projectile set for the weapon points on the ship
        projectilesArray = [[NSMutableArray alloc] init];
        for(int i = 0; i < numTurrets; i++) {
            AbstractProjectile *projectile = [[AbstractProjectile alloc] initWithParticleID:kPlayerParticle fromTurretPosition:Vector2fMake(currentLocation.x + turretPoints[i].x, currentLocation.y + turretPoints[i].y) radius:10 rateOfFire:4 andAngle:90];
            [projectilesArray insertObject:projectile atIndex:i];
            [projectile release];
        }
        
        
        [shipTurretArray release];
        [shipThrusterArray release];
        [shipCollisionArray release];
        [shipDictionary release];
	}
    
	return self;
}

- (void)setDesiredLocation:(CGPoint)aPoint {
    //Named desired because the ship will not move as fast as the user inputs, we implement drag
    desiredPosition = aPoint;
}

- (void)update:(GLfloat)delta {
    currentLocation.x += ((desiredPosition.x - currentLocation.x) / shipSpeed) * (pow(1.584893192, shipSpeed)) * delta;
    currentLocation.y += ((desiredPosition.y - currentLocation.y) / shipSpeed) * (pow(1.584893192, shipSpeed)) * delta;
    
    //Update the points for our polygon
    [collisionPolygon setPos:currentLocation];
    
    // Update all of our projectiles
    for(int i = 0; i < [projectilesArray count]; i++) {
        [[projectilesArray objectAtIndex:i] update:delta];
        [[projectilesArray objectAtIndex:i] setTurretPosition:Vector2fMake(currentLocation.x + turretPoints[i].x, currentLocation.y + turretPoints[i].y)];
    }
}

- (void)render {    
    [mainImage renderAtPoint:currentLocation centerOfImage:YES];
    
    // Render projectiles
    for(int i = 0; i < [projectilesArray count]; i++) {
        [[projectilesArray objectAtIndex:i] render];
    }
    
    // For DEBUGging collisions
    if(DEBUG) {                
        glPushMatrix();
        
        glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
        
        //Loop through the all the lines except for the last
        for(int i = 0; i < (collisionPointsCount - 1); i++) {
            GLfloat line[] = {
                collisionPolygon.points[i].x, collisionPolygon.points[i].y,
                collisionPolygon.points[i+1].x, collisionPolygon.points[i+1].y,
            };
            
            glVertexPointer(2, GL_FLOAT, 0, line);
            glEnableClientState(GL_VERTEX_ARRAY);
            glDrawArrays(GL_LINES, 0, 2);
        }
        
        
        //Renders last line, we do this because of how arrays work.
        GLfloat lineEnd[] = {
            collisionPolygon.points[(collisionPointsCount - 1)].x, collisionPolygon.points[(collisionPointsCount - 1)].y,
            collisionPolygon.points[0].x, collisionPolygon.points[0].y,
        };
        
        glVertexPointer(2, GL_FLOAT, 0, lineEnd);
        glEnableClientState(GL_VERTEX_ARRAY);
        glDrawArrays(GL_LINES, 0, 2);
        
        glPopMatrix();
    }
}

- (void)fireWeapons {
    
}

- (void)shipWasHitWithProjectile:(AbstractProjectile *)projectile {
    
}

- (void)destroyShip {
    
}

- (void)dealloc {
    free(collisionDetectionBoundingPoints);
    [Image release];
    [collisionPolygon release];
    free(turretPoints);
    free(thrusterPoints);
    [super dealloc];
}

@end
