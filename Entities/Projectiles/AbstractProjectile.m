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
//
//  Last Updated - 1/18/2011 @10PM - Alexander
//  - Changed player bullet to fade and get smaller as the projectile
//  moves across the screen
//
//  Last Updated - 6/13/2011 @ 5:40PM - James
//  - Stopped rendering of all objects when projectile is
//  set to inactive.
//
//  Last Updated - 6/15/2011 @12:40PM - James
//  - Removed setFiring: method, added pauseProj, playProj, and stopProj
//  to differentiate between needs, play/pause for pause screen, stop for
//  not rendering projectile.
//
//	Last Updated - 6/15/2011 @ 3:30PM - Alexander
//	- Support for new Scale2f vector scaling system
//
//  Last updated - 6/22/2011 @ 11PM - James
//  - Deprecated missilePolygon and particlePolyon. Replaced with 
//  using the first(0th) polygon object in the polygonsArray
//
//  Last Updated - 6/23/2011 @ 3:30PM - James
//  - Forgot to allocate polygons for missiles and particles :\
//
//  Last Updated - 7/20/11 @5:40PM - James
//  - Adjusted size/speed of Player/Enemy bullets, enabled blend
//  additive, for bullets the emitter renders twice to get the blend additive
//  to look nice and bright.
//
//  Last Updated - 7/22/11 @5PM - James
//  - Made sure to move emitter bullets off screen when stopping projectile
//
//  Last updated - 7/26/11 @2PM - James
//  - Adjusted stopProjectile to stop them efficiently-er

#import "AbstractProjectile.h"


@implementation AbstractProjectile

@synthesize turretPosition, currentLocation, desiredLocation, isActive, projectileAngle, projectileSpeed, projectileID, polygonArray, emitter, isStopped;

- (id)initWithProjectileID:(ProjectileID)aProjectileID fromTurretPosition:(Vector2f)aPosition andAngle:(int)aAngle emissionRate:(int)aRate {
    if((self = [super init])){
        
        projectileID = aProjectileID;
        idType = [[NSString alloc] initWithString:@"Projectile"];
        turretPosition = aPosition;
        projectileAngle = aAngle;
        currentLocation = turretPosition;
        rateOfFire = aRate;
        
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
        
        
        projectileSpeed = [[projectileDictionary objectForKey:@"kProjectileSpeed"] floatValue];
        
        
        //Loop through the collision points, put them in a C array
        NSArray *tempCollisionPoints = [[NSArray alloc] initWithArray:[projectileDictionary objectForKey:@"kCollisionBoundingPoints"]];
        collisionPointCount = [tempCollisionPoints count];
        collisionPoints = malloc(sizeof(Vector2f) * collisionPointCount);
        bzero(collisionPoints, sizeof(Vector2f) * collisionPointCount);
        for(int i = 0; i < collisionPointCount; i++){
            NSArray *coords = [[NSArray alloc] initWithArray:[[tempCollisionPoints objectAtIndex:i] componentsSeparatedByString:@","]];
            @try {
                collisionPoints[i] = Vector2fMake([[coords objectAtIndex:0] intValue], [[coords objectAtIndex:1] intValue]);
            }
            @catch (NSException * e) {
                NSLog(@"Exception thrown: %@", e);
            }
            @finally {
            }
            [coords release];
        }
        
        nameOfImage = [[projectileDictionary objectForKey:@"kProjectileImage"] copy];
        
        //Decides how to setup the particle emitter
        switch(projectileID){
            case kPlayerProjectile_Bullet:
                emitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:nameOfImage
                                                                            position:Vector2fMake(currentLocation.x, currentLocation.y) 
                                                              sourcePositionVariance:Vector2fZero 
                                                                               speed:projectileSpeed
                                                                       speedVariance:0.0
                                                                    particleLifeSpan:4.0
                                                            particleLifespanVariance:0.0
                                                                               angle:projectileAngle
                                                                       angleVariance:0.0
                                                                             gravity:Vector2fZero
                                                                          startColor:Color4fMake(0.8, 0.8, 1.0, 1.0)
                                                                  startColorVariance:Color4fMake(0.0, 0.0, 0.0, 0.0)
                                                                         finishColor:Color4fMake(0.8, 0.8, 1.0, 1.0)
                                                                 finishColorVariance:Color4fMake(0.0, 0.0, 0.0, 0.0)
                                                                        maxParticles:10.0
                                                                        particleSize:15.0
                                                                  finishParticleSize:15.0
                                                                particleSizeVariance:0.0
                                                                            duration:-1.0
                                                                       blendAdditive:YES];
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
                polygonArray = [[NSMutableArray alloc] init];
                image = [[Image alloc] initWithImage:[projectileDictionary objectForKey:@"kProjectileImage"] scale:Scale2fOne];
                [polygonArray addObject:[[Polygon alloc] initWithPoints:collisionPoints andCount:collisionPointCount andShipPos:CGPointMake(turretPosition.x, turretPosition.y)]];
                isAlive = YES;
                break;
                
            case kPlayerProjectile_Wave:
                emitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:nameOfImage
                                                                            position:Vector2fMake(currentLocation.x, currentLocation.y) 
                                                              sourcePositionVariance:Vector2fZero
                                                                               speed:projectileSpeed 
                                                                       speedVariance:0.0
                                                                    particleLifeSpan:4.0
                                                            particleLifespanVariance:0.0
                                                                               angle:projectileAngle
                                                                       angleVariance:30.0
                                                                             gravity:Vector2fZero
                                                                          startColor:Color4fMake(1.0, 1.0, 1.0, 1.0)
                                                                  startColorVariance:Color4fMake(0.0, 0.0, 0.0, 0.0)
                                                                         finishColor:Color4fMake(1.0, 1.0, 1.0, 1.0)
                                                                 finishColorVariance:Color4fMake(0.0, 0.0, 0.0, 0.0)
                                                                        maxParticles:50.0
                                                                        particleSize:15.0
                                                                  finishParticleSize:15.0
                                                                particleSizeVariance:0.0
                                                                            duration:0.1
                                                                       blendAdditive:YES];
                emitter.emissionRate = 5000;
                emitter.fastEmission = YES;
                polygonArray = [[NSMutableArray alloc] init];
                for(int i = 0; i < emitter.maxParticles; i++){
                    Polygon *tempPolygon = [[Polygon alloc] initWithPoints:collisionPoints andCount:collisionPointCount andShipPos:CGPointMake(turretPosition.x, turretPosition.y)];
                    [tempPolygon setPos:CGPointMake(emitter.particles[i].position.x, emitter.particles[i].position.y)];
                    [polygonArray addObject:tempPolygon];
                    [tempPolygon release];
                }
                break;
                
                //Enemies:
            case kEnemyProjectile_Bullet:
                emitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:nameOfImage 
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
                                                                        maxParticles:3.0
                                                                        particleSize:15.0
                                                                  finishParticleSize:15.0
                                                                particleSizeVariance:0.0
                                                                            duration:-1.0
                                                                       blendAdditive:YES];
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
                polygonArray = [[NSMutableArray alloc] init];
                image = [[Image alloc] initWithImage:[projectileDictionary objectForKey:@"kProjectileImage"] scale:Scale2fOne];
                [polygonArray addObject:[[Polygon alloc] initWithPoints:collisionPoints andCount:collisionPointCount andShipPos:CGPointMake(turretPosition.x, turretPosition.y)]];
                isAlive = YES;
                break;
                
            case kEnemyProjectile_Wave:
                emitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:nameOfImage
                                                                            position:Vector2fMake(currentLocation.x, currentLocation.y) 
                                                              sourcePositionVariance:Vector2fZero 
                                                                               speed:projectileSpeed
                                                                       speedVariance:0.0
                                                                    particleLifeSpan:0.0
                                                            particleLifespanVariance:2.0
                                                                               angle:projectileAngle
                                                                       angleVariance:15.0
                                                                             gravity:Vector2fZero
                                                                          startColor:Color4fMake(1.0, 0.0, 0.0, 1.0)
                                                                  startColorVariance:Color4fMake(0.0, 0.0, 0.0, 0.0)
                                                                         finishColor:Color4fMake(1.0, 0.0, 0.0, 1.0)
                                                                 finishColorVariance:Color4fMake(0.0, 0.0, 0.0, 0.0)
                                                                        maxParticles:100.0
                                                                        particleSize:15.0
                                                                  finishParticleSize:15.0
                                                                particleSizeVariance:0.0
                                                                            duration:0.01
                                                                       blendAdditive:YES];
                emitter.fastEmission = YES;
                polygonArray = [[NSMutableArray alloc] init];
                for(int i = 0; i < emitter.maxParticles; i++){
                    Polygon *tempPolygon = [[Polygon alloc] initWithPoints:collisionPoints andCount:collisionPointCount andShipPos:CGPointMake(turretPosition.x, turretPosition.y)];
                    [tempPolygon setPos:CGPointMake(emitter.particles[i].position.x, emitter.particles[i].position.y)];
                    [polygonArray addObject:tempPolygon];
                    [tempPolygon release];
                }
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

- (id)initWithParticleID:(ParticleID)aParticleID fromTurretPosition:(Vector2f)aPosition radius:(int)aRadius rateOfFire:(int)aRate andAngle:(int)aAngle {
    if((self = [super init])){
        
        particleID = aParticleID;
        idType = [[NSString alloc] initWithString:@"Particle"];
        turretPosition = aPosition;
        currentLocation = turretPosition;
        projectileAngle = aAngle;
        particleRadius = aRadius;
        rateOfFire = aRate;
        
        projectileSpeed = (1.0/rateOfFire) * 3;
        
        
        //Because we have a radius, we can manually make our collision points
        collisionPointCount = 4;
        collisionPoints = malloc(sizeof(Vector2f) * collisionPointCount);
        bzero(collisionPoints, sizeof(Vector2f) * collisionPointCount);
        //Manually assign points
        collisionPoints[0] = Vector2fMake(particleRadius, 0);
        collisionPoints[1] = Vector2fMake(0, particleRadius);
        collisionPoints[2] = Vector2fMake(-1 * particleRadius, 0);
        collisionPoints[3] = Vector2fMake(0, -1 * particleRadius);
        
        polygonArray = [[NSMutableArray alloc] init];
        [polygonArray addObject:[[[Polygon alloc] initWithPoints:collisionPoints andCount:collisionPointCount andShipPos:CGPointMake(currentLocation.x, currentLocation.y)] autorelease]];
        
        
        
        switch(particleID){
            case kPlayerParticle:
                emitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
                                                                            position:turretPosition
                                                              sourcePositionVariance:Vector2fZero
                                                                               speed:0.8
                                                                       speedVariance:0.0
                                                                    particleLifeSpan:0.3
                                                            particleLifespanVariance:0.1
                                                                               angle:projectileAngle
                                                                       angleVariance:0.0
                                                                             gravity:Vector2fZero
                                                                          startColor:Color4fMake(0.12, 0.25, 0.75, 1.0)
                                                                  startColorVariance:Color4fMake(0.0, 0.0, 0.0, 0.0)
                                                                         finishColor:Color4fMake(0.1, 0.1, 0.5, 1.0)
                                                                 finishColorVariance:Color4fMake(0.05, 0.05, 0.3, 0.0)
                                                                        maxParticles:40.0
                                                                        particleSize:particleAngle * 2.5
                                                                  finishParticleSize:particleAngle * 2.5
                                                                particleSizeVariance:0.0
                                                                            duration:-1.0
                                                                       blendAdditive:YES];
                break;
                
            case kEnemyParticle:
                emitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
                                                                            position:turretPosition
                                                              sourcePositionVariance:Vector2fZero
                                                                               speed:0.8
                                                                       speedVariance:0.1
                                                                    particleLifeSpan:0.2
                                                            particleLifespanVariance:0.1
                                                                               angle:projectileAngle
                                                                       angleVariance:0.0
                                                                             gravity:Vector2fZero
                                                                          startColor:Color4fMake(0.75, 0.25, 0.12, 1.0)
                                                                  startColorVariance:Color4fMake(0.0, 0.0, 0.0, 0.0)
                                                                         finishColor:Color4fMake(0.5, 0.1, 0.1, 1.0)
                                                                 finishColorVariance:Color4fMake(0.3, 0.05, 0.05, 0.0)
                                                                        maxParticles:40.0
                                                                        particleSize:particleRadius * 2.5
                                                                  finishParticleSize:particleRadius * 2.5
                                                                particleSizeVariance:0.0
                                                                            duration:-1.0
                                                                       blendAdditive:YES];
                break;
                
            default:
                break;
        }
        isActive = YES;
    }
    return self;
}

- (void)update:(CGFloat)aDelta {
    if(isActive == NO) return;
    //Switch between projectile or particle
    if([idType isEqualToString:@"Projectile"] == TRUE){
        switch(projectileID){
            case kPlayerProjectile_Bullet:
                [emitter setSourcePosition:Vector2fMake(turretPosition.x, turretPosition.y)];
                [emitter update:aDelta];
                for(Polygon *tempPoly in polygonArray){
                    [tempPoly setPos:CGPointMake(-50, -50)];
                }
                for(int i = 0; i < [emitter particleIndex]; i++){
                    [[polygonArray objectAtIndex:i] setPos:CGPointMake(emitter.particles[i].position.x, emitter.particles[i].position.y)];
                }
                break;
                
            case kPlayerProjectile_Missile:
                elapsedTime += aDelta;
                if(elapsedTime >= rateOfFire){
                    //If it's been two seconds then reset the position back to where the missile came from
                    currentLocation = turretPosition;
                    elapsedTime = 0;
                }
                float newAngle = DEGREES_TO_RADIANS(projectileAngle);
                CGPoint vector = CGPointMake(cosf(newAngle), sinf(newAngle));
                currentLocation.x += (projectileSpeed * 15) * aDelta * vector.x;
                currentLocation.y += (projectileSpeed * 15) * aDelta * vector.y;
                [[polygonArray objectAtIndex:0] setPos:CGPointMake(currentLocation.x, currentLocation.y)];
                break;
                
            case kPlayerProjectile_Wave:
                elapsedTime += aDelta;
                if(elapsedTime >= rateOfFire){
                    [emitter stopParticleEmitter];
                    [emitter release];
                    emitter = nil;
                    emitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:nameOfImage
                                                                                position:Vector2fMake(currentLocation.x, currentLocation.y) 
                                                                  sourcePositionVariance:Vector2fZero
                                                                                   speed:projectileSpeed 
                                                                           speedVariance:0.0
                                                                        particleLifeSpan:4.0
                                                                particleLifespanVariance:0.0
                                                                                   angle:projectileAngle
                                                                           angleVariance:30.0
                                                                                 gravity:Vector2fZero
                                                                              startColor:Color4fMake(1.0, 1.0, 1.0, 1.0)
                                                                      startColorVariance:Color4fMake(0.0, 0.0, 0.0, 0.0)
                                                                             finishColor:Color4fMake(1.0, 1.0, 1.0, 1.0)
                                                                     finishColorVariance:Color4fMake(0.0, 0.0, 0.0, 0.0)
                                                                            maxParticles:50.0
                                                                            particleSize:15.0
                                                                      finishParticleSize:15.0
                                                                    particleSizeVariance:0.0
                                                                                duration:0.1
                                                                           blendAdditive:YES];
                    emitter.emissionRate = 5000;
                    emitter.fastEmission = YES;
                    elapsedTime = 0;
                }
                for(int i = 0; i < emitter.maxParticles; i++){
                    //If the particle died
                    if(emitter.particles[i].timeToLive >= 0){
                        [[polygonArray objectAtIndex:i] setPos:CGPointMake(emitter.particles[i].position.x, emitter.particles[i].position.y)];
                    }
                    else {
                        [[polygonArray objectAtIndex:i] setPos:CGPointMake(6, 16)];
                    }
                }
                [emitter setSourcePosition:Vector2fMake(turretPosition.x, turretPosition.y)];
                [emitter update:aDelta];
                break;
                
                
            case kEnemyProjectile_Bullet:
                [emitter setSourcePosition:Vector2fMake(turretPosition.x, turretPosition.y)];
                [emitter update:aDelta];
                for(Polygon *tempPoly in polygonArray){
                    [tempPoly setPos:CGPointMake(-50, -50)];
                }
                for(int i = 0; i < [emitter particleIndex]; i++){
                    [[polygonArray objectAtIndex:i] setPos:CGPointMake(emitter.particles[i].position.x, emitter.particles[i].position.y)];
                }
                break;
                
            case kEnemyProjectile_Missile:
                elapsedTime += aDelta;
                if(elapsedTime >= rateOfFire){
                    //If it's been two seconds then reset the position back to where the missile came from
                    currentLocation = turretPosition;
                    elapsedTime = 0;
                }
                float newAngle2 = DEGREES_TO_RADIANS(projectileAngle);
                CGPoint vector2 = CGPointMake(cosf(newAngle2), sinf(newAngle2));
                currentLocation.x += (projectileSpeed * 15) * aDelta * vector2.x;
                currentLocation.y += (projectileSpeed * 15) * aDelta * vector2.y;
                [[polygonArray objectAtIndex:0] setPos:CGPointMake(currentLocation.x, currentLocation.y)];
                break;
                
            case kEnemyProjectile_Wave:
                elapsedTime += aDelta;
                if(elapsedTime >= rateOfFire){
                    [emitter stopParticleEmitter];
                    [emitter release];
                    emitter = nil;
                    emitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:nameOfImage
                                                                                position:Vector2fMake(currentLocation.x, currentLocation.y) 
                                                                  sourcePositionVariance:Vector2fZero 
                                                                                   speed:projectileSpeed
                                                                           speedVariance:0.0
                                                                        particleLifeSpan:0.0
                                                                particleLifespanVariance:2.0
                                                                                   angle:projectileAngle
                                                                           angleVariance:15.0
                                                                                 gravity:Vector2fZero
                                                                              startColor:Color4fMake(1.0, 0.0, 0.0, 1.0)
                                                                      startColorVariance:Color4fMake(0.0, 0.0, 0.0, 0.0)
                                                                             finishColor:Color4fMake(1.0, 0.0, 0.0, 1.0)
                                                                     finishColorVariance:Color4fMake(0.0, 0.0, 0.0, 0.0)
                                                                            maxParticles:100.0
                                                                            particleSize:15.0
                                                                      finishParticleSize:15.0
                                                                    particleSizeVariance:0.0
                                                                                duration:0.01
                                                                           blendAdditive:YES];
                    emitter.fastEmission = YES;
                    
                    elapsedTime = 0;
                }
                for(int i = 0; i < emitter.maxParticles; i++){
                    [[polygonArray objectAtIndex:i] setPos:CGPointMake(emitter.particles[i].position.x, emitter.particles[i].position.y)];
                }
                [emitter update:aDelta];
                break;
                
            default:
                break;
        }
    }
    
    //Particle updating
    else if([idType isEqualToString:@"Particle"] == TRUE){
        elapsedTime += aDelta;
        //Re-initialize our emitter
        if(elapsedTime >= rateOfFire){

            elapsedTime = 0;
            
            switch(particleID){
                case kPlayerParticle:
                    emitter.sourcePosition = turretPosition;
                    break;
                    
                case kEnemyParticle:
                    emitter.sourcePosition = turretPosition;
                    break;
                    
                default:
                    break;
            }
            particleAngle = DEGREES_TO_RADIANS(projectileAngle);
            particleVector = CGPointMake(cosf(particleAngle), sinf(particleAngle));
            emitter.angle = projectileAngle;
        }
        Vector2f tempPos = emitter.sourcePosition;
        tempPos.x += (projectileSpeed * 15 * 5) * aDelta * particleVector.x;
        tempPos.y += (projectileSpeed * 15 * 5) * aDelta * particleVector.y;
        emitter.sourcePosition = tempPos;
        
        [[polygonArray objectAtIndex:0] setPos:CGPointMake(emitter.sourcePosition.x, emitter.sourcePosition.y)];
        
        [emitter update:aDelta];
    }
    
}

- (void)pauseProjectile {
    //This merely tells the class to stop updating the projectiles, mainly for use on pause screen
    
    isActive = NO;
    
}

- (void)playProjectile {
    //Reverses the ffect of pauseProjectile, mainly for when pause screen goes away
    
    isActive = YES;
    emitter.active = YES;
    isStopped = NO;
}

- (void)stopProjectile {
    //Used when we want to stop updating AND rendering our projectile.
    //The owner of the class uses this so it doesn't have to deallocate the projectile on ship death
    isStopped = YES;
    [emitter stopParticleEmitter];
}

- (void)render {
    if([idType isEqualToString:@"Projectile"] == TRUE){
        if(projectileID == kPlayerProjectile_Bullet || projectileID == kPlayerProjectile_Wave || projectileID == kEnemyProjectile_Bullet || projectileID == kEnemyProjectile_Wave){
            [emitter renderParticles];
            if(projectileID == kPlayerProjectile_Bullet || projectileID == kEnemyProjectile_Bullet){
                //Re-render is to make them look brighter using the BlendAdditive option
                [emitter renderParticles];
            }
        }
        else if(projectileID == kPlayerProjectile_Missile || projectileID == kEnemyProjectile_Missile){
            if(isAlive == YES){
                [image renderAtPoint:CGPointMake(currentLocation.x, currentLocation.y) centerOfImage:YES];
            }
        }
    }
    else if([idType isEqualToString:@"Particle"] == TRUE){
        [emitter renderParticles];
    }
    
    //From PlayerShip class
    if(DEBUG) {
        if([idType isEqualToString:@"Projectile"] == TRUE){
            if(projectileID == kPlayerProjectile_Bullet || projectileID == kPlayerProjectile_Wave || projectileID == kEnemyProjectile_Bullet || projectileID == kEnemyProjectile_Wave){
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
            else if(projectileID == kPlayerProjectile_Missile || projectileID == kEnemyProjectile_Missile){
                glPushMatrix();
                
                glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
                
                //Loop through the all the lines except for the last
                Polygon *tempPolygonFromArray = [polygonArray objectAtIndex:0];
                for(int i = 0; i < ([[polygonArray objectAtIndex:0] pointCount] - 1); i++) {
                    GLfloat line[] = {
                        tempPolygonFromArray.points[i].x, tempPolygonFromArray.points[i].y,
                        tempPolygonFromArray.points[i+1].x, tempPolygonFromArray.points[i+1].y,
                    };
                    
                    glVertexPointer(2, GL_FLOAT, 0, line);
                    glEnableClientState(GL_VERTEX_ARRAY);
                    glDrawArrays(GL_LINES, 0, 2);
                }
                
                
                //Renders last line, we do this because of how arrays work.
                GLfloat lineEnd[] = {
                    tempPolygonFromArray.points[([tempPolygonFromArray pointCount] - 1)].x, tempPolygonFromArray.points[([tempPolygonFromArray pointCount] - 1)].y,
                    tempPolygonFromArray.points[0].x, tempPolygonFromArray.points[0].y,
                };
                
                glVertexPointer(2, GL_FLOAT, 0, lineEnd);
                glEnableClientState(GL_VERTEX_ARRAY);
                glDrawArrays(GL_LINES, 0, 2);
                
                glPopMatrix();
            }
        }
        else if([idType isEqualToString:@"Particle"] == TRUE){
            glPushMatrix();
            
            glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
            
            //Loop through the all the lines except for the last
            Polygon *tempPolygonFromArray = [polygonArray objectAtIndex:0];
            for(int i = 0; i < (tempPolygonFromArray.pointCount - 1); i++) {
                GLfloat line[] = {
                    tempPolygonFromArray.points[i].x, tempPolygonFromArray.points[i].y,
                    tempPolygonFromArray.points[i+1].x, tempPolygonFromArray.points[i+1].y,
                };
                
                glVertexPointer(2, GL_FLOAT, 0, line);
                glEnableClientState(GL_VERTEX_ARRAY);
                glDrawArrays(GL_LINES, 0, 2);
            }
            
            
            //Renders last line, we do this because of how arrays work.
            GLfloat lineEnd[] = {
                tempPolygonFromArray.points[([tempPolygonFromArray pointCount] - 1)].x, tempPolygonFromArray.points[([tempPolygonFromArray pointCount] - 1)].y,
                tempPolygonFromArray.points[0].x, tempPolygonFromArray.points[0].y,
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
    [idType release];
    [nameOfImage release];
    free(collisionPoints);
    [super dealloc];
}

@end
