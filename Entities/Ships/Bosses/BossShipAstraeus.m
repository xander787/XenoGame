//
//  BossShipAstraeus.m
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
//	Last Updated - 7/19/2011 @5PM - Alexander
//  - Cannons rotate and also shift positions and everything
//
//  Last Updated - 8/2/11 @8PM - James
//  - Fixed a bunch of bugs, mainly with copying the old and broken
//  angle conde and etc form Atlas. Fixed now

#import "BossShipAstraeus.h"
#import "BossShip.h"


@implementation BossShipAstraeus

@synthesize leftSideTransitionComplete, rightSideTransitionComplete;

- (id)initWithLocation:(CGPoint)aPoint andPlayerShipRef:(PlayerShip *)playerRef {
    if((self = [super initWithBossID:kBoss_Astraeus initialLocation:aPoint andPlayerShipRef:playerRef])){
        ship = &self.modularObjects[0];
        cannonFrontLeft = &self.modularObjects[2];
        cannonFrontRight = &self.modularObjects[1];
        cannonReplacementOneLeft = &self.modularObjects[3];
        cannonReplacementOneRight = &self.modularObjects[4];
        cannonReplacementTwoLeft = &self.modularObjects[5];
        cannonReplacementTwoRight = &self.modularObjects[6];
        cannonReplacementThreeLeft = &self.modularObjects[7];
        cannonReplacementThreeRight = &self.modularObjects[8];
    }
    
    return self;
}

- (void)update:(GLfloat)delta {
    [super update:delta];
    
    currentLocation.x += ((desiredLocation.x - currentLocation.x) / bossSpeed) * (pow(1.584893192, bossSpeed)) * delta;
    currentLocation.y += ((desiredLocation.y - currentLocation.y) / bossSpeed) * (pow(1.584893192, bossSpeed)) * delta;
    
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
    
    {
        // Left Cannon Aiming
        float playerXPosition = (currentLocation.x + cannonFrontLeft->location.x) - playerShipRef.currentLocation.x;
        float playerYPosition = (currentLocation.y + cannonFrontLeft->location.y) - playerShipRef.currentLocation.y;
        
        float angleToPlayer = atan2f(playerYPosition, playerXPosition);
        angleToPlayer = angleToPlayer * (180 / M_PI);
        if(angleToPlayer < 0) angleToPlayer += 360;
        angleToPlayer = 90 - angleToPlayer;
        if(angleToPlayer < 0) angleToPlayer += 360;
        
        if(angleToPlayer > 20 && angleToPlayer < 180) angleToPlayer = 20;
        if(angleToPlayer < 340 && angleToPlayer > 180) angleToPlayer = 340;
        
        
        // Right Cannon aiming
        playerXPosition = (currentLocation.x + cannonFrontRight->location.x) - playerShipRef.currentLocation.x;
        playerYPosition = (currentLocation.y + cannonFrontRight->location.y) - playerShipRef.currentLocation.y;
        
        float angleToPlayer2 = atan2f(playerYPosition, playerXPosition);
        angleToPlayer2 = angleToPlayer2 * (180 / M_PI);
        if(angleToPlayer2 < 0) angleToPlayer2 += 360;
        angleToPlayer2 = 90 - angleToPlayer2;
        if(angleToPlayer2 < 0) angleToPlayer2 += 360;
        
        if(angleToPlayer2 > 20 && angleToPlayer2 < 180) angleToPlayer2 = 20;
        if(angleToPlayer2 < 340 && angleToPlayer2 > 180) angleToPlayer2 = 340;
        
        
        //Rotation for polygons to match the rotation of the cannons
        for(int k = 0; k < [cannonFrontLeft->collisionPolygonArray count]; k++){
            for(int i = 0; i < [[cannonFrontLeft->collisionPolygonArray objectAtIndex:k] pointCount]; i++){
                Vector2f tempPoint = [[cannonFrontLeft->collisionPolygonArray objectAtIndex:k] originalPoints][i];
                double tempAngle = DEGREES_TO_RADIANS(cannonFrontLeft->rotation - angleToPlayer);
                [[cannonFrontLeft->collisionPolygonArray objectAtIndex:k] originalPoints][i] = Vector2fMake((tempPoint.x * cos(tempAngle)) - (tempPoint.y * sin(tempAngle)), (tempPoint.x * sin(tempAngle)) + (tempPoint.y * cos(tempAngle)));
            }
            [[cannonFrontLeft->collisionPolygonArray objectAtIndex:k] buildEdges];
        }
        
        for(int k = 0; k < [cannonFrontRight->collisionPolygonArray count]; k++){
            for(int i = 0; i < [[cannonFrontRight->collisionPolygonArray objectAtIndex:k] pointCount]; i++){
                Vector2f tempPoint = [[cannonFrontRight->collisionPolygonArray objectAtIndex:k] originalPoints][i];
                double tempAngle = DEGREES_TO_RADIANS(cannonFrontRight->rotation - angleToPlayer2);
                [[cannonFrontRight->collisionPolygonArray objectAtIndex:k] originalPoints][i] = Vector2fMake((tempPoint.x * cos(tempAngle)) - (tempPoint.y * sin(tempAngle)), (tempPoint.x * sin(tempAngle)) + (tempPoint.y * cos(tempAngle)));
            }
            [[cannonFrontRight->collisionPolygonArray objectAtIndex:k] buildEdges];
        }

        cannonFrontRight->rotation = angleToPlayer2;
        cannonFrontLeft->rotation = angleToPlayer;

    }
    
    if(cannonFrontLeft->isDead) {
        timeSinceFrontLeftDied+= delta;
        leftSideTransitionComplete = NO;
        if(cannonReplacementOneLeft->location.x < cannonFrontLeft->defaultLocation.x) cannonReplacementOneLeft->location.x = cannonReplacementOneLeft->location.x + (timeSinceFrontLeftDied * 0.5);
        if(cannonReplacementOneLeft->location.y > cannonFrontLeft->defaultLocation.y) cannonReplacementOneLeft->location.y = cannonReplacementOneLeft->location.y - (timeSinceFrontLeftDied * 0.5);
        if(cannonReplacementOneLeft->rotation > -cannonFrontLeft->rotation) cannonReplacementOneLeft->rotation -= (timeSinceFrontLeftDied * 0.5);
        
        if(cannonReplacementTwoLeft->location.x < cannonReplacementOneLeft->defaultLocation.x) cannonReplacementTwoLeft->location.x = cannonReplacementTwoLeft->location.x + (timeSinceFrontLeftDied * 0.5);
        if(cannonReplacementTwoLeft->location.y > cannonReplacementOneLeft->defaultLocation.y) cannonReplacementTwoLeft->location.y = cannonReplacementTwoLeft->location.y - (timeSinceFrontLeftDied * 0.5);
        if(cannonReplacementTwoLeft->rotation > -30) cannonReplacementTwoLeft->rotation -= (timeSinceFrontLeftDied * 0.5);
        
        if(cannonReplacementThreeLeft->location.x < cannonReplacementTwoLeft->defaultLocation.x) cannonReplacementThreeLeft->location.x = cannonReplacementThreeLeft->location.x + (timeSinceFrontLeftDied * 0.5);
        if(cannonReplacementThreeLeft->location.y > cannonReplacementTwoLeft->defaultLocation.y) cannonReplacementThreeLeft->location.y = cannonReplacementThreeLeft->location.y - (timeSinceFrontLeftDied * 0.5);
        if(cannonReplacementThreeLeft->rotation > -30) cannonReplacementThreeLeft->rotation -= (timeSinceFrontLeftDied * 0.5);
        
        if(!(cannonReplacementOneLeft->location.x < cannonFrontLeft->defaultLocation.x) && !(cannonReplacementOneLeft->location.y > cannonFrontLeft->defaultLocation.y) && !(cannonReplacementTwoLeft->location.x < cannonReplacementOneLeft->defaultLocation.x) && !(cannonReplacementTwoLeft->location.y > cannonReplacementOneLeft->defaultLocation.y) && !(cannonReplacementThreeLeft->location.x < cannonReplacementTwoLeft->defaultLocation.x) && !(cannonReplacementThreeLeft->location.y > cannonReplacementTwoLeft->defaultLocation.y)) {
            leftSideTransitionComplete = YES;
        }
    }
    
    if(cannonFrontRight->isDead) {
        timeSinceFrontRightDied+= delta;
        rightSideTransitionComplete = NO;
        if(cannonReplacementOneRight->location.x > cannonFrontRight->defaultLocation.x) cannonReplacementOneRight->location.x = cannonReplacementOneRight->location.x - (timeSinceFrontRightDied * 0.5);
        if(cannonReplacementOneRight->location.y > cannonFrontRight->defaultLocation.y) cannonReplacementOneRight->location.y = cannonReplacementOneRight->location.y - (timeSinceFrontRightDied * 0.5);
        if(cannonReplacementOneRight->rotation > -cannonFrontRight->rotation) cannonReplacementOneRight->rotation += (timeSinceFrontRightDied * 0.5);
        
        if(cannonReplacementTwoRight->location.x > cannonReplacementOneRight->defaultLocation.x) cannonReplacementTwoRight->location.x = cannonReplacementTwoRight->location.x - (timeSinceFrontRightDied * 0.5);
        if(cannonReplacementTwoRight->location.y > cannonReplacementOneRight->defaultLocation.y) cannonReplacementTwoRight->location.y = cannonReplacementTwoRight->location.y - (timeSinceFrontRightDied * 0.5);
        if(cannonReplacementTwoRight->rotation < 30) cannonReplacementTwoRight->rotation += (timeSinceFrontRightDied * 0.5);

        if(cannonReplacementThreeRight->location.x > cannonReplacementTwoRight->defaultLocation.x) cannonReplacementThreeRight->location.x = cannonReplacementThreeRight->location.x - (timeSinceFrontRightDied * 0.5);
        if(cannonReplacementThreeRight->location.y > cannonReplacementTwoRight->defaultLocation.y) cannonReplacementThreeRight->location.y = cannonReplacementThreeRight->location.y - (timeSinceFrontRightDied * 0.5);
        if(cannonReplacementThreeRight->rotation < 30) cannonReplacementThreeRight->rotation += (timeSinceFrontRightDied * 0.5);

        if(!(cannonReplacementOneRight->location.x > cannonFrontRight->defaultLocation.x) && !(cannonReplacementOneRight->location.y > cannonFrontRight->defaultLocation.y) && !(cannonReplacementTwoRight->location.x > cannonReplacementOneRight->defaultLocation.x) && !(cannonReplacementTwoRight->location.y > cannonReplacementOneRight->defaultLocation.y) && !(cannonReplacementThreeRight->location.x > cannonReplacementTwoRight->defaultLocation.x) && !(cannonReplacementThreeRight->location.y > cannonReplacementTwoRight->defaultLocation.y)) {
            rightSideTransitionComplete = YES;
        }
    }
    
    if(rightSideTransitionComplete) {
        cannonFrontRight->isDead = NO;
        rightSideTransitionComplete = NO;
        timeSinceFrontRightDied = 0.0f;
        
        if(cannonReplacementThreeRight->isDead == NO) {
            cannonReplacementThreeRight->isDead = YES;
            cannonReplacementOneRight->location = cannonReplacementOneRight->defaultLocation;
            cannonReplacementTwoRight->location = cannonReplacementTwoRight->defaultLocation;
            cannonReplacementOneRight->rotation = 0;
            cannonReplacementTwoRight->rotation = 0;
        }
        else if(cannonReplacementTwoRight->isDead == NO) {
            cannonReplacementTwoRight->isDead = YES;
            cannonReplacementOneRight->location = cannonReplacementOneRight->defaultLocation;
            cannonReplacementOneRight->rotation = 0;
        }
        else if(cannonReplacementOneRight->isDead == NO) {
            cannonReplacementOneRight->isDead = YES;
        }
        else {
            // All cannons are dead
        }
    }
    
    if(leftSideTransitionComplete) {
        cannonFrontLeft->isDead = NO;
        leftSideTransitionComplete = NO;
        timeSinceFrontLeftDied = 0.0f;
        
        if(cannonReplacementThreeLeft->isDead == NO) {
            cannonReplacementThreeLeft->isDead = YES;
            cannonReplacementOneLeft->location = cannonReplacementOneLeft->defaultLocation;
            cannonReplacementTwoLeft->location = cannonReplacementTwoLeft->defaultLocation;
            cannonReplacementOneLeft->rotation = 0;
            cannonReplacementTwoLeft->rotation = 0;
        }
        else if(cannonReplacementTwoLeft->isDead == NO) {
            cannonReplacementTwoLeft->isDead = YES;
            cannonReplacementOneLeft->location = cannonReplacementOneLeft->defaultLocation;
            cannonReplacementOneLeft->rotation = 0;
        }
        else if(cannonReplacementOneLeft->isDead == NO) {
            cannonReplacementOneLeft->isDead = YES;
        }
        else {
            // All cannons are dead
        }
    }
}

- (void)render {
    for(int i = 0; i < numberOfModules; i++) {
        if (!modularObjects[i].isDead) {
            [modularObjects[i].moduleImage setRotation:modularObjects[i].rotation];
            [modularObjects[i].moduleImage renderAtPoint:CGPointMake(currentLocation.x + modularObjects[i].location.x, currentLocation.y + modularObjects[i].location.y) centerOfImage:YES];
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
