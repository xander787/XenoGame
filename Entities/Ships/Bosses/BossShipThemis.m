//
//  BossShipThemis.m
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

#import "BossShipThemis.h"
#import "BossShip.h"

#define kRightChainClamp_X 39
#define kRightChainClamp_Y -8
#define kLeftChainClamp_X -39
#define kLeftChainClamp_Y -8

#define kChainEndClamp_X 0
#define kChainEndClamp_Y 16

#define kChainSegmentFullHeight 14
#define kChainSegmentConnectingHeight 7

@implementation BossShipThemis

- (id)initWithLocation:(CGPoint)aPoint andPlayershipRef:(PlayerShip *)playerRef {
    if((self = [super initWithBossID:kBoss_Themis initialLocation:aPoint andPlayerShipRef:playerRef])) {
        mainBody = &self.modularObjects[0];
        chainEndRight = &self.modularObjects[1];
        chainEndLeft = &self.modularObjects[2];
        
        state = -1;
        
        for(int i = 0; i < numberOfModules; i++) {
            modularObjects[i].desiredLocation = modularObjects[i].location;
        }
    }
    return self;
}

- (void)update:(GLfloat)delta {
    [super update:delta];
    
    if (state == -1) {
        currentLocation.x += ((desiredLocation.x - currentLocation.x) / bossSpeed) * (pow(1.584893192, bossSpeed)) * delta;
        currentLocation.y += ((desiredLocation.y - currentLocation.y) / bossSpeed) * (pow(1.584893192, bossSpeed)) * delta;
    }
    else if(state == kThemisState_StageOne) {
        currentLocation.x += ((desiredLocation.x - currentLocation.x) / bossSpeed) * (pow(1.584893192, bossSpeed/1.25)) * delta;
        currentLocation.y += ((desiredLocation.y - currentLocation.y) / bossSpeed) * (pow(1.584893192, bossSpeed/1.25)) * delta;
    }
    else if(state == kThemisState_StageTwo) {
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
    
    if (shipIsDeployed) {
        
        if (state == -1) {
            state = kThemisState_StageOne;
        }
        
        if (state == kThemisState_StageOne) {
            holdingTimer += delta;
            
            if (chainShootTimer <= 0) {
                shouldShootChain = YES;
                
                chainShootTimer = RANDOM_0_TO_1() * 20;
                if (chainShootTimer < 5) {
                    chainShootTimer += RANDOM_0_TO_1() * 10;
                }
                
                if (RANDOM_MINUS_1_TO_1() < 0) {
                    chainToShootIsLeft = YES;
                    chainToShootIsRight = NO;
                }
                else {
                    chainToShootIsLeft = NO;
                    chainToShootIsRight = YES;
                }
            }
            else {
                chainShootTimer -= delta;
            }
            
            NSLog(@"%f", chainShootTimer);
            
            if(holdingTimer >= 1.4){
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
            
            if (shouldShootChain && !chainEndDeployed) {
                if (chainToShootIsLeft) {
                    chainEndLeft->desiredLocation = Vector2fMake(chainEndLeft->location.x, (playerShipRef.currentLocation.y - 10) - self.currentLocation.y);
                    chainEndDeployed = YES;
                }
                else if (chainToShootIsRight) {
                    chainEndRight->desiredLocation = Vector2fMake(chainEndRight->location.x, (playerShipRef.currentLocation.y - 10) - self.currentLocation.y);
                    chainEndDeployed = YES;
                }
            }
            
            if (chainEndDeployed) {
                chainDeploymentTimer += delta;
                if(chainDeploymentTimer >= 4) {
                    chainDeploymentTimer = 0.0f;
                    shouldShootChain = NO;
                    chainEndDeployed = NO;
                    if (chainToShootIsLeft) {
                        chainEndLeft->desiredLocation = Vector2fMake(chainEndLeft->location.x, chainEndLeft->defaultLocation.y);
                        chainEndDeployed = NO;
                    }
                    else if (chainToShootIsRight) {
                        chainEndRight->desiredLocation = Vector2fMake(chainEndRight->location.x, chainEndRight->defaultLocation.y);
                        chainEndDeployed = NO;
                    }
                }
            }
        }
    }
    
    for(int i = 0; i < numberOfModules; i++) {
        modularObjects[i].location.x += ((modularObjects[i].desiredLocation.x - modularObjects[i].location.x) / bossSpeed/1.10) * (pow(1.584893192, bossSpeed)) * delta;
        modularObjects[i].location.y += ((modularObjects[i].desiredLocation.y - modularObjects[i].location.y) / bossSpeed/1.10) * (pow(1.584893192, bossSpeed)) * delta;
        
    }
}

- (void)hitModule:(int)module withDamage:(int)damage {
    //modularObjects[module].moduleHealth -= damage;
    
    //[super hitModule:module withDamage:damage];
}

- (void)render {
    for(int i = 0; i < numberOfModules; i++) {
        if (modularObjects[i].isDead == NO) {
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

- (void)dealloc {
    [super dealloc];
}

@end
