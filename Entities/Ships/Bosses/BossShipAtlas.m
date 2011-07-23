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

#import "BossShipAtlas.h"

@interface BossShipAtlas(Private)
- (void)aimCannonsAtPlayer;
@end


@implementation BossShipAtlas

- (id)initWithLocation:(CGPoint)aPoint andPlayerShipRef:(PlayerShip *)playerRef {
    if((self = [super initWithBossID:kBoss_Atlas initialLocation:aPoint andPlayerShipRef:playerRef])){        
        mainBody = &self.modularObjects[0];
        turretLeft = &self.modularObjects[1];
        turretRight = &self.modularObjects[2];
        cannonRight = &self.modularObjects[3];
        cannonLeft = &self.modularObjects[4];
        
        rightCannonEmitterJoint = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
                                                                                    position:Vector2fMake(currentLocation.x + 105, 0)
                                                                      sourcePositionVariance:Vector2fMake(0,0)
                                                                                       speed:0.01f
                                                                               speedVariance:0.0f
                                                                            particleLifeSpan:1.0f
                                                                    particleLifespanVariance:1.0f
                                                                                       angle:360.0f
                                                                               angleVariance:0
                                                                                     gravity:Vector2fMake(0.0f, 0.0f)
                                                                                  startColor:Color4fMake(0.3f, 1.0f, 0.66f, 1.0f)
                                                                          startColorVariance:Color4fMake(0.0f, 0.2f, 0.2f, 0.5f)
                                                                                 finishColor:Color4fMake(0.16f, 0.0f, 0.0f, 1.0f)
                                                                         finishColorVariance:Color4fMake(0.0f, 0.0f, 0.0f, 1.0f)
                                                                                maxParticles:10
                                                                                particleSize:25
                                                                          finishParticleSize:25
                                                                        particleSizeVariance:2
                                                                                    duration:-1
                                                                               blendAdditive:YES];
        
        leftCannonEmitterJoint = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
                                                                                   position:Vector2fMake(currentLocation.x + 105, 0)
                                                                     sourcePositionVariance:Vector2fMake(0,0)
                                                                                      speed:0.01f
                                                                              speedVariance:0.0f
                                                                           particleLifeSpan:1.0f
                                                                   particleLifespanVariance:1.0f
                                                                                      angle:360.0f
                                                                              angleVariance:0
                                                                                    gravity:Vector2fMake(0.0f, 0.0f)
                                                                                 startColor:Color4fMake(0.3f, 1.0f, 0.66f, 1.0f)
                                                                         startColorVariance:Color4fMake(0.0f, 0.2f, 0.2f, 0.5f)
                                                                                finishColor:Color4fMake(0.16f, 0.0f, 0.0f, 1.0f)
                                                                        finishColorVariance:Color4fMake(0.0f, 0.0f, 0.0f, 1.0f)
                                                                               maxParticles:10
                                                                               particleSize:25
                                                                         finishParticleSize:25
                                                                       particleSizeVariance:2
                                                                                   duration:-1
                                                                              blendAdditive:YES];
    }
    return self;
}

- (void)update:(GLfloat)delta {
    [super update:delta];
    
    currentLocation.x += ((desiredLocation.x - currentLocation.x) / bossSpeed) * (pow(1.584893192, bossSpeed)) * delta;
    currentLocation.y += ((desiredLocation.y - currentLocation.y) / bossSpeed) * (pow(1.584893192, bossSpeed)) * delta;
    
    [self aimCannonsAtPlayer];
    
    //Set the centers of the polygons so they get rendered properly
    for(int i = 0; i < numberOfModules; i++){
        if(modularObjects[i].isDead == NO){
            [modularObjects[i].collisionPolygon setPos:CGPointMake(modularObjects[i].location.x + currentLocation.x, modularObjects[i].location.y + currentLocation.y)];
        }
        else {
            //Death Animation Update Emitter
        }
    }
        
    [rightCannonEmitterJoint setSourcePosition:Vector2fMake(currentLocation.x + (-105), currentLocation.y)];
    [leftCannonEmitterJoint setSourcePosition:Vector2fMake(currentLocation.x + 105, currentLocation.y)];
    if(cannonRight->isDead == NO){
        [rightCannonEmitterJoint update:delta];
    }
    if(cannonLeft->isDead == NO){
        [leftCannonEmitterJoint update:delta];
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
    
    if(angleToPlayer > 20) angleToPlayer = 20;
        
    
    // Right Cannon aiming
    playerXPosition = (currentLocation.x + cannonRight->location.x) - playerShipRef.currentLocation.x;
    playerYPosition = (currentLocation.y + cannonRight->location.y) - playerShipRef.currentLocation.y;
    
    float angleToPlayer2 = atan2f(playerYPosition, playerXPosition);
    angleToPlayer2 = angleToPlayer2 * (180 / M_PI);
    if(angleToPlayer2 < 0) angleToPlayer2 += 360;
    angleToPlayer2 = 90 - angleToPlayer2;
    if(angleToPlayer2 < 0) angleToPlayer2 += 360;
    
    if(angleToPlayer2 < 340) angleToPlayer2 = 340;
    
    
    //Rotation for polygons to match the rotation of the cannons
    for(int i = 0; i < cannonLeft->collisionPolygon.pointCount; i++){
        Vector2f tempPoint = cannonLeft->collisionPolygon.originalPoints[i];
        double tempAngle = DEGREES_TO_RADIANS(cannonLeft->rotation - angleToPlayer);
        cannonLeft->collisionPolygon.originalPoints[i] = Vector2fMake((tempPoint.x * cos(tempAngle)) - (tempPoint.y * sin(tempAngle)),
                                                                            (tempPoint.x * sin(tempAngle)) + (tempPoint.y * cos(tempAngle)));
    }
    [cannonLeft->collisionPolygon buildEdges];

    for(int i = 0; i < cannonRight->collisionPolygon.pointCount; i++){
        Vector2f tempPoint = cannonRight->collisionPolygon.originalPoints[i];
        double tempAngle = DEGREES_TO_RADIANS(cannonRight->rotation - angleToPlayer2);
        cannonRight->collisionPolygon.originalPoints[i] = Vector2fMake((tempPoint.x * cos(tempAngle)) - (tempPoint.y * sin(tempAngle)),
                                                                            (tempPoint.x * sin(tempAngle)) + (tempPoint.y * cos(tempAngle)));
    }
    [cannonRight->collisionPolygon buildEdges];

    
    cannonRight->rotation = angleToPlayer2;
    cannonLeft->rotation = angleToPlayer;
}

- (void)render {
    for(int i = 0; i < numberOfModules; i++) {
        if(modularObjects[i].isDead == NO){
            [modularObjects[i].moduleImage setRotation:modularObjects[i].rotation];
            [modularObjects[i].moduleImage renderAtPoint:CGPointMake(currentLocation.x + modularObjects[i].location.x, currentLocation.y + modularObjects[i].location.y) centerOfImage:YES];
        }
        else {
            //Render death animation emitter
        }
    }
    
    if(cannonRight->isDead == NO){
        [rightCannonEmitterJoint renderParticles];
    }
    if(cannonLeft->isDead == NO){
        [leftCannonEmitterJoint renderParticles];
    }
    
    /*
    glPushMatrix();
    
    glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
    
    GLfloat lineToShip[] = {
        playerShipRef.currentLocation.x, playerShipRef.currentLocation.y,
        (currentLocation.x + cannonLeft.location.x), (currentLocation.y + cannonLeft.location.y),
    };
    
    glVertexPointer(2, GL_FLOAT, 0, lineToShip);
    glEnableClientState(GL_VERTEX_ARRAY);
    glDrawArrays(GL_LINES, 0, 2);
    
    glPopMatrix();
    */
    
    if(DEBUG) {
        glPushMatrix();
        
        glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
        
        for(int i = 0; i < numberOfModules; i++) {
            if(modularObjects[i].isDead == NO){
                for(int j = 0; j < (modularObjects[i].collisionPointsCount - 1); j++) {
                        GLfloat line[] = {
                            modularObjects[i].collisionPolygon.points[j].x, modularObjects[i].collisionPolygon.points[j].y,
                            modularObjects[i].collisionPolygon.points[j+1].x, modularObjects[i].collisionPolygon.points[j+1].y,
                        };
                        
                        glVertexPointer(2, GL_FLOAT, 0, line);
                        glEnableClientState(GL_VERTEX_ARRAY);
                        glDrawArrays(GL_LINES, 0, 2);
                }
                
                GLfloat lineEnd[] = {
                    modularObjects[i].collisionPolygon.points[(modularObjects[i].collisionPointsCount - 1)].x, modularObjects[i].collisionPolygon.points[(modularObjects[i].collisionPointsCount - 1)].y,
                        modularObjects[i].collisionPolygon.points[0].x, modularObjects[i].collisionPolygon.points[0].y,
                };
            
                glVertexPointer(2, GL_FLOAT, 0, lineEnd);
                glEnableClientState(GL_VERTEX_ARRAY);
                glDrawArrays(GL_LINES, 0, 2);
            }
        }
        
        glPopMatrix();
    }
}

- (void)dealloc {
    
    [super dealloc];
}

@end
