//
//  MiniBoss_FiveOne.m
//  Xenophobe
//
//  Created by James Linnell on 9/9/11.
//  Copyright 2011 PDHS. All rights reserved.
//

#import "MiniBoss_FiveOne.h"

@implementation MiniBoss_FiveOne

- (id)initWithLocation:(CGPoint)aPoint andPlayerShipRef:(PlayerShip *)playerRef {
    self = [super initWithBossID:kMiniBoss_FiveOne initialLocation:aPoint andPlayerShipRef:playerRef];
    if (self) {
        // Initialization code here.
        state = kFiveOne_Entry;
        
        deathAnimation = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
                                                                           position:Vector2fMake(currentLocation.x, currentLocation.y)
                                                             sourcePositionVariance:Vector2fZero
                                                                              speed:0.8
                                                                      speedVariance:0.2
                                                                   particleLifeSpan:0.8
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
                                                                           duration:0.2
                                                                      blendAdditive:YES];
        middleDeathAnimation = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
                                                                           position:Vector2fMake(currentLocation.x, currentLocation.y)
                                                             sourcePositionVariance:Vector2fZero
                                                                              speed:1.0
                                                                      speedVariance:0.2
                                                                   particleLifeSpan:1.2
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
                                                                           duration:0.2
                                                                      blendAdditive:YES];
        outerDeathAnimation = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
                                                                           position:Vector2fMake(currentLocation.x, currentLocation.y)
                                                             sourcePositionVariance:Vector2fZero
                                                                              speed:1.0
                                                                      speedVariance:0.2
                                                                   particleLifeSpan:1.4
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
                                                                           duration:0.2
                                                                      blendAdditive:YES];
        
        
        centerTripleBullet = [[BulletProjectile alloc] initWithProjectileID:kEnemyProjectile_BulletLevelFive_Triple location:Vector2fZero andAngle:-90.0f];
        centerWaveLeft = [[WaveProjectile alloc] initWithProjectileID:kEnemyProjectile_WaveLevelSix_DoubleMedium location:Vector2fZero andAngle:-120.0f];
        centerWaveRight = [[WaveProjectile alloc] initWithProjectileID:kEnemyProjectile_WaveLevelSix_DoubleMedium location:Vector2fZero andAngle:-60.0f];
        centerHeatSeekerLeft = [[HeatSeekingMissile alloc] initWithProjectileID:kEnemyProjectile_HeatSeekingMissile location:Vector2fZero angle:120.0f speed:1 rate:4 andPlayerShipRef:playerShipRef];
        centerHeatSeekerRight = [[HeatSeekingMissile alloc] initWithProjectileID:kEnemyProjectile_HeatSeekingMissile location:Vector2fZero angle:45.0f speed:1 rate:4 andPlayerShipRef:playerShipRef];
        
        middleWaveBottom = [[WaveProjectile alloc] initWithProjectileID:kEnemyProjectile_WaveLevelThree_DoubleSmall location:Vector2fZero andAngle:-90.0f];
        middleWaveTop = [[WaveProjectile alloc] initWithProjectileID:kEnemyProjectile_WaveLevelThree_DoubleSmall location:Vector2fZero andAngle:90.0f];
        middleTripleLeft = [[BulletProjectile alloc] initWithProjectileID:kEnemyProjectile_BulletLevelFour_Triple location:Vector2fZero andAngle:150.0f];
        middleTripleRight = [[BulletProjectile alloc] initWithProjectileID:kEnemyProjectile_BulletLevelFour_Triple location:Vector2fZero andAngle:-30.0f];
        
        outerWaveLeft = [[WaveProjectile alloc] initWithProjectileID:kEnemyProjectile_WaveLevelThree_DoubleSmall location:Vector2fZero andAngle:180.0f];
        outerWaveRight = [[WaveProjectile alloc] initWithProjectileID:kEnemyProjectile_WaveLevelThree_DoubleSmall location:Vector2fZero andAngle:0.0f];
        outerTripleBottomLeft = [[BulletProjectile alloc] initWithProjectileID:kEnemyProjectile_BulletLevelFour_Triple location:Vector2fZero andAngle:225.0f];
        outerTripleTopRight = [[BulletProjectile alloc] initWithProjectileID:kEnemyProjectile_BulletLevelFour_Triple location:Vector2fZero andAngle:45.0f];
        
        projectilesArray = [[NSMutableArray alloc] initWithObjects:centerTripleBullet, centerWaveLeft, centerWaveRight, centerHeatSeekerLeft, centerHeatSeekerRight,
                            middleWaveBottom, middleWaveTop, middleTripleLeft, middleTripleRight,
                            outerWaveLeft, outerWaveRight, outerTripleBottomLeft, outerTripleTopRight, nil];
    }
    return self;
}

- (void)update:(GLfloat)delta {
    [super update:delta];
    
    if(!shipIsDeployed){
        currentLocation.x += ((desiredLocation.x - currentLocation.x) / bossSpeed) * (pow(1.584893192, bossSpeed)) * delta;
        currentLocation.y += ((desiredLocation.y - currentLocation.y) / bossSpeed) * (pow(1.584893192, bossSpeed)) * delta;
    }
    else {
        currentLocation.x += ((desiredLocation.x - currentLocation.x) / bossSpeed) * (pow(1.584893192, bossSpeed/3)) * delta;
        currentLocation.y += ((desiredLocation.y - currentLocation.y) / bossSpeed) * (pow(1.584893192, bossSpeed/3)) * delta;
    }
    
    for(int i = 0; i < numberOfModules; i++){
        if(modularObjects[i].isDead == NO){
            for(Polygon *modulePoly in modularObjects[i].collisionPolygonArray){
                [modulePoly setPos:CGPointMake(modularObjects[i].location.x + currentLocation.x, modularObjects[i].location.y + currentLocation.y)];
            }
        }
    }
    
    [deathAnimation setSourcePosition:Vector2fMake(currentLocation.x, currentLocation.y)];
    [middleDeathAnimation setSourcePosition:Vector2fMake(currentLocation.x, currentLocation.y)];
    [outerDeathAnimation setSourcePosition:Vector2fMake(currentLocation.x, currentLocation.y)];
    
    if(shipIsDeployed){
        [centerTripleBullet setLocation:Vector2fMake(currentLocation.x + modularObjects[0].weapons[0].weaponCoord.x, currentLocation.y + modularObjects[0].weapons[0].weaponCoord.y)];
        [centerWaveLeft setLocation:Vector2fMake(currentLocation.x + modularObjects[0].weapons[1].weaponCoord.x, currentLocation.y + modularObjects[0].weapons[1].weaponCoord.y)];
        [centerWaveRight setLocation:Vector2fMake(currentLocation.x + modularObjects[0].weapons[2].weaponCoord.x, currentLocation.y + modularObjects[0].weapons[2].weaponCoord.y)];
        [centerHeatSeekerLeft setLocation:Vector2fMake(currentLocation.x + modularObjects[0].weapons[3].weaponCoord.x, currentLocation.y + modularObjects[0].weapons[3].weaponCoord.y)];
        [centerHeatSeekerRight setLocation:Vector2fMake(currentLocation.x + modularObjects[0].weapons[4].weaponCoord.x, currentLocation.y + modularObjects[0].weapons[4].weaponCoord.y)];
        
        [middleWaveBottom setLocation:Vector2fMake(currentLocation.x + modularObjects[1].weapons[0].weaponCoord.x, currentLocation.y + modularObjects[1].weapons[0].weaponCoord.y)];
        [middleWaveTop setLocation:Vector2fMake(currentLocation.x + modularObjects[1].weapons[1].weaponCoord.x, currentLocation.y + modularObjects[1].weapons[1].weaponCoord.y)];
        [middleTripleLeft setLocation:Vector2fMake(currentLocation.x + modularObjects[1].weapons[2].weaponCoord.x, currentLocation.y + modularObjects[1].weapons[2].weaponCoord.y)];
        [middleTripleRight setLocation:Vector2fMake(currentLocation.x + modularObjects[1].weapons[3].weaponCoord.x, currentLocation.y + modularObjects[1].weapons[3].weaponCoord.y)];
        
        [outerWaveLeft setLocation:Vector2fMake(currentLocation.x + modularObjects[2].weapons[0].weaponCoord.x, currentLocation.y + modularObjects[2].weapons[0].weaponCoord.y)];
        [outerWaveRight setLocation:Vector2fMake(currentLocation.x + modularObjects[2].weapons[1].weaponCoord.x, currentLocation.y + modularObjects[2].weapons[1].weaponCoord.y)];
        [outerTripleBottomLeft setLocation:Vector2fMake(currentLocation.x + modularObjects[2].weapons[2].weaponCoord.x, currentLocation.y + modularObjects[2].weapons[2].weaponCoord.y)];
        [outerTripleTopRight setLocation:Vector2fMake(currentLocation.x + modularObjects[2].weapons[3].weaponCoord.x, currentLocation.y + modularObjects[2].weapons[3].weaponCoord.y)];
        
        [centerTripleBullet update:delta];
        [centerWaveLeft update:delta];
        [centerWaveRight update:delta];
        [centerHeatSeekerLeft update:delta];
        [centerHeatSeekerRight update:delta];
        
        [middleWaveBottom update:delta];
        [middleWaveTop update:delta];
        [middleTripleLeft update:delta];
        [middleTripleRight update:delta];
        
        [outerWaveLeft update:delta];
        [outerWaveRight update:delta];
        [outerTripleBottomLeft update:delta];
        [outerTripleTopRight update:delta];
    }
    
    if(state == kFiveOne_Entry){
        if(shipIsDeployed){
            state = kFiveOne_Holding;
        }
    }
    else if(state == kFiveOne_Holding){
        holdingTimer += delta;
        attackTimer += delta;
        
        if(holdingTimer >= 1.2){
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
        
        GLfloat oldRotation = modularObjects[1].rotation;
        modularObjects[1].rotation += 180 * delta;
        [self rotateModule:1 aroundPositionWithOldrotation:oldRotation];
        
        oldRotation = modularObjects[2].rotation;
        modularObjects[2].rotation += 90 * delta;
        [self rotateModule:2 aroundPositionWithOldrotation:oldRotation];
        
        if(attackTimer >= 8){
            state = kFiveOne_Attacking;
            attackTimer = 0;
            holdingTimer = 0;
        }
        if(modularObjects[0].isDead){
            state = kFiveOne_Death;
        }
    }
    else if(state == kFiveOne_Attacking){
        if(!attackingPath){
            oldPointBeforeAttack = Vector2fMake(currentLocation.x, currentLocation.y);
            
            //Randomize direction
            if(RANDOM_0_TO_1() > 0.5){
                attackingPath = [[BezierCurve alloc] initCurveFrom:Vector2fMake(currentLocation.x, currentLocation.y) 
                                                     controlPoint1:Vector2fMake((160 - 350), 130)
                                                     controlPoint2:Vector2fMake((160 + 350), 130)
                                                          endPoint:Vector2fMake(currentLocation.x, currentLocation.y)
                                                          segments:50];
            }
            else {
                attackingPath = [[BezierCurve alloc] initCurveFrom:Vector2fMake(currentLocation.x, currentLocation.y) 
                                                     controlPoint1:Vector2fMake((160 + 350), 130)
                                                     controlPoint2:Vector2fMake((160 - 350), 130)
                                                          endPoint:Vector2fMake(currentLocation.x, currentLocation.y)
                                                          segments:50];
            }
        }
        attackPathtimer += delta;
        currentLocation.x = [attackingPath getPointAt:attackPathtimer/4].x;
        currentLocation.y = [attackingPath getPointAt:attackPathtimer/4].y;
        
        if(currentLocation.y > oldPointBeforeAttack.y && attackPathtimer > 1){
            state = kFiveOne_Holding;
            attackPathtimer = 0;
            [attackingPath release];
            attackingPath = nil;
        }
        if(modularObjects[0].isDead){
            state = kFiveOne_Death;
        }
    }
    if(state == kFiveOne_Death){
        [deathAnimation update:delta];
        modularObjects[0].isDead = NO;
        if(deathAnimation.particleCount == 0){
            modularObjects[0].isDead = YES;
        }
    }
}

- (void)hitModule:(int)module withDamage:(int)damage {
    modularObjects[module].moduleHealth -= damage;
    [super hitModule:module withDamage:damage];
    
    if(modularObjects[module].isDead){
        if(module == 2){
            [outerWaveLeft stopProjectile];
            [outerWaveRight stopProjectile];
            [outerTripleBottomLeft stopProjectile];
            [outerTripleTopRight stopProjectile];
        }
        else if(module == 1){
            [middleWaveBottom stopProjectile];
            [middleWaveTop stopProjectile];
            [middleTripleLeft stopProjectile];
            [middleTripleRight stopProjectile];
        }
        else if(module == 0){
            [centerTripleBullet stopProjectile];
            [centerWaveLeft stopProjectile];
            [centerWaveRight stopProjectile];
            [centerHeatSeekerLeft stopProjectile];
            [centerHeatSeekerRight stopProjectile];
        }
    }
    
    shipHealth = modularObjects[0].moduleHealth + modularObjects[1].moduleHealth + modularObjects[2].moduleHealth;
    shipMaxHealth = modularObjects[0].moduleMaxHealth + modularObjects[1].moduleMaxHealth + modularObjects[2].moduleMaxHealth;
}

- (void)rotateModule:(int)mod aroundPositionWithOldrotation:(GLfloat)oldRot {
    Vector2f tempPoint = modularObjects[mod].location;
    double tempAngle = DEGREES_TO_RADIANS(oldRot - modularObjects[mod].rotation);
    modularObjects[mod].location = Vector2fMake((tempPoint.x * cos(tempAngle)) - (tempPoint.y * sin(tempAngle)), (tempPoint.x * sin(tempAngle)) + (tempPoint.y * cos(tempAngle)));
    
    for(int k = 0; k < [modularObjects[mod].collisionPolygonArray count]; k++){
        for(int i = 0; i < [[modularObjects[mod].collisionPolygonArray objectAtIndex:k] pointCount]; i++){
            Vector2f tempPoint = [[modularObjects[mod].collisionPolygonArray objectAtIndex:k] originalPoints][i];
            double tempAngle = DEGREES_TO_RADIANS(oldRot - modularObjects[mod].rotation);
            [[modularObjects[mod].collisionPolygonArray objectAtIndex:k] originalPoints][i] = Vector2fMake((tempPoint.x * cos(tempAngle)) - (tempPoint.y * sin(tempAngle)), (tempPoint.x * sin(tempAngle)) + (tempPoint.y * cos(tempAngle)));
        }
        [[modularObjects[mod].collisionPolygonArray objectAtIndex:k] buildEdges];
    }
    
    for(int i = 0; i < modularObjects[mod].numberOfWeapons; i++){
        Vector2f tempPoint2 = modularObjects[mod].weapons[i].weaponCoord;
        double tempAngle2 = DEGREES_TO_RADIANS(oldRot - modularObjects[mod].rotation);
        modularObjects[mod].weapons[i].weaponCoord = Vector2fMake((tempPoint2.x * cos(tempAngle2)) - (tempPoint2.y * sin(tempAngle2)),
                                                                  (tempPoint2.x * sin(tempAngle2)) + (tempPoint2.y * cos(tempAngle2)));
    }
}

- (void)render {
    [centerTripleBullet render];
    [centerWaveLeft render];
    [centerWaveRight render];
    [centerHeatSeekerLeft render];
    [centerHeatSeekerRight render];
    
    [middleWaveBottom render];
    [middleWaveTop render];
    [middleTripleLeft render];
    [middleTripleRight render];
    
    [outerWaveLeft render];
    [outerWaveRight render];
    [outerTripleBottomLeft render];
    [outerTripleTopRight render];
    
    if(state == kFiveOne_Death){
        [deathAnimation renderParticles];
    }
    
    for(int i = 0; i < numberOfModules; i++) {
        if(i != 0){
            if (!modularObjects[i].isDead) {
                [modularObjects[i].moduleImage setRotation:modularObjects[i].rotation];
                [modularObjects[i].moduleImage renderAtPoint:CGPointMake(currentLocation.x + modularObjects[i].location.x, currentLocation.y + modularObjects[i].location.y) centerOfImage:YES];
            }
        }
        else if(state != kFiveOne_Death){
            [modularObjects[0].moduleImage setRotation:modularObjects[i].rotation];
            [modularObjects[0].moduleImage renderAtPoint:CGPointMake(currentLocation.x + modularObjects[i].location.x, currentLocation.y + modularObjects[i].location.y) centerOfImage:YES];
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

@end
