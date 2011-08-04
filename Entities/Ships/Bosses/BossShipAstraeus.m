//
//  BossShipAstraeus.m
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
//	Last Updated - 7/19/2011 @5PM - Alexander
//  - Cannons rotate and also shift positions and everything
//
//  Last Updated - 8/2/11 @8PM - James
//  - Fixed a bunch of bugs, mainly with copying the old and broken
//  angle conde and etc form Atlas. Fixed now
//
//  Last Updated - 8/2/11 @11PM - James
//  - Fixed nasty bug with cannons being killed too fast and causing problems

#import "BossShipAstraeus.h"
#import "BossShip.h"


@implementation BossShipAstraeus

@synthesize leftSideTransitionComplete, rightSideTransitionComplete;

- (id)initWithLocation:(CGPoint)aPoint andPlayerShipRef:(PlayerShip *)playerRef {
    if((self = [super initWithBossID:kBoss_Astraeus initialLocation:aPoint andPlayerShipRef:playerRef])){
        ship = &self.modularObjects[0];
        cannonFrontLeft = &self.modularObjects[2];
        cannonFrontRight = &self.modularObjects[1];
        cannonReplacementOneLeft = &self.modularObjects[3];
        cannonReplacementOneRight = &self.modularObjects[4];
        cannonReplacementTwoLeft = &self.modularObjects[5];
        cannonReplacementTwoRight = &self.modularObjects[6];
        cannonReplacementThreeLeft = &self.modularObjects[7];
        cannonReplacementThreeRight = &self.modularObjects[8];
        
        cannonReplacementOneLeft->shouldTakeDamage = NO;
        cannonReplacementOneRight->shouldTakeDamage = NO;
        cannonReplacementTwoLeft->shouldTakeDamage = NO;
        cannonReplacementTwoRight->shouldTakeDamage = NO;
        cannonReplacementThreeLeft->shouldTakeDamage = NO;
        cannonReplacementThreeRight->shouldTakeDamage = NO;
        
        holdingTimer = 1.0;
        
        leftSideDeathEmitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
                                                                                 position:Vector2fMake(currentLocation.x, currentLocation.y)
                                                                   sourcePositionVariance:Vector2fZero
                                                                                    speed:0.8
                                                                            speedVariance:0.2
                                                                         particleLifeSpan:0.4
                                                                 particleLifespanVariance:0.2
                                                                                    angle:0
                                                                            angleVariance:360
                                                                                  gravity:Vector2fZero
                                                                               startColor:Color4fMake(1.0, 0.2, 0.2, 1.0)
                                                                       startColorVariance:Color4fMake(0.1, 0.1, 0.1, 0.0)
                                                                              finishColor:Color4fMake(0.2, 0.2, 0.2, 1.0)
                                                                      finishColorVariance:Color4fMake(0.1, 0.1, 0.1, 0.0)
                                                                             maxParticles:1000
                                                                             particleSize:12.0
                                                                       finishParticleSize:12.0
                                                                     particleSizeVariance:0.0
                                                                                 duration:0.1
                                                                            blendAdditive:YES];
        rightSideDeathEmitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
                                                                                 position:Vector2fMake(currentLocation.x, currentLocation.y)
                                                                   sourcePositionVariance:Vector2fZero
                                                                                    speed:0.8
                                                                            speedVariance:0.2
                                                                         particleLifeSpan:0.4
                                                                 particleLifespanVariance:0.2
                                                                                    angle:0
                                                                            angleVariance:360
                                                                                  gravity:Vector2fZero
                                                                               startColor:Color4fMake(1.0, 0.2, 0.2, 1.0)
                                                                       startColorVariance:Color4fMake(0.1, 0.1, 0.1, 0.0)
                                                                              finishColor:Color4fMake(0.2, 0.2, 0.2, 1.0)
                                                                      finishColorVariance:Color4fMake(0.1, 0.1, 0.1, 0.0)
                                                                             maxParticles:1000
                                                                             particleSize:12.0
                                                                       finishParticleSize:12.0
                                                                     particleSizeVariance:0.0
                                                                                 duration:0.1
                                                                            blendAdditive:YES];
        
        mainbodyDeathEmitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
                                                                                  position:Vector2fMake(currentLocation.x, currentLocation.y)
                                                                    sourcePositionVariance:Vector2fZero
                                                                                     speed:0.8
                                                                             speedVariance:0.2
                                                                          particleLifeSpan:1.0
                                                                  particleLifespanVariance:0.2
                                                                                     angle:0
                                                                             angleVariance:360
                                                                                   gravity:Vector2fZero
                                                                                startColor:Color4fMake(0.8, 0.1, 0.1, 1.0)
                                                                        startColorVariance:Color4fMake(0.1, 0.1, 0.1, 0.0)
                                                                               finishColor:Color4fMake(0.1, 0.1, 0.1, 1.0)
                                                                       finishColorVariance:Color4fMake(0.1, 0.1, 0.1, 0.0)
                                                                              maxParticles:1500
                                                                              particleSize:20.0
                                                                        finishParticleSize:20.0
                                                                      particleSizeVariance:0.0
                                                                                  duration:0.8
                                                                             blendAdditive:YES];
        
        leftCannonProjectile = [[AbstractProjectile alloc] initWithParticleID:kEnemyParticle 
                                                           fromTurretPosition:Vector2fZero
                                                                       radius:14
                                                                   rateOfFire:4
                                                                     andAngle:270];
        rightCannonProjectile = [[AbstractProjectile alloc] initWithParticleID:kEnemyParticle
                                                            fromTurretPosition:Vector2fZero
                                                                        radius:14 
                                                                    rateOfFire:4
                                                                      andAngle:270];
    }
    
    return self;
}

- (void)update:(GLfloat)delta {
    [super update:delta];
    
    if(!shipIsDeployed){
        currentLocation.x += ((desiredLocation.x - currentLocation.x) / bossSpeed) * (pow(1.584893192, bossSpeed)) * delta;
        currentLocation.y += ((desiredLocation.y - currentLocation.y) / bossSpeed) * (pow(1.584893192, bossSpeed)) * delta;
    }
    else if(!updateMainBodyDeathEmitter){
        //Move slower when is moves around
        currentLocation.x += ((desiredLocation.x - currentLocation.x) / bossSpeed) * (pow(1.584893192, bossSpeed/2)) * delta;
        currentLocation.y += ((desiredLocation.y - currentLocation.y) / bossSpeed) * (pow(1.584893192, bossSpeed/2)) * delta;
    }
    
    //Set the centers of the polygons so they get rendered properly
    for(int i = 0; i < numberOfModules; i++){
        if(modularObjects[i].isDead == NO){
            for(Polygon *modulePoly in modularObjects[i].collisionPolygonArray){
                [modulePoly setPos:CGPointMake(modularObjects[i].location.x + currentLocation.x, modularObjects[i].location.y + currentLocation.y)];
            }
        }
        else {
            //Death Animation Update Emitter
        }
    }
    
    leftSideDeathEmitter.sourcePosition = Vector2fMake(cannonFrontLeft->location.x + currentLocation.x, cannonFrontLeft->location.y + currentLocation.y);
    rightSideDeathEmitter.sourcePosition = Vector2fMake(cannonFrontRight->location.x + currentLocation.x, cannonFrontRight->location.y + currentLocation.y);
    
    {
        // Left Cannon Aiming
        float playerXPosition = (currentLocation.x + cannonFrontLeft->location.x) - playerShipRef.currentLocation.x;
        float playerYPosition = (currentLocation.y + cannonFrontLeft->location.y) - playerShipRef.currentLocation.y;
        
        float angleToPlayer = atan2f(playerYPosition, playerXPosition);
        angleToPlayer = angleToPlayer * (180 / M_PI);
        if(angleToPlayer < 0) angleToPlayer += 360;
        angleToPlayer = 90 - angleToPlayer;
        if(angleToPlayer < 0) angleToPlayer += 360;
        
        if(angleToPlayer > 20 && angleToPlayer < 180) angleToPlayer = 20;
        if(angleToPlayer < 340 && angleToPlayer > 180) angleToPlayer = 340;
        
        
        // Right Cannon aiming
        playerXPosition = (currentLocation.x + cannonFrontRight->location.x) - playerShipRef.currentLocation.x;
        playerYPosition = (currentLocation.y + cannonFrontRight->location.y) - playerShipRef.currentLocation.y;
        
        float angleToPlayer2 = atan2f(playerYPosition, playerXPosition);
        angleToPlayer2 = angleToPlayer2 * (180 / M_PI);
        if(angleToPlayer2 < 0) angleToPlayer2 += 360;
        angleToPlayer2 = 90 - angleToPlayer2;
        if(angleToPlayer2 < 0) angleToPlayer2 += 360;
        
        if(angleToPlayer2 > 20 && angleToPlayer2 < 180) angleToPlayer2 = 20;
        if(angleToPlayer2 < 340 && angleToPlayer2 > 180) angleToPlayer2 = 340;
        
        
        //Rotation for polygons to match the rotation of the cannons
        for(int k = 0; k < [cannonFrontLeft->collisionPolygonArray count]; k++){
            for(int i = 0; i < [[cannonFrontLeft->collisionPolygonArray objectAtIndex:k] pointCount]; i++){
                Vector2f tempPoint = [[cannonFrontLeft->collisionPolygonArray objectAtIndex:k] originalPoints][i];
                double tempAngle = DEGREES_TO_RADIANS(cannonFrontLeft->rotation - angleToPlayer);
                [[cannonFrontLeft->collisionPolygonArray objectAtIndex:k] originalPoints][i] = Vector2fMake((tempPoint.x * cos(tempAngle)) - (tempPoint.y * sin(tempAngle)), (tempPoint.x * sin(tempAngle)) + (tempPoint.y * cos(tempAngle)));
            }
            [[cannonFrontLeft->collisionPolygonArray objectAtIndex:k] buildEdges];
        }
        Vector2f tempPoint = cannonFrontLeft->weapons[0].weaponCoord;
        double tempAngle = DEGREES_TO_RADIANS(cannonFrontLeft->rotation - angleToPlayer);
        cannonFrontLeft->weapons[0].weaponCoord = Vector2fMake((tempPoint.x * cos(tempAngle)) - (tempPoint.y * sin(tempAngle)), (tempPoint.x * sin(tempAngle)) + (tempPoint.y * cos(tempAngle)));
        
        for(int k = 0; k < [cannonFrontRight->collisionPolygonArray count]; k++){
            for(int i = 0; i < [[cannonFrontRight->collisionPolygonArray objectAtIndex:k] pointCount]; i++){
                Vector2f tempPoint = [[cannonFrontRight->collisionPolygonArray objectAtIndex:k] originalPoints][i];
                double tempAngle = DEGREES_TO_RADIANS(cannonFrontRight->rotation - angleToPlayer2);
                [[cannonFrontRight->collisionPolygonArray objectAtIndex:k] originalPoints][i] = Vector2fMake((tempPoint.x * cos(tempAngle)) - (tempPoint.y * sin(tempAngle)), (tempPoint.x * sin(tempAngle)) + (tempPoint.y * cos(tempAngle)));
            }
            [[cannonFrontRight->collisionPolygonArray objectAtIndex:k] buildEdges];
        }
        Vector2f tempPoint2 = cannonFrontLeft->weapons[0].weaponCoord;
        double tempAngle2 = DEGREES_TO_RADIANS(cannonFrontLeft->rotation - angleToPlayer2);
        cannonFrontRight->weapons[0].weaponCoord = Vector2fMake((tempPoint2.x * cos(tempAngle2)) - (tempPoint2.y * sin(tempAngle2)), (tempPoint2.x * sin(tempAngle2)) + (tempPoint2.y * cos(tempAngle2)));

        cannonFrontRight->rotation = angleToPlayer2;
        cannonFrontLeft->rotation = angleToPlayer;
    }
    
    if(cannonFrontLeft->isDead) {
        [leftSideDeathEmitter update:delta];
        if(leftSideDeathEmitter.particleCount == 0){
            //When the emitter is dead
            if(cannonReplacementOneLeft->isDead == NO || cannonReplacementTwoLeft->isDead == NO || cannonReplacementThreeLeft->isDead == NO){
                //Check to make sure that there are others to animate in
                timeSinceFrontLeftDied+= delta;
                leftSideTransitionComplete = NO;
                [leftCannonProjectile stopProjectile];
                cannonFrontLeft->shouldTakeDamage = NO;
                if(cannonReplacementOneLeft->location.x < cannonFrontLeft->defaultLocation.x) cannonReplacementOneLeft->location.x = cannonReplacementOneLeft->location.x + (timeSinceFrontLeftDied * 0.5);
                if(cannonReplacementOneLeft->location.y > cannonFrontLeft->defaultLocation.y) cannonReplacementOneLeft->location.y = cannonReplacementOneLeft->location.y - (timeSinceFrontLeftDied * 0.5);
                if(cannonReplacementOneLeft->rotation > -cannonFrontLeft->rotation) cannonReplacementOneLeft->rotation -= (timeSinceFrontLeftDied * 0.5);
        
                if(cannonReplacementTwoLeft->location.x < cannonReplacementOneLeft->defaultLocation.x) cannonReplacementTwoLeft->location.x = cannonReplacementTwoLeft->location.x + (timeSinceFrontLeftDied * 0.5);
                if(cannonReplacementTwoLeft->location.y > cannonReplacementOneLeft->defaultLocation.y) cannonReplacementTwoLeft->location.y = cannonReplacementTwoLeft->location.y - (timeSinceFrontLeftDied * 0.5);
                if(cannonReplacementTwoLeft->rotation > -30) cannonReplacementTwoLeft->rotation -= (timeSinceFrontLeftDied * 0.5);
        
                if(cannonReplacementThreeLeft->location.x < cannonReplacementTwoLeft->defaultLocation.x) cannonReplacementThreeLeft->location.x = cannonReplacementThreeLeft->location.x + (timeSinceFrontLeftDied * 0.5);
                if(cannonReplacementThreeLeft->location.y > cannonReplacementTwoLeft->defaultLocation.y) cannonReplacementThreeLeft->location.y = cannonReplacementThreeLeft->location.y - (timeSinceFrontLeftDied * 0.5);
                if(cannonReplacementThreeLeft->rotation > -30) cannonReplacementThreeLeft->rotation -= (timeSinceFrontLeftDied * 0.5);
            
                if(!(cannonReplacementOneLeft->location.x < cannonFrontLeft->defaultLocation.x) && !(cannonReplacementOneLeft->location.y > cannonFrontLeft->defaultLocation.y) && !(cannonReplacementTwoLeft->location.x < cannonReplacementOneLeft->defaultLocation.x) && !(cannonReplacementTwoLeft->location.y > cannonReplacementOneLeft->defaultLocation.y) && !(cannonReplacementThreeLeft->location.x < cannonReplacementTwoLeft->defaultLocation.x) && !(cannonReplacementThreeLeft->location.y > cannonReplacementTwoLeft->defaultLocation.y)) {
                    leftSideTransitionComplete = YES;
                }
            }
        }
    }
    
    if(cannonFrontRight->isDead) {
        [rightSideDeathEmitter update:delta];
        if(rightSideDeathEmitter.particleCount == 0){
            
            if(cannonReplacementOneRight->isDead == NO || cannonReplacementTwoRight->isDead == NO || cannonReplacementThreeLeft->isDead == NO){
                timeSinceFrontRightDied+= delta;
                rightSideTransitionComplete = NO;
                [rightCannonProjectile stopProjectile];
                cannonFrontRight->shouldTakeDamage = NO;
                if(cannonReplacementOneRight->location.x > cannonFrontRight->defaultLocation.x) cannonReplacementOneRight->location.x = cannonReplacementOneRight->location.x - (timeSinceFrontRightDied * 0.5);
                if(cannonReplacementOneRight->location.y > cannonFrontRight->defaultLocation.y) cannonReplacementOneRight->location.y = cannonReplacementOneRight->location.y - (timeSinceFrontRightDied * 0.5);
                if(cannonReplacementOneRight->rotation > -cannonFrontRight->rotation) cannonReplacementOneRight->rotation += (timeSinceFrontRightDied * 0.5);
                
                if(cannonReplacementTwoRight->location.x > cannonReplacementOneRight->defaultLocation.x) cannonReplacementTwoRight->location.x = cannonReplacementTwoRight->location.x - (timeSinceFrontRightDied * 0.5);
                if(cannonReplacementTwoRight->location.y > cannonReplacementOneRight->defaultLocation.y) cannonReplacementTwoRight->location.y = cannonReplacementTwoRight->location.y - (timeSinceFrontRightDied * 0.5);
                if(cannonReplacementTwoRight->rotation < 30) cannonReplacementTwoRight->rotation += (timeSinceFrontRightDied * 0.5);
                
                if(cannonReplacementThreeRight->location.x > cannonReplacementTwoRight->defaultLocation.x) cannonReplacementThreeRight->location.x = cannonReplacementThreeRight->location.x - (timeSinceFrontRightDied * 0.5);
                if(cannonReplacementThreeRight->location.y > cannonReplacementTwoRight->defaultLocation.y) cannonReplacementThreeRight->location.y = cannonReplacementThreeRight->location.y - (timeSinceFrontRightDied * 0.5);
                if(cannonReplacementThreeRight->rotation < 30) cannonReplacementThreeRight->rotation += (timeSinceFrontRightDied * 0.5);
                
                if(!(cannonReplacementOneRight->location.x > cannonFrontRight->defaultLocation.x) && !(cannonReplacementOneRight->location.y > cannonFrontRight->defaultLocation.y) && !(cannonReplacementTwoRight->location.x > cannonReplacementOneRight->defaultLocation.x) && !(cannonReplacementTwoRight->location.y > cannonReplacementOneRight->defaultLocation.y) && !(cannonReplacementThreeRight->location.x > cannonReplacementTwoRight->defaultLocation.x) && !(cannonReplacementThreeRight->location.y > cannonReplacementTwoRight->defaultLocation.y)) {
                    rightSideTransitionComplete = YES;
                }
            }
        }
    }
    
    if(rightSideTransitionComplete) {
        rightSideTransitionComplete = NO;
        timeSinceFrontRightDied = 0.0f;
        
        [rightCannonProjectile release];
        rightCannonProjectile = nil;
        if(cannonReplacementThreeRight->isDead == NO) {
            cannonReplacementThreeRight->isDead = YES;
            cannonReplacementOneRight->location = cannonReplacementOneRight->defaultLocation;
            cannonReplacementTwoRight->location = cannonReplacementTwoRight->defaultLocation;
            cannonReplacementOneRight->rotation = 0;
            cannonReplacementTwoRight->rotation = 0;
            
            cannonFrontRight->isDead = NO;
            cannonFrontRight->moduleHealth = cannonFrontRight->moduleMaxHealth;
            cannonFrontRight->shouldTakeDamage = YES;
            rightCannonProjectile = [[AbstractProjectile alloc] initWithParticleID:kEnemyParticle fromTurretPosition:Vector2fZero radius:11 rateOfFire:3 andAngle:270];
        }
        else if(cannonReplacementTwoRight->isDead == NO) {
            cannonReplacementTwoRight->isDead = YES;
            cannonReplacementOneRight->location = cannonReplacementOneRight->defaultLocation;
            cannonReplacementOneRight->rotation = 0;
            
            cannonFrontRight->isDead = NO;
            cannonFrontRight->moduleHealth = cannonFrontRight->moduleMaxHealth;
            cannonFrontRight->shouldTakeDamage = YES;
            rightCannonProjectile = [[AbstractProjectile alloc] initWithParticleID:kEnemyParticle fromTurretPosition:Vector2fZero radius:8 rateOfFire:2 andAngle:270];
        }
        else if(cannonReplacementOneRight->isDead == NO) {
            cannonReplacementOneRight->isDead = YES;
            
            cannonFrontRight->isDead = NO;
            cannonFrontRight->moduleHealth = cannonFrontRight->moduleMaxHealth;
            cannonFrontRight->shouldTakeDamage = YES;
            rightCannonProjectile = [[AbstractProjectile alloc] initWithParticleID:kEnemyParticle fromTurretPosition:Vector2fZero radius:5 rateOfFire:1 andAngle:270];
        }
        else {
            // All cannons are dead
        }
        [rightSideDeathEmitter release];
        
        rightSideDeathEmitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
                                                                                  position:Vector2fMake(currentLocation.x, currentLocation.y)
                                                                    sourcePositionVariance:Vector2fZero
                                                                                     speed:0.8
                                                                             speedVariance:0.2
                                                                          particleLifeSpan:0.4
                                                                  particleLifespanVariance:0.2
                                                                                     angle:0
                                                                             angleVariance:360
                                                                                   gravity:Vector2fZero
                                                                                startColor:Color4fMake(1.0, 0.2, 0.2, 1.0)
                                                                        startColorVariance:Color4fMake(0.1, 0.1, 0.1, 0.0)
                                                                               finishColor:Color4fMake(0.2, 0.2, 0.2, 1.0)
                                                                       finishColorVariance:Color4fMake(0.1, 0.1, 0.1, 0.0)
                                                                              maxParticles:1000
                                                                              particleSize:12.0
                                                                        finishParticleSize:12.0
                                                                      particleSizeVariance:0.0
                                                                                  duration:0.1
                                                                             blendAdditive:YES];
        
    }
    
    if(leftSideTransitionComplete) {
        leftSideTransitionComplete = NO;
        timeSinceFrontLeftDied = 0.0f;
        
        if(cannonReplacementThreeLeft->isDead == NO) {
            cannonReplacementThreeLeft->isDead = YES;
            cannonReplacementOneLeft->location = cannonReplacementOneLeft->defaultLocation;
            cannonReplacementTwoLeft->location = cannonReplacementTwoLeft->defaultLocation;
            cannonReplacementOneLeft->rotation = 0;
            cannonReplacementTwoLeft->rotation = 0;
            
            cannonFrontLeft->isDead = NO;
            cannonFrontLeft->moduleHealth = cannonFrontLeft->moduleMaxHealth;
            cannonFrontLeft->shouldTakeDamage = YES;
            leftCannonProjectile = [[AbstractProjectile alloc] initWithParticleID:kEnemyParticle fromTurretPosition:Vector2fZero radius:11 rateOfFire:3 andAngle:270];
        }
        else if(cannonReplacementTwoLeft->isDead == NO) {
            cannonReplacementTwoLeft->isDead = YES;
            cannonReplacementOneLeft->location = cannonReplacementOneLeft->defaultLocation;
            cannonReplacementOneLeft->rotation = 0;
            
            cannonFrontLeft->isDead = NO;
            cannonFrontLeft->moduleHealth = cannonFrontLeft->moduleMaxHealth;
            cannonFrontLeft->shouldTakeDamage = YES;
            leftCannonProjectile = [[AbstractProjectile alloc] initWithParticleID:kEnemyParticle fromTurretPosition:Vector2fZero radius:8 rateOfFire:2 andAngle:270];
        }
        else if(cannonReplacementOneLeft->isDead == NO) {
            cannonReplacementOneLeft->isDead = YES;
            
            cannonFrontLeft->isDead = NO;
            cannonFrontLeft->moduleHealth = cannonFrontLeft->moduleMaxHealth;
            cannonFrontLeft->shouldTakeDamage = YES;
            leftCannonProjectile = [[AbstractProjectile alloc] initWithParticleID:kEnemyParticle fromTurretPosition:Vector2fZero radius:5 rateOfFire:1 andAngle:270];
        }
        else {
            // All cannons are dead
        }
        [leftSideDeathEmitter release];
        
        leftSideDeathEmitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
                                                                                  position:Vector2fMake(currentLocation.x, currentLocation.y)
                                                                    sourcePositionVariance:Vector2fZero
                                                                                     speed:0.8
                                                                             speedVariance:0.2
                                                                          particleLifeSpan:0.4
                                                                  particleLifespanVariance:0.2
                                                                                     angle:0
                                                                             angleVariance:360
                                                                                   gravity:Vector2fZero
                                                                                startColor:Color4fMake(1.0, 0.2, 0.2, 1.0)
                                                                        startColorVariance:Color4fMake(0.1, 0.1, 0.1, 0.0)
                                                                               finishColor:Color4fMake(0.2, 0.2, 0.2, 1.0)
                                                                       finishColorVariance:Color4fMake(0.1, 0.1, 0.1, 0.0)
                                                                              maxParticles:1000
                                                                              particleSize:12.0
                                                                        finishParticleSize:12.0
                                                                      particleSizeVariance:0.0
                                                                                  duration:0.1
                                                                             blendAdditive:YES];
    }
    
    if(cannonReplacementOneLeft->isDead && cannonReplacementTwoLeft->isDead && cannonReplacementThreeLeft->isDead &&
       cannonReplacementOneRight->isDead && cannonReplacementTwoRight->isDead && cannonReplacementThreeRight->isDead){
        allReplacementsDead = YES;
    }
    
    if(cannonReplacementOneLeft->isDead && cannonReplacementTwoLeft->isDead && cannonReplacementThreeLeft->isDead && cannonFrontLeft->isDead){
        [leftCannonProjectile release];
        leftCannonProjectile = nil;
    }
    if(cannonReplacementOneRight->isDead && cannonReplacementTwoRight->isDead && cannonReplacementThreeRight->isDead && cannonFrontRight->isDead){
        [rightCannonProjectile release];
        rightCannonProjectile = nil;
    }
    
    if(allReplacementsDead){
        holdingTimer += delta;
        
        if(holdingTimer >= 1.4){
            holdingTimer = 0.0;
            
            if(currentLocation.x <= 160){
                desiredLocation.x = (MAX(0.4, RANDOM_0_TO_1()) * 160) + 160;
            }
            else if(currentLocation.x >= 160){
                desiredLocation.x = (MIN(0.6, RANDOM_0_TO_1()) * 160);
            }
            
            desiredLocation.y = currentLocation.y + (RANDOM_MINUS_1_TO_1() * 150);
            
            desiredLocation.x = MAX(50, desiredLocation.x);
            desiredLocation.y = MAX(320, desiredLocation.y);
            
            desiredLocation.x = MIN(desiredLocation.x, 270);
            desiredLocation.y = MIN(desiredLocation.y, 430);
        }
    }
    
    if(ship->isDead){
        ship->isDead = NO;
        updateMainBodyDeathEmitter = YES;
        NSLog(@"Toggled shipIsdead, %d %d", ship->isDead, updateMainBodyDeathEmitter);
    }
    if(updateMainBodyDeathEmitter){
        NSLog(@"updating death emitter");
        mainbodyDeathEmitter.sourcePosition = Vector2fMake(ship->location.x + currentLocation.x, ship->location.y + currentLocation.y);
        [mainbodyDeathEmitter update:delta];
        if(mainbodyDeathEmitter.particleCount == 0){
            ship->isDead = YES;
            updateMainBodyDeathEmitter = NO;
        }
    }
    
    if(shipIsDeployed){
        if(leftCannonProjectile){
            [leftCannonProjectile update:delta];
            leftCannonProjectile.projectileAngle = 270 - cannonFrontLeft->rotation;
            leftCannonProjectile.turretPosition = Vector2fMake(currentLocation.x + cannonFrontLeft->weapons[0].weaponCoord.x + cannonFrontLeft->location.x, currentLocation.y + cannonFrontLeft->weapons[0].weaponCoord.y + cannonFrontLeft->location.y);
        }
        if(rightCannonProjectile){
            [rightCannonProjectile update:delta];
            rightCannonProjectile.projectileAngle = 270 - cannonFrontRight->rotation;
            rightCannonProjectile.turretPosition = Vector2fMake(currentLocation.x + cannonFrontRight->weapons[0].weaponCoord.x + cannonFrontRight->location.x, currentLocation.y + cannonFrontRight->weapons[0].weaponCoord.y + cannonFrontRight->location.y);
        }
    }
}

- (void)render {
    [leftCannonProjectile render];
    [rightCannonProjectile render];
    
    for(int i = 0; i < numberOfModules; i++) {
        if (!modularObjects[i].isDead) {
            if(i != 0){
                [modularObjects[i].moduleImage setRotation:modularObjects[i].rotation];
                [modularObjects[i].moduleImage renderAtPoint:CGPointMake(currentLocation.x + modularObjects[i].location.x, currentLocation.y + modularObjects[i].location.y) centerOfImage:YES];
            }
            else {
                //Special rendering for the main body
                if(!updateMainBodyDeathEmitter){
                    [ship->moduleImage renderAtPoint:CGPointMake(currentLocation.x + ship->location.x, currentLocation.y + ship->location.y) centerOfImage:YES];
                }
            }
        }
    }
    
    if(cannonFrontLeft->isDead){
        [leftSideDeathEmitter renderParticles];
    }
    if(cannonFrontRight->isDead){
        [rightSideDeathEmitter renderParticles];
    }
    if(updateMainBodyDeathEmitter){
        [mainbodyDeathEmitter renderParticles];
    }
    
    if(DEBUG) {
        glPushMatrix();
        
        glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
        
        for(int i = 0; i < numberOfModules; i++) {
            if(modularObjects[i].isDead == NO){
                for(int k = 0; k < [modularObjects[i].collisionPolygonArray count]; k++){
                    for(int j = 0; j < ([[modularObjects[i].collisionPolygonArray objectAtIndex:k] pointCount] - 1); j++) {
                        GLfloat line[] = {
                            [[modularObjects[i].collisionPolygonArray objectAtIndex:k] points][j].x, [[modularObjects[i].collisionPolygonArray objectAtIndex:k] points][j].y,
                            [[modularObjects[i].collisionPolygonArray objectAtIndex:k] points][j+1].x, [[modularObjects[i].collisionPolygonArray objectAtIndex:k] points][j+1].y,
                        };
                        
                        glVertexPointer(2, GL_FLOAT, 0, line);
                        glEnableClientState(GL_VERTEX_ARRAY);
                        glDrawArrays(GL_LINES, 0, 2);
                    }
                    
                    GLfloat lineEnd[] = {
                        [[modularObjects[i].collisionPolygonArray objectAtIndex:k] points][([[modularObjects[i].collisionPolygonArray objectAtIndex:k] pointCount] - 1)].x, [[modularObjects[i].collisionPolygonArray objectAtIndex:k] points][([[modularObjects[i].collisionPolygonArray objectAtIndex:k] pointCount] - 1)].y,
                        [[modularObjects[i].collisionPolygonArray objectAtIndex:k] points][0].x, [[modularObjects[i].collisionPolygonArray objectAtIndex:k] points][0].y,
                    };
                    
                    glVertexPointer(2, GL_FLOAT, 0, lineEnd);
                    glEnableClientState(GL_VERTEX_ARRAY);
                    glDrawArrays(GL_LINES, 0, 2);
                }
            }
        }
        
        glPopMatrix();
    }
}

@end
