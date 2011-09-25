//
//  MiniBoss_SixTwo.m
//  Xenophobe
//
//  Created by James Linnell on 9/11/11.
//  Copyright 2011 PDHS. All rights reserved.
//

#import "MiniBoss_SixTwo.h"

@implementation MiniBoss_SixTwo

- (id)initWithLocation:(CGPoint)aPoint andPlayerShipRef:(PlayerShip *)playerRef
{
    self = [super initWithBossID:kMiniBoss_SixTwo initialLocation:aPoint andPlayerShipRef:playerRef];
    if (self) {
        // Initialization code here.
        state = kSixTwo_Entry;
        
        shield = &self.modularObjects[1];
        
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
        
        
        doubleBulletLeft = [[BulletProjectile alloc] initWithProjectileID:kEnemyProjectile_BulletLevelThree_Double location:Vector2fZero andAngle:-95.0f];
        doubleBulletRight = [[BulletProjectile alloc] initWithProjectileID:kEnemyProjectile_BulletLevelThree_Double location:Vector2fZero andAngle:-85.0f];
        waveLeft = [[WaveProjectile alloc] initWithProjectileID:kEnemyProjectile_WaveLevelOne_SingleSmall location:Vector2fZero andAngle:-95.0f];
        waveRight = [[WaveProjectile alloc] initWithProjectileID:kEnemyProjectile_WaveLevelOne_SingleSmall location:Vector2fZero andAngle:-85.0f];
        heatSeekerLeft = [[HeatSeekingMissile alloc] initWithProjectileID:kEnemyProjectile_HeatSeekingMissile location:Vector2fZero angle:-135.0f speed:1 rate:5 andPlayerShipRef:playerShipRef];
        heatSeekerRight = [[HeatSeekingMissile alloc] initWithProjectileID:kEnemyProjectile_HeatSeekingMissile location:Vector2fZero angle:-45.0f speed:1 rate:5 andPlayerShipRef:playerShipRef];
        
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
        
        shield->location.x += ((shield->desiredLocation.x - shield->location.x) / bossSpeed) * (pow(1.584893192, bossSpeed/3)) * delta;
        shield->location.y += ((shield->desiredLocation.y - shield->location.y) / bossSpeed) * (pow(1.584893192, bossSpeed/3)) * delta;
    }
    
    for(int i = 0; i < numberOfModules; i++){
        if(modularObjects[i].isDead == NO){
            for(Polygon *modulePoly in modularObjects[i].collisionPolygonArray){
                [modulePoly setPos:CGPointMake(modularObjects[i].location.x + currentLocation.x, modularObjects[i].location.y + currentLocation.y)];
            }
        }
    }
    
    [deathAnimation setSourcePosition:Vector2fMake(currentLocation.x, currentLocation.y)];
    
    if(shipIsDeployed){
        [doubleBulletLeft setLocation:Vector2fMake(currentLocation.x + modularObjects[0].weapons[0].weaponCoord.x, currentLocation.y + modularObjects[0].weapons[0].weaponCoord.y)];
        [doubleBulletRight setLocation:Vector2fMake(currentLocation.x + modularObjects[0].weapons[1].weaponCoord.x, currentLocation.y + modularObjects[0].weapons[1].weaponCoord.y)];
        [waveLeft setLocation:Vector2fMake(currentLocation.x + modularObjects[0].weapons[2].weaponCoord.x, currentLocation.y + modularObjects[0].weapons[2].weaponCoord.y)];
        [waveRight setLocation:Vector2fMake(currentLocation.x + modularObjects[0].weapons[3].weaponCoord.x, currentLocation.y + modularObjects[0].weapons[3].weaponCoord.y)];
        [heatSeekerLeft setLocation:Vector2fMake(currentLocation.x + modularObjects[0].weapons[4].weaponCoord.x, currentLocation.y + modularObjects[0].weapons[4].weaponCoord.y)];
        [heatSeekerRight setLocation:Vector2fMake(currentLocation.x + modularObjects[0].weapons[5].weaponCoord.x, currentLocation.y + modularObjects[0].weapons[5].weaponCoord.y)];
        
        [doubleBulletLeft update:delta];
        [doubleBulletRight update:delta];
        [waveLeft update:delta];
        [waveRight update:delta];
        [heatSeekerLeft update:delta];
        [heatSeekerRight update:delta];
    }
    
    if(state == kSixTwo_Entry){
        if(shipIsDeployed){
            state = kSixTwo_Holding;
        }
    }
    else if(state == kSixTwo_Holding){
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
            
            
            
            //Shield movement
            if(shield->location.x <= 0){
                shield->desiredLocation.x = RANDOM_0_TO_1() * 20;
            }
            else if(shield->location.x >= 0){
                shield->desiredLocation.x = RANDOM_0_TO_1() * -20;
            }
            shield->desiredLocation.y = (RANDOM_MINUS_1_TO_1() * 10) + shield->defaultLocation.y;
            
        }
        
        if(attackTimer >= 6){
            state = kSixTwo_Attacking;
            attackTimer = 0;
            holdingTimer = 0;
        }
        if(modularObjects[0].isDead){
            state = kSixTwo_Death;
        }
    }
    else if(state == kSixTwo_Attacking){
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
            state = kSixTwo_Holding;
            attackPathtimer = 0;
            [attackingPath release];
            attackingPath = nil;
        }
        if(modularObjects[0].isDead){
            state = kSixTwo_Death;
        }
    }
    if(state == kSixTwo_Death){
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
    //Make both take damage, but only allow the mainbody to die after the shield
    if(modularObjects[0].isDead && modularObjects[1].isDead == NO){
        modularObjects[0].isDead = NO;
        modularObjects[0].moduleHealth += damage;
    }
    
    shipHealth = modularObjects[0].moduleHealth + modularObjects[0].moduleMaxHealth;
    shipMaxHealth = modularObjects[0].moduleMaxHealth + modularObjects[1].moduleMaxHealth;
}

- (void)render {
    [doubleBulletLeft render];
    [doubleBulletRight render];
    [waveLeft render];
    [waveRight render];
    [heatSeekerLeft render];
    [heatSeekerRight render];
    
    if(state == kSixTwo_Death){
        [deathAnimation renderParticles];
    }
    
    for(int i = 0; i < numberOfModules; i++) {
        if(i != 0){
            if (!modularObjects[i].isDead) {
                [modularObjects[i].moduleImage setRotation:modularObjects[i].rotation];
                [modularObjects[i].moduleImage renderAtPoint:CGPointMake(currentLocation.x + modularObjects[i].location.x, currentLocation.y + modularObjects[i].location.y) centerOfImage:YES];
            }
        }
        else if(state != kSixTwo_Death){
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
