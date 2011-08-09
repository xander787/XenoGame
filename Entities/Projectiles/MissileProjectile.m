//
//  MissileProjectile.m
//  Xenophobe
//
//  Created by James Linnell on 8/5/11.
//  Copyright 2011 PDHS. All rights reserved.
//

#import "MissileProjectile.h"

@implementation MissileProjectile

- (id)initWithProjectileID:(ProjectileID)aProjID location:(Vector2f)aLocation andAngle:(GLfloat)aAngle
{
    self = [super initWithProjectileID:aProjID location:aLocation andAngle:aAngle];
    if (self) {
        
        //Paths for main dictionary
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *path = [[NSString alloc] initWithString:[bundle pathForResource:@"Projectiles" ofType:@"plist"]];
        NSMutableDictionary *dictionaryPlist = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        NSMutableDictionary *projectileDictionary;
        [path release];
        
        switch(projectileID){
            case kPlayerProjectile_MissileLevelOne_Single:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kPlayerProjectile_MissileLevelOne_Single"]];
                break;
            case kPlayerProjectile_MissileLevelTwo_Double:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kPlayerProjectile_MissileLevelTwo_Double"]];
                break;
            case kPlayerProjectile_MissileLevelThree_Double:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kPlayerProjectile_MissileLevelThree_Double"]];
                break;
            case kPlayerProjectile_MissileLevelFour_Triple:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kPlayerProjectile_MissileLevelFour_Triple"]];
                break;
            case kPlayerProjectile_MissileLevelFive_Triple:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kPlayerProjectile_MissileLevelFive_Triple"]];
                break;
            case kPlayerProjectile_MissileLevelSix_Quadruple:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kPlayerProjectile_MissileLevelSix_Quadruple"]];
                break;
            case kPlayerProjectile_MissileLevelSeven_Quadruple:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kPlayerProjectile_MissileLevelSeven_Quadruple"]];
                break;
            case kPlayerProjectile_MissileLevelEight_Quintuple:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kPlayerProjectile_MissileLevelEight_Quintuple"]];
                break;
            case kPlayerProjectile_MissileLevelNine_Quintuple:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kPlayerProjectile_MissileLevelNine_Quintuple"]];
                break;
            case kPlayerProjectile_MissileLevelTen_Sextuple:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kPlayerProjectile_MissileLevelTen_Sextuple"]];
                break;
                
                
            case kEnemyProjectile_MissileLevelOne_Single:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kEnemyProjectile_MissileLevelOne_Single"]];
                break;
            case kEnemyProjectile_MissileLevelTwo_Double:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kEnemyProjectile_MissileLevelTwo_Double"]];
                break;
            case kEnemyProjectile_MissileLevelThree_Double:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kEnemyProjectile_MissileLevelThree_Double"]];
                break;
            case kEnemyProjectile_MissileLevelFour_Triple:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kEnemyProjectile_MissileLevelFour_Triple"]];
                break;
            case kEnemyProjectile_MissileLevelFive_Triple:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kEnemyProjectile_MissileLevelFive_Triple"]];
                break;
            case kEnemyProjectile_MissileLevelSix_Quadruple:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kEnemyProjectile_MissileLevelSix_Quadruple"]];
                break;
            case kEnemyProjectile_MissileLevelSeven_Quadruple:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kEnemyProjectile_MissileLevelSeven_Quadruple"]];
                break;
            case kEnemyProjectile_MissileLevelEight_Quintuple:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kEnemyProjectile_MissileLevelEight_Quintuple"]];
                break;
            case kEnemyProjectile_MissileLevelNine_Quintuple:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kEnemyProjectile_MissileLevelNine_Quintuple"]];
                break;
            case kEnemyProjectile_MissileLevelTen_Sextuple:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kEnemyProjectile_MissileLevelTen_Sextuple"]];
                break;
            default:
                break;
        }
        [dictionaryPlist release];
        
        speed = [[projectileDictionary objectForKey:@"kSpeed"] floatValue];    
        rate = [[projectileDictionary objectForKey:@"kRate"] intValue];
        
        [projectileDictionary release];
        
        //Loop through the collision points, put them in a C array
        collisionPointCount = 4;
        collisionPoints = malloc(sizeof(Vector2f) * collisionPointCount);
        bzero(collisionPoints, sizeof(Vector2f) * collisionPointCount);
        collisionPoints[0] = Vector2fMake(0, 6);
        collisionPoints[1] = Vector2fMake(6, 0);
        collisionPoints[2] = Vector2fMake(0, -6);
        collisionPoints[3] = Vector2fMake(-6, 0);
        
        
        
        
        switch(projectileID){
            case kEnemyProjectile_MissileLevelOne_Single:
            case kPlayerProjectile_MissileLevelOne_Single: {
                /*
                        |
                        | 
                        |
                        |
                        |
                        0
                 */
                ParticleEmitter *tempEmitter = [self newMissileEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                
                NSArray *tempArray = [self newArrayOfPolygonsWithCount:[[emitters objectAtIndex:0] maxParticles]];
                [polygons addObject:tempArray];
                [tempArray release];
                break;
            }
                
            case kEnemyProjectile_MissileLevelTwo_Double:
            case kPlayerProjectile_MissileLevelTwo_Double: {
                /*
                        |   |
                        |   |
                        |   |
                        |   |
                        |   |
                        0   1
                 */
                ParticleEmitter *tempEmitter = [self newMissileEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                tempEmitter = [self newMissileEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                
                
                [[emitters objectAtIndex:0] setSourcePosition:Vector2fAdd([[emitters objectAtIndex:0] sourcePosition], Vector2fMake(-20, 0))];
                [[emitters objectAtIndex:1] setSourcePosition:Vector2fAdd([[emitters objectAtIndex:1] sourcePosition], Vector2fMake(20, 0))];
                
                NSArray *tempArray = [self newArrayOfPolygonsWithCount:[[emitters objectAtIndex:0] maxParticles]];
                [polygons addObject:tempArray];
                [tempArray release];
                tempArray = [self newArrayOfPolygonsWithCount:[[emitters objectAtIndex:1] maxParticles]];
                [polygons addObject:tempArray];
                [tempArray release];
                break;
            }
                
            case kEnemyProjectile_MissileLevelThree_Double:
            case kPlayerProjectile_MissileLevelThree_Double: {
                /*
                        |   |
                        |   |
                        |   |
                        |   |
                        |   |
                        0   1
                 */
                ParticleEmitter *tempEmitter = [self newMissileEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                tempEmitter = [self newMissileEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                
                [[emitters objectAtIndex:0] setSourcePosition:Vector2fAdd([[emitters objectAtIndex:0] sourcePosition], Vector2fMake(-20, 0))];
                [[emitters objectAtIndex:1] setSourcePosition:Vector2fAdd([[emitters objectAtIndex:1] sourcePosition], Vector2fMake(20, 0))];
                
                NSArray *tempArray = [self newArrayOfPolygonsWithCount:[[emitters objectAtIndex:0] maxParticles]];
                [polygons addObject:tempArray];
                [tempArray release];
                tempArray = [self newArrayOfPolygonsWithCount:[[emitters objectAtIndex:1] maxParticles]];
                [polygons addObject:tempArray];
                [tempArray release];
                break;
            }
                
            case kEnemyProjectile_MissileLevelFour_Triple:
            case kPlayerProjectile_MissileLevelFour_Triple: {
                /*
                   \        |        /
                    \       |       /
                     \      |      /
                      \     |     /
                       \    |    /
                        0   1   2
                 */
                ParticleEmitter *tempEmitter = [self newMissileEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                tempEmitter = [self newMissileEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                tempEmitter = [self newMissileEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                
                
                [[emitters objectAtIndex:0] setSourcePosition:Vector2fAdd([[emitters objectAtIndex:0] sourcePosition], Vector2fMake(-20, 0))];
                [[emitters objectAtIndex:1] setSourcePosition:Vector2fAdd([[emitters objectAtIndex:1] sourcePosition], Vector2fMake(0, 0))];
                [[emitters objectAtIndex:2] setSourcePosition:Vector2fAdd([[emitters objectAtIndex:2] sourcePosition], Vector2fMake(20, 0))];
                
                [[emitters objectAtIndex:0] setAngle:[[emitters objectAtIndex:0] angle] + 15];
                [[emitters objectAtIndex:2] setAngle:[[emitters objectAtIndex:2] angle] - 15];
                
                
                NSArray *tempArray = [self newArrayOfPolygonsWithCount:[[emitters objectAtIndex:0] maxParticles]];
                [polygons addObject:tempArray];
                [tempArray release];
                tempArray = [self newArrayOfPolygonsWithCount:[[emitters objectAtIndex:1] maxParticles]];
                [polygons addObject:tempArray];
                [tempArray release];
                tempArray = [self newArrayOfPolygonsWithCount:[[emitters objectAtIndex:2] maxParticles]];
                [polygons addObject:tempArray];
                [tempArray release];
                break;
            }
                
            case kEnemyProjectile_MissileLevelFive_Triple:
            case kPlayerProjectile_MissileLevelFive_Triple: {
                /*
                   \        |        /
                    \       |       /
                     \      |      /
                      \     |     /
                       \    |    /
                        0   1   2
                 */
                ParticleEmitter *tempEmitter = [self newMissileEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                tempEmitter = [self newMissileEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                tempEmitter = [self newMissileEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                
                
                [[emitters objectAtIndex:0] setSourcePosition:Vector2fAdd([[emitters objectAtIndex:0] sourcePosition], Vector2fMake(-20, 0))];
                [[emitters objectAtIndex:1] setSourcePosition:Vector2fAdd([[emitters objectAtIndex:1] sourcePosition], Vector2fMake(0, 0))];
                [[emitters objectAtIndex:2] setSourcePosition:Vector2fAdd([[emitters objectAtIndex:2] sourcePosition], Vector2fMake(20, 0))];
                
                [[emitters objectAtIndex:0] setAngle:[[emitters objectAtIndex:0] angle] + 15];
                [[emitters objectAtIndex:2] setAngle:[[emitters objectAtIndex:2] angle] - 15];
                
                
                NSArray *tempArray = [self newArrayOfPolygonsWithCount:[[emitters objectAtIndex:0] maxParticles]];
                [polygons addObject:tempArray];
                [tempArray release];
                tempArray = [self newArrayOfPolygonsWithCount:[[emitters objectAtIndex:1] maxParticles]];
                [polygons addObject:tempArray];
                [tempArray release];
                tempArray = [self newArrayOfPolygonsWithCount:[[emitters objectAtIndex:2] maxParticles]];
                [polygons addObject:tempArray];
                [tempArray release];
                break;
            }
                
            case kEnemyProjectile_MissileLevelSix_Quadruple:
            case kPlayerProjectile_MissileLevelSix_Quadruple: {
                /*
                   \     |   |     /
                    \    |   |    /
                     \   |   |   /
                      \  |   |  /
                       \ |   | /   
                        01   23
                 */
                ParticleEmitter *tempEmitter = [self newMissileEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                tempEmitter = [self newMissileEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                tempEmitter = [self newMissileEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                tempEmitter = [self newMissileEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                
                
                [[emitters objectAtIndex:0] setSourcePosition:Vector2fAdd([[emitters objectAtIndex:0] sourcePosition], Vector2fMake(-20, 0))];
                [[emitters objectAtIndex:1] setSourcePosition:Vector2fAdd([[emitters objectAtIndex:1] sourcePosition], Vector2fMake(-20, 0))];
                [[emitters objectAtIndex:2] setSourcePosition:Vector2fAdd([[emitters objectAtIndex:2] sourcePosition], Vector2fMake(20, 0))];
                [[emitters objectAtIndex:3] setSourcePosition:Vector2fAdd([[emitters objectAtIndex:3] sourcePosition], Vector2fMake(20, 0))];
                
                [[emitters objectAtIndex:0] setAngle:([[emitters objectAtIndex:0] angle] + 15)];
                [[emitters objectAtIndex:3] setAngle:([[emitters objectAtIndex:3] angle] - 15)];
                
                
                NSArray *tempArray = [self newArrayOfPolygonsWithCount:[[emitters objectAtIndex:0] maxParticles]];
                [polygons addObject:tempArray];
                [tempArray release];
                tempArray = [self newArrayOfPolygonsWithCount:[[emitters objectAtIndex:1] maxParticles]];
                [polygons addObject:tempArray];
                [tempArray release];
                tempArray = [self newArrayOfPolygonsWithCount:[[emitters objectAtIndex:2] maxParticles]];
                [polygons addObject:tempArray];
                [tempArray release];
                tempArray = [self newArrayOfPolygonsWithCount:[[emitters objectAtIndex:3] maxParticles]];
                [polygons addObject:tempArray];
                [tempArray release];
                break;
            }
                
            case kEnemyProjectile_MissileLevelSeven_Quadruple:
            case kPlayerProjectile_MissileLevelSeven_Quadruple: {
                /*
                   \     |   |     /
                    \    |   |    /
                     \   |   |   /
                      \  |   |  /
                       \ |   | /   
                        01   23
                 */
                ParticleEmitter *tempEmitter = [self newMissileEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                tempEmitter = [self newMissileEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                tempEmitter = [self newMissileEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                tempEmitter = [self newMissileEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                
                
                [[emitters objectAtIndex:0] setSourcePosition:Vector2fAdd([[emitters objectAtIndex:0] sourcePosition], Vector2fMake(-20, 0))];
                [[emitters objectAtIndex:1] setSourcePosition:Vector2fAdd([[emitters objectAtIndex:1] sourcePosition], Vector2fMake(-20, 0))];
                [[emitters objectAtIndex:2] setSourcePosition:Vector2fAdd([[emitters objectAtIndex:2] sourcePosition], Vector2fMake(20, 0))];
                [[emitters objectAtIndex:3] setSourcePosition:Vector2fAdd([[emitters objectAtIndex:3] sourcePosition], Vector2fMake(20, 0))];
                
                [[emitters objectAtIndex:0] setAngle:([[emitters objectAtIndex:0] angle] + 15)];
                [[emitters objectAtIndex:3] setAngle:([[emitters objectAtIndex:3] angle] - 15)];
                
                
                NSArray *tempArray = [self newArrayOfPolygonsWithCount:[[emitters objectAtIndex:0] maxParticles]];
                [polygons addObject:tempArray];
                [tempArray release];
                tempArray = [self newArrayOfPolygonsWithCount:[[emitters objectAtIndex:1] maxParticles]];
                [polygons addObject:tempArray];
                [tempArray release];
                tempArray = [self newArrayOfPolygonsWithCount:[[emitters objectAtIndex:2] maxParticles]];
                [polygons addObject:tempArray];
                [tempArray release];
                tempArray = [self newArrayOfPolygonsWithCount:[[emitters objectAtIndex:3] maxParticles]];
                [polygons addObject:tempArray];
                [tempArray release];
                break;
            }
                
            case kEnemyProjectile_MissileLevelEight_Quintuple:
            case kPlayerProjectile_MissileLevelEight_Quintuple: {
                /*
                   \     |  |  |     /
                    \    |  |  |    /
                     \   |  |  |   /
                      \  |  |  |  /
                       \ |  |  | /
                        01  2  34
                 */
                ParticleEmitter *tempEmitter = [self newMissileEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                tempEmitter = [self newMissileEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                tempEmitter = [self newMissileEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                tempEmitter = [self newMissileEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                tempEmitter = [self newMissileEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                
                
                [[emitters objectAtIndex:0] setSourcePosition:Vector2fAdd([[emitters objectAtIndex:0] sourcePosition], Vector2fMake(-20, 0))];
                [[emitters objectAtIndex:1] setSourcePosition:Vector2fAdd([[emitters objectAtIndex:1] sourcePosition], Vector2fMake(-20, 0))];
                [[emitters objectAtIndex:3] setSourcePosition:Vector2fAdd([[emitters objectAtIndex:3] sourcePosition], Vector2fMake(20, 0))];
                [[emitters objectAtIndex:4] setSourcePosition:Vector2fAdd([[emitters objectAtIndex:4] sourcePosition], Vector2fMake(20, 0))];
                
                [[emitters objectAtIndex:0] setAngle:([[emitters objectAtIndex:0] angle] + 15)];
                [[emitters objectAtIndex:4] setAngle:([[emitters objectAtIndex:4] angle] - 15)];
                
                
                NSArray *tempArray = [self newArrayOfPolygonsWithCount:[[emitters objectAtIndex:0] maxParticles]];
                [polygons addObject:tempArray];
                [tempArray release];
                tempArray = [self newArrayOfPolygonsWithCount:[[emitters objectAtIndex:1] maxParticles]];
                [polygons addObject:tempArray];
                [tempArray release];
                tempArray = [self newArrayOfPolygonsWithCount:[[emitters objectAtIndex:2] maxParticles]];
                [polygons addObject:tempArray];
                [tempArray release];
                tempArray = [self newArrayOfPolygonsWithCount:[[emitters objectAtIndex:3] maxParticles]];
                [polygons addObject:tempArray];
                [tempArray release];
                tempArray = [self newArrayOfPolygonsWithCount:[[emitters objectAtIndex:4] maxParticles]];
                [polygons addObject:tempArray];
                [tempArray release];
                break;
            }
                
            case kEnemyProjectile_MissileLevelNine_Quintuple:
            case kPlayerProjectile_MissileLevelNine_Quintuple: {
                /*
                   \     |  |  |     /
                    \    |  |  |    /
                     \   |  |  |   /
                      \  |  |  |  /
                       \ |  |  | /
                        01  2  34
                 */
                ParticleEmitter *tempEmitter = [self newMissileEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                tempEmitter = [self newMissileEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                tempEmitter = [self newMissileEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                tempEmitter = [self newMissileEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                tempEmitter = [self newMissileEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                
                
                [[emitters objectAtIndex:0] setSourcePosition:Vector2fAdd([[emitters objectAtIndex:0] sourcePosition], Vector2fMake(-20, 0))];
                [[emitters objectAtIndex:1] setSourcePosition:Vector2fAdd([[emitters objectAtIndex:1] sourcePosition], Vector2fMake(-20, 0))];
                [[emitters objectAtIndex:3] setSourcePosition:Vector2fAdd([[emitters objectAtIndex:3] sourcePosition], Vector2fMake(20, 0))];
                [[emitters objectAtIndex:4] setSourcePosition:Vector2fAdd([[emitters objectAtIndex:4] sourcePosition], Vector2fMake(20, 0))];
                
                [[emitters objectAtIndex:0] setAngle:([[emitters objectAtIndex:0] angle] + 15)];
                [[emitters objectAtIndex:4] setAngle:([[emitters objectAtIndex:4] angle] - 15)];
                
                
                NSArray *tempArray = [self newArrayOfPolygonsWithCount:[[emitters objectAtIndex:0] maxParticles]];
                [polygons addObject:tempArray];
                [tempArray release];
                tempArray = [self newArrayOfPolygonsWithCount:[[emitters objectAtIndex:1] maxParticles]];
                [polygons addObject:tempArray];
                [tempArray release];
                tempArray = [self newArrayOfPolygonsWithCount:[[emitters objectAtIndex:2] maxParticles]];
                [polygons addObject:tempArray];
                [tempArray release];
                tempArray = [self newArrayOfPolygonsWithCount:[[emitters objectAtIndex:3] maxParticles]];
                [polygons addObject:tempArray];
                [tempArray release];
                tempArray = [self newArrayOfPolygonsWithCount:[[emitters objectAtIndex:4] maxParticles]];
                [polygons addObject:tempArray];
                [tempArray release];
                break;
            }
                
            case kEnemyProjectile_MissileLevelTen_Sextuple:
            case kPlayerProjectile_MissileLevelTen_Sextuple: {
                /*     7.5°         7.5°
                   \   |  | |   |  /
                    \  \  | |   / /
                     \  | | |  | /
                      \ \ | | / /
                15°>   \ || || /  <15°
                        012 345
                 */
                ParticleEmitter *tempEmitter = [self newMissileEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                tempEmitter = [self newMissileEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                tempEmitter = [self newMissileEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                tempEmitter = [self newMissileEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                tempEmitter = [self newMissileEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                tempEmitter = [self newMissileEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                
                
                [[emitters objectAtIndex:0] setSourcePosition:Vector2fAdd([[emitters objectAtIndex:0] sourcePosition], Vector2fMake(-20, 0))];
                [[emitters objectAtIndex:1] setSourcePosition:Vector2fAdd([[emitters objectAtIndex:1] sourcePosition], Vector2fMake(-20, 0))];
                [[emitters objectAtIndex:2] setSourcePosition:Vector2fAdd([[emitters objectAtIndex:2] sourcePosition], Vector2fMake(-20, 0))];
                [[emitters objectAtIndex:3] setSourcePosition:Vector2fAdd([[emitters objectAtIndex:3] sourcePosition], Vector2fMake(20, 0))];
                [[emitters objectAtIndex:4] setSourcePosition:Vector2fAdd([[emitters objectAtIndex:4] sourcePosition], Vector2fMake(20, 0))];
                [[emitters objectAtIndex:5] setSourcePosition:Vector2fAdd([[emitters objectAtIndex:5] sourcePosition], Vector2fMake(20, 0))];
                
                [[emitters objectAtIndex:0] setAngle:([[emitters objectAtIndex:0] angle] + 15)];
                [[emitters objectAtIndex:5] setAngle:([[emitters objectAtIndex:5] angle] - 15)];
                
                [[emitters objectAtIndex:1] setAngle:([[emitters objectAtIndex:1] angle] + 7.5)];
                [[emitters objectAtIndex:4] setAngle:([[emitters objectAtIndex:4] angle] - 7.5)];
                
                
                NSArray *tempArray = [self newArrayOfPolygonsWithCount:[[emitters objectAtIndex:0] maxParticles]];
                [polygons addObject:tempArray];
                [tempArray release];
                tempArray = [self newArrayOfPolygonsWithCount:[[emitters objectAtIndex:1] maxParticles]];
                [polygons addObject:tempArray];
                [tempArray release];
                tempArray = [self newArrayOfPolygonsWithCount:[[emitters objectAtIndex:2] maxParticles]];
                [polygons addObject:tempArray];
                [tempArray release];
                tempArray = [self newArrayOfPolygonsWithCount:[[emitters objectAtIndex:3] maxParticles]];
                [polygons addObject:tempArray];
                [tempArray release];
                tempArray = [self newArrayOfPolygonsWithCount:[[emitters objectAtIndex:4] maxParticles]];
                [polygons addObject:tempArray];
                [tempArray release];
                tempArray = [self newArrayOfPolygonsWithCount:[[emitters objectAtIndex:5] maxParticles]];
                [polygons addObject:tempArray];
                [tempArray release];
                break;
            }
                
            default:
                NSLog(@"ERROR::: Invalid projectile ID!");
                break;
        }
        
        if([emitters count] != [polygons count]){
            NSLog(@"ERROR::: Emitter count does not equal Polygon count!");
        }
    }
    
    return self;
}

- (void)update:(GLfloat)aDelta {
    [super update:aDelta];
    
    //Make sure to update with correct positions
    switch(projectileID){
        case kEnemyProjectile_MissileLevelOne_Single:
        case kPlayerProjectile_MissileLevelOne_Single: {
            [[emitters objectAtIndex:0] setSourcePosition:Vector2fMake(location.x, location.y)];
            break;
        }
            
        case kEnemyProjectile_MissileLevelTwo_Double:
        case kPlayerProjectile_MissileLevelTwo_Double: {
            [[emitters objectAtIndex:0] setSourcePosition:Vector2fMake(location.x - 20, location.y)];
            [[emitters objectAtIndex:1] setSourcePosition:Vector2fMake(location.x + 20, location.y)];
            break;
        }
            
        case kEnemyProjectile_MissileLevelThree_Double:
        case kPlayerProjectile_MissileLevelThree_Double: {
            [[emitters objectAtIndex:0] setSourcePosition:Vector2fMake(location.x - 20, location.y)];
            [[emitters objectAtIndex:1] setSourcePosition:Vector2fMake(location.x + 20, location.y)];
            break;
        }
            
        case kEnemyProjectile_MissileLevelFour_Triple:
        case kPlayerProjectile_MissileLevelFour_Triple: {
            [[emitters objectAtIndex:0] setSourcePosition:Vector2fMake(location.x - 20, location.y)];
            [[emitters objectAtIndex:1] setSourcePosition:Vector2fMake(location.x, location.y)];
            [[emitters objectAtIndex:2] setSourcePosition:Vector2fMake(location.x + 20, location.y)];
            break;
        }
            
        case kEnemyProjectile_MissileLevelFive_Triple:
        case kPlayerProjectile_MissileLevelFive_Triple: {
            [[emitters objectAtIndex:0] setSourcePosition:Vector2fMake(location.x - 20, location.y)];
            [[emitters objectAtIndex:1] setSourcePosition:Vector2fMake(location.x, location.y)];
            [[emitters objectAtIndex:2] setSourcePosition:Vector2fMake(location.x + 20, location.y)];
            break;
        }
            
        case kEnemyProjectile_MissileLevelSix_Quadruple:
        case kPlayerProjectile_MissileLevelSix_Quadruple: {
            [[emitters objectAtIndex:0] setSourcePosition:Vector2fMake(location.x - 20, location.y)];
            [[emitters objectAtIndex:1] setSourcePosition:Vector2fMake(location.x - 20, location.y)];
            [[emitters objectAtIndex:2] setSourcePosition:Vector2fMake(location.x + 20, location.y)];
            [[emitters objectAtIndex:3] setSourcePosition:Vector2fMake(location.x + 20, location.y)];
            break;
        }
            
        case kEnemyProjectile_MissileLevelSeven_Quadruple:
        case kPlayerProjectile_MissileLevelSeven_Quadruple: {
            [[emitters objectAtIndex:0] setSourcePosition:Vector2fMake(location.x - 20, location.y)];
            [[emitters objectAtIndex:1] setSourcePosition:Vector2fMake(location.x - 20, location.y)];
            [[emitters objectAtIndex:2] setSourcePosition:Vector2fMake(location.x + 20, location.y)];
            [[emitters objectAtIndex:3] setSourcePosition:Vector2fMake(location.x + 20, location.y)];
            break;
        }
            
        case kEnemyProjectile_MissileLevelEight_Quintuple:
        case kPlayerProjectile_MissileLevelEight_Quintuple: {
            [[emitters objectAtIndex:0] setSourcePosition:Vector2fMake(location.x - 20, location.y)];
            [[emitters objectAtIndex:1] setSourcePosition:Vector2fMake(location.x - 20, location.y)];
            [[emitters objectAtIndex:2] setSourcePosition:Vector2fMake(location.x, location.y)];
            [[emitters objectAtIndex:3] setSourcePosition:Vector2fMake(location.x + 20, location.y)];
            [[emitters objectAtIndex:4] setSourcePosition:Vector2fMake(location.x + 20, location.y)];
            break;
        }
            
        case kEnemyProjectile_MissileLevelNine_Quintuple:
        case kPlayerProjectile_MissileLevelNine_Quintuple: {
            [[emitters objectAtIndex:0] setSourcePosition:Vector2fMake(location.x - 20, location.y)];
            [[emitters objectAtIndex:1] setSourcePosition:Vector2fMake(location.x - 20, location.y)];
            [[emitters objectAtIndex:2] setSourcePosition:Vector2fMake(location.x, location.y)];
            [[emitters objectAtIndex:3] setSourcePosition:Vector2fMake(location.x + 20, location.y)];
            [[emitters objectAtIndex:4] setSourcePosition:Vector2fMake(location.x + 20, location.y)];
            break;
        }
            
        case kEnemyProjectile_MissileLevelTen_Sextuple:
        case kPlayerProjectile_MissileLevelTen_Sextuple: {
            [[emitters objectAtIndex:0] setSourcePosition:Vector2fMake(location.x - 20, location.y)];
            [[emitters objectAtIndex:1] setSourcePosition:Vector2fMake(location.x - 20, location.y)];
            [[emitters objectAtIndex:2] setSourcePosition:Vector2fMake(location.x - 20, location.y)];
            [[emitters objectAtIndex:3] setSourcePosition:Vector2fMake(location.x + 20, location.y)];
            [[emitters objectAtIndex:4] setSourcePosition:Vector2fMake(location.x + 20, location.y)];
            [[emitters objectAtIndex:5] setSourcePosition:Vector2fMake(location.x + 20, location.y)];
            
            break;
        }
            
        default:
            break;
    }
    
    
    for(NSArray *polyArray in polygons){
        for(Polygon *poly in polyArray){
            [poly setPos:CGPointMake(-50, -50)];
        }
    }
    for (int emitterPolyCount = 0; emitterPolyCount < [emitters count]; emitterPolyCount++){
        [[emitters objectAtIndex:emitterPolyCount] update:aDelta];
        
        for(int k = 0; k < [[emitters objectAtIndex:emitterPolyCount] particleIndex]; k++){
            //        for(int k = 0; k < [[polygons objectAtIndex:emitterPolyCount] count]; k++){
            [[[polygons objectAtIndex:emitterPolyCount] objectAtIndex:k] setPos:CGPointMake([[emitters objectAtIndex:emitterPolyCount] particles][k].position.x, 
                                                                                            [[emitters objectAtIndex:emitterPolyCount] particles][k].position.y)];
        }
    }
}

- (ParticleEmitter *)newMissileEmitter {
    ParticleEmitter *baseEmitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
                                                                                     position:Vector2fMake(location.x, location.y) 
                                                                       sourcePositionVariance:Vector2fZero 
                                                                                        speed:speed
                                                                                speedVariance:0.0
                                                                             particleLifeSpan:10.0
                                                                     particleLifespanVariance:0.0
                                                                                        angle:angle
                                                                                angleVariance:0.0
                                                                                      gravity:Vector2fZero
                                                                                   startColor:Color4fMake(0.8, 0.8, 1.0, 1.0)
                                                                           startColorVariance:Color4fMake(0.0, 0.0, 0.0, 0.0)
                                                                                  finishColor:Color4fMake(0.8, 0.8, 1.0, 1.0)
                                                                          finishColorVariance:Color4fMake(0.0, 0.0, 0.0, 0.0)
                                                                                 maxParticles:rate * 10.0
                                                                                 particleSize:25.0
                                                                           finishParticleSize:25.0
                                                                         particleSizeVariance:0.0
                                                                                     duration:-1.0
                                                                                blendAdditive:YES];
    
    if(projectileID >= kEnemyProjectile_MissileLevelOne_Single && projectileID <= kEnemyProjectile_MissileLevelTen_Sextuple){
        [baseEmitter setStartColor:Color4fMake(1.0, 0.0, 0.0, 1.0)];
        [baseEmitter setFinishColor:Color4fMake(1.0, 0.0, 0.0, 1.0)];
    }
    return baseEmitter;
}

- (NSArray *)newArrayOfPolygonsWithCount:(int)count {
    NSMutableArray *firstArray = [[NSMutableArray alloc] init];
    for(int i =0; i < count; i++){
        Polygon *tempPoly = [[Polygon alloc] initWithPoints:collisionPoints andCount:collisionPointCount andShipPos:CGPointMake(location.x, location.y)];
        [firstArray addObject:tempPoly];
        [tempPoly release];
    }
    
    NSArray *lastArray = [[NSArray alloc] initWithArray:firstArray];
    [firstArray release];
    return lastArray;
}

- (void)playProjectile {
    [super playProjectile];
}

- (void)pauseProjectile {
    [super pauseProjectile];
}

- (void)stopProjectile {
    [super stopProjectile];
}

- (void)render {
    for(ParticleEmitter *emitter in emitters){
        [emitter renderParticles];
        [emitter renderParticles];
    }
    
    
    
    if(DEBUG) {
        for(NSArray *polyArray in polygons){
            for(Polygon *polygon in polyArray){
                glPushMatrix();
                
                glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
                
                //Loop through the all the lines except for the last
                for(int i = 0; i < (polygon.pointCount - 1); i++) {
                    GLfloat line[] = {
                        polygon.points[i].x, polygon.points[i].y,
                        polygon.points[i+1].x, polygon.points[i+1].y,
                    };
                    
                    glVertexPointer(2, GL_FLOAT, 0, line);
                    glEnableClientState(GL_VERTEX_ARRAY);
                    glDrawArrays(GL_LINES, 0, 2);
                }
                
                
                //Renders last line, we do this because of how arrays work.
                GLfloat lineEnd[] = {
                    polygon.points[([polygon pointCount] - 1)].x, polygon.points[([polygon pointCount] - 1)].y,
                    polygon.points[0].x, polygon.points[0].y,
                };
                
                glVertexPointer(2, GL_FLOAT, 0, lineEnd);
                glEnableClientState(GL_VERTEX_ARRAY);
                glDrawArrays(GL_LINES, 0, 2);
                
                glPopMatrix();
            }
        }
    }
}

@end
