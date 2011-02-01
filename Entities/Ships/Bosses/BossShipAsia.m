//
//  BossShipAsia.m
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

#import "BossShipAsia.h"

@interface BossShipAsia(Private)
- (void)aimCannonsAtPlayer;
@end


@implementation BossShipAsia

- (id)initWithLocation:(CGPoint)aPoint andPlayerShipRef:(PlayerShip *)playerRef {
    if((self = [super initWithBossID:kBoss_Asia initialLocation:aPoint andPlayerShipRef:playerRef])){        
        mainBody = self.modularObjects[0];
        turretLeft = self.modularObjects[1];
        turretRight = self.modularObjects[2];
        cannonRight = self.modularObjects[3];
        cannonLeft = self.modularObjects[4];
        
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
    currentLocation.x += ((desiredLocation.x - currentLocation.x) / bossSpeed) * (pow(1.584893192, bossSpeed)) * delta;
    currentLocation.y += ((desiredLocation.y - currentLocation.y) / bossSpeed) * (pow(1.584893192, bossSpeed)) * delta;
    
    [self aimCannonsAtPlayer];
    
    //Set the centers of the polygons so they get rendered properly
    for(int i = 0; i < numberOfModules; i++){
        [modularObjects[i].collisionPolygon setPos:CGPointMake(modularObjects[i].location.x + currentLocation.x, modularObjects[i].location.y + currentLocation.y)];  
    }
        
    [rightCannonEmitterJoint setSourcePosition:Vector2fMake(currentLocation.x + (-105), currentLocation.y)];
    [leftCannonEmitterJoint setSourcePosition:Vector2fMake(currentLocation.x + 105, currentLocation.y)];
    [rightCannonEmitterJoint update:delta];
    [leftCannonEmitterJoint update:delta];
}

- (void)aimCannonsAtPlayer {
    // Right Cannon Aiming
    float playerXPosition = (currentLocation.x + cannonLeft.location.x) - playerShipRef.currentLocation.x;
    float playerYPosition = (currentLocation.y + cannonLeft.location.y) - playerShipRef.currentLocation.y;
    
    float angleToPlayer = atan2f(playerYPosition, playerXPosition);
    angleToPlayer = angleToPlayer * (180 / M_PI);
    if(angleToPlayer < 0) angleToPlayer += 360;
    angleToPlayer = 90 - angleToPlayer;
    if(angleToPlayer < 0) angleToPlayer += 360;
    
    if(angleToPlayer < 340) angleToPlayer = 340;
    
    
    
    // Left Cannon aiming
    playerXPosition = (currentLocation.x + cannonRight.location.x) - playerShipRef.currentLocation.x;
    playerYPosition = (currentLocation.y + cannonRight.location.y) - playerShipRef.currentLocation.y;
    
    float angleToPlayer2 = atan2f(playerYPosition, playerXPosition);
    angleToPlayer2 = angleToPlayer2 * (180 / M_PI);
    if(angleToPlayer2 < 0) angleToPlayer2 += 360;
    angleToPlayer2 = 90 - angleToPlayer2;
    if(angleToPlayer2 < 0) angleToPlayer2 += 360;
    
    if(angleToPlayer2 > 20) angleToPlayer2 = 20;
    
    
    
    //Rotation for polygons to match the rotation of the cannons
    for(int i = 0; i < modularObjects[4].collisionPolygon.pointCount; i++){
        Vector2f tempPoint = modularObjects[4].collisionPolygon.originalPoints[i];
        double tempAngle = DEGREES_TO_RADIANS(modularObjects[3].rotation - angleToPlayer);
        modularObjects[4].collisionPolygon.originalPoints[i] = Vector2fMake((tempPoint.x * cos(tempAngle)) - (tempPoint.y * sin(tempAngle)),
                                                                            (tempPoint.x * sin(tempAngle)) + (tempPoint.y * cos(tempAngle)));
    }
    [modularObjects[4].collisionPolygon buildEdges];

    for(int i = 0; i < modularObjects[3].collisionPolygon.pointCount; i++){
        Vector2f tempPoint = modularObjects[3].collisionPolygon.originalPoints[i];
        double tempAngle = DEGREES_TO_RADIANS(modularObjects[4].rotation - angleToPlayer2);
        modularObjects[3].collisionPolygon.originalPoints[i] = Vector2fMake((tempPoint.x * cos(tempAngle)) - (tempPoint.y * sin(tempAngle)),
                                                                            (tempPoint.x * sin(tempAngle)) + (tempPoint.y * cos(tempAngle)));
    }
    [modularObjects[3].collisionPolygon buildEdges];

    
    
    [modularObjects[3].moduleImage setRotation:angleToPlayer];
    modularObjects[3].rotation = angleToPlayer;
    [modularObjects[4].moduleImage setRotation:angleToPlayer2];
    modularObjects[4].rotation = angleToPlayer2;
}

- (void)render {
    for(int i = 0; i < numberOfModules; i++) {
        [modularObjects[i].moduleImage renderAtPoint:CGPointMake(currentLocation.x - modularObjects[i].location.x, currentLocation.y + modularObjects[i].location.y) centerOfImage:YES];
    }
    
    [rightCannonEmitterJoint renderParticles];
    [leftCannonEmitterJoint renderParticles];
    
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
        
        glPopMatrix();
    }
}

- (void)dealloc {
    
    [super dealloc];
}

@end
