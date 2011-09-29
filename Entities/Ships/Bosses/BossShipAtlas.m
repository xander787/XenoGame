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
                                                                                   position:Vector2fMake(currentLocation.x - 105, 0)
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
        
        
        //Projectiles:
        frontCenterTurretProjectile = [[HeatSeekingMissile alloc] initWithProjectileID:kEnemyProjectile_HeatSeekingMissile location:Vector2fZero angle:-90.0f speed:0.5 rate:5 andPlayerShipRef:playerShipRef];
        frontLeftTurretProjectile = [[BulletProjectile alloc] initWithProjectileID:kEnemyProjectile_BulletLevelFour_Triple location:Vector2fZero andAngle:-105.0f];
        frontRightTurretProjectile = [[BulletProjectile alloc] initWithProjectileID:kEnemyProjectile_BulletLevelFour_Triple location:Vector2fZero andAngle:-75.0f];
        cannonLeftProjectile = [[ParticleProjectile alloc] initWithProjectileID:kEnemyParticle_Single location:Vector2fZero angle:0 radius:7 andFireRate:4];
        cannonRightProjectile = [[ParticleProjectile alloc] initWithProjectileID:kEnemyParticle_Single location:Vector2fZero angle:0 radius:7 andFireRate:4];
        shipFarLeftProjectile = [[WaveProjectile alloc] initWithProjectileID:kEnemyProjectile_WaveLevelOne_SingleSmall location:Vector2fZero andAngle:-100.0f];
        shipFarRightProjectile = [[WaveProjectile alloc] initWithProjectileID:kEnemyProjectile_WaveLevelOne_SingleSmall location:Vector2fZero andAngle:-80.0f];
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
    else if(state == kAtlasState_StageTwo) {
        currentLocation.x += ((desiredLocation.x - currentLocation.x) / bossSpeed) * (pow(1.584893192, bossSpeed/3)) * delta;
        currentLocation.y += ((desiredLocation.y - currentLocation.y) / bossSpeed) * (pow(1.584893192, bossSpeed/3)) * delta;
    }
    else if(state == kAtlasState_StageThree) {
        currentLocation.x += ((desiredLocation.x - currentLocation.x) / bossSpeed) * (pow(1.584893192, bossSpeed/3)) * delta;
        currentLocation.y += ((desiredLocation.y - currentLocation.y) / bossSpeed) * (pow(1.584893192, bossSpeed/3)) * delta;
    }
    else if(state == kAtlasState_StageFour) {
        currentLocation.x += ((desiredLocation.x - currentLocation.x) / bossSpeed) * (pow(1.584893192, bossSpeed/3)) * delta;
        currentLocation.y += ((desiredLocation.y - currentLocation.y) / bossSpeed) * (pow(1.584893192, bossSpeed/3)) * delta;
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

    //Update projectile positions
    if(shipIsDeployed){
        [frontCenterTurretProjectile setLocation:Vector2fMake(currentLocation.x + frontCenterTurret->location.x + frontCenterTurret->weapons[0].weaponCoord.x, currentLocation.y + frontCenterTurret->location.y + frontCenterTurret->weapons[0].weaponCoord.y)];
        [frontLeftTurretProjectile setLocation:Vector2fMake(currentLocation.x + frontLeftTurret->location.x + frontLeftTurret->weapons[0].weaponCoord.x, currentLocation.y + frontLeftTurret->location.y + frontLeftTurret->weapons[0].weaponCoord.y)];
        [frontRightTurretProjectile setLocation:Vector2fMake(currentLocation.x + frontRightTurret->location.x + frontRightTurret->weapons[0].weaponCoord.x, currentLocation.y + frontRightTurret->location.y + frontRightTurret->weapons[0].weaponCoord.y)];
        [cannonLeftProjectile setLocation:Vector2fMake(currentLocation.x + cannonLeft->location.x + cannonLeft->weapons[0].weaponCoord.x, currentLocation.y + cannonLeft->location.y + cannonLeft->weapons[0].weaponCoord.y)];
        [cannonRightProjectile setLocation:Vector2fMake(currentLocation.x + cannonRight->location.x + cannonRight->weapons[0].weaponCoord.x, currentLocation.y + cannonRight->location.y + cannonRight->weapons[0].weaponCoord.y)];
        [shipLeftProjectile setLocation:Vector2fMake(currentLocation.x + mainBody->location.x + mainBody->weapons[1].weaponCoord.x, currentLocation.y + mainBody->location.y + mainBody->weapons[1].weaponCoord.y)];
        [shipFarLeftProjectile setLocation:Vector2fMake(currentLocation.x + mainBody->location.x + mainBody->weapons[0].weaponCoord.x, currentLocation.y + mainBody->location.y + mainBody->weapons[0].weaponCoord.y)];
        [shipRightProjectile setLocation:Vector2fMake(currentLocation.x + mainBody->location.x + mainBody->weapons[4].weaponCoord.x, currentLocation.y + mainBody->location.y + mainBody->weapons[4].weaponCoord.y)];
        [shipFarRightProjectile setLocation:Vector2fMake(currentLocation.x + mainBody->location.x + mainBody->weapons[3].weaponCoord.x, currentLocation.y + mainBody->location.y + mainBody->weapons[3].weaponCoord.y)];
        [shipWingLeftProjectile setLocation:Vector2fMake(currentLocation.x + mainBody->location.x + mainBody->weapons[2].weaponCoord.x, currentLocation.y + mainBody->location.y + mainBody->weapons[2].weaponCoord.y)];
        [shipWingRightProjectile setLocation:Vector2fMake(currentLocation.x + mainBody->location.x + mainBody->weapons[5].weaponCoord.x, currentLocation.y + mainBody->location.y + mainBody->weapons[5].weaponCoord.y)];
    }
    
    if (mainBody->isDead && !updateMainBodyDeathEmitter) {
        updateMainBodyDeathEmitter = YES;
    }
    if(updateMainBodyDeathEmitter){
        [mainBodyDeathEmitter update:delta];
        if([mainBodyDeathEmitter particleCount] == 0){
            mainBody->isDead = YES;
        }
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
    
    /*
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
    }*/
    
        
    [rightCannonEmitterJoint setSourcePosition:Vector2fMake(currentLocation.x + 115, currentLocation.y - 30)];
    [leftCannonEmitterJoint setSourcePosition:Vector2fMake(currentLocation.x + (-115), currentLocation.y - 30)];
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
            
            //Projectile updating:
            [cannonLeftProjectile setAngle:270 - cannonLeft->rotation];
            [cannonLeftProjectile update:delta];
            [cannonRightProjectile setAngle:270 - cannonRight->rotation];
            [cannonRightProjectile update:delta];
            [frontCenterTurretProjectile update:delta];
            [frontLeftTurretProjectile update:delta];
            [frontRightTurretProjectile update:delta];
            [shipFarLeftProjectile update:delta];
            [shipFarRightProjectile update:delta];
            
            if(cannonLeft->isDead){
                [cannonLeftProjectile stopProjectile];
            }
            if(cannonRight->isDead){
                [cannonRightProjectile stopProjectile];
            }
            if(frontCenterTurret->isDead){
                [frontCenterTurretProjectile stopProjectile];
            }
            if(frontLeftTurret->isDead){
                [frontLeftTurretProjectile stopProjectile];
            }
            if(frontRightTurret->isDead){
                [frontRightTurretProjectile stopProjectile];
            }
            
            if (cannonRightFlewOff && cannonLeftFlewOff && frontCenterTurretFlewOff && frontRightTurretFlewOff && frontLeftTurretFlewOff) {
                desiredLocation = CGPointMake(160.0f, currentLocation.y);
//                currentStagePaused = YES;
                state = kAtlasState_StageTwo;
                
                NSLog(@"Stge Two Begin");
                
                //Update projectiles
                shipLeftProjectile = [[WaveProjectile alloc] initWithProjectileID:kEnemyProjectile_WaveLevelOne_SingleSmall location:Vector2fZero andAngle:-90.0f];
                shipRightProjectile = [[WaveProjectile alloc] initWithProjectileID:kEnemyProjectile_WaveLevelOne_SingleSmall location:Vector2fZero andAngle:-90.0f];
                shipWingLeftProjectile = [[HeatSeekingMissile alloc] initWithProjectileID:kEnemyProjectile_HeatSeekingMissile location:Vector2fZero angle:-110.0f speed:0.8 rate:6 andPlayerShipRef:playerShipRef];
                shipWingRightProjectile = [[HeatSeekingMissile alloc] initWithProjectileID:kEnemyProjectile_HeatSeekingMissile location:Vector2fZero angle:-70.0f speed:0.8 rate:6 andPlayerShipRef:playerShipRef];
            }
        }
        else if(state == kAtlasState_StageTwo){
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
            
            //Projectile updating:
            [shipLeftProjectile update:delta];
            [shipFarLeftProjectile update:delta];
            [shipRightProjectile update:delta];
            [shipFarRightProjectile update:delta];
            [shipWingLeftProjectile update:delta];
            [shipWingRightProjectile update:delta];
            
            if(mainBody->moduleHealth <= mainBody->moduleMaxHealth/2){
                state = kAtlasState_StageThree;
                NSLog(@"Stage Three Begin");
                currentDestructionOrder = 0;
                
                // Revive the weapons!
                cannonRight->desiredLocation = cannonRight->defaultLocation;
                cannonLeft->desiredLocation = cannonLeft->defaultLocation;
                frontCenterTurret->desiredLocation = frontCenterTurret->defaultLocation;
                frontLeftTurret->desiredLocation = frontLeftTurret->defaultLocation;
                frontRightTurret->desiredLocation = frontRightTurret->defaultLocation;
                
                cannonRight->moduleHealth = cannonRight->moduleMaxHealth;
                cannonLeft->moduleHealth = cannonLeft->moduleMaxHealth;
                frontCenterTurret->moduleHealth = frontCenterTurret->moduleMaxHealth;
                frontLeftTurret->moduleHealth = frontLeftTurret->moduleMaxHealth;
                frontRightTurret->moduleHealth = frontRightTurret->moduleMaxHealth;
                
                cannonRight->isDead = NO;
                cannonLeft->isDead = NO;
                frontCenterTurret->isDead = NO;
                frontLeftTurret->isDead = NO;
                frontRightTurret->isDead = NO;
                
                cannonRightFlewOff = NO;
                cannonLeftFlewOff = NO;
                frontCenterTurretFlewOff = NO;
                frontLeftTurretFlewOff = NO;
                frontRightTurretFlewOff = NO;
                
                [leftCannonDeathEmitter stopParticleEmitter];
                [leftCannonDeathEmitter setActive:YES];
                [rightCannonDeathEmitter stopParticleEmitter];
                [rightCannonDeathEmitter setActive: YES];
                [frontCenterTurretDeathEmitter stopParticleEmitter];
                [frontCenterTurretDeathEmitter setActive:YES];
                [frontLeftTurretDeathEmitter stopParticleEmitter];
                [frontLeftTurretDeathEmitter setActive:YES];
                [frontRightTurretDeathEmitter stopParticleEmitter];
                [frontRightTurretDeathEmitter setActive:YES];
                
                //Proj
                [frontLeftTurretProjectile release];
                frontLeftTurretProjectile = [[BulletProjectile alloc] initWithProjectileID:kEnemyProjectile_BulletLevelTwo_Double location:Vector2fZero andAngle:-100.0f];
                [frontRightTurretProjectile release];
                frontRightTurretProjectile = [[BulletProjectile alloc] initWithProjectileID:kEnemyProjectile_BulletLevelTwo_Double location:Vector2fZero andAngle:-80.0f];
                [frontCenterTurretProjectile release];
                frontCenterTurretProjectile = [[WaveProjectile alloc] initWithProjectileID:kEnemyProjectile_WaveLevelOne_SingleSmall location:Vector2fZero andAngle:-90.0f];
                [shipWingLeftProjectile release];
                shipWingLeftProjectile = [[BulletProjectile alloc] initWithProjectileID:kEnemyProjectile_BulletLevelTwo_Double location:Vector2fZero andAngle:-90.0f];
                [shipWingRightProjectile release];
                shipWingRightProjectile = [[BulletProjectile alloc] initWithProjectileID:kEnemyProjectile_BulletLevelTwo_Double location:Vector2fZero andAngle:-90.0f];
            }
        }
        else if(state == kAtlasState_StageThree){
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
            
            //Proj
            [frontCenterTurretProjectile update:delta];
            [frontLeftTurretProjectile update:delta];
            [frontRightTurretProjectile update:delta];
            [cannonLeftProjectile update:delta];
            [cannonRightProjectile update:delta];
            [shipLeftProjectile update:delta];
            [shipRightProjectile update:delta];
            [shipWingLeftProjectile update:delta];
            [shipWingRightProjectile update:delta];
            
            if(cannonLeft->isDead){
                [cannonLeftProjectile stopProjectile];
            }
            if(cannonRight->isDead){
                [cannonRightProjectile stopProjectile];
            }
            if(frontCenterTurret->isDead){
                [frontCenterTurretProjectile stopProjectile];
            }
            if(frontLeftTurret->isDead){
                [frontLeftTurretProjectile stopProjectile];
            }
            if(frontRightTurret->isDead){
                [frontRightTurretProjectile stopProjectile];
            }
            
            if (cannonRightFlewOff && cannonLeftFlewOff && frontCenterTurretFlewOff && frontRightTurretFlewOff && frontLeftTurretFlewOff) {
                state = kAtlasState_StageFour;
                NSLog(@"Stage Four begin");
                
                [shipLeftProjectile release];
                shipLeftProjectile = [[WaveProjectile alloc] initWithProjectileID:kEnemyProjectile_WaveLevelTwo_DoubleSmall location:Vector2fZero andAngle:-90.0f];
                [shipRightProjectile release];
                shipRightProjectile = [[WaveProjectile alloc] initWithProjectileID:kEnemyProjectile_WaveLevelTwo_DoubleSmall location:Vector2fZero andAngle:-90.0f];
                [shipWingLeftProjectile release];
                shipWingLeftProjectile = [[BulletProjectile alloc] initWithProjectileID:kEnemyProjectile_BulletLevelFive_Triple location:Vector2fZero andAngle:-100.0f];
                [shipWingRightProjectile release];
                shipWingRightProjectile = [[BulletProjectile alloc] initWithProjectileID:kEnemyProjectile_BulletLevelFive_Triple location:Vector2fZero andAngle:-80.0f];
            }
        }
        else if(state == kAtlasState_StageFour){
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
            }
            
            //Proj
            [shipLeftProjectile update:delta];
            [shipRightProjectile update:delta];
            [shipWingLeftProjectile update:delta];
            [shipWingRightProjectile update:delta];
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
            cannonLeft->moduleHealth = cannonLeft->moduleMaxHealth;
            frontCenterTurret->moduleHealth = frontCenterTurret->moduleMaxHealth;
            frontLeftTurret->moduleHealth = frontLeftTurret->moduleMaxHealth;
            frontRightTurret->moduleHealth = frontRightTurret->moduleMaxHealth;
            
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
    if(state == kAtlasState_StageOne){
        [frontCenterTurretProjectile render];
        [frontLeftTurretProjectile render];
        [frontRightTurretProjectile render];
        [cannonLeftProjectile render];
        [cannonRightProjectile render];
        [shipFarLeftProjectile render];
        [shipFarRightProjectile render];
    }
    else if(state == kAtlasState_StageTwo){
        [shipLeftProjectile render];
        [shipFarLeftProjectile render];
        [shipWingLeftProjectile render];
        [shipRightProjectile render];
        [shipFarRightProjectile render];
        [shipWingRightProjectile render];
    }
    else if(state == kAtlasState_StageThree){
        [frontCenterTurretProjectile render];
        [frontLeftTurretProjectile render];
        [frontRightTurretProjectile render];
        [cannonLeftProjectile render];
        [cannonRightProjectile render];
        [shipLeftProjectile render];
        [shipWingLeftProjectile render];
        [shipRightProjectile render];
        [shipWingRightProjectile render];
    }
    else if(state == kAtlasState_StageFour){
        [shipLeftProjectile render];
        [shipWingLeftProjectile render];
        [shipRightProjectile render];
        [shipWingRightProjectile render];
    }
    
    
    for(int i = 0; i < numberOfModules; i++) {
        if(modularObjects[i].isDead == NO || state == kAtlasState_StageOne || state == kAtlasState_StageThree){
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
    if(updateMainBodyDeathEmitter) {
        [mainBodyDeathEmitter renderParticles];
    }
    if(cannonRight->isDead){
        if (state == kAtlasState_StageThree) {
            cannonRightFlewOff = YES;
            [rightCannonDeathEmitter renderParticles];
            cannonRight->desiredLocation = Vector2fMake(300.0f,cannonRight->location.y);
        }
        else {
            cannonRightFlewOff = YES;
            [rightCannonDeathSecondaryEmitter renderParticles];
            cannonRight->desiredLocation = Vector2fMake(300.0f,cannonRight->location.y);
        }
    }
    if(cannonLeft->isDead){
        if (state == kAtlasState_StageThree) {
            cannonLeftFlewOff = YES;
            [leftCannonDeathEmitter renderParticles];
            cannonLeft->desiredLocation = Vector2fMake(-300.0f,cannonLeft->location.y);
        }
        else {
            cannonLeftFlewOff = YES;
            [leftCannonDeathSecondaryEmitter renderParticles];
            cannonLeft->desiredLocation = Vector2fMake(-300.0f,cannonLeft->location.y);
        }
    }
    if (frontLeftTurret->isDead) {
        if (state == kAtlasState_StageThree) {
            frontLeftTurretFlewOff = YES;
            [frontLeftTurretDeathEmitter renderParticles];
            frontLeftTurret->desiredLocation = Vector2fMake(-400.0f, frontLeftTurret->location.y);
        }
        else {
            frontLeftTurretFlewOff = YES;
            [frontLeftTurretDeathSecondaryEmitter renderParticles];
            frontLeftTurret->desiredLocation = Vector2fMake(-400.0f, frontLeftTurret->location.y);
        }
    }
    if (frontRightTurret->isDead) {
        if (state == kAtlasState_StageThree) {
            frontRightTurretFlewOff = YES;
            [frontRightTurretDeathEmitter renderParticles];
            frontRightTurret->desiredLocation = Vector2fMake(400.0f, frontRightTurret->location.y);
        }
        else {
            frontRightTurretFlewOff = YES;
            [frontRightTurretDeathSecondaryEmitter renderParticles];
            frontRightTurret->desiredLocation = Vector2fMake(400.0f, frontRightTurret->location.y);
        }
    }
    if (frontCenterTurret->isDead) {
        if (state == kAtlasState_StageThree) {
            frontCenterTurretFlewOff = YES;
            [frontCenterTurretDeathEmitter renderParticles];
            frontCenterTurret->desiredLocation = Vector2fMake(frontCenterTurret->location.x, -400.0);
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
