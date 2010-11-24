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


#import "EnemyShip.h"


@implementation EnemyShip

- (id)init {
    self = [super init];
    return self;
}

- (id)initWithShipID:(EnemyShipID)aEnemyID initialLocation:(CGPoint)aPoint andPlayerShipRef:(PlayerShip *)aPlayership {
    if(self = [super init]) {
        enemyID = aEnemyID;
        currentLocation = aPoint;
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
            case kEnemyShip_TwoShotBossAssistLevelOne:
                enemyDictionary = [[NSMutableDictionary alloc] initWithDictionary:[enemyShipsDictionary objectForKey:@"kShipTwoShot_BossOne"]];
                break;
            case kEnemyShip_TwoShotBossAssistLevelTwo:
                enemyDictionary = [[NSMutableDictionary alloc] initWithDictionary:[enemyShipsDictionary objectForKey:@"kShipTwoShot_BossTwo"]];
                break;
            case kEnemyShip_TwoShotBossAssistLevelThree:
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
            case kEnemyShip_ThreeShotBossAssistLevelOne:
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
            case kEnemyShip_WaveShotBossAssistLevelOne:
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
            case kEnemyShip_MissileBombShotBossAssistLevelOne:
                enemyDictionary = [[NSMutableDictionary alloc] initWithDictionary:[enemyShipsDictionary objectForKey:@"kShipMissileBombShot_BossOne"]];
                break;
            case kEnemyShip_MissileBombShotBossAssistLevelTwo:
                enemyDictionary = [[NSMutableDictionary alloc] initWithDictionary:[enemyShipsDictionary objectForKey:@"kShipMissileBombShot_BossTwo"]];
                break;
            case kEnemyShip_MissileBombShotBossAssistLevelThree:
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
            case kEnemyShip_KamikazeBossAssistLevelOne:
                enemyDictionary = [[NSMutableDictionary alloc] initWithDictionary:[enemyShipsDictionary objectForKey:@"kShipKamikaze_BossOne"]];
                break;
            case kEnemyShip_KamikazeBossAssistLevelTwo:
                enemyDictionary = [[NSMutableDictionary alloc] initWithDictionary:[enemyShipsDictionary objectForKey:@"kShipKamikaze_BossTwo"]];
                break;
            case kEnemyShip_KamikazeBossAssistLevelThree:
                enemyDictionary = [[NSMutableDictionary alloc] initWithDictionary:[enemyShipsDictionary objectForKey:@"kShipKamikaze_BossThree"]];
                break;
            case kEnemyShip_KamikazeBossAssistLevelFour:
                enemyDictionary = [[NSMutableDictionary alloc] initWithDictionary:[enemyShipsDictionary objectForKey:@"kShipKamikaze_BossFour"]];
                break;
            case kEnemyShip_KamikazeBossAssistLevelFive:
                enemyDictionary = [[NSMutableDictionary alloc] initWithDictionary:[enemyShipsDictionary objectForKey:@"kShipKamikaze_BossFive"]];
                break;
            case kEnemyShip_KamikazeBossAssistLevelSix:
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
        
        Image *spriteSheetImage = [[Image alloc] initWithImage:[enemyDictionary valueForKey:@"kShipSpriteSheet"] scale:1.0f];
        enemySpriteSheet = [[SpriteSheet alloc] initWithImage:spriteSheetImage 
                                                  spriteWidth:[[enemyDictionary valueForKey:@"kSpriteSheetColumnWidth"] intValue]
                                                 spriteHeight:[[enemyDictionary valueForKey:@"kSpriteSheetRowHeight"] intValue]
                                                      spacing:0];
        [spriteSheetImage release];
        
        enemyAnimation = [[Animation alloc] init];
        for(int i = 0; i < [[enemyDictionary valueForKey:@"kSpriteSheetNumColumns"] intValue]; i++) {
            [enemyAnimation addFrameWithImage:[enemySpriteSheet getSpriteAtX:i y:0] delay:0.1];
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

@end
