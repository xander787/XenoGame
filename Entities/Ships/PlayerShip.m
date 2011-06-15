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
//
//  Last Updated - 6/13/2011 @ 4:40PM - James
//  - Added in death animation, basic health system. Ship
//  images stops rendering on deaht, too.
//
//  Last Updated - 6/13/2011 @5:50PM - James
//  - Cleaned up a bit of code, removing NSLogs and all.
//  On death all projectiles also cease firing and rendering

#import "PlayerShip.h"


@implementation PlayerShip

@synthesize shipTemporaryWeaponUpgrade, shipTemporaryMiscUpgrade, desiredPosition;

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
		shipMaxHealth = 300;
        shipHealth = shipMaxHealth;
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
            //AbstractProjectile *projectile = [[AbstractProjectile alloc] initWithProjectileID:kPlayerProjectile_Bullet fromTurretPosition:Vector2fMake(currentLocation.x + turretPoints[i].x, currentLocation.y + turretPoints[i].y) andAngle:90 emissionRate:4];
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
    
    if(shipIsDead == TRUE){
        [deathAnimationEmitter update:delta];
        if(deathAnimationEmitter.particleCount == 0){
            //When the emitter is done, no more particles:
            
        }
    }
}

- (void)hitShipWithDamage:(int)damage {
    //NSLog(@"Player Ship takes damage with %d damage", damage);
    
    //Deduct damage from existing health
    shipHealth = shipHealth - damage;
    //NSLog(@"New ship health: %d", shipHealth);
    
    if(shipHealth <= 0){
        
        NSLog(@"Player Ship died");
        //Player ship is offically dead
        shipIsDead = TRUE;
        
        for(AbstractProjectile *tempProjectile in projectilesArray){
            [tempProjectile stopProjectile];
        }
        
        //TODO: Remove image, start particle death animation, etc
        
        deathAnimationEmitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
                                                                                  position:Vector2fMake(currentLocation.x, currentLocation.y)
                                                                    sourcePositionVariance:Vector2fZero
                                                                                     speed:0.8
                                                                             speedVariance:0.2
                                                                          particleLifeSpan:0.3
                                                                  particleLifespanVariance:0.2
                                                                                     angle:0.0
                                                                             angleVariance:360.0
                                                                                   gravity:Vector2fZero
                                                                                startColor:Color4fMake(0.7, 0.7, 0.7, 1.0)
                                                                        startColorVariance:Color4fMake(0.5, 0.5, 0.5, 0.0)
                                                                               finishColor:Color4fMake(0.7, 0.7, 0.7, 0.2)
                                                                       finishColorVariance:Color4fMake(0.5, 0.5, 0.5, 0.0)
                                                                              maxParticles:1000
                                                                              particleSize:10.0
                                                                        finishParticleSize:10.0
                                                                      particleSizeVariance:0.0
                                                                                  duration:0.1
                                                                             blendAdditive:YES];
        deathAnimationEmitter.fastEmission = YES;
    }
}

- (void)render {    
    if(shipIsDead == FALSE){
        //Only render if ship is alive, else do not draw for the particle animation
        [mainImage renderAtPoint:currentLocation centerOfImage:YES];
    }
    if(shipIsDead == TRUE){
        //Make sure to *start* rendering our emitter!
        [deathAnimationEmitter renderParticles];
    }
        
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
    if(deathAnimationEmitter){
        [deathAnimationEmitter release];
    }
    [projectilesArray release];
    [collisionPolygon release];
    free(turretPoints);
    free(thrusterPoints);
    [super dealloc];
}

@end
