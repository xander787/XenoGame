//
//  BossShipKronos.m
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

#import "BossShipKronos.h"
#import "BossShip.h"


@implementation BossShipKronos

- (id)initWithLocation:(CGPoint)aPoint andPlayerShipRef:(PlayerShip *)playerRef {
    self = [super initWithBossID:kBoss_Kronos initialLocation:aPoint andPlayerShipRef:playerRef];
    if(self){
        mainBody = &self.modularObjects[0];
        head = &self.modularObjects[1];
        bottomLeftTurret = &self.modularObjects[2];
        middleLeftTurret = &self.modularObjects[3];
        middleLeftWing = &self.modularObjects[4];
        topLeftCannon = &self.modularObjects[5];
        topLeftTurret = &self.modularObjects[6];
        bottomRightTurret = &self.modularObjects[7];
        middleRightTurret = &self.modularObjects[8];
        middleRightWing = &self.modularObjects[9];
        topRightCannon = &self.modularObjects[10];
        topRightTurret = &self.modularObjects[11];
        tail = &self.modularObjects[12];
        
        
        
        //Projectiles
        headProjectileLeft = [[BulletProjectile alloc] initWithProjectileID:kEnemyProjectile_BulletLevelOne_Single location:Vector2fMake(currentLocation.x + head->location.x + head->weapons[0].weaponCoord.x, currentLocation.y + head->location.y + head->weapons[0].weaponCoord.y) andAngle:-90.0f];
        headProjectileRight = [[BulletProjectile alloc] initWithProjectileID:kEnemyProjectile_BulletLevelOne_Single location:Vector2fMake(currentLocation.x + head->location.x + head->weapons[1].weaponCoord.x, currentLocation.y + head->location.y + head->weapons[1].weaponCoord.y) andAngle:-90.0f];
        
        bottomLeftTurretProjectile = [[BulletProjectile alloc] initWithProjectileID:kEnemyProjectile_BulletLevelOne_Single location:Vector2fMake(currentLocation.x + bottomLeftTurret->location.x + bottomLeftTurret->weapons[0].weaponCoord.x, currentLocation.y + bottomLeftTurret->location.y + bottomLeftTurret->weapons[0].weaponCoord.y) andAngle:-120.0f];
        middleLeftTurretProjectile = [[BulletProjectile alloc] initWithProjectileID:kEnemyProjectile_BulletLevelOne_Single location:Vector2fMake(currentLocation.x + middleLeftTurret->location.x + middleLeftTurret->weapons[0].weaponCoord.x, currentLocation.y + middleLeftTurret->location.y + middleLeftTurret->weapons[0].weaponCoord.y) andAngle:215.0f];
        middleLeftWingProjectile = [[WaveProjectile alloc] initWithProjectileID:kEnemyProjectile_WaveLevelSeven_DoubleMedium location:Vector2fMake(currentLocation.x + middleLeftWing->location.x + middleLeftWing->weapons[0].weaponCoord.x, currentLocation.y + middleLeftWing->location.y + middleLeftWing->weapons[0].weaponCoord.y) andAngle:-90.0f];
        topLeftCannonProjectile = [[ParticleProjectile alloc] initWithProjectileID:kEnemyParticle_Single location:Vector2fMake(currentLocation.x + topLeftCannon->location.x + topLeftCannon->weapons[0].weaponCoord.x, currentLocation.y + topLeftCannon->location.y + topLeftCannon->weapons[0].weaponCoord.y) angle:130.0f radius:8 andFireRate:2];
        topLeftTurretProjectile = [[BulletProjectile alloc] initWithProjectileID:kEnemyProjectile_BulletLevelOne_Single location:Vector2fMake(currentLocation.x + topLeftTurret->location.x + topLeftTurret->weapons[0].weaponCoord.x, currentLocation.y + topLeftTurret->location.y + topLeftTurret->weapons[0].weaponCoord.y) andAngle:110.0f];
        
        
        bottomRightTurretProjectile = [[BulletProjectile alloc] initWithProjectileID:kEnemyProjectile_BulletLevelOne_Single location:Vector2fMake(currentLocation.x + bottomRightTurret->location.x + bottomRightTurret->weapons[0].weaponCoord.x, currentLocation.y + bottomRightTurret->location.y + bottomRightTurret->weapons[0].weaponCoord.y) andAngle:-60.0f];
        middleRightTurretProjectile = [[BulletProjectile alloc] initWithProjectileID:kEnemyProjectile_BulletLevelOne_Single location:Vector2fMake(currentLocation.x + middleRightTurret->location.x + middleRightTurret->weapons[0].weaponCoord.x, currentLocation.y + middleRightTurret->location.y + middleRightTurret->weapons[0].weaponCoord.y) andAngle:325.0f];
        middleRightWingProjectile = [[WaveProjectile alloc] initWithProjectileID:kEnemyProjectile_WaveLevelSeven_DoubleMedium location:Vector2fMake(currentLocation.x + middleRightWing->location.x + middleRightWing->weapons[0].weaponCoord.x, currentLocation.y + middleRightWing->location.y + middleRightWing->weapons[0].weaponCoord.y) andAngle:-90.0f];
        topRightCannonProjectile = [[ParticleProjectile alloc] initWithProjectileID:kEnemyParticle_Single location:Vector2fMake(currentLocation.x + topRightCannon->location.x + topRightCannon->weapons[0].weaponCoord.x, currentLocation.y + topRightCannon->location.y + topRightCannon->weapons[0].weaponCoord.y) angle:50.0f radius:8 andFireRate:2];
        topRightTurretProjectile = [[BulletProjectile alloc] initWithProjectileID:kEnemyProjectile_BulletLevelOne_Single location:Vector2fMake(currentLocation.x + topRightTurret->location.x + topRightTurret->weapons[0].weaponCoord.x, currentLocation.y + topRightTurret->location.y + topRightTurret->weapons[0].weaponCoord.y) andAngle:65.0f];
        
        tailProjectile = [[BulletProjectile alloc] initWithProjectileID:kEnemyProjectile_BulletLevelOne_Single location:Vector2fMake(currentLocation.x + tail->location.x + tail->weapons[0].weaponCoord.x, currentLocation.y + tail->location.y + tail->weapons[0].weaponCoord.y) andAngle:90.0f];
        
        
        
        //Death emitters
        headDeathEmitter = [self newDeathAnimationEmitter];
        bottomLeftTurretDeathEmitter = [self newDeathAnimationEmitter];
        middleLeftTurretDeathEmitter = [self newDeathAnimationEmitter];
        middleLeftWingDeathEmitter = [self newDeathAnimationEmitter];
        topLeftCannonDeathEmitter = [self newDeathAnimationEmitter];
        topLeftTurretDeathEmitter = [self newDeathAnimationEmitter];
        bottomRightTurretDeathEmitter = [self newDeathAnimationEmitter];
        middleRightTurretDeathEmitter = [self newDeathAnimationEmitter];
        middleRightWingDeathEmitter = [self newDeathAnimationEmitter];
        topRightCannonDeathEmitter = [self newDeathAnimationEmitter];
        topRightTurretDeathEmitter = [self newDeathAnimationEmitter];
        tailDeathEmitter = [self newDeathAnimationEmitter];
    }
    return self;
}

- (void)update:(GLfloat)delta {
    [super update:delta];
    
    if(!shipIsDeployed){
        currentLocation.x += ((desiredLocation.x - currentLocation.x) / bossSpeed) * (pow(1.584893192, bossSpeed)) * delta;
        currentLocation.y += ((desiredLocation.y - currentLocation.y) / bossSpeed) * (pow(1.584893192, bossSpeed)) * delta;
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
    
    if(shipIsDeployed){
        
        
        //Projectile updating
        
        [headProjectileLeft setLocation:Vector2fMake(currentLocation.x + head->location.x + head->weapons[0].weaponCoord.x, currentLocation.y + head->location.y + head->weapons[0].weaponCoord.y)];
        [headProjectileLeft setAngle:270 -mainBody->rotation];
        [headProjectileLeft update:delta];
        
        [headProjectileRight setLocation:Vector2fMake(currentLocation.x + head->location.x + head->weapons[1].weaponCoord.x, currentLocation.y + head->location.y + head->weapons[1].weaponCoord.y)];
        [headProjectileRight setAngle:270 - mainBody->rotation];
        [headProjectileRight update:delta];
        
    
        [bottomLeftTurretProjectile setLocation:Vector2fMake(currentLocation.x + bottomLeftTurret->location.x + bottomLeftTurret->weapons[0].weaponCoord.x, currentLocation.y + bottomLeftTurret->location.y + bottomLeftTurret->weapons[0].weaponCoord.y)];
        [bottomLeftTurretProjectile setAngle:240 - mainBody->rotation];
        [bottomLeftTurretProjectile update:delta];
        
        [middleLeftTurretProjectile setLocation:Vector2fMake(currentLocation.x + middleLeftTurret->location.x + middleLeftTurret->weapons[0].weaponCoord.x, currentLocation.y + middleLeftTurret->location.y + middleLeftTurret->weapons[0].weaponCoord.y)];
        [middleLeftTurretProjectile setAngle:215 - mainBody->rotation];
        [middleLeftTurretProjectile update:delta];
        
        [middleLeftWingProjectile setLocation:Vector2fMake(currentLocation.x + middleLeftWing->location.x + middleLeftWing->weapons[0].weaponCoord.x, currentLocation.y + middleLeftWing->location.y + middleLeftWing->weapons[0].weaponCoord.y)];
        [middleLeftWingProjectile setAngle:270 - mainBody->rotation];
        [middleLeftWingProjectile update:delta];
        
        [topLeftCannonProjectile setLocation:Vector2fMake(currentLocation.x + topLeftCannon->location.x + topLeftCannon->weapons[0].weaponCoord.x, currentLocation.y + topLeftCannon->location.y + topLeftCannon->weapons[0].weaponCoord.y)];
        [topLeftCannonProjectile setAngle:130 - mainBody->rotation];
        [topLeftCannonProjectile update:delta];
        
        [topLeftTurretProjectile setLocation:Vector2fMake(currentLocation.x + topLeftTurret->location.x + topLeftTurret->weapons[0].weaponCoord.x, currentLocation.y + topLeftTurret->location.y + topLeftTurret->weapons[0].weaponCoord.y)];
        [topLeftTurretProjectile setAngle:110 - mainBody->rotation];
        [topLeftTurretProjectile update:delta];
        
    
        [bottomRightTurretProjectile setLocation:Vector2fMake(currentLocation.x + bottomRightTurret->location.x + bottomRightTurret->weapons[0].weaponCoord.x, currentLocation.y + bottomRightTurret->location.y + bottomRightTurret->weapons[0].weaponCoord.y)];
        [bottomRightTurretProjectile setAngle:300 - mainBody->rotation];
        [bottomRightTurretProjectile update:delta];
        
        [middleRightTurretProjectile setLocation:Vector2fMake(currentLocation.x + middleRightTurret->location.x + middleRightTurret->weapons[0].weaponCoord.x, currentLocation.y + middleRightTurret->location.y + middleRightTurret->weapons[0].weaponCoord.y)];
        [middleRightTurretProjectile setAngle:325 - mainBody->rotation];
        [middleRightTurretProjectile update:delta];
        
        [middleRightWingProjectile setLocation:Vector2fMake(currentLocation.x + middleRightWing->location.x + middleRightWing->weapons[0].weaponCoord.x, currentLocation.y + middleRightWing->location.y + middleRightWing->weapons[0].weaponCoord.y)];
        [middleRightWingProjectile setAngle:270 - mainBody->rotation];
        [middleRightWingProjectile update:delta];
        
        [topRightCannonProjectile setLocation:Vector2fMake(currentLocation.x + topRightCannon->location.x + topRightCannon->weapons[0].weaponCoord.x, currentLocation.y + topRightCannon->location.y + topRightCannon->weapons[0].weaponCoord.y)];
        [topRightCannonProjectile setAngle:50 - mainBody->rotation];
        [topRightCannonProjectile update:delta];
        
        [topRightTurretProjectile setLocation:Vector2fMake(currentLocation.x + topRightTurret->location.x + topRightTurret->weapons[0].weaponCoord.x, currentLocation.y + topRightTurret->location.y + topRightTurret->weapons[0].weaponCoord.y)];
        [topRightTurretProjectile setAngle:65 - mainBody->rotation];
        [topRightTurretProjectile update:delta];
        
        
        [tailProjectile setLocation:Vector2fMake(currentLocation.x + tail->location.x + tail->weapons[0].weaponCoord.x, currentLocation.y + tail->location.y + tail->weapons[0].weaponCoord.y)];
        [tailProjectile setAngle:90 - mainBody->rotation];
        [tailProjectile update:delta];
        
        
        if(state == kKronosState_StageOne){
            
            GLfloat oldRotation = mainBody->rotation;
            if(head->isDead && bottomLeftTurret->isDead && middleLeftTurret->isDead && middleLeftWing->isDead && topLeftCannon->isDead && topLeftTurret->isDead && bottomRightTurret->isDead && middleRightTurret->isDead && middleRightWing->isDead && topRightCannon->isDead && topRightTurret->isDead && tail->isDead){
                
                if(mainBody->rotation < 5 && mainBody->rotation > -5){
                    state = kKronosState_StageTwo;
                }
                else {
                    //Rotate faster by 120° per second
                    mainBody->rotation += 120 * delta;
                }
            }
            mainBody->rotation += 90 * delta;
            if(mainBody->rotation > 360) mainBody->rotation -= 360;
            
            head->rotation = mainBody->rotation;
            bottomLeftTurret->rotation = mainBody->rotation;
            middleLeftTurret->rotation = mainBody->rotation;
            middleLeftWing->rotation = mainBody->rotation;
            topLeftCannon->rotation = mainBody->rotation;
            topLeftTurret->rotation = mainBody->rotation;
            bottomRightTurret->rotation = mainBody->rotation;
            middleRightTurret->rotation = mainBody->rotation;
            middleRightWing->rotation = mainBody->rotation;
            topRightCannon->rotation = mainBody->rotation;
            topRightTurret->rotation = mainBody->rotation;
            tail->rotation = mainBody->rotation;
            
            for(int i = 0; i < numberOfModules; i++){
                [self rotateModule:i aroundPositionWithOldrotation:oldRotation];
            }
        }
        else if(state == kKronosState_StageTwo){
            stageTwoTimer += delta;
            
            if(stageTwoTimer > 0.8){
                currentLocation.y += 60 * delta;
                if(currentLocation.y >= 550){
                    mainBody->isDead = YES;
                    NSLog(@"Done");
                }
            }
        }
        
        
        if(head->isDead){
            [headProjectileLeft stopProjectile];
            [headProjectileRight stopProjectile];
            [headDeathEmitter setSourcePosition:Vector2fMake(currentLocation.x + head->location.x, currentLocation.y + head->location.y)];
            [headDeathEmitter update:delta];
        }
        if(bottomLeftTurret->isDead){
            [bottomLeftTurretProjectile stopProjectile];
            [bottomLeftTurretDeathEmitter setSourcePosition:Vector2fMake(currentLocation.x + bottomLeftTurret->location.x, currentLocation.y + bottomLeftTurret->location.y)];
            [bottomLeftTurretDeathEmitter update:delta];
        }
        if(middleLeftTurret->isDead){
            [middleLeftTurretProjectile stopProjectile];
            [middleLeftTurretDeathEmitter setSourcePosition:Vector2fMake(currentLocation.x + middleLeftTurret->location.x, currentLocation.y + middleLeftTurret->location.y)];
            [middleLeftTurretDeathEmitter update:delta];
        }
        if(middleLeftWing->isDead){
            [middleLeftWingProjectile stopProjectile];
            [middleLeftWingDeathEmitter setSourcePosition:Vector2fMake(currentLocation.x + middleLeftWing->location.x, currentLocation.y + middleLeftWing->location.y)];
            [middleLeftWingDeathEmitter update:delta];
        }
        if(topLeftCannon->isDead){
            [topLeftCannonProjectile stopProjectile];
            [topLeftCannonDeathEmitter setSourcePosition:Vector2fMake(currentLocation.x + topLeftCannon->location.x, currentLocation.y + topLeftCannon->location.y)];
            [topLeftCannonDeathEmitter update:delta];
        }
        if(topLeftTurret->isDead){
            [topLeftTurretProjectile stopProjectile];
            [topLeftTurretDeathEmitter setSourcePosition:Vector2fMake(currentLocation.x + topLeftTurret->location.x, currentLocation.y + topLeftTurret->location.y)];
            [topLeftTurretDeathEmitter update:delta];
        }
        if(bottomRightTurret->isDead){
            [bottomRightTurretProjectile stopProjectile];
            [bottomRightTurretDeathEmitter setSourcePosition:Vector2fMake(currentLocation.x + bottomRightTurret->location.x, currentLocation.y + bottomRightTurret->location.y)];
            [bottomRightTurretDeathEmitter update:delta];
        }
        if(middleRightTurret->isDead){
            [middleRightTurretProjectile stopProjectile];
            [middleRightTurretDeathEmitter setSourcePosition:Vector2fMake(currentLocation.x + middleRightTurret->location.x, currentLocation.y + middleRightTurret->location.y)];
            [middleRightTurretDeathEmitter update:delta];
        }
        if(middleRightWing->isDead){
            [middleRightWingProjectile stopProjectile];
            [middleRightWingDeathEmitter setSourcePosition:Vector2fMake(currentLocation.x + middleRightWing->location.x, currentLocation.y + middleRightWing->location.y)];
            [middleRightWingDeathEmitter update:delta];
        }
        if(topRightCannon->isDead){
            [topRightCannonProjectile stopProjectile];
            [topRightCannonDeathEmitter setSourcePosition:Vector2fMake(currentLocation.x + topRightCannon->location.x, currentLocation.y + topRightCannon->location.y)];
            [topRightCannonDeathEmitter update:delta];
        }
        if(topRightTurret->isDead){
            [topRightTurretProjectile stopProjectile];
            [topRightTurretDeathEmitter setSourcePosition:Vector2fMake(currentLocation.x + topRightTurret->location.x, currentLocation.y + topRightTurret->location.y)];
            [topRightTurretDeathEmitter update:delta];
        }
        if(tail->isDead){
            [tailProjectile stopProjectile];
            [tailDeathEmitter setSourcePosition:Vector2fMake(currentLocation.x + tail->location.x, currentLocation.y + tail->location.y)];
            [tailDeathEmitter update:delta];
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

- (ParticleEmitter *)newDeathAnimationEmitter {
    ParticleEmitter *baseEmitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
                                                                                     position:Vector2fZero
                                                                       sourcePositionVariance:Vector2fZero
                                                                                        speed:0.7
                                                                                speedVariance:0.2
                                                                             particleLifeSpan:0.2
                                                                     particleLifespanVariance:0.1
                                                                                        angle:0.0
                                                                                angleVariance:360.0
                                                                                      gravity:Vector2fZero
                                                                                   startColor:Color4fMake(1.0, 0.3, 0.3, 1.0)
                                                                           startColorVariance:Color4fMake(0.3, 0.3, 0.3, 0.0)
                                                                                  finishColor:Color4fMake(0.7, 0.3, 0.3, 1.0)
                                                                          finishColorVariance:Color4fMake(0.3, 0.3, 0.3, 0.0)
                                                                                 maxParticles:1000
                                                                                 particleSize:7.0
                                                                           finishParticleSize:7.0
                                                                         particleSizeVariance:0.0
                                                                                     duration:0.1
                                                                                blendAdditive:YES];
    return  baseEmitter;
}

- (void)hitModule:(int)module withDamage:(int)damage {
    if(module != 0){
        modularObjects[module].moduleHealth -= damage;
        [super hitModule:module withDamage:damage];
    }
}

- (void)render {
    [headProjectileLeft render];
    [headProjectileRight render];
    [bottomLeftTurretProjectile render];
    [middleLeftTurretProjectile render];
    [middleLeftWingProjectile render];
    [topLeftCannonProjectile render];
    [topLeftTurretProjectile render];
    [bottomRightTurretProjectile render];
    [middleRightTurretProjectile render];
    [middleRightWingProjectile render];
    [topRightCannonProjectile render];
    [topRightTurretProjectile render];
    [tailProjectile render];
    
    for(int i = 0; i < numberOfModules; i++) {
        if (!modularObjects[i].isDead) {
            [modularObjects[i].moduleImage setRotation:modularObjects[i].rotation];
            [modularObjects[i].moduleImage renderAtPoint:CGPointMake(currentLocation.x + modularObjects[i].location.x, currentLocation.y + modularObjects[i].location.y) centerOfImage:YES];
        }
    }
    
    [headDeathEmitter renderParticles];
    [bottomLeftTurretDeathEmitter renderParticles];
    [middleLeftTurretDeathEmitter renderParticles];
    [middleLeftWingDeathEmitter renderParticles];
    [topLeftCannonDeathEmitter renderParticles];
    [topLeftTurretDeathEmitter renderParticles];
    [bottomRightTurretDeathEmitter renderParticles];
    [middleRightTurretDeathEmitter renderParticles];
    [middleRightWingDeathEmitter renderParticles];
    [topRightCannonDeathEmitter renderParticles];
    [topRightTurretDeathEmitter renderParticles];
    [tailDeathEmitter renderParticles];
    
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
