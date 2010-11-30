//
//  BossShip.m
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
//	Last Updated - 11/25/2010 @8PM - Alexander
//	- Wrote the first-draft initializer code (fuckin complicated)
//  for the Boss class.
//
//	Last Updated - 11/26/2010 @3:30PM - Alexander
//	- Fixed the problems in the boss initialization. Should work now
//
//  Last Updated - 11/26/2010 @6PM - Alexander
//  - Added rendering code, and fixed some other crashing bugs

#import "BossShip.h"


@implementation BossShip

@synthesize bossHealth, bossAttack, bossStamina, bossSpeed, currentLocation;

- (id)initWithBossID:(BossShipID)aBossID initialLocation:(CGPoint)aPoint andPlayerShipRef:(PlayerShip *)aPlayerShip {
    if(self = [super init]) {
        bossID = aBossID;
        currentLocation = aPoint;
        playerShipRef = aPlayerShip;
        desiredLocation = aPoint;
        
        //Load the PLIST with all the boss ship definitions
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *path = [[NSString alloc] initWithString:[bundle pathForResource:@"BossShips" ofType:@"plist"]];
        NSMutableDictionary *bossShipsDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        NSMutableDictionary *bossDictionary;
        [bundle release];
        [path release];
        
        switch (bossID) {
            case kBoss_Africa:
                bossDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bossShipsDictionary objectForKey:@"kBossAfrica"]];
                break;
            case kBoss_Antarctica:
                bossDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bossShipsDictionary objectForKey:@"kBossAntarctica"]];
                break;
            case kBoss_Asia:
                bossDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bossShipsDictionary objectForKey:@"kBossAsia"]];
                break;
            case kBoss_Australia:
                bossDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bossShipsDictionary objectForKey:@"kBossAustralia"]];
                break;
            case kBoss_Earth:
                bossDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bossShipsDictionary objectForKey:@"kBossEarth"]];
                break;
            case kBoss_Europe:
                bossDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bossShipsDictionary objectForKey:@"kBossEurope"]];
                break;
            case kBoss_NorthAmerika:
                bossDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bossShipsDictionary objectForKey:@"kBossNorthAmerika"]];
                break;
            case kBoss_SouthAmerika:
                bossDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bossShipsDictionary objectForKey:@"kBossSouthAmerika"]];
                break;
            case kMiniBoss_AmazonRiver:
                bossDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bossShipsDictionary objectForKey:@"kMiniBossAmazonRiver"]];
                break;
            case kMiniBoss_AntarcticPeninsula:
                bossDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bossShipsDictionary objectForKey:@"kMiniBossAntarcticPeninsula"]];
                break;
            case kMiniBoss_Baghdad:
                bossDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bossShipsDictionary objectForKey:@"kMiniBossBaghdad"]];
                break;
            case kMiniBoss_Beijing:
                bossDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bossShipsDictionary objectForKey:@"kMiniBossBeijing"]];
                break;
            case kMiniBoss_Berlin:
                bossDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bossShipsDictionary objectForKey:@"kMiniBossBerlin"]];
                break;
            case kMiniBoss_BeunosAires:
                bossDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bossShipsDictionary objectForKey:@"kMiniBossBeunosAires"]];
                break;
            case kMiniBoss_Cairo:
                bossDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bossShipsDictionary objectForKey:@"kMiniBossCairo"]];
                break;
            case kMiniBoss_Chicago:
                bossDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bossShipsDictionary objectForKey:@"kMiniBossChicago"]];
                break;
            case kMiniBoss_HongKong:
                bossDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bossShipsDictionary objectForKey:@"kMiniBossHongKong"]];
                break;
            case kMiniBoss_Jakarta:
                bossDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bossShipsDictionary objectForKey:@"kMiniBossJakarta"]];
                break;
            case kMiniBoss_Johannesburg:
                bossDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bossShipsDictionary objectForKey:@"kMiniBossJohannesburg"]];
                break;
            case kMiniBoss_London:
                bossDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bossShipsDictionary objectForKey:@"kMiniBossLondon"]];
                break;
            case kMiniBoss_LosAngeles:
                bossDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bossShipsDictionary objectForKey:@"kMiniBossLosAngeles"]];
                break;
            case kMiniBoss_Madrid:
                bossDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bossShipsDictionary objectForKey:@"kMiniBossMadrid"]];
                break;
            case kMiniBoss_Melbourne:
                bossDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bossShipsDictionary objectForKey:@"kMiniBossMelbourne"]];
                break;
            case kMiniBoss_MexicoCity:
                bossDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bossShipsDictionary objectForKey:@"kMiniBossMexicoCity"]];
                break;
            case kMiniBoss_Moscow:
                bossDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bossShipsDictionary objectForKey:@"kMiniBossMoscow"]];
                break;
            case kMiniBoss_MtRushmore:
                bossDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bossShipsDictionary objectForKey:@"kMiniBossMtRushmore"]];
                break;
            case kMiniBoss_NewDelhi:
                bossDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bossShipsDictionary objectForKey:@"kMiniBossNewDelhi"]];
                break;
            case kMiniBoss_NewYork:
                bossDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bossShipsDictionary objectForKey:@"kMiniBossNewYork"]];
                break;
            case kMiniBoss_Outback:
                bossDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bossShipsDictionary objectForKey:@"kMiniBossOutback"]];
                break;
            case kMiniBoss_Paris:
                bossDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bossShipsDictionary objectForKey:@"kMiniBossParis"]];
                break;
            case kMiniBoss_Sahara:
                bossDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bossShipsDictionary objectForKey:@"kMiniBossSahara"]];
                break;
            case kMiniBoss_SanFrancisco:
                bossDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bossShipsDictionary objectForKey:@"kMiniBossSanFrancisco"]];
                break;
            case kMiniBoss_Santiago:
                bossDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bossShipsDictionary objectForKey:@"kMiniBossSantiago"]];
                break;
            case kMiniBoss_SouthPole:
                bossDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bossShipsDictionary objectForKey:@"kMiniBossSouthPole"]];
                break;
            case kMiniBoss_Sydney:
                bossDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bossShipsDictionary objectForKey:@"kMiniBossSydney"]];
                break;
            case kMiniBoss_Tokyo:
                bossDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bossShipsDictionary objectForKey:@"kMiniBossTokyo"]];
                break;
            default:
                break;
        }
        
        [bossShipsDictionary release];
        
        //Set the values for the ship based on those in the plist file
        bossHealth = 100;
        bossAttack = [[bossDictionary valueForKey:@"kBossAttack"] intValue];
        bossStamina = [[bossDictionary valueForKey:@"kBossStamina"] intValue];
        bossSpeed = [[bossDictionary valueForKey:@"kBossSpeed"] intValue];
        
        if([bossDictionary valueForKey:@"kBossType"] == @"kBossTypeBoss") {
            bossType = kBossType_Full;
        }
        else if([bossDictionary valueForKey:@"kBossType"] == @"kBossTypeMini") {
            bossType = kBossType_Mini;
        }
        
        //Fill a C array with all of the modules for the Boss and all of their information
        NSArray *moduleImagesArray = [[NSArray alloc] initWithArray:[bossDictionary objectForKey:@"kShipModuleImages"]];
        NSArray *modulePointsArray = [[NSArray alloc] initWithArray:[bossDictionary objectForKey:@"kShipModulePoints"]];

        modularObjects = malloc(sizeof(ModularObject) * [moduleImagesArray count]);
        numberOfModules = [moduleImagesArray count];
        bzero(modularObjects, sizeof(ModularObject) * [moduleImagesArray count]);
        
        for(int i = 0; i < [moduleImagesArray count]; i++) {
            modularObjects[i].moduleImage = [[bossDictionary objectForKey:@"kShipModuleImages"] objectAtIndex:i];
            modularObjects[i].drawingOrder = i;
            
            NSArray *moduleCoords = [[NSArray alloc] initWithArray:[[modulePointsArray objectAtIndex:i] componentsSeparatedByString:@","]];
            modularObjects[i].location = Vector2fMake([[moduleCoords objectAtIndex:0] floatValue], [[moduleCoords objectAtIndex:1] floatValue]);
            [moduleCoords release];
            
            NSArray *turretPoints = [[NSArray alloc] initWithArray:[bossDictionary objectForKey:@"kShipTurretPoints"]];
            NSString *turretString = [turretPoints objectAtIndex:i];
            if(![turretString isEqualToString:@"nil"]) {
                NSLog(@"%@", [turretPoints objectAtIndex:i]);
                NSArray *coordPairs = [[NSArray alloc] initWithArray:[[turretPoints objectAtIndex:i] componentsSeparatedByString:@";"]];
                modularObjects[i].weapons = malloc(sizeof(WeaponObject) * [coordPairs count]);
                modularObjects[i].numberOfWeapons = [coordPairs count];
                
                for(int j = 0; j < [coordPairs count]; j++) {
                    NSArray *turretCoords = [[NSArray alloc] initWithArray:[[coordPairs objectAtIndex:j] componentsSeparatedByString:@","]];
                    
                    modularObjects[i].weapons[j].weaponCoord = Vector2fMake([[turretCoords objectAtIndex:0] intValue], [[turretCoords objectAtIndex:1] intValue]);
                    modularObjects[i].weapons[j].weaponType = kBossWeapon_Default;
                    
                    [turretCoords release];
                }
                [coordPairs release];
            }
            else {
                modularObjects[i].numberOfWeapons = 0;
            }
            
            [turretPoints release];
            [turretString release];
        }
        
        NSArray *destructionOrder = [[NSArray alloc] initWithArray:[bossDictionary objectForKey:@"kModularDestructionOrder"]];
        for(int i = 0; i < [destructionOrder count]; i++) {
            NSArray *destructableModulesArray = [[NSArray alloc] initWithArray:[destructionOrder objectAtIndex:i]];
            for(int j = 0; j < [destructableModulesArray count]; j++) {
                int moduleNum = [[destructableModulesArray objectAtIndex:j] intValue];
                modularObjects[moduleNum].destructionOrder = i; 
            }
            [destructableModulesArray release];
        }
        
        [modulePointsArray release];
    }
    
    return self;
}

- (void)update:(GLfloat)delta {
    currentLocation.x += ((desiredLocation.x - currentLocation.x) / bossSpeed) * (pow(1.584893192, bossSpeed)) * delta;
    currentLocation.y += ((desiredLocation.y - currentLocation.y) / bossSpeed) * (pow(1.584893192, bossSpeed)) * delta;
}

- (void)render {
    for(int i = 0; i < numberOfModules; i++) {
        NSString *imagePath = modularObjects[i].moduleImage;
        Image *moduleImage = [[Image alloc] initWithImage:[NSString stringWithString:imagePath]];
        [moduleImage renderAtPoint:CGPointMake(currentLocation.x - modularObjects[i].location.x, currentLocation.y - modularObjects[i].location.y) centerOfImage:YES];
    }
}

@end
