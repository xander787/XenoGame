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
//
//  Last Updated - 12/19/2010 @5PM - Alexander
//  - Added collision point loading code from PLIST
//
//  Last Updated - 12/31/2010 @7:30PM - Alexander
//  - Memory management: added dealloc method and use it
//  to deallocate our objects
//  Last updated - 1/19/11 @ &PM - James
//  - Rewrote hte majority of the initialization, mainly
//  for loading information fomr the BossShips.plist file

#import "BossShip.h"


@implementation BossShip

@synthesize bossHealth, bossAttack, bossStamina, bossSpeed, currentLocation, modularObjects;

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
        
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        //Pre allocate all of the arrays from our BossShips.plist
        NSArray *moduleImagesArray = [[NSArray alloc] initWithArray:[bossDictionary objectForKey:@"kShipModuleImages"]];
        NSArray *moduleLocationsArray = [[NSArray alloc] initWithArray:[bossDictionary objectForKey:@"kShipModulePoints"]];
        NSArray *moduleTurretPointsArray = [[NSArray alloc] initWithArray:[bossDictionary objectForKey:@"kShipTurretPoints"]];
        NSArray *moduleCollisionPointsArray = [[NSArray alloc] initWithArray:[bossDictionary objectForKey:@"kCollisionBoundingPoints"]];
        NSArray *moduleDestructionOrder = [[NSArray alloc] initWithArray:[bossDictionary objectForKey:@"kModularDestructionOrder"]];
        
        //Set a global number of modules we have for the boss ship, better to use than getting the count of an array multiple times
        numberOfModules = [moduleImagesArray count];
        
        //Alloc memory for each module, old C style
        modularObjects = malloc(sizeof(ModularObject) * numberOfModules);
        bzero(modularObjects, sizeof(ModularObject) * numberOfModules);
        
        shipWidth = 0;
        shipHeight = 0;
        
        //This is our main loop, getting the unique info for each module at a time
        for(int i = 0; i < numberOfModules; i++){
            
            //Step one: get the image for the module, simple so it's first
            modularObjects[i].moduleImage = [[Image alloc] initWithImage:[moduleImagesArray objectAtIndex:i] scale:1.0f];
            
            //Set the width & height for later use in super class handling this ship
            shipWidth += modularObjects[i].moduleImage.imageWidth;
            shipHeight += modularObjects[i].moduleImage.imageHeight;
            
            //Drawing order goes here, it's so certain things are not drawn over other parts of the ship
            modularObjects[i].drawingOrder = i;
            
            
            //Step two:  get the locations for each module relative to the center of the ship
            NSArray *moduleLocationCoords = [[NSArray alloc] initWithArray:[[moduleLocationsArray objectAtIndex:i] componentsSeparatedByString:@","]];
            modularObjects[i].location = Vector2fMake([[moduleLocationCoords objectAtIndex:0] floatValue], [[moduleLocationCoords objectAtIndex:1] floatValue]);
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
            [turretString release];
            
            
            
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
        
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    }
    
    return self;
}

- (void)setDesiredLocation:(CGPoint)aPoint {
    desiredLocation = aPoint;
}

- (void)update:(GLfloat)delta {
    currentLocation.x += ((desiredLocation.x - currentLocation.x) / bossSpeed) * (pow(1.584893192, bossSpeed)) * delta;
    currentLocation.y += ((desiredLocation.y - currentLocation.y) / bossSpeed) * (pow(1.584893192, bossSpeed)) * delta;
    
    //Set the centers of the polygons so they get rendered properly
    for(int i = 0; i < numberOfModules; i++){
        [modularObjects[i].collisionPolygon setPos:CGPointMake(modularObjects[i].location.x + currentLocation.x, modularObjects[i].location.y + currentLocation.y)];  
    }
}

- (void)render {
    for(int i = 0; i < numberOfModules; i++) {
        [modularObjects[i].moduleImage renderAtPoint:CGPointMake(currentLocation.x - modularObjects[i].location.x, currentLocation.y - modularObjects[i].location.y) centerOfImage:YES];
    }
    
    if(DEBUG) {                
        glPushMatrix();
        
        glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
        
        for(int i = 0; i < numberOfModules; i++) {
            for(int j = 0; j < (modularObjects[i].collisionPointsCount - 1); j++) {
                GLfloat line[] = {
                    modularObjects[i].collisionPolygon.points[j].x, modularObjects[i].collisionPolygon.points[j].y,
                    modularObjects[i].collisionPolygon.points[j+1].x, modularObjects[i].collisionPolygon.points[j+1].y,
                };
                
                glVertexPointer(2, GL_FLOAT, 0, line);
                glEnableClientState(GL_VERTEX_ARRAY);
                glDrawArrays(GL_LINES, 0, 2);
            }
            
            GLfloat lineEnd[] = {
                modularObjects[i].collisionPolygon.points[(modularObjects[i].collisionPointsCount - 1)].x, modularObjects[i].collisionPolygon.points[(modularObjects[i].collisionPointsCount - 1)].y,
                modularObjects[i].collisionPolygon.points[0].x, modularObjects[i].collisionPolygon.points[0].y,
            };
            
            glVertexPointer(2, GL_FLOAT, 0, lineEnd);
            glEnableClientState(GL_VERTEX_ARRAY);
            glDrawArrays(GL_LINES, 0, 2);
        }
        
        glPopMatrix();
    }
}

- (void)dealloc {
    [playerShipRef release];
    [super dealloc];
}

@end
