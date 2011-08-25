//
//  BulletProjectile.m
//  Xenophobe
//
//  Created by James Linnell on 8/5/11.
//  Copyright 2011 PDHS. All rights reserved.
//

#import "BulletProjectile.h"

@implementation BulletProjectile

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
            case kPlayerProjectile_BulletLevelOne_Single:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kPlayerProjectile_BulletLevelOne_Single"]];
                break;
            case kPlayerProjectile_BulletLevelTwo_Double:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kPlayerProjectile_BulletLevelTwo_Double"]];
                break;
            case kPlayerProjectile_BulletLevelThree_Double:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kPlayerProjectile_BulletLevelThree_Double"]];
                break;
            case kPlayerProjectile_BulletLevelFour_Triple:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kPlayerProjectile_BulletLevelFour_Triple"]];
                break;
            case kPlayerProjectile_BulletLevelFive_Triple:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kPlayerProjectile_BulletLevelFive_Triple"]];
                break;
            case kPlayerProjectile_BulletLevelSix_Quadruple:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kPlayerProjectile_BulletLevelSix_Quadruple"]];
                break;
            case kPlayerProjectile_BulletLevelSeven_Quadruple:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kPlayerProjectile_BulletLevelSeven_Quadruple"]];
                break;
            case kPlayerProjectile_BulletLevelEight_Quintuple:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kPlayerProjectile_BulletLevelEight_Quintuple"]];
                break;
            case kPlayerProjectile_BulletLevelNine_Quintuple:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kPlayerProjectile_BulletLevelNine_Quintuple"]];
                break;
            case kPlayerProjectile_BulletLevelTen_Septuple:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kPlayerProjectile_BulletLevelTen_Septuple"]];
                break;
                
                
            case kEnemyProjectile_BulletLevelOne_Single:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kEnemyProjectile_BulletLevelOne_Single"]];
                break;
            case kEnemyProjectile_BulletLevelTwo_Double:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kEnemyProjectile_BulletLevelTwo_Double"]];
                break;
            case kEnemyProjectile_BulletLevelThree_Double:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kEnemyProjectile_BulletLevelThree_Double"]];
                break;
            case kEnemyProjectile_BulletLevelFour_Triple:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kEnemyProjectile_BulletLevelFour_Triple"]];
                break;
            case kEnemyProjectile_BulletLevelFive_Triple:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kEnemyProjectile_BulletLevelFive_Triple"]];
                break;
            case kEnemyProjectile_BulletLevelSix_Quadruple:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kEnemyProjectile_BulletLevelSix_Quadruple"]];
                break;
            case kEnemyProjectile_BulletLevelSeven_Quadruple:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kEnemyProjectile_BulletLevelSeven_Quadruple"]];
                break;
            case kEnemyProjectile_BulletLevelEight_Quintuple:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kEnemyProjectile_BulletLevelEight_Quintuple"]];
                break;
            case kEnemyProjectile_BulletLevelNine_Quintuple:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kEnemyProjectile_BulletLevelNine_Quintuple"]];
                break;
            case kEnemyProjectile_BulletLevelTen_Septuple:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kEnemyProjectile_BulletLevelTen_Septuple"]];
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
        collisionPoints[0] = Vector2fMake(0, 4);
        collisionPoints[1] = Vector2fMake(4, 0);
        collisionPoints[2] = Vector2fMake(0, -4);
        collisionPoints[3] = Vector2fMake(-4, 0);
        
        
        
        
        switch(projectileID){
            case kEnemyProjectile_BulletLevelOne_Single:
            case kPlayerProjectile_BulletLevelOne_Single: {
                /*
                        |
                        |
                        |
                        |
                        |
                        0
                 */
                ParticleEmitter *tempEmitter = [self newBulletEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                
                NSArray *tempArray = [self newArrayOfPolygonsWithCount:[[emitters objectAtIndex:0] maxParticles]];
                [polygons addObject:tempArray];
                [tempArray release];
                break;
            }
            
            case kEnemyProjectile_BulletLevelTwo_Double:
            case kPlayerProjectile_BulletLevelTwo_Double: {
                /*
                        |   |
                        |   |
                        |   |
                        |   |
                        |   |
                        0   1
                 */
                ParticleEmitter *tempEmitter = [self newBulletEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                tempEmitter = [self newBulletEmitter];
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
            
            case kEnemyProjectile_BulletLevelThree_Double:
            case kPlayerProjectile_BulletLevelThree_Double: {
                /*
                        |   |
                        |   |
                        |   |
                        |   |
                        |   |
                        0   1
                 */
                ParticleEmitter *tempEmitter = [self newBulletEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                tempEmitter = [self newBulletEmitter];
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
                
            case kEnemyProjectile_BulletLevelFour_Triple:
            case kPlayerProjectile_BulletLevelFour_Triple: {
                /*
                   \        |        /
                    \       |       /
                     \      |      /
                      \     |     /
                       \    |    /
                        0   1   2
                 */
                ParticleEmitter *tempEmitter = [self newBulletEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                tempEmitter = [self newBulletEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                tempEmitter = [self newBulletEmitter];
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
                
            case kEnemyProjectile_BulletLevelFive_Triple:
            case kPlayerProjectile_BulletLevelFive_Triple: {
                /*
                   \        |        /
                    \       |       /
                     \      |      /
                      \     |     /
                       \    |    /
                        0   1   2
                 */
                ParticleEmitter *tempEmitter = [self newBulletEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                tempEmitter = [self newBulletEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                tempEmitter = [self newBulletEmitter];
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
            
            case kEnemyProjectile_BulletLevelSix_Quadruple:
            case kPlayerProjectile_BulletLevelSix_Quadruple: {
                /*
                   \     |   |     /
                    \    |   |    /
                     \   |   |   /
                      \  |   |  /
                       \ |   | /   
                        01   23
                 */
                ParticleEmitter *tempEmitter = [self newBulletEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                tempEmitter = [self newBulletEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                tempEmitter = [self newBulletEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                tempEmitter = [self newBulletEmitter];
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
             
            case kEnemyProjectile_BulletLevelSeven_Quadruple:
            case kPlayerProjectile_BulletLevelSeven_Quadruple: {
                /*
                   \     |   |     /
                    \    |   |    /
                     \   |   |   /
                      \  |   |  /
                       \ |   | /   
                        01   23
                 */
                ParticleEmitter *tempEmitter = [self newBulletEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                tempEmitter = [self newBulletEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                tempEmitter = [self newBulletEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                tempEmitter = [self newBulletEmitter];
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
             
            case kEnemyProjectile_BulletLevelEight_Quintuple:
            case kPlayerProjectile_BulletLevelEight_Quintuple: {
                /*
                   \     |  |  |     /
                    \    |  |  |    /
                     \   |  |  |   /
                      \  |  |  |  /
                       \ |  |  | /
                        01  2  34
                 */
                ParticleEmitter *tempEmitter = [self newBulletEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                tempEmitter = [self newBulletEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                tempEmitter = [self newBulletEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                tempEmitter = [self newBulletEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                tempEmitter = [self newBulletEmitter];
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
                
            case kEnemyProjectile_BulletLevelNine_Quintuple:
            case kPlayerProjectile_BulletLevelNine_Quintuple: {
                /*
                   \     |  |  |     /
                    \    |  |  |    /
                     \   |  |  |   /
                      \  |  |  |  /
                       \ |  |  | /
                        01  2  34
                 */
                ParticleEmitter *tempEmitter = [self newBulletEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                tempEmitter = [self newBulletEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                tempEmitter = [self newBulletEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                tempEmitter = [self newBulletEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                tempEmitter = [self newBulletEmitter];
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
                
            case kEnemyProjectile_BulletLevelTen_Septuple:
            case kPlayerProjectile_BulletLevelTen_Septuple: {
                /*     7.5°         7.5°
                   \   |  |  |  |   |  /
                    \  \  |  |  |   / /
                     \  | |  |  |  | /
                      \ \ |  |  | / /
                15°>   \ ||  |  || /  <15°
                        012  3  456
                 */
                ParticleEmitter *tempEmitter = [self newBulletEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                tempEmitter = [self newBulletEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                tempEmitter = [self newBulletEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                tempEmitter = [self newBulletEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                tempEmitter = [self newBulletEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                tempEmitter = [self newBulletEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                tempEmitter = [self newBulletEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];

                
                [[emitters objectAtIndex:0] setSourcePosition:Vector2fAdd([[emitters objectAtIndex:0] sourcePosition], Vector2fMake(-20, 0))];
                [[emitters objectAtIndex:1] setSourcePosition:Vector2fAdd([[emitters objectAtIndex:1] sourcePosition], Vector2fMake(-20, 0))];
                [[emitters objectAtIndex:2] setSourcePosition:Vector2fAdd([[emitters objectAtIndex:2] sourcePosition], Vector2fMake(-20, 0))];
                [[emitters objectAtIndex:4] setSourcePosition:Vector2fAdd([[emitters objectAtIndex:4] sourcePosition], Vector2fMake(20, 0))];
                [[emitters objectAtIndex:5] setSourcePosition:Vector2fAdd([[emitters objectAtIndex:5] sourcePosition], Vector2fMake(20, 0))];
                [[emitters objectAtIndex:6] setSourcePosition:Vector2fAdd([[emitters objectAtIndex:6] sourcePosition], Vector2fMake(20, 0))];
                
                [[emitters objectAtIndex:0] setAngle:([[emitters objectAtIndex:0] angle] + 15)];
                [[emitters objectAtIndex:6] setAngle:([[emitters objectAtIndex:6] angle] - 15)];
                
                [[emitters objectAtIndex:1] setAngle:([[emitters objectAtIndex:1] angle] + 7.5)];
                [[emitters objectAtIndex:5] setAngle:([[emitters objectAtIndex:5] angle] - 7.5)];
                
                
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
                tempArray = [self newArrayOfPolygonsWithCount:[[emitters objectAtIndex:6] maxParticles]];
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
        case kEnemyProjectile_BulletLevelOne_Single:
        case kPlayerProjectile_BulletLevelOne_Single: {
            [[emitters objectAtIndex:0] setSourcePosition:Vector2fMake(location.x, location.y)];
            break;
        }
            
        case kEnemyProjectile_BulletLevelTwo_Double:
        case kPlayerProjectile_BulletLevelTwo_Double: {
            [[emitters objectAtIndex:0] setSourcePosition:Vector2fMake(location.x - 20, location.y)];
            [[emitters objectAtIndex:1] setSourcePosition:Vector2fMake(location.x + 20, location.y)];
            break;
        }
            
        case kEnemyProjectile_BulletLevelThree_Double:
        case kPlayerProjectile_BulletLevelThree_Double: {
            [[emitters objectAtIndex:0] setSourcePosition:Vector2fMake(location.x - 20, location.y)];
            [[emitters objectAtIndex:1] setSourcePosition:Vector2fMake(location.x + 20, location.y)];
            break;
        }
            
        case kEnemyProjectile_BulletLevelFour_Triple:
        case kPlayerProjectile_BulletLevelFour_Triple: {
            [[emitters objectAtIndex:0] setSourcePosition:Vector2fMake(location.x - 20, location.y)];
            [[emitters objectAtIndex:1] setSourcePosition:Vector2fMake(location.x, location.y)];
            [[emitters objectAtIndex:2] setSourcePosition:Vector2fMake(location.x + 20, location.y)];
            break;
        }
            
        case kEnemyProjectile_BulletLevelFive_Triple:
        case kPlayerProjectile_BulletLevelFive_Triple: {
            [[emitters objectAtIndex:0] setSourcePosition:Vector2fMake(location.x - 20, location.y)];
            [[emitters objectAtIndex:1] setSourcePosition:Vector2fMake(location.x, location.y)];
            [[emitters objectAtIndex:2] setSourcePosition:Vector2fMake(location.x + 20, location.y)];
            break;
        }
            
        case kEnemyProjectile_BulletLevelSix_Quadruple:
        case kPlayerProjectile_BulletLevelSix_Quadruple: {
            [[emitters objectAtIndex:0] setSourcePosition:Vector2fMake(location.x - 20, location.y)];
            [[emitters objectAtIndex:1] setSourcePosition:Vector2fMake(location.x - 20, location.y)];
            [[emitters objectAtIndex:2] setSourcePosition:Vector2fMake(location.x + 20, location.y)];
            [[emitters objectAtIndex:3] setSourcePosition:Vector2fMake(location.x + 20, location.y)];
            break;
        }
            
        case kEnemyProjectile_BulletLevelSeven_Quadruple:
        case kPlayerProjectile_BulletLevelSeven_Quadruple: {
            [[emitters objectAtIndex:0] setSourcePosition:Vector2fMake(location.x - 20, location.y)];
            [[emitters objectAtIndex:1] setSourcePosition:Vector2fMake(location.x - 20, location.y)];
            [[emitters objectAtIndex:2] setSourcePosition:Vector2fMake(location.x + 20, location.y)];
            [[emitters objectAtIndex:3] setSourcePosition:Vector2fMake(location.x + 20, location.y)];
            break;
        }
            
        case kEnemyProjectile_BulletLevelEight_Quintuple:
        case kPlayerProjectile_BulletLevelEight_Quintuple: {
            [[emitters objectAtIndex:0] setSourcePosition:Vector2fMake(location.x - 20, location.y)];
            [[emitters objectAtIndex:1] setSourcePosition:Vector2fMake(location.x - 20, location.y)];
            [[emitters objectAtIndex:2] setSourcePosition:Vector2fMake(location.x, location.y)];
            [[emitters objectAtIndex:3] setSourcePosition:Vector2fMake(location.x + 20, location.y)];
            [[emitters objectAtIndex:4] setSourcePosition:Vector2fMake(location.x + 20, location.y)];
            break;
        }
            
        case kEnemyProjectile_BulletLevelNine_Quintuple:
        case kPlayerProjectile_BulletLevelNine_Quintuple: {
            [[emitters objectAtIndex:0] setSourcePosition:Vector2fMake(location.x - 20, location.y)];
            [[emitters objectAtIndex:1] setSourcePosition:Vector2fMake(location.x - 20, location.y)];
            [[emitters objectAtIndex:2] setSourcePosition:Vector2fMake(location.x, location.y)];
            [[emitters objectAtIndex:3] setSourcePosition:Vector2fMake(location.x + 20, location.y)];
            [[emitters objectAtIndex:4] setSourcePosition:Vector2fMake(location.x + 20, location.y)];
            break;
        }
            
        case kEnemyProjectile_BulletLevelTen_Septuple:
        case kPlayerProjectile_BulletLevelTen_Septuple: {
            [[emitters objectAtIndex:0] setSourcePosition:Vector2fMake(location.x - 20, location.y)];
            [[emitters objectAtIndex:1] setSourcePosition:Vector2fMake(location.x - 20, location.y)];
            [[emitters objectAtIndex:2] setSourcePosition:Vector2fMake(location.x - 20, location.y)];
            [[emitters objectAtIndex:3] setSourcePosition:Vector2fMake(location.x, location.y)];
            [[emitters objectAtIndex:4] setSourcePosition:Vector2fMake(location.x + 20, location.y)];
            [[emitters objectAtIndex:5] setSourcePosition:Vector2fMake(location.x + 20, location.y)];
            [[emitters objectAtIndex:6] setSourcePosition:Vector2fMake(location.x + 20, location.y)];
            
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
        [[emitters objectAtIndex:emitterPolyCount] setAngle:angle];
        
        [[emitters objectAtIndex:emitterPolyCount] update:aDelta];
        
        for(int k = 0; k < [[emitters objectAtIndex:emitterPolyCount] particleIndex]; k++){
//        for(int k = 0; k < [[polygons objectAtIndex:emitterPolyCount] count]; k++){
            [[[polygons objectAtIndex:emitterPolyCount] objectAtIndex:k] setPos:CGPointMake([[emitters objectAtIndex:emitterPolyCount] particles][k].position.x, 
                                                                                            [[emitters objectAtIndex:emitterPolyCount] particles][k].position.y)];
        }
    }
}

- (ParticleEmitter *)newBulletEmitter {
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
                                                                                 particleSize:15.0
                                                                           finishParticleSize:15.0
                                                                         particleSizeVariance:0.0
                                                                                     duration:-1.0
                                                                                blendAdditive:YES];
    
    if(projectileID >= kEnemyProjectile_BulletLevelOne_Single && projectileID <= kEnemyProjectile_BulletLevelTen_Septuple){
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
