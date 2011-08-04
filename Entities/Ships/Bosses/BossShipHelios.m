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
        rightwing = &self.modularObjects[3];
        
    }
    
    return  self;
}

- (void)update:(GLfloat)delta {
    [super update:delta];
    
    currentLocation.x += ((desiredLocation.x - currentLocation.x) / bossSpeed/2) * (pow(1.584893192, bossSpeed)) * delta;
    currentLocation.y += ((desiredLocation.y - currentLocation.y) / bossSpeed/2) * (pow(1.584893192, bossSpeed)) * delta;
    
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
    
    //Code to move side to side
    if(currentLocation.x < 190 && moveLeft == NO){
        desiredLocation.x = 200;
    }
    else {
        moveLeft = YES;
    }
    if(currentLocation.x > 130 && moveLeft == YES){
        desiredLocation.x = 120;
    }
    else {
        moveLeft = NO;
    }
}

- (void)render {
    for(int i = 0; i < numberOfModules; i++) {
        if (!modularObjects[i].isDead) {
            [modularObjects[i].moduleImage setRotation:modularObjects[i].rotation];
            [modularObjects[i].moduleImage renderAtPoint:CGPointMake(currentLocation.x + modularObjects[i].location.x, currentLocation.y + modularObjects[i].location.y) centerOfImage:YES];
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
