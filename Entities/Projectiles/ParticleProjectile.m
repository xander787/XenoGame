//
//  ParticleProjectile.m
//  Xenophobe
//
//  Created by James Linnell on 8/5/11.
//  Copyright 2011 PDHS. All rights reserved.
//

#import "ParticleProjectile.h"

@implementation ParticleProjectile

- (id)initWithProjectileID:(ProjectileID)aProjID location:(Vector2f)aLocation angle:(GLfloat)aAngle radius:(float)aRadius andFireRate:(GLfloat)aRate;
{
    self = [super initWithProjectileID:aProjID location:aLocation andAngle:aAngle];
    if (self) {
        
        radius = aRadius;
        angle = aAngle;
        rate = aRate;
        elapsedTime = rate;
        speed = (1 / rate) + 1;
        
        //Loop through the collision points, put them in a C array
        collisionPointCount = 4;
        collisionPoints = malloc(sizeof(Vector2f) * collisionPointCount);
        bzero(collisionPoints, sizeof(Vector2f) * collisionPointCount);
        collisionPoints[0] = Vector2fMake(0, radius);
        collisionPoints[1] = Vector2fMake(radius, 0);
        collisionPoints[2] = Vector2fMake(0, -radius);
        collisionPoints[3] = Vector2fMake(-radius, 0);
        
        
        switch (projectileID) {
            case kEnemyParticle_Single:
            case kPlayerParticle_Single:{
                ParticleEmitter *tempEmitter = [self newParticleEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                
                NSArray *tempArray = [self newArrayWithPolygon];
                [polygons addObject:tempArray];
                [tempArray release];
                break;
            }
                
            case kEnemyParticle_Double:
            case kPlayerParticle_Double:{
                ParticleEmitter *tempEmitter = [self newParticleEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                tempEmitter = [self newParticleEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                
                [[emitters objectAtIndex:0] setAngle:angle + 15];
                [[emitters objectAtIndex:1] setAngle:angle - 15];
                
                NSArray *tempArray = [self newArrayWithPolygon];
                [polygons addObject:tempArray];
                [tempArray release];
                tempArray = [self newArrayWithPolygon];
                [polygons addObject:tempArray];
                [tempArray release];
                break;
            }
                
            case kEnemyParticle_Triple:
            case kPlayerParticle_Triple:{
                ParticleEmitter *tempEmitter = [self newParticleEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                tempEmitter = [self newParticleEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                tempEmitter = [self newParticleEmitter];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                
                [[emitters objectAtIndex:0] setAngle:angle + 15];
                [[emitters objectAtIndex:2] setAngle:angle - 15];
                
                NSArray *tempArray = [self newArrayWithPolygon];
                [polygons addObject:tempArray];
                [tempArray release];
                tempArray = [self newArrayWithPolygon];
                [polygons addObject:tempArray];
                [tempArray release];
                tempArray = [self newArrayWithPolygon];
                [polygons addObject:tempArray];
                [tempArray release];
                break;
            }
                
            default:
                if([emitters count] != [polygons count]){
                    NSLog(@"ERROR::: Emitters count does not equal polygons count!");
                }
                break;
        }
    }
    
    return self;
}

- (void)update:(GLfloat)aDelta {
    [super update:aDelta];
    
    for (int emitterPolyCount = 0; emitterPolyCount < [emitters count]; emitterPolyCount++){
        [[emitters objectAtIndex:emitterPolyCount] update:aDelta];
        
        [[[polygons objectAtIndex:emitterPolyCount] objectAtIndex:0] setPos:CGPointMake([[emitters objectAtIndex:emitterPolyCount] sourcePosition].x, 
                                                                                        [[emitters objectAtIndex:emitterPolyCount] sourcePosition].y)];
        
        
        Vector2f tempPos = [[emitters objectAtIndex:emitterPolyCount] sourcePosition];
        if(emitterPolyCount == 0){
            tempPos.x += (speed * 100) * aDelta * particleVector0.x;
            tempPos.y += (speed * 100) * aDelta * particleVector0.y;
        }
        else if(emitterPolyCount == 1){
            tempPos.x += (speed * 100) * aDelta * particleVector1.x;
            tempPos.y += (speed * 100) * aDelta * particleVector1.y;
        }
        else if(emitterPolyCount == 2){
            tempPos.x += (speed * 100) * aDelta * particleVector2.x;
            tempPos.y += (speed * 100) * aDelta * particleVector2.y;
        }
        [[emitters objectAtIndex:emitterPolyCount] setSourcePosition:tempPos];
    }
    
    //Re-initialize our emitter
    if(elapsedTime >= rate && !isStopped){
        elapsedTime = 0;
        
        for (int emitterPolyCount = 0; emitterPolyCount < [emitters count]; emitterPolyCount++){
            [[emitters objectAtIndex:emitterPolyCount] setSourcePosition:location];
            
            switch(projectileID){
                case kEnemyParticle_Single:
                case kPlayerParticle_Single:{
                    [[emitters objectAtIndex:emitterPolyCount] setAngle:angle];
                    break;
                }
                
                case kEnemyParticle_Double:
                case kPlayerParticle_Double:{
                    if(emitterPolyCount == 0){
                        [[emitters objectAtIndex:emitterPolyCount] setAngle:angle + 15];
                    }
                    else if(emitterPolyCount == 1){
                        [[emitters objectAtIndex:emitterPolyCount] setAngle:angle - 15];
                    }
                    break;
                }
                
                case kEnemyParticle_Triple:
                case kPlayerParticle_Triple:{
                    if(emitterPolyCount == 0){
                        [[emitters objectAtIndex:emitterPolyCount] setAngle:angle - 15];
                    }
                    else if(emitterPolyCount == 1){
                        [[emitters objectAtIndex:emitterPolyCount] setAngle:angle];
                    }
                    else if(emitterPolyCount == 2){
                        [[emitters objectAtIndex:emitterPolyCount] setAngle:angle + 15];
                    }
                    break;
                }
                
                default:
                    break;
            }
            
            GLfloat particleAngle = DEGREES_TO_RADIANS([[emitters objectAtIndex:emitterPolyCount] angle]);
            if(emitterPolyCount == 0){
                particleVector0 = CGPointMake(cosf(particleAngle), sinf(particleAngle));
            }
            else if(emitterPolyCount == 1){
                particleVector1 = CGPointMake(cosf(particleAngle), sinf(particleAngle));
            }
            else if(emitterPolyCount == 2){
                particleVector2 = CGPointMake(cosf(particleAngle), sinf(particleAngle));
            }
            
            
        }
    }
}

- (ParticleEmitter *)newParticleEmitter {
    ParticleEmitter *baseEmitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
                                                                                     position:location
                                                                       sourcePositionVariance:Vector2fZero
                                                                                        speed:speed/1.5
                                                                                speedVariance:0.0
                                                                             particleLifeSpan:0.2
                                                                     particleLifespanVariance:0.1
                                                                                        angle:angle
                                                                                angleVariance:0.0
                                                                                      gravity:Vector2fZero
                                                                                   startColor:Color4fMake(0.12, 0.25, 0.75, 1.0)
                                                                           startColorVariance:Color4fMake(0.0, 0.0, 0.0, 0.0)
                                                                                  finishColor:Color4fMake(0.1, 0.1, 0.5, 1.0)
                                                                          finishColorVariance:Color4fMake(0.05, 0.05, 0.3, 0.0)
                                                                                 maxParticles:40.0
                                                                                 particleSize:radius * 2
                                                                           finishParticleSize:radius * 2
                                                                         particleSizeVariance:0.0
                                                                                     duration:-1.0
                                                                                blendAdditive:YES];
    
    if(projectileID >= kEnemyParticle_Single && projectileID <= kEnemyParticle_Triple){
        [baseEmitter setStartColor:Color4fMake(0.75, 0.25, 0.12, 1.0)];
        [baseEmitter setFinishColor:Color4fMake(0.5, 0.1, 0.1, 1.0)];
        [baseEmitter setFinishColorVariance:Color4fMake(0.3, 0.05, 0.05, 0.0)];
    }
    return baseEmitter;
}

- (NSArray *)newArrayWithPolygon {
    NSMutableArray *firstArray = [[NSMutableArray alloc] init];
       
    Polygon *tempPoly = [[Polygon alloc] initWithPoints:collisionPoints andCount:collisionPointCount andShipPos:CGPointMake(location.x, location.y)];
    [firstArray addObject:tempPoly];
    [tempPoly release];
    
    NSArray *lastArray = [[NSArray alloc] initWithArray:firstArray];
    [firstArray release];
    return lastArray;
}

- (void)playProjectile {
    [super playProjectile];
}

- (void)pauseProjectile {
    [super pauseProjectile];
}

- (void)stopProjectile {
    [super stopProjectile];
}

- (void)render {
    for(ParticleEmitter *emitter in emitters){
        [emitter renderParticles];
    }
    
    if(DEBUG) {
        for(NSArray *polyArray in polygons){
            for(Polygon *polygon in polyArray){
                glPushMatrix();
                
                glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
                
                //Loop through the all the lines except for the last
                for(int i = 0; i < (polygon.pointCount - 1); i++) {
                    GLfloat line[] = {
                        polygon.points[i].x, polygon.points[i].y,
                        polygon.points[i+1].x, polygon.points[i+1].y,
                    };
                    
                    glVertexPointer(2, GL_FLOAT, 0, line);
                    glEnableClientState(GL_VERTEX_ARRAY);
                    glDrawArrays(GL_LINES, 0, 2);
                }
                
                
                //Renders last line, we do this because of how arrays work.
                GLfloat lineEnd[] = {
                    polygon.points[([polygon pointCount] - 1)].x, polygon.points[([polygon pointCount] - 1)].y,
                    polygon.points[0].x, polygon.points[0].y,
                };
                
                glVertexPointer(2, GL_FLOAT, 0, lineEnd);
                glEnableClientState(GL_VERTEX_ARRAY);
                glDrawArrays(GL_LINES, 0, 2);
                
                glPopMatrix();
            }
        }
    }
}

@end
