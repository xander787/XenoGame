//
//  EnemyShip.m
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
//  Last Updated - 11/25/10 @8PM - Alexander
//  - Forgot to add properties for the public items
//
//  Last Updated - 12/17/10 @6PM - James
//  - Assigned correct width and height measurements
//  to the boundingBox variable, derived from
//  the GameObject class.
//
//  Last Updated - 12/29/10 @12AM - Alexander
//  - Added in code to load collision bounding points 
//  from PLIST file.
//
//  Last Updated - 12/31/1010 @11AM - Alexander
//  - Playing with the spritesheet timer
//
//  Last Updated - 12/31/2010 @7:30PM - Alexander
//  - Memory management: Added dealloc method and put
//  our deallocations in it.
//
//  Last Updated - 1/1/11 @9:30PM - Alexander
//  - Added shipWidth and shipHeight properties
//
//  Last Updated - 2/15/11 @9PM - Alexander
//  - Rewrote the init method to be more organized
//
//	Last Updated - 6/15/2011 @ 3:30PM - Alexander
//	- Support for new Scale2f vector scaling system
//
//  Last Updated - 6/16/2011 @8:15PM - James
//  - Added simple health logic, death animation.
//
//  Last Updated - 6/23/2011 @ 4:40PM - James
//  - Added killShip method, moved death emitter init
//  to regular init for less lag, made sure there's no
//  more polygon after death
//
//  Last Updated - 6/23/11 @8PM - Alexander
//  - Enemy ship now adds red filter when hit
//
//  Last Updated - 6/23/11 @8PM - Alexander
//  - Fixed the timing for the red filter. Looks good now.

#import "EnemyShip.h"


@implementation EnemyShip


- (id)init {
    self = [super init];
    return self;
}

- (id)initWithShipID:(EnemyShipID)aEnemyID initialLocation:(CGPoint)aPoint andPlayerShipRef:(PlayerShip *)aPlayership {
    if((self = [super init])) {
        enemyID = aEnemyID;
        currentLocation = aPoint;
        self.position = Vector2fMake(currentLocation.x, currentLocation.y); // Sets position for DidCollide use
        playerShipRef = aPlayership;
        hitFilter = NO;
        hitFilterEffectTime = 0.0;
        
        //Load the PLIST with all enemy ship definitions in them
		NSBundle *bundle = [NSBundle mainBundle];
		NSString *path = [[NSString alloc] initWithString:[bundle pathForResource:@"EnemyShips" ofType:@"plist"]];
		NSMutableDictionary *enemyShipsDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
		NSMutableDictionary *enemyDictionary;
		[bundle release];
		[path release];
        
        switch (enemyID) {
			case kEnemyShip_OneShotLevelOne:
				enemyDictionary = [[NSMutableDictionary alloc] initWithDictionary:[enemyShipsDictionary objectForKey:@"kShipOneShot_One"]];
				break;
            case kEnemyShip_OneShotLevelTwo:
                enemyDictionary = [[NSMutableDictionary alloc] initWithDictionary:[enemyShipsDictionary objectForKey:@"kShipOneShot_Two"]];
                break;
            case kEnemyShip_OneShotLevelThree:
                enemyDictionary = [[NSMutableDictionary alloc] initWithDictionary:[enemyShipsDictionary objectForKey:@"kShipOneShot_Three"]];
                break;
            case kEnemyShip_OneShotLevelFour:
                enemyDictionary = [[NSMutableDictionary alloc] initWithDictionary:[enemyShipsDictionary objectForKey:@"kShipOneShot_Four"]];
                break;
            case kEnemyShip_OneShotLevelFive:
                enemyDictionary = [[NSMutableDictionary alloc] initWithDictionary:[enemyShipsDictionary objectForKey:@"kShipOneShot_Five"]];
                break;
            case kEnemyShip_OneShotLevelSix:
                enemyDictionary = [[NSMutableDictionary alloc] initWithDictionary:[enemyShipsDictionary objectForKey:@"kShipOneShot_Six"]];
                break;
            case kEnemyShip_TwoShotLevelOne:
                enemyDictionary = [[NSMutableDictionary alloc] initWithDictionary:[enemyShipsDictionary objectForKey:@"kShipTwoShot_One"]];
                break;
            case kEnemyShip_TwoShotLevelTwo:
                enemyDictionary = [[NSMutableDictionary alloc] initWithDictionary:[enemyShipsDictionary objectForKey:@"kShipTwoShot_Two"]];
                break;
            case kEnemyShip_TwoShotLevelThree:
                enemyDictionary = [[NSMutableDictionary alloc] initWithDictionary:[enemyShipsDictionary objectForKey:@"kShipTwoShot_Three"]];
                break;
            case kEnemyShip_TwoShotLevelFour:
                enemyDictionary = [[NSMutableDictionary alloc] initWithDictionary:[enemyShipsDictionary objectForKey:@"kShipTwoShot_Four"]];
                break;
            case kEnemyShip_TwoShotLevelFive:
                enemyDictionary = [[NSMutableDictionary alloc] initWithDictionary:[enemyShipsDictionary objectForKey:@"kShipTwoShot_Five"]];
                break;
            case kEnemyShip_TwoShotLevelSix:
                enemyDictionary = [[NSMutableDictionary alloc] initWithDictionary:[enemyShipsDictionary objectForKey:@"kShipTwoShot_Six"]];
                break;
            case kEnemyShip_TwoShotLevelSeven:
                enemyDictionary = [[NSMutableDictionary alloc] initWithDictionary:[enemyShipsDictionary objectForKey:@"kShipTwoShot_Seven"]];
                break;
            case kEnemyShip_TwoShotkBossAfricaAssistOne:
                enemyDictionary = [[NSMutableDictionary alloc] initWithDictionary:[enemyShipsDictionary objectForKey:@"kShipTwoShot_BossOne"]];
                break;
            case kEnemyShip_TwoShotkBossAfricaAssistTwo:
                enemyDictionary = [[NSMutableDictionary alloc] initWithDictionary:[enemyShipsDictionary objectForKey:@"kShipTwoShot_BossTwo"]];
                break;
            case kEnemyShip_TwoShotkBossAsiaAssist:
                enemyDictionary = [[NSMutableDictionary alloc] initWithDictionary:[enemyShipsDictionary objectForKey:@"kShipTwoShot_BossThree"]];
                break;
            case kEnemyShip_ThreeShotLevelOne:
                enemyDictionary = [[NSMutableDictionary alloc] initWithDictionary:[enemyShipsDictionary objectForKey:@"kShipThreeShot_One"]];
                break;
            case kEnemyShip_ThreeShotLevelTwo:
                enemyDictionary = [[NSMutableDictionary alloc] initWithDictionary:[enemyShipsDictionary objectForKey:@"kShipThreeShot_Two"]];
                break;
            case kEnemyShip_ThreeShotLevelThree:
                enemyDictionary = [[NSMutableDictionary alloc] initWithDictionary:[enemyShipsDictionary objectForKey:@"kShipThreeShot_Three"]];
                break;
            case kEnemyShip_ThreeShotLevelFour:
                enemyDictionary = [[NSMutableDictionary alloc] initWithDictionary:[enemyShipsDictionary objectForKey:@"kShipThreeShot_Four"]];
                break;
            case kEnemyShip_ThreeShotLevelFive:
                enemyDictionary = [[NSMutableDictionary alloc] initWithDictionary:[enemyShipsDictionary objectForKey:@"kShipThreeShot_Five"]];
                break;
            case kEnemyShip_ThreeShotkBossAsiaAssist:
                enemyDictionary = [[NSMutableDictionary alloc] initWithDictionary:[enemyShipsDictionary objectForKey:@"kShipThreeShot_BossOne"]];
                break;
            case kEnemyShip_WaveShotLevelOne:
                enemyDictionary = [[NSMutableDictionary alloc] initWithDictionary:[enemyShipsDictionary objectForKey:@"kShipWaveShot_One"]];
                break;
            case kEnemyShip_WaveShotLevelTwo:
                enemyDictionary = [[NSMutableDictionary alloc] initWithDictionary:[enemyShipsDictionary objectForKey:@"kShipWaveShot_Two"]];
                break;
            case kEnemyShip_WaveShotLevelThree:
                enemyDictionary = [[NSMutableDictionary alloc] initWithDictionary:[enemyShipsDictionary objectForKey:@"kShipWaveShot_Three"]];
                break;
            case kEnemyShip_WaveShotLevelFour:
                enemyDictionary = [[NSMutableDictionary alloc] initWithDictionary:[enemyShipsDictionary objectForKey:@"kShipWaveShot_Four"]];
                break;
            case kEnemyShip_WaveShotLevelFive:
                enemyDictionary = [[NSMutableDictionary alloc] initWithDictionary:[enemyShipsDictionary objectForKey:@"kShipWaveShot_Five"]];
                break;
            case kEnemyShip_WaveShotkBossAntarcticaAssist:
                enemyDictionary = [[NSMutableDictionary alloc] initWithDictionary:[enemyShipsDictionary objectForKey:@"kShipWaveShot_BossOne"]];
                break;
            case kEnemyShip_MissileBombShotLevelOne:
                enemyDictionary = [[NSMutableDictionary alloc] initWithDictionary:[enemyShipsDictionary objectForKey:@"kShipMissileBombShot_One"]];
                break;
            case kEnemyShip_MissileBombShotLevelTwo:
                enemyDictionary = [[NSMutableDictionary alloc] initWithDictionary:[enemyShipsDictionary objectForKey:@"kShipMissileBombShot_Two"]];
                break;
            case kEnemyShip_MissileBombShotLevelThree:
                enemyDictionary = [[NSMutableDictionary alloc] initWithDictionary:[enemyShipsDictionary objectForKey:@"kShipMissileBombShot_Three"]];
                break;
            case kEnemyShip_MissileBombShotLevelFive:
                enemyDictionary = [[NSMutableDictionary alloc] initWithDictionary:[enemyShipsDictionary objectForKey:@"kShipMissileBombShot_Four"]];
                break;
            case kEnemyShip_MissileBombShotkBossSouthAmericaAssist:
                enemyDictionary = [[NSMutableDictionary alloc] initWithDictionary:[enemyShipsDictionary objectForKey:@"kShipMissileBombShot_BossOne"]];
                break;
            case kEnemyShip_MissileBombShotkBossEuropeAssist:
                enemyDictionary = [[NSMutableDictionary alloc] initWithDictionary:[enemyShipsDictionary objectForKey:@"kShipMissileBombShot_BossTwo"]];
                break;
            case kEnemyShip_MissileBombShotkBossAustraliaAssist:
                enemyDictionary = [[NSMutableDictionary alloc] initWithDictionary:[enemyShipsDictionary objectForKey:@"kShipMissileBombShot_BossThree"]];
                break;
            case kEnemyShip_KamikazeLevelOne:
                enemyDictionary = [[NSMutableDictionary alloc] initWithDictionary:[enemyShipsDictionary objectForKey:@"kShipKamikaze_One"]];
                break;
            case kEnemyShip_KamikazeLevelTwo:
                enemyDictionary = [[NSMutableDictionary alloc] initWithDictionary:[enemyShipsDictionary objectForKey:@"kShipKamikaze_Two"]];
                break;
            case kEnemyShip_KamikazeLevelThree:
                enemyDictionary = [[NSMutableDictionary alloc] initWithDictionary:[enemyShipsDictionary objectForKey:@"kShipKamikaze_Three"]];
                break;
            case kEnemyShip_KamikazeLevelFour:
                enemyDictionary = [[NSMutableDictionary alloc] initWithDictionary:[enemyShipsDictionary objectForKey:@"kShipKamikaze_Four"]];
                break;
            case kEnemyShip_KamikazekBossNorthAmericaAssistOne:
                enemyDictionary = [[NSMutableDictionary alloc] initWithDictionary:[enemyShipsDictionary objectForKey:@"kShipKamikaze_BossOne"]];
                break;
            case kEnemyShip_KamikazekBossNorthAmericaAssistTwo:
                enemyDictionary = [[NSMutableDictionary alloc] initWithDictionary:[enemyShipsDictionary objectForKey:@"kShipKamikaze_BossTwo"]];
                break;
            case kEnemyShip_KamikazekBossSouthAmericaAssist:
                enemyDictionary = [[NSMutableDictionary alloc] initWithDictionary:[enemyShipsDictionary objectForKey:@"kShipKamikaze_BossThree"]];
                break;
            case kEnemyShip_KamikazekBossEuropeAssist:
                enemyDictionary = [[NSMutableDictionary alloc] initWithDictionary:[enemyShipsDictionary objectForKey:@"kShipKamikaze_BossFour"]];
                break;
            case kEnemyShip_KamikazekBossAustraliaAssist:
                enemyDictionary = [[NSMutableDictionary alloc] initWithDictionary:[enemyShipsDictionary objectForKey:@"kShipKamikaze_BossFive"]];
                break;
            case kEnemyShip_KamikazekBossAntarcticaAssist:
                enemyDictionary = [[NSMutableDictionary alloc] initWithDictionary:[enemyShipsDictionary objectForKey:@"kShipKamikaze_BossSix"]];
                break;
			default:
				break;
		}
        
        [enemyShipsDictionary release];
        
        //Set the values for the ship based on those in the plist file
        shipMaxHealth = 300;
        shipHealth = shipMaxHealth; 
        shipAttack = [[enemyDictionary valueForKey:@"kShipAttack"] intValue];
        shipStamina = [[enemyDictionary valueForKey:@"kShipStamina"] intValue];
        shipSpeed = [[enemyDictionary valueForKey:@"kShipSpeed"] intValue];
        shipWidth = [[enemyDictionary valueForKey:@"kSpriteSheetColumnWidth"] intValue];
        shipHeight = [[enemyDictionary valueForKey:@"kSpriteSheetRowheight"] intValue];
        
        
        if([enemyDictionary valueForKey:@"kShipCategory"] == @"kShipType_OneShot") {
            enemyCategory = kEnemyCategory_OneShot;
        }
        else if([enemyDictionary valueForKey:@"kShipCategory"] == @"kShipType_TwoShot") {
            enemyCategory = kEnemyCategory_TwoShot;
        }
        else if([enemyDictionary valueForKey:@"kShipCategory"] == @"kShipType_ThreeShot") {
            enemyCategory = kEnemyCategory_ThreeShot;
        }
        else if([enemyDictionary valueForKey:@"kShipCategory"] == @"kShipType_WaveShot") {
            enemyCategory = kEnemyCategory_WaveShot;
        }
        else if([enemyDictionary valueForKey:@"kShipCategory"] == @"kShipType_MissileBombShot") {
            enemyCategory = kEnemyCategory_MissileBombShot;
        }
        else if([enemyDictionary valueForKey:@"kShipCategory"] == @"kShipType_Kamikaze") {
            enemyCategory = kEnemyCategory_Kamikaze;
        }
        
        NSArray *shipWeaponsArray = [[NSArray alloc] initWithArray:[enemyDictionary objectForKey:@"kWeaponPoints"]];
        NSArray *shipCollisionArray = [[NSArray alloc] initWithArray:[enemyDictionary objectForKey:@"kCollisionBoundingPoints"]];
        
        //Fill a C array with the weapon points on the enemy
        turretPoints = malloc(sizeof(Vector2f) * [shipWeaponsArray count]);
        bzero(turretPoints, sizeof(Vector2f) * [shipWeaponsArray count]);
        
        for(int i =0; i < [shipWeaponsArray count]; i++) {
            NSArray *coords = [[NSArray alloc] initWithArray:[[shipWeaponsArray objectAtIndex:i] componentsSeparatedByString:@","]];
            turretPoints[i] = Vector2fMake([[coords objectAtIndex:0] intValue], [[coords objectAtIndex:1] intValue]);
            [coords release];
        }
        
        
        //Fill a C array with the collision bounding points from the enemy
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
        
        // Load collision polygon for ship
        collisionPolygon = [[Polygon alloc] initWithPoints:collisionDetectionBoundingPoints andCount:collisionPointsCount andShipPos:currentLocation];
        
        
        // Load images from spritesheet
        Image *spriteSheetImage = [[Image alloc] initWithImage:[enemyDictionary valueForKey:@"kShipSpriteSheet"] scale:Scale2fOne];
        enemySpriteSheet = [[SpriteSheet alloc] initWithImage:spriteSheetImage 
                                                  spriteWidth:[[enemyDictionary valueForKey:@"kSpriteSheetColumnWidth"] intValue]
                                                 spriteHeight:[[enemyDictionary valueForKey:@"kSpriteSheetRowHeight"] intValue]
                                                      spacing:0];
        [spriteSheetImage release];
        
        
        // Load animation for the sprites
        enemyAnimation = [[Animation alloc] init];
        for(int i = 0; i < [[enemyDictionary valueForKey:@"kSpriteSheetNumColumns"] intValue]; i++) {
            [enemyAnimation addFrameWithImage:[enemySpriteSheet getSpriteAtX:i y:0] delay:0.05];
        }
        [enemyAnimation setRunning:YES];
        [enemyAnimation setRepeat:YES];
        
        [enemyDictionary release];
        
        [shipWeaponsArray release];
        [shipCollisionArray release];
        
        //Death animation emitter:
        
        deathAnimationEmitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
                                                                                  position:Vector2fMake(currentLocation.x, currentLocation.y)
                                                                    sourcePositionVariance:Vector2fZero
                                                                                     speed:0.5
                                                                             speedVariance:0.2
                                                                          particleLifeSpan:0.2
                                                                  particleLifespanVariance:0.1
                                                                                     angle:0.0
                                                                             angleVariance:360.0
                                                                                   gravity:Vector2fZero
                                                                                startColor:Color4fMake(0.7, 0.3, 0.3, 1.0)
                                                                        startColorVariance:Color4fMake(0.3, 0.3, 0.3, 0.0)
                                                                               finishColor:Color4fMake(0.7, 0.3, 0.3, 0.2)
                                                                       finishColorVariance:Color4fMake(0.3, 0.3, 0.3, 0.0)
                                                                              maxParticles:1000
                                                                              particleSize:7.0
                                                                        finishParticleSize:7.0
                                                                      particleSizeVariance:0.0
                                                                                  duration:0.1
                                                                             blendAdditive:YES];
        deathAnimationEmitter.fastEmission = YES;
    }
    
    return self;
}

- (void)update:(GLfloat)delta {
    [enemyAnimation update:delta];
    
    if(!shipIsDead){
        //If it is dead it get moved off screen so save cpu time on collisions
        [collisionPolygon setPos:currentLocation];
    }
    
    if(shipIsDead == TRUE){
        [deathAnimationEmitter update:delta];
        if(deathAnimationEmitter.particleCount == 0){
            //Tell owner that emitter is done, okay to dealloc
            
        }
    }
    
    if(hitFilter && hitFilterEffectTime <= 0.15) {
        hitFilterEffectTime += delta;
    }
    else {
        hitFilter = NO;
        hitFilterEffectTime = 0.0;
        [enemyAnimation setColorFilter:Color4fMake(1.0f, 1.0f, 1.0f, 1.0f)];
    }
}

- (void)hitShipWithDamage:(int)damage {
    //When the enemy ship takes damage
    
    // Apply temporary red filter to the ship to show damage
    hitFilter = YES;
    [enemyAnimation setColorFilter:Color4fMake(0.8f, 0.5f, 0.5f, 1.0f)];
    
    shipHealth = shipHealth - damage;
    
    if(shipHealth <= 0){
        //Ship loses all health, dies.
        [self killShip];
    }
}

- (void)killShip {
    shipIsDead = TRUE;
    
    for(AbstractProjectile *tempProjectile in projectilesArray){
        [tempProjectile stopProjectile];
    }
    [collisionPolygon setPos:CGPointMake(-500, -500)];
}

- (void)render {
    if(shipIsDead == FALSE){
        [enemyAnimation renderAtPoint:currentLocation];
    }
    
    if(shipIsDead == TRUE){
        [deathAnimationEmitter renderParticles];
    }
    
    
    if(DEBUG) {                
        glPushMatrix();
        
        glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
        
        
        for(int i = 0; i < (collisionPointsCount - 1); i++) {
            GLfloat line[] = {
                collisionPolygon.points[i].x, collisionPolygon.points[i].y,
                collisionPolygon.points[i+1].x, collisionPolygon.points[i+1].y,
            };
            
            glVertexPointer(2, GL_FLOAT, 0, line);
            glEnableClientState(GL_VERTEX_ARRAY);
            glDrawArrays(GL_LINES, 0, 2);
        }
        
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

- (void)dealloc {
    free(turretPoints);
    free(collisionDetectionBoundingPoints);
    [enemySpriteSheet release];
    [enemyAnimation release];
    [playerShipRef release];
    if(collisionPolygon){
        [collisionPolygon release];
    }
    [super dealloc];
}

@end
