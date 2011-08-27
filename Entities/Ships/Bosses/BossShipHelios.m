//
//  BossShipHelios.m
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

#import "BossShipHelios.h"
#import "BossShip.h"


@implementation BossShipHelios

- (id)initWithLocation:(CGPoint)aPoint andPlayerShipRef:(PlayerShip *)playerRef {
    if((self = [super initWithBossID:kBoss_Helios initialLocation:aPoint andPlayerShipRef:playerRef])){
        
        mainBody = &self.modularObjects[0];
        tail = &self.modularObjects[1];
        leftWing = &self.modularObjects[2];
        rightWing = &self.modularObjects[3];
        
        state = -1;
        
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
        
        rightWingDeathSecondaryEmitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
                                                                                           position:Vector2fMake(currentLocation.x, currentLocation.y)
                                                                             sourcePositionVariance:Vector2fZero
                                                                                              speed:0.8
                                                                                      speedVariance:0.2
                                                                                   particleLifeSpan:0.2
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
        
        leftWingDeathSecondaryEmitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
                                                                                          position:Vector2fMake(currentLocation.x, currentLocation.y)
                                                                            sourcePositionVariance:Vector2fZero
                                                                                             speed:0.8
                                                                                     speedVariance:0.2
                                                                                  particleLifeSpan:0.2
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
        
        wingShipDeathEmitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
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
        
        for(int i = 0; i < numberOfModules; i++) {
            modularObjects[i].desiredLocation = modularObjects[i].location;
        }
    }
    
    return  self;
}

- (void)update:(GLfloat)delta {
    [super update:delta];
        
    if (state == -1) {
        currentLocation.x += ((desiredLocation.x - currentLocation.x) / bossSpeed) * (pow(1.584893192, bossSpeed)) * delta;
        currentLocation.y += ((desiredLocation.y - currentLocation.y) / bossSpeed) * (pow(1.584893192, bossSpeed)) * delta;
    }
    else if(state == kHeliosState_StageOne) {
        currentLocation.x += ((desiredLocation.x - currentLocation.x) / bossSpeed) * (pow(1.584893192, bossSpeed/2.5)) * delta;
        currentLocation.y += ((desiredLocation.y - currentLocation.y) / bossSpeed) * (pow(1.584893192, bossSpeed/2.5)) * delta;
    }
    else if(state == kHeliosState_StageTwo) {
        currentLocation.x += ((desiredLocation.x - currentLocation.x) / bossSpeed) * (pow(1.584893192, bossSpeed*2)) * delta;
        currentLocation.y += ((desiredLocation.y - currentLocation.y) / bossSpeed) * (pow(1.584893192, bossSpeed*2)) * delta;
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
    
    [mainBodyDeathEmitter setSourcePosition:Vector2fMake(mainBody->location.x + currentLocation.x, mainBody->location.y + currentLocation.y)];
    [rightWingDeathSecondaryEmitter setSourcePosition:Vector2fMake(rightWing->location.x + currentLocation.x, rightWing->location.y + currentLocation.y)];
    [leftWingDeathSecondaryEmitter setSourcePosition:Vector2fMake(leftWing->location.x + currentLocation.x, leftWing->location.y + currentLocation.y)];
    [wingShipDeathEmitter setSourcePosition:Vector2fMake(((rightWing->location.x + leftWing->location.x) / 2) + currentLocation.x, rightWing->location.y + currentLocation.y)];
    
    if (mainBody->isDead) {
        [mainBodyDeathEmitter update:delta];
    }
    if (rightWing->isDead && leftWing->isDead && state == kHeliosState_StageTwo) {
        [wingShipDeathEmitter update:delta];
    }
    
    if (wingRightFlewOff) {
        [rightWingDeathSecondaryEmitter update:delta];
    }
    if (wingLeftFlewOff) {
        [leftWingDeathSecondaryEmitter update:delta];
    }
    
    //Code to move side to side
    if(shipIsDeployed && !currentStagePaused){
        
        if (state == -1) {
            state = kHeliosState_StageOne;
        }
        
        if (state == kHeliosState_StageOne) {
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
            
            if (wingRightFlewOff && wingLeftFlewOff) {
                desiredLocation = CGPointMake(160.0f, currentLocation.y);
                currentStagePaused = YES;
            }
        }
        
        if (state == kHeliosState_StageTwo) {
            holdingTimer += delta;
            
            if(holdingTimer >= 1.4){
                holdingTimer = 0.0;
                
                if(rightWing->location.x <= 0){
                    rightWing->desiredLocation.x = RANDOM_0_TO_1() * 160;
                }
                else if(rightWing->location.x >= 0){
                    rightWing->desiredLocation.x = -(RANDOM_0_TO_1() * 160);
                }
                
                leftWing->desiredLocation = Vector2fMake(rightWing->desiredLocation.x - 55.0f, -150.0f);
            }   
        }
    }
    else if(currentStagePaused) {
        if (state == kHeliosState_StageOne) {
            [playerShipRef stopAllProjectiles];
            
            leftWing->desiredLocation = Vector2fMake(-25.0f, -150.0f);
            rightWing->desiredLocation = Vector2fMake(25.0f, -150.0f);
            
            leftWing->moduleHealth = leftWing->moduleMaxHealth;
            rightWing->moduleHealth = rightWing->moduleMaxHealth;
            
            leftWing->isDead = NO;
            rightWing->isDead = NO;
            
            if (abs(leftWing->desiredLocation.x - leftWing->location.x) < 3 && abs(leftWing->desiredLocation.y - leftWing->location.y) < 3 && abs(rightWing->desiredLocation.x - rightWing->location.x) < 3 && abs(rightWing->desiredLocation.y - rightWing->location.y) < 3) {
                currentStagePaused = NO;
                state = kHeliosState_StageTwo;
            }
        }
    }
    
    // Update locations of the modules (for fly-offs)
    for(int i = 0; i < numberOfModules; i++) {
        modularObjects[i].location.x += ((modularObjects[i].desiredLocation.x - modularObjects[i].location.x) / bossSpeed) * (pow(1.584893192, bossSpeed/2)) * delta;
        modularObjects[i].location.y += ((modularObjects[i].desiredLocation.y - modularObjects[i].location.y) / bossSpeed) * (pow(1.584893192, bossSpeed/2)) * delta;
        
    }
}

- (void)hitModule:(int)module withDamage:(int)damage {
    modularObjects[module].moduleHealth -= damage;
    
    [super hitModule:module withDamage:damage];
}

- (void)render {
    for(int i = 0; i < numberOfModules; i++) {
        if (modularObjects[i].isDead == NO || state == kHeliosState_StageOne) {
            [modularObjects[i].moduleImage setRotation:modularObjects[i].rotation];
            [modularObjects[i].moduleImage renderAtPoint:CGPointMake(currentLocation.x + modularObjects[i].location.x, currentLocation.y + modularObjects[i].location.y) centerOfImage:YES];
        }
    }
    
    if (mainBody->isDead) {
        [mainBodyDeathEmitter renderParticles];
    }
    if (rightWing->isDead && leftWing->isDead && state == kHeliosState_StageTwo) {
        [wingShipDeathEmitter renderParticles];
    }
    
    if(rightWing->isDead){
        if (state == kHeliosState_StageTwo) {
            [wingShipDeathEmitter renderParticles];
        }
        else {
            wingRightFlewOff = YES;
            [rightWingDeathSecondaryEmitter renderParticles];
            rightWing->desiredLocation = Vector2fMake(300.0f,rightWing->location.y);
        }
    }
    if(leftWing->isDead){
        if (state == kHeliosState_StageTwo) {
            [wingShipDeathEmitter renderParticles];
        }
        else {
            wingLeftFlewOff = YES;
            [leftWingDeathSecondaryEmitter renderParticles];
            leftWing->desiredLocation = Vector2fMake(-300.0f,leftWing->location.y);
        }
    }

    
    if(YES) {
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
