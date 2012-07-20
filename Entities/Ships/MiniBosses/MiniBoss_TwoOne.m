//
//  MiniBoss_TwoOne.m
//  Xenophobe
//
//  Created by James Linnell on 6/18/12.
//  Copyright 2012 PDHS. All rights reserved.
//

#import "MiniBoss_TwoOne.h"

@implementation MiniBoss_TwoOne

- (id)initWithLocation:(CGPoint)aPoint andPlayerShipRef:(PlayerShip *)playerRef {
    self = [super initWithBossID:kMiniBoss_TwoOne initialLocation:aPoint andPlayerShipRef:playerRef];
    if (self) {
        // Initialization code here.
        
        //Always start the state correctly
        state = kTwoOne_Entry;
        
        mainBodyOne = &self.modularObjects[0];
        mainBodyTwo = &self.modularObjects[1];
        mainBodyOneCurrentAngle = 0;
        mainBodyTwoCurrentAngle = 180;
        
        //Init the Death Animation and all the weapons, along with putting the weapons in the array
        deathAnimationOne = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
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
        deathAnimationTwo = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
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
        
        
        //bulletCenter = [[BulletProjectile alloc] initWithProjectileID:kEnemyProjectile_BulletLevelOne_Single location:Vector2fZero andAngle:-90.0f];
        bodyOneBulletOne = [[BulletProjectile alloc] initWithProjectileID:kEnemyProjectile_BulletLevelOne_Single location:Vector2fZero andAngle:-100.0f];
        bodyOneBulletTwo = [[BulletProjectile alloc] initWithProjectileID:kEnemyProjectile_BulletLevelOne_Single location:Vector2fZero andAngle:-80.0f];
        bodyOneBulletThree = [[BulletProjectile alloc] initWithProjectileID:kEnemyProjectile_BulletLevelOne_Single location:Vector2fZero andAngle:-45.0f];
        bodyOneBulletFour = [[BulletProjectile alloc] initWithProjectileID:kEnemyProjectile_BulletLevelOne_Single location:Vector2fZero andAngle:45.0f];
        bodyOneBulletFive = [[BulletProjectile alloc] initWithProjectileID:kEnemyProjectile_BulletLevelOne_Single location:Vector2fZero andAngle:80.0f];
        bodyOneBulletSix = [[BulletProjectile alloc] initWithProjectileID:kEnemyProjectile_BulletLevelOne_Single location:Vector2fZero andAngle:100.0f];
        bodyOneBulletSeven = [[BulletProjectile alloc] initWithProjectileID:kEnemyProjectile_BulletLevelOne_Single location:Vector2fZero andAngle:135.0f];
        bodyOneBulletEight = [[BulletProjectile alloc] initWithProjectileID:kEnemyProjectile_BulletLevelOne_Single location:Vector2fZero andAngle:225.0f];
        
        bodyTwoBulletOne = [[BulletProjectile alloc] initWithProjectileID:kEnemyProjectile_BulletLevelOne_Single location:Vector2fZero andAngle:-100.0f];
        bodyTwoBulletTwo = [[BulletProjectile alloc] initWithProjectileID:kEnemyProjectile_BulletLevelOne_Single location:Vector2fZero andAngle:-80.0f];
        bodyTwoBulletThree = [[BulletProjectile alloc] initWithProjectileID:kEnemyProjectile_BulletLevelOne_Single location:Vector2fZero andAngle:-45.0f];
        bodyTwoBulletFour = [[BulletProjectile alloc] initWithProjectileID:kEnemyProjectile_BulletLevelOne_Single location:Vector2fZero andAngle:45.0f];
        bodyTwoBulletFive = [[BulletProjectile alloc] initWithProjectileID:kEnemyProjectile_BulletLevelOne_Single location:Vector2fZero andAngle:80.0f];
        bodyTwoBulletSix = [[BulletProjectile alloc] initWithProjectileID:kEnemyProjectile_BulletLevelOne_Single location:Vector2fZero andAngle:100.0f];
        bodyTwoBulletSeven = [[BulletProjectile alloc] initWithProjectileID:kEnemyProjectile_BulletLevelOne_Single location:Vector2fZero andAngle:135.0f];
        bodyTwoBulletEight = [[BulletProjectile alloc] initWithProjectileID:kEnemyProjectile_BulletLevelOne_Single location:Vector2fZero andAngle:225.0f];
        
        projectilesArray = [[NSMutableArray alloc] initWithObjects:bodyOneBulletOne, nil];
    }
    return self;
}

- (void)update:(GLfloat)delta {
    
    //Start
    //This is very typical for most of the ships, updates all of the weapons,
    //the death animation for when the ship dies, and the correct movement positions
    //along with the collision hitboxes
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
    
    
    
    if(shipIsDeployed){
        //[bulletCenter setLocation:Vector2fMake(currentLocation.x + modularObjects[0].weapons[0].weaponCoord.x, currentLocation.y + modularObjects[0].weapons[0].weaponCoord.y)];
        [bodyOneBulletOne setLocation:Vector2fMake(currentLocation.x + mainBodyOne->location.x + mainBodyOne->weapons[0].weaponCoord.x, currentLocation.y + mainBodyOne->location.y + mainBodyOne->weapons[0].weaponCoord.y)];
        [bodyOneBulletTwo setLocation:Vector2fMake(currentLocation.x + mainBodyOne->location.x + mainBodyOne->weapons[1].weaponCoord.x, currentLocation.y + mainBodyOne->location.y + mainBodyOne->weapons[1].weaponCoord.y)];
        [bodyOneBulletThree setLocation:Vector2fMake(currentLocation.x + mainBodyOne->location.x + mainBodyOne->weapons[2].weaponCoord.x, currentLocation.y + mainBodyOne->location.y + mainBodyOne->weapons[2].weaponCoord.y)];
        [bodyOneBulletFour setLocation:Vector2fMake(currentLocation.x + mainBodyOne->location.x + mainBodyOne->weapons[3].weaponCoord.x, currentLocation.y + mainBodyOne->location.y + mainBodyOne->weapons[3].weaponCoord.y)];
        [bodyOneBulletFive setLocation:Vector2fMake(currentLocation.x + mainBodyOne->location.x + mainBodyOne->weapons[4].weaponCoord.x, currentLocation.y + mainBodyOne->location.y + mainBodyOne->weapons[4].weaponCoord.y)];
        [bodyOneBulletSix setLocation:Vector2fMake(currentLocation.x + mainBodyOne->location.x + mainBodyOne->weapons[5].weaponCoord.x, currentLocation.y + mainBodyOne->location.y + mainBodyOne->weapons[5].weaponCoord.y)];
        [bodyOneBulletSeven setLocation:Vector2fMake(currentLocation.x + mainBodyOne->location.x + mainBodyOne->weapons[6].weaponCoord.x, currentLocation.y + mainBodyOne->location.y + mainBodyOne->weapons[6].weaponCoord.y)];
        [bodyOneBulletEight setLocation:Vector2fMake(currentLocation.x + mainBodyOne->location.x + mainBodyOne->weapons[7].weaponCoord.x, currentLocation.y + mainBodyOne->location.y + mainBodyOne->weapons[7].weaponCoord.y)];
        
        [bodyTwoBulletOne setLocation:Vector2fMake(currentLocation.x + mainBodyTwo->location.x + mainBodyTwo->weapons[0].weaponCoord.x, currentLocation.y + mainBodyTwo->location.y + mainBodyTwo->weapons[0].weaponCoord.y)];
        [bodyTwoBulletTwo setLocation:Vector2fMake(currentLocation.x + mainBodyTwo->location.x + mainBodyTwo->weapons[1].weaponCoord.x, currentLocation.y + mainBodyTwo->location.y + mainBodyTwo->weapons[1].weaponCoord.y)];
        [bodyTwoBulletThree setLocation:Vector2fMake(currentLocation.x + mainBodyTwo->location.x + mainBodyTwo->weapons[2].weaponCoord.x, currentLocation.y + mainBodyTwo->location.y + mainBodyTwo->weapons[2].weaponCoord.y)];
        [bodyTwoBulletFour setLocation:Vector2fMake(currentLocation.x + mainBodyTwo->location.x + mainBodyTwo->weapons[3].weaponCoord.x, currentLocation.y + mainBodyTwo->location.y + mainBodyTwo->weapons[3].weaponCoord.y)];
        [bodyTwoBulletFive setLocation:Vector2fMake(currentLocation.x + mainBodyTwo->location.x + mainBodyTwo->weapons[4].weaponCoord.x, currentLocation.y + mainBodyTwo->location.y + mainBodyTwo->weapons[4].weaponCoord.y)];
        [bodyTwoBulletSix setLocation:Vector2fMake(currentLocation.x + mainBodyTwo->location.x + mainBodyTwo->weapons[5].weaponCoord.x, currentLocation.y + mainBodyTwo->location.y + mainBodyTwo->weapons[5].weaponCoord.y)];
        [bodyTwoBulletSeven setLocation:Vector2fMake(currentLocation.x + mainBodyTwo->location.x + mainBodyTwo->weapons[6].weaponCoord.x, currentLocation.y + mainBodyTwo->location.y + mainBodyTwo->weapons[6].weaponCoord.y)];
        [bodyTwoBulletEight setLocation:Vector2fMake(currentLocation.x + mainBodyTwo->location.x + mainBodyTwo->weapons[7].weaponCoord.x, currentLocation.y + mainBodyTwo->location.y + mainBodyTwo->weapons[7].weaponCoord.y)];
        
        
        //[bulletCenter update:delta];
        [bodyOneBulletOne update:delta];
        [bodyOneBulletTwo update:delta];
        [bodyOneBulletThree update:delta];
        [bodyOneBulletFour update:delta];
        [bodyOneBulletFive update:delta];
        [bodyOneBulletSix update:delta];
        [bodyOneBulletSeven update:delta];
        [bodyOneBulletEight update:delta];
        
        [bodyTwoBulletOne update:delta];
        [bodyTwoBulletTwo update:delta];
        [bodyTwoBulletThree update:delta];
        [bodyTwoBulletFour update:delta];
        [bodyTwoBulletFive update:delta];
        [bodyTwoBulletSix update:delta];
        [bodyTwoBulletSeven update:delta];
        [bodyTwoBulletEight update:delta];
    }
    //End
    
    //This starts with handling all of the different states, just if-statements
    if(state == kTwoOne_Entry){
        //Typical among most MiniBosses
        if(shipIsDeployed){
            state = kTwoOne_Holding;
        }
    }
    else if(state == kTwoOne_Holding){
        //Deals with the floating when the ship is holding, and handles the times for the attacks.
        //This can be more flexible for different ships with different modules and floating variations
        holdingTimer += delta;
        attackTimer += delta;
        
        //Move the two modules about a circle
        GLfloat oldAngle1 = mainBodyOneCurrentAngle;
        GLfloat oldAngle2 = mainBodyTwoCurrentAngle;
        mainBodyOneCurrentAngle += 45 * delta;
        mainBodyTwoCurrentAngle += 45 * delta;
        Vector2f tempPoint1 = mainBodyOne->location;
        Vector2f tempPoint2 = mainBodyTwo->location;
        double tempAngle1 = DEGREES_TO_RADIANS(mainBodyOneCurrentAngle - oldAngle1);
        double tempAngle2 = DEGREES_TO_RADIANS(mainBodyTwoCurrentAngle - oldAngle2);
        mainBodyOne->location = Vector2fMake((tempPoint1.x * cos(tempAngle1)) - (tempPoint1.y * sin(tempAngle1)), (tempPoint1.x * sin(tempAngle1)) + (tempPoint1.y * cos(tempAngle1)));
        mainBodyTwo->location = Vector2fMake((tempPoint2.x * cos(tempAngle2)) - (tempPoint2.y * sin(tempAngle2)), (tempPoint2.x * sin(tempAngle2)) + (tempPoint2.y * cos(tempAngle2)));

        //Rotate the modules themselves
        GLfloat oldRotation1 = mainBodyOne->rotation;
        GLfloat oldRotation2 = mainBodyTwo->rotation;
        mainBodyOne->rotation += 30 * delta;
        mainBodyTwo->rotation += 30 * delta;
        double tempRot1 = -DEGREES_TO_RADIANS(mainBodyOne->rotation - oldRotation1);
        double tempRot2 = -DEGREES_TO_RADIANS(mainBodyTwo->rotation - oldRotation2);
        for(int k = 0; k < [mainBodyOne->collisionPolygonArray count]; k++){
            for(int i = 0; i < [[mainBodyOne->collisionPolygonArray objectAtIndex:k] pointCount]; i++){
                Vector2f tempPoint = [[mainBodyOne->collisionPolygonArray objectAtIndex:k] originalPoints][i];
                [[mainBodyOne->collisionPolygonArray objectAtIndex:k] originalPoints][i] = Vector2fMake((tempPoint.x * cos(tempRot1)) - (tempPoint.y * sin(tempRot1)), (tempPoint.x * sin(tempRot1)) + (tempPoint.y * cos(tempRot1)));
            }
            [[mainBodyOne->collisionPolygonArray objectAtIndex:k] buildEdges];
        }
        for(int k = 0; k < [mainBodyTwo->collisionPolygonArray count]; k++){
            for(int i = 0; i < [[mainBodyTwo->collisionPolygonArray objectAtIndex:k] pointCount]; i++){
                Vector2f tempPoint = [[mainBodyTwo->collisionPolygonArray objectAtIndex:k] originalPoints][i];
                [[mainBodyTwo->collisionPolygonArray objectAtIndex:k] originalPoints][i] = Vector2fMake((tempPoint.x * cos(tempRot2)) - (tempPoint.y * sin(tempRot2)), (tempPoint.x * sin(tempRot2)) + (tempPoint.y * cos(tempRot2)));
            }
            [[mainBodyTwo->collisionPolygonArray objectAtIndex:k] buildEdges];
        }
        
        //Rotate weapons around modules
        for(int k = 0; k < mainBodyOne->numberOfWeapons; k++){
            Vector2f tempPoint = mainBodyOne->weapons[k].weaponCoord;
            mainBodyOne->weapons[k].weaponCoord = Vector2fMake((tempPoint.x * cos(tempRot1)) - (tempPoint.y * sin(tempRot1)), (tempPoint.x * sin(tempRot1)) + (tempPoint.y * cos(tempRot1)));
        }
        for(int k = 0; k < mainBodyTwo->numberOfWeapons; k++){
            Vector2f tempPoint = mainBodyTwo->weapons[k].weaponCoord;
            mainBodyTwo->weapons[k].weaponCoord = Vector2fMake((tempPoint.x * cos(tempRot2)) - (tempPoint.y * sin(tempRot2)), (tempPoint.x * sin(tempRot2)) + (tempPoint.y * cos(tempRot2)));
        }
        bodyOneBulletOne.angle -= mainBodyOne->rotation - oldRotation1;
        bodyOneBulletTwo.angle -= mainBodyOne->rotation - oldRotation1;
        bodyOneBulletThree.angle -= mainBodyOne->rotation - oldRotation1;
        bodyOneBulletFour.angle -= mainBodyOne->rotation - oldRotation1;
        bodyOneBulletFive.angle -= mainBodyOne->rotation - oldRotation1;
        bodyOneBulletSix.angle -= mainBodyOne->rotation - oldRotation1;
        bodyOneBulletSeven.angle -= mainBodyOne->rotation - oldRotation1;
        bodyOneBulletEight.angle -= mainBodyOne->rotation - oldRotation1;
        
        bodyTwoBulletOne.angle -= mainBodyOne->rotation - oldRotation1;
        bodyTwoBulletTwo.angle -= mainBodyOne->rotation - oldRotation1;
        bodyTwoBulletThree.angle -= mainBodyOne->rotation - oldRotation1;
        bodyTwoBulletFour.angle -= mainBodyOne->rotation - oldRotation1;
        bodyTwoBulletFive.angle -= mainBodyOne->rotation - oldRotation1;
        bodyTwoBulletSix.angle -= mainBodyOne->rotation - oldRotation1;
        bodyTwoBulletSeven.angle -= mainBodyOne->rotation - oldRotation1;
        bodyTwoBulletEight.angle -= mainBodyOne->rotation - oldRotation1;
        
        if(attackTimer >= 6){
            state = kTwoOne_Attacking;
            attackTimer = 0;
            holdingTimer = 0;
        }
        if(modularObjects[0].isDead && modularObjects[1].isDead){
            state = kTwoOne_Death;
        }
    }
    else if(state == kTwoOne_Attacking){
        //Thisi s more typical too, might be changed if the ship goes too far on the bottom, for example
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
            state = kTwoOne_Holding;
            attackPathtimer = 0;
            [attackingPath release];
            attackingPath = nil;
        }if(modularObjects[0].isDead){
            state = kTwoOne_Death;
        }
    }
    if(state == kTwoOne_Death){
        //Again, typical death code, animations, stopping weapons, etc
        //[bulletCenter stopProjectile];
        
    }
    
    if(mainBodyOne->isDead && !deathOneIsAnimating){
        [bodyOneBulletOne stopProjectile];
        [bodyOneBulletTwo stopProjectile];
        [bodyOneBulletThree stopProjectile];
        [bodyOneBulletFour stopProjectile];
        [bodyOneBulletFive stopProjectile];
        [bodyOneBulletSix stopProjectile];
        [bodyOneBulletSeven stopProjectile];
        [bodyOneBulletEight stopProjectile];
        
        mainBodyOne->isDead = NO;
        deathOneIsAnimating = YES;
    }
    if(mainBodyTwo->isDead && !deathTwoIsAnimating){
        [bodyTwoBulletOne stopProjectile];
        [bodyTwoBulletTwo stopProjectile];
        [bodyTwoBulletThree stopProjectile];
        [bodyTwoBulletFour stopProjectile];
        [bodyTwoBulletFive stopProjectile];
        [bodyTwoBulletSix stopProjectile];
        [bodyTwoBulletSeven stopProjectile];
        [bodyTwoBulletEight stopProjectile];
        
        mainBodyTwo->isDead = NO;
        deathTwoIsAnimating = YES;
    }
    if(deathOneIsAnimating){        
        [deathAnimationOne setSourcePosition:Vector2fMake(currentLocation.x + mainBodyOne->location.x, currentLocation.y + mainBodyOne->location.y)];
        [deathAnimationOne update:delta];
        if(deathAnimationOne.particleCount == 0){
            deathOneIsAnimating = NO;
            mainBodyOne->isDead = YES;
        }
    }
    if(deathTwoIsAnimating){
        [deathAnimationTwo setSourcePosition:Vector2fMake(currentLocation.x + mainBodyTwo->location.x, currentLocation.y + mainBodyTwo->location.y)];
        [deathAnimationTwo update:delta];
        if(deathAnimationTwo.particleCount == 0){
            deathTwoIsAnimating = NO;
            mainBodyTwo->isDead = YES;
        }
    }
}

//Important to help with collision detection and dealing damage in the GameLevelScene
- (void)hitModule:(int)module withDamage:(int)damage {
    modularObjects[module].moduleHealth -= damage;
    [super hitModule:module withDamage:damage];
    
    shipHealth = modularObjects[0].moduleHealth + modularObjects[1].moduleHealth;
    shipMaxHealth = modularObjects[0].moduleMaxHealth + modularObjects[1].moduleMaxHealth;
    NSLog(@"%d / %d", shipHealth, shipMaxHealth);
}

- (void)render {
    //[bulletCenter render];
    [bodyOneBulletOne render];
    [bodyOneBulletTwo render];
    [bodyOneBulletThree render];
    [bodyOneBulletFour render];
    [bodyOneBulletFive render];
    [bodyOneBulletSix render];
    [bodyOneBulletSeven render];
    [bodyOneBulletEight render];
    
    [bodyTwoBulletOne render];
    [bodyTwoBulletTwo render];
    [bodyTwoBulletThree render];
    [bodyTwoBulletFour render];
    [bodyTwoBulletFive render];
    [bodyTwoBulletSix render];
    [bodyTwoBulletSeven render];
    [bodyTwoBulletEight render];
    
    if(deathOneIsAnimating){
        [deathAnimationOne renderParticles];
    }
    if(deathTwoIsAnimating){
        [deathAnimationTwo renderParticles];
    }
    
    if(!mainBodyOne->isDead && !deathOneIsAnimating){
        [modularObjects[0].moduleImage setRotation:modularObjects[0].rotation];
        [modularObjects[0].moduleImage renderAtPoint:CGPointMake(currentLocation.x + modularObjects[0].location.x, currentLocation.y + modularObjects[0].location.y) centerOfImage:YES];
    }
    if(!mainBodyTwo->isDead && !deathTwoIsAnimating){
        [modularObjects[1].moduleImage setRotation:modularObjects[1].rotation];
        [modularObjects[1].moduleImage renderAtPoint:CGPointMake(currentLocation.x + modularObjects[1].location.x, currentLocation.y + modularObjects[1].location.y) centerOfImage:YES];
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
