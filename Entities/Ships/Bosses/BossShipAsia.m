//
//  BossShipAsia.m
//  Xenophobe
//
//  Created by Alexander on 10/20/10.
//  Copyright 2010 Alexander Nabavi-Noori, XanderNet Inc. All rights reserved.
//  

#import "BossShipAsia.h"


@implementation BossShipAsia

- (id)initWithLocation:(CGPoint)aPoint andPlayerShipRef:(PlayerShip *)playerRef {
    if((self = [super initWithBossID:kBoss_Asia initialLocation:aPoint andPlayerShipRef:playerRef])){
        NSLog(@"TEST");
        
        mainBody = self.modularObjects[0];
        turretLeft = self.modularObjects[1];
        turretRight = self.modularObjects[2];
        cannonRight = self.modularObjects[3];
        cannonLeft = self.modularObjects[4];
        
        rightCannonEmitterJoint = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
                                                                                    position:Vector2fMake(currentLocation.x + (-10), 0)
                                                                      sourcePositionVariance:Vector2fZero
                                                                                       speed:0.0f
                                                                               speedVariance:30.0f
                                                                            particleLifeSpan:1.0f
                                                                    particleLifespanVariance:0.0f
                                                                                       angle:360.0f
                                                                               angleVariance:0.0f
                                                                                     gravity:Vector2fMake(1.54, 0.7)
                                                                                  startColor:Color4fMake(0.3f, 1.0f, 0.66f, 1.0f)
                                                                          startColorVariance:Color4fMake(0.0f, 0.2f, 0.2f, 0.5f)
                                                                                 finishColor:Color4fMake(0.16f, 0.0f, 0.0f, 1.0f)
                                                                         finishColorVariance:Color4fMake(0.0f, 0.0f, 0.0f, 1.0f)
                                                                                maxParticles:100
                                                                                particleSize:64.0f
                                                                          finishParticleSize:0.0f
                                                                        particleSizeVariance:27.0f
                                                                                    duration:-1
                                                                               blendAdditive:NO];
        
        leftCannonEmitterJoint = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
                                                                                   position:Vector2fMake(currentLocation.x + 10, 0)
                                                                     sourcePositionVariance:Vector2fZero
                                                                                      speed:0.0f
                                                                              speedVariance:30.0f
                                                                           particleLifeSpan:1.0f
                                                                   particleLifespanVariance:0.0f
                                                                                      angle:360.0f
                                                                              angleVariance:0.0f
                                                                                    gravity:Vector2fMake(1.54, 0.7)
                                                                                 startColor:Color4fMake(0.3f, 1.0f, 0.66f, 1.0f)
                                                                         startColorVariance:Color4fMake(0.0f, 0.2f, 0.2f, 0.5f)
                                                                                finishColor:Color4fMake(0.16f, 0.0f, 0.0f, 1.0f)
                                                                        finishColorVariance:Color4fMake(0.0f, 0.0f, 0.0f, 1.0f)
                                                                               maxParticles:100
                                                                               particleSize:64.0f
                                                                         finishParticleSize:0.0f
                                                                       particleSizeVariance:27.0f
                                                                                   duration:-1
                                                                              blendAdditive:NO];
    }
    return self;
}

- (void)update:(GLfloat)delta {
    currentLocation.x += ((desiredLocation.x - currentLocation.x) / bossSpeed) * (pow(1.584893192, bossSpeed)) * delta;
    currentLocation.y += ((desiredLocation.y - currentLocation.y) / bossSpeed) * (pow(1.584893192, bossSpeed)) * delta;
    
    //Set the centers of the polygons so they get rendered properly
    for(int i = 0; i < numberOfModules; i++){
        [modularObjects[i].collisionPolygon setPos:CGPointMake(modularObjects[i].location.x + currentLocation.x, modularObjects[i].location.y + currentLocation.y)];  
    }
    
    NSLog(@"ASDLFKJ");
    
    [rightCannonEmitterJoint setSourcePosition:Vector2fMake(currentLocation.x + (-10), 0)];
    [leftCannonEmitterJoint setSourcePosition:Vector2fMake(currentLocation.x + 10, 0)];
    [rightCannonEmitterJoint update:delta];
    [leftCannonEmitterJoint update:delta];
}

- (void)render {
    for(int i = 0; i < numberOfModules; i++) {
        [modularObjects[i].moduleImage renderAtPoint:CGPointMake(currentLocation.x - modularObjects[i].location.x, currentLocation.y + modularObjects[i].location.y) centerOfImage:YES];
    }
    
    [rightCannonEmitterJoint renderParticles];
    [leftCannonEmitterJoint renderParticles];
    
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
