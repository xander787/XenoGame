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

#import "EnemyShip.h"


@implementation EnemyShip

@synthesize enemyHealth, enemyAttack, enemyStamina, enemySpeed, currentLocation, shipWidth, shipHeight;

- (id)init {
    self = [super init];
    return self;
}

- (id)initWithShipID:(EnemyShipID)aEnemyID initialLocation:(CGPoint)aPoint andPlayerShipRef:(PlayerShip *)aPlayership {
    if(self = [super init]) {
        enemyID = aEnemyID;
        currentLocation = aPoint;
        self.position = Vector2fMake(currentLocation.x, currentLocation.y); // Sets position for DidCollide use
        playerShipRef = aPlayership;
        
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
                enemyDictionary = [[NSMutableDictionary alloc] initWithDictionary:[enemyShipsDictionary objectForKey:@"kKamikaze_Four"]];
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
        enemyHealth = 100; 
        enemyAttack = [[enemyDictionary valueForKey:@"kShipAttack"] intValue];
        enemyStamina = [[enemyDictionary valueForKey:@"kShipStamina"] intValue];
        enemySpeed = [[enemyDictionary valueForKey:@"kShipSpeed"] intValue];
        
        if([enemyDictionary valueForKey:@"kShipCategory"] == @"kShipType_OneShot") {
            enemyCategroy = kEnemyCategory_OneShot;
        }
        else if([enemyDictionary valueForKey:@"kShipCategory"] == @"kShipType_TwoShot") {
            enemyCategroy = kEnemyCategory_TwoShot;
        }
        else if([enemyDictionary valueForKey:@"kShipCategory"] == @"kShipType_ThreeShot") {
            enemyCategroy = kEnemyCategory_ThreeShot;
        }
        else if([enemyDictionary valueForKey:@"kShipCategory"] == @"kShipType_WaveShot") {
            enemyCategroy = kEnemyCategory_WaveShot;
        }
        else if([enemyDictionary valueForKey:@"kShipCategory"] == @"kShipType_MissileBombShot") {
            enemyCategroy = kEnemyCategory_MissileBombShot;
        }
        else if([enemyDictionary valueForKey:@"kShipCategory"] == @"kShipType_Kamikaze") {
            enemyCategroy = kEnemyCategory_Kamikaze;
        }
        
        //Fill a C array with the weapon points on the enemy
        NSArray *weaponsArray = [[NSArray alloc] initWithArray:[enemyDictionary objectForKey:@"kWeaponPoints"]];
        weaponPoints = malloc(sizeof(Vector2f) * [weaponsArray count]);
        bzero(weaponPoints, sizeof(Vector2f) * [weaponsArray count]);
        
        for(int i =0; i < [weaponsArray count]; i++) {
            NSArray *coords = [[NSArray alloc] initWithArray:[[weaponsArray objectAtIndex:i] componentsSeparatedByString:@","]];
            weaponPoints[i] = Vector2fMake([[coords objectAtIndex:0] intValue], [[coords objectAtIndex:1] intValue]);
            [coords release];
        }
        [weaponsArray release];
        
        //Fill a C array with the collision bounding points from the enemy
        NSArray *collisionArray = [[NSArray alloc] initWithArray:[enemyDictionary objectForKey:@"kCollisionBoundingPoints"]];
        collisionDetectionBoundingPoints = malloc(sizeof(Vector2f) * [collisionArray count]);
        bzero(collisionDetectionBoundingPoints, sizeof(Vector2f) * [collisionArray count]);
        
        for(int i = 0; i < [collisionArray count]; i++) {
            NSArray *coords = [[NSArray alloc] initWithArray:[[collisionArray objectAtIndex:i] componentsSeparatedByString:@","]];
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
        [collisionArray release];
        
        Image *spriteSheetImage = [[Image alloc] initWithImage:[enemyDictionary valueForKey:@"kShipSpriteSheet"] scale:1.0f];
        enemySpriteSheet = [[SpriteSheet alloc] initWithImage:spriteSheetImage 
                                                  spriteWidth:[[enemyDictionary valueForKey:@"kSpriteSheetColumnWidth"] intValue]
                                                 spriteHeight:[[enemyDictionary valueForKey:@"kSpriteSheetRowHeight"] intValue]
                                                      spacing:0];
        [spriteSheetImage release];
        
        //Sets boundingBox for use with DidCollide
        self.boundingBox = Vector2fMake([[enemyDictionary valueForKey:@"kSpriteSheetColumnWidth"] intValue], [[enemyDictionary valueForKey:@"kSpriteSheetRowHeight"] intValue]);
        
        shipWidth = [[enemyDictionary valueForKey:@"kSpriteSheetColumnWidth"] intValue];
        shipHeight = [[enemyDictionary valueForKey:@"kSpriteSheetRowheight"] intValue];
        
        NSLog(@"Enemy: %f, %f", self.boundingBox.x, self.boundingBox.y);
        
        enemyAnimation = [[Animation alloc] init];
        for(int i = 0; i < [[enemyDictionary valueForKey:@"kSpriteSheetNumColumns"] intValue]; i++) {
            [enemyAnimation addFrameWithImage:[enemySpriteSheet getSpriteAtX:i y:0] delay:0.05];
        }
        [enemyAnimation setRunning:YES];
        [enemyAnimation setRepeat:YES];
        
        [enemyDictionary release];
    }
    
    return self;
}

- (void)update:(GLfloat)delta {
    [enemyAnimation update:delta];
}

- (void)render {
    [enemyAnimation renderAtPoint:currentLocation];
}

- (void)dealloc {
    free(weaponPoints);
    free(collisionDetectionBoundingPoints);
    [enemySpriteSheet release];
    [enemyAnimation release];
    [playerShipRef release];
    [super dealloc];
}

@end
