//
//  BossShipAtlas.m
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
//	Last Updated - 1/28/2011 @10PM - Alexander
//  - Initial write, added a bunch of stuff including
//      • Cannon joint particle emitters
//      • Objects for all of the modules
//
//  Last Updated - 2/4/2011 @ 8PM - Alexander
//  - Changed all modularObjects[x] references for the cannons
//  to the cannonLeft and cannonRight objects for better 
//  readability of the code
//
//  Last Updated - 6/22/11 @5PM - Alexander & James
//  - Changed class name to reflect new boss names
//
//  Last updated - 7/21/11 @9PM - James
//  - Made sure to only update/render modules when they're
//  alive, and emitter joints. Small bug with modules not matching
//  up. Todo: death animations
//
//  Last Updated - 7/23/11 @12:10PM - James
//  - Fixed bug where module images would render at the wrong points,
//  and by fixing that messed up cannons and the aiming, fixed that.
//
//  Last Updated - 8/5/11 @9:45PM - Alexander
//  - Began code on the first few stages of attack from the ship
//  - The modules (cannons, front turrets) are programmed to return after
//  first death

#import "BossShipAtlas.h"

@interface BossShipAtlas(Private)
- (void)aimCannonsAtPlayer;
@end


@implementation BossShipAtlas

- (id)initWithLocation:(CGPoint)aPoint andPlayerShipRef:(PlayerShip *)playerRef {
    if((self = [super initWithBossID:kBoss_Atlas initialLocation:aPoint andPlayerShipRef:playerRef])){        
        mainBody = &self.modularObjects[0];
        cannonRight = &self.modularObjects[3];
        cannonLeft = &self.modularObjects[4];
        frontCenterTurret = &self.modularObjects[5];
        frontRightTurret = &self.modularObjects[2];
        frontLeftTurret = &self.modularObjects[1];
        
        state = -1;
        cannonRightFlewOff = NO;
        cannonLeftFlewOff = NO;
        frontCenterTurretFlewOff = NO;
        frontLeftTurretFlewOff = NO;
        frontRightTurretFlewOff = NO;
        
        rightCannonEmitterJoint = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
                                                                                    position:Vector2fMake(currentLocation.x + 105, 0)
                                                                      sourcePositionVariance:Vector2fMake(0,0)
                                                                                       speed:0.01f
                                                                               speedVariance:0.0f
                                                                            particleLifeSpan:0.1f
                                                                    particleLifespanVariance:0.2f
                                                                                       angle:360.0f
                                                                               angleVariance:0
                                                                                     gravity:Vector2fMake(0.0f, 0.0f)
                                                                                  startColor:Color4fMake(0.3f, 1.0f, 0.66f, 1.0f)
                                                                          startColorVariance:Color4fMake(0.0f, 0.2f, 0.2f, 0.5f)
                                                                                 finishColor:Color4fMake(0.16f, 0.0f, 0.0f, 1.0f)
                                                                         finishColorVariance:Color4fMake(0.0f, 0.0f, 0.0f, 1.0f)
                                                                                maxParticles:25
                                                                                particleSize:25
                                                                          finishParticleSize:25
                                                                        particleSizeVariance:2
                                                                                    duration:-1
                                                                               blendAdditive:YES];
        
        leftCannonEmitterJoint = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
                                                                                   position:Vector2fMake(currentLocation.x + 105, 0)
                                                                     sourcePositionVariance:Vector2fMake(0,0)
                                                                                      speed:0.01f
                                                                              speedVariance:0.0f
                                                                           particleLifeSpan:0.1f
                                                                   particleLifespanVariance:0.2f
                                                                                      angle:360.0f
                                                                              angleVariance:0
                                                                                    gravity:Vector2fMake(0.0f, 0.0f)
                                                                                 startColor:Color4fMake(0.3f, 1.0f, 0.66f, 1.0f)
                                                                         startColorVariance:Color4fMake(0.0f, 0.2f, 0.2f, 0.5f)
                                                                                finishColor:Color4fMake(0.16f, 0.0f, 0.0f, 1.0f)
                                                                        finishColorVariance:Color4fMake(0.0f, 0.0f, 0.0f, 1.0f)
                                                                               maxParticles:25
                                                                               particleSize:25
                                                                         finishParticleSize:25
                                                                       particleSizeVariance:2
                                                                                   duration:-1
                                                                              blendAdditive:YES];
        
        backEngineEnergyEmitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
                                                                                    position:Vector2fMake(currentLocation.x, currentLocation.y + 30)
                                                                      sourcePositionVariance:Vector2fMake(0,0)
                                                                                       speed:0.01f
                                                                               speedVariance:0.0f
                                                                            particleLifeSpan:0.1f
                                                                    particleLifespanVariance:0.2f
                                                                                       angle:360.0f
                                                                               angleVariance:0
                                                                                     gravity:Vector2fMake(0.0f, 0.0f)
                                                                                  startColor:Color4fMake(0.3f, 1.0f, 0.66f, 1.0f)
                                                                          startColorVariance:Color4fMake(0.0f, 0.2f, 0.2f, 0.5f)
                                                                                 finishColor:Color4fMake(0.16f, 0.0f, 0.0f, 1.0f)
                                                                         finishColorVariance:Color4fMake(0.0f, 0.0f, 0.0f, 1.0f)
                                                                                maxParticles:25
                                                                                particleSize:25
                                                                          finishParticleSize:25
                                                                        particleSizeVariance:2
                                                                                    duration:-1
                                                                               blendAdditive:YES];
        
        mainBodyDeathEmitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
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
        
        leftCannonDeathEmitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
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
        leftCannonDeathSecondaryEmitter = leftCannonDeathEmitter;
        
        rightCannonDeathEmitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
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
        rightCannonDeathSecondaryEmitter = rightCannonDeathEmitter;
        
        frontCenterTurretDeathEmitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
                                                                                                           position:Vector2fMake(currentLocation.x, currentLocation.y)
                                                                                             sourcePositionVariance:Vector2fZero
                                                                                                              speed:0.8
                                                                                                      speedVariance:0.2
                                                                                                   particleLifeSpan:0.1
                                                                                           particleLifespanVariance:0.1
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
        frontCenterTurretDeathSecondaryEmitter = frontCenterTurretDeathEmitter;
        
        frontLeftTurretDeathEmitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
                                                                                                         position:Vector2fMake(currentLocation.x, currentLocation.y)
                                                                                           sourcePositionVariance:Vector2fZero
                                                                                                            speed:0.8
                                                                                                    speedVariance:0.2
                                                                                                 particleLifeSpan:0.1
                                                                                         particleLifespanVariance:0.1
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
        frontLeftTurretDeathSecondaryEmitter = frontLeftTurretDeathEmitter;
        
        frontRightTurretDeathEmitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
                                                                                                          position:Vector2fMake(currentLocation.x, currentLocation.y)
                                                                                            sourcePositionVariance:Vector2fZero
                                                                                                             speed:0.8
                                                                                                     speedVariance:0.2
                                                                                                  particleLifeSpan:0.1
                                                                                          particleLifespanVariance:0.1
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
        frontRightTurretDeathSecondaryEmitter = frontRightTurretDeathEmitter;
        
        stagePauseTimer = 0.0f;
        currentStagePaused = NO;
        
        for(int i = 0; i < numberOfModules; i++) {
            modularObjects[i].desiredLocation = modularObjects[i].location;
        }
   }
    return self;
}

- (void)update:(GLfloat)delta {
    [super update:delta];
    
    if (state == -1) {
        currentLocation.x += ((desiredLocation.x - currentLocation.x) / bossSpeed) * (pow(1.584893192, bossSpeed)) * delta;
        currentLocation.y += ((desiredLocation.y - currentLocation.y) / bossSpeed) * (pow(1.584893192, bossSpeed)) * delta;
    }
    else if(state == kAtlasState_StageOne) {
        currentLocation.x += ((desiredLocation.x - currentLocation.x) / bossSpeed) * (pow(1.584893192, bossSpeed/2.5)) * delta;
        currentLocation.y += ((desiredLocation.y - currentLocation.y) / bossSpeed) * (pow(1.584893192, bossSpeed/2.5)) * delta;
    }
    
    
    [self aimCannonsAtPlayer];
    
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
    
    // Update the death emitter positions
    [mainBodyDeathEmitter setSourcePosition:Vector2fMake(mainBody->location.x + currentLocation.x, mainBody->location.y + currentLocation.y)];
    [leftCannonDeathEmitter setSourcePosition:Vector2fMake(cannonLeft->location.x + currentLocation.x, cannonLeft->location.y + currentLocation.y)];
    [rightCannonDeathEmitter setSourcePosition:Vector2fMake(cannonRight->location.x + currentLocation.x, cannonRight->location.y + currentLocation.y)];
    [frontCenterTurretDeathEmitter setSourcePosition:Vector2fMake(frontCenterTurret->location.x + currentLocation.x, frontCenterTurret->location.y + currentLocation.y)];
    [frontLeftTurretDeathEmitter setSourcePosition:Vector2fMake(frontLeftTurret->location.x + currentLocation.x, frontLeftTurret->location.y + currentLocation.y)];
    [frontRightTurretDeathEmitter setSourcePosition:Vector2fMake(frontRightTurret->location.x + currentLocation.x, frontRightTurret->location.y + currentLocation.y)];
    [leftCannonDeathSecondaryEmitter setSourcePosition:Vector2fMake(cannonLeft->location.x + currentLocation.x, cannonLeft->location.y + currentLocation.y)];
    [rightCannonDeathSecondaryEmitter setSourcePosition:Vector2fMake(cannonRight->location.x + currentLocation.x, cannonRight->location.y + currentLocation.y)];
    [frontCenterTurretDeathSecondaryEmitter setSourcePosition:Vector2fMake(frontCenterTurret->location.x + currentLocation.x, frontCenterTurret->location.y + currentLocation.y)];
    [frontLeftTurretDeathSecondaryEmitter setSourcePosition:Vector2fMake(frontLeftTurret->location.x + currentLocation.x, frontLeftTurret->location.y + currentLocation.y)];
    [frontRightTurretDeathSecondaryEmitter setSourcePosition:Vector2fMake(frontRightTurret->location.x + currentLocation.x, frontRightTurret->location.y + currentLocation.y)];

    
    if (mainBody->isDead) {
        [mainBodyDeathEmitter update:delta];
    }
    if (cannonRight->isDead) {
        [rightCannonDeathSecondaryEmitter update:delta];
    }
    if (cannonLeft->isDead) {
        [leftCannonDeathSecondaryEmitter update:delta];
    }
    if (frontRightTurret->isDead) {
        [frontRightTurretDeathSecondaryEmitter update:delta];
    }
    if (frontCenterTurret->isDead) {
        [frontCenterTurretDeathSecondaryEmitter update:delta];
    }
    if (frontLeftTurret->isDead) {
        [frontLeftTurretDeathSecondaryEmitter update:delta];
    }
    
    if (cannonRightFlewOff) {
        [rightCannonDeathEmitter update:delta];
    }
    if (cannonLeftFlewOff) {
        [leftCannonDeathEmitter update:delta];
    }
    if (frontRightTurretFlewOff) {
        [frontRightTurretDeathEmitter update:delta];
    }
    if (frontCenterTurretFlewOff) {
        [frontCenterTurretDeathEmitter update:delta];
    }
    if (frontLeftTurretFlewOff) {
        [frontLeftTurretDeathEmitter update:delta];
    }
    
        
    [rightCannonEmitterJoint setSourcePosition:Vector2fMake(currentLocation.x + (-115), currentLocation.y - 30)];
    [leftCannonEmitterJoint setSourcePosition:Vector2fMake(currentLocation.x + 115, currentLocation.y - 30)];
    [backEngineEnergyEmitter setSourcePosition:Vector2fMake(currentLocation.x, currentLocation.y + 30)];
    
    if(cannonRight->isDead == NO){
        [rightCannonEmitterJoint update:delta];
    }
    if(cannonLeft->isDead == NO){
        [leftCannonEmitterJoint update:delta];
    }
    if(mainBody->isDead == NO) {
        [backEngineEnergyEmitter update:delta];
    }
    
    if (shipIsDeployed && !currentStagePaused) {
        
        if (state == -1) {
            state = kAtlasState_StageOne;
        }
        
        if (state == kAtlasState_StageOne) {
            holdingTimer += delta;
            
            if(holdingTimer >= 1.4){
                holdingTimer = 0.0;
                
                if(currentLocation.x <= 160){
                    desiredLocation.x = (MAX(0.4, RANDOM_0_TO_1()) * 160) + 160;
                }
                else if(currentLocation.x >= 160){
                    desiredLocation.x = (MIN(0.6, RANDOM_0_TO_1()) * 160);
                }
                
                //desiredLocation.y = currentLocation.y + (RANDOM_MINUS_1_TO_1() * 150);
                
                desiredLocation.x = MAX(50, desiredLocation.x);
                //desiredLocation.y = MAX(320, desiredLocation.y);
                
                desiredLocation.x = MIN(desiredLocation.x, 270);
                //desiredLocation.y = MIN(desiredLocation.y, 430);
            }
            
            if (cannonRightFlewOff && cannonLeftFlewOff && frontCenterTurretFlewOff && frontRightTurretFlewOff && frontLeftTurretFlewOff) {
                desiredLocation = CGPointMake(160.0f, currentLocation.y);
                currentStagePaused = YES;
            }
        }
    }
    else if(currentStagePaused) {
        if (state == kAtlasState_StageOne) {
            [playerShipRef stopAllProjectiles];
            
            // Revive the weapons!
            cannonRight->desiredLocation = cannonRight->defaultLocation;
            cannonLeft->desiredLocation = cannonLeft->defaultLocation;
            frontCenterTurret->desiredLocation = frontCenterTurret->defaultLocation;
            frontLeftTurret->desiredLocation = frontLeftTurret->defaultLocation;
            frontRightTurret->desiredLocation = frontRightTurret->defaultLocation;
            
            cannonRight->moduleHealth = cannonRight->moduleMaxHealth;
            cannonLeft->moduleHealth = cannonLeft->moduleHealth;
            frontCenterTurret->moduleHealth = frontCenterTurret->moduleHealth;
            frontLeftTurret->moduleHealth = frontLeftTurret->moduleHealth;
            frontRightTurret->moduleHealth = frontRightTurret->moduleHealth;
            
            cannonRight->isDead = NO;
            cannonLeft->isDead = NO;
            frontCenterTurret->isDead = NO;
            frontLeftTurret->isDead = NO;
            frontRightTurret->isDead = NO;
        }
    }
    
    // Update locations of the modules (for fly-offs)
    for(int i = 0; i < numberOfModules; i++) {
        modularObjects[i].location.x += ((modularObjects[i].desiredLocation.x - modularObjects[i].location.x) / bossSpeed) * (pow(1.584893192, bossSpeed/2)) * delta;
        modularObjects[i].location.y += ((modularObjects[i].desiredLocation.y - modularObjects[i].location.y) / bossSpeed) * (pow(1.584893192, bossSpeed/2)) * delta;

    }
}

- (void)aimCannonsAtPlayer {
    // Left Cannon Aiming
    float playerXPosition = (currentLocation.x + cannonLeft->location.x) - playerShipRef.currentLocation.x;
    float playerYPosition = (currentLocation.y + cannonLeft->location.y) - playerShipRef.currentLocation.y;
    
    float angleToPlayer = atan2f(playerYPosition, playerXPosition);
    angleToPlayer = angleToPlayer * (180 / M_PI);
    if(angleToPlayer < 0) angleToPlayer += 360;
    angleToPlayer = 90 - angleToPlayer;
    if(angleToPlayer < 0) angleToPlayer += 360;
    
    if(angleToPlayer > 20 && angleToPlayer < 180) angleToPlayer = 20;
    if(angleToPlayer < 340 && angleToPlayer > 180) angleToPlayer = 340;
        
    
    // Right Cannon aiming
    playerXPosition = (currentLocation.x + cannonRight->location.x) - playerShipRef.currentLocation.x;
    playerYPosition = (currentLocation.y + cannonRight->location.y) - playerShipRef.currentLocation.y;
    
    float angleToPlayer2 = atan2f(playerYPosition, playerXPosition);
    angleToPlayer2 = angleToPlayer2 * (180 / M_PI);
    if(angleToPlayer2 < 0) angleToPlayer2 += 360;
    angleToPlayer2 = 90 - angleToPlayer2;
    if(angleToPlayer2 < 0) angleToPlayer2 += 360;
    
    if(angleToPlayer2 > 20 && angleToPlayer2 < 180) angleToPlayer2 = 20;
    if(angleToPlayer2 < 340 && angleToPlayer2 > 180) angleToPlayer2 = 340;
    
    
    //Rotation for polygons to match the rotation of the cannons
    for(int k = 0; k < [cannonLeft->collisionPolygonArray count]; k++){
        for(int i = 0; i < [[cannonLeft->collisionPolygonArray objectAtIndex:k] pointCount]; i++){
            Vector2f tempPoint = [[cannonLeft->collisionPolygonArray objectAtIndex:k] originalPoints][i];
            double tempAngle = DEGREES_TO_RADIANS(cannonLeft->rotation - angleToPlayer);
            [[cannonLeft->collisionPolygonArray objectAtIndex:k] originalPoints][i] = Vector2fMake((tempPoint.x * cos(tempAngle)) - (tempPoint.y * sin(tempAngle)), (tempPoint.x * sin(tempAngle)) + (tempPoint.y * cos(tempAngle)));
        }
        [[cannonLeft->collisionPolygonArray objectAtIndex:k] buildEdges];
    }

    for(int k = 0; k < [cannonLeft->collisionPolygonArray count]; k++){
        for(int i = 0; i < [[cannonRight->collisionPolygonArray objectAtIndex:k] pointCount]; i++){
            Vector2f tempPoint = [[cannonRight->collisionPolygonArray objectAtIndex:k] originalPoints][i];
            double tempAngle = DEGREES_TO_RADIANS(cannonRight->rotation - angleToPlayer2);
            [[cannonRight->collisionPolygonArray objectAtIndex:k] originalPoints][i] = Vector2fMake((tempPoint.x * cos(tempAngle)) - (tempPoint.y * sin(tempAngle)), (tempPoint.x * sin(tempAngle)) + (tempPoint.y * cos(tempAngle)));
        }
        [[cannonRight->collisionPolygonArray objectAtIndex:k] buildEdges];
    }
    
    cannonRight->rotation = angleToPlayer2;
    cannonLeft->rotation = angleToPlayer;
}

- (void)hitModule:(int)module withDamage:(int)damage {
    modularObjects[module].moduleHealth -= damage;
    
    [super hitModule:module withDamage:damage];
}

- (void)render {
    for(int i = 0; i < numberOfModules; i++) {
        if(modularObjects[i].isDead == NO || state == kAtlasState_StageOne){
            [modularObjects[i].moduleImage setRotation:modularObjects[i].rotation];
            [modularObjects[i].moduleImage renderAtPoint:CGPointMake(currentLocation.x + modularObjects[i].location.x, currentLocation.y + modularObjects[i].location.y) centerOfImage:YES];
        }
    }
    
    if(cannonRight->isDead == NO){
        [rightCannonEmitterJoint renderParticles];
    }
    if(cannonLeft->isDead == NO){
        [leftCannonEmitterJoint renderParticles];
    }
    if(mainBody->isDead == NO){
        [backEngineEnergyEmitter renderParticles];
    }
    
    // Death emitters
    if(mainBody->isDead) {
        [mainBodyDeathEmitter renderParticles];
    }
    if(cannonRight->isDead){
        if (state == kAtlasState_StageThree) {
            [rightCannonDeathEmitter renderParticles];
        }
        else {
            cannonRightFlewOff = YES;
            [rightCannonDeathSecondaryEmitter renderParticles];
            cannonRight->desiredLocation = Vector2fMake(300.0f,cannonRight->location.y);
        }
    }
    if(cannonLeft->isDead){
        if (state == kAtlasState_StageThree) {
            [leftCannonDeathEmitter renderParticles];
        }
        else {
            cannonLeftFlewOff = YES;
            [leftCannonDeathSecondaryEmitter renderParticles];
            cannonLeft->desiredLocation = Vector2fMake(-300.0f,cannonLeft->location.y);
        }
    }
    if (frontLeftTurret->isDead) {
        if (state == kAtlasState_StageThree) {
            [frontLeftTurretDeathEmitter renderParticles];
        }
        else {
            frontLeftTurretFlewOff = YES;
            [frontLeftTurretDeathSecondaryEmitter renderParticles];
            frontLeftTurret->desiredLocation = Vector2fMake(-400.0f, frontLeftTurret->location.y);
        }
    }
    if (frontRightTurret->isDead) {
        if (state == kAtlasState_StageThree) {
            [frontRightTurretDeathEmitter renderParticles];
        }
        else {
            frontRightTurretFlewOff = YES;
            [frontRightTurretDeathSecondaryEmitter renderParticles];
            frontRightTurret->desiredLocation = Vector2fMake(400.0f, frontRightTurret->location.y);
        }
    }
    if (frontCenterTurret->isDead) {
        if (state == kAtlasState_StageThree) {
            [frontCenterTurretDeathEmitter renderParticles];
        }
        else {
            frontCenterTurretFlewOff = YES;
            [frontCenterTurretDeathSecondaryEmitter renderParticles];
            frontCenterTurret->desiredLocation = Vector2fMake(frontCenterTurret->location.x, -400.0);
        }
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

- (void)dealloc {
    [leftCannonEmitterJoint release];
    [rightCannonEmitterJoint release];
    [super dealloc];
}

@end
