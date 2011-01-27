//
//  AbstractProjectile.m
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
//	Last Updated - 1/26/2011 @ 5:20PM - Alexander
//  - Added ability to change location, and also added properties for
//  public vars

#import "AbstractProjectile.h"


@implementation AbstractProjectile

@synthesize turretPosition, currentLocation, desiredLocation, isActive, projectileAngle, projectileSpeed, projectileID;

- (id)initWithProjectileID:(ProjectileID)aProjectileID fromTurretPosition:(Vector2f)aPosition andAngle:(int)aAngle {
    if((self = [super init])){
        
        projectileID = aProjectileID;
        turretPosition = aPosition;
        projectileAngle = aAngle;
        currentLocation = turretPosition;
        
        //Paths for main dictionary
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *path = [[NSString alloc] initWithString:[bundle pathForResource:@"Projectiles" ofType:@"plist"]];
        NSMutableDictionary *dictionaryPlist = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        NSMutableDictionary *projectileDictionary;
        [bundle release];
        [path release];
        
        
        //Load from Plist appropriate bullet type information
        switch(projectileID){
            case kEnemyProjectile_Bullet:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kEnemyProjectile_Bullet"]];
                break;
            case kEnemyProjectile_Missile:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kEnemyProjectile_Missile"]];
                break;
            case kEnemyProjectile_Wave:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kEnemyProjectile_Wave"]];
                break;
            case kPlayerProjectile_Bullet:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kPlayerProjectile_Bullet"]];
                break;
            case kPlayerProjectile_Missile:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kPlayerProjectile_Missile"]];
                break;
            case kPlayerProjectile_Wave:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kPlayerProjectile_Wave"]];
            default:
                break;
        }
        [dictionaryPlist release];
        
        
        projectileSpeed = [[projectileDictionary objectForKey:@"kProjectileSpeed"] intValue];
        
        
        //Loop through the collision points, put them in a C array
        NSArray *tempCollisionPoints = [[NSArray alloc] initWithArray:[projectileDictionary objectForKey:@"kCollisionBoundingPoints"]];
        collisionPointCount = [tempCollisionPoints count];
        collisionPoints = malloc(sizeof(Vector2f) * [tempCollisionPoints count]);
        bzero(collisionPoints, sizeof(Vector2f) * [tempCollisionPoints count]);
        for(int i = 0; i < [tempCollisionPoints count]; i++){
            NSArray *coords = [[NSArray alloc] initWithArray:[[tempCollisionPoints objectAtIndex:i] componentsSeparatedByString:@","]];
            @try {
                collisionPoints[i] = Vector2fMake([[coords objectAtIndex:0] intValue], [[coords objectAtIndex:1] intValue]);
            }
            @catch (NSException * e) {
                NSLog(@"Exception thrown: %@", e);
            }
            @finally {
                NSLog(@"Bullet Coll Coord: %f, %f", collisionPoints[i].x, collisionPoints[i].y);
            }
            [coords release];
        }
        
        
        //Decides how to setup the particle emitter
        switch(projectileID){
            case kPlayerProjectile_Bullet:
                emitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:[projectileDictionary objectForKey:@"kProjectileImage"] 
                                                                            position:Vector2fMake(currentLocation.x, currentLocation.y) 
                                                              sourcePositionVariance:Vector2fZero 
                                                                               speed:projectileSpeed
                                                                       speedVariance:0.0
                                                                    particleLifeSpan:4.0
                                                            particleLifespanVariance:0.0
                                                                               angle:projectileAngle
                                                                       angleVariance:0.0
                                                                             gravity:Vector2fZero
                                                                          startColor:Color4fMake(1.0, 1.0, 1.0, 1.0)
                                                                  startColorVariance:Color4fMake(0.0, 0.0, 0.0, 0.0)
                                                                         finishColor:Color4fMake(1.0, 1.0, 1.0, 1.0)
                                                                 finishColorVariance:Color4fMake(0.0, 0.0, 0.0, 0.0)
                                                                        maxParticles:15.0
                                                                        particleSize:10.0
                                                                  finishParticleSize:10.0
                                                                particleSizeVariance:0.0
                                                                            duration:-1.0
                                                                       blendAdditive:NO];
                //Set up the Polygons for each particle
                polygonArray = [[NSMutableArray alloc] init];
                for(int i = 0; i < [emitter maxParticles]; i++){
                    Polygon *tempPolygon = [[Polygon alloc] initWithPoints:collisionPoints andCount:collisionPointCount andShipPos:CGPointMake(turretPosition.x, turretPosition.y)];
                    [tempPolygon setPos:CGPointMake(emitter.particles[i].position.x, emitter.particles[i].position.y)];
                    [polygonArray addObject:tempPolygon];
                    [tempPolygon release];
                }
                break;
                
            case kPlayerProjectile_Missile:
                image = [[Image alloc] initWithImage:[projectileDictionary objectForKey:@"kProjectileImage"] scale:1.0f];
                missilePolygon = [[Polygon alloc] initWithPoints:collisionPoints andCount:collisionPointCount andShipPos:CGPointMake(turretPosition.x, turretPosition.y)];
                break;
                
            case kPlayerProjectile_Wave:
                emitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:[projectileDictionary objectForKey:@"kProjectileImage"]
                                                                            position:Vector2fMake(currentLocation.x, currentLocation.y) 
                                                              sourcePositionVariance:Vector2fZero
                                                                               speed:projectileSpeed 
                                                                       speedVariance:0.0
                                                                    particleLifeSpan:1.0
                                                            particleLifespanVariance:0.0
                                                                               angle:projectileAngle
                                                                       angleVariance:30.0
                                                                             gravity:Vector2fZero
                                                                          startColor:Color4fMake(1.0, 1.0, 1.0, 1.0)
                                                                  startColorVariance:Color4fMake(0.0, 0.0, 0.0, 0.0)
                                                                         finishColor:Color4fMake(0.0, 0.0, 0.0, 0.8399999737739563)
                                                                 finishColorVariance:Color4fMake(0.0, 0.0, 0.0, 0.0)
                                                                        maxParticles:60
                                                                        particleSize:15.0
                                                                  finishParticleSize:10.0
                                                                particleSizeVariance:0.0
                                                                            duration:-1.0
                                                                       blendAdditive:NO];
                break;
                
                //Enemies:
            case kEnemyProjectile_Bullet:
                emitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:[projectileDictionary objectForKey:@"kProjectileImage"] 
                                                                            position:Vector2fMake(currentLocation.x, currentLocation.y) 
                                                              sourcePositionVariance:Vector2fZero 
                                                                               speed:projectileSpeed
                                                                       speedVariance:0.0 
                                                                    particleLifeSpan:4.0
                                                            particleLifespanVariance:0.0
                                                                               angle:projectileAngle 
                                                                       angleVariance:0.0 
                                                                             gravity:Vector2fZero 
                                                                          startColor:Color4fMake(1.0, 0.0, 0.0, 1.0) 
                                                                  startColorVariance:Color4fMake(0.0, 0.0, 0.0, 0.0) 
                                                                         finishColor:Color4fMake(1.0, 0.0, 0.0, 1.0) 
                                                                 finishColorVariance:Color4fMake(0.0, 0.0, 0.0, 0.0) 
                                                                        maxParticles:15.0
                                                                        particleSize:10.0
                                                                  finishParticleSize:10.0
                                                                particleSizeVariance:0.0
                                                                            duration:-1.0
                                                                       blendAdditive:NO];
                //Set up the Polygons for each particle
                polygonArray = [[NSMutableArray alloc] init];
                for(int i = 0; i < [emitter maxParticles]; i++){
                    Polygon *tempPolygon = [[Polygon alloc] initWithPoints:collisionPoints andCount:collisionPointCount andShipPos:CGPointMake(turretPosition.x, turretPosition.y)];
                    [tempPolygon setPos:CGPointMake(emitter.particles[i].position.x, emitter.particles[i].position.y)];
                    [polygonArray addObject:tempPolygon];
                    [tempPolygon release];
                }
                break;
                
            case kEnemyProjectile_Missile:
                image = [[Image alloc] initWithImage:[projectileDictionary objectForKey:@"kProjectileImage"] scale:1.0f];
                missilePolygon = [[Polygon alloc] initWithPoints:collisionPoints andCount:collisionPointCount andShipPos:CGPointMake(turretPosition.x, turretPosition.y)];
                break;
                
            case kEnemyProjectile_Wave:
                emitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:[projectileDictionary objectForKey:@"kProjectileImage"]
                                                                            position:Vector2fMake(currentLocation.x, currentLocation.y) 
                                                              sourcePositionVariance:Vector2fZero 
                                                                               speed:projectileSpeed
                                                                       speedVariance:0.0
                                                                    particleLifeSpan:4.0
                                                            particleLifespanVariance:0.0
                                                                               angle:projectileAngle
                                                                       angleVariance:30.0
                                                                             gravity:Vector2fZero
                                                                          startColor:Color4fMake(1.0, 0.0, 0.0, 1.0)
                                                                  startColorVariance:Color4fMake(0.0, 0.0, 0.0, 0.0)
                                                                         finishColor:Color4fMake(0.0, 0.0, 0.0, 0.8399999737739563)
                                                                 finishColorVariance:Color4fMake(0.0, 0.0, 0.0, 0.0)
                                                                        maxParticles:30.0
                                                                        particleSize:15.0
                                                                  finishParticleSize:10.0
                                                                particleSizeVariance:0.0
                                                                            duration:-1.0
                                                                       blendAdditive:NO];
                break;
                
            default:
                break;
        }
        
        [tempCollisionPoints release];
        [projectileDictionary release];
        
        isActive = YES;
    }
    
    return self;
}

- (id)initWithParticleID:(ParticleID)aParticleID fromTurretPosition:(Vector2f)aPosition andAngle:(int)aAngle {
    return self;
}

- (void)update:(CGFloat)aDelta {
    if(isActive == NO) return;
        
    switch(projectileID){
        case kPlayerProjectile_Bullet:
            for(int i = 0; i < [emitter maxParticles]; i++){
                [[polygonArray objectAtIndex:i] setPos:CGPointMake(emitter.particles[i].position.x, emitter.particles[i].position.y)];
            }
            [emitter setSourcePosition:Vector2fMake(turretPosition.x, turretPosition.y)];
            [emitter update:aDelta];
            break;
            
        case kPlayerProjectile_Missile:
            elapsedTime += aDelta;
            if(elapsedTime >= 2){
                //If it's been two seconds then reset the position back to where the missile came from
                currentLocation = turretPosition;
                elapsedTime = 0;
            }
            float newAngle = DEGREES_TO_RADIANS(projectileAngle);
            CGPoint vector = CGPointMake(cosf(newAngle), sinf(newAngle));
            currentLocation.x += (projectileSpeed * 10) * aDelta * vector.x;
            currentLocation.y += (projectileSpeed * 10) * aDelta * vector.y;
            [missilePolygon setPos:CGPointMake(turretPosition.x, turretPosition.y)];
            break;
            
        case kPlayerProjectile_Wave:
            [emitter update:aDelta];
            break;
            
        
        case kEnemyProjectile_Bullet:
            for(int i = 0; i < [emitter maxParticles]; i++){
                [[polygonArray objectAtIndex:i] setPos:CGPointMake(emitter.particles[i].position.x, emitter.particles[i].position.y)];
            }
            [emitter update:aDelta];
            [emitter setSourcePosition:Vector2fMake(turretPosition.x, turretPosition.y)];
            break;
            
        case kEnemyProjectile_Missile:
            elapsedTime += aDelta;
            if(elapsedTime >= 2){
                //If it's been two seconds then reset the position back to where the missile came from
                currentLocation = turretPosition;
                elapsedTime = 0;
            }
            float newAngle2 = DEGREES_TO_RADIANS(projectileAngle);
            CGPoint vector2 = CGPointMake(cosf(newAngle2), sinf(newAngle2));
            currentLocation.x += (projectileSpeed * 10) * aDelta * vector2.x;
            currentLocation.y += (projectileSpeed * 10) * aDelta * vector2.y;
            [missilePolygon setPos:CGPointMake(turretPosition.x, turretPosition.y)];
            break;
            
        case kEnemyProjectile_Wave:
            [emitter update:aDelta];
            break;
            
        default:
            break;
    }
    
}

- (void)setFiring:(BOOL)aFire {
    if(aFire == YES){
        isActive = YES;
    }
    else if(aFire == NO){
        isActive = NO;
    }
}

- (void)render {
    if(projectileID == kPlayerProjectile_Bullet || projectileID == kPlayerProjectile_Wave || projectileID == kEnemyProjectile_Bullet || projectileID == kEnemyProjectile_Wave){
        [emitter renderParticles];
    }
    else if(projectileID == kPlayerProjectile_Missile || projectileID == kEnemyProjectile_Missile){
        [image renderAtPoint:CGPointMake(currentLocation.x, currentLocation.y) centerOfImage:YES];
    }
    //From PlayerShip class
    if(DEBUG) { 
        for(Polygon *polygon in polygonArray){
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

- (void)dealloc {
    [emitter release];
    [image release];
    [polygonArray release];
    free(collisionPoints);
    [super dealloc];
}

@end
