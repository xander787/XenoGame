//
//  BossShipHyperion.m
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

#import "BossShipHyperion.h"
#import "BossShip.h"


@implementation BossShipHyperion

- (id)initWithLocation:(CGPoint)aPoint andPlayershipRef:(PlayerShip *)playerRef {
    if((self = [super initWithBossID:kBoss_Hyperion initialLocation:aPoint andPlayerShipRef:playerRef])) {
        mainBody = &self.modularObjects[0];
        wingRight = &self.modularObjects[1];
        wingLeft = &self.modularObjects[2];
        
        mainBody->moduleMaxHealth = 1000;
        mainBody->moduleHealth = mainBody->moduleMaxHealth;
        
        wingRight->moduleMaxHealth = 100;
        wingRight->moduleHealth = wingRight->moduleMaxHealth;
        
        wingLeft->moduleMaxHealth = 100;
        wingLeft->moduleHealth = wingLeft->moduleMaxHealth;

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
                                                                                 duration:0.6
                                                                            blendAdditive:YES];
        
        wingLeftDeathEmitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
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
                                                                             particleSize:10.0
                                                                       finishParticleSize:10.0
                                                                     particleSizeVariance:0.0
                                                                                 duration:0.1
                                                                            blendAdditive:YES];
        wingRightDeathEmitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
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
                                                                              particleSize:10.0
                                                                        finishParticleSize:10.0
                                                                      particleSizeVariance:0.0
                                                                                  duration:0.1
                                                                             blendAdditive:YES];
        
        state = -1;
    }
    return self;
}

- (void)update:(GLfloat)delta {
    [super update:delta];
    
    if (state == -1) {
        currentLocation.x += ((desiredLocation.x - currentLocation.x) / bossSpeed) * (pow(1.584893192, bossSpeed)) * delta;
        currentLocation.y += ((desiredLocation.y - currentLocation.y) / bossSpeed) * (pow(1.584893192, bossSpeed)) * delta;
    }
    else if(state == kHyperionState_StageOne) {
        currentLocation.x += ((desiredLocation.x - currentLocation.x) / bossSpeed) * (pow(1.584893192, bossSpeed/2)) * delta;
        currentLocation.y += ((desiredLocation.y - currentLocation.y) / bossSpeed) * (pow(1.584893192, bossSpeed/2)) * delta;
    }
    else if(state == kHyperionState_StageTwo || state == kHyperionState_StageThree) { 
        currentLocation.x += ((desiredLocation.x - currentLocation.x) / bossSpeed) * (pow(1.584893192, bossSpeed/1.25)) * delta;
        currentLocation.y += ((desiredLocation.y - currentLocation.y) / bossSpeed) * (pow(1.584893192, bossSpeed/1.25)) * delta;
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
    
    if (shipIsDeployed) {
        
        [mainBodyDeathEmitter setSourcePosition:Vector2fMake(currentLocation.x, currentLocation.y)];
        [wingLeftDeathEmitter setSourcePosition:Vector2fMake(currentLocation.x + wingLeft->location.x, currentLocation.y + wingLeft->location.y)];
        [wingRightDeathEmitter setSourcePosition:Vector2fMake(currentLocation.x + wingRight->location.x, currentLocation.y + wingRight->location.y)];

        
        [mainBodyLeftProjectile setLocation:Vector2fMake(currentLocation.x + mainBody->weapons[1].weaponCoord.x, currentLocation.y + mainBody->weapons[1].weaponCoord.y)];
        [mainBodyRightProjectile setLocation:Vector2fMake(currentLocation.x + mainBody->weapons[2].weaponCoord.x, currentLocation.y + mainBody->weapons[2].weaponCoord.y)];
        [mainBodyCenterProjectile setLocation:Vector2fMake(currentLocation.x + mainBody->weapons[0].weaponCoord.x, currentLocation.y + mainBody->weapons[0].weaponCoord.y)];
        [mainBodyTailProjectile setLocation:Vector2fMake(currentLocation.x + mainBody->weapons[3].weaponCoord.x, currentLocation.y + mainBody->weapons[3].weaponCoord.y)];
        [mainBodyLeftProjectile update:delta];
        [mainBodyRightProjectile update:delta];
        [mainBodyCenterProjectile update:delta];
        [mainBodyTailProjectile update:delta];
        
        [wingLeftTurretProjectile setLocation:Vector2fMake(currentLocation.x + wingLeft->location.x + wingLeft->weapons[0].weaponCoord.x, currentLocation.y + wingLeft->location.y + wingLeft->weapons[0].weaponCoord.y)];
        [wingRightTurretProjectile setLocation:Vector2fMake(currentLocation.x + wingRight->location.x + wingRight->weapons[0].weaponCoord.x, currentLocation.y + wingRight->location.y + wingRight->weapons[0].weaponCoord.y)];
        [wingLeftTurretProjectile update:delta];
        [wingRightTurretProjectile update:delta];
        
        [wingLeftHeatSeekingProjectile setLocation:Vector2fMake(currentLocation.x + wingLeft->location.x + wingLeft->weapons[0].weaponCoord.x, currentLocation.y + wingLeft->location.y + wingLeft->weapons[0].weaponCoord.y)];
        [wingRightHeatSeekingProjectile setLocation:Vector2fMake(currentLocation.x + wingRight->location.x + wingRight->weapons[0].weaponCoord.x, currentLocation.y + wingRight->location.y + wingRight->weapons[0].weaponCoord.y)];
        [wingLeftHeatSeekingProjectile update:delta];
        [wingRightHeatSeekingProjectile update:delta];
        
        [mainBodyLeftHeatSeekingProjectile setLocation:Vector2fMake(currentLocation.x + mainBody->weapons[2].weaponCoord.x, currentLocation.y + mainBody->weapons[2].weaponCoord.y)];
        [mainBodyRightHeatSeekingProjectile setLocation:Vector2fMake(currentLocation.x + mainBody->weapons[1].weaponCoord.x, currentLocation.y + mainBody->weapons[1].weaponCoord.y)];
        [mainBodyLeftHeatSeekingProjectile update:delta];
        [mainBodyRightHeatSeekingProjectile update:delta];
        
        
        if (state == -1) {
            state = kHyperionState_StageOne;
            mainBodyRightProjectile = [[BulletProjectile alloc] initWithProjectileID:kEnemyProjectile_BulletLevelTwo_Double location:Vector2fMake(currentLocation.x + mainBody->weapons[1].weaponCoord.x, currentLocation.y + mainBody->weapons[1].weaponCoord.y) andAngle:-90.0f];
            
            mainBodyLeftProjectile = [[BulletProjectile alloc] initWithProjectileID:kEnemyProjectile_BulletLevelTwo_Double location:Vector2fMake(currentLocation.x + mainBody->weapons[2].weaponCoord.x, currentLocation.y + mainBody->weapons[2].weaponCoord.y) andAngle:-90.0f];
            
            mainBodyCenterProjectile = [[WaveProjectile alloc] initWithProjectileID:kEnemyProjectile_WaveLevelOne_SingleSmall location:Vector2fMake(currentLocation.x + mainBody->weapons[0].weaponCoord.x, currentLocation.y + mainBody->weapons[0].weaponCoord.y) andAngle:-90.0f];
            
            mainBodyTailProjectile = [[WaveProjectile alloc] initWithProjectileID:kEnemyProjectile_WaveLevelNine_DoubleBig location:Vector2fMake(currentLocation.x + mainBody->weapons[3].weaponCoord.x, currentLocation.y + mainBody->weapons[3].weaponCoord.y) andAngle:-90.0f];
            [mainBodyTailProjectile stopProjectile];
            
            wingLeftTurretProjectile = [[BulletProjectile alloc] initWithProjectileID:kEnemyProjectile_BulletLevelThree_Double location:Vector2fMake(currentLocation.x + wingLeft->location.x + wingLeft->weapons[0].weaponCoord.x, currentLocation.y + wingLeft->location.y + wingLeft->weapons[0].weaponCoord.y) andAngle:-90.0f];
            
            wingRightTurretProjectile = [[BulletProjectile alloc] initWithProjectileID:kEnemyProjectile_BulletLevelThree_Double location:Vector2fMake(currentLocation.x + wingRight->location.x + wingRight->weapons[0].weaponCoord.x, currentLocation.y + wingRight->location.y + wingRight->weapons[0].weaponCoord.y) andAngle:-90.0f];
            
            wingLeftHeatSeekingProjectile = [[HeatSeekingMissile alloc] initWithProjectileID:kEnemyProjectile_HeatSeekingMissile location:Vector2fMake(currentLocation.x + wingLeft->location.x + wingLeft->weapons[0].weaponCoord.x, currentLocation.y + wingLeft->location.y + wingLeft->weapons[0].weaponCoord.y) angle:-120.0f speed:1 rate:3 andPlayerShipRef:playerShipRef];
            [wingLeftHeatSeekingProjectile stopProjectile];
            
            wingRightHeatSeekingProjectile = [[HeatSeekingMissile alloc] initWithProjectileID:kEnemyProjectile_HeatSeekingMissile location:Vector2fMake(currentLocation.x + wingRight->location.x + wingRight->weapons[0].weaponCoord.x, currentLocation.y + wingRight->location.y + wingRight->weapons[0].weaponCoord.y) angle:-60.0f speed:1 rate:3 andPlayerShipRef:playerShipRef];
            [wingRightHeatSeekingProjectile stopProjectile];
            
            mainBodyLeftHeatSeekingProjectile = [[HeatSeekingMissile alloc] initWithProjectileID:kEnemyProjectile_HeatSeekingMissile location:Vector2fMake(currentLocation.x + mainBody->weapons[2].weaponCoord.x, currentLocation.y + mainBody->weapons[2].weaponCoord.y) angle:-120.0f speed:1 rate:3 andPlayerShipRef:playerShipRef];
            [mainBodyLeftHeatSeekingProjectile stopProjectile];
            
            mainBodyRightHeatSeekingProjectile = [[HeatSeekingMissile alloc] initWithProjectileID:kEnemyProjectile_HeatSeekingMissile location:Vector2fMake(currentLocation.x + mainBody->weapons[1].weaponCoord.x, currentLocation.y + mainBody->weapons[1].weaponCoord.y) angle:-60.0f speed:1 rate:3 andPlayerShipRef:playerShipRef];
            [mainBodyRightHeatSeekingProjectile stopProjectile];
            
            NSLog(@"Stage One");
        }
        
        if (state == kHyperionState_StageOne) {
            bossRotationTimer += delta;
            
            
            if (!bossRotated) {
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
            }
                        
            if (bossRotationTimer > 14.0f && bossReRotationTimer < 5.0f) {
                bossReRotationTimer += delta;
                bossRotated = YES;
                
                [mainBodyLeftProjectile stopProjectile];
                [mainBodyRightProjectile stopProjectile];
                [mainBodyCenterProjectile stopProjectile];
                [mainBodyTailProjectile playProjectile];
                
                [wingLeftTurretProjectile stopProjectile];
                [wingRightTurretProjectile stopProjectile];
                
                for(int i = 0; i < numberOfModules; i++){
                    if ((int)modularObjects[i].rotation != 180) {
                        modularObjects[i].rotation += 0.5;
                    }
                    else if(modularObjects[i].rotation == 180.0f) {
                        for(int k = 0; k < [modularObjects[i].collisionPolygonArray count]; k++){
                            for(int j = 0; j < [[modularObjects[i].collisionPolygonArray objectAtIndex:k] pointCount]; j++){
                                Vector2f tempPoint = [[modularObjects[i].collisionPolygonArray objectAtIndex:k] originalPoints][j];
                                double tempAngle = DEGREES_TO_RADIANS(180);
                                [[modularObjects[i].collisionPolygonArray objectAtIndex:k] originalPoints][j] = Vector2fMake((tempPoint.x * cos(tempAngle)) - (tempPoint.y * sin(tempAngle)), (tempPoint.x * sin(tempAngle)) + (tempPoint.y * cos(tempAngle)));
                            }
                            [[modularObjects[i].collisionPolygonArray objectAtIndex:k] buildEdges];
                        }
                        modularObjects[i].rotation = 180.1f;
                    }
                }
            }
            else if(bossReRotationTimer >= 5.0f) {                
                for(int i = 0; i < numberOfModules; i++){
                    if (modularObjects[i].rotation != 0.0f) {
                        modularObjects[i].rotation -= 0.5;
                    }
                }
                
                int numRotatedAlready = 0;
                for(int i = 0; i < numberOfModules; i++){
                    if ((int)modularObjects[i].rotation == 0 && modularObjects[i].rotation > 0.0f) {
                        for(int k = 0; k < [modularObjects[i].collisionPolygonArray count]; k++){
                            for(int j = 0; j < [[modularObjects[i].collisionPolygonArray objectAtIndex:k] pointCount]; j++){
                                Vector2f tempPoint = [[modularObjects[i].collisionPolygonArray objectAtIndex:k] originalPoints][j];
                                double tempAngle = DEGREES_TO_RADIANS(-180);
                                [[modularObjects[i].collisionPolygonArray objectAtIndex:k] originalPoints][j] = Vector2fMake((tempPoint.x * cos(tempAngle)) - (tempPoint.y * sin(tempAngle)), (tempPoint.x * sin(tempAngle)) + (tempPoint.y * cos(tempAngle)));
                            }
                            [[modularObjects[i].collisionPolygonArray objectAtIndex:k] buildEdges];
                        }
                        modularObjects[i].rotation = 0.0f;
                        numRotatedAlready++;
                    }
                }
                
                if (numRotatedAlready == 3) {
                    bossRotationTimer = 0.0f;
                    bossReRotationTimer = 0.0f;
                    bossRotated = NO;
                    
                    [mainBodyLeftProjectile playProjectile];
                    [mainBodyRightProjectile playProjectile];
                    [mainBodyCenterProjectile playProjectile];
                    [mainBodyTailProjectile stopProjectile];
                    
                    [wingLeftTurretProjectile playProjectile];
                    [wingRightTurretProjectile playProjectile];
                }
            }
            
            if ((mainBody->moduleHealth / mainBody->moduleMaxHealth) <= 0.50f && bossRotated == NO) {
                holdingTimer = 0.0f;
                state = kHyperionState_StageTwo;
                NSLog(@"Stage Two");
                
                
                [mainBodyLeftProjectile release];
                mainBodyLeftProjectile = [[BulletProjectile alloc] initWithProjectileID:kEnemyProjectile_BulletLevelFour_Triple location:Vector2fMake(currentLocation.x + mainBody->weapons[1].weaponCoord.x, currentLocation.y + mainBody->weapons[1].weaponCoord.y) andAngle:-90.0f];
                
                [mainBodyRightProjectile release];
                mainBodyRightProjectile = [[BulletProjectile alloc] initWithProjectileID:kEnemyProjectile_BulletLevelFour_Triple location:Vector2fMake(currentLocation.x + mainBody->weapons[2].weaponCoord.x, currentLocation.y + mainBody->weapons[2].weaponCoord.y) andAngle:-90.0f];
                
                [wingLeftTurretProjectile stopProjectile];
                [wingRightTurretProjectile stopProjectile];
                
                [wingLeftHeatSeekingProjectile playProjectile];
                [wingRightHeatSeekingProjectile playProjectile];
            }
        }
        
        if (state == kHyperionState_StageTwo) {            
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
            
            wingFlyOffTimer += delta;
            if(wingFlyOffTimer > 10.0){
                wingLeft->location.y -= 200 * delta;
                wingRight->location.y -= 200 * delta;
                
                if(wingLeft->location.y < -500 && wingRight->location.y < -500){
                    wingLeft->location.y = 600;
                    wingRight->location.y = 600;
                }
                if(wingFlyOffTimer > (10.0 + 3.0) && abs(wingLeft->location.y - wingLeft->defaultLocation.y) < 5){
                    wingLeft->location.y = wingLeft->defaultLocation.y;
                    wingRight->location.y = wingRight->defaultLocation.y;
                    
                    wingFlyOffTimer = 0;
                }
            }
            
            if(wingLeft->moduleHealth <= 0 && wingRight->moduleHealth <= 0){
                state = kHyperionState_StageThree;
                
                [wingLeftTurretProjectile stopProjectile];
                [wingRightTurretProjectile stopProjectile];
                
                [mainBodyCenterProjectile release];
                mainBodyCenterProjectile = [[WaveProjectile alloc] initWithProjectileID:kEnemyProjectile_WaveLevelSix_DoubleMedium location:Vector2fMake(currentLocation.x + mainBody->weapons[0].weaponCoord.x, currentLocation.y + mainBody->weapons[0].weaponCoord.y) andAngle:-90.0f];
                
                [wingLeftHeatSeekingProjectile stopProjectile];
                [wingRightHeatSeekingProjectile stopProjectile];
                
                [mainBodyLeftHeatSeekingProjectile playProjectile];
                [mainBodyRightHeatSeekingProjectile playProjectile];
                
                [mainBodyCenterProjectile release];
                mainBodyCenterProjectile = [[WaveProjectile alloc] initWithProjectileID:kEnemyProjectile_WaveLevelTwo_DoubleSmall location:Vector2fMake(currentLocation.x + mainBody->weapons[0].weaponCoord.x, currentLocation.y + mainBody->weapons[0].weaponCoord.y) andAngle:-90.0f];
                
                [mainBodyLeftProjectile stopProjectile];
                [mainBodyRightProjectile stopProjectile];
                
                NSLog(@"Stage Three");
            }
        }
        
        if (state == kHyperionState_StageThree) {
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
        
        
        if(wingLeft->isDead){
            [wingLeftDeathEmitter update:delta];
            [wingLeftHeatSeekingProjectile stopProjectile];
        }
        if(wingRight->isDead){
            [wingRightDeathEmitter update:delta];
            [wingRightHeatSeekingProjectile stopProjectile];
        }
        
        if(mainBody->isDead){
            mainBody->isDead = NO;
            updateMainBodyDeathEmitterBeforeDeath = YES;
        }
        if(updateMainBodyDeathEmitterBeforeDeath){
            [mainBodyDeathEmitter update:delta];
            if(mainBodyDeathEmitter.particleCount == 0){
                updateMainBodyDeathEmitterBeforeDeath = NO;
                mainBody->isDead = YES;
            }
        }
    }
}

- (void)hitModule:(int)module withDamage:(int)damage {

    if(state == kHyperionState_StageOne){
        mainBody->moduleHealth -= damage;
        [super hitModule:module withDamage:damage];
    }
    else if(state == kHyperionState_StageTwo){
        if(module == 1){
            wingRight->moduleHealth -= damage;
            [super hitModule:module withDamage:damage];
        }
        else if(module == 2){
            wingLeft->moduleHealth -= damage;
            [super hitModule:module withDamage:damage];
        }
    }
    else if(state == kHyperionState_StageThree){
        mainBody->moduleHealth -= damage;
        [super hitModule:module withDamage:damage];
    }
}

- (void)render {
    for(int i = 0; i < numberOfModules; i++) {
        if (modularObjects[i].isDead == NO) {
            if(i != 0){
                [modularObjects[i].moduleImage setRotation:modularObjects[i].rotation];
                [modularObjects[i].moduleImage renderAtPoint:CGPointMake(currentLocation.x + modularObjects[i].location.x, currentLocation.y + modularObjects[i].location.y) centerOfImage:YES];
            }
            else if(!updateMainBodyDeathEmitterBeforeDeath){
                [mainBody->moduleImage setRotation:mainBody->rotation];
                [mainBody->moduleImage renderAtPoint:CGPointMake(currentLocation.x + mainBody->location.x, currentLocation.y + mainBody->location.y) centerOfImage:YES];
            }
        }
    }
    
    [mainBodyLeftProjectile render];
    [mainBodyRightProjectile render];
    [mainBodyCenterProjectile render];
    [mainBodyTailProjectile render];
    
    [wingLeftTurretProjectile render];
    [wingRightTurretProjectile render];
    
    [wingLeftHeatSeekingProjectile render];
    [wingRightHeatSeekingProjectile render];
    
    [wingLeftDeathEmitter renderParticles];
    [wingRightDeathEmitter renderParticles];
    [mainBodyDeathEmitter renderParticles];
    
    [mainBodyLeftHeatSeekingProjectile render];
    [mainBodyRightHeatSeekingProjectile render];
    
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
    [super dealloc];
}

@end
