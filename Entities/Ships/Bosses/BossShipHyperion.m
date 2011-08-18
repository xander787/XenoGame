//
//  BossShipHyperion.m
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

#import "BossShipHyperion.h"
#import "BossShip.h"


@implementation BossShipHyperion

- (id)initWithLocation:(CGPoint)aPoint andPlayershipRef:(PlayerShip *)playerRef {
    if((self = [super initWithBossID:kBoss_Hyperion initialLocation:aPoint andPlayerShipRef:playerRef])) {
        mainBody = &self.modularObjects[0];
        wingRight = &self.modularObjects[1];
        wingLeft = &self.modularObjects[2];
        
        state = -1;
    }
    return self;
}

- (void)update:(GLfloat)delta {
    [super update:delta];
    
    if (state == -1) {
        currentLocation.x += ((desiredLocation.x - currentLocation.x) / bossSpeed) * (pow(1.584893192, bossSpeed)) * delta;
        currentLocation.y += ((desiredLocation.y - currentLocation.y) / bossSpeed) * (pow(1.584893192, bossSpeed)) * delta;
    }
    else if(state == kHyperionState_StageOne) {
        currentLocation.x += ((desiredLocation.x - currentLocation.x) / bossSpeed) * (pow(1.584893192, bossSpeed/2)) * delta;
        currentLocation.y += ((desiredLocation.y - currentLocation.y) / bossSpeed) * (pow(1.584893192, bossSpeed/2)) * delta;
    }
    else if(state == kHyperionState_StageTwo) { 
        currentLocation.x += ((desiredLocation.x - currentLocation.x) / bossSpeed) * (pow(1.584893192, bossSpeed/1.25)) * delta;
        currentLocation.y += ((desiredLocation.y - currentLocation.y) / bossSpeed) * (pow(1.584893192, bossSpeed/1.25)) * delta;
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
            state = kHyperionState_StageOne;
            mainBodyRightProjectile = [[BulletProjectile alloc] initWithProjectileID:kEnemyProjectile_BulletLevelTwo_Double location:Vector2fMake(currentLocation.x + mainBody->weapons[1].weaponCoord.x, currentLocation.y + mainBody->weapons[1].weaponCoord.y) andAngle:-90.0f];
            
            mainBodyLeftProjectile = [[BulletProjectile alloc] initWithProjectileID:kEnemyProjectile_BulletLevelTwo_Double location:Vector2fMake(currentLocation.x + mainBody->weapons[2].weaponCoord.x, currentLocation.y + mainBody->weapons[2].weaponCoord.y) andAngle:-90.0f];
        }
        
        if (state == kHyperionState_StageOne) {
            bossRotationTimer += delta;
            
            [mainBodyLeftProjectile update:delta];
            [mainBodyRightProjectile update:delta];
            [mainBodyCenterProjectile update:delta];
            
            if (!bossRotated) {
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
            }
                        
            if (bossRotationTimer > 15.0f && bossReRotationTimer < 15.0f) {
                bossReRotationTimer += delta;
                bossRotated = YES;
                
                for(int i = 0; i < numberOfModules; i++){
                    if ((int)modularObjects[i].rotation != 180) {
                        modularObjects[i].rotation += 0.5;
                    }
                    else if(modularObjects[i].rotation == 180.0f) {
                        for(int k = 0; k < [modularObjects[i].collisionPolygonArray count]; k++){
                            for(int j = 0; j < [[modularObjects[i].collisionPolygonArray objectAtIndex:k] pointCount]; j++){
                                Vector2f tempPoint = [[modularObjects[i].collisionPolygonArray objectAtIndex:k] originalPoints][j];
                                double tempAngle = DEGREES_TO_RADIANS(180);
                                [[modularObjects[i].collisionPolygonArray objectAtIndex:k] originalPoints][j] = Vector2fMake((tempPoint.x * cos(tempAngle)) - (tempPoint.y * sin(tempAngle)), (tempPoint.x * sin(tempAngle)) + (tempPoint.y * cos(tempAngle)));
                            }
                            [[modularObjects[i].collisionPolygonArray objectAtIndex:k] buildEdges];
                        }
                        modularObjects[i].rotation = 180.1f;
                    }
                }
            }
            else if(bossReRotationTimer > 15.0f) {                
                for(int i = 0; i < numberOfModules; i++){
                    if (modularObjects[i].rotation != 0.0f) {
                        modularObjects[i].rotation -= 0.5;
                    }
                }
                
                int numRotatedAlready = 0;
                for(int i = 0; i < numberOfModules; i++){
                    if ((int)modularObjects[i].rotation == 0 && modularObjects[i].rotation > 0.0f) {
                        for(int k = 0; k < [modularObjects[i].collisionPolygonArray count]; k++){
                            for(int j = 0; j < [[modularObjects[i].collisionPolygonArray objectAtIndex:k] pointCount]; j++){
                                Vector2f tempPoint = [[modularObjects[i].collisionPolygonArray objectAtIndex:k] originalPoints][j];
                                double tempAngle = DEGREES_TO_RADIANS(-180);
                                [[modularObjects[i].collisionPolygonArray objectAtIndex:k] originalPoints][j] = Vector2fMake((tempPoint.x * cos(tempAngle)) - (tempPoint.y * sin(tempAngle)), (tempPoint.x * sin(tempAngle)) + (tempPoint.y * cos(tempAngle)));
                            }
                            [[modularObjects[i].collisionPolygonArray objectAtIndex:k] buildEdges];
                        }
                        modularObjects[i].rotation = 0.0f;
                        numRotatedAlready++;
                    }
                }
                
                if (numRotatedAlready == 3) {
                    bossRotationTimer = 0.0f;
                    bossReRotationTimer = 0.0f;
                    bossRotated = NO;
                }
            }
            
            if ((self.shipHealth / self.shipMaxHealth) <= 0.50f) {
                holdingTimer = 0.0f;
                state = kHyperionState_StageTwo;
            }
        }
        
        if (state == kHyperionState_StageTwo) {            
            holdingTimer += delta;
            
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
        }
    }
}

- (void)hitModule:(int)module withDamage:(int)damage {
    modularObjects[module].moduleHealth -= damage;
    
//    if (modularObjects[module].moduleHealth <= 0) {
//        self.shipHealth = 5;
//    }
    
    [super hitModule:module withDamage:damage];
}

- (void)render {
    for(int i = 0; i < numberOfModules; i++) {
        if (modularObjects[i].isDead == NO) {
            [modularObjects[i].moduleImage setRotation:modularObjects[i].rotation];
            [modularObjects[i].moduleImage renderAtPoint:CGPointMake(currentLocation.x + modularObjects[i].location.x, currentLocation.y + modularObjects[i].location.y) centerOfImage:YES];
        }
    }
    
    [mainBodyLeftProjectile render];
    [mainBodyRightProjectile render];
    [mainBodyCenterProjectile render];
    
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
