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
//  Last updated - 1/19/11 @ &PM - James
//  - Rewrote hte majority of the initialization, mainly
//  for loading information fomr the BossShips.plist file
//
//  Last Updated - 1/28/2011 @10PM - Alexander
//  - Make sure that on initialization, module rotations 
//  are set to 0.0f
//
//	Last Updated - 6/15/2011 @ 3:30PM - Alexander
//	- Support for new Scale2f vector scaling system
//
//  Last Updated - 6/22/11 @5PM - Alexander & James
//  - Changed enums to reflect new bosses
//
//  Last Updated - 7/19/11 @5PM - Alexander
//  - Modules now have default and current location
//
//  Last Updated - 7/19/11 @5:30PM - Alexander
//  - Added readonly properties for numberOfModules, bossID, and bossType
//  - Added new method to hit modules with damage
//
//  Last Updated - 7/20/11 @7:30PM - Alexander
//  - Added currentDestructionOrder for the ship to keep track of
//  which modules can currently be hit
//
//  Last Updated - 7/21/11 @9PM - James
//  - Added basic health logic, logic for destruction order
//
//  Last Updated - 7/22/11 @9PM - Alexander
//  - Module color filter change when hit

#import "BossShip.h"
#import "BossShipAtlas.h"

@implementation BossShip

@synthesize bossHealth, bossAttack, bossStamina, bossSpeed, modularObjects, numberOfModules, currentDestructionOrder, bossID, bossType;

- (id)initWithBossID:(BossShipID)aBossID initialLocation:(CGPoint)aPoint andPlayerShipRef:(PlayerShip *)aPlayerShip {
    if((self = [super init])) {
        bossID = aBossID;
        currentLocation = aPoint;
        playerShipRef = aPlayerShip;
        desiredLocation = aPoint;
        
        //Load the PLIST with all the boss ship definitions
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *path = [[NSString alloc] initWithString:[bundle pathForResource:@"BossShips" ofType:@"plist"]];
        NSMutableDictionary *bossShipsDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        NSMutableDictionary *bossDictionary;
        [path release];
        
        switch (bossID) {
            case kBoss_Themis:
                bossDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bossShipsDictionary objectForKey:@"kBossThemis"]];
                break;
            case kBoss_Eos:
                bossDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bossShipsDictionary objectForKey:@"kBossEos"]];
                break;
            case kBoss_Astraeus:
                bossDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bossShipsDictionary objectForKey:@"kBossAstraeus"]];
                break;
            case kBoss_Helios:
                bossDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bossShipsDictionary objectForKey:@"kBossHelios"]];
                break;
            case kBoss_Oceanus:
                bossDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bossShipsDictionary objectForKey:@"kBossOceanus"]];
                break;
            case kBoss_Atlas:
                bossDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bossShipsDictionary objectForKey:@"kBossAtlas"]];
                break;
            case kBoss_Hyperion:
                bossDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bossShipsDictionary objectForKey:@"kBossHyperion"]];
                break;
            case kBoss_Kronos:
                bossDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bossShipsDictionary objectForKey:@"kBossKronos"]];
                break;
            case kBoss_AlphaWeapon:
                bossDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bossShipsDictionary objectForKey:@"kMiniBossAlphaWeapon"]];
                break;
            case kMiniBoss_OneOne:
                bossDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bossShipsDictionary objectForKey:@"kMiniBossOneOne"]];
                break;
            case kMiniBoss_OneTwo:
                bossDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bossShipsDictionary objectForKey:@"kMiniBossOneTwo"]];
                break;
            case kMiniBoss_OneThree:
                bossDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bossShipsDictionary objectForKey:@"kMiniBossOneThree"]];
                break;
            case kMiniBoss_TwoOne:
                bossDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bossShipsDictionary objectForKey:@"kMiniBossTwoOne"]];
                break;
            case kMiniBoss_TwoTwo:
                bossDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bossShipsDictionary objectForKey:@"kMiniBossTwoTwo"]];
                break;
            case kMiniBoss_TwoThree:
                bossDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bossShipsDictionary objectForKey:@"kMiniBossTwoThree"]];
                break;
            case kMiniBoss_ThreeOne:
                bossDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bossShipsDictionary objectForKey:@"kMiniBossThreeOne"]];
                break;
            case kMiniBoss_ThreeTwo:
                bossDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bossShipsDictionary objectForKey:@"kMiniBossThreeTwo"]];
                break;
            case kMiniBoss_ThreeThree:
                bossDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bossShipsDictionary objectForKey:@"kMiniBossThreeThree"]];
                break;
            case kMiniBoss_FourOne:
                bossDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bossShipsDictionary objectForKey:@"kMiniBossFourOne"]];
                break;
            case kMiniBoss_FourTwo:
                bossDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bossShipsDictionary objectForKey:@"kMiniBossFourTwo"]];
                break;
            case kMiniBoss_FiveOne:
                bossDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bossShipsDictionary objectForKey:@"kMiniBossFiveOne"]];
                break;
            case kMiniBoss_FiveTwo:
                bossDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bossShipsDictionary objectForKey:@"kMiniBossFiveTwo"]];
                break;
            case kMiniBoss_FiveThree:
                bossDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bossShipsDictionary objectForKey:@"kMiniBossFiveThree"]];
                break;
            case kMiniBoss_SixOne:
                bossDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bossShipsDictionary objectForKey:@"kMiniBossSixOne"]];
                break;
            case kMiniBoss_SixTwo:
                bossDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bossShipsDictionary objectForKey:@"kMiniBossSixTwo"]];
                break;
            case kMiniBoss_SixThree:
                bossDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bossShipsDictionary objectForKey:@"kMiniBossSixThree"]];
                break;
            case kMiniBoss_SevenOne:
                bossDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bossShipsDictionary objectForKey:@"kMiniBossSevenOne"]];
                break;
            case kMiniBoss_SevenTwo:
                bossDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bossShipsDictionary objectForKey:@"kMiniBossSevenTwo"]];
                break;
            case kMiniBoss_SevenThree:
                bossDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bossShipsDictionary objectForKey:@"kMiniBossSevenThree"]];
                break;
            default:
                break;
        }
        
        [bossShipsDictionary release];
        
        //Set the values for the ship based on those in the plist file
        bossHealth = 1;
        bossAttack = [[bossDictionary valueForKey:@"kBossAttack"] intValue];
        bossStamina = [[bossDictionary valueForKey:@"kBossStamina"] intValue];
        bossSpeed = [[bossDictionary valueForKey:@"kBossSpeed"] intValue];
        
        if([bossDictionary valueForKey:@"kBossType"] == @"kBossTypeBoss") {
            bossType = kBossType_Full;
        }
        else if([bossDictionary valueForKey:@"kBossType"] == @"kBossTypeMini") {
            bossType = kBossType_Mini;
        }
                
        //Pre allocate all of the arrays from our BossShips.plist
        NSArray *moduleImagesArray = [[NSArray alloc] initWithArray:[bossDictionary objectForKey:@"kShipModuleImages"]];
        NSArray *moduleLocationsArray = [[NSArray alloc] initWithArray:[bossDictionary objectForKey:@"kShipModulePoints"]];
        NSArray *moduleTurretPointsArray = [[NSArray alloc] initWithArray:[bossDictionary objectForKey:@"kShipTurretPoints"]];
        NSArray *moduleCollisionPointsArray = [[NSArray alloc] initWithArray:[bossDictionary objectForKey:@"kCollisionBoundingPoints"]];
        NSArray *moduleDestructionOrder = [[NSArray alloc] initWithArray:[bossDictionary objectForKey:@"kModularDestructionOrder"]];
        
        [bossDictionary release];
        
        //Set a global number of modules we have for the boss ship, better to use than getting the count of an array multiple times
        numberOfModules = [moduleImagesArray count];
        currentDestructionOrder = 0;
        
        //Alloc memory for each module, old C style
        modularObjects = malloc(sizeof(ModularObject) * numberOfModules);
        bzero(modularObjects, sizeof(ModularObject) * numberOfModules);
        
        shipWidth = 0;
        shipHeight = 0;
        
        //This is our main loop, getting the unique info for each module at a time
        for(int i = 0; i < numberOfModules; i++){
            
            //Step one: get the image for the module, simple so it's first
            modularObjects[i].moduleImage = [[Image alloc] initWithImage:[moduleImagesArray objectAtIndex:i] scale:Scale2fOne];
            
            modularObjects[i].moduleMaxHealth = 1;
            modularObjects[i].moduleHealth = modularObjects[i].moduleMaxHealth;
            
            modularObjects[i].rotation = 0;
            
            //Set the width & height for later use in super class handling this ship
            shipWidth += modularObjects[i].moduleImage.imageWidth;
            shipHeight += modularObjects[i].moduleImage.imageHeight;
            
            //Drawing order goes here, it's so certain things are not drawn over other parts of the ship
            modularObjects[i].drawingOrder = i;
            
            
            //Step two:  get the locations for each module relative to the center of the ship
            NSArray *moduleLocationCoords = [[NSArray alloc] initWithArray:[[moduleLocationsArray objectAtIndex:i] componentsSeparatedByString:@","]];
            modularObjects[i].location = Vector2fMake([[moduleLocationCoords objectAtIndex:0] floatValue], [[moduleLocationCoords objectAtIndex:1] floatValue]);
            modularObjects[i].defaultLocation = modularObjects[i].location;
            [moduleLocationCoords release];
            
            
            //Now for getting the turret locations relative to the center of this certain module, note there can be multiple turrets for each module
            NSString *turretString = [moduleTurretPointsArray objectAtIndex:i];
            //Are we sure that this module even has a single turret?
            if([turretString isEqualToString:nil] == NO){
                //We seperate by a semicolon because there can be multiple turrets
                NSArray *turretCoordPairs = [[NSArray alloc] initWithArray:[[moduleTurretPointsArray objectAtIndex:i] componentsSeparatedByString:@";"]];
                //Alloc the space for information of our weapons
                modularObjects[i].weapons = malloc(sizeof(WeaponObject) * [turretCoordPairs count]);
                modularObjects[i].numberOfWeapons = [turretCoordPairs count];
                
                //Now loops through each pairs of coordinates of turrets
                for(int j = 0; j < modularObjects[i].numberOfWeapons; j++){
                    NSArray *turretCoords = [[NSArray alloc] initWithArray:[[turretCoordPairs objectAtIndex:j] componentsSeparatedByString:@","]];
                    
                    modularObjects[i].weapons[j].weaponCoord = Vector2fMake([[turretCoords objectAtIndex:0] floatValue], [[turretCoords objectAtIndex:1] floatValue]);
                    //Note: we will add custom weapons later
                    modularObjects[i].weapons[j].weaponType = kBossWeapon_Default;
                    [turretCoords release];
                    
                }
                [turretCoordPairs release];
            }
            else {
                modularObjects[i].numberOfWeapons = 0;
            }            
            
            
            //Collision detection points time!
            NSArray *collisionCoordPairs = [[NSArray alloc] initWithArray:[[moduleCollisionPointsArray objectAtIndex:i] componentsSeparatedByString:@";"]];
            
            modularObjects[i].collisionDetectionBoundingPoints = malloc(sizeof(Vector2f) * [collisionCoordPairs count]);
            bzero(modularObjects[i].collisionDetectionBoundingPoints, sizeof(Vector2f) * [collisionCoordPairs count]);
            
            //Loop through the pairs of coordinates and apply them
            for(int j = 0; j < [collisionCoordPairs count]; j++){
                NSArray *coords = [[NSArray alloc] initWithArray:[[collisionCoordPairs objectAtIndex:j] componentsSeparatedByString:@","]];
                
                modularObjects[i].collisionDetectionBoundingPoints[j] = Vector2fMake([[coords objectAtIndex:0] floatValue], [[coords objectAtIndex:1] floatValue]);
                [coords release];
            }
            
            //We need the number of points for polygons
            modularObjects[i].collisionPointsCount = [collisionCoordPairs count];
            [collisionCoordPairs release];
            
            //Finally create our polygon, for each module of course
            modularObjects[i].collisionPolygon = [[Polygon alloc] initWithPoints:modularObjects[i].collisionDetectionBoundingPoints
                                                                        andCount:modularObjects[i].collisionPointsCount
                                                                      andShipPos:currentLocation];
            //Update the position of the polygon to the center of the module
            [modularObjects[i].collisionPolygon setPos:CGPointMake(currentLocation.x + modularObjects[i].location.x, currentLocation.y + modularObjects[i].location.y)];
            
            
        }
        
        //We have to put this in a seperate for loop because it doesn't conform to the number of modules
        //Here, we order the way the modules get destroyed
        for(int i = 0; i < [moduleDestructionOrder count]; i++) {
            NSArray *destructableModulesArray = [[NSArray alloc] initWithArray:[moduleDestructionOrder objectAtIndex:i]];
            for(int j = 0; j < [destructableModulesArray count]; j++) {
                int moduleNum = [[destructableModulesArray objectAtIndex:j] intValue];
                modularObjects[moduleNum].destructionOrder = i; 
            }
            [destructableModulesArray release];
        }
        
        
        //Make sure to free our memory, leaks are bad.
        [moduleImagesArray release];
        [moduleLocationsArray release];
        [moduleTurretPointsArray release];
        [moduleCollisionPointsArray release];
        [moduleDestructionOrder release];
        
    }
    
    return self;
}

- (void)setDesiredLocation:(CGPoint)aPoint {
    desiredLocation = aPoint;
}

- (void)hitModule:(int)module withDamage:(int)damage {
    modularObjects[module].moduleHealth -= damage;
    
    modularObjects[module].hitFilter = YES;
    [modularObjects[module].moduleImage setColourFilterRed:1.0f green:0.0f blue:0.0f alpha:0.5f];
    
    if(modularObjects[module].moduleHealth <= 0){
        modularObjects[module].isDead = YES;
        //See if all mmodules with this destructionOrder are dead, if so, bump up the current
        BOOL increment = YES;
        for(int i = 0; i < numberOfModules; i++){
            if(module != i){
                if(modularObjects[i].isDead == NO){
                    if(modularObjects[i].destructionOrder == currentDestructionOrder){
                        increment = NO;
                    }
                }
            }
        }
        if(increment){
            currentDestructionOrder++;
        }
    }
}

- (void)update:(GLfloat)delta {    
    for (int i = 0; i < numberOfModules; ++i) {
        if (modularObjects[i].hitFilter && modularObjects[i].hitFilterEffectTime <= 0.15) {
            modularObjects[i].hitFilterEffectTime += delta;
        }
        else {
            modularObjects[i].hitFilter = NO;
            modularObjects[i].hitFilterEffectTime = 0.0;
            [modularObjects[i].moduleImage setColourFilterRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
        }        
    }
}

- (void)render {
    
}

- (void)dealloc {
    free(modularObjects);
    [super dealloc];
}

@end
