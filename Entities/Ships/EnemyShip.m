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
//
//  Last Updated - 6/23/11 @8PM - Alexander
//  - Softer caller for the filter applied when hit.
//
//  Last Updated - 6/29/11 @5PM - James
//  - Setup paths for the ships when they come in
//
//  Last Updated - 7/20/11 @4:30PM - James
//  - Added code to make the enemy 'hover' around
//  its holding position. Bounding box editable in the
//  two #defines
//
//  Last updated - 7/24/11 @2:10PM - James
//  - Made killShip lso make health zero.
//
//  Last Updated - 7/25/11 @3:15PM - James
//  - Synthesized enemyID, added isKamikazeShip method
//
//  Last Updated - 7/26/11 @2:20PM - James
//  - Fixed laoding of turrets and projectiles

#import "EnemyShip.h"

//The +- limits for how far away an enemy ship can
//stray from their respective holding points
#define HOLDING_LIMIT_X 5
#define HOLDING_LIMIT_Y 5

@implementation EnemyShip

@synthesize currentPath, currentPathType, pathTime, desiredPosition, holdingPositionPoint, powerUpDropped, enemyID;

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
        
        NSArray *shipWeaponsArray = [[NSArray alloc] initWithArray:[enemyDictionary objectForKey:@"kTurretPoints"]];
        numTurrets = [shipWeaponsArray count];
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
        
        projectilesArray = [[NSMutableArray alloc] init];
        for(int i = 0; i < numTurrets; i++) {
            //AbstractProjectile *projectile = [[AbstractProjectile alloc] initWithParticleID:kPlayerParticle fromTurretPosition:Vector2fMake(currentLocation.x + turretPoints[i].x, currentLocation.y + turretPoints[i].y) radius:10 rateOfFire:4 andAngle:90];
            AbstractProjectile *projectile = [[AbstractProjectile alloc] initWithProjectileID:kEnemyProjectile_Bullet fromTurretPosition:Vector2fMake(currentLocation.x + turretPoints[i].x, currentLocation.y + turretPoints[i].y) andAngle:-90 emissionRate:4];
            [projectile stopProjectile];
            [projectilesArray insertObject:projectile atIndex:i];
            [projectile release];
        }
        
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
    if(currentPathType != kPathType_Holding) pathTime += delta;
    
    if(currentPathType == kPathType_Holding){
        currentLocation.x += ((desiredPosition.x - currentLocation.x) / shipSpeed) * (pow(1.584893192, shipSpeed)) * delta;
        currentLocation.y += ((desiredPosition.y - currentLocation.y) / shipSpeed) * (pow(1.584893192, shipSpeed)) * delta;
        
        holdingTimer += delta;
        if(holdingTimer >= 1.00){
            holdingTimer = 0;
            desiredPosition.x = currentLocation.x + (RANDOM_MINUS_1_TO_1() * HOLDING_LIMIT_X);
            desiredPosition.y = currentLocation.y + (RANDOM_MINUS_1_TO_1() * HOLDING_LIMIT_Y);
        }
        
        //Make sure the ship doesn't fall out of it's bounds
        if(currentLocation.x < (holdingPositionPoint.x - HOLDING_LIMIT_X)) currentLocation.x = (holdingPositionPoint.x - HOLDING_LIMIT_X);
        if(currentLocation.x > (holdingPositionPoint.x + HOLDING_LIMIT_X)) currentLocation.x = (holdingPositionPoint.x + HOLDING_LIMIT_X);
        
        if(currentLocation.y < (holdingPositionPoint.y - HOLDING_LIMIT_Y)) currentLocation.y = (holdingPositionPoint.y - HOLDING_LIMIT_Y);
        if(currentLocation.y > (holdingPositionPoint.y + HOLDING_LIMIT_Y)) currentLocation.y = (holdingPositionPoint.y + HOLDING_LIMIT_Y);
    }
    
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
   
    deathAnimationEmitter.sourcePosition = Vector2fMake(currentLocation.x, currentLocation.y);
    
    if(hitFilter && hitFilterEffectTime <= 0.15) {
        hitFilterEffectTime += delta;
    }
    else {
        hitFilter = NO;
        hitFilterEffectTime = 0.0;
        [enemyAnimation setColorFilter:Color4fMake(1.0f, 1.0f, 1.0f, 1.0f)];
    }
    
    for(int i = 0; i < [projectilesArray count]; i++) {
        [[projectilesArray objectAtIndex:i] update:delta];
        [[projectilesArray objectAtIndex:i] setTurretPosition:Vector2fMake(currentLocation.x + turretPoints[i].x, currentLocation.y + turretPoints[i].y)];
    }
}

- (void)hitShipWithDamage:(int)damage {
    //When the enemy ship takes damage
    
    // Apply temporary red filter to the ship to show damage
    hitFilter = YES;
    [enemyAnimation setColorFilter:Color4fMake(1.0f, 0.8f, 0.8f, 1.0f)];
    
    shipHealth = shipHealth - damage;
    
    if(shipHealth <= 0){
        //Ship loses all health, dies.
        [self killShip];
    }
}

- (void)killShip {
    shipIsDead = TRUE;
    shipHealth = 0;
    for(AbstractProjectile *tempProjectile in projectilesArray){
        [tempProjectile stopProjectile];
    }
    [collisionPolygon setPos:CGPointMake(-500, -500)];
}

- (BOOL)isKamikazeShip {
    if(enemyID == kEnemyShip_KamikazeLevelOne ||
       enemyID == kEnemyShip_KamikazeLevelTwo ||
       enemyID == kEnemyShip_KamikazeLevelThree ||
       enemyID == kEnemyShip_KamikazeLevelFour ||
       enemyID == kEnemyShip_KamikazekBossNorthAmericaAssistOne ||
       enemyID == kEnemyShip_KamikazekBossNorthAmericaAssistTwo ||
       enemyID == kEnemyShip_KamikazekBossSouthAmericaAssist ||
       enemyID == kEnemyShip_KamikazekBossEuropeAssist ||
       enemyID == kEnemyShip_KamikazekBossAustraliaAssist ||
       enemyID == kEnemyShip_KamikazekBossAntarcticaAssist){
        return YES;
    }
    else return NO;
}

- (void)stopAllProjectiles {
    for(AbstractProjectile *enemyProj in projectilesArray){
        [enemyProj stopProjectile];
    }
}

- (void)pauseAllProjectiles {
    for(AbstractProjectile *enemyProj in projectilesArray){
        [enemyProj pauseProjectile];
    }
}

- (void)playAllProjectiles {
    for(AbstractProjectile *enemyProj in projectilesArray){
        [enemyProj playProjectile];
    }
}

- (void)render {
    for(AbstractProjectile *enemyProj in projectilesArray){
        [enemyProj render];
    }
    
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
    [enemySpriteSheet release];
    [enemyAnimation release];
    [currentPath release];
    [super dealloc];
}

@end
