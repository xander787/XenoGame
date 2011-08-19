//
//  BossShipOceanus.m
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
//  Last Updated - 8/12/11 - 3:30PM - James
//  - Added polygons to the rotation on the spinnign stage

#import "BossShipOceanus.h"
#import "BossShip.h"


@implementation BossShipOceanus

- (id)initWithLocation:(CGPoint)aPoint andPlayerShipRef:(PlayerShip *)playerRef {
    if((self = [super initWithBossID:kBoss_Oceanus initialLocation:aPoint andPlayerShipRef:playerRef])){
        state = kOceanusState_Stage1;
        
        mainbody = &self.modularObjects[0];
        harpoon = &self.modularObjects[1];
        leftTurret = &self.modularObjects[2];
        rightTurret = &self.modularObjects[3];
        leftBulge = &self.modularObjects[4];
        rightBulge = &self.modularObjects[5];
        
        mainbody->moduleMaxHealth = 100;
        mainbody->moduleHealth = mainbody->moduleMaxHealth;
        
        mainBodyEmitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
                                                                            position:Vector2fMake(currentLocation.x, currentLocation.y)
                                                              sourcePositionVariance:Vector2fZero
                                                                               speed:0.8
                                                                       speedVariance:0.2
                                                                    particleLifeSpan:1.0
                                                            particleLifespanVariance:0.2
                                                                               angle:0
                                                                       angleVariance:360
                                                                             gravity:Vector2fZero
                                                                          startColor:Color4fMake(0.1, 0.1, 0.8, 1.0)
                                                                  startColorVariance:Color4fMake(0.1, 0.1, 0.1, 0.0)
                                                                         finishColor:Color4fMake(0.1, 0.1, 0.3, 1.0)
                                                                 finishColorVariance:Color4fMake(0.1, 0.1, 0.1, 0.0)
                                                                        maxParticles:1500
                                                                        particleSize:20.0
                                                                  finishParticleSize:20.0
                                                                particleSizeVariance:0.0
                                                                            duration:0.8
                                                                       blendAdditive:YES];
        
        leftTurretProj = [[BulletProjectile alloc] initWithProjectileID:kEnemyProjectile_BulletLevelOne_Single 
                                                           location:Vector2fMake(mainbody->weapons[0].weaponCoord.x + mainbody->location.x + currentLocation.x, mainbody->weapons[0].weaponCoord.y + mainbody->location.y + currentLocation.y) 
                                                           andAngle:270];
        
        rightTurretProj = [[BulletProjectile alloc] initWithProjectileID:kEnemyProjectile_BulletLevelOne_Single 
                                                           location:Vector2fMake(mainbody->weapons[1].weaponCoord.x + mainbody->location.x + currentLocation.x, mainbody->weapons[1].weaponCoord.y + mainbody->location.y + currentLocation.y) 
                                                           andAngle:270];
        
        leftWaveProj = [[WaveProjectile alloc] initWithProjectileID:kEnemyProjectile_WaveLevelOne_SingleSmall location:Vector2fMake(leftBulge->weapons[0].weaponCoord.x + leftBulge->location.x + currentLocation.x, leftBulge->weapons[0].weaponCoord.y + leftBulge->location.y + currentLocation.y) andAngle:270];
        
        rightWaveProj = [[WaveProjectile alloc] initWithProjectileID:kEnemyProjectile_WaveLevelOne_SingleSmall location:Vector2fMake(rightBulge->weapons[0].weaponCoord.x + rightBulge->location.x + currentLocation.x, rightBulge->weapons[0].weaponCoord.y + rightBulge->location.y + currentLocation.y) andAngle:270];
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
        if(state == kOceanusState_Stage1 || state == kOceanusState_Spinning){
            currentLocation.x += ((desiredLocation.x - currentLocation.x) / bossSpeed) * (pow(1.584893192, bossSpeed/2)) * delta;
            currentLocation.y += ((desiredLocation.y - currentLocation.y) / bossSpeed) * (pow(1.584893192, bossSpeed/2)) * delta;
        }
        else if(state == kOceanusState_Stage2){
            currentLocation.x += ((desiredLocation.x - currentLocation.x) / bossSpeed) * (pow(1.584893192, bossSpeed/1.5)) * delta;
            currentLocation.y += ((desiredLocation.y - currentLocation.y) / bossSpeed) * (pow(1.584893192, bossSpeed/1.5)) * delta;
        }
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
    
    if(mainbody->isDead == YES){
        harpoon->isDead = YES;
    }
    
    //Main updating
    if(state == kOceanusState_Stage1){
        [self floatPositionWithDelta:delta andTime:1.4];
        
        
        if(mainbody->moduleHealth <= mainbody->moduleMaxHealth / 2){
            state = kOceanusState_Spinning;
            mainbody->rotation = 1800;
        }
    }
    else if(state == kOceanusState_Spinning){
        spinningTimer += delta;
        
        [self floatPositionWithDelta:delta andTime:1.4];
        GLfloat oldRotation = mainbody->rotation;
        mainbody->rotation += 360 * delta;
        harpoon->rotation = mainbody->rotation;
        leftTurret->rotation = mainbody->rotation;
        rightTurret->rotation = mainbody->rotation;
        leftBulge->rotation = mainbody->rotation;
        rightBulge->rotation = mainbody->rotation;
        
        //Rotate the polygons and module locations aroudn the point
        [self rotateModule:0 aroundPositionWithOldrotation:oldRotation];
        [self rotateModule:1 aroundPositionWithOldrotation:oldRotation];
        [self rotateModule:2 aroundPositionWithOldrotation:oldRotation];
        [self rotateModule:3 aroundPositionWithOldrotation:oldRotation];
        [self rotateModule:4 aroundPositionWithOldrotation:oldRotation];
        [self rotateModule:5 aroundPositionWithOldrotation:oldRotation];
        
        
        if(spinningTimer >= 6){
            state = kOceanusState_Stage2;
            
            mainbody->rotation = 0;
            harpoon->rotation = 0;
            leftTurret->rotation = 0;
            rightTurret->rotation = 0;
            leftBulge->rotation = 0;
            rightBulge->rotation = 0;
            
            //Rotate the polygons and module locations aroudn the point
            [self rotateModule:0 aroundPositionWithOldrotation:oldRotation];
            [self rotateModule:1 aroundPositionWithOldrotation:oldRotation];
            [self rotateModule:2 aroundPositionWithOldrotation:oldRotation];
            [self rotateModule:3 aroundPositionWithOldrotation:oldRotation];
            [self rotateModule:4 aroundPositionWithOldrotation:oldRotation];
            [self rotateModule:5 aroundPositionWithOldrotation:oldRotation];
            
            
            [leftTurretProj stopProjectile];
            [rightTurretProj stopProjectile];
            [leftWaveProj stopProjectile];
            [rightWaveProj stopProjectile];
            [leftTurretProj release];
            [rightTurretProj release];
            [leftWaveProj release];
            [rightWaveProj release];
            leftTurretProj = [[BulletProjectile alloc] initWithProjectileID:kEnemyProjectile_BulletLevelThree_Double
                                                                   location:Vector2fMake(mainbody->weapons[0].weaponCoord.x + mainbody->location.x + currentLocation.x, mainbody->weapons[0].weaponCoord.y + mainbody->location.y + currentLocation.y) 
                                                                   andAngle:270];
            
            rightTurretProj = [[BulletProjectile alloc] initWithProjectileID:kEnemyProjectile_BulletLevelThree_Double
                                                                    location:Vector2fMake(mainbody->weapons[1].weaponCoord.x + mainbody->location.x + currentLocation.x, mainbody->weapons[1].weaponCoord.y + mainbody->location.y + currentLocation.y) 
                                                                    andAngle:270];
            
            leftWaveProj = [[WaveProjectile alloc] initWithProjectileID:kEnemyProjectile_WaveLevelTwo_DoubleSmall location:Vector2fMake(leftBulge->weapons[0].weaponCoord.x + leftBulge->location.x + currentLocation.x, leftBulge->weapons[0].weaponCoord.y + leftBulge->location.y + currentLocation.y) andAngle:270];
            
            rightWaveProj = [[WaveProjectile alloc] initWithProjectileID:kEnemyProjectile_WaveLevelTwo_DoubleSmall location:Vector2fMake(rightBulge->weapons[0].weaponCoord.x + rightBulge->location.x + currentLocation.x, rightBulge->weapons[0].weaponCoord.y + rightBulge->location.y + currentLocation.y) andAngle:270];
        }
        else if(mainbody->isDead){
            mainbody->isDead = NO;
            state = kOceanusState_Death;
            
            [leftTurretProj stopProjectile];
            [rightTurretProj stopProjectile];
            [leftWaveProj stopProjectile];
            [rightWaveProj stopProjectile];
        }
    }
    else if(state == kOceanusState_Stage2){
        [self floatPositionWithDelta:delta andTime:0.6];
        
        //Projectile updating
        
        //Harpoon stuff
        if(!harpoonIsAttacking && !harpoonIsReturning){
            harpoonTimer += delta;
        }
        if(harpoonTimer >= 1){
            harpoonTimer = 0;
            NSLog(@"harponn attack");
            harpoonIsAttacking = YES;
        }
        if(harpoonIsAttacking){
            harpoon->location.y -= 50 * delta;
            if(harpoon->location.y < 400){
                harpoonIsReturning = YES;
                harpoon->location.y = 200;
                harpoonIsAttacking = NO;
            }
        }
        if(harpoonIsReturning){
            harpoon->location.y -= 50 * delta;
            if((harpoon->location.y - harpoon->defaultLocation.y) > 10 || (harpoon->location.y - harpoon->defaultLocation.y) < 10){
                harpoon->location = harpoon->defaultLocation;
                harpoonIsReturning = NO;
            }
        }
        
        if(mainbody->isDead){
            mainbody->isDead = NO;
            state = kOceanusState_Death;
            
            [leftTurretProj stopProjectile];
            [rightTurretProj stopProjectile];
            [leftWaveProj stopProjectile];
            [rightWaveProj stopProjectile];
        }
    }
    else if(state == kOceanusState_Death){
        mainBodyEmitter.sourcePosition = Vector2fMake(mainbody->location.x + currentLocation.x, mainbody->location.y + currentLocation.y);
        [mainBodyEmitter update:delta];
        if(mainbody->isDead){
            mainbody->isDead = NO;
        }
        if(mainBodyEmitter.particleCount == 0){
            mainbody->isDead = YES;
            harpoon->isDead = YES;
            leftTurret->isDead = YES;
            rightTurret->isDead = YES;
            leftBulge->isDead = YES;
            rightBulge->isDead = YES;
        }
    }
    
    
    if(self.shipIsDeployed){
        //Update projectiles
        [leftTurretProj setLocation:Vector2fMake(mainbody->weapons[0].weaponCoord.x + mainbody->location.x + currentLocation.x, mainbody->weapons[0].weaponCoord.y + mainbody->location.y + currentLocation.y)];
        [rightTurretProj setLocation:Vector2fMake(mainbody->weapons[1].weaponCoord.x + mainbody->location.x + currentLocation.x, mainbody->weapons[1].weaponCoord.y + mainbody->location.y + currentLocation.y)];
            
        [leftTurretProj update:delta];
        [rightTurretProj update:delta];
            
        [leftWaveProj setLocation:Vector2fMake(leftBulge->weapons[0].weaponCoord.x + leftBulge->location.x + currentLocation.x, leftBulge->weapons[0].weaponCoord.y + leftBulge->location.y + currentLocation.y)];
        [rightWaveProj setLocation:Vector2fMake(rightBulge->weapons[0].weaponCoord.x + rightBulge->location.x + currentLocation.x, rightBulge->weapons[0].weaponCoord.y + rightBulge->location.y + currentLocation.y)];
        [leftWaveProj update:delta];
        [rightWaveProj update:delta];
    }
}

- (void)floatPositionWithDelta:(GLfloat)delta andTime:(GLfloat)aTime {
    holdingTimer += delta;
    
    if(holdingTimer >= aTime){
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
}

- (void)hitModule:(int)module withDamage:(int)damage {
    
    if(state != kOceanusState_Death && state != kOceanusState_Spinning){
        if(state != kOceanusState_Stage2){
            //just send attacks to the main ship's body
            mainbody->moduleHealth -= damage;
            [super hitModule:0 withDamage:damage];
        }
        else{
            //If its the second stage other modules may now be destroyed
            modularObjects[module].moduleHealth -= damage;
            [super hitModule:module withDamage:damage];
        }
    }
}

- (void)render {
    [leftTurretProj render];
    [rightTurretProj render];
    [leftWaveProj render];
    [rightWaveProj render];
    
    for(int i = 0; i < numberOfModules; i++) {
        if(i != 0){
            if (!modularObjects[i].isDead) {
                [modularObjects[i].moduleImage setRotation:modularObjects[i].rotation];
                [modularObjects[i].moduleImage renderAtPoint:CGPointMake(currentLocation.x + modularObjects[i].location.x, currentLocation.y + modularObjects[i].location.y) centerOfImage:YES];
            }
        }
        else if(state != kOceanusState_Death){
            [mainbody->moduleImage setRotation:modularObjects[i].rotation];
            [mainbody->moduleImage renderAtPoint:CGPointMake(currentLocation.x + modularObjects[i].location.x, currentLocation.y + modularObjects[i].location.y) centerOfImage:YES];
        }
        
    }
    
    if(state == kOceanusState_Death){
        [mainBodyEmitter renderParticles];
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
