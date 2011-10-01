//
//  MiniBoss_FourTwo.m
//  Xenophobe
//
//  Created by James Linnell on 9/16/11.
//  Copyright 2011 PDHS. All rights reserved.
//

#import "MiniBoss_FourTwo.h"

@implementation MiniBoss_FourTwo

- (id)initWithLocation:(CGPoint)aPoint andPlayerShipRef:(PlayerShip *)playerRef
{
    self = [super initWithBossID:kMiniBoss_FourTwo initialLocation:aPoint andPlayerShipRef:playerRef];
    if (self) {
        // Initialization code here.
        state = kFourTwo_Entry;
        
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
        
        particle = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
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
                                                                 particleSize:20
                                                           finishParticleSize:20
                                                         particleSizeVariance:2
                                                                     duration:-1
                                                                blendAdditive:YES];
        
        
        doubleBulletLeft = [[BulletProjectile alloc] initWithProjectileID:kEnemyProjectile_BulletLevelTwo_Double location:Vector2fZero andAngle:-90.0f];
        doubleBulletRight = [[BulletProjectile alloc] initWithProjectileID:kEnemyProjectile_BulletLevelTwo_Double location:Vector2fZero andAngle:-90.0f];
        heatSeekerCenter = [[HeatSeekingMissile alloc] initWithProjectileID:kEnemyProjectile_HeatSeekingMissile location:Vector2fZero angle:-90.0f speed:1 rate:5 andPlayerShipRef:playerShipRef];
        heatSeekerLeft = [[HeatSeekingMissile alloc] initWithProjectileID:kEnemyProjectile_HeatSeekingMissile location:Vector2fZero angle:240.0f speed:0.8 rate:5 andPlayerShipRef:playerShipRef];
        heatSeekerRight = [[HeatSeekingMissile alloc] initWithProjectileID:kEnemyProjectile_HeatSeekingMissile location:Vector2fZero angle:300.0f speed:0.8 rate:5 andPlayerShipRef:playerShipRef];
        heatSeekerFarLeft = [[HeatSeekingMissile alloc] initWithProjectileID:kEnemyProjectile_HeatSeekingMissile location:Vector2fZero angle:210.0f speed:0.8 rate:5 andPlayerShipRef:playerShipRef];
        heatSeekerFarRight = [[HeatSeekingMissile alloc] initWithProjectileID:kEnemyProjectile_HeatSeekingMissile location:Vector2fZero angle:330.0f speed:0.8 rate:5 andPlayerShipRef:playerShipRef];
        
        projectilesArray = [[NSMutableArray alloc] initWithObjects:doubleBulletLeft, doubleBulletRight, heatSeekerCenter, heatSeekerLeft, heatSeekerRight, heatSeekerFarLeft, heatSeekerFarRight, nil];
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
    [particle setSourcePosition:Vector2fMake(currentLocation.x, currentLocation.y + (-10))];
    
    if(shipIsDeployed){
        [doubleBulletLeft setLocation:Vector2fMake(currentLocation.x + modularObjects[0].weapons[6].weaponCoord.x, currentLocation.y + modularObjects[0].weapons[6].weaponCoord.y)];
        [doubleBulletRight setLocation:Vector2fMake(currentLocation.x + modularObjects[0].weapons[5].weaponCoord.x, currentLocation.y + modularObjects[0].weapons[5].weaponCoord.y)];
        [heatSeekerCenter setLocation:Vector2fMake(currentLocation.x + modularObjects[0].weapons[0].weaponCoord.x, currentLocation.y + modularObjects[0].weapons[0].weaponCoord.y)];
        [heatSeekerLeft setLocation:Vector2fMake(currentLocation.x + modularObjects[0].weapons[3].weaponCoord.x, currentLocation.y + modularObjects[0].weapons[3].weaponCoord.y)];
        [heatSeekerRight setLocation:Vector2fMake(currentLocation.x + modularObjects[0].weapons[4].weaponCoord.x, currentLocation.y + modularObjects[0].weapons[4].weaponCoord.y)];
        [heatSeekerFarLeft setLocation:Vector2fMake(currentLocation.x + modularObjects[0].weapons[1].weaponCoord.x, currentLocation.y + modularObjects[0].weapons[1].weaponCoord.y)];
        [heatSeekerFarRight setLocation:Vector2fMake(currentLocation.x + modularObjects[0].weapons[2].weaponCoord.x, currentLocation.y + modularObjects[0].weapons[2].weaponCoord.y)];
        
        [doubleBulletLeft update:delta];
        [doubleBulletRight update:delta];
        [heatSeekerCenter update:delta];
        if((modularObjects[0].moduleHealth / modularObjects[0].moduleMaxHealth) <= 0.5){
            [heatSeekerLeft update:delta];
            [heatSeekerRight update:delta];
        }
        [heatSeekerFarLeft update:delta];
        [heatSeekerFarRight update:delta];
    }
    
    if(modularObjects[0].isDead == NO){
        [particle update:delta];
    }
    
    if(state == kFourTwo_Entry){
        if(shipIsDeployed){
            state = kFourTwo_Holding;
        }
    }
    else if(state == kFourTwo_Holding){
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
        
        if(attackTimer >= 6){
            state = kFourTwo_Attacking;
            attackTimer = 0;
            holdingTimer = 0;
        }
        if(modularObjects[0].isDead){
            state = kFourTwo_Death;
        }
    }
    else if(state == kFourTwo_Attacking){
        if(!attackingPath){
            oldPointBeforeAttack = Vector2fMake(currentLocation.x, currentLocation.y);
            
            //Randomize direction
            if(RANDOM_0_TO_1() > 0.5){
                attackingPath = [[BezierCurve alloc] initCurveFrom:Vector2fMake(currentLocation.x, currentLocation.y) 
                                                     controlPoint1:Vector2fMake((160 - 350), 100)
                                                     controlPoint2:Vector2fMake((160 + 350), 100)
                                                          endPoint:Vector2fMake(currentLocation.x, currentLocation.y)
                                                          segments:50];
            }
            else {
                attackingPath = [[BezierCurve alloc] initCurveFrom:Vector2fMake(currentLocation.x, currentLocation.y) 
                                                     controlPoint1:Vector2fMake((160 + 350), 100)
                                                     controlPoint2:Vector2fMake((160 - 350), 100)
                                                          endPoint:Vector2fMake(currentLocation.x, currentLocation.y)
                                                          segments:50];
            }
        }
        attackPathtimer += delta;
        currentLocation.x = [attackingPath getPointAt:attackPathtimer/4].x;
        currentLocation.y = [attackingPath getPointAt:attackPathtimer/4].y;
        
        if(abs(oldPointBeforeAttack.x - currentLocation.x) <= 5 && abs(oldPointBeforeAttack.y - currentLocation.y) <= 5 && attackPathtimer > 1){
            state = kFourTwo_Holding;
            attackPathtimer = 0;
            [attackingPath release];
            attackingPath = nil;
        }
        if(modularObjects[0].isDead){
            state = kFourTwo_Death;
        }
    }
    if(state == kFourTwo_Death){
        [doubleBulletLeft stopProjectile];
        [doubleBulletRight stopProjectile];
        [heatSeekerCenter stopProjectile];
        [heatSeekerLeft stopProjectile];
        [heatSeekerRight stopProjectile];
        [heatSeekerFarLeft stopProjectile];
        [heatSeekerFarRight stopProjectile];
        
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
    
    shipHealth = modularObjects[0].moduleHealth;
    shipMaxHealth = modularObjects[0].moduleMaxHealth;
}

- (void)render {
    [doubleBulletLeft render];
    [doubleBulletRight render];
    [heatSeekerCenter render];
    [heatSeekerLeft render];
    [heatSeekerRight render];
    [heatSeekerFarLeft render];
    [heatSeekerFarRight render];
    
    if(state == kFourTwo_Death){
        [deathAnimation renderParticles];
        [particle renderParticles];
    }
    
    for(int i = 0; i < numberOfModules; i++) {
        if(i != 0){
            if (!modularObjects[i].isDead) {
                [modularObjects[i].moduleImage setRotation:modularObjects[i].rotation];
                [modularObjects[i].moduleImage renderAtPoint:CGPointMake(currentLocation.x + modularObjects[i].location.x, currentLocation.y + modularObjects[i].location.y) centerOfImage:YES];
            }
        }
        else if(state != kFourTwo_Death){
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
