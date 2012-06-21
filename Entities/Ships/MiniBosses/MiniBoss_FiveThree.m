//
//  MiniBossFiveThree.m
//  Xenophobe
//
//  Created by James Linnell on 6/18/12.
//  Copyright 2012 PDHS. All rights reserved.
//

#import "MiniBoss_FiveThree.h"

@implementation MiniBoss_FiveThree

- (id)initWithLocation:(CGPoint)aPoint andPlayerShipRef:(PlayerShip *)playerRef {
    self = [super initWithBossID:kMiniBoss_FiveThree initialLocation:aPoint andPlayerShipRef:playerRef];
    if (self) {
        // Initialization code here.
        
        //Always start the state correctly
        state = kFiveThree_Entry;
        
        //Init the Death Animation and all the weapons, along with putting the weapons in the array
        deathAnimation = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
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
        
        
        bulletCenter = [[BulletProjectile alloc] initWithProjectileID:kEnemyProjectile_BulletLevelOne_Single location:Vector2fZero andAngle:-90.0f];
        
        projectilesArray = [[NSMutableArray alloc] initWithObjects:bulletCenter, nil];
        
        front = &self.modularObjects[0];
        bodyOne = &self.modularObjects[1];
        bodyTwo = &self.modularObjects[2];
        bodyThree = &self.modularObjects[3];
        back = &self.modularObjects[4];
        
        orbFrontVBodyOne = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
                                                                             position:Vector2fMake(currentLocation.x + 105, 0)
                                                               sourcePositionVariance:Vector2fMake(0,0)
                                                                                speed:0.01f
                                                                        speedVariance:0.0f
                                                                     particleLifeSpan:0.1f
                                                             particleLifespanVariance:0.2f
                                                                                angle:360.0f
                                                                        angleVariance:0
                                                                              gravity:Vector2fMake(0.0f, 0.0f)
                                                                           startColor:Color4fMake(0.3f, 1.0f, 0.66f, 1.0f)
                                                                   startColorVariance:Color4fMake(0.0f, 0.2f, 0.2f, 0.5f)
                                                                          finishColor:Color4fMake(0.16f, 0.0f, 0.0f, 1.0f)
                                                                  finishColorVariance:Color4fMake(0.0f, 0.0f, 0.0f, 1.0f)
                                                                         maxParticles:25
                                                                         particleSize:20
                                                                   finishParticleSize:20
                                                                 particleSizeVariance:2
                                                                             duration:-1
                                                                        blendAdditive:YES];
        orbBodyOneVBodyTwo = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
                                                                               position:Vector2fMake(currentLocation.x + 105, 0)
                                                                 sourcePositionVariance:Vector2fMake(0,0)
                                                                                  speed:0.01f
                                                                          speedVariance:0.0f
                                                                       particleLifeSpan:0.1f
                                                               particleLifespanVariance:0.2f
                                                                                  angle:360.0f
                                                                          angleVariance:0
                                                                                gravity:Vector2fMake(0.0f, 0.0f)
                                                                             startColor:Color4fMake(0.3f, 1.0f, 0.66f, 1.0f)
                                                                     startColorVariance:Color4fMake(0.0f, 0.2f, 0.2f, 0.5f)
                                                                            finishColor:Color4fMake(0.16f, 0.0f, 0.0f, 1.0f)
                                                                    finishColorVariance:Color4fMake(0.0f, 0.0f, 0.0f, 1.0f)
                                                                           maxParticles:25
                                                                           particleSize:20
                                                                     finishParticleSize:20
                                                                   particleSizeVariance:2
                                                                               duration:-1
                                                                          blendAdditive:YES];
        orbBodyTwoVBodyThree = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
                                                                                 position:Vector2fMake(currentLocation.x + 105, 0)
                                                                   sourcePositionVariance:Vector2fMake(0,0)
                                                                                    speed:0.01f
                                                                            speedVariance:0.0f
                                                                         particleLifeSpan:0.1f
                                                                 particleLifespanVariance:0.2f
                                                                                    angle:360.0f
                                                                            angleVariance:0
                                                                                  gravity:Vector2fMake(0.0f, 0.0f)
                                                                               startColor:Color4fMake(0.3f, 1.0f, 0.66f, 1.0f)
                                                                       startColorVariance:Color4fMake(0.0f, 0.2f, 0.2f, 0.5f)
                                                                              finishColor:Color4fMake(0.16f, 0.0f, 0.0f, 1.0f)
                                                                      finishColorVariance:Color4fMake(0.0f, 0.0f, 0.0f, 1.0f)
                                                                             maxParticles:25
                                                                             particleSize:20
                                                                       finishParticleSize:20
                                                                     particleSizeVariance:2
                                                                                 duration:-1
                                                                            blendAdditive:YES];

        orbBodyThreeVBack = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
                                                                             position:Vector2fMake(currentLocation.x + 105, 0)
                                                               sourcePositionVariance:Vector2fMake(0,0)
                                                                                speed:0.01f
                                                                        speedVariance:0.0f
                                                                     particleLifeSpan:0.1f
                                                             particleLifespanVariance:0.2f
                                                                                angle:360.0f
                                                                        angleVariance:0
                                                                              gravity:Vector2fMake(0.0f, 0.0f)
                                                                           startColor:Color4fMake(0.3f, 1.0f, 0.66f, 1.0f)
                                                                   startColorVariance:Color4fMake(0.0f, 0.2f, 0.2f, 0.5f)
                                                                          finishColor:Color4fMake(0.16f, 0.0f, 0.0f, 1.0f)
                                                                  finishColorVariance:Color4fMake(0.0f, 0.0f, 0.0f, 1.0f)
                                                                         maxParticles:25
                                                                         particleSize:20
                                                                   finishParticleSize:20
                                                                 particleSizeVariance:2
                                                                             duration:-1
                                                                        blendAdditive:YES];
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
    
    [deathAnimation setSourcePosition:Vector2fMake(currentLocation.x, currentLocation.y)];
    
    if(shipIsDeployed){
        [bulletCenter setLocation:Vector2fMake(currentLocation.x + modularObjects[0].weapons[0].weaponCoord.x, currentLocation.y + modularObjects[0].weapons[0].weaponCoord.y)];
        
        [bulletCenter update:delta];
    }
    
    if(shipIsDead == NO){
        //Orbs
        [orbFrontVBodyOne setSourcePosition:Vector2fMake(currentLocation.x, currentLocation.y + 25)];
        [orbBodyOneVBodyTwo setSourcePosition:Vector2fMake(currentLocation.x, currentLocation.y + 93)];
        [orbBodyTwoVBodyThree setSourcePosition:Vector2fMake(currentLocation.x, currentLocation.y + 148)];
        [orbBodyThreeVBack setSourcePosition:Vector2fMake(currentLocation.x, currentLocation.y + 213)];
        
        [orbFrontVBodyOne update:delta];
        [orbBodyOneVBodyTwo update:delta];
        [orbBodyTwoVBodyThree update:delta];
        [orbBodyThreeVBack update:delta];
        
        //Rotations
        GLfloat rotatingSpeed = 45 * delta;
        
        /*GLfloat oldRot = bodyOne->rotation;
        bodyOne->rotation += rotatingSpeed;
        bodyOne->location = [self rotatePoint:bodyOne->location aroundPoint:Vector2fMake(orbFrontVBodyOne.sourcePosition.x - currentLocation.x, orbFrontVBodyOne.sourcePosition.y - currentLocation.y) withAngle:oldRot - bodyOne->rotation];
        [self syncBodyOneCollisionPolygon:oldRot];*/
        
        
        if(rotatingState == kRotating_StepOneForward){
            
            //Rotate
            GLfloat oldBodyOneRotation = bodyOne->rotation;
            GLfloat oldBodyTwoRotation = bodyTwo->rotation;
            GLfloat oldBodyThreeRotation = bodyThree->rotation;
            GLfloat oldTailRotation = back->rotation;
            if(bodyOne->rotation < SEGMENT_ROTATION){
                bodyOne->rotation += rotatingSpeed;
                bodyTwo->rotation -= rotatingSpeed;
                bodyThree->rotation += rotatingSpeed;
                back->rotation -= rotatingSpeed;
            }
            else {
                bodyOne->rotation = SEGMENT_ROTATION;
                bodyTwo->rotation = -SEGMENT_ROTATION;
                bodyThree->rotation = SEGMENT_ROTATION;
                back->rotation = -SEGMENT_ROTATION;
                
                rotatingState = kRotating_StepOneReturn;
                NSLog(@"State: %d", rotatingState);
            }
            bodyOne->location = [self rotatePoint:bodyOne->location aroundPoint:Vector2fMake(orbFrontVBodyOne.sourcePosition.x - currentLocation.x, orbFrontVBodyOne.sourcePosition.y - currentLocation.y) withAngle:oldBodyOneRotation - bodyOne->rotation];
            bodyTwo->location = [self rotatePoint:bodyTwo->location aroundPoint:Vector2fMake(orbBodyOneVBodyTwo.sourcePosition.x - currentLocation.x, orbBodyOneVBodyTwo.sourcePosition.y - currentLocation.y) withAngle:oldBodyTwoRotation - bodyTwo->rotation];
            bodyThree->location = [self rotatePoint:bodyThree->location aroundPoint:Vector2fMake(orbBodyTwoVBodyThree.sourcePosition.x - currentLocation.x, orbBodyTwoVBodyThree.sourcePosition.y - currentLocation.y) withAngle:oldBodyThreeRotation - bodyThree->rotation];
            back->location = [self rotatePoint:back->location aroundPoint:Vector2fMake(orbBodyThreeVBack.sourcePosition.x - currentLocation.x, orbBodyThreeVBack.sourcePosition.y - currentLocation.y) withAngle:oldTailRotation - back->rotation];
            
            [self syncBodyOneCollisionPolygon:oldBodyOneRotation];
            [self syncBodyTwoCollisionPolygon:oldBodyTwoRotation];
            [self syncBodyThreeCollisionPolygon:oldBodyThreeRotation];
            [self syncBackCollisionPolygon:oldTailRotation];
            
        }
        else if(rotatingState == kRotating_StepOneReturn){

            //Rotate
            GLfloat oldBodyOneRotation = bodyOne->rotation;
            GLfloat oldBodyTwoRotation = bodyTwo->rotation;
            GLfloat oldBodyThreeRotation = bodyThree->rotation;
            GLfloat oldTailRotation = back->rotation;
            if(bodyOne->rotation > 0){
                bodyOne->rotation -= rotatingSpeed;
                bodyTwo->rotation += rotatingSpeed;
                bodyThree->rotation -= rotatingSpeed;
                back->rotation += rotatingSpeed;
            }
            else {
                bodyOne->rotation = 0;
                bodyTwo->rotation = 0;
                bodyThree->rotation = 0;
                back->rotation = 0;
                
                //When they go back to a rotation of 0 degrees, they'll be back in
                //their normal positions, but because of roudning errors they move
                //slightly inwards. This resets them back to their default positions
                //to cancel that effect.
                bodyOne->location = bodyOne->defaultLocation;
                bodyTwo->location = bodyTwo->defaultLocation;
                bodyThree->location = bodyThree->defaultLocation;
                back->location = back->defaultLocation;
                
                rotatingState = kRotating_StepTwoForward;
                NSLog(@"State: %d", rotatingState);
            }
            bodyOne->location = [self rotatePoint:bodyOne->location aroundPoint:Vector2fMake(orbFrontVBodyOne.sourcePosition.x - currentLocation.x, orbFrontVBodyOne.sourcePosition.y - currentLocation.y) withAngle:oldBodyOneRotation - bodyOne->rotation];
            bodyTwo->location = [self rotatePoint:bodyTwo->location aroundPoint:Vector2fMake(orbBodyOneVBodyTwo.sourcePosition.x - currentLocation.x, orbBodyOneVBodyTwo.sourcePosition.y - currentLocation.y) withAngle:oldBodyTwoRotation - bodyTwo->rotation];
            bodyThree->location = [self rotatePoint:bodyThree->location aroundPoint:Vector2fMake(orbBodyTwoVBodyThree.sourcePosition.x - currentLocation.x, orbBodyTwoVBodyThree.sourcePosition.y - currentLocation.y) withAngle:oldBodyThreeRotation - bodyThree->rotation];
            back->location = [self rotatePoint:back->location aroundPoint:Vector2fMake(orbBodyThreeVBack.sourcePosition.x - currentLocation.x, orbBodyThreeVBack.sourcePosition.y - currentLocation.y) withAngle:oldTailRotation - back->rotation];
            
            [self syncBodyOneCollisionPolygon:oldBodyOneRotation];
            [self syncBodyTwoCollisionPolygon:oldBodyTwoRotation];
            [self syncBodyThreeCollisionPolygon:oldBodyThreeRotation];
            [self syncBackCollisionPolygon:oldTailRotation];
        }
        else if(rotatingState == kRotating_StepTwoForward){
            
            //Rotate
            GLfloat oldBodyOneRotation = bodyOne->rotation;
            GLfloat oldBodyTwoRotation = bodyTwo->rotation;
            GLfloat oldBodyThreeRotation = bodyThree->rotation;
            GLfloat oldTailRotation = back->rotation;
            if(bodyOne->rotation > -SEGMENT_ROTATION){
                bodyOne->rotation -= rotatingSpeed;
                bodyTwo->rotation += rotatingSpeed;
                bodyThree->rotation -= rotatingSpeed;
                back->rotation += rotatingSpeed;
            }
            else {
                bodyOne->rotation = -SEGMENT_ROTATION;
                bodyTwo->rotation = SEGMENT_ROTATION;
                bodyThree->rotation = -SEGMENT_ROTATION;
                back->rotation = SEGMENT_ROTATION;
                
                rotatingState = kRotating_StepTwoReturn;
                NSLog(@"State: %d", rotatingState);
            }
            bodyOne->location = [self rotatePoint:bodyOne->location aroundPoint:Vector2fMake(orbFrontVBodyOne.sourcePosition.x - currentLocation.x, orbFrontVBodyOne.sourcePosition.y - currentLocation.y) withAngle:oldBodyOneRotation - bodyOne->rotation];
            bodyTwo->location = [self rotatePoint:bodyTwo->location aroundPoint:Vector2fMake(orbBodyOneVBodyTwo.sourcePosition.x - currentLocation.x, orbBodyOneVBodyTwo.sourcePosition.y - currentLocation.y) withAngle:oldBodyTwoRotation - bodyTwo->rotation];
            bodyThree->location = [self rotatePoint:bodyThree->location aroundPoint:Vector2fMake(orbBodyTwoVBodyThree.sourcePosition.x - currentLocation.x, orbBodyTwoVBodyThree.sourcePosition.y - currentLocation.y) withAngle:oldBodyThreeRotation - bodyThree->rotation];
            back->location = [self rotatePoint:back->location aroundPoint:Vector2fMake(orbBodyThreeVBack.sourcePosition.x - currentLocation.x, orbBodyThreeVBack.sourcePosition.y - currentLocation.y) withAngle:oldTailRotation - back->rotation];
            
            [self syncBodyOneCollisionPolygon:oldBodyOneRotation];
            [self syncBodyTwoCollisionPolygon:oldBodyTwoRotation];
            [self syncBodyThreeCollisionPolygon:oldBodyThreeRotation];
            [self syncBackCollisionPolygon:oldTailRotation];
        }
        else if(rotatingState == kRotating_StepTwoReturn){
            //Rotate
            GLfloat oldBodyOneRotation = bodyOne->rotation;
            GLfloat oldBodyTwoRotation = bodyTwo->rotation;
            GLfloat oldBodyThreeRotation = bodyThree->rotation;
            GLfloat oldTailRotation = back->rotation;
            if(bodyOne->rotation < 0){
                bodyOne->rotation += rotatingSpeed;
                bodyTwo->rotation -= rotatingSpeed;
                bodyThree->rotation += rotatingSpeed;
                back->rotation -= rotatingSpeed;
            }
            else {
                bodyOne->rotation = 0;
                bodyTwo->rotation = 0;
                bodyThree->rotation = 0;
                back->rotation = 0;
                
                //When they go back to a rotation of 0 degrees, they'll be back in
                //their normal positions, but because of roudning errors they move
                //slightly inwards. This resets them back to their default positions
                //to cancel that effect.
                bodyOne->location = bodyOne->defaultLocation;
                bodyTwo->location = bodyTwo->defaultLocation;
                bodyThree->location = bodyThree->defaultLocation;
                back->location = back->defaultLocation;
                
                rotatingState = kRotating_StepOneForward;
                NSLog(@"State: %d", rotatingState);
            }
            bodyOne->location = [self rotatePoint:bodyOne->location aroundPoint:Vector2fMake(orbFrontVBodyOne.sourcePosition.x - currentLocation.x, orbFrontVBodyOne.sourcePosition.y - currentLocation.y) withAngle:oldBodyOneRotation - bodyOne->rotation];
            bodyTwo->location = [self rotatePoint:bodyTwo->location aroundPoint:Vector2fMake(orbBodyOneVBodyTwo.sourcePosition.x - currentLocation.x, orbBodyOneVBodyTwo.sourcePosition.y - currentLocation.y) withAngle:oldBodyTwoRotation - bodyTwo->rotation];
            bodyThree->location = [self rotatePoint:bodyThree->location aroundPoint:Vector2fMake(orbBodyTwoVBodyThree.sourcePosition.x - currentLocation.x, orbBodyTwoVBodyThree.sourcePosition.y - currentLocation.y) withAngle:oldBodyThreeRotation - bodyThree->rotation];
            back->location = [self rotatePoint:back->location aroundPoint:Vector2fMake(orbBodyThreeVBack.sourcePosition.x - currentLocation.x, orbBodyThreeVBack.sourcePosition.y - currentLocation.y) withAngle:oldTailRotation - back->rotation];
            
            [self syncBodyOneCollisionPolygon:oldBodyOneRotation];
            [self syncBodyTwoCollisionPolygon:oldBodyTwoRotation];
            [self syncBodyThreeCollisionPolygon:oldBodyThreeRotation];
            [self syncBackCollisionPolygon:oldTailRotation];
        }
        
    }
    //End
    
    //This starts with handling all of the different states, just if-statements
    if(state == kFiveThree_Entry){
        //Typical among most MiniBosses
        if(shipIsDeployed){
            state = kFiveThree_Holding;
        }
    }
    else if(state == kFiveThree_Holding){
        //Deals with the floating when the ship is holding, and handles the times for the attacks.
        //This can be more flexible for different ships with different modules and floating variations
        holdingTimer += delta;
        attackTimer += delta;
        
        /*
        if(holdingTimer >= 1.2){
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
        */
         
        if(attackTimer >= 6){
            state = kFiveThree_Attacking;
            attackTimer = 0;
            holdingTimer = 0;
        }
        if(modularObjects[0].isDead){
            state = kFiveThree_Death;
        }
    }
    else if(state == kFiveThree_Attacking){
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
            state = kFiveThree_Holding;
            attackPathtimer = 0;
            [attackingPath release];
            attackingPath = nil;
        }if(modularObjects[0].isDead){
            state = kFiveThree_Death;
        }
    }
    if(state == kFiveThree_Death){
        //Again, typical death code, animations, stopping weapons, etc
        [bulletCenter stopProjectile];
        
        
        [deathAnimation update:delta];
        modularObjects[0].isDead = NO;
        if(deathAnimation.particleCount == 0){
            modularObjects[0].isDead = YES;
        }
    }
}

//Important to help with collision detection and dealing damage in the GameLevelScene
- (void)hitModule:(int)module withDamage:(int)damage {
    modularObjects[module].moduleHealth -= damage;
    [super hitModule:module withDamage:damage];
    
    shipHealth = modularObjects[0].moduleHealth;
    shipMaxHealth = modularObjects[0].moduleMaxHealth;
    NSLog(@"%d / %d", shipHealth, shipMaxHealth);
}

- (Vector2f)rotatePoint:(Vector2f)initialPoint aroundPoint:(Vector2f)axisPoint withAngle:(GLfloat)angle {
    
    initialPoint.x -= axisPoint.x;
    initialPoint.y -= axisPoint.y;
    
    double radianAngle = DEGREES_TO_RADIANS(angle);
    initialPoint.x = (initialPoint.x * cos(radianAngle)) - (initialPoint.y * sin(radianAngle)); 
    initialPoint.y = (initialPoint.x * sin(radianAngle)) + (initialPoint.y * cos(radianAngle));
    
    initialPoint.x += axisPoint.x;
    initialPoint.y += axisPoint.y;
    
    return initialPoint;
}

- (void)syncBodyOneCollisionPolygon:(GLfloat)oldRotation {
    //Rotate Body One
    for(int i = 0; i < [[bodyOne->collisionPolygonArray objectAtIndex:0] pointCount]; i++){
        Vector2f tempPoint = [[bodyOne->collisionPolygonArray objectAtIndex:0] originalPoints][i];
        double tempAngle = DEGREES_TO_RADIANS(oldRotation - bodyOne->rotation);
        [[bodyOne->collisionPolygonArray objectAtIndex:0] originalPoints][i] = Vector2fMake((tempPoint.x * cos(tempAngle)) - (tempPoint.y * sin(tempAngle)), (tempPoint.x * sin(tempAngle)) + (tempPoint.y * cos(tempAngle)));
    }
    [[bodyOne->collisionPolygonArray objectAtIndex:0] buildEdges];
}

- (void)syncBodyTwoCollisionPolygon:(GLfloat)oldRotation {
    //Rotate Body Two
    for(int i = 0; i < [[bodyTwo->collisionPolygonArray objectAtIndex:0] pointCount]; i++){
        Vector2f tempPoint = [[bodyTwo->collisionPolygonArray objectAtIndex:0] originalPoints][i];
        double tempAngle = DEGREES_TO_RADIANS(oldRotation - bodyTwo->rotation);
        [[bodyTwo->collisionPolygonArray objectAtIndex:0] originalPoints][i] = Vector2fMake((tempPoint.x * cos(tempAngle)) - (tempPoint.y * sin(tempAngle)), (tempPoint.x * sin(tempAngle)) + (tempPoint.y * cos(tempAngle)));
    }
    [[bodyTwo->collisionPolygonArray objectAtIndex:0] buildEdges];
}

- (void)syncBodyThreeCollisionPolygon:(GLfloat)oldRotation {
    //Rotate Body Three
    for(int i = 0; i < [[bodyThree->collisionPolygonArray objectAtIndex:0] pointCount]; i++){
        Vector2f tempPoint = [[bodyThree->collisionPolygonArray objectAtIndex:0] originalPoints][i];
        double tempAngle = DEGREES_TO_RADIANS(oldRotation - bodyThree->rotation);
        [[bodyThree->collisionPolygonArray objectAtIndex:0] originalPoints][i] = Vector2fMake((tempPoint.x * cos(tempAngle)) - (tempPoint.y * sin(tempAngle)), (tempPoint.x * sin(tempAngle)) + (tempPoint.y * cos(tempAngle)));
    }
    [[bodyThree->collisionPolygonArray objectAtIndex:0] buildEdges];
}

- (void)syncBackCollisionPolygon:(GLfloat)oldRotation {
    //Rotate Tail
    for(int i = 0; i < [[back->collisionPolygonArray objectAtIndex:0] pointCount]; i++){
        Vector2f tempPoint = [[back->collisionPolygonArray objectAtIndex:0] originalPoints][i];
        double tempAngle = DEGREES_TO_RADIANS(oldRotation - back->rotation);
        [[back->collisionPolygonArray objectAtIndex:0] originalPoints][i] = Vector2fMake((tempPoint.x * cos(tempAngle)) - (tempPoint.y * sin(tempAngle)), (tempPoint.x * sin(tempAngle)) + (tempPoint.y * cos(tempAngle)));
    }
    [[back->collisionPolygonArray objectAtIndex:0] buildEdges];
}

- (void)render {
    [bulletCenter render];
    [orbFrontVBodyOne renderParticles];
    [orbBodyOneVBodyTwo renderParticles];
    [orbBodyTwoVBodyThree renderParticles];
    [orbBodyThreeVBack renderParticles];
    
    if(state == kFiveThree_Death){
        [deathAnimation renderParticles];
    }
    
    for(int i = 0; i < numberOfModules; i++) {
        if(i != 0){
            if (!modularObjects[i].isDead) {
                [modularObjects[i].moduleImage setRotation:modularObjects[i].rotation];
                [modularObjects[i].moduleImage renderAtPoint:CGPointMake(currentLocation.x + modularObjects[i].location.x, currentLocation.y + modularObjects[i].location.y) centerOfImage:YES];
            }
        }
        else if(state != kFiveThree_Death){
            [modularObjects[0].moduleImage setRotation:modularObjects[i].rotation];
            [modularObjects[0].moduleImage renderAtPoint:CGPointMake(currentLocation.x + modularObjects[i].location.x, currentLocation.y + modularObjects[i].location.y) centerOfImage:YES];
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
