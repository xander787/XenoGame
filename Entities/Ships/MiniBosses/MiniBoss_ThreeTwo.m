//
//  MiniBoss_ThreeTwo.m
//  Xenophobe
//
//  Created by James Linnell on 9/10/11.
//  Copyright 2011 PDHS. All rights reserved.
//

#import "MiniBoss_ThreeTwo.h"

@implementation MiniBoss_ThreeTwo

- (id)initWithLocation:(CGPoint)aPoint andPlayerShipRef:(PlayerShip *)playerRef {
    self = [super initWithBossID:kMiniBoss_ThreeTwo initialLocation:aPoint andPlayerShipRef:playerRef];
    if (self) {
        // Initialization code here.
        state = kThreeTwo_Entry;
        
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
        
        
        singleTopBullet = [[BulletProjectile alloc] initWithProjectileID:kEnemyProjectile_BulletLevelOne_Single location:Vector2fZero andAngle:-90.0f];
        singleLeftBullet = [[BulletProjectile alloc] initWithProjectileID:kEnemyProjectile_BulletLevelOne_Single location:Vector2fZero andAngle:150.0f];
        singleRightBullet = [[BulletProjectile alloc] initWithProjectileID:kEnemyProjectile_BulletLevelOne_Single location:Vector2fZero andAngle:30.0f];
        doubleTopBullet = [[BulletProjectile alloc] initWithProjectileID:kEnemyProjectile_BulletLevelTwo_Double location:Vector2fZero andAngle:90.0f];
        doubleLeftBullet = [[BulletProjectile alloc] initWithProjectileID:kEnemyProjectile_BulletLevelTwo_Double location:Vector2fZero andAngle:210.0f];
        doubleRightBullet = [[BulletProjectile alloc] initWithProjectileID:kEnemyProjectile_BulletLevelTwo_Double location:Vector2fZero andAngle:-30.0f];
        
        projectilesArray = [[NSMutableArray alloc] initWithObjects:singleTopBullet, singleLeftBullet, singleRightBullet, doubleTopBullet, doubleLeftBullet, doubleRightBullet, nil];
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
    
    if(shipIsDeployed){
        [singleTopBullet setLocation:Vector2fMake(currentLocation.x + modularObjects[0].weapons[5].weaponCoord.x, currentLocation.y + modularObjects[0].weapons[5].weaponCoord.y)];
        [singleLeftBullet setLocation:Vector2fMake(currentLocation.x + modularObjects[0].weapons[3].weaponCoord.x, currentLocation.y + modularObjects[0].weapons[3].weaponCoord.y)];
        [singleRightBullet setLocation:Vector2fMake(currentLocation.x + modularObjects[0].weapons[4].weaponCoord.x, currentLocation.y + modularObjects[0].weapons[4].weaponCoord.y)];
        [doubleTopBullet setLocation:Vector2fMake(currentLocation.x + modularObjects[0].weapons[2].weaponCoord.x, currentLocation.y + modularObjects[0].weapons[2].weaponCoord.y)];
        [doubleLeftBullet setLocation:Vector2fMake(currentLocation.x + modularObjects[0].weapons[0].weaponCoord.x, currentLocation.y + modularObjects[0].weapons[0].weaponCoord.y)];
        [doubleRightBullet setLocation:Vector2fMake(currentLocation.x + modularObjects[0].weapons[1].weaponCoord.x, currentLocation.y + modularObjects[0].weapons[1].weaponCoord.y)];
        
        [singleTopBullet update:delta];
        [singleLeftBullet update:delta];
        [singleRightBullet update:delta];
        [doubleTopBullet update:delta];
        [doubleLeftBullet update:delta];
        [doubleRightBullet update:delta];
    }
    
    if(state == kThreeTwo_Entry){
        if(shipIsDeployed){
            state = kThreeTwo_Holding;
        }
    }
    else if(state == kThreeTwo_Holding){
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
        
        GLfloat oldRotation;
        oldRotation = modularObjects[0].rotation;
        modularObjects[0].rotation += 180 * delta;
        
        [self rotateModule:0 aroundPositionWithOldrotation:oldRotation];
        
        [singleTopBullet setAngle:modularObjects[0].rotation + -90.0f];
        [singleLeftBullet setAngle:modularObjects[0].rotation + 150.0f];
        [singleRightBullet setAngle:modularObjects[0].rotation + 30.0f];
        [doubleTopBullet setAngle:modularObjects[0].rotation + 90.0f];
        [doubleLeftBullet setAngle:modularObjects[0].rotation + 210.0f];
        [doubleRightBullet setAngle:modularObjects[0].rotation + -30.0f];
        
        if(attackTimer >= 6){
            state = kThreeTwo_Attacking;
            attackTimer = 0;
            holdingTimer = 0;
        }
        if(modularObjects[0].isDead){
            state = kThreeTwo_Death;
        }
    }
    else if(state == kThreeTwo_Attacking){
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
            state = kThreeTwo_Holding;
            attackPathtimer = 0;
            [attackingPath release];
            attackingPath = nil;
        }
        if(modularObjects[0].isDead){
            state = kThreeTwo_Death;
        }
    }
    if(state == kThreeTwo_Death){
        [deathAnimation update:delta];
        modularObjects[0].isDead = NO;
        if(deathAnimation.particleCount == 0){
            modularObjects[0].isDead = YES;
        }
    }
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

- (void)hitModule:(int)module withDamage:(int)damage {
    modularObjects[module].moduleHealth -= damage;
    [super hitModule:module withDamage:damage];
    
    shipHealth = modularObjects[0].moduleHealth;
    shipMaxHealth = modularObjects[0].moduleMaxHealth;
}

- (void)render {
    [singleTopBullet render];
    [singleLeftBullet render];
    [singleRightBullet render];
    [doubleTopBullet render];
    [doubleLeftBullet render];
    [doubleRightBullet render];
    
    
    if(state == kThreeTwo_Death){
        [deathAnimation renderParticles];
    }
    
    for(int i = 0; i < numberOfModules; i++) {
        if(i != 0){
            if (!modularObjects[i].isDead) {
                [modularObjects[i].moduleImage setRotation:modularObjects[i].rotation];
                [modularObjects[i].moduleImage renderAtPoint:CGPointMake(currentLocation.x + modularObjects[i].location.x, currentLocation.y + modularObjects[i].location.y) centerOfImage:YES];
            }
        }
        else if(state != kThreeTwo_Death){
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
